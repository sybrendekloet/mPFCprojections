function [test_out,test_stats_pop,final_out] = signalParameters(data_in, meta_in)

win1 = ceil(5*1017.3/64);
win2 = ceil(17.5*1017.3/64);

% variables
test_out = struct; % for test variables
dist_out = struct; % for distributions
test_stats_pop = struct; % for test statistics
test_stats_out = struct; % for test statistics

    % rtb_baseline =nan(8,4);rts_baseline =nan(8,4);rtm_baseline =nan(8,4);
% v_amp_rat =nan(8,4); t50_all =nan(8,4); tdev2_all=nan(8,4);tdev3_all=nan(8,4);
% devp_auc_pt_in=nan(8,4);devp_auc50=nan(8,4); dev_auc_pt_in=nan(8,4);dev_auc50=nan(8,4);
% peakmax= nan(8,4);peakmax_m= nan(8,4);
% peakn = nan(8,4);peakn_m= nan(8,4);
% peak1= nan(8,4);peak1_m= nan(8,4); peak_max_m_t=nan(8,4);slope_to_peak1=nan(8,4);

%arrays
distr_rt = cell(1,4); distr_max = cell(1,4); dev_auc_cum_pt_in=cell(1,4);
devp_auc_cum_pt_in=cell(1,4);

% input values
testlist = {}; t_id = 1;
% set(0,'DefaultFigureVisible','off')
slope_win = ceil(6*1017.3/64);
mps = 0.2; 
test_type = 'lsd';
out_comp = [1 3 4];
gsize = [8 4 7 6];
outcomes = {'Correct' 'Incorrect' 'Omission' 'Premature'};
plot_lims = [-0.25 0.75; 0 5*15.89; 0 10*15.89; 0 12];
final_out=cell(4,4);
% figures
% f1 = figure('visible', 'off');
% f2 = figure('visible', 'off');
% f3 = figure('visible','off');
% f4 = figure('visible','off');
for o = out_comp
k =1;
    for g = 1:max(unique(meta_in(:,1)))
        for r =1:numel(unique(meta_in(meta_in(:,1)==g,2)))
            ratno = unique(meta_in(meta_in(:,1)==g,2));
            ratId = ratno(r);
            
            % distinguish between response types, iti, rat, etc.
            cfi = (meta_in(:,1)==g & meta_in(:,2)==ratId & meta_in(:,3)==1 &...
                meta_in(:,5)==o & meta_in(:,6)==3);
            
            if sum(cfi)==0
                continue
            end
            % Alternative baseline
            %         bm_mean = mean(data_in{1}{1}(cfi,ceil(15.89):ceil(3*15.89)),'all');
            %         bm_std= std(data_in{1}{1}(cfi,ceil(15.89):ceil(3*15.89)),0,'all');
            %         data_in{1}_bm = (data_in{1}{1}(cfi,:)-bm_mean)./bm_std;
            %
            %% Select input data
            data_tests = data_in{1}(cfi,:);
            
            % Baseline Std
            %         data_tests_bstd = std(data_tests(:,bwin(1):bwin(2)),[],2);
            
            %% Activation speed
            % only trials >2 std above baseline
            data_bl = data_tests(:,win1:win2);
            validtr=mean(data_bl>2,2)>0.1; % only trials that reach above baseline
            
            % rt from baseline
            r_up = 80;
            r_down = 20;
            [~,rtb10] = max(data_bl(validtr,:)>prctile(data_bl(validtr,:),r_down,2),[],2);
            [~,rtb90] = max(data_bl(validtr,:)>prctile(data_bl(validtr,:),r_up,2),[],2);
            rtb_10_90 = rtb90-rtb10;
            
            test_out(o).rtb_baseline(r,g) = median(rtb_10_90(rtb_10_90>5));
            
            % rt from trial start
            data_rts = data_tests(:,win1:win2);
            data_rts_start = data_rts - data_rts(:,1);
            [~,rts10] = max(data_rts_start>prctile(data_rts_start,r_down,2),[],2);
            [~,rts90] = max(data_rts_start>prctile(data_rts_start,r_up,2),[],2);
            rts_10_90 = rts90-rts10;
            test_out(o).rts_baseline(r,g) = median(rts_10_90(rts_10_90>5));
            
            % rt based on mean signal
            mean_rat_trace = mean(data_rts);
            [~,test_out(o).rtm_baseline(r,g)] = max(mean_rat_trace>prctile(mean_rat_trace,r_up,2),[],2);
            
