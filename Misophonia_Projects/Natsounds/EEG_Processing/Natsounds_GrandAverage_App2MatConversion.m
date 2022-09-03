function [] = Natsounds_GrandAverage_App2MatConversion()
% Creates grand average of .app converted into .mat files to show ERPs 

% AllSubs = filename(s) of subjects for input

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/PreProcessing') % Moves to correct folder
clc;clear % Cleans up workspace
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
for v = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(v,:)); % Moves into the current selected folder
    load(getfilesindir(pwd, '*ERPs_AllConditions.mat')) % Loads the app structure
    ERPConditions = fieldnames(ERPs); % Creates a vector for all ERP conditions
    for vi = 1:size(ERPConditions) % Loops through all ERP conditions in the vector
        SubjectERPs(:,:,vi,v) = ERPs.(ERPConditions{vi}); % Creates a Channel x TimePoint x Condition x Participant array
    end 
    cd('..') % Moves out of the current selected folder
end 
GrandAverageERPs = mean(SubjectERPs,4); % Averages across all subjects to create Channel X TimePoint X Condition array
save('GrandAverage_ERPs_AllConditions.mat', 'GrandAverageERPs'); % Saves the grand average ERP as a Channel x TimePoint X Condition array
taxis = -600:2:6000; % Creates time axis in ms based on current epoch
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
for vii = 1:size(GrandAverageERPs,3) % Loops through all ERP conditions
   subplot(3,2,vii); % Begins subplotting current ERP condition
   plot(taxis, GrandAverageERPs(:,:,vii)');
   ax = gca; % Edits the plot in figure 1 above
   ax.FontSize = 18; % Sets font size to 18
   ax.Box = 'off';   % Removes the box around the plot
   xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
   xlim([-600 6000]); 
   xticks([-600 0 1000 2000 3000 4000 5000 6000]);
   xline(0,'-k',{'Stimulus Onset'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
   yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
   ptitle = strcat('Condition ', ERPConditions{vii}(end)); 
   title({ ptitle}, 'Interpreter','none') 
end
GrandAverageERPsAllConditions = mean(GrandAverageERPs,3); % Averages across all conditions to create Channel X TimePoint array
subplot(3,2,(5:6))
plot(taxis, GrandAverageERPsAllConditions);
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
xlim([-600 6000]); 
xticks([-600 0 1000 2000 3000 4000 5000 6000]);
xline(0,'-k',{'Stimulus Onset'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = strcat('Averaged Across Conditions'); 
title({ ptitle}, 'Interpreter','none') 
sgtitle({'Grand Averaged ERPs Across All Sensors'}, 'FontSize', 30)
print(fig1, '-dtiff', 'GrandAverage_ERP_Plots.tiff');
close all % Clears all figures
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
