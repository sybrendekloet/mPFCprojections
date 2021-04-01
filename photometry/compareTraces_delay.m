function [win_store_kt, win_store_dt, win_store_pt] = compareTraces_delay(data_in, meta_in)

% a) Bootstrap to baseline
data_in_boot = cell(4,4); %bootstrap input array
combs_resp = [1 3; 1 4; 3 4]; % combinations for permutation test
combs_pop = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4]; % combinations for permutation test
perm_out = cell(1,4); %permutation test for trial outcome array
perm_pop = cell(1,4); %permutation test for population array
f1 = figure;
f2 = figure;
set(f1, 'renderer', 'painters')
set(f2, 'renderer', 'painters')


data_pop = data_in{1};
meta_pop = meta_in;


for g = 1:max(unique(meta_pop(:,1)))
    
    for o = [1 3 4]
        
        % Categorize all data per rat
        for r =1:numel(unique(meta_pop(meta_pop(:,1)==g,2)))
            ratno = unique(meta_pop(meta_pop(:,1)==g,2));
            ratId = ratno(r);            
            
            % distinguish between response types, iti, rat, etc.
            if o == 4 % Filter prematures
            cfj = (meta_pop(:,1)==g & meta_pop(:,2)==ratId & meta_pop(:,3)==1 &...
                meta_pop(:,5)==o & meta_pop(:,6)==3 & (meta_pop(:,end-1)-meta_pop(:,end-2))>7.5);
            else
            cfj = (meta_pop(:,1)==g & meta_pop(:,2)==ratId & meta_pop(:,3)==1 &...
                meta_pop(:,5)==o & meta_pop(:,6)==3);
            end
            data_tests = data_pop(cfj,:);
            
            % get baseline per rat
            %             bm_mean = mean(data_in{1}(cfj,1:ceil(4*15.89)),'all');
            %             bm_std= std(data_in{1}(cfj,1:ceil(4*15.89)),0,'all');
            %             tmp_mean = mean((data_in{1}(cfj,:)-bm_mean)./bm_std);
            
            %             tmp_mean = mean((data_in{1}(cfj,:)-mean(data_in{1}(cfj,1:ceil(3*15.89)),2))./...
            %                 std(data_in{1}(cfj,1:ceil(3*15.89)),[],2));
            
            tmp_mean = nanmean(data_tests);
            
            % bin data
            bin_w = 3;
            [~,~,idx] = histcounts(1:numel(tmp_mean),1:bin_w:numel(tmp_mean));
            tmp_mean(idx==0)=[]; idx(idx==0)=[];
            data_in_boot{g,o}(r,:) = accumarray(idx(:),tmp_mean,[],@nanmean);

        end
        
        % Plot means for each outcome
        figure(f1)
        subplot(4,4,(g-1)*4+o)
        imagesc(data_in_boot{g,o})
%         xlim([0 66])
        caxis([-2 2])
        colormap(flipud(brewermap([],'RdBu')))
        if g==4 && o ==4
            colorbar
        end
%         colormap(jet)
        
        figure(f2)
        subplot(2,4,g)
%         xlim([0 66])
        plot(movmean(mean(data_in_boot{g,o}),3), 'color','k','linewidth',2)
         hold on
        
        % Bootstrap test for each rat
        sig = 0.0001; %bootstrap significance level
        fit_boots = 1; %bootstrap fit parameter
        num_boots = 5000; %number of bootstrap iterations
        data_bootstrap_analysis = data_in_boot{g,o}(:,ceil(3*15.89/3):ceil(17.5*15.89/3));
        
        ci = bootci(num_boots,{@mean,data_bootstrap_analysis},'alpha',sig);
