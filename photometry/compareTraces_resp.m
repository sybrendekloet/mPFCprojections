function [kt_frames, dt_frames, ptp_frames] = compareTraces_resp(data_in, meta_in)

%% Population activity AROUND RESPONSE
% Is population active during task and does it respond to changing task
% parameters?
%
% 1      2    3     4     5     6        7           8
% group, rat, cond, sess, resp, subspec, lower norm, upper norm
% 9
% a) Bootstrap to baseline
data_in_boot_rsp = cell(4,4); %bootstrap input array
combs_resp = [1 3; 1 4; 3 4]; % combinations for permutation test
combs_pop = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4]; % combinations for permutation test
combs_rsp = [1 3]; % combinations for permutation test
perm_out_resp = cell(1,4); %permutation test for trial outcome array
perm_pop_resp = cell(1,4); %permutation test for population array
f5 = figure;
f6 = figure;
set(f5, 'renderer', 'painters')
set(f6, 'renderer', 'painters')

% Ztransform the data (on single trial lvl)
% baseline window = -4s : -2s
% bwin = [ceil(1*15.89)^0, ceil(4*15.89)];
% data_rsp = (data_in{1}-mean(data_in{1}(:,bwin(1):bwin(2)),2))./...
%     std(data_in{1}(:,bwin(1):bwin(2)),[],2);
% 
% % Only trials that show deviation from BL
% data_in_rsp_z = data_rsp(sum(data_in_z>2,2)>10,:);
% meta_in_act_rsp_z = meta_in(sum(data_in_z>2,2)>10,:);
% % Sync win == -3: 5 around response

data_rsp = data_in{2};
meta_rsp = meta_in;

for g = 1:max(unique(meta_rsp(:,1)))
    
    for o = [1 3 4]
        
        % Categorize all data per rat
        for r =1:numel(unique(meta_rsp(meta_rsp(:,1)==g,2)))
            ratno = unique(meta_rsp(meta_rsp(:,1)==g,2));
            ratId = ratno(r);
            
            % distinguish between response types, iti, rat, etc.
            cfj = (meta_rsp(:,1)==g & meta_rsp(:,2)==ratId & meta_rsp(:,3)==1 &...
                meta_rsp(:,5)==o & meta_rsp(:,6)==3);
            data_tests = data_rsp(cfj,:);
            
            % get baseline per rat
            %             bm_mean = mean(data_in{1}(cfj,1:ceil(4*15.89)),'all');
            %             bm_std= std(data_in{1}(cfj,1:ceil(4*15.89)),0,'all');
            %             tmp_mean = mean((data_in{1}(cfj,:)-bm_mean)./bm_std);
            
            %             tmp_mean = mean((data_in{1}(cfj,:)-mean(data_in{1}(cfj,1:ceil(3*15.89)),2))./...
            %                 std(data_in{1}(cfj,1:ceil(3*15.89)),[],2));
            
            tmp_mean = mean(data_tests);
            
            % bin data
            bin_w = 3;
            [~,~,idx] = histcounts(1:numel(tmp_mean),1:bin_w:numel(tmp_mean));
            tmp_mean(idx==0)=[]; idx(idx==0)=[];
            data_in_boot_rsp{g,o}(r,:) = accumarray(idx(:),tmp_mean,[],@mean);

        end
        
        % Plot means for each outcome
        figure(f5)
        subplot(4,4,(g-1)*4+o)
        imagesc(data_in_boot_rsp{g,o})
        xlim([0 42])
        caxis([-2 2])
        colormap(flipud(brewermap([],'RdBu')))
            line([16 16], get(gca,'ylim'), 'color', 'k')
        if g==4 
            if o ==4
            colorbar
            end
        end
%         colormap(jet)
        
        figure(f6)
        subplot(2,4,g)
        xlim([0 42])
        plot(movmean(mean(data_in_boot_rsp{g,o}),3), 'color','k','linewidth',2)
         hold on
        
        % Bootstrap test for each rat
        sig = 0.0005; %bootstrap significance level
        fit_boots = 1; %bootstrap fit parameter
        num_boots = 5000; %number of bootstrap iterations
        data_bootstrap_analysis = data_in_boot_rsp{g,o};
        
        ci = bootci(num_boots,{@mean,data_bootstrap_analysis},'alpha',sig);
