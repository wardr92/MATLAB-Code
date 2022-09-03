function [] = Natsounds_SingleSubjects_RawFFT(AllSubs, timewinSP)
% Compute FFT Transformations on specified subject files using their
% ".at.ar" files and additional input parameters

% AllSubs = filename(s) of subjects for input
% timewinSP = the time windows of interest in sample points (6 x length array)

ASSR = '/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'; % Creates path for analysis folder
DataPath = '/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/PreProcessing'; % Creates path where raw data is
cd(DataPath); % Moves into the PreProcessing Folder
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    Subject = AllSubs(i,:); % Creates string of subject #
    SubFolderPath = strcat(ASSR, '/', Subject, '/'); % Creates path for individual subject in new analysis folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    get_FFT_atg(pwd, [timewinSP(1,:)]); % Transforms all .ar files in the folder into .spec files
    First = dir(fullfile(pwd, '*.E1.at*.spec')); % Create a vector with all ASSRs for first time bin
    for ii = 1:size(First,1) % Loop through all conditions
        name = First(ii).name; % Grab the name of the file
        name_f = name(1:15); % Change name
        name_l = name(end-11:end); % Change name
        name = strcat(name_f, name_l); % Change name
        name = strrep(name, '.at', '.1stTimeBin.at'); % Renames file
        movefile(fullfile(pwd, First(ii).name), fullfile(pwd, name)); % Saves renamed file
    end 
    get_FFT_atg(pwd, [timewinSP(2,:)]); % Transforms all .ar files in the folder into .spec files
    Second = dir(fullfile(pwd, '*.E1.at*.spec')); % Create a vector with all ASSRs for second time bin
    for ii = 1:size(Second,1) % Loop through all conditions
        name = Second(ii).name; % Grab the name of the file
        name_f = name(1:15); % Change name
        name_l = name(end-11:end); % Change name
        name = strcat(name_f, name_l); % Change name
        name = strrep(name, '.at', '.2ndTimeBin.at'); % Renames file
        movefile(fullfile(pwd, Second(ii).name), fullfile(pwd, name)); % Saves renamed file
    end 
    get_FFT_atg(pwd, [timewinSP(3,:)]); % Transforms all .ar files in the folder into .spec files
    Third = dir(fullfile(pwd, '*.E1.at*.spec')); % Create a vector with all ASSRs for third time bin 
    for ii = 1:size(Third,1) % Loop through all conditions
        name = Third(ii).name; % Grab the name of the file
        name_f = name(1:15); % Change name
        name_l = name(end-11:end); % Change name
        name = strcat(name_f, name_l); % Change name
        name = strrep(name, '.at', '.3rdTimeBin.at'); % Renames file
        movefile(fullfile(pwd, Third(ii).name), fullfile(pwd, name)); % Saves renamed file
    end
    get_FFT_atg(pwd, [timewinSP(4,:)]); % Transforms all .ar files in the folder into .spec files
    Fourth = dir(fullfile(pwd, '*.E1.at*.spec')); % Create a vector with all ASSRs for fourth time bin 
    for ii = 1:size(Fourth,1) % Loop through all conditions
        name = Fourth(ii).name; % Grab the name of the file
        name_f = name(1:15); % Change name
        name_l = name(end-11:end); % Change name
        name = strcat(name_f, name_l); % Change name
        name = strrep(name, '.at', '.4thTimeBin.at'); % Renames file
        movefile(fullfile(pwd, Fourth(ii).name), fullfile(pwd, name)); % Saves renamed file
    end 
    get_FFT_atg(pwd, [timewinSP(5,:)]); % Transforms all .ar files in the folder into .spec files
    Fifth = dir(fullfile(pwd, '*.E1.at*.spec')); % Create a vector with all ASSRs for fifth time bin 
    for ii = 1:size(Fifth,1) % Loop through all conditions
        name = Fifth(ii).name; % Grab the name of the file
        name_f = name(1:15); % Change name
        name_l = name(end-11:end); % Change name
        name = strcat(name_f, name_l); % Change name
        name = strrep(name, '.at', '.5thTimeBin.at'); % Renames file
        movefile(fullfile(pwd, Fifth(ii).name), fullfile(pwd, name)); % Saves renamed file
    end 
    get_FFT_atg(pwd, [timewinSP(6,:)]); % Transforms all .ar files in the folder into .spec files
    Sixth = dir(fullfile(pwd, '*.E1.at*.spec')); % Create a vector with all ASSRs for sixth time bin 
    for ii = 1:size(Sixth,1) % Loop through all conditions
        name = Sixth(ii).name; % Grab the name of the file
        name_f = name(1:15); % Change name
        name_l = name(end-11:end); % Change name
        name = strcat(name_f, name_l); % Change name
        name = strrep(name, '.at', '.6thTimeBin.at'); % Renames file
        movefile(fullfile(pwd, Sixth(ii).name), fullfile(pwd, name)); % Saves renamed file
    end 
    MatFile = dir(fullfile('*.ar.spec')); % Grabs file(s) of interest
    for ii = 1:size(MatFile,1) % Loops through MatFiles
        copyfile(fullfile(pwd, MatFile(ii).name), fullfile(SubFolderPath, MatFile(ii).name)); % Copies & pastes file to new folder
    end
    cd('..') % Moves out of the current selected folder
    fprintf(['\n FFT complete for ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
end 
fprintf(['\n Script Finished \n'])
end 

%% ===== CALLED FUNCTIONS BELOW ===== %%

function [spec] = get_FFT_atg(folder, timewinSP)

infilemat = dir([folder '/*.at*.ar']); 
%infilemat = dir([folder '/*.mat']); 

for fileindex = 1:size(infilemat,1)
    
    [AvgMat,File,Path,FilePath,NTrialAvgVec,StdChanTimeMat,...
	SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec] = ReadAvgFile(infilemat(fileindex).name);
   
%limit time series to desired interval (timewinSP) and then apply cosine
%square window
  
    AvgMat = AvgMat(:,timewinSP); 
   
     AvgMat = AvgMat .* cosinwin(20,size(AvgMat,2), size(AvgMat,1));  
  
    NFFT = size(AvgMat,2); 
	NumUniquePts = ceil((NFFT+1)/2); 
	fftMat = fft(AvgMat', NFFT);  % transpose: channels as columns (fft columnwise)
	Mag = abs(fftMat);                                                   %  calculate Amplitude
	Mag = Mag*2;   
	
	Mag(1) = Mag(1)/2;                                                    % DC trat aber nicht doppelt auf
	if ~rem(NFFT,2),                                                    % Nyquist Frequency not twice
        Mag(length(Mag))=Mag(length(Mag))/2;
	end
	
	Mag=Mag/NFFT; % scale FFT 
    
    Mag = Mag'; 
    
    spec = Mag(:,1:round(NFFT./2)); 
    
    fsmapnew = 1000./(SampRate./NFFT);
    
    [File,Path,FilePath]=SaveAvgFile([infilemat(fileindex).name '.spec'],spec,NTrialAvgVec,StdChanTimeMat, fsmapnew);
	
end
end 