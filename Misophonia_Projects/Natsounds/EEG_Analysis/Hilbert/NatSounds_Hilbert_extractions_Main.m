%% EXTRACTION OF HILBERT TRANSFORMED AMPLITUDE %% 

clc;clear; % Cleans up workspace

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/HilbertTransformed'); % Navigates to appropriate folder

% NOTE: conditions are ordered as: Miso, Unpl, Plea, Neut.

% Load Files
load('AllSubs_HilbertTransform_Power_AllConditions.mat'); % Loads each subject's Hilbert power across all conditions
Hilbert_AllConditions = AllSubs_Power_AllCondition; % Rename variable

% Insert sensor information here
sensors = [118]; % Vector for sensors

% Clean Up
clearvars -except Hilbert_AllConditions sensors

% Plot Hilbert Data
[GrandAverage_Hilbert, GrandAverage_Hilbert_se, GrandAverage_Hilbert_AllConditions, GrandAverage_Hilbert_AllConditions_se] = Natsounds_Hilbert_Plots(Hilbert_AllConditions, sensors);

% Examine Hilbert Data
[sensors] = Natsounds_Hilbert_contrast_tests(Hilbert_AllConditions, sensors);

% Extract Hilbert Data
Times_in_ms = [1250:5500]; % Insert time window in ms you wish to extract Hilbert data from

% Hilbert Data Extraction
[mean_Hilbert] = Natsounds_Hilbert_extraction(Hilbert_AllConditions, Times_in_ms, sensors);

% Clean Up
clearvars -except Hilbert_AllConditions sensors GrandAverage_Hilbert GrandAverage_Hilbert_se GrandAverage_Hilbert_AllConditions GrandAverage_Hilbert_AllConditions_se mean_Hilbert

%% F CONTRAST MAPS & MASS PERMUTATION TESTS %% 

Times_in_ms = [1250:5500]; % Insert time window in ms you wish to extract Hilbert data from

% Model weights
ModelW = [-2 -1 0 3];

% Extraction function
[Hilbert_AllConditions, QFmaxprime, QFmaxprime_change] = Natsounds_Hilbert_Fmaps(Hilbert_AllConditions, Time_in_ms, ModelW);

clearvars -except Hilbert_AllConditions QFmaxprime QFmaxprime_change
