function [] = Natsounds_GrandAverage_SlidingWindow()
% Compute grand averages for all subjects 

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Move to correct folder
clc;clear % Cleans up workspace
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
for iv = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(iv,:)); % Moves into the current selected folder
    load(getfilesindir(pwd, '*Slidewin_Winmat3D_0-1_seconds*.mat')) % Loads the first ASSR timebin winmat structure
    WinmatConditions = fieldnames(AllWinmats); % Creates a vector for all winmat conditions
    for v = 1:size(WinmatConditions) % Loops through all winmat conditions in the vector
        SubjectMeanWinmat_FirstTime(:,:,v,iv) = mean(AllWinmats.(WinmatConditions{v}),3); % Averages across current condition's winmat trials to create a Channel x TimePoint x Condition x Subject array
    end 
    load(getfilesindir(pwd, '*Slidewin_Winmat3D_1-2_seconds*.mat')) % Loads the second ASSR timebin winmat structure
    for v = 1:size(WinmatConditions) % Loops through all winmat conditions in the vector
        SubjectMeanWinmat_SecondTime(:,:,v,iv) = mean(AllWinmats.(WinmatConditions{v}),3); % Averages across current condition's winmat trials to create a Channel x TimePoint x Condition x Subject array
    end 
    load(getfilesindir(pwd, '*Slidewin_Winmat3D_2-3_seconds*.mat')) % Loads the third ASSR timebin winmat structure
    for v = 1:size(WinmatConditions) % Loops through all winmat conditions in the vector
        SubjectMeanWinmat_ThirdTime(:,:,v,iv) = mean(AllWinmats.(WinmatConditions{v}),3); % Averages across current condition's winmat trials to create a Channel x TimePoint x Condition x Subject array
    end 
    load(getfilesindir(pwd, '*Slidewin_Winmat3D_3-4_seconds*.mat')) % Loads the fourth ASSR timebin winmat structure
    for v = 1:size(WinmatConditions) % Loops through all winmat conditions in the vector
        SubjectMeanWinmat_FourthTime(:,:,v,iv) = mean(AllWinmats.(WinmatConditions{v}),3); % Averages across current condition's winmat trials to create a Channel x TimePoint x Condition x Subject array
    end 
    load(getfilesindir(pwd, '*Slidewin_Winmat3D_4-5_seconds*.mat')) % Loads the fifth ASSR timebin winmat structure
    for v = 1:size(WinmatConditions) % Loops through all winmat conditions in the vector
        SubjectMeanWinmat_FifthTime(:,:,v,iv) = mean(AllWinmats.(WinmatConditions{v}),3); % Averages across current condition's winmat trials to create a Channel x TimePoint x Condition x Subject array
    end 
    load(getfilesindir(pwd, '*Slidewin_Winmat3D_5-6_seconds*.mat')) % Loads the sixth ASSR timebin winmat structure
    for v = 1:size(WinmatConditions) % Loops through all winmat conditions in the vector
        SubjectMeanWinmat_SixthTime(:,:,v,iv) = mean(AllWinmats.(WinmatConditions{v}),3); % Averages across current condition's winmat trials to create a Channel x TimePoint x Condition x Subject array
    end 
    cd('..') % Moves out of the current selected folder
