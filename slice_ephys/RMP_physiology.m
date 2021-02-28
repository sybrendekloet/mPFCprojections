function [Rin, Tau, goff, Sag_Ratio20, Capacitance] = RMP_physiology(abfFiles,MDorStr)

% Function returns the parameters Input resistance, resting membrane potential, Tau, sag ratio and capacitance from current step
% protocol. Only uses the negative steps.
%
% Required scripts:
% - abfload.m
%
% Input:
% - abfFiles = array with abf files that contain the data (abfFiles = {'2018_08_15_MD2_2_Ipsi_0001.abf',...
%                                                                      '2018_08_15_MD2_1_Ipsi_0001.abf'};
% - MDorStr = 'MD' or 'Str' recording
%
% Output:
% - Rin = vector with mean input resistence (MOhm) per recording
% - Tau = vector with membrane time constant (from exponential fit) per recording (ms)
% - goff = goodness of fitt for every tay
% - Sag_ratio20 = vector with sag ratio per recording (% deviation from
% steady state), recorded from pulse that showed a peak drop of 20mV
% - Capacitance = capacitance in (pF)
%
% h.terra@vu.nl
% 18-11-2020
% Version 2.0
%
%

% Analysis method form Collins - Carter, Neuron, 2018, except for tau and capacitance (C), this
% was googlded.
% For current-clamp recordings, input resistance was measured using the
% steady-state response to a 500 ms, 50 or 100 pA current injection. The membrane time constant (tau) was measured using exponential
% fits to these same hyperpolarizations. Voltage sag due to h-current was calculated by taking the minimum voltage in the first
% 200 ms, subtracting the average voltage over the final 50 ms, and then
% dividing by the steady-state value.


alternateRecordingDates = {'2019_12_19','2019_12_20','DS2_cell1_L_2019_12_18','DS3_cell1_L_2019_12_18','DS3_cell2_L_2019_12_18','DS1_cell1_L_2020_02_06','DS2_cell2_L_2020_02_04','DS2_cell1_L_2020_02_04','VS1_cell1_L_2020_02_07'};

try
%% Loop over all abf files and perform calculations
for fileIx = 1:size(abfFiles,2)
    % Open .abf file
    [RAW,~,recParam] = abfload(abfFiles{fileIx});

    % Set recording channels based on recording type.
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
        
    %% Calculate input Resistance in MOhm
    % Define epoch where input pulse was given based on first sweep and
    diffRaw = diff(RAW(:,I_CH,1));
    [temp, downIx] = min(diffRaw);
    [temp, upIx] = max(diffRaw);
    
    
    % Define input amplitude
    n = 1;
    for sweep = 1:size(RAW(:,I_CH,:),3)
        input_Amp(sweep) = -int64(diff([min(RAW(downIx+1:upIx-1,I_CH,sweep)) mean(RAW(1:downIx-1,I_CH,sweep))]));
        if input_Amp(sweep) <= 0
            sweep_neg(n) = sweep;
            
            n = n+1;
        end
    end
    
    % Find relevant sweeps
    sweep50_100 = find(input_Amp<=-5 & input_Amp>=-104);
    n = 1;
    for sweep = sweep50_100
        I_input(n) = round(abs(mean(RAW(downIx+1:upIx-1,I_CH,sweep))-mean(RAW(1:downIx-1,I_CH,sweep))),0);
        n=n+1;
    end
    I_input = I_input*(10^-12);
    
    % Get delta voltage per relevant sweep
    n = 1;    
    for sweep = sweep50_100
        V_output(n) = diff([median(RAW(upIx-(recParam.si*200):upIx-1,V_CH,sweep)) median(RAW(downIx-(recParam.si*200):downIx-1,V_CH,sweep))]);
        n = n+1;
    end

    % Change mV to V
    V_output = V_output*(10^-3);
    
   
    
    % Calculate input Resistance R = U/I
    %R_input = V_output./I_input;
    
    % Take median value across all negative inputs and convert to MOhm
    %R_input_median(fileIx) = median(R_input)*(10^-6);
    
    % Make linear fit over all negative pulses and take angle as Rin
    Linear_fit = polyfit(I_input',V_output',1);
    Rin(fileIx) = Linear_fit(1)*(10^-6);
    %Rin(fileIx) = V_output./I_input*(10^-6);
%     if upIx-downIx > 11000
%     figure
%     hold on
%     scatter(I_input,V_output)
%     plot(I_input, polyval(Linear_fit,I_input))
%     text(I_input, polyval(Linear_fit,I_input), sprintf('Text %f more text', Linear_fit(1)*(10^-6)))
%     
%     timeaxis = 0:recParam.si/1000000:(size(RAW(:,1,:),1)-1)/(1000000/recParam.si);
%     figure
%     for i = sweep50_100
%         subplot(2,1,1)
%         hold on
%         plot(timeaxis,RAW(:,V_CH,i))
%         subplot(2,1,2)
%         hold on
%         plot(timeaxis,RAW(:,I_CH,i))
%     end
%     end
    
    
    
    
    %% Calculate resting membrane potential in mV
    %for sweep = 1:size(RAW(:,2,:),3);
    %    RMP_sweep(sweep) = median(RAW(1:downIx-1,1,sweep));
    %end
    %RMP(fileIx) = mean(RMP_sweep);
    
    %% Calculate membrane time constant in ms. Calculates time in takes to get from median baseline before pulse to 63% of the last 100ms of pulse
    
    % Get relevant sweeps
    sweep50_100 = find(input_Amp<=-1 & input_Amp>=-56);

    % Make exponential fit per sweep
%     figure
%     hold on
    
    n = 1;
    for sweep10mV2 = sweep50_100
        yFit = RAW(downIx:downIx+(0.3*20000),V_CH,sweep10mV2);
        xFit = linspace(0,(numel(yFit)-1)*(1/20000),numel(yFit))';

        ft = fittype( 'a*exp(b*-x)+c', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display     = 'Off';
        opts.Lower       = [-Inf -Inf -Inf];
        opts.Upper       = [Inf  Inf Inf];
        opts.MaxFunEvals = 1000;
        opts.MaxIter     = 1000;
        opts.StartPoint  = [20 10 -70];
        [fitresult, gof] = fit(xFit, yFit, ft, opts );
        goff(fileIx) = gof.rsquare;

        if gof.rsquare >= 0.8 && ((1/fitresult.b)*1000) < 150
            tauTemp(n) = (1/fitresult.b)*1000;
            n = n+1;
        else
            tauTemp(n) = nan;
            n = n+1;
        end
        
%         timeaxis_fit = 0:recParam.si/1000000:(size(xFit,1)-1)/(1000000/recParam.si);
%         plot(timeaxis_fit,yFit)
%         plot(fitresult)
%         
        
    end

    % Take median tau over sweeps
    Tau(fileIx) = nanmedian(tauTemp);
    
%     timeaxis = 0:recParam.si/1000000:(size(RAW(:,1,:),1)-1)/(1000000/recParam.si);
%     figure
%     for i = sweep50_100
%         subplot(2,1,1)
%         hold on
%         plot(timeaxis,RAW(:,V_CH,i))
%         subplot(2,1,2)
%         hold on
%         plot(timeaxis,RAW(:,I_CH,i))
%     end
    
%     figure
%     timeaxis = 0:recParam.si/1000000:(size(RAW(:,1,:),1)-1)/(1000000/recParam.si);
%     subplot(2,1,1)
%     hold on
%     for sweep = 1:size(RAW(:,2,:),3)
%         plot(timeaxis,RAW(:,1,sweep),'k')
%     end
%     for sweep = sweep50_100
%         plot(timeaxis,RAW(:,1,sweep),'r')
%     end
%     plot(timeaxis,RAW(:,1,sweep10mV),'b')
%     
%     subplot(2,1,2)
%     hold on
%     for sweep = 1:size(RAW(:,2,:),3)
%         plot(timeaxis,RAW(:,2,sweep),'k')
%     end
%     for sweep = sweep50_100
%         plot(timeaxis,RAW(:,2,sweep),'r')
%     end
%     plot(timeaxis,RAW(:,2,sweep10mV),'b')
%     xlabel('Time (sec)')
%     ylabel('pA')
    
    
    
    %% Calculate voltage sag

    n = 1;
    for sweep = sweep_neg
        Sag_BL(n) = mean(RAW(1:downIx-1,V_CH,sweep));
        Sag_min(n) = diff([min(lowpassfilter(RAW(downIx:downIx+round(((upIx-downIx)*0.2),0),V_CH,sweep),(1000000/recParam.si),200)) Sag_BL(n)]);
        Sag_last50(n) = diff([median(RAW(upIx-round(((upIx-downIx)*0.1),0):upIx,V_CH,sweep)) Sag_BL(n)]);
        %I_inputSag(n) = round(abs(mean(RAW(downIx+1:upIx-1,2,sweep))-mean(RAW(1:downIx-1,2,sweep))),0);
        n = n+1;
    end
    
    if upIx-downIx > 11000
        [x sweep20mV] = min(abs(Sag_min-20));
        Sag_Ratio20(fileIx) = 100*(Sag_min(sweep20mV)-Sag_last50(sweep20mV))./Sag_min(sweep20mV);
        if Sag_Ratio20(fileIx) < 0
            Sag_Ratio20(fileIx) = 0;
        end
    else
        %Sag_Ratio20(fileIx) = nan;
        [x sweep20mV] = min(abs(Sag_min-20));
        Sag_Ratio20(fileIx) = 100*(Sag_min(sweep20mV)-Sag_last50(sweep20mV))./Sag_min(sweep20mV);
        if Sag_Ratio20(fileIx) < 0
            Sag_Ratio20(fileIx) = 0;
        end
    end
    %Sag_ratio(fileIx) = median(Sag_ratio_sweep);
        
%     timeaxis = 0:recParam.si/1000000:(size(RAW(:,1,:),1)-1)/(1000000/recParam.si);
%     if upIx-downIx > 11000
%     try
%     figure
%     for i = sweep_neg(sweep20mV)
%         subplot(2,1,1)
%         hold on
%         plot(timeaxis,RAW(:,V_CH,i))
%         line([1 2], [min(lowpassfilter(RAW(downIx:downIx+round(((upIx-downIx)*0.2),0),V_CH,i),(1000000/recParam.si),200)) min(lowpassfilter(RAW(downIx:downIx+round(((upIx-downIx)*0.2),0),V_CH,i),(1000000/recParam.si),200))])
%         line([1 2], [median(RAW(upIx-round(((upIx-downIx)*0.1),0):upIx,V_CH,i)) median(RAW(upIx-round(((upIx-downIx)*0.1),0):upIx,V_CH,i))])
%         subplot(2,1,2)
%         hold on
%         plot(timeaxis,RAW(:,I_CH,i))
%     end
%     catch
%     end
%     end
    %% Calculate membrane capacitance (C = Tau/R) or tau = RC
    Capacitance(fileIx) = ((Tau(fileIx)/1000)/(Rin(fileIx)/(10^-6)))*10^12;
    
    clearvars -except fileIx abfFiles Rin Tau Sag_ratio goff Sag_Ratio20 Capacitance V_CH I_CH alternateRecordingDates MDorStr
end
catch
end
