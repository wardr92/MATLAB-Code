function [] = Natsounds_GrandAverage_SlidewinSNR_Mat2emegs()
% Compute grand averages for all subjects 

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Move to correct folder
clc;clear % Cleans up workspace
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
i = 1; % Moves into first subject folder to grab Conditions file
cd(AllSubs(i,:)); % Moves into the current selected folder
load(getfilesindir(pwd, '*Slidewin_FFT_Amplitude_AveragedTrials_0-1_seconds_AllConditions.mat')); % Loads the amp structure for averaged FFT on averaged trials
Conditions = fieldnames(AllAmps); % Just did this all to make conditions vector
cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRdb') % Moves to SNRdb folder  
SNRdbTimes = getfilesindir(pwd, '*SNRdb_AveragedTrials*AllConditions.mat'); % Loads the SNRdb time bins
cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRratio') % Moves to SNRratio folder
SNRratioTimes = getfilesindir(pwd, '*SNRratio_AveragedTrials*AllConditions.mat'); % Loads the SNRratio time bins
for ii = 1:size(SNRdbTimes) % Loops through all time bins
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRdb') % Moves to SNRdb folder  
    load(getfilesindir(pwd, [SNRdbTimes(ii,:)])) % Loads current time bin SNRdb
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRratio') % Moves to SNRratio folder
    load(getfilesindir(pwd, SNRratioTimes(ii,:))) % Loads current time bin SNRratio
    for iii = 1:size(Conditions) % Loops through all conditions
        CurrentSNRdb = SNRdb(:,:,iii); % Saves the current condition's SNRdb on averaged trials
        CurrentSNRratio = SNRratio(:,:,iii); % Saves the current condition's SNRdb on averaged trials
        SNRdbName = char(strcat('GrandAverage_Slidewin_FFT_SNRdb_AveragedTrials_', SNRdbTimes(ii,48:59), Conditions(iii), '.at', (cellfun(@(v) v(end), Conditions(iii)))));
        SNRratioName = char(strcat('GrandAverage_Slidewin_FFT_SNRdb_AveragedTrials_', SNRratioTimes(ii,51:62), Conditions(iii), '.at', (cellfun(@(v) v(end), Conditions(iii)))));
        cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRdb') % Moves to SNRdb folder
        SaveAvgFile(SNRdbName, CurrentSNRdb,[],[], 194.1748,[],[],[],[],1); % Saves SNRdb on average trials as a .at file
        cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRratio') % Moves to SNRratio folder
        SaveAvgFile(SNRratioName, CurrentSNRratio,[],[], 194.1748,[],[],[],[],1); % Saves SNRratio on average trials as a .at file
    end
    AllConSNRdb = mean(SNRdb,3); % Averaged across all conditions
    AllConSNRratio = mean(SNRratio,3); % Averaged across all conditions
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRdb') % Moves to SNRdb folder
    SNRdbName = char(strcat('GrandAverage_Slidewin_FFT_SNRdb_AveragedTrials_', SNRdbTimes(ii,48:59), 'AllConditions.at')); % Assigns new variable name
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRratio') % Moves to SNRratio folder
    SNRratioName = char(strcat('GrandAverage_Slidewin_FFT_SNRratio_AveragedTrials_', SNRratioTimes(ii,51:62), 'AllConditions.at')); % Assigns new variable name
    SaveAvgFile(SNRdbName, AllConSNRdb,[],[], 194.1748,[],[],[],[],1); % Saves SNRdb for FFT on averaged trials as a .at file
    SaveAvgFile(SNRratioName, AllConSNRratio,[],[], 194.1748,[],[],[],[],1); % Saves SNRdb for FFT on averaged trials as a .at file
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

function[File,Path,FilePath]=SaveAvgFile(FilePath,AvgMat,NTrialAvgVec,StdChanTimeMat, ...
    SampRate,MedMedRawVec,MedMedAvgVec,EegMegStatus,NChanExtra,TrigPoint,HybridFactor,...
    HybridDataCell,DataTypeVal,EffectDf,ErrorDf)
%	
%	SaveAvgFile - saves data in AvgMat under 'FilePath', using the SCADS format.
%	
%	See also READAVGFILE.                                                       
%	
	
