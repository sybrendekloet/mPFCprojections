function [kdata_loo,kdata,kfit_loo,kfit,kfit_norm_loo] = kernel_CC(data)
%Modified from kernel_CC by PhilJRDB

% calculate kernel across all trials
mean_resp = mean(data,1);
kdata = mean_resp./sqrt(sum(mean_resp.^2));

% calculate fit based on single kernel (slightly circular => upwards bias)
kfit = kdata*data'; % CC changed from column to row vector

% calculate kernels and fits on leave-one-out basis
num_trials = size(data,1);

if num_trials > 1
   t_index = 1:num_trials;
   kdata_loo = zeros(size(data));

	for t = 1:num_trials
      not_t = t_index(t_index~=t);
      tmp_mean = mean(data(not_t,:));
      kdata_loo(t,:) = tmp_mean./sqrt(sum(tmp_mean.^2));

      kfit_loo(t) = data(t,:)*kdata_loo(t,:)';

      kfit_norm_loo(t) = data(t,:)*kdata_loo(t,:)'./sqrt(sum(data(t,:).^2));
   end
else
   fprintf('Only 1 or 2 trial - leave-one-out kernel not calculated\n');
   kdata_loo = NaN;
   kfit_loo = NaN;
   kfit_norm_loo = NaN;
end

%---------
% Plotting stuff here ...
% 
% % plot all leave-one-out kernels
% figure
% plot(kdata_loo')
% xlim([1 size(data,2)]);
% 
% % plot unbiased and biased measures of kfit
% figure
% subplot 121
% plot(1:num_trials,kfit,'bs-')
% hold on
% plot(1:num_trials,kfit_loo,'ro-')
% plot([0 num_trials+1],[0 0],'k:')
% xlim([0 num_trials+1]);
% subplot 122
% plot(kfit,kfit_loo,'ko')
% hold on
% minval = min([kfit kfit_loo]);
% maxval = max([kfit kfit_loo]);
% plot([minval maxval],[minval maxval],'k:')
% axis equal
% 
% % check that the mean of the leave-one-out kernels is the same as the mean kernel
% figure
% plot(kdata,'b-')
% hold on
% plot(mean(kdata_loo)-kdata,'r-')
% xlim([1 size(data,2)]);

end