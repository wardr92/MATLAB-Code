function  [] = Natsounds_SingleSubjects_SlidewinSNR_Mat2emegs(AllSubs, cyclelength)
% Convert SNR on sliding window data into emegs format for specified
% subject files using their "FFT_SNRdb/ratio*AllConditions.mat" files and 
% additional input parameters

% AllSubs = filename(s) of subjects for input
% cyclelength = length of each cycle segments (wavelength X the number of cycles)

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Moves to correct folder
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    SNRdbTimes = getfilesindir(pwd, '*Slidewin_FFT_SNRdb_AveragedTrials*AllConditions.mat'); % Grabs all the SNRdb time bins
    SNRratioTimes =  getfilesindir(pwd, '*Slidewin_FFT_SNRratio_AveragedTrials*AllConditions.mat'); % Grabs all the SNRratio time bins
    for ii = 1:size(SNRdbTimes) % Loops through all time bins
        load(getfilesindir(pwd, SNRdbTimes(ii,:))) % Loads current time bin SNRdb
        load(getfilesindir(pwd, SNRratioTimes(ii,:))) % Loads current time bin SNRratio
        Conditions = [fieldnames(SNRdb_AveragedTrials), fieldnames(SNRratio_AveragedTrials)]; % Creates vector for conditions
        for iii = 1:size(Conditions) % Loops through all conditions
            SNRdb(:,:,iii) = SNRdb_AveragedTrials.(Conditions{iii,1}); % Matrix of current condition's SNRdb for averaged trials, save for later
            SNRratio(:,:,iii) = SNRratio_AveragedTrials.(Conditions{iii,1}); % Matrix of current condition's SNRratio for averaged trials, save for later
            Current_SNRdb = SNRdb_AveragedTrials.(Conditions{iii,1}); % Saves the current condition's SNRdb on the averaged trials
            Current_SNRratio = SNRratio_AveragedTrials.(Conditions{iii,1}); % Saves the current condition's SNRratio on the averaged trials
            SNRdbName = char(strcat(AllSubs(i,:), '_Slidewin_FFT_SNRdb_AveragedTrials_', SNRdbTimes(ii,48:59), Conditions(iii), '.at', (cellfun(@(v) v(end), Conditions(iii))))); % Assigns new variable name
            SNRratioName = char(strcat(AllSubs(i,:), '_Slidewin_FFT_SNRratio_AveragedTrials_', SNRratioTimes(ii,51:62), Conditions(iii), '.at', (cellfun(@(v) v(end), Conditions(iii))))); % Assigns new variable name
            SaveAvgFile(SNRdbName, Current_SNRdb,[],[], cyclelength,[],[],[],[],1); % Saves SNRdb for averaged trials as a .at file
            SaveAvgFile(SNRratioName, Current_SNRratio,[],[], cyclelength,[],[],[],[],1); % Saves SNRratio for averaged trials as a .at file
        end
        AllConSNRdb = mean(SNRdb,3); % Averaged across all conditions
        AllConSNRratio = mean(SNRratio,3); % Averaged across all conditions
        SNRdbName = char(strcat(AllSubs(i,:), '_Slidewin_FFT_SNRdb_AveragedTrials_', SNRdbTimes(ii,48:59), 'AllConditions.at')); % Assigns new variable name
        SNRratioName = char(strcat(AllSubs(i,:), '_Slidewin_FFT_SNRratio_AveragedTrials_', SNRratioTimes(ii,51:62), 'AllConditions.at')); % Assigns new variable name
        SaveAvgFile(SNRdbName, AllConSNRdb,[],[], cyclelength,[],[],[],[],1); % Saves SNRdb for averaged trials as a .at file
        SaveAvgFile(SNRratioName, AllConSNRratio,[],[], cyclelength,[],[],[],[],1); % Saves SNRratio for averaged trials as a .at file
    end
    fprintf(['\n' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) Complete! \n'])
    cd('..') % Moves out of the current selected folder  
end 
fprintf(['\n Script Finished \n'])

end

%% ===== CALLED FUNCTIONS BELOW ===== %%

function [FileMat,Path,NFiles,FilePathMat]=getfilesindir(Path,InMask);
%	GetFilesInDir
	
%   EMEGS - Electro Magneto Encephalography Software                           
%   © Copyright 2005 Markus Junghoefer & Peter Peyk                            
%   Implemented programs from: Andrea de Cesarei, Thomas Gruber,               
%   Olaf Hauk, Andreas Keil, Olaf Steinstraeter, Nathan Weisz                  
%   and Andreas Wollbrink.                                                     
%                                                                              
%   This program is free software; you can redistribute it and/or              
%   modify it under the terms of the GNU General Public License                
%   as published by the Free Software Foundation; either version 3             
%   of the License, or (at your option) any later version.                     
%                                                                              
%   This program is distributed in the hope that it will be useful,            
%   but WITHOUT ANY WARRANTY; without even the implied warranty of             
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              
%   GNU General Public License for more details.                               
%   You should have received a copy of the GNU General Public License          
%   along with this program; if not, write to the Free Software                
%   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
if nargin<2; InMask=[]; end
if nargin<1; Path=[]; end

if isempty(InMask); InMask='*.*'; end
if isempty(Path)
    Def=SetDefPath('r',InMask);
    [File,Path]=uigetfile(Def,'Pick any file in target directory:');
    if File==0; FileMat=[]; Path=[]; NFiles=0; return; end
    SetDefPath('w',Path)
end
PathMask=[Path,filesep,InMask];
s=dir(PathMask);
if ~strcmp(Path(end),filesep)
    Path=[Path,filesep];
end
NFiles=0;
if size(s,1)==0
    FileMat=[];
    FilePathMat=[];
    NFiles=0;
    return;
end
for i=1:size(s,1);
    Tmp=char(getfield(s,{i},'name'));
    if ~strcmp(Tmp,'.') & ~strcmp(Tmp,'..')
        NFiles=NFiles+1;
        if NFiles==1
            FileMat=char(Tmp);
            FilePathMat=char([Path,Tmp]);
        else
            FileMat=char(FileMat,Tmp);
            FilePathMat=char(FilePathMat,[Path,Tmp]);
        end
    end
end
return;
end