%         bootfun = @(x) mean(x)./sqrt(sum(x.^2));
%         kci = bootci(num_boots,{bootfun,data_bootstrap_analysis},'alpha',sig);
                
        % bootstrap window shaded
        plotmean = mean(data_in_boot_rsp{g,o});

        % sem shaded
        jbfill(1:size(movmean(plotmean,3),2),...
            movmean(plotmean,3)+movmean(std(data_in_boot_rsp{g,o},[],1),3)./sqrt(size(data_in_boot_rsp{g,o},1)),...
            movmean(plotmean,3)-movmean(std(data_in_boot_rsp{g,o},[],1),3)./sqrt(size(data_in_boot_rsp{g,o},1)),...
            col_resp(o),col_resp(o),1,0.25);
        hold on
            line([16 16], [-2 4.5], 'color', 'k')
        
        % Plot bootstrap windows > 0
        kt_frames = 1:size(ci,2);
        kt_frames(ci(1,:)<=0)=nan;

        plot(kt_frames, 2.5+o*0.06*ones(1,length(kt_frames)), 'color', col_resp(o),'linewidth',2)
        
        subplot(2,4,o+4)
        xlim([0 42])
        % plot comparison between populations
        plot(movmean(mean(data_in_boot_rsp{g,o}),3), 'color','k','linewidth',2)
        hold on
            line([16 16], [-2 4.5],'color',  'k')

            % sem shaded
        jbfill(1:size(movmean(plotmean,3),2),...
            movmean(plotmean,3)+movmean(std(data_in_boot_rsp{g,o},[],1),3)./sqrt(size(data_in_boot_rsp{g,o},1)),...
            movmean(plotmean,3)-movmean(std(data_in_boot_rsp{g,o},[],1),3)./sqrt(size(data_in_boot_rsp{g,o},1)),...
            color_scheme(g),color_scheme(g),1,0.25);
         hold on
       
    end
    
    % Permutation and bootstrap test between outcomes
    % in: data_in_boot{g,o}
    for c=1:size(combs_rsp,1)
        subplot(2,4,g)
        % Permutation tests
        [perm_out_resp{g}(c,:), ~]=permTest_array(data_in_boot_rsp{g,combs_rsp(c,1)},...
            data_in_boot_rsp{g,combs_rsp(c,2)}, 1000);
        
        % Bootstrap difference between outcomes
        boot_diff_in = data_in_boot_rsp{g,combs_rsp(c,1)}-...
            data_in_boot_rsp{g,combs_rsp(c,2)};
        
        ci2 = bootci(num_boots,{@mean,boot_diff_in},'alpha',sig);
        dt_frames = ceil(1:8*15.89/3);
        dt_frames(ci2(1,:)<=0)=nan;
        
        plot(dt_frames, 4+c*0.12*ones(1,length(dt_frames)), 'color', col_resp(combs_rsp(c,1)),'linewidth',2)
        plot(dt_frames, 4.03+c*0.12*ones(1,length(dt_frames)), 'color', col_resp(combs_rsp(c,2)),'linewidth',2)
        
    end

    if g == 4
        for o = 1:4
            % Permutation test between populations
            for c=1:size(combs_pop,1)
                subplot(2,4,o+4)
                try
                    [perm_pop_resp{o}(c,:), ~]=permTest_array(data_in_boot_rsp{combs_pop(c,1),o},...
                        data_in_boot_rsp{combs_pop(c,2),o}, 3000);
                    
                    ptp_frames = ceil(1:8*15.89/3);
                    ptp_frames(perm_pop_resp{o}(c,:)>=0.05)=nan;
                    plot(ptp_frames, 3.5+c*0.12*ones(1,length(ptp_frames)), 'color', color_scheme(combs_pop(c,1)),'linewidth',2)
                    plot(ptp_frames, 3.53+c*0.12*ones(1,length(ptp_frames)), 'color', color_scheme(combs_pop(c,2)),'linewidth',2)
                end
            end
        end
    end

    
end
