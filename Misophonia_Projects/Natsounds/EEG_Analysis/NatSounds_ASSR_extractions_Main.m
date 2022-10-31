%% EXTRACTION OF ASSR AMPLITUDE %% 

clc;clear; % Cleans up workspace

% Load Files
cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/'); % Navigates to appropriate folder
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    SubFiles = getfilesindir(pwd, '*FFT_Amplitude_AveragedTrials_*_AllConditions.mat'); % Grabs all the ASSR time bins
    for ii = 1:size(SubFiles) % Loops through all timebins
        load(getfilesindir(pwd, SubFiles(ii,:))) % Loads current ASSR for time window
        ConditionNames = fieldnames(AllAmps); % Creates vector for conditions
        for iii = 1:size(ConditionNames) % Loop through all conditions
            ASSR_AllConditions(:,:,ii,iii,i) =  AllAmps.([ConditionNames{iii}]); % Saves subject's ASSR in a sensor x frequency x timebin x condition x subject array
        end 
    end
    cd('..') % Moves out of the current selected folder 
end

% Insert Frequency bin and sensor information here
freqbin = [9]; % Vector for frequency bin of interest
sensors = [118]; % Vector for sensors

% Clean Up
clearvars -except freqbin sensors ASSR_AllConditions

% Plot ASSR Data
[GrandAverage_ASSR, GrandAverage_ASSR_se, GrandAverage_ASSR_AllConditions, GrandAverage_ASSR_AllConditions_se] = Natsounds_ASSR_Plots(ASSR_AllConditions, sensors);

% Examine ASSR Data
[sensors] = Natsounds_ASSR_contrast_tests(ASSR_AllConditions, sensors, freqbin);

% ASSR Data Extraction
[ASSR_0to1, ASSR_1to2, ASSR_2to3, ASSR_3to4, ASSR_4to5, ASSR_5to6] = Natsounds_ASSR_extraction(ASSR_AllConditions, sensors, freqbin);

% Clean Up
clearvars -except sensors freqbin ASSR_AllConditions ASSR_0to1 ASSR_1to2 ASSR_2to3 ASSR_3to4 ASSR_4to5 ASSR_5to6 GrandAverage_ASSR GrandAverage_ASSR_se GrandAverage_ASSR_AllConditions GrandAverage_ASSR_AllConditions_se

%% F CONTRAST MAPS & MASS PERMUTATION TESTS %% 

% Model weights
ModelW = [-2 -1 0 3];

% Extraction function
[QFmaxprime] = Natsounds_ASSR_Fmaps(ASSR_AllConditions, ModelW, freqbin);

clearvars -except ASSR_AllConditions QFmaxprime