function Cm = Capacitance

% Hello Amir
% If you assume the cell is a one-compartment it is quite easy if you have an intracellular electrode inside. 
% First, you have to estimate the cell input resistance (during quiescence, i.e. without synaptic input). 
% You can do this by two levels of DC current injections and then measuring the voltage and the calculating the difference (delta I and delta V). Then you use Ohms law :
% R = delta V / delta I
% Next, you have to measure the cells timeconstant, tau. You can do this by giving a step pulse in current and 
% fit an exponential to the decay towards the new voltage level. This will give you tau. You can also measure the 
% time it takes to reach 63% of its way towards the asymptotic value. Once you have tau, calculating the capacitance 
% is easy from the fact that one-compartment cells have tau=RC:
% C = tau/R
% hope this makes sense - otherwise write me
% Rune

% Function returns paired pulse ratio (PPR) after LED stim and also returns
% time to 80% of max amplitude of ePSC.


% Abf files that contain LED stim train
abfFiles = {'2018_08_15_MD2_2_Ipsi_0001.abf','2018_08_15_MD2_1_Ipsi_0001.abf'};

% Loop over all abf files and perform calculations
n = 1;
for fileIx = 1:size(abfFiles,2)
    % Open .abf file
    [RAW,~,recParam] = abfload(abfFiles{fileIx});
    
    % Take median trace over all sweeps
    eEPSC_median(n,:) = median(RAW(:,1,:),3);
    eEPSC_median_lpF = lowpassfilter(eEPSC_median,(1000000/recParam.si),1000);

    % Find indexes where LED TTL went high
    [~, LEDonIx]= findpeaks(diff(RAW(:,3,1)),'MinPeakHeight',1);
       
    m = 1;
    for peak = 1:size(LEDonIx,1)
        [peakVal, peakIx] = min(eEPSC_median_lpF(n,LEDonIx(peak):LEDonIx(peak)+3999));
        %eEPSC_respTime(n,m) = peakIx*(1/(1000/recParam.si));
        % Calculate baseline pA from last second of sweep
        pA_baseline = mean(eEPSC_median_lpF(n,LEDonIx(peak)));
        eEPSC_amp(n,m) = pA_baseline-peakVal;

        % Calculate relative eEPSC peak value compared to baseline pA.
        % find time to 90% of peak eEPSC
        eEPSC_amp_80 = pA_baseline+abs(0.8*eEPSC_amp(n,m));
        [~, eEPSC_amp_80Ix] = min( abs( eEPSC_median_lpF(n,LEDonIx(peak):LEDonIx(peak)+peakIx)-eEPSC_amp_80 ) );
        eEPSC.respTime(n,m) = eEPSC_amp_80Ix/(1000000/recParam.si);

        m = m+1;
    end
    
    
    
    % Take ratio PEAKn/PEAK1
    eEPSC.ratio (n,:) = eEPSC_amp(n,:)/eEPSC_amp(n,1);
    
    n = n+1;

end

figure
hold on
for i = 1:size(eEPSC.ratio,1)
    plot(1:5,eEPSC.ratio(i,:),'*');
end
errorbar(1:5,mean(eEPSC.ratio,1),std(eEPSC.ratio,1)/sqrt(size(eEPSC.ratio,1)))
title('LED induced PPR')
xlabel('Pulse number')
ylabel('eEPSCn/ePSC1')
set(gca,'XTick',[0 1 2 3 4 5])
