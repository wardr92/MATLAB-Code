function [] = Natsounds_GrandAverage_SlidewinFFT()
% Compute grand averages for all subjects 

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Move to correct folder
clc;clear % Cleans up workspace
AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    FreqTimes = getfilesindir(pwd, '*Slidewin_FFT_Frequencies_*'); % Grabs all the Freq time bins
    AmpTimes = getfilesindir(pwd, '*Slidewin_FFT_Amplitude_*.mat'); % Grabs all the Amp time bins
    for ii = 1:size(AmpTimes) % Loops through all time bins
        load(getfilesindir(pwd, FreqTimes(ii,:))) % Loads current ASSR time Freq
        load(getfilesindir(pwd, AmpTimes(ii,:))) % Loads current ASSR time Amp
        FFTConditions = ([fieldnames(AllAmps), fieldnames(AllFreqs)]); % creates vector for all conditions 
        for iii = 1:size(FFTConditions) % Loops through all fields in conditions structure
            ConditionFreq(:,:,iii, ii, i) = AllFreqs.(FFTConditions{iii,2});
            ConditionAmp(:,:,iii, ii, i) = AllAmps.(FFTConditions{iii,1});
        end
    end 
    cd('..')
end
cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR/Grand Averages/GA_Slidewin_FFT'); % Move to grand averages folder
AllSubsConditionFreq = mean(ConditionFreq,5); % Averages across all subjects to create FrequencyBin X ListVector X Condition x Time Bin array
AllSubsConditionAmp = mean(ConditionAmp,5); % Averages across all subjects to create Channel X FrequencyAmp X Condition x Time bin array
for iv = 1:size(AllSubsConditionFreq,4) % Loops through all ASSR time bins
    Freqs = AllSubsConditionFreq(:,:,:,iv); % Grabs current ASSR time bin Freqs
    Amps = AllSubsConditionAmp(:,:,:,iv); % Grabs current ASSR time bin Amps
    save(strcat('GrandAverage_Slidewin_FFT_Amplitude_AveragedTrials_', (AmpTimes(iv,52:54)), '_AllConditions.mat'), 'Amps'); % Saves the grand average amp as a Channel X FrequencyAmp X Condition array
    save(strcat('GrandAverage_Slidewin_FFT_Frequencies_AveragedTrials_', (AmpTimes(iv,52:54)), '_AllConditions.mat'), 'Freqs'); % Saves the grand average freqs as a FrequencyBin X ListVector X Condition array
    fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
    for v = 1:size(FFTConditions) % Loops through all of the conditions to create a figure 
        subplot(3,2,v); % Begins subplotting current condition winmat output
        plot(Freqs(1:21,:,v), Amps(:,1:21,v)) % Plots all sensors across averaged trials for this condition 
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Frequency (Hz)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
        xlim([0 60]); 
        xticks([0 10 20 30 40 50 60]);
        xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = strcat('Condition ', FFTConditions{v}(end-1:end)); 
        title({ptitle}, 'Interpreter','none') 
    end 
    AllConFreqs = mean(Freqs,3); % Averages across all conditions to create FrequencyBin X ListVector array
    AllConAmps = mean(Amps,3); % Averages across all conditions to create Channel X FrequencyAmp array
    subplot(3,2,(5:6))
    plot(AllConFreqs(1:21), AllConAmps(:,1:21)) % Plots all sensors across averaged trials averaged across conditions 
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Frequency (Hz)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
    xlim([0 60]); 
    xticks([0 10 20 30 40 50 60]);
    xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = 'Averaged Across Conditions';
    title({ptitle}, 'Interpreter','none') 
    sgtitle({'Grand Average Spectral Power Across All Sensors'}, 'FontSize', 30)
    print(fig1, '-dtiff', strcat('GrandAverage_Slidewin_FFT_SpectralPower_',(AmpTimes(iv,52:62)) , '_AveragedTrials_Plots.tiff'));
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