function [mean_Hilbert] = Natsounds_Hilbert_extraction(Hilbert_AllConditions, Times_in_ms, sensors);

Hilbert_AllConditions = squeeze(Hilbert_AllConditions(sensors,:,:,:)); % Only grab Hilbert from predefined sensors

% Convert ms time to sample points
taxis = -600:2:6000; % Create time axis
BeginWin = Times_in_ms(1,1); % Beginning on interval
EndWin = Times_in_ms(1,end); % end of interval
BeginWin = find(taxis == BeginWin); % Find sample point corresponding to ms of interest
EndWin = find(taxis == EndWin); % Find sample point corresponding to ms of interest
TimePoints = BeginWin:EndWin; % Compute sample points for specified time window

% Extract Hilbert data
for i = 1:size(Hilbert_AllConditions,3) % Loops through each participant
    for ii = 1:size(Hilbert_AllConditions,2) % Loops through each condition for each participant
        mean_Hilbert(i,ii) = mean(Hilbert_AllConditions(TimePoints, ii, i)); % Extracts mean Hilbert data for time interval
    end
end
end 