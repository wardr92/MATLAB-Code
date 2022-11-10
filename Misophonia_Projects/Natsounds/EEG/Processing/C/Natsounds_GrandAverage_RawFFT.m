function [] = Natsounds_GrandAverage_RawFFT()
% Compute grand averages for all subjects 

clc;clear % Cleans up workspace
AllMiso = []; % Creates blank array for storing all subjects .spec files
AllUnp = []; % Creates blank array for storing all subjects .spec files
AllNeu = []; % Creates blank array for storing all subjects .spec files
AllPls = []; % Creates blank array for storing all subjects .spec files
cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR')
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    Miso = getfilesindir(pwd, '*.at1.ar.spec'); % Grab misophonia condition
    Unp = getfilesindir(pwd, '*.at2.ar.spec'); % Grab unpleasant condition
    Neu = getfilesindir(pwd, '*.at3.ar.spec'); % Grab neutral condition
    Pls = getfilesindir(pwd, '*.at4.ar.spec'); % Grab pleasant condition
    AllMiso = cat(1, AllMiso, Miso); % Creates final list of .spec files
    AllUnp = cat(1, AllUnp, Unp); % Creates final list of .spec files
    AllNeu = cat(1, AllNeu, Neu); % Creates final list of .spec files
    AllPls = cat(1, AllPls, Pls); % Creates final list of .spec files
    cd('..') % Moves out of the current selected folder  
