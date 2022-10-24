function [mean_Hilbert] = generaudi_Hilbert_extraction(Hilbert_AllConditions, Times_in_ms, sensors)

Hilbert_AllConditions = squeeze(mean(Hilbert_AllConditions(sensors,:,:,:))); % Only grab Hilbert from predefined sesnors

% Convert ms time to saple points
taxis = -600:2:3000; % Create time axis
BeginWin = Times_in_ms(1,1); % Beginning on interval
EndWin = Times_in_ms(1,end); % end of interval
BeginWin = (BeginWin/1000)*500; % Convert to sample points
EndWin = (EndWin/1000)*500; % Convert to sample points 
TimePoints = BeginWin:EndWin; % Compute sample points for specified time window

% Extract Hilbert data
for i = 1:size(Hilbert_AllConditions,3) % Loops through each participant
    for ii = 1:size(Hilbert_AllConditions,2) % Loops through each condition for each participant
        mean_Hilbert(i,ii) = mean(Hilbert_AllConditions(TimePoints, ii, i)); % Extracts mean Hilbert data for time interval
    end
end
end 
