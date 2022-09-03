function [] = Natsounds_GrandAverage_SlidewinSNR()
% Compute grand averages for all subjects 

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Moves into correct folder
clc;clear % Cleans up workspace
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    SNRdbTimes = getfilesindir(pwd, '*SNRdb_AveragedTrials*AllConditions.mat'); % Loads the SNRdb time bins
    SNRratioTimes = getfilesindir(pwd, '*SNRratio_AveragedTrials*AllConditions.mat'); % Loads the SNRratio time bins
    for ii = 1:size(SNRdbTimes) % Loops through all time bins
        load(getfilesindir(pwd, SNRdbTimes(ii,:))) % Loads current time bin SNRdb
        load(getfilesindir(pwd, SNRratioTimes(ii,:))) % Loads current time bin SNRratio
        Conditions = [fieldnames(SNRdb_AveragedTrials), fieldnames(SNRratio_AveragedTrials)]; % Creates vector for conditions
        for iii = 1:size(Conditions) % Loops through all conditions
            SNRdb_AveragedTrials_GrandAvg(:,:,iii, ii, i) = SNRdb_AveragedTrials.(Conditions{iii,1}); % Grabs current condition's SNRdb
            SNRratio_AveragedTrials_GrandAvg(:,:,iii, ii, i)= SNRratio_AveragedTrials.(Conditions{iii,2}); % Grabs current condition's SNRratio
        end
    end
    load(getfilesindir(pwd, '*FFT_Frequencies_AveragedTrials_0-1_seconds*')) % Loads Freqs for plottings 
    Freqs = AllFreqs.Condition_1; % Grabs frequencies for plotting
    cd('..')
end
SNRdb_AveragedTrials_GrandAvg = mean(SNRdb_AveragedTrials_GrandAvg,5); % Averages across all subjects to create a Channel x FrequencyBin x Condition x Time Bin array
SNRratio_AveragedTrials_GrandAvg = mean(SNRratio_AveragedTrials_GrandAvg,5); % Averages across all subjects to create a Channel x FrequencyBin x Condition x Time Bin array

for iv = 1:size(SNRdb_AveragedTrials_GrandAvg,4) % Loops through all ASSR time bins
    SNRdb = SNRdb_AveragedTrials_GrandAvg(:,:,:,iv); % Grabs current ASSR time bin SNRdbs
    SNRratio = SNRratio_AveragedTrials_GrandAvg(:,:,:,iv); % Grabs current ASSR time SNRratios
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRdb') % Moves to SNRdb folder
    save(strcat('GrandAverage_Slidewin_FFT_SNRdb_AveragedTrials_', (SNRdbTimes(iv,48:59)), 'AllConditions.mat'), 'SNRdb'); % Saves the grand average amp as a Channel X FrequencyBin X Condition array
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRratio') % Moves to SNRratio folder
    save(strcat('GrandAverage_Slidewin_FFT_SNRratio_AveragedTrials_', (SNRratioTimes(iv,51:62)), 'AllConditions.mat'), 'SNRratio'); % Saves the grand average freqs as a Channel X FrequencyBin X Condition array
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRdb') % Moves to SNRdb folder
    fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
    for v = 1:size(Conditions,1) % Loops through all of the conditions to create a figure 
        subplot(3,2,v); % Begins subplotting current condition winmat output
        plot(Freqs(1:21,:), SNRdb(:,1:21,v)) % Plots all sensors across averaged trials for this condition 
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Frequency (Hz)'), ylabel('SNR (db)'); % Applies labels to x and y axes 
        ylim([-30 30]); 
        yticks([-30 -15 0 15 30]);
        yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        xlim([0 60]); 
        xticks([0 10 20 30 40 50 60]);
        xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = strcat('Condition ', Conditions{v}(end-1:end)); 
        title({ptitle}, 'Interpreter','none') 
    end 
    AllConSNRdb = mean(SNRratio,3); % Averages across all conditions to create Channel X FrequencyBin array
    subplot(3,2,(5:6))
    plot(Freqs(1:21), SNRdb(:,1:21)) % Plots all sensors across averaged trials averaged across conditions 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Frequency (Hz)'), ylabel('SNR (db)'); % Applies labels to x and y axes 
    ylim([-30 30]); 
    yticks([-30 -15 0 15 30]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    xlim([0 60]); 
    xticks([0 10 20 30 40 50 60]);
    xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = 'Averaged Across Conditions';
    title({ptitle}, 'Interpreter','none') 
    sgtitle({'Grand Average Signal-to-Noise Ratio (db) Across All Sensors'}, 'FontSize', 30)
    print(fig1, '-dtiff', strcat('GrandAverage_Slidewin_FFT_SNRdb_',(SNRdbTimes(iv,48:59)) , 'AveragedTrials_Plots.tiff'));
    close all % Clears all figures
    cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT_SNRratio') % Moves to SNRratio folder
    fig2 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
    for v = 1:size(Conditions,1) % Loops through all of the conditions to create a figure 
        subplot(3,2,v); % Begins subplotting current condition winmat output
        plot(Freqs(1:21,:), SNRratio(:,1:21,v)) % Plots all sensors across averaged trials for this condition 
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Frequency (Hz)'), ylabel('SNR (Ratio)'); % Applies labels to x and y axes 
        ylim([-30 30]); 
        yticks([-30 -15 0 15 30]);
        yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        xlim([0 60]); 
        xticks([0 10 20 30 40 50 60]);
        xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = strcat('Condition ', Conditions{v}(end-1:end)); 
        title({ptitle}, 'Interpreter','none') 
    end 
    AllConSNRratio = mean(SNRratio,3); % Averages across all conditions to create Channel X FrequencyBin array
    subplot(3,2,(5:6))
    plot(Freqs(1:21), AllConSNRratio(:,1:21)) % Plots all sensors across averaged trials averaged across conditions 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Frequency (Hz)'), ylabel('SNR (Ratio)'); % Applies labels to x and y axes 
    ylim([-30 30]); 
    yticks([-30 -15 0 15 30]);
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    xlim([0 60]); 
    xticks([0 10 20 30 40 50 60]);
    xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = 'Averaged Across Conditions';
    title({ptitle}, 'Interpreter','none') 
    sgtitle({'Grand Average Signal-to-Noise Ratio (Relative) Across All Sensors'}, 'FontSize', 30)
    print(fig2, '-dtiff', strcat('GrandAverage_Slidewin_FFT_SNRratio_',(SNRratioTimes(iv,51:62)) , 'AveragedTrials_Plots.tiff'));
    close all % Clears all figures
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