end
Misophonia_all = AllMiso; % Grand average of misophonia condition
Unpleasant_all = AllUnp; % Grand average of unpleasant condition
Neutral_all = AllNeu; % Grand average of neutral condition
Pleasant_all = AllPls; % Grand average of pleasant condition
AllCons = cat(1, AllMiso, AllUnp, AllPls, AllNeu); % Create grand average condition
cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_RawFFT'); % Moves into grand averages folder
MergeAvgFiles(Misophonia_all, 'GrandAverage_Misophonia_All.spec.at1',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Unpleasant_all, 'GrandAverage_Unpleasant_All.spec.at2',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Pleasant_all, 'GrandAverage_Pleasant_All.spec.at4',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Neutral_all, 'GrandAverage_Neutral_All.spec.at3',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(AllCons, 'GrandAverage_AllConditions_All.spec.at',1,1,[],0,[],[],0,0) % Merges files together with Emegs
First_M = Misophonia_all(1:6:end,:); % Array for first time bin
MergeAvgFiles(First_M, 'GrandAverage_Misophonia_1stTimeBin.spec.at1',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Second_M = Misophonia_all(2:6:end,:); % Array for second time bin
MergeAvgFiles(Second_M, 'GrandAverage_Misophonia_2ndTimeBin.spec.at1',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Third_M = Misophonia_all(3:6:end,:); % Array for third time bin
MergeAvgFiles(Third_M, 'GrandAverage_Misophonia_3rdTimeBin.spec.at1',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fourth_M = Misophonia_all(4:6:end,:); % Array for fourth time bin
MergeAvgFiles(Fourth_M, 'GrandAverage_Misophonia_4thTimeBin.spec.at1',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fifth_M = Misophonia_all(5:6:end,:); % Array for fifth time bin
MergeAvgFiles(Fifth_M, 'GrandAverage_Misophonia_5thTimeBin.spec.at1',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Sixth_M = Misophonia_all(6:6:end,:); % Array for sixth time bin
MergeAvgFiles(Sixth_M, 'GrandAverage_Misophonia_6thTimeBin.spec.at1',1,1,[],0,[],[],0,0) % Merges files together with Emegs
First_U = Unpleasant_all(1:6:end,:); % Array for first time bin
MergeAvgFiles(First_U, 'GrandAverage_Unpleasant_1stTimeBin.spec.at2',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Second_U = Unpleasant_all(2:6:end,:); % Array for second time bin
MergeAvgFiles(Second_U, 'GrandAverage_Unpleasant_2ndTimeTimeBin.spec.at2',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Third_U = Unpleasant_all(3:6:end,:); % Array for third time bin
MergeAvgFiles(Third_U, 'GrandAverage_Unpleasant_3rdTimeBin.spec.at2',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fourth_U = Unpleasant_all(4:6:end,:); % Array for fourth time bin
MergeAvgFiles(Fourth_U, 'GrandAverage_Unpleasant_4thTimeBin.spec.at2',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fifth_U = Unpleasant_all(5:6:end,:); % Array for fifth time bin
MergeAvgFiles(Fifth_U, 'GrandAverage_Unpleasant_5thTimeBin.spec.at2',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Sixth_U = Unpleasant_all(6:6:end,:); % Array for sixth time bin
MergeAvgFiles(Sixth_U, 'GrandAverage_Unpleasant_6thTimeBin.spec.at2',1,1,[],0,[],[],0,0) % Merges files together with Emegs
First_P = Pleasant_all(1:6:end,:); % Array for first time bin
MergeAvgFiles(First_P, 'GrandAverage_Pleasant_1stTimeBin.spec.at4',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Second_P = Pleasant_all(2:6:end,:); % Array for second time bin
MergeAvgFiles(Second_P, 'GrandAverage_Pleasant_2ndTimeBin.spec.at4',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Third_P = Pleasant_all(3:6:end,:); % Array for third time bin
MergeAvgFiles(Third_P, 'GrandAverage_Pleasant_3rdTimeBin.spec.at4',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fourth_P = Pleasant_all(4:6:end,:); % Array for fourth time bin
MergeAvgFiles(Fourth_P, 'GrandAverage_Pleasant_4thTimeBin.spec.at4',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fifth_P = Pleasant_all(5:6:end,:); % Array for fifth time bin
MergeAvgFiles(Fifth_P, 'GrandAverage_Pleasant_5thTimeBin.spec.at4',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Sixth_P = Pleasant_all(6:6:end,:); % Array for sixth time bin
MergeAvgFiles(Sixth_P, 'GrandAverage_Pleasant_6thTimeBin.spec.at4',1,1,[],0,[],[],0,0) % Merges files together with Emegs
First_N = Neutral_all(1:6:end,:); % Array for first time bin
MergeAvgFiles(First_N, 'GrandAverage_Neutral_1stTimeBin.spec.at3',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Second_N = Neutral_all(2:6:end,:); % Array for second time bin
MergeAvgFiles(Second_N, 'GrandAverage_Neutral_2ndTimeBin.spec.at3',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Third_N = Neutral_all(3:6:end,:); % Array for third time bin
MergeAvgFiles(Third_N, 'GrandAverage_Neutral_3rdTimeBin.spec.at3',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fourth_N = Neutral_all(4:6:end,:); % Array for fourth time bin
MergeAvgFiles(Fourth_N, 'GrandAverage_Neutral_4thTimeBin.spec.at3',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Fifth_N = Neutral_all(5:6:end,:); % Array for fifth time bin
MergeAvgFiles(Fifth_N, 'GrandAverage_Neutral_5thTimeBin.spec.at3',1,1,[],0,[],[],0,0) % Merges files together with Emegs
Sixth_N = Neutral_all(6:6:end,:); % Array for sixth time bin
MergeAvgFiles(Sixth_N, 'GrandAverage_Neutral_6thTimeBin.spec.at3',1,1,[],0,[],[],0,0) % Merges files together with Emegs
First = cat(1, First_M, First_U, First_P, First_N); % Combine all first time bins
Second = cat(1, Second_M, Second_U, Second_P, Second_N); % Combine all second time bins
Third = cat(1, Third_M, Third_U, Third_P, Third_N); % Combine all third time bins
Fourth = cat(1, Fourth_M, Fourth_U, Fourth_P, Fourth_N); % Combine all fourth time bins
Fifth = cat(1, Fifth_M, Fifth_U, Fifth_P, Fifth_N); % Combine all fifth time bins
Sixth = cat(1, Sixth_M, Sixth_U, Sixth_P, Sixth_N); % Combine all sixth time bins
MergeAvgFiles(First, 'GrandAverage_AllConditions_1stTimeBin.spec.at',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Second, 'GrandAverage_AllConditions_2ndTimeBin.spec.at',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Third, 'GrandAverage_AllConditions_3rdTimeBin.spec.at',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Fourth, 'GrandAverage_AllConditions_4thTimeBin.spec.at',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Fifth, 'GrandAverage_AllConditions_5thTimeBin.spec.at',1,1,[],0,[],[],0,0) % Merges files together with Emegs
MergeAvgFiles(Sixth, 'GrandAverage_AllConditions_6thTimeBin.spec.at',1,1,[],0,[],[],0,0) % Merges files together with Emegs
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

function[OutFilePath,NormVec]=MergeAvgFiles(InFileMat,OutFilePath,chWeight,chNorm,...
    DefFileMask,CalcBaseStatus,MinBase,MaxBase,PrintGPStatus,AskGuiStatus,LogFileStatus)

%	MergeAvgFiles - averages several SCADS average files, offering options 
%   for weighting and normalization.
%	
%	See also BatchMergeAvgFiles CalcAvgDiff. 
	
%   EMEGS - Electro Magneto Encephalography Software                           
%   ??? Copyright 2005 Markus Junghoefer & Peter Peyk                            
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
%  a typical call: MergeAvgFiles(filemat,'test.atg.ar',1,1,[],0,[],[],0,0)

if nargin<11;LogFileStatus=[];end
if nargin<10;AskGuiStatus=[];end

if isempty(LogFileStatus);LogFileStatus=1;end
if isempty(AskGuiStatus);AskGuiStatus=1;end
if isunix;setappdata(0,'UseNativeSystemDialogs',0);end

if AskGuiStatus
    InfoStr=char('Launch graphical user interface "EmegsGrandMean" instead?'); 
    InfoStr=char(InfoStr,'');
    answer=questdlg(InfoStr,'Launch EmegsGrandMean?','Launch EmegsGrandMean','Launch MergeAvgFiles','Cancel','Launch EmegsGrandMean');
    switch answer,
        case 'Launch EmegsGrandMean'
            EmegsGrandMean;
            return
        case 'Cancel'
            return;
    end
else
    answer = 'Launch MergeAvgFiles';
end
                
if nargin<9; PrintGPStatus=[]; end;
if nargin<8; MaxBase=[]; end;
if nargin<7; MinBase=[]; end;
if nargin<6; CalcBaseStatus=[]; end;
if nargin<5; DefFileMask='*at*'; end;
if nargin<4; chNorm=[]; end;
if nargin<3; chWeight=[]; end;
if nargin<2; OutFilePath=[]; end;
if nargin<1; InFileMat=[]; end;

%==================================================================

[DefFilePath]=SetDefPath('r',DefFileMask);
[DefFile,DefPath]=SepFilePath(DefFilePath)
[DefPath]=SwitchGrandBatch(DefPath,'Grand2Batch',1);
DefFilePath=[DefPath,DefFile]
[NFiles,InFileMat,NonUse,BatchFilePath]=ReadFileNames(InFileMat,DefFilePath,'Choose avg files or batch file:');
if NFiles==0; OutFilePath=[]; return; end
[BatchFile,BatchPath]=SepFilePath(BatchFilePath);
SetDefPath(2,BatchPath);

fprintf('\n\n');
[chWeight]=IfEmptyInputSpecVal(chWeight,[1:3],1,...
'Do you want to use',...
'no weighting                [1]',...
'trial number weighting      [2]',...
'Std matrix weighting        [3]');
fprintf('\n\n');

WeightOptCell = {'no weighting ';'trial number weighting';'Std matrix weighting  '};

[chNorm]=IfEmptyInputSpecVal(chNorm,[1:4],1,...
'Do you want to use',...
'no normalization                     [1]',...
'Norm=mean(mean(sqrt(Data.^2)))       [2]',...
'Norm=mean(mean(Data.^2))             [3]',...
'Norm=mean(mean(Data))                [4]');
fprintf('\n\n');
NormOptCell = {'no normalization';'Norm=mean(mean(sqrt(Data.^2)))';'Norm=mean(mean(Data.^2)) ';'Norm=mean(mean(Data))  '};

[CalcBaseStatus]=IfEmptyInputBo('Calculate a baseline ?',[],CalcBaseStatus,1,0);
fprintf('\n\n');
if CalcBaseStatus & (isempty(MinBase) | isempty(MaxBase))
    [NPointsBaseStatus]=IfEmptyInputBo('Do you want to use','the whole interval as baseline ?',[],0,0);
    fprintf('\n\n');
	if NPointsBaseStatus; 
		MinBase=[]; MaxBase=[]; 
	else
		[MinBase]=IfEmptyInputVal('Please insert the baseline start point:',[],MinBase,16,0);
        fprintf('\n\n');    
		[MaxBase]=IfEmptyInputVal('Please insert the baseline end point:',[],MaxBase,60,0);
        fprintf('\n\n');
    end
elseif CalcBaseStatus & ~isempty(MinBase) & ~isempty(MaxBase)
    NPointsBaseStatus = 0;
end
[PrintGPStatus]=IfEmptyInputBo('Print Global Power','for each file ?',PrintGPStatus,1,0);

if chNorm>1
	NormVec=zeros(NFiles,1);
else
	NormVec=[];
end
OutFile=BatchFile;
Tmp=findstr(lower(OutFile),'batch.');
if ~isempty(Tmp)
	if Tmp==1 & length(OutFile)>5
		OutFile=OutFile(7:length(OutFile));
	elseif Tmp==length(OutFile)-4
		OutFile=OutFile(1:Tmp-1);
	else
		OutFile=OutFile([1:Tmp-1,Tmp+5:length(OutFile)]);
	end
end
Tmp=findstr(lower(OutFile),'batch');
if ~isempty(Tmp)
	if Tmp==1 & length(OutFile)>5
		OutFile=OutFile(7:length(OutFile));
	elseif Tmp==length(OutFile)-4
		OutFile=OutFile(1:Tmp-1);
	else
		OutFile=OutFile([1:Tmp-1,Tmp+5:length(OutFile)]);
	end
end
if length(OutFile)>4
	if strcmp(OutFile(1:4),'Bat.')
		OutFile=OutFile(5:end);
	end
end
if length(OutFile)>3
	if strcmp(OutFile(1:3),'GM.')
		OutFile=OutFile(4:end);
	end
end
if length(OutFile)>4
	if strcmp(OutFile(end-3:end),'.rep')
		OutFile=OutFile(1:end-4);
	end
end
if isempty(OutFilePath)
    [BatchPath]=SwitchGrandBatch(BatchPath,'Batch2Grand',1);
	[OutFile,OutPath,OutFilePath]=WriteFilePath([BatchPath,filesep,'GM.w',int2str(chWeight),'.n',int2str(chNorm),'.',OutFile],'Choose the new file name:');
else
    [OutFile,OutPath]=SepFilePath(OutFilePath);
end

if OutFile==0; fprintf(1,'Bad OutFilePath in MergeAvgFiles !'); return; end
if NFiles<2; return; end
pause(.01)
for FileIndex=1:NFiles
    [File,Path,FilePath]=GetFileNameOfMat(InFileMat,FileIndex);
    [AvgMat,File,Path,FilePath,NTrialAvgVec,StdMat,SampRate,AvgRef,Version,MedMedRawVec,MedMedAvgVec,...
     EegMegStatus,NChanExtra,TrigPoint,HybridFactor,HybridDataCell,DataTypeVal]=ReadAvgFile(FilePath);
    if size(MedMedRawVec,1)==1; MedMedRawVec=MedMedRawVec'; end
    if size(MedMedAvgVec,1)==1; MedMedAvgVec=MedMedAvgVec'; end
    [NChan,NPoints]=size(AvgMat);
    if isempty(NTrialAvgVec); NTrialAvgVec=ones(NChan,1); end
    if length(NTrialAvgVec)~=NChan
        NTrialAvgVec=ones(NChan,1).*mean(NTrialAvgVec);
    end
    if FileIndex==1
        FilePathDef = FilePath;
        NPointsDef = NPoints;
        NChanDef = NChan;
    else
        if NChan~=NChanDef 
            uiwait(errordlg(char(['File nr. ',num2str(FileIndex)],'',FilePath,'',...
                ['has a different number of channels (',num2str(NChan),') than first file'],...
                '',FilePathDef,'', ['which has ',num2str(NChanDef),' channels!']),'Error:')); 
            return
        end
        if NPoints~=NPointsDef 
            uiwait(errordlg(char(['File nr. ',num2str(FileIndex)],'',FilePath,'',...
                ['has a different number of points (',num2str(NPoints),') than first file'],...
                '',FilePathDef,'',['which has ',num2str(NPointsDef),' points!']),'Error:')); 
            return
        end
    end
   
    if CalcBaseStatus
		if NPointsBaseStatus
			MinBase=1; 
			MaxBase=NPoints; 
		end
		fprintf('Subtract baseline interval of points %g - %g.\n\n\n',MinBase,MaxBase);
		AvgMat=CalcBaseline(AvgMat,MinBase,MaxBase);
	else
		fprintf('No baseline subtraction.\n\n\n');
	end
	if chNorm>1
		if chNorm==2
			Norm=mean(mean(sqrt(AvgMat.^2)));
		elseif chNorm==3
			Norm=mean(mean(AvgMat.^2));
        elseif chNorm==4
			Norm=mean(mean(AvgMat));
		end
		AvgMat=AvgMat./Norm;
		NormVec(FileIndex)=Norm;
	end
    if PrintGPStatus
		MaxVec(FileIndex)=max(mean(sqrt(AvgMat.^2)));
	end
	if FileIndex==1; 
		[NChan,NPoints]=size(AvgMat);
		if chWeight==1
			MergeAvgMat=AvgMat;
		elseif chWeight==2
			TotMaxNumberOfTrials=max(NTrialAvgVec);
			MergeAvgMat=TotMaxNumberOfTrials.*AvgMat;
		elseif chWeight==3
			InvMergeStdMat=1./StdMat;
			MergeAvgMat=AvgMat.*InvMergeStdMat; 
		end
		MergeStdMat=StdMat; 
		MergeNTrialAvgVec=NTrialAvgVec;
		MergeMedMedRawVec=MedMedRawVec;
		MergeMedMedAvgVec=MedMedAvgVec;
	else
		if chWeight==1
			MergeAvgMat=MergeAvgMat+AvgMat;
		elseif chWeight==2
			MaxNumberOfTrials=max(NTrialAvgVec);
			fprintf(1,'Maximum number of trials in this file: %g\n\n',MaxNumberOfTrials);
			TotMaxNumberOfTrials=TotMaxNumberOfTrials+MaxNumberOfTrials;
			MergeAvgMat=MergeAvgMat+MaxNumberOfTrials.*AvgMat;
		elseif chWeight==3
			MergeAvgMat=MergeAvgMat+AvgMat./StdMat;
			InvMergeStdMat=InvMergeStdMat+1./StdMat;
		end
%		MergeStdMat=MergeStdMat+StdMat;
		%============If MergeNTrialAvgVec=NTrialAvgVec'=============
		SizeMergeNTrialAvgVec=size(MergeNTrialAvgVec);
		SizeNTrialAvgVec=size(NTrialAvgVec);
		if SizeMergeNTrialAvgVec(2)==SizeNTrialAvgVec(1); NTrialAvgVec=NTrialAvgVec'; end
		MergeNTrialAvgVec=MergeNTrialAvgVec+NTrialAvgVec;
		%============If MergeMedMedRawVec=MedMedRawVec'=============
		SizeMergeMedMedRawVec=size(MergeMedMedRawVec);
		SizeMedMedRawVec=size(MedMedRawVec);
		if SizeMergeMedMedRawVec(2)==SizeMedMedRawVec(1); MedMedRawVec=MedMedRawVec'; end
		MergeMedMedRawVec=[MergeMedMedRawVec;MedMedRawVec];
		%============If MergeMedMedAvgVec=MedMedAvgVec'=============
		SizeMergeMedMedAvgVec=size(MergeMedMedAvgVec);
		SizeMedMedAvgVec=size(MedMedAvgVec);
		if SizeMergeMedMedAvgVec(2)==SizeMedMedAvgVec(1); MedMedAvgVec=MedMedAvgVec'; end
		MergeMedMedAvgVec=[MergeMedMedAvgVec;MedMedAvgVec];
		%==============================================================
	end
end

if chWeight==1
	MergeAvgMat=MergeAvgMat./NFiles;
elseif chWeight==2
	MergeAvgMat=MergeAvgMat./TotMaxNumberOfTrials;
elseif chWeight==3
	MergeAvgMat=MergeAvgMat./InvMergeStdMat;
end
if chNorm>1
    MergeAvgMat=MergeAvgMat.*mean(NormVec);
end
MergeStdMat=MergeStdMat./NFiles;


fprintf('\n\n');
fprintf(1,'Average of %g files done using %g\n',NFiles);
fprintf(1,[NormOptCell{chNorm},' and ']);
fprintf(1,[WeightOptCell{chWeight},'.\n']);

SaveAvgFile(OutFilePath,MergeAvgMat,MergeNTrialAvgVec,MergeStdMat,SampRate,MergeMedMedRawVec,MergeMedMedAvgVec,...
        EegMegStatus,NChanExtra,TrigPoint,HybridFactor,HybridDataCell,DataTypeVal);
SetDefPath('w',OutPath);

if LogFileStatus
    LogFilePath=[OutFilePath,'.log'];
    LogFid = fopen(LogFilePath,'wt');
    fprintf(LogFid,'Average of %g files using %g',NFiles);fprintf(LogFid,' ');
    fprintf(LogFid,[NormOptCell{chNorm},' and ']);
    fprintf(LogFid,[WeightOptCell{chWeight},'. \n']);
    if CalcBaseStatus
        fprintf(LogFid,'Subtracting baseline interval of points %g - %g.',MinBase,MaxBase);fprintf(LogFid,'\n');
    else
        fprintf(LogFid,'No baseline subtraction.');fprintf(LogFid,'\n');
    end
    fprintf(LogFid,['FileMatrix = ']);fprintf(LogFid,'\n');
    for FileIndex=1:NFiles
        [File,Path,FilePath]=GetFileNameOfMat(InFileMat,FileIndex);
        fprintf(LogFid,'%c',FilePath);fprintf(LogFid,'\n');
    end
    fclose(LogFid);
    LogStr=['Log saved in: ',LogFilePath];
    fprintf(1,LogStr,'\n');
end %LogFileStatus

fprintf('\n\n');
if PrintGPStatus
    NSubPlot=NFiles+1;
	NCol=ceil(sqrt(NSubPlot));
	NRow=ceil(NSubPlot./NCol);
    if NSubPlot<=4
        ChanFigPosVec=[0 .4 .5 .5];
    elseif NSubPlot>4 & NSubPlot<=9
        ChanFigPosVec=[0 .25 .65 .65];
    elseif NSubPlot>9 & NSubPlot<=16
        ChanFigPosVec=[0 .1 .8 .8];
    elseif NSubPlot>16 
        ChanFigPosVec=[0 0.1 1 .9];
    end
	hMergeAvgFilesFig=figure('Units','normal',...
        'Position',ChanFigPosVec, ...
	    'Name','Global power of individual files:',...
        'Color',[1 1 1], ...
	    'NumberTitle','off', ...
        'tag','hMergeAvgFilesFig');
	for FileIndex=1:NFiles
        TrigPoint=[];
		[File,Path,FilePath]=GetFileNameOfMat(InFileMat,FileIndex);
        [AvgMat,File,Path,FilePath,NTrialAvgVec,StdMat,SampRate,AvgRef,Version,...
        MedMedRawVec,MedMedAvgVec,EegMegStatus,NChanExtra,TrigPoint]=ReadAvgFile(FilePath);
        [NChan,NPoints]=size(AvgMat);
        AvgMat=CalcBaseline(AvgMat,MinBase,MaxBase,CalcBaseStatus);
        subplot(NCol,NRow,FileIndex)
        if chNorm>1
            if chNorm==2
                Norm=mean(mean(sqrt(AvgMat.^2)));
            elseif chNorm==3
                Norm=mean(mean(AvgMat.^2));
            elseif chNorm==4
                Norm=mean(mean(AvgMat));
            end
            AvgMat=AvgMat./Norm;
        end     
        if ~isempty(TrigPoint) 
            if TrigPoint<0 | TrigPoint>NPoints
                TrigPoint=[];
            end
        end
        if ~isempty(TrigPoint) 
            xVec=linspace(-TrigPoint,NPoints-TrigPoint,NPoints).*1000./SampRate;
            plot(xVec,mean(sqrt(AvgMat.^2)))
            hold on
            plot([0 0],[0 max(MaxVec)],'k--')
            hold off
            axis([min(xVec) max(xVec) 0 max(MaxVec)])
        else
            xVec=linspace(0,NPoints-1).*1000./SampRate;
            plot(xVec,mean(sqrt(AvgMat.^2)))
            axis([0 max(xVec) 0 max(MaxVec)])
        end
        title(File)
        pause(.001)
    end
    subplot(NCol,NRow,FileIndex+1)
    if ~isempty(TrigPoint) 
        xVec=linspace(-TrigPoint,NPoints-TrigPoint,NPoints).*1000./SampRate;
        plot(xVec,mean(sqrt(MergeAvgMat.^2)))
        hold on
        plot([0 0],[0 max(MaxVec)],'k--')
        hold off
        axis([min(xVec) max(xVec) 0 max(MaxVec)])
    else
        xVec=linspace(0,NPoints-1).*1000./SampRate;
        plot(xVec,mean(sqrt(MergeAvgMat.^2)))
        axis([0 max(xVec) 0 max(MaxVec)])
    end
    title(['Mean: ',OutFile])
    xlabel('Time [ms]')
    if EegMegStatus==1
        ylabel('Amplitude [?V]')
    elseif EegMegStatus==2
        ylabel('Amplitude [fT]')
    end
    pause(.001)
end
return;
end 
