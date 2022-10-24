function [Hilbert_AllConditions, QFmaxprime, QFmaxprime_change] = generaudi_Hilbert_Fmaps(Hilbert_AllConditions, Time_in_ms, AllNothing, AllNothing_Change, Generalization, Generalization_Change, Sharpening, Sharpening_Change)

% Convert ms time to saple points
taxis = -600:2:3000; % Create time axis
BeginWin = Times_in_ms(1,1); % Beginning on interval
EndWin = Times_in_ms(1,end); % end of interval
BeginWin = (BeginWin/1000)*500; % Convert to sample points
EndWin = (EndWin/1000)*500; % Convert to sample points 
TimePoints = BeginWin:EndWin; % Compute sample points for specified time window

% Extract Hilbert data for predefined time window
for i = 1:size(Hilbert_AllConditions,4) % Loops through each participant
    for ii = 1:size(Hilbert_AllConditions,3) % Loops through each condition for each participant
        mean_Hilbert(:,:,ii,i) = mean(Hilbert_AllConditions(:, TimePoints, ii, i),2); % Extracts mean Hilbert data for time interval
    end
end

% Set up for topo map contrasts
repeatmat = squeeze(mean_Hilbert); % Rename variable and squeeze
repeatmat_change = repeatmat(:,4:6,:) - repeatmat(:,1:3,:); % Compute change score 
repeatmat = permute(repeatmat, [1 3 2]); % Re-arranges dimensions into time x sub x condition array
repeatmat_change = permute(repeatmat_change, [1 3 2]); % Re-arranges dimensions into time x sub x condition array
AllModels = [AllNothing; Generalization; Sharpening];
AllModels_Change = [AllNothing_Change; Generalization_Change; Sharpening_Change];
Filename = {'All-Nothing_Model'; 'Generalization_Model'; 'Sharpening_Model'}; % Save filenames for plotting Fcontmats
clearvars -except repeatmat repeatmat_change AllModels AllModels_Change Filename

% Loop through all models to compute F-contrast Maps
for iii = 1:size(AllModels,1) % Loops through all models
    weights = AllModels(iii,:); % Grab current model weights
    [Fcontmat,rcontmat,MScont,MScs, dfcs] = contrast_rep(repeatmat,weights); % Runs contrasts across all sensors with full model
    SaveAvgFile(strcat('Fcontmat_', Filename{iii}, '_6_Conditions.atg'),Fcontmat); % Saves F contrasts
    weights_change = AllModels_Change(iii,:); % Grab current model weights for change scores
    [Fcontmat,rcontmat,MScont,MScs, dfcs] = contrast_rep(repeatmat_change,weights_change); % Runs contrasts across all sensors with change model
    SaveAvgFile(strcat('Fcontmat_', Filename{iii}, '_3_Conditions.atg'),Fcontmat); % Saves F contrasts
end
   
% Compute permutation distribution for F critical value
for iv = 1:8000 % Loops through a set number of permutations
    repeatmat_draw = repeatmat; % Creates temporary variable for repeatmat
    repeatmat_change_draw = repeatmat_change; % Creates temporary variable for repeatmat_change
    for v = 1:size(repeatmat,2) % Loops through each subject's repeatmat 
        randomorder = randperm(6); % Creates randomized order for full 6 condition model
        randomorder_change = randperm(3); % Creates randomized order for 3 change condition model
        repeatmat_draw(:, v, :) = repeatmat(:, v, randomorder); % Runs permutation on all 6 conditions in full model
        repeatmat_change_draw(:, v, :) = repeatmat_change(:, v, randomorder_change); % Runs permutation on 3 conditions of change model 
    end
    RandomModel = randi(size(AllModels,1)); % Selects a random row index (i.e., weights) from AllModels
    weights =  AllModels(RandomModel,:); % Assigns randomly selected model weights
    [Fcontmat,rcontmat,MScont,MScs, dfcs] = contrast_rep(repeatmat_draw,weights); % F contrast for full 6 conditions
    temp = sort(Fcontmat, 'descend'); % Sorts F values by largest to lowest
    Fmaxprime(iv) = temp(3); % Saves 3rd highest F value
    RandomModel_Change = randi(size(AllModels_Change,1)); % Selects a random row index (i.e., weights) from AllModels_Change
    weights_change = AllModels_Change(RandomModel_Change,:); % Assigns randomly selected model weights for change scores
    [Fcontmat,rcontmat,MScont,MScs, dfcs] = contrast_rep(repeatmat_change_draw,weights_change); % F contrast for 3 change conditions
    temp = sort(Fcontmat, 'descend'); % Sorts F values by largest to lowest
    Fmaxprime_change(iv) = temp(3); % Saves 3rd highest F value
end 
clearvars -except Fmaxprime Fmaxprime_change % Clean up

% Plot F critical values
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
subplot(2,1,1); % Begins subplotting FmaxPrime for all 6 conditions
hist(Fmaxprime,100);
QFmaxprime = quantile(Fmaxprime, 0.95);
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('F value'), ylabel('Count'); % Applies labels to x and y axes 
xline(QFmaxprime,'-k',{(QFmaxprime)}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = char('Full 6 Condition Model'); 
title({ptitle}, 'Interpreter','none') 
subplot(2,1,2); % Begins subplotting FmaxPrime for 3 change conditions
hist(Fmaxprime_change,100);
QFmaxprime_change = quantile(Fmaxprime_change, 0.95);
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('F value'), ylabel('Count'); % Applies labels to x and y axes 
xline(QFmaxprime_change,'-k',{(QFmaxprime_change)}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = char('3 Change Condition Model'); 
title({ptitle}, 'Interpreter','none') 
sgtitle({'F Permutation Testing Over All Sensors'}, 'FontSize', 30)

end 