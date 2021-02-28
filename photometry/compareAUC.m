function [data_tests_trapz,test_results, data_traces] = compareAUC(data_in, meta_in)

data_tests_trapz=cell(1,4);
test_results = struct;
cue_t = [10 12.5 17.5];
start_t = 5;

% loop through groups
for g = 1:4
    % loop through itis
    for ss = 1:3
        % loop through rats
        for r =1:numel(unique(meta_in(meta_in(:,1)==g,2)))
            ratno = unique(meta_in(meta_in(:,1)==g,2));
            ratId = ratno(r);
            
            % distinguish between response types, iti, rat, etc.
            cfi = (meta_in(:,1)==g & meta_in(:,2)==ratId & meta_in(:,3)==1 &...
                meta_in(:,5)==1 & meta_in(:,6)==ss);
            
            % Alternative baseline
            %         bm_mean = mean(data_in{1}(cfi,ceil(15.89):ceil(3*15.89)),'all');
            %         bm_std= std(data_in{1}(cfi,ceil(15.89):ceil(3*15.89)),0,'all');
            %         data_in_bm = (data_in{1}(cfi,:)-bm_mean)./bm_stds;
            %
            % Select input data and process
            % Only data >0
            data_2 = data_in{1}(cfi,ceil(start_t*15.89):ceil(cue_t(ss)*15.89));
            %             data_2m = (data_2-prctile(data_2,10,2))./prctile(data_2,90,2)
            data_tmp{g}(r,ss) = sum(data_2(data_2>0))/sum(cfi);
            %             data_tests_trapz{g}(r,ss) = trapz(mean(data_in(cfi,ceil(start_t*15.89):ceil(cue_t(ss)*15.89))),2);
            data_tests_trapz{g}(r,ss) = mean(sum(data_in{1}(cfi,ceil(start_t*15.89):ceil(cue_t(ss)*15.89))>0,2));
%             subplot(1,4,g)
            data_traces{g}(r,:) = mean(data_in{1}(cfi,:));
%             plot(mean(data_in{1}(cfi,ceil(start_t*15.89):ceil(cue_t(ss)*15.89))), 'color', col_rep(ss))
%             hold on
        end
    end
    
    [test_results(g).p,test_results(g).tab,test_results(g).stats] = friedman(data_tests_trapz{g},1,'off');
    [test_results(g).tb, test_results(g).mct] = multcompare(test_results(g).stats, 'display', 'off');
    test_results(g).w = test_results(g).tab{2,5}/(size(data_tests_trapz{g},1)*(size(data_tests_trapz{g},2)-1));
end

end