%   EMEGS - Electro Magneto Encephalography Software                           
%   ? Copyright 2005 Markus Junghoefer & Peter Peyk                            
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
%   typicall call: SaveAvgFile(FilePath,AvgMat,[],[], 1,[],[],[],[],1)
if nargin<15; ErrorDf = [];end
if nargin<14; EffectDf = [];end
if nargin<13; DataTypeVal = [];end
if nargin<12; HybridDataCell = [];end
if nargin<11; HybridFactor = []; end
if nargin<10; TrigPoint=[]; end
if nargin<9; NChanExtra=[]; end
if nargin<8; EegMegStatus=[]; end	%1=EEG; 2=MEG
if nargin<7; MedMedAvgVec=[]; end
if nargin<6; MedMedRawVec=[]; end
if nargin<5; SampRate=[]; end
if nargin<4; StdChanTimeMat=[]; end
if nargin<3; NTrialAvgVec=[]; end
if nargin<2; AvgMat=[]; end
if nargin<1; File=[]; Path=[]; FilePath=[]; return; end

if isempty(ErrorDf);  ErrorDf=-1;  end %Unknown
if isempty(EffectDf); EffectDf=-1; end %Unknown
if isempty(DataTypeVal); DataTypeVal=0; end %Unknown
if isempty(HybridDataCell); HybridDataCell=[]; end
if isempty(HybridFactor); HybridFactor=0; end %No Factor
if isempty(EegMegStatus); EegMegStatus=1; end %1=EEG;
if isempty(SampRate); SampRate=1; end
if isempty(NChanExtra); NChanExtra=0; end
if isempty(TrigPoint); TrigPoint=1; end
if isempty(StdChanTimeMat); StdChanTimeMat=ones(size(AvgMat)); end
if isempty(AvgMat); AvgMat=[]; end

if ~isempty(FilePath) & ~ischar(FilePath) & length(size(FilePath))==2 %SaveAvgFile(AvgMat)
    AvgMat=FilePath;
    File=[]; Path=[]; FilePath=[]; 
end
if isempty(FilePath)
    DefPath=SetDefPath('r','*.at');
	[File,Path,FilePath]=WriteFilePath(DefPath,'Choose a file name:');
    if File==0
        File=[]; Path=[]; FilePath=[]; 
        return;
    end
    SetDefPath('w',Path);
else
	[File,Path]=SepFilePath(FilePath);
end

fid=fopen(FilePath,'w','b');
fwrite(fid,'Version','char');
Version=9;
fwrite(fid,Version,'int16');
fwrite(fid,EegMegStatus,'float32');
fwrite(fid,NChanExtra,'float32');
fwrite(fid,TrigPoint,'float32');
fwrite(fid,DataTypeVal,'float32');
fwrite(fid,EffectDf,'float32');
fwrite(fid,ErrorDf,'float32');
SizeAvgMat=size(AvgMat);
fprintf('\nWrite averaged data with %g sensors and %g points to file:\n',SizeAvgMat);
disp(FilePath);
NSizeAvgMat=length(SizeAvgMat);
if NSizeAvgMat>2
	SizeAvgMat=SizeAvgMat(NSizeAvgMat-1:NSizeAvgMat);
end
SizeStdChanTimeMat=size(StdChanTimeMat);
NSizeStdChanTimeMat=length(SizeStdChanTimeMat);
if NSizeStdChanTimeMat>2
	SizeStdChanTimeMat=SizeStdChanTimeMat(NSizeStdChanTimeMat-1:NSizeStdChanTimeMat);
end
fwrite(fid,SizeAvgMat,'float32');
fwrite(fid,AvgMat,'float32');
if ~isempty(NTrialAvgVec)
	fwrite(fid,size(NTrialAvgVec),'float32');
	fwrite(fid,NTrialAvgVec,'float32');
else
	fwrite(fid,[0 0],'float32');
end
if ~isempty(StdChanTimeMat)
	fwrite(fid,SizeStdChanTimeMat,'float32');
	fwrite(fid,StdChanTimeMat,'float32');
else
	NTrials=[];
	fwrite(fid,[0 0],'float32');
end
if ~isempty(SampRate)
	fwrite(fid,size(SampRate),'float32');
	fwrite(fid,SampRate,'float32');
else
	fwrite(fid,[0 0],'float32');
end
if ~isempty(MedMedRawVec)
	fwrite(fid,size(MedMedRawVec),'float32');
	fwrite(fid,MedMedRawVec,'float32');
else
	fwrite(fid,[0 0],'float32');
end
if ~isempty(MedMedAvgVec)
	fwrite(fid,size(MedMedAvgVec),'float32');
	fwrite(fid,MedMedAvgVec,'float32');
else
	fwrite(fid,[0 0],'float32');
end
fwrite(fid,HybridFactor,'float32');
if HybridFactor
    for r=1:HybridFactor
        fwrite(fid,HybridDataCell{r},'float32');
    end
end

fclose(fid);
return;
end
