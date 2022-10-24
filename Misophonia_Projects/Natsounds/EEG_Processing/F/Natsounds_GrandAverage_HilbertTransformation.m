function [] = Natsounds_GrandAverage_HilbertTransformation()
% Compute grand averages for all subjects 

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/HilbertTransformed'); % Moves to Hilbert directory
clc;clear % Cleans up workspace
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    load(getfilesindir(pwd, '*HilbertTransform_Power*.mat')) % Loads the AllHilbertPower structure
    load(getfilesindir(pwd, '*HilbertTransform_Phase*.mat')) % Loads the AllHilbertPhase structure
    load(getfilesindir(pwd, '*HilbertTransform_Complex*.mat')) % Loads the AllHilbertComplex structure
    Conditions = fieldnames(AllHilbertPower); % creates vector for all conditions
    for ii = 1:size(Conditions) % Loops through all condition vectors
        GA_HilbertTransformed_Power_AllConditions(:,:,ii,i) = AllHilbertPower.(Conditions{ii}); % Grabs current condition's power
        GA_HilbertTransformed_Phase_AllConditions(:,:,ii,i) = AllHilbertPhase.(Conditions{ii}); % Grabs current condition's phase
        GA_HilbertTransformed_Complex_AllConditions(:,:,ii,i) = AllHilbertComplex.(Conditions{ii});% Grabs current condition's complex 
    end
    cd('..') % Moves out of the current selected folder
end
AllSubs_Power_AllCondition = GA_HilbertTransformed_Power_AllConditions; % Renames matrix
AllSubs_Phase_AllCondition = GA_HilbertTransformed_Phase_AllConditions; % Renames matrix
AllSubs_Complex_AllCondition = GA_HilbertTransformed_Complex_AllConditions; % Renames matrix
save('AllSubs_HilbertTransform_Power_AllConditions.mat','AllSubs_Power_AllCondition') % Saves all subjects Hilbert Power data
save('AllSubs_HilbertTransform_Phase_AllConditions.mat','AllSubs_Phase_AllCondition') % Saves all subjects Hilbert Phase data
save('AllSubs_HilbertTransform_Complex_AllConditions.mat','AllSubs_Complex_AllCondition') % Saves all subjects Hilbert Complex data
GA_Power_AllCondition = mean(AllSubs_Power_AllCondition,4); % Averages across participants
GA_Phase_AllCondition = mean(AllSubs_Phase_AllCondition,4); % Averages across participants
GA_Complex_AllCondition = mean(AllSubs_Complex_AllCondition,4); % Averages across participants
save('GrandAverage_HilbertTransform_Power_AllConditions.mat','GA_Power_AllCondition') % Saves all subjects Hilbert Power data
save('GrandAverage_HilbertTransform_Phase_AllConditions.mat','GA_Phase_AllCondition') % Saves all subjects Hilbert Phase data
save('GrandAverage_HilbertTransform_Complex_AllConditions.mat','GA_Complex_AllCondition') % Saves all subjects Hilbert Complex data
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