end 
GrandAverageWinmats_FirstTime = mean(SubjectMeanWinmat_FirstTime,4); % Averages across all subjects to create Channel X TimePoint X Condition array
GrandAverageWinmats_SecondTime = mean(SubjectMeanWinmat_SecondTime,4); % Averages across all subjects to create Channel X TimePoint X Condition array
GrandAverageWinmats_ThirdTime = mean(SubjectMeanWinmat_ThirdTime,4); % Averages across all subjects to create Channel X TimePoint X Condition array
GrandAverageWinmats_FourthTime = mean(SubjectMeanWinmat_FourthTime,4); % Averages across all subjects to create Channel X TimePoint X Condition array
GrandAverageWinmats_FifthTime = mean(SubjectMeanWinmat_FifthTime,4); % Averages across all subjects to create Channel X TimePoint X Condition array
GrandAverageWinmats_SixthTime = mean(SubjectMeanWinmat_SixthTime,4); % Averages across all subjects to create Channel X TimePoint X Condition array
save('GrandAverage_Slidewin_Winmat3D_0-1_seconds_AllConditions.mat', 'GrandAverageWinmats_FirstTime'); % Saves the grand average winmat as a Channel x TimePoint X Condition array
save('GrandAverage_Slidewin_Winmat3D_1-2_seconds_AllConditions.mat', 'GrandAverageWinmats_SecondTime'); % Saves the grand average winmat as a Channel x TimePoint X Condition array
save('GrandAverage_Slidewin_Winmat3D_2-3_seconds_AllConditions.mat', 'GrandAverageWinmats_ThirdTime'); % Saves the grand average winmat as a Channel x TimePoint X Condition array
save('GrandAverage_Slidewin_Winmat3D_3-4_seconds_AllConditions.mat', 'GrandAverageWinmats_FourthTime'); % Saves the grand average winmat as a Channel x TimePoint X Condition array
save('GrandAverage_Slidewin_Winmat3D_4-5_seconds_AllConditions.mat', 'GrandAverageWinmats_FifthTime'); % Saves the grand average winmat as a Channel x TimePoint X Condition array
save('GrandAverage_Slidewin_Winmat3D_5-6_seconds_AllConditions.mat', 'GrandAverageWinmats_SixthTime'); % Saves the grand average winmat as a Channel x TimePoint X Condition array
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
for vi = 1:size(WinmatConditions)
    subplot(3,2,vi); % Begins subplotting current condition winmat output
    plot(GrandAverageWinmats_FirstTime(:,:,vi)'); % Plots all sensors across averaged trials for this condition 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 160]); 
    xticks([0 40 80 120 160]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = strcat('Condition ', WinmatConditions{vi}(end-1:end)); 
    title({ptitle}, 'Interpreter','none') 
end
GrandAverageWinmatsAllCon_FirstTime = mean(GrandAverageWinmats_FirstTime,3); % Averages across all conditions to create Channel X TimePoint array
subplot(3,2,(5:6))
plot(GrandAverageWinmatsAllCon_FirstTime(:,:)'); % Plots all sensors across all timepoints
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
xlim([0 160]); 
xticks([0 40 80 120 160]);
yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = strcat('Averaged Across Conditions'); 
title({ptitle}, 'Interpreter','none') 
sgtitle({'Grand Averaged Sliding Time Window Outcomes Across All Sensors'}, 'FontSize', 30)
print(fig1, '-dtiff', 'GrandAverage_0-1_seconds_Slidewin_Plots.tiff');
close all % Clears all figures
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
for vi = 1:size(WinmatConditions)
    subplot(3,2,vi); % Begins subplotting current condition winmat output
    plot(GrandAverageWinmats_SecondTime(:,:,vi)'); % Plots all sensors across averaged trials for this condition 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 160]); 
    xticks([0 40 80 120 160]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = strcat('Condition ', WinmatConditions{vi}(end-1:end)); 
    title({ptitle}, 'Interpreter','none') 
end
GrandAverageWinmatsAllCon_SecondTime = mean(GrandAverageWinmats_SecondTime,3); % Averages across all conditions to create Channel X TimePoint array
subplot(3,2,(5:6))
plot(GrandAverageWinmatsAllCon_SecondTime(:,:)'); % Plots all sensors across all timepoints
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
xlim([0 160]); 
xticks([0 40 80 120 160]);
yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = strcat('Averaged Across Conditions'); 
title({ptitle}, 'Interpreter','none') 
sgtitle({'Grand Averaged Sliding Time Window Outcomes Across All Sensors'}, 'FontSize', 30)
print(fig1, '-dtiff', 'GrandAverage_1-2_seconds_Slidewin_Plots.tiff');
close all % Clears all figures
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
for vi = 1:size(WinmatConditions)
    subplot(3,2,vi); % Begins subplotting current condition winmat output
    plot(GrandAverageWinmats_ThirdTime(:,:,vi)'); % Plots all sensors across averaged trials for this condition 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 160]); 
    xticks([0 40 80 120 160]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = strcat('Condition ', WinmatConditions{vi}(end-1:end)); 
    title({ptitle}, 'Interpreter','none') 
end
GrandAverageWinmatsAllCon_ThirdTime = mean(GrandAverageWinmats_ThirdTime,3); % Averages across all conditions to create Channel X TimePoint array
subplot(3,2,(5:6))
plot(GrandAverageWinmatsAllCon_ThirdTime(:,:)'); % Plots all sensors across all timepoints
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
xlim([0 160]); 
xticks([0 40 80 120 160]);
yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = strcat('Averaged Across Conditions'); 
title({ptitle}, 'Interpreter','none') 
sgtitle({'Grand Averaged Sliding Time Window Outcomes Across All Sensors'}, 'FontSize', 30)
print(fig1, '-dtiff', 'GrandAverage_2-3_seconds_Slidewin_Plots.tiff');
close all % Clears all figures
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
for vi = 1:size(WinmatConditions)
    subplot(3,2,vi); % Begins subplotting current condition winmat output
    plot(GrandAverageWinmats_FourthTime(:,:,vi)'); % Plots all sensors across averaged trials for this condition 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 160]); 
    xticks([0 40 80 120 160]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = strcat('Condition ', WinmatConditions{vi}(end-1:end)); 
    title({ptitle}, 'Interpreter','none') 
end
GrandAverageWinmatsAllCon_FourthTime = mean(GrandAverageWinmats_FourthTime,3); % Averages across all conditions to create Channel X TimePoint array
subplot(3,2,(5:6))
plot(GrandAverageWinmatsAllCon_FourthTime(:,:)'); % Plots all sensors across all timepoints
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
xlim([0 160]); 
xticks([0 40 80 120 160]);
yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = strcat('Averaged Across Conditions'); 
title({ptitle}, 'Interpreter','none') 
sgtitle({'Grand Averaged Sliding Time Window Outcomes Across All Sensors'}, 'FontSize', 30)
print(fig1, '-dtiff', 'GrandAverage_3-4_seconds_Slidewin_Plots.tiff');
close all % Clears all figures
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
for vi = 1:size(WinmatConditions)
    subplot(3,2,vi); % Begins subplotting current condition winmat output
    plot(GrandAverageWinmats_FifthTime(:,:,vi)'); % Plots all sensors across averaged trials for this condition 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 160]); 
    xticks([0 40 80 120 160]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = strcat('Condition ', WinmatConditions{vi}(end-1:end)); 
    title({ptitle}, 'Interpreter','none') 
end
GrandAverageWinmatsAllCon_FifthTime = mean(GrandAverageWinmats_FifthTime,3); % Averages across all conditions to create Channel X TimePoint array
subplot(3,2,(5:6))
plot(GrandAverageWinmatsAllCon_FifthTime(:,:)'); % Plots all sensors across all timepoints
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
xlim([0 160]); 
xticks([0 40 80 120 160]);
yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = strcat('Averaged Across Conditions'); 
title({ptitle}, 'Interpreter','none') 
sgtitle({'Grand Averaged Sliding Time Window Outcomes Across All Sensors'}, 'FontSize', 30)
print(fig1, '-dtiff', 'GrandAverage_4-5_seconds_Slidewin_Plots.tiff');
close all % Clears all figures
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
for vi = 1:size(WinmatConditions)
    subplot(3,2,vi); % Begins subplotting current condition winmat output
    plot(GrandAverageWinmats_SixthTime(:,:,vi)'); % Plots all sensors across averaged trials for this condition 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 160]); 
    xticks([0 40 80 120 160]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = strcat('Condition ', WinmatConditions{vi}(end-1:end)); 
    title({ptitle}, 'Interpreter','none') 
end
GrandAverageWinmatsAllCon_SixthTime = mean(GrandAverageWinmats_SixthTime,3); % Averages across all conditions to create Channel X TimePoint array
subplot(3,2,(5:6))
plot(GrandAverageWinmatsAllCon_SixthTime(:,:)'); % Plots all sensors across all timepoints
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
xlim([0 160]); 
xticks([0 40 80 120 160]);
yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
ptitle = strcat('Averaged Across Conditions'); 
title({ptitle}, 'Interpreter','none') 
sgtitle({'Grand Averaged Sliding Time Window Outcomes Across All Sensors'}, 'FontSize', 30)
print(fig1, '-dtiff', 'GrandAverage_5-6_seconds_Slidewin_Plots.tiff');
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
