%
function [data_in, meta_in] = classify_FPdata(cData, cDatNorm, cDatDev)

% Extract names for categories
rNms = fieldnames(cData);
ratNames = rNms(~contains(rNms,'placements'));
placements_keep = cData.placements;
% syncNames = {'trialstart', 'response'}; %define sync moment names
field_order = {'GMDL' 'MDM' 'GDS' 'GVS'};

% Parameters for data structuring
tmpTrc = cell(1,2); ana_meta = zeros(1,10);
sync_win = {ceil(-5*15.89):ceil(17.5*15.89), ceil(-3*15.89):ceil(5*15.89)};
spec = [5 7.5 12.5;...
    1 0.5 0.2]; % Rows contain different delay (row 1) or cue duration (row 2) conditions
% conv = 1017.3/64; %Conversion rate from frames 1017.3/s to seconds (original data: 1017.3Hz. Downsampled 64x during pre-processing)

for rat = 1:numel(ratNames)
    
    if strcmp(ratNames{rat}(isletter(ratNames{rat})), 'GMDM')
        group = {'MDM'};
    else
        group = placements_keep(strcmp(ratNames{rat}(isletter(ratNames{rat})),placements_keep));
    end
    
    group = find(contains(field_order, group)==1);
    
    conditions = fieldnames(cData.(ratNames{rat}));
    
    for cond = 1:numel(conditions)
        sessN = numel(cData.(ratNames{rat}).(conditions{cond}).msfin);
        
        condCheck = find(strcmp(conditions{cond},{'varITI' 'varSD'})==1);
        
        for sess = 1:sessN
            data = cData.(ratNames{rat}).(conditions{cond}).msfin{sess};
            meta = [cData.(ratNames{rat}).(conditions{cond}).trialstart{sess}(:,1),...
            cData.(ratNames{rat}).(conditions{cond}).response{sess}(:,1),...
            cData.(ratNames{rat}).(conditions{cond}).trialstart{sess}(:,2:4)];
            
            % exclude trials too close to session start or end
            validtr = find(meta(:,1)>5.5 & meta(:,2)<(numel(data)/15.89)-15);
            
            % for appending the array
            msize = size(tmpTrc{1},1);
            
            % percentiles for normalization
            upper_prc = prctile(data,98);
            lower_prc = prctile(data,2);
            [~,subspec]=ismember(meta(validtr,4),spec(condCheck,:));
            
            % trial start time relative to session length
            trtime = meta(validtr,1);%*1017.3/64/length(data);
            rsptime = meta(validtr,2);%*1017.3/64/length(data);
            
            for sync = 1:2
                iidx = bsxfun(@plus, ceil(meta(validtr,sync)*(1017.3/64)), sync_win{sync}); % create all indices
%                 b1 = bsxfun(@plus, ceil(meta(validtr,1)*15.89), ceil(-5*15.89):ceil(15.89*-2)); % create all indices
                tmpTrc{sync}(msize+1:msize+numel(validtr),:) = data(iidx);%-mean(data(b1),2);
            end % sync
            
            % 1      2    3     4     5     6        7           8
            % group, rat, cond, sess, resp, subspec, lower norm, upper norm
            % 9             % 10
            % trial time,   resp time
            ana_meta(msize+1:msize+numel(validtr),:) = ...
                [ones(numel(validtr),1)*group,...
                ones(numel(validtr),1)*rat, ones(numel(validtr),1)*condCheck,...
                ones(numel(validtr),1)*sess, meta(validtr,3),...
                subspec,...
                ones(numel(validtr),1)*lower_prc, ones(numel(validtr),1)*upper_prc,...
                trtime,rsptime];
        end %sessn
    end %stages
end %rats

data_in{1} = tmpTrc{1}(ana_meta(:,6)~=0,:);
data_in{2} = tmpTrc{2}(ana_meta(:,6)~=0,:);
meta_in = ana_meta(ana_meta(:,6)~=0,:);

if cDatNorm == 1
    % Ztransform the data (on single trial lvl)
    % baseline window = -5s : -1s
    bwin = [ceil(1*15.89)^0, ceil(4*15.89)];
    data_in_z = (data_in{1}-mean(data_in{1}(:,bwin(1):bwin(2)),2))./...
        std(data_in{1}(:,bwin(1):bwin(2)),[],2);
    data_in_z_resp = (data_in{2}-mean(data_in{1}(:,bwin(1):bwin(2)),2))./...
        std(data_in{1}(:,bwin(1):bwin(2)),[],2);
    data_in{1}= data_in_z;
    data_in{2}= data_in_z_resp;
end

% Only trials that show deviation from BL
data_in{1} = data_in{1}(sum(abs(data_in{1})>cDatDev,2)>10,:);
data_in{2} = data_in{2}(sum(abs(data_in{2})>cDatDev,2)>10,:);
meta_in = meta_in(sum(data_in{1}>cDatDev,2)>10,:);


end

