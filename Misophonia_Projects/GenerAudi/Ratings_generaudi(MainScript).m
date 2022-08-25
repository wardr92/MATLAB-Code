%% Create Valence & Arousal Matrices

% clears workspace and command window
clc; clear

% Paste each variable's respective data into each set of brackets 
% to create # of Participants x 12 matrix
Valence_Raw = [];
Arousal_Raw = [];

%% Create Model Trends

% CS+, GS1, and GS2 model trends
generalization = [1 0.75 -1.75];
sharpening = [1 -1.5 .5];
allnothing = [2 -1 -1];

%% Run Model x Score Comutations

% Valence & Arousal processing function
[Valence_Model_Scores, Arousal_Model_Scores, Valence_Raw_Change, Arousal_Raw_Change, Valence_Model_Change, Arousal_Model_Change] = Valence_Arousal_Output(Valence_Raw, Arousal_Raw, generalization, sharpening, allnothing);

% Combination Score processing function
[Combined_Raw, Combined_Model_Scores, Combined_Raw_Change, Combined_Model_Change] = Combo_Output(Valence_Raw, Arousal_Raw, generalization, sharpening, allnothing);

%% Valence & Arousal Output Function
function[Valence_Model_Scores, Arousal_Model_Scores, Valence_Raw_Change, Arousal_Raw_Change, Valence_Model_Change, Arousal_Model_Change] = Valence_Arousal_Output(Valence_Raw, Arousal_Raw, generalization, sharpening, allnothing)

% Loop through each response (all 12) for all subjects and multiplies
% model weight with raw data

% First for valence
for x = 1:size(Valence_Raw,1)
    generalization_valence(x,1) = generalization * Valence_Raw(x, 1:3)'; % Model x early habituation scores
    generalization_valence(x,2) = generalization * Valence_Raw(x, 4:6)'; % Model x late habituation scores
    generalization_valence(x,3) = generalization * Valence_Raw(x, 7:9)'; % Model x early acquisition scores
    generalization_valence(x,4) = generalization * Valence_Raw(x, 10:12)'; % Model x late acquisition scores
    sharpening_valence(x,1) = sharpening * Valence_Raw(x, 1:3)'; 
    sharpening_valence(x,2) = sharpening * Valence_Raw(x, 4:6)';
    sharpening_valence(x,3) = sharpening * Valence_Raw(x, 7:9)'; 
    sharpening_valence(x,4) = sharpening * Valence_Raw(x, 10:12)';
    allnothing_valence(x,1) = allnothing * Valence_Raw(x, 1:3)';
    allnothing_valence(x,2) = allnothing * Valence_Raw(x, 4:6)'; 
    allnothing_valence(x,3) = allnothing * Valence_Raw(x, 7:9)';
    allnothing_valence(x,4) = allnothing * Valence_Raw(x, 10:12)';
end 

% Next for arousal
for x = 1:size(Arousal_Raw,1)
    generalization_arousal(x,1) = generalization * Arousal_Raw(x, 1:3)'; % Model x early habituation scores
    generalization_arousal(x,2) = generalization * Arousal_Raw(x, 4:6)'; % Model x late habituation scores
    generalization_arousal(x,3) = generalization * Arousal_Raw(x, 7:9)'; % Model x early acquisition scores
    generalization_arousal(x,4) = generalization * Arousal_Raw(x, 10:12)'; % Model x late acquisition scores
    sharpening_arousal(x,1) = sharpening * Arousal_Raw(x, 1:3)'; 
    sharpening_arousal(x,2) = sharpening * Arousal_Raw(x, 4:6)';
    sharpening_arousal(x,3) = sharpening * Arousal_Raw(x, 7:9)'; 
    sharpening_arousal(x,4) = sharpening * Arousal_Raw(x, 10:12)';
    allnothing_arousal(x,1) = allnothing * Arousal_Raw(x, 1:3)';
    allnothing_arousal(x,2) = allnothing * Arousal_Raw(x, 4:6)'; 
    allnothing_arousal(x,3) = allnothing * Arousal_Raw(x, 7:9)';
    allnothing_arousal(x,4) = allnothing * Arousal_Raw(x, 10:12)';
end 

% Saves model scores in a # of Participants x 12 matrix
Valence_Model_Scores = [generalization_valence sharpening_valence allnothing_valence];
Arousal_Model_Scores = [generalization_arousal sharpening_arousal allnothing_arousal];

% Computes raw change scores

% First for valence
Valence_Raw_Change(:, 1:3) = Valence_Raw(:, 7:9) - (Valence_Raw(:, 1:3) + Valence_Raw(:, 4:6))./2;
Valence_Raw_Change(:, 4:6) = Valence_Raw(:, 10:12) - (Valence_Raw(:, 1:3) + Valence_Raw(:, 4:6))./2;

% Next for arousal
Arousal_Raw_Change(:, 1:3) = Arousal_Raw(:, 7:9) - (Arousal_Raw(:, 1:3) + Arousal_Raw(:, 4:6))./2;
Arousal_Raw_Change(:, 4:6) = Arousal_Raw(:, 10:12) - (Arousal_Raw(:, 1:3) + Arousal_Raw(:, 4:6))./2;

% Loop through each response change score (all 6) for all subjects 
% and multiplies model weight with change score data

