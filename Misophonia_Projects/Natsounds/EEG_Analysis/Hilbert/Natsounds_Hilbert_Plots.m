function [GrandAverage_Hilbert, GrandAverage_Hilbert_se, GrandAverage_Hilbert_AllConditions, GrandAverage_Hilbert_AllConditions_se] = Natsounds_Hilbert_Plots(Hilbert_AllConditions, sensors);

% Only grab from predefined sensors 
Hilbert_AllConditions = squeeze(Hilbert_AllConditions(sensors,:,:,:)); % Only grab Hilbert from predefined sensors

% Grand Average 
GA_AveragedConditions = squeeze(mean(Hilbert_AllConditions,2)); % Create grand average Hilbert across all conditions for each subject
GrandAverage_Hilbert_se = (std(GA_AveragedConditions')/sqrt(size(GA_AveragedConditions,2)))'; % Creates standard error for grand mean hilbert vector for each time point
GrandAverage_Hilbert = mean(GA_AveragedConditions,2); % Averages across all participants to create a single vector for grand average Hilbert for each condition

% Condition Grand Averages
GrandAverage_Hilbert_AllConditions = mean(Hilbert_AllConditions, 3); % Averages across all participants to create a single vector for grand average Hilbert for each condition
for i = 1:size(Hilbert_AllConditions,2) % SE for each condition
    GrandAverage_Hilbert_AllConditions_se(:,i) = std(squeeze(Hilbert_AllConditions(:,i,:))')/sqrt(size(Hilbert_AllConditions,3)); % Creates standard error for grand mean by condition pupil vector
end

% Plot Grand Average Hilbert Response
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:6000; % Creates a time axis
plot(taxis, GrandAverage_Hilbert); 
shadedErrorBar(taxis, GrandAverage_Hilbert, GrandAverage_Hilbert_se);
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude'); % Apply labels to x and y axes 
xlim([-600,6000])
title ('Grand Average Hilbert Response');

% Plot Grand Average by Condition Interpolated Pupil Responses
fig2 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:6000; % Creates a time axis
hold on
plot(taxis, GrandAverage_Hilbert_AllConditions(:,1), '-g'); % Plot Miso
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,1), GrandAverage_Hilbert_AllConditions_se(:,1),'lineprops', '-g', 'transparent', 1);
plot(taxis, GrandAverage_Hilbert_AllConditions(:,2), '-r'); % Plot Unpl
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,2), GrandAverage_Hilbert_AllConditions_se(:,2),'lineprops', '-r', 'transparent', 1);
plot(taxis, GrandAverage_Hilbert_AllConditions(:,3), '-b'); % Plot Plea
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,3), GrandAverage_Hilbert_AllConditions_se(:,3),'lineprops', '-b', 'transparent', 1);
plot(taxis, GrandAverage_Hilbert_AllConditions(:,4), '-k'); % Plot Neut
shadedErrorBar(taxis, GrandAverage_Hilbert_AllConditions(:,4), GrandAverage_Hilbert_AllConditions_se(:,4), 'lineprops', '-k', 'transparent', 1);
hold off
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude'); % Apply labels to x and y axes 
xlim([-600,6000])
title ('Grand Average Hilbert Response by Condition');