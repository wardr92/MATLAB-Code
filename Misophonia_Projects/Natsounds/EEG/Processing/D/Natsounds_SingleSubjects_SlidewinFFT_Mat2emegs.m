function [] = Natsounds_SingleSubjects_SlidewinFFT_Mat2emegs(AllSubs, cyclelength)
% Convert FFT on sliding window data into emegs format for specified
% subject files using their "FFT_Amplitude*AllConditions.mat" files and 
% additional input parameters

% AllSubs = filename(s) of subjects for input
% cyclelength = length of each cycle segments (wavelength X the number of cycles)

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Move to correct folder
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    AmpTimes = getfilesindir(pwd, '*Slidewin_FFT_Amplitude_AveragedTrials*AllConditions.mat'); % Grabs all the Amp time bins
    for ii = 1:size(AmpTimes) % Loops through all time bins
        load(getfilesindir(pwd, AmpTimes(ii,:))) % Loads current ASSR time Amp
        AveragedTrials = AllAmps; % Changes AllAmps name
        Conditions = fieldnames(AveragedTrials); % Creates vector for conditions
        for iii = 1:size(Conditions) % Loops through all conditions 
            AllConAmp_AveragedTrials(:,:,iii) = AveragedTrials.(Conditions{iii,1}); % Matrix of current condition's Amps on FFTs for averaged trials, save for later
            ConditionAmp_AveragedTrials = AveragedTrials.(Conditions{iii,1}); % Saves the current condition's Amps for FFTs on the averaged trials
            AveragedTrialsName = char(strcat(AllSubs(i,:), '_Slidewin_FFT_Amplitude_AveragedTrials_', AmpTimes(ii,52:62), '_', Conditions(iii,1), '.at', (cellfun(@(v) v(end), Conditions(iii))))); % Assigns new variable name
            SaveAvgFile(AveragedTrialsName, ConditionAmp_AveragedTrials,[],[], cyclelength,[],[],[],[],1); % Saves AveragedTrials FFT as a .at file
        end
        AllConAmp_AveragedTrials = mean(AllConAmp_AveragedTrials,3); % Averaged across all conditions
        AveragedTrialsName = char(strcat(AllSubs(i,:), '_Slidewin_FFT_Amplitude_AveragedTrials_', AmpTimes(ii,52:62), '_AllConditions.at')); % Assigns new variable name
        SaveAvgFile(AveragedTrialsName, AllConAmp_AveragedTrials,[],[], cyclelength,[],[],[],[],1); % Saves AveragedTrials FFT as a .at file
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
%   ?? Copyright 2005 Markus Junghoefer & Peter Peyk                            
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