%             bE = 1:4:win2-win1;
%             distr_f2 = discretize(rts_10_90,bE);
%             disca2 = histogram(distr_f2,numel(bE),'normalization', 'cdf', 'facecolor', col_rep(g));
%             xlim([0 numel(bE)])
%             distr_rt{g}(r,:) = disca2.Values;
            
            % proportion of max within first 1,2,3,5 sec
%             t_amp = 2; % window value
            v_amp1 = data_rts(:,ceil(1*15.89))./max(data_rts,[],2);
            v_amp2 = data_rts(:,ceil(2*15.89))./max(data_rts,[],2);
            v_amp3 = data_rts(:,ceil(3*15.89))./max(data_rts,[],2);
            v_amp5 = data_rts(:,ceil(5*15.89))./max(data_rts,[],2);
            test_out(o).v_amp_1(r,g) = median(v_amp1);
            test_out(o).v_amp_2(r,g) = median(v_amp2);
            test_out(o).v_amp_3(r,g) = median(v_amp3);
            test_out(o).v_amp_5(r,g) = median(v_amp5);
            
%             test_out(o).v_amp_1(r,g) = mean_rat_trace(ceil(1*15.89))./max(mean_rat_trace,[],2);
%             test_out(o).v_amp_2(r,g) = mean_rat_trace(ceil(2*15.89))./max(mean_rat_trace,[],2);
%             test_out(o).v_amp_3(r,g) = mean_rat_trace(ceil(3*15.89))./max(mean_rat_trace,[],2);
%             test_out(o).v_amp_5(r,g) = mean_rat_trace(ceil(5*15.89))./max(mean_rat_trace,[],2);
%             
            % time it takes to reach 50%-70%-90% of max.
            adj_data_rise_time = data_rts;
            [~,t_50] = max(adj_data_rise_time>(max(adj_data_rise_time,[],2)*0.5),[],2);
            [~,t_70] = max(adj_data_rise_time>(max(adj_data_rise_time,[],2)*0.7),[],2);
            [~,t_90] = max(adj_data_rise_time>(max(adj_data_rise_time,[],2)*0.9),[],2);
            test_out(o).t50_all(r,g) = median(t_50(t_50>5));
            test_out(o).t70_all(r,g) = median(t_70(t_90>5));
            test_out(o).t90_all(r,g) = median(t_70(t_90>5));
            
%             adj_data_rise_time = data_rts;
%             [~,t_50] = max(mean_rat_trace>(max(mean_rat_trace,[],2)*0.5),[],2);
%             [~,t_70] = max(mean_rat_trace>(max(mean_rat_trace,[],2)*0.7),[],2);
%             [~,t_90] = max(mean_rat_trace>(max(mean_rat_trace,[],2)*0.9),[],2);
%             [~,test_out(o).t50_all(r,g)] = max(mean_rat_trace>(max(mean_rat_trace,[],2)*0.5));
%             [~,test_out(o).t70_all(r,g)] = max(mean_rat_trace>(max(mean_rat_trace,[],2)*0.7));
%             [~,test_out(o).t90_all(r,g)] = max(mean_rat_trace>(max(mean_rat_trace,[],2)*0.9));
            
            %% Bulk activation (only activation)
            data_auc = data_tests(:,win1:win2);
            
            % time spent >2std, 3std away from baseline
