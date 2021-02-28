function [bootsCI, ...
          kdata, kbootsCI, ...
          kfit_loo, boot_kfit_loo, ...
          kfit_norm_loo, boot_kfit_loo_norm] = ...
   bootstrap_data_v201(data,num_boots,fit_boots,sig)

%%Bootstraps data via kernels (kdata+fits from embedded kernel_CC function). 
% If fig_title not empty (i.e. []), plots kernel+bootstraps according to meta and sig - 
% "Trials" if subj_names empty (enter subj names if plotting kernel of subj_means)

%%Output:
% data_boots = LCI+UCI vector

% kdata = kernel (i.e. normalised response)
% kboots =  bootstrap matrix of kernel (shuffled trial kernel x number_boots)

% kfit_loo = fit of data trials on kernel (leave-one-out basis)
% boot_kfit_loo = bootstrap vector of fits (fits on shuffled kernels (leave-one-out))

% kfit_norm_loo = fit of normalised data trials on kernel (leave-one-out basis)
% boot_kfit_loo_norm = bootstrap of normalised fits (norm fits on shuffled kernels (leave-one-out))

num_trials = size(data,1);
window = size(data,2);

% Minimum 2 trials (otherwise get funky signals due to inevitable crossing oscillations)
if num_trials > 2
   
   % calculate kernel across all trials and fits (and normalized fits) on actual data using leave-one-out
   [~,kdata,kfit_loo,~,kfit_norm_loo] = kernel_CC(data);

   % Prep bootstrapping variables (one row for each bootstrap) ...
   data_boots = zeros(num_boots, window);
   bootsCI = zeros(2,window);
   
   kboots = zeros(num_boots, window);
   kbootsCI = zeros(2,window);
   
   if fit_boots == 1
      boot_kfit_loo = zeros(num_boots, num_trials);
      boot_kfit_loo_norm = zeros(num_boots, num_trials);
   end

   for b = 1:num_boots
      % bootstrap data + kernel across all trials ...
      trial_array = ceil((num_trials).*rand(1,num_trials));
      data_boots(b,:) = mean(data(trial_array,:));
      kboots(b,:) = data_boots(b,:)./sqrt(sum(data_boots(b,:).^2));

      % calculate kernels and fits on leave-one-out basis (as per kernel_CC)
      if fit_boots == 1
         tmp_kdata_loo = zeros(num_trials,window);
         for t = 1:num_trials
            trial_array = ceil((num_trials-1).*rand(1,num_trials-1)); % sample from trials randomly with replacement
            trial_array(trial_array==t) = num_trials;
            tmp_mean = mean(data(trial_array,:));
            tmp_kdata_loo(t,:) = tmp_mean./sqrt(sum(tmp_mean.^2));

            boot_kfit_loo(b,t) = data(t,:)*tmp_kdata_loo(t,:)';
            boot_kfit_loo_norm(b,t) = (data(t,:)*tmp_kdata_loo(t,:)')./sqrt(sum(data(t,:).^2));
         end
      end
   end
   
   %% Calculate bootstrap CI
   data_boots = sort(data_boots,1);
   kboots = sort(kboots,1);

   lower_conf_index = ceil(num_boots*(sig/2))+1;
   upper_conf_index = floor(num_boots*(1-sig/2));

   bootsCI(1,:) = data_boots(lower_conf_index,:);
   bootsCI(2,:) = data_boots(upper_conf_index,:);
   kbootsCI(1,:) = kboots(lower_conf_index,:);
   kbootsCI(2,:) = kboots(upper_conf_index,:);
%    
%    if plot_boot == 1
%       
%       if exist('boot_kfit_loo','var') ~= 1
%          boot_kfit_loo = [];
%       end
%       if exist('boot_kfit_loo_norm','var') ~= 1
%          boot_kfit_loo_norm = [];
%       end
%       
% %       bootstrap_plot2(data, num_boots, bootsCI,...
%                    kfit_loo, boot_kfit_loo,...
%                    kfit_norm_loo, boot_kfit_loo_norm,...
%                    fig_title,meta,sig,consec_thresh,rat_IDs);
%    end

else
   fprintf('Less than 3 trials - bootstrapping skipped\n');
   bootsCI = NaN;
   kdata = NaN;
   kbootsCI = NaN;
   kfit_loo = NaN;
   boot_kfit_loo = NaN;
   kfit_norm_loo = NaN;
   boot_kfit_loo_norm = NaN;
end
           
%% plot
% ts = (1:size(data,2))/15.89-3;
% plot(ts,mean(data), 'LineWidth', 2)
% hold on
% jbfill(ts, bootsCI(1,:), bootsCI(2,:), 'b', 'b');
% line([ts(1) ts(end)], [0 0], 'LineStyle', '--', 'Color', 'k');
% ylinemin = 1.2*max(bootsCI(2,:));
% ylinemax = 1.3*max(bootsCI(2,:));
% hold on
% plot(ts(bootsCI(2,:)<0), ylinemin*ones(size(ts(bootsCI(2,:)<0),2)), 's', 'MarkerSize', 7, 'MarkerFaceColor','b','Color', 'b')
% plot(ts(bootsCI(1,:)>0), ylinemax*ones(size(ts(bootsCI(1,:)>0),2)), 's', 'MarkerSize', 7, 'MarkerFaceColor','k','Color', 'k')
% yl =get(gca, 'YLim');
% line([0 0], [yl(1) yl(2)], 'Color', 'm', 'LineWidth', 2)
% xlim([ts(1) ts(end)])


% alternative bootstrap - do kernel and fits all together but kernel can include same trials type (as sampling wih replacement)
% for b = 1:num_boots
%     trial_array = ceil(num_trials.*rand(1,num_trials)); % sample from trials randomly with replacement
%     tmp_kdata_loo = zeros(size(data));
%     
%     % calculate kernels and fits on leave-one-out basis (as per kernel_CC)
%     t_index = 1:num_trials;
%     for t = 1:num_trials
%         not_t = t_index(t_index~=t);
%         tmp_mean = mean(data(trial_array(not_t),:));
%         tmp_kdata_loo(t,:) = tmp_mean./sqrt(sum(tmp_mean.^2));
%         
%         boot_kfit_loo(b,t) = data(t,:)*tmp_kdata_loo(t,:)';
%         boot_kfit_loo_norm(b,t) = (data(t,:)*tmp_kdata_loo(t,:)')./sqrt(sum(data(t,:).^2));
%     end
%     boot_kernels(b,:) = mean(tmp_kdata_loo); % calculate mean kernel across trials for each boot
% end
