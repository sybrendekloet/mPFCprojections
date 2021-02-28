%% Analysis program for fiber photometry data in 5-CSRTT
% Contents:
% 
% - Data import and setup
% 
%   > Data has already been pre-processed, and needs to be loaded from
%   corresponding .mat file
%
%   > In this part, we set all the relevant parameters for the next step.
%
% - Data structuring
%
%   > Pre-processed data has been structured in a particular way. This part
%   of the script generates two outputs:
%
%       1)  data_in: This is a cell array of 2 cells. Each cell contains a
%       matrix of all individual traces. Traces correspond to single
%       trials.
%
%       2)  meta_in: This is a matrix with all the relevant task parameters
%       (e.g. session type ['variable delay' (vITI) or 'variable cue'
%       (vSD)] or outcome ['Correct', 'Incorrect', 'Omission',
%       'Premature']). This allows for easy access to trials needed for
%       statistical analysis, graphing or any other use.
% 
% - Behavioral analysis
% 
% - Neurophysiological analysis

%% Import and basic parameters

% Set directory for analysis output (graphs, tables)
exptname = 'group_data_projections'; % name folder to which analysis will belong
savefolder = ['D:\Publications\Projection paper\Data\Analysis\' exptname];%folder where this analysis will be saved
mkdir(savefolder); % creates directory where figures will end up
saveFig = 1; % 1 = save all figures, 0 = don't save figures    


%% Classification
% Re-organise pre-processed fiber photometry data (variable named
% compiledData, which contains FP data from individual rats/sessions)
%
% Allows for normalization and selection of data based on activity. 
%
norm = 1; % Normalization type. 0 = no transformation, 1 = z-transform (default)
dev = 0; % Deviation criterion. 0 = no selection (default). Other inputs = only trials 
% where amount of frames that are >[dev] from baseline is larger than 10.
% This allows selection of only trials where population is active. 

[data_in, meta_in] = classify_FPdata(compiledData, norm, dev);

[test_out,test_stats_pop, final_out] = signalParameters(data_in, meta_in);

%% Behavior
% Generates struct with behavioral data for 5-CSRTT sessions 
% This data is shown in Figure S5a

[behavior] = fp_behavior(meta_in);

%% Area under curve
% Compares Area Under Curve (AUC) between different delay duration trials.
% This data is shown in Figure 4F-G.

[aucData, aucTest, aucTraces] = compareAUC(data_in, meta_in);


%% Basic metrics
% Compares signal parameters between populations and outcomes. These data
% are shown in Figures 4H-M.

% [test_out,test_stats_pop, final_out] = signalParameters(data_in, meta_in);


%% Population activity DURING ITI
% Compares traces between populations and outcomes. This data is shown in
% Figure 5.

% kt = difference from baseline
% dt, pt = difference between populations

[delay_kt, delay_dt, delay_pt] = compareTraces_delay(data_in, meta_in);


%% Population activity AROUND CUE
% Is population active during task and does it respond to changing task
% parameters?
%
[cue_kt, cue_dt, cue_pt] = compareTraces_cue(data_in, meta_in);

% b) ITI duration & AUC
%% Population activity AROUND RESPONSE

[resp_kt, resp_dt, resp_pt] = compareTraces_resp(data_in, meta_in);

%% Save all plots

saveFigures(savefolder, saveFig);


%% 
%% Population activity DURING ITI FOR SINGLE RATS
% Is population active during task and does it respond to changing task
% parameters?
%
% 1      2    3     4     5     6        7           8
% group, rat, cond, sess, resp, subspec, lower norm, upper norm
% 9
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


data_pop = data_in_z;
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
                meta_pop(:,5)==o & meta_pop(:,6)==3 & (meta_pop(:,end)-meta_pop(:,end-1))>7.5);
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
            
            
            
            
            % Bootstrap test for each rat
            sig = 0.001; %bootstrap significance level
            fit_boots = 1; %bootstrap fit parameter
            num_boots = 2000; %number of bootstrap iterations
            data_bootstrap_analysis = data_tests(:,ceil(5*15.89):ceil(12.5*15.89));
            
            [bootsCI, ...
                ~, kbootsCI, ...
                ~, ~, ...
                ~, ~] = ...
                bootstrap_data_v201(data_bootstrap_analysis,num_boots,fit_boots,sig);
         
            data_out_boot{g,o}(r,:) = bootsCI(1,:)>0;
        end
    end
end



%% Difference between response types
% Is population activity different leading up to different response types?
%
% a) Permutation tests or bootstrap to 0 for differences between populations
%
% Individual rat lvl: permutation tests or bootstrap for each response type
%
%% Predictive value of signal
% Does signal hold any predictive information about trial outcome?
%
% a) Use auROC to show classification of trial outcomes
% b) train model and use it to predict trial outcomes 
%