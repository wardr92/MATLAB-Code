%% EXTRACTION OF HILBERT TRANSFORMED AMPLITUDE %% 

clc;clear; % Cleans up workspace

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/GenerAudi/ASSR/HilbertTransformed'); % Navigates to appropriate folder

% NOTE: conditions are ordered as: CS+ Hab, GS1 Hab, GS2 Hab, CS+ Acq, GS1 Acq, and GS2 Acq.

% Load Files
load('AllSubs_HilbertTransform_Smoothed_bslCorrected_Power_AllConditions.mat'); % Loads each subject's Hilbert power across all conditions
Hilbert_AllConditions = AllSubs_PowerSmoothed_bslCorrected_AllCondition; % Rename variable

% Insert sensor information here
sensors = [5,6,11,12]; % Vector for sensors

% Clean Up
clearvars -except Hilbert_AllConditions sensors

% Plot Hilbert Data
[GrandAverage_Hilbert, GrandAverage_Hilbert_se, GrandAverage_Hilbert_AllConditions, GrandAverage_Hilbert_AllConditions_se, GrandAverage_Hilbert_Change, GrandAverage_Hilbert_Change_se] = generaudi_Hilbert_Plots(Hilbert_AllConditions, sensors);

% Examine Hilbert Data
[sensors] = generaudi_Hilbert_contrast_tests(Hilbert_AllConditions, sensors);

% Clean Up
clearvars -except Hilbert_AllConditions sensors GrandAverage_Hilbert GrandAverage_Hilbert_se GrandAverage_Hilbert_AllConditions GrandAverage_Hilbert_AllConditions_se mean_Hilbert

%% EXTRACT HILBERT TRANSFORMED AMPLITUDE %% 

% Extract Hilbert Data
Times_in_ms = [500:2500]; % Insert time window in ms you wish to extract Hilbert data from

% Hilbert Data Extraction
[mean_Hilbert] = generaudi_Hilbert_extraction(Hilbert_AllConditions, Times_in_ms, sensors);

% Clean Up
clearvars -except Hilbert_AllConditions sensors mean_Hilbert

%% MODEL AND CHANGE SCORE COMPUTATIONS FOR HILBERT TRANSFORMED AMPLITUDE %% 

ASSR_Data = []; % Should be a number of subejects x 6 array

% CS+, GS1, and GS2 model trends
generalization = [1 0.75 -1.75];
sharpening = [1 -1.5 .5];
allnothing = [2 -1 -1];

% Extraction function
[ASSR_Model_Scores, ASSR_Raw_Change, ASSR_Model_Change] = ASSR_Output(ASSR_Data, generalization, sharpening, allnothing);

% Clean Up
clearvars -except Hilbert_AllConditions sensors ASSR_Model_Scores ASSR_Raw_Change ASSR_Model_Change ASSR_Data

%% F CONTRAST MAPS & MASS PERMUTATION TESTS %% 

Times_in_ms = [500:2500]; % Insert time window in ms you wish to extract Hilbert data from

% Model weights
AllNothing = [-1 -1 -1 5 -1 -1];
AllNothing_Change = [2 -1 -1];
Generalization = [-2 -2 -2 3 2.5 0.5];
Generalization_Change = [1 0.75 -1.75];
Sharpening = [1 1 1 -2 0.5 -1.5];
Sharpening_Change = [-1 1.5 -0.5];

% Extraction function
[Hilbert_AllConditions, QFmaxprime, QFmaxprime_change] = generaudi_Hilbert_Fmaps(Hilbert_AllConditions, Time_in_ms, AllNothing, AllNothing_Change, Generalization, Generalization_Change, Sharpening, Sharpening_Change);

clearvars -except Hilbert_AllConditions QFmaxprime QFmaxprime_change