%             tdev2 = sum(abs(data_auc)>2,2);
            tdev2 = sum(data_auc>2,2);
            tdev3 = sum(data_auc>3,2);
            
            test_out(o).tdev2_all(r,g) = mean(tdev2);
            test_out(o).tdev3_all(r,g) = mean(tdev3);
            
            % deviation from baseline (i.e. information content)
            devp_auc = trapz(data_auc,2);
            test_out(o).devp_auc_pt_in(r,g) = median(devp_auc); % storage var
            
            % cumulative
            devp_auc_cum = cumtrapz(data_auc,2);
            devp_auc_cum_frame = devp_auc_cum./devp_auc_cum(:,end); % proportion of information per frame
            devp_auc_cum_pt_in{g}(r,:) = median(devp_auc_cum); % storage var
            
            % 50% of total deviation
            [~,aucp50] = max(devp_auc_cum_frame>0.5,[],2); % time until 50% of deviation from baseline
            test_out(o).devp_auc50(r,g) = median(aucp50); % storage var
            
            
            %% Bulk activation (both activation and inhibition)
            data_auc = data_tests(:,win1:win2);
            
            % deviation from baseline (i.e. information content)
            dev_auc = abs(trapz(data_auc,2));
            test_out(o).dev_auc_pt_in(r,g) = median(dev_auc); % storage var
            
            % cumulative
            dev_auc_cum = cumtrapz(abs(data_auc),2);
            dev_auc_cum_frame = dev_auc_cum./dev_auc_cum(:,end); % proportion of information per frame
            dev_auc_cum_pt_in{g}(r,:) = median(dev_auc_cum); % storage var
            
            % 50% of total deviation
            [~,auc50] = max(dev_auc_cum_frame>0.5,[],2); % time until 50% of deviation from baseline
            test_out(o).dev_auc50(r,g) = median(auc50); % storage var
            
            %% Slope and peaks
            % Individual trial level
            peakmax_tmp = nan(1,size(data_tests,1));
            peakn_tmp = nan(1,size(data_tests,1));
            peak1_tmp = nan(1,size(data_tests,1));
            for tr = 1:size(data_tests,1)
                % Find maximum peak
                %             [peak_amp,peak_t,~,peak_p] = findpeaks(data_tests(tr,win1:win2),...
                %                 'MinPeakProminence',mpp*(max(data_tests(tr,win1:win2)-min(data_tests(tr,win1:win2)))),...
                %                 'MaxPeakWidth',mpw);
                [peak_amp,peak_t] = findpeaks(data_tests(tr,win1:win2));
                [vall_amp,vall_t] = findpeaks(-data_tests(tr,win1:win2));
                peak_tmp = sortrows([[peak_t';vall_t'],[peak_amp';-1*(vall_amp)']],1);
                if peak_t(1)<vall_t(1)
                    peak_mat = peak_tmp(diff([0;peak_tmp(:,2)])>mps*(max(data_tests(tr,win1:win2)-min(data_tests(tr,win1:win2)))),:);
                else
                    peak_mat = peak_tmp(diff([nan(1,1);peak_tmp(:,2)])>mps*(max(data_tests(tr,win1:win2)-min(data_tests(tr,win1:win2)))),:);
                end
                validpeaks = peak_mat(peak_mat(:,2)>2,:);
                
                if ~isempty(validpeaks)
                    peakmax_tmp(tr) = max(validpeaks(:,2));
                    
                    % Find number of peaks
                    peakn_tmp(tr) = size(validpeaks,1);
                    
                    % Find time of first peak
                    peak1_tmp(tr) = validpeaks(1,1);
                    
                end
            end
            
            % Take mean of each value
            test_out(o).peakmax(r,g) = nanmean(peakmax_tmp);
            test_out(o).peakn(r,g) = nanmean(peakn_tmp);
            test_out(o).peak1(r,g) = nanmean(peak1_tmp);
            
            % alt peakmax
            test_out(o).altpeakmax(r,g)=mean(max(data_tests,[],2));
            
            % Mean values of rats
            data_tests_mean = mean(data_tests(:,win1:win2));
            [peak_amp_m,peak_t_m] = findpeaks(data_tests_mean);
            [vall_amp_m,vall_t_m] = findpeaks(-data_tests_mean);
            peak_m_tmp = sortrows([[peak_t_m';vall_t_m'],[peak_amp_m';-1*(vall_amp_m)']],1);
            if peak_t_m(1)<vall_t_m(1)
                peak_m_mat = peak_m_tmp(diff([0;peak_m_tmp(:,2)])>mps*(max(data_tests_mean)-min(data_tests_mean)),:);
            else
                peak_m_mat = peak_m_tmp(diff([nan(1,1);peak_m_tmp(:,2)])>mps*(max(data_tests_mean)-min(data_tests_mean)),:);
            end
            validpeaks = peak_m_mat(peak_m_mat(:,2)>1,:);
            if ~isempty(validpeaks)
                [test_out(o).peakmax_m(r,g), pmt] = max(validpeaks(:,2));
                test_out(o).peak_max_m_t(r,g) = validpeaks(pmt,1);
                test_out(o).peakn_m(r,g) = size(validpeaks,1);
                test_out(o).peak1_m(r,g) = validpeaks(1,1);
                test_out(o).slope_to_peak1(r,g) = validpeaks(1,2)-data_tests_mean(1);
            end
            
            % Slope
            
            % sliding window of 1s for variance
            dist_out(o).var_1s{g}(r,:) = movvar(data_tests_mean,16);
            dist_out(o).mad_1s{g}(r,:) = movmad(data_tests_mean,16); 
            
            [test_out(o).max_var(r,g), test_out(o).t_var(r,g)] = max(dist_out(o).var_1s{g}(r,:),[],2);
            [test_out(o).max_mad(r,g), test_out(o).t_mad(r,g)] = max(dist_out(o).mad_1s{g}(r,:),[],2);
            
        end
    end
    
    test_fields = fieldnames(test_out);
