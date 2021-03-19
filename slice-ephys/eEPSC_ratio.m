function [eEPSC] = eEPSC_ratio(abfFiles,MDorStr)

%% Function returns paired pulse ratio (PPR) after LED stim and also returns
% time to 80% of max amplitude of ePSC.

% Scripts needed:
% - lowpassfilter.m
% - abfload.m
%
% input:
% - abfFiles = array with abf files that contain the data (abfFiles = {'2018_08_15_MD2_2_Ipsi_0001.abf',...
%                                                                      '2018_08_15_MD2_1_Ipsi_0001.abf'};
%
% ouput:
% - eEPSC   = struct with mean(or median) LED evoked PPR per recording and
%           80% max amplitude response times.
% - p       = Friedmans p-value indicating if there is overall effect of pulse
%           number on PPR.
% - results = Dunn's multiple comparisons results

alternateRecordingDates = {'2019_12_19','2019_12_20','DS2_cell1_L_2019_12_18','DS3_cell1_L_2019_12_18','DS3_cell2_L_2019_12_18','DS1_cell1_L_2020_02_06','DS2_cell2_L_2020_02_04','DS2_cell1_L_2020_02_04','VS1_cell1_L_2020_02_07'};

%% Loop over all abf files and perform calculations
n = 1;
for fileIx = 1:size(abfFiles,2)
    % Open .abf file
    [RAW,~,recParam] = abfload(abfFiles{fileIx});
    
    if contains(MDorStr,'MD')
        V_CH = 1;
        I_CH = 3;
    elseif contains(MDorStr,'Str')
        V_CH = 2;
        I_CH = 5;
        for i = 1:size(alternateRecordingDates,2)
            if contains(abfFiles{fileIx},alternateRecordingDates{i})
                V_CH = 1;            
                break
            end
        end
    else
        display('Wrong input')
    end
    
    
    
    % correct baseline deviations with a robust linear regression line fit
    % and subtract that per sweep.
%     for sweep = 1:size(RAW(:,V_CH,:),3)
    for sweep = 1:10
        robustReg = robustfit(1:size(RAW(:,V_CH,1),1),(RAW(:,V_CH,sweep)));
        RAW(:,V_CH,sweep) = RAW(:,V_CH,sweep)-(robustReg(1)+robustReg(2)*(1:size(RAW(:,V_CH,1),1))');
    end
    
    
    
    % Take median trace over all sweeps and low pass filter to get rid of
    % fast artefacts
    eEPSC_median = median(RAW(:,V_CH,1:10),3);
    eEPSC_median_lpF = eEPSC_median;
    %lowpassfilter(eEPSC_median,(1000000/recParam.si),1000);

    % Find indexes where LED TTL went high
    LEDTreshold = find(RAW(:,I_CH,1)>0.1);
    b = LEDTreshold(find(diff(LEDTreshold)>1)+1)';
    LEDonIx = [LEDTreshold(1) b];
    
    clear LEDTreshold b
    
    % Optional figure
%     timeAxis = 0:1/(1000000/recParam.si):(size(RAW(:,I_CH,1),1)-1)/(1000000/recParam.si);
%     figure
%     hold on
%     for i = 1:10
%     plot(timeAxis,RAW(:,V_CH,i),'LineWidth',0.1)
%     end
%     plot(timeAxis,eEPSC_median_lpF,'LineWidth',2)
%     plot(timeAxis,RAW(:,I_CH,1)*10,'LineWidth',1)
    
    m = 1;
    for peak = 1:size(LEDonIx,2)
        [peakVal, peakIx] = min(eEPSC_median_lpF(LEDonIx(peak):LEDonIx(peak)+200));
        %segmentLPF = lowpassfilter(abs(eEPSC_median_lpF(LEDonIx(peak):LEDonIx(peak)+200)),(1000000/recParam.si),1000);
        %[peakVal, peakIx] = findpeaks(abs(eEPSC_median_lpF(LEDonIx(peak):LEDonIx(peak)+200)));
        % Gets peak values
        eEPSC.amp(fileIx,peak) = peakVal;
        %eEPSC.amp(fileIx,peak) = peakVal(1);
%         if peak == 1 && peakVal < -50
%             eEPSC.amp(n,peak) = nan;
%         end
    
    
        % Calculate relative eEPSC peak value compared to baseline pA.
        % find time to 90% of peak eEPSC
        eEPSC_amp_80 = abs(0.8*peakVal);
        [~, eEPSC_amp_80Ix] = min( abs( eEPSC_median_lpF(LEDonIx(peak):LEDonIx(peak)+peakIx)-eEPSC_amp_80 ) );
        eEPSC.respTime(fileIx,peak) = eEPSC_amp_80Ix/(1000000/recParam.si);

        m = m+1;
        clear peakVal peakIx
    end
    
    % Take ratio PEAKn/PEAK1
    eEPSC.ratio (fileIx,:) = eEPSC.amp(fileIx,:)/eEPSC.amp(fileIx,1);
    
    n = n+1;

end

%% Plotting and statistics
% figure
% hold on
% for i = 1:size(eEPSC.ratio,1)
%     plot(1:5,eEPSC.ratio(i,:),'*');
% end
% if numel(abfFiles) > 1
%     errorbar(1:5,mean(eEPSC.ratio,1),std(eEPSC.ratio,1)/sqrt(size(eEPSC.ratio,1)))
% end
% title('LED induced PPR')
% xlabel('Pulse number')
% ylabel('eEPSCn/ePSC1')
% set(gca,'XTick',[0 1 2 3 4 5])

if numel(abfFiles) > 1
    % Friedmans Anova to test for effect of pulse number on PPR. Post-hoc Dunn's mulitple
    % comparison test
    %[p,tbl,stats] = friedman(eEPSC.ratio,1,'displayopt','off');
    %[p,tbl,stats] = friedman(eEPSC.ratio,1);

    %results = multcompare(stats,'CType','dunn-sidak');
end
