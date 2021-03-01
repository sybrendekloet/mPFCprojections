%% Analysis program for fiber photometry data in 5-CSRTT
% Contents:
% 
% - Import and basic parameters
% 
%   > Data has already been pre-processed, and needs to be loaded from
%   corresponding .mat file ('mPFCprojections_allData.mat')
%
%   > In this part, we set all the relevant parameters for the next step.
%
% - Classification
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
%
%
%   Questions / feedback?
%   Please contact Sybren de Kloet (sybrendekloet@protonmail.com)
%
%   Last updated: 28-02-2021
%
%
%
%
%
%

%% Import and basic parameters

% Set directory for analysis output (graphs, tables)
exptname = ''; % name folder to which analysis will belong (put expt name between apostrophes)
savefolder = ['' exptname];%folder where this analysis will be saved (put directory between apostrophes)
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
% This allows selection of only trials where population is active (not
% recommended when unfamiliar with the data and collection process).

[data_in, meta_in] = classify_FPdata(c3, norm, dev);


%% Behavioral analysis
% Generates struct with behavioral data for 5-CSRTT sessions 
% This data is shown in Figure S5a

[behavior] = fp_behavior(meta_in);

%% Neurophysiological analysis
%
% Find scripts corresponding to article figures below:
%
%% Area under curve
% Compares Area Under Curve (AUC) between different delay duration trials.
% This data is shown in Figure 4F-G.

[aucData, aucTest, aucTraces] = compareAUC(data_in, meta_in);


%% Signal parameters
% Compares signal parameters between populations and outcomes. These data
% are shown in Figures 4H-M.

[test_out,test_stats_pop, final_out] = signalParameters(data_in, meta_in);


%% Population activity DURING ITI
% Compares traces between populations and outcomes. This data is shown in
% Figure 5.

% kt = difference from baseline
% dt, pt = difference between populations

[delay_kt, delay_dt, delay_pt] = compareTraces_delay(data_in, meta_in);


%% Population activity AROUND CUE
% Compares traces between populations and outcomes. This data is shown in
% Figure 5.
%
[cue_kt, cue_dt, cue_pt] = compareTraces_cue(data_in, meta_in);

% b) ITI duration & AUC
%% Population activity AROUND RESPONSE
% Compares traces between populations and outcomes. This data is shown in
% Figure 5.
%

[resp_kt, resp_dt, resp_pt] = compareTraces_resp(data_in, meta_in);

%% Save all plots
% If necessary

saveFigures(savefolder, saveFig);


%% 