% First for valence
for x = 1:size(Valence_Raw_Change,1)
    generalization_valence_change(x,1) = generalization * Valence_Raw_Change(x, 1:3)'; % Model x early change scores
    generalization_valence_change(x,2) = generalization * Valence_Raw_Change(x, 4:6)'; % Model x late change scores
    sharpening_valence_change(x,1) = sharpening * Valence_Raw_Change(x, 1:3)';
    sharpening_valence_change(x,2) = sharpening * Valence_Raw_Change(x, 4:6)'; 
    allnothing_valence_change(x,1) = allnothing * Valence_Raw_Change(x, 1:3)'; 
    allnothing_valence_change(x,2) = allnothing * Valence_Raw_Change(x, 4:6)'; 
end

% Next for arousal
for x = 1:size(Arousal_Raw_Change,1)
    generalization_arousal_change(x,1) = generalization * Arousal_Raw_Change(x, 1:3)'; % Model x early change scores
    generalization_arousal_change(x,2) = generalization * Valence_Raw_Change(x, 4:6)'; % Model x late change scores
    sharpening_arousal_change(x,1) = sharpening * Arousal_Raw_Change(x, 1:3)';
    sharpening_arousal_change(x,2) = sharpening * Arousal_Raw_Change(x, 4:6)'; 
    allnothing_arousal_change(x,1) = allnothing * Arousal_Raw_Change(x, 1:3)'; 
    allnothing_arousal_change(x,2) = allnothing * Arousal_Raw_Change(x, 4:6)'; 
end

% Saves model change scores in a # of Participants x 6 matrix
Valence_Model_Change = [generalization_valence_change sharpening_valence_change allnothing_valence_change];
Arousal_Model_Change = [generalization_arousal_change sharpening_arousal_change allnothing_arousal_change];

% Only keep necessary variables
clearvars -except Valence_Model_Scores Arousal_Model_Scores Valence_Raw_Change ...
    Arousal_Raw_Change Valence_Model_Change Arousal_Model_Change Valence_Raw ...
    Arousal_Raw generalization sharpening allnothing

end

%% Combination Output Function
function[Combined_Raw, Combined_Model_Scores, Combined_Raw_Change, Combined_Model_Change] = Combo_Output(Valence_Raw, Arousal_Raw, generalization, sharpening, allnothing);

% Checks to make sure valence and arousal data matrices match
if size(Valence_Raw) == size(Arousal_Raw)
    
    % Loop through each response (all 12) for all subjects and computes a
    % combined score
    for x = 1:size(Valence_Raw,1)
        Combined_Raw(x,:) = sqrt((Valence_Raw(x,:).^2) + (Arousal_Raw(x,:).^2));
    end 

    % Loop through each response (all 12) for all subjects and multiplies
    % model weight with combined raw data
    for x = 1:size(Combined_Raw,1)
        generalization_combined(x,1) = generalization * Combined_Raw(x, 1:3)'; % Model x early habituation scores
        generalization_combined(x,2) = generalization * Combined_Raw(x, 4:6)'; % Model x late habituation scores
        generalization_combined(x,3) = generalization * Combined_Raw(x, 7:9)'; % Model x early acquisition scores
        generalization_combined(x,4) = generalization * Combined_Raw(x, 10:12)'; % Model x late acquisition scores
        sharpening_combined(x,1) = sharpening * Combined_Raw(x, 1:3)'; 
        sharpening_combined(x,2) = sharpening * Combined_Raw(x, 4:6)';
        sharpening_combined(x,3) = sharpening * Combined_Raw(x, 7:9)'; 
        sharpening_combined(x,4) = sharpening * Combined_Raw(x, 10:12)';
        allnothing_combined(x,1) = allnothing * Combined_Raw(x, 1:3)';
        allnothing_combined(x,2) = allnothing * Combined_Raw(x, 4:6)'; 
        allnothing_combined(x,3) = allnothing * Combined_Raw(x, 7:9)';
        allnothing_combined(x,4) = allnothing * Combined_Raw(x, 10:12)';
    end 

    % Saves model scores in a # of Participants x 12 matrix
    Combined_Model_Scores = [generalization_combined sharpening_combined allnothing_combined];

    % Computes raw change scores
    Combined_Raw_Change(:, 1:3) = Combined_Raw(:, 7:9) - (Combined_Raw(:, 1:3) + Combined_Raw(:, 4:6))./2;
    Combined_Raw_Change(:, 4:6) = Combined_Raw(:, 10:12) - (Combined_Raw(:, 1:3) + Combined_Raw(:, 4:6))./2;

    % Loop through each response change score (all 6) for all subjects 
    % and multiplies model weight with change score data
    for x = 1:size(Combined_Raw_Change,1)
        generalization_combined_change(x,1) = generalization * Combined_Raw_Change(x, 1:3)'; % Model x early change scores
        generalization_combined_change(x,2) = generalization * Combined_Raw_Change(x, 4:6)'; % Model x late change scores
        sharpening_combined_change(x,1) = sharpening * Combined_Raw_Change(x, 1:3)';
        sharpening_combined_change(x,2) = sharpening * Combined_Raw_Change(x, 4:6)'; 
        allnothing_combined_change(x,1) = allnothing * Combined_Raw_Change(x, 1:3)'; 
        allnothing_combined_change(x,2) = allnothing * Combined_Raw_Change(x, 4:6)'; 
    end

    % Saves model change scores in a # of Participants x 6 matrix
    Combined_Model_Change = [generalization_combined_change sharpening_combined_change allnothing_combined_change];

    % Only keep necessary variables
    clearvars -except Combined_Raw Combined_Model_Scores Combined_Raw_Change ...
        Combined_Model_Change
else 
    fprintf('Valence & Arousal Data Not Correct - Double Check Variables\n')
end
end