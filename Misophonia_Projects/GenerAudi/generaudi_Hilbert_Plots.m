function [GrandAverage_Hilbert, GrandAverage_Hilbert_se, GrandAverage_Hilbert_AllConditions, GrandAverage_Hilbert_AllConditions_se, GrandAverage_Hilbert_Change, GrandAverage_Hilbert_Change_se] = generaudi_Hilbert_Plots(Hilbert_AllConditions, sensors)

% Only grab from predefined sensors 
Hilbert_AllConditions = squeeze(mean(Hilbert_AllConditions(sensors,:,:,:))); % Only grab Hilbert from predefined sesnors

% Grand Average 
GA_AveragedConditions = squeeze(mean(Hilbert_AllConditions,2)); % Create grand average Hilbert across all conditions for each subject
GrandAverage_Hilbert_se = (std(GA_AveragedConditions')/sqrt(size(GA_AveragedConditions,2)))'; % Creates standard error for grand mean hilbert vector for each time point
GrandAverage_Hilbert = mean(GA_AveragedConditions,2); % Averages across all participants to create a single vector for grand average Hilbert for each condition

% Condition Grand Averages
GrandAverage_Hilbert_AllConditions = mean(Hilbert_AllConditions, 3); % Averages across all participants to create a single vector for grand average Hilbert for each condition
for i = 1:size(Hilbert_AllConditions,2) % SE for each condition
    GrandAverage_Hilbert_AllConditions_se(:,i) = std(squeeze(Hilbert_AllConditions(:,i,:))')/sqrt(size(Hilbert_AllConditions,3)); % Creates standard error for grand mean by condition pupil vector
end

% Change Score Condition Grand Averages
Hilbert_Change = Hilbert_AllConditions(:,4:6,:) - Hilbert_AllConditions(:,1:3,:); % Compute change score
GrandAverage_Hilbert_Change = mean(Hilbert_Change,3); % Averages across participants to create Grand Average for each condition's change
for ii = 1:size(Hilbert_Change,2) % SE for each condition
    GrandAverage_Hilbert_Change_se(:,ii) = std(squeeze(Hilbert_Change(:,ii,:))')/sqrt(size(Hilbert_Change,3)); % Creates standard error for grand mean by condition pupil vector
end

% Plot Grand Average Hilbert Response
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:3000; % Creates a time axis
plot(taxis, GrandAverage_Hilbert); 
shadedErrorBar(taxis, GrandAverage_Hilbert, GrandAverage_Hilbert_se);
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude'); % Apply labels to x and y axes 
xlim([-600,3000])
title ('Grand Average Hilbert Response');

% Plot Grand Average by Condition Responses
fig2 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:3000; % Creates a time axis
hold on
%plot(taxis, GrandAverage_Hilbert_AllConditions(:,1), '-g'); % 
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,1), GrandAverage_Hilbert_AllConditions_se(:,1),'lineprops', '-k', 'transparent', 1); % Plot CS+ Hab
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,2), GrandAverage_Hilbert_AllConditions_se(:,2),'lineprops', '-c', 'transparent', 1); % Plot GS1 Hab
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,3), GrandAverage_Hilbert_AllConditions_se(:,3),'lineprops', '-y', 'transparent', 1); % Plot GS2 Hab
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,4), GrandAverage_Hilbert_AllConditions_se(:,4), 'lineprops', '-r', 'transparent', 1); % Plot CS+ Acq
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,5), GrandAverage_Hilbert_AllConditions_se(:,5), 'lineprops', '-b', 'transparent', 1); % Plot GS1 Acq
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,6), GrandAverage_Hilbert_AllConditions_se(:,6), 'lineprops', '-g', 'transparent', 1); % Plot GS2 Acq
hold off
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude'); % Apply labels to x and y axes 
xlim([-600,3000])
title ('Grand Average Hilbert Response by Condition');

% Plot Grand Average by Condition Change Responses
fig3 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:3000; % Creates a time axis
hold on
%plot(taxis, GrandAverage_Hilbert_AllConditions(:,1), '-g'); % 
shadedErrorBar(taxis, GrandAverage_Hilbert_Change(:,1), GrandAverage_Hilbert_Change_se(:,1), 'lineprops', '-r', 'transparent', 1); % Plot CS+ Acq
shadedErrorBar(taxis, GrandAverage_Hilbert_Change(:,2), GrandAverage_Hilbert_Change_se(:,2), 'lineprops', '-b', 'transparent', 1); % Plot GS1 Acq
shadedErrorBar(taxis, GrandAverage_Hilbert_Change(:,3), GrandAverage_Hilbert_Change_se(:,3), 'lineprops', '-g', 'transparent', 1); % Plot GS2 Acq
hold off
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude'); % Apply labels to x and y axes 
xlim([-600,3000])
title ('Grand Average Hilbert Response by Condition Change');