function [I_input, N_APs] = Step_prot_firing_SteadyState(abfFiles,MDorStr)

% Function returns the parameters Input resistance, resting membrane potential, Tau and sag ratio from current step
% protocol. Only uses the first half of the steps (the negative ones)
%
% Required scripts:
% - abfload.m
%
% Input:
% input:
% - abfFiles = array with abf files that contain the data (abfFiles = {'2018_08_15_MD2_2_Ipsi_0001.abf',...
%                                                                      '2018_08_15_MD2_1_Ipsi_0001.abf'};
%
% Output:
% - R_input_median = vector with mean input resistence (MOhm) per recording
% - RMP = vector with resting membrane potential per recording (mV)
% - Tau = vector with membrane time constant (set at 63% of steady state value) per recording (ms)
% - Sag_ratio = vector with sag ratio per recording (ms)
%
% h.terra@vu.nl
% 23-11-2018
% Version 1.0
%
%

alternateRecordingDates = {'2019_12_19','2019_12_20','DS2_cell1_L_2019_12_18','DS3_cell1_L_2019_12_18','DS3_cell2_L_2019_12_18','DS1_cell1_L_2020_02_06','DS2_cell2_L_2020_02_04','DS2_cell1_L_2020_02_04','VS1_cell1_L_2020_02_07'};

try
%% Loop over all abf files and perform calculations
for fileIx = 1:size(abfFiles,2)
    % Open .abf file
    [RAW,~,recParam] = abfload(abfFiles{fileIx});
    
    samplingFreq = 1000000/recParam.si;
    
    if contains(MDorStr,'MD')
        V_CH = 1;
        I_CH = 2;
    elseif contains(MDorStr,'Str')
        V_CH = 2;
        I_CH = 3;
        for i = 1:size(alternateRecordingDates,2)
            if contains(abfFiles{fileIx},alternateRecordingDates{i})
                V_CH = 1;            
                break
            end
        end
    else
        display('Wrong input')
    end
    
    
    diffRaw = diff(RAW(1:end/2,I_CH,end));
    [temp, downIx] = min(diffRaw); downIx = downIx-1;
    [temp, upIx] = max(diffRaw); upIx = upIx+1;
    
    n = 1;
    for sweep = 1:size(RAW(:,I_CH,:),3)
        input_Amp(sweep) = int64(mean(RAW(upIx:downIx,I_CH,sweep))-int64(mean(RAW(1:upIx-1,I_CH,sweep))));
        if input_Amp(sweep) >= 0
            sweep_pos(n) = sweep;
            n = n+1;
        end
    end
    
    
    n = 1;
    for sweep = sweep_pos
        I_input(fileIx,n) = round(abs(round(mean(RAW(upIx:downIx,I_CH,sweep)),0)-round(mean(RAW(1:upIx-1,I_CH,sweep)),0)),0);
        if n >=2 && I_input(fileIx,2)-I_input(fileIx,1)<20
            I_input(fileIx,1) = round(I_input(fileIx,1)/15)*15;
            I_input(fileIx,n) = round(I_input(fileIx,n)/15)*15; %Make sure that small deviations in step current are correct a multiplication of 5;
        elseif n >=2 && I_input(fileIx,2)-I_input(fileIx,1)>20
            I_input(fileIx,1) = round(I_input(fileIx,1)/50)*50;
            I_input(fileIx,n) = round(I_input(fileIx,n)/50)*50; %Make sure that small deviations in step current are correct a multiplication of 5;
        end
        n=n+1;
    end
    %I_input = I_input*(10^-12);
    
    n = 1;    
    for sweep = sweep_pos
        try
            [pks,locs] = findpeaks(RAW((downIx-samplingFreq/5):downIx,V_CH,sweep),'MinPeakHeight',0);
            N_APs(fileIx,n) = numel(pks)*5;
            %ISI_APs(fileIx,n)
        catch
            N_APs(fileIx,n) = 0;
        end
        n = n+1;
    end
    
%     timeaxis = 0:recParam.si/1000000:(size(RAW(:,1,:),1)-1)/(1000000/recParam.si);
%     figure
%     for i = sweep_pos
%         subplot(2,1,1)
%         hold on
%         plot(timeaxis,RAW(:,V_CH,i))
%         subplot(2,1,2)
%         hold on
%         plot(timeaxis,RAW(:,I_CH,i))
%     end
    
    
    clearvars -except N_APs I_input fileIx abfFiles V_CH I_CH alternateRecordingDates MDorStr
    
% %     figure
% %     timeaxis = 0:recParam.si/1000000:(size(RAW(:,1,:),1)-1)/(1000000/recParam.si);
% %     subplot(2,1,1)
% %     hold on
% %     for sweep = 1:size(RAW(:,2,:),3)
% %         plot(timeaxis,RAW(:,1,sweep),'k')
% %     end
% %     for sweep = sweep50_100
% %         plot(timeaxis,RAW(:,1,sweep),'r')
% %     end
% %     plot(timeaxis,RAW(:,1,sweep10mV),'b')
% %     
% %     subplot(2,1,2)
% %     hold on
% %     for sweep = 1:size(RAW(:,2,:),3)
% %         plot(timeaxis,RAW(:,2,sweep),'k')
% %     end
% %     for sweep = sweep50_100
% %         plot(timeaxis,RAW(:,2,sweep),'r')
% %     end
% %     plot(timeaxis,RAW(:,2,sweep10mV),'b')
% %     xlabel('Time (sec)')
% %     ylabel('pA')
    
    
    
end
catch
    disp('doesnt work')
end