%     sub_x = ceil(sqrt(numel(test_fields)));
%     sub_y = ceil(sqrt(numel(test_fields)));

    %% Tests between populations
%     figure;
%     plot_in = cell(1,1); med_in = cell(1,1);
%     pid = 0;
    test_fields = {'v_amp_1'; 'peak1';'tdev2_all'; 'peakmax'};

    for idx = 1:size(test_fields,1)
%         subplot(sub_x, sub_y, idx)
        % Remove 0s from data
        testdata_in{1} = test_out(o).(test_fields{idx});
        testdata_in{1}(testdata_in{1}==0)=nan;
        
        [P,T,STATS] = kruskalwallis(testdata_in{1},[],'off');
        
        if P<0.05
            [MCT,VALS]=multcompare(STATS, 'CType', test_type ,'display','off');
                        
            E2 = T{2,5}/((sum(STATS.n)^2-1)/(sum(STATS.n)+1));
            ETA2 = (T{2,5}-numel(STATS.n)+1)/(sum(STATS.n)-numel(STATS.n));
            test_stats_pop(o).(test_fields{idx}).P = P;
            test_stats_pop(o).(test_fields{idx}).T = T;
            test_stats_pop(o).(test_fields{idx}).STATS = STATS;
            test_stats_pop(o).(test_fields{idx}).MCT = MCT;
            test_stats_pop(o).(test_fields{idx}).VALS = VALS;
            test_stats_pop(o).(test_fields{idx}).EPSI2 = E2;
            test_stats_pop(o).(test_fields{idx}).ETA2 = ETA2;
            final_out{o}(:,idx)=MCT(:,end);
        end
        k = k+1;
       
%         pid=pid+1;
%         x_in = repmat(1:4,size(testdata_in{1},1),1);
%         x_in(isnan(testdata_in{1}))=nan;
%         plot_in{pid}=[x_in(:),testdata_in{1}(:)];
%         med_in{pid}=nanmedian(testdata_in{1});
%         id_no(pid)=idx;

    end
    
    % Plots
%     for plotn = 1:pid
%        subplot(ceil(sqrt(pid)), round(sqrt(pid)), plotn)
%        try
%        beeswarm(plot_in{plotn}(:,1), plot_in{plotn}(:,2),...
%            'dot_size', 0.67, 'overlay_style','box');
%        end
%        hold on
% %        plot(1:4,med_in{plotn},'vk', 'markersize',4, 'markerfacecolor', [0 0 0]);
%        title(test_fields{id_no(plotn)})
%        ylim([plot_lims(plotn,:)])
%        xlim([-3.5 8.5])
%     end
%     supertitle([outcomes{o} newline ])

end

end
