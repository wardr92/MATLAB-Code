function [] = Natsounds_Prepare_4_ASSR(AllSubs)
% Move .App.AllConditions.mat files for each subject in AllSubs into a new
% folder in "ASSR" directory.

% AllSubs = filename(s) of subjects for input

ASSR = '/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'; % Creates path for analysis folder
DataPath = '/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/PreProcessing'; % Creates path where raw data is
cd(DataPath);  % Moves to correct folder
for i = 1:size(AllSubs,1) % Loops through subject folders
    Subject = AllSubs(i,:); % Creates string of subject #
    cd(ASSR) % Moves to new analysis folder
    mkdir(Subject) % Creates new folder based on subject #
    cd(DataPath) % Moves to Data folder
    cd(AllSubs(i,:)); % Moves into subject folder
    SubFolderPath = strcat(ASSR, '/', Subject, '/'); % Creates path for individual subject in new analysis folder
    MatFile = dir(fullfile('*_App_AllConditions.mat')); % Grabs file(s) of interest
    copyfile(fullfile(pwd, MatFile.name), fullfile(SubFolderPath, MatFile.name)); % Copies & pastes file to new folder
    cd('..') % Moves out of current folder
end
fprintf(['\n Script Finished \n'])

end