%         bootfun = @(x) mean(x)./sqrt(sum(x.^2));
%         kci = bootci(num_boots,{bootfun,data_bootstrap_analysis},'alpha',sig);

        % mean + sem shaded
        plotmean = mean(data_in_boot{g,o});
        
        jbfill(1:size(movmean(plotmean,3),2),...
            movmean(plotmean,3)+movmean(std(data_in_boot{g,o},[],1),3)./sqrt(size(data_in_boot{g,o},1)),...
            movmean(plotmean,3)-movmean(std(data_in_boot{g,o},[],1),3)./sqrt(size(data_in_boot{g,o},1)),...
            color_scheme(o),color_scheme(o),1,0.25);
        hold on
        
        % Plot bootstrap windows > 0
        kt_frames = 16:16+size(ci,2);
        kt_frames(ci(1,:)<=0)=nan;

        plot(kt_frames, 2.5+o*0.06*ones(1,length(kt_frames)), 'color', color_scheme(o),'linewidth',2)
        win_store_kt{o}(g,:)=kt_frames/(15.89/3);
        
        subplot(2,4,o+4)
        % plot comparison between populations
        plot(movmean(mean(data_in_boot{g,o}),3), 'color','k','linewidth',2)
        hold on

        % sem shaded
        jbfill(1:size(movmean(plotmean,3),2),...
            movmean(plotmean,3)+movmean(std(data_in_boot{g,o},[],1),3)./sqrt(size(data_in_boot{g,o},1)),...
            movmean(plotmean,3)-movmean(std(data_in_boot{g,o},[],1),3)./sqrt(size(data_in_boot{g,o},1)),...
            color_scheme(g),color_scheme(g),1,0.25);
         hold on
       
    end
    
    % Permutation and bootstrap test between outcomes
    % in: data_in_boot{g,o}
        sig = 0.01; %bootstrap significance level
    for c=1:size(combs_resp,1)
        subplot(2,4,g)
        % Permutation tests
        [perm_out{g}(c,:), ~]=permTest_array(data_in_boot{g,combs_resp(c,1)}(:,ceil(5*15.89/3:12.5*15.89/3)),...
            data_in_boot{g,combs_resp(c,2)}(:,ceil(5*15.89/3:12.5*15.89/3)), 1000);
        
        % Bootstrap difference between outcomes
        boot_diff_in = data_in_boot{g,combs_resp(c,1)}(:,ceil(5*15.89/3:12.5*15.89/3))-...
            data_in_boot{g,combs_resp(c,2)}(:,ceil(5*15.89/3:12.5*15.89/3));
        
        ci2 = bootci(num_boots,{@mean,boot_diff_in},'alpha',sig);
        dt_frames = ceil(1:8*15.89/3);
        dt_frames(ci2(1,:)<=0)=nan;
                
        plot(dt_frames, 4+c*0.12*ones(1,length(dt_frames)), 'color', color_scheme(combs_resp(c,1)),'linewidth',2)
        plot(dt_frames, 4.03+c*0.12*ones(1,length(dt_frames)), 'color', color_scheme(combs_resp(c,2)),'linewidth',2)
        win_store_dt{o}(c,:) = dt_frames/(15.89/3);
        
    end

    if g == 4
        for o = 1:4
            % Permutation test between populations
            for c=1:size(combs_pop,1)
                subplot(2,4,o+4)
                try
                    [perm_pop{o}(c,:), ~]=permTest_array(data_in_boot{combs_pop(c,1),o}(:,ceil(5*15.89/3:12.5*15.89/3)),...
                        data_in_boot{combs_pop(c,2),o}(:,ceil(5*15.89/3:12.5*15.89/3)), 3000);
                    
                    ptp_frames = ceil(5*15.89/3:12.5*15.89/3);
                    ptp_frames(perm_pop{o}(c,:)>=0.05)=nan;
                    plot(ptp_frames, 3.5+c*0.12*ones(1,length(ptp_frames)), 'color', color_scheme(combs_pop(c,1)),'linewidth',2)
                    plot(ptp_frames, 3.53+c*0.12*ones(1,length(ptp_frames)), 'color', color_scheme(combs_pop(c,2)),'linewidth',2)
                    win_store_pt{o}(c,:)=ptp_frames/(15.89/3);
                end
            end
        end
    end

    
end

end