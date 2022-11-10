function [GrandAverage_ASSR, GrandAverage_ASSR_se, GrandAverage_ASSR_AllConditions, GrandAverage_ASSR_AllConditions_se] = Natsounds_ASSR_Plots(ASSR_AllConditions, sensors);

% Only grab from predefined sensors 
ASSR_AllConditions = squeeze(mean(ASSR_AllConditions(sensors,:,:,:,:),1)); % Only grab ASSR from predefined sensors

% Load time bins
cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/'); % Navigates to appropriate folder
BinNames = getfilesindir(pwd, '*_Slidewin_Winmat3D_*_AllConditions.mat'); % Grab time bin names
BinNames = BinNames(:,end-28:end-18); % Renames variable
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
cd(AllSubs(1,:)); % Moves into the current selected folder
load(getfilesindir(pwd,'*_Slidewin_FFT_Frequencies_AveragedTrials_0-1_seconds_AllConditions.mat')) % Load frequency structure
FreqRange = AllFreqs.Condition_1; % Grab frequencies
cd('..') % Moves out of the current selected folder 

% Grand Averages Across Conditions for Each Time Bin
for i = 1:size(ASSR_AllConditions,2)
    GA_ASSRAllConditions(:,:,i) =  squeeze(mean(squeeze(ASSR_AllConditions(:,i,:,:)),2)); % Creates average ASSR over all conditions for the time window in each subject
    GrandAverage_ASSR_se(:,i) = (std(GA_ASSRAllConditions(:,:,i)')/sqrt(size(GA_ASSRAllConditions,2)))'; % Creates standard error for grand mean ASSR vector for each frequency bin
    GrandAverage_ASSR(:,i) = mean(GA_ASSRAllConditions(:,:,i),2); % Averages across all participants to create a single vector for grand average ASSR for each condition in each time bin
end 
    
% Grand Averages for Each Condition in Each Time Bin
for ii = 1:size(ASSR_AllConditions,2)
    for iii = 1:size(ASSR_AllConditions,3)
        GrandAverage_ASSR_AllConditions(:, ii, iii) = mean(ASSR_AllConditions(:,ii,iii,:),4); % Creates condition average for respective timebin ASSR response
        GrandAverage_ASSR_AllConditions_se(:,ii,iii) = (std(ASSR_AllConditions(:,ii,iii,:),0,4)'/sqrt(size(ASSR_AllConditions,4)')); % Creates condition standard error for respective timebin ASSR response    
    end 
end

% Plot Grand Average ASSR Response
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
hold on   
plot(FreqRange, GrandAverage_ASSR(:,1)', '-k'); 
shadedErrorBar(FreqRange, GrandAverage_ASSR(:,1)', GrandAverage_ASSR_se(:,1), 'lineprops', '-k', 'transparent', 1);
plot(FreqRange, GrandAverage_ASSR(:,2)', '-b'); 
shadedErrorBar(FreqRange, GrandAverage_ASSR(:,2)', GrandAverage_ASSR_se(:,2), 'lineprops', '-b', 'transparent', 1);
plot(FreqRange, GrandAverage_ASSR(:,3)', '-g'); 
shadedErrorBar(FreqRange, GrandAverage_ASSR(:,3)', GrandAverage_ASSR_se(:,3), 'lineprops', '-g', 'transparent', 1);
plot(FreqRange, GrandAverage_ASSR(:,4)', '-m'); 
shadedErrorBar(FreqRange, GrandAverage_ASSR(:,4)', GrandAverage_ASSR_se(:,4), 'lineprops', '-m', 'transparent', 1);
plot(FreqRange, GrandAverage_ASSR(:,5)', '-r'); 
shadedErrorBar(FreqRange, GrandAverage_ASSR(:,5)', GrandAverage_ASSR_se(:,5), 'lineprops', '-r', 'transparent', 1);
plot(FreqRange, GrandAverage_ASSR(:,6)', '-c'); 
shadedErrorBar(FreqRange, GrandAverage_ASSR(:,6)', GrandAverage_ASSR_se(:,6), 'lineprops', '-c', 'transparent', 1);
hold off
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Frequency (Hz)'), ylabel('Amplitude'); % Apply labels to x and y axes 
xlim([0,80])
xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
title ('Grand Average ASSR Response');

fig2 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
for iv = 1:size(ASSR_AllConditions,2)
    subplot(2,3,iv); % Begins subplotting current condition winmat output
    hold on
    plot(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,1)', '-g'); % Plot Miso
    shadedErrorBar(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,1)', GrandAverage_ASSR_AllConditions_se(:,iv,1), 'lineprops', '-g', 'transparent', 1);
    plot(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,2)', '-r'); % Plot Unpl
    shadedErrorBar(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,2)', GrandAverage_ASSR_AllConditions_se(:,iv,2), 'lineprops', '-r', 'transparent', 1);
    plot(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,3)', '-b'); % Plot Plea
    shadedErrorBar(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,3)', GrandAverage_ASSR_AllConditions_se(:,iv,3), 'lineprops', '-b', 'transparent', 1);
    plot(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,4)', '-k'); % Plot Neut
    shadedErrorBar(FreqRange, GrandAverage_ASSR_AllConditions(:,iv,4)', GrandAverage_ASSR_AllConditions_se(:,iv,4), 'lineprops', '-k', 'transparent', 1);
    hold off
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Frequency (Hz)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 60]); 
    xticks([0 80]);
    xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = strcat('Time Bin_', BinNames(iv,:));
    title({ptitle}, 'Interpreter','none') 
end
sgtitle({'Grand Average ASSR Response by Condition'}, 'FontSize', 30);
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
