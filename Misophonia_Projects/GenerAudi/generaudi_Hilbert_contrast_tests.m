function [sensors] = generaudi_Hilbert_contrast_tests(Hilbert_AllConditions, sensors)

Hilbert_AllConditions = squeeze(mean(Hilbert_AllConditions(sensors,:,:,:))); % Only grab Hilbert from predefined sesnors

% Organize for F contrasts
repmat = permute(Hilbert_AllConditions, [1 3 2]); % Re-arranges dimensions into time x sub x condition array
repmat_hab = repmat(:,:,1:3); % Only use hab trials
repmat_acq = repmat(:,:,4:6);% Only use acq trials
repmat_chg = repmat(:,:,4:6)-repmat(:,:,1:3); % Only use change trials

% Basic F values for All Conditions 
[Fcontmat,rcontmat,MScont,MScs, dfcs]=contrast_rep(repmat,[0 0 0 3 -2 -1]); % Tests F contrast model 

% Plot F-values for full model
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:3000; % Creates a time axis
plot(taxis, Fcontmat); % Plots F-values from model contrasts
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('F-value'); % Apply labels to x and y axes 
xlim([-600,3000])
title ('Hilbert Data - F-test Contrast - All Conditions');

% Basic F values for Acqusition Conditions 
[Fcontmat,rcontmat,MScont,MScs, dfcs]=contrast_rep(repmat_acq,[2 -1 -1]); % Tests F contrast model 

% Plot F-values for full model
fig2 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:3000; % Creates a time axis
plot(taxis, Fcontmat); % Plots F-values from model contrasts
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('F-value'); % Apply labels to x and y axes 
xlim([-600,3000])
title ('Hilbert Data - F-test Contrast - Acquisition Only');

% Basic paired t-tests for change scores
[~, ~, ~, stats_gs1_v_csp] = ttest(repmat_chg(:, 2, :), repmat_chg(:, 1, :), 'Dim', 3); % CS+ vs GS1
[~, ~, ~, stats_gs2_v_csp] = ttest(repmat_chg(:, 3, :), repmat_chg(:, 1, :), 'Dim', 3); % CS+ vs GS2
[~, ~, ~, stats_gs1_v_gs2] = ttest(repmat_chg(:, 2, :), repmat_chg(:, 3, :), 'Dim', 3); % GS1 vs GS2

% Plot t-values
fig3 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:3000; % Creates a time axis
hold on
plot(taxis, stats_gs1_v_csp.tstat); % Plot t-values from CS+ vs GS1
plot(taxis, stats_gs2_v_csp.tstat); % Plot t-values from CS+ vs GS2
plot(taxis, stats_gs1_v_gs2.tstat); % Plot t-values from GS1 vs GS2
hold off
lgd = legend;
legend('CS+ vs GS1','CS+ vs GS2', 'GS1 vs. GS2')
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('t-value'); % Apply labels to x and y axes 
xlim([-600,3000])
title ('Hilbert Data - t-test Contrasts for change scores');

% Basic F values for Change Conditions 
[Fcontmat,rcontmat,MScont,MScs, dfcs]=contrast_rep(repmat_chg,[1 0 -1]); % Tests F contrast model 

% Plot F-values for change score model
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = -600:2:3000; % Creates a time axis
plot(taxis, Fcontmat); % Plots F-values from model contrasts
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('F-value'); % Apply labels to x and y axes 
xlim([-600,3000])
title ('Hilbert Data - F-test Contrast - Change Scores');
