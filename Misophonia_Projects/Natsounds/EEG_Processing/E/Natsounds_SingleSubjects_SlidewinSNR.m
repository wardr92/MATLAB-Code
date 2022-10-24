function [] = Natsounds_SingleSubjects_SlidewinSNR(AllSubs,noisebins)
% Compute SNR on sliding window data for specified subject files using 
% their "FFT_Amplitude*AllConditions.mat" files and additional input parameters

% AllSubs = filename(s) of subjects for input
% noisebins = frequency bins adjacent to foi

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Moves into correct folder
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    AmpTimes = getfilesindir(pwd, '*Slidewin_FFT_Amplitude_AveragedTrials*AllConditions.mat'); % Grabs all the Amp time bins
    for ii = 1:size(AmpTimes) % Loops through all time bins
        load(getfilesindir(pwd, AmpTimes(ii,:))) % Loads current ASSR time Amp
        AveragedTrials = AllAmps; % Changes AllAmps name
        Conditions = fieldnames(AveragedTrials); % Creates vector for conditions
        for iii = 1:size(Conditions) % Loops through the condition vector made above
            fprintf(['\nApplying SNR estimates to ' Conditions{iii} ' (i.e., condition #' num2str(ii) ' in loop) \n'])
            AveragedTrials_Amp = AveragedTrials.(Conditions{iii,1}); % Grabs current condition's amp
            [SNRdb, SNRratio] = freqtag_simpleSNR(AveragedTrials_Amp, noisebins); % Runs SNR on amp data for averaged trials FFT
            SNRdb_AveragedTrials.([Conditions{iii}]) = SNRdb; % Creates SNRdb structure for averaged trial FFT
            SNRratio_AveragedTrials.([Conditions{iii}]) = SNRratio; % Creates SNRratio structure for averaged trial FFT
        end 
        save(strcat(AllSubs(i,:), '_', 'Slidewin_FFT_SNRdb_AveragedTrials_', AmpTimes(ii,52:63), 'AllConditions.mat'), 'SNRdb_AveragedTrials') % Saves SNRdb structure
        save(strcat(AllSubs(i,:), '_', 'Slidewin_FFT_SNRratio_AveragedTrials_', AmpTimes(ii,52:63), 'AllConditions.mat'), 'SNRratio_AveragedTrials') % Saves SNRratio structure
        load(getfilesindir(pwd, '*Slidewin_FFT_Frequencies_AveragedTrials_0-1_seconds_AllConditions.mat')); % Loads the freq structure for averaged trial FFT
        AveragedFreqs = AllFreqs; % Renames variable
        fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size  
        for iv = 1:size(Conditions) % Loops through the condition vector made above
            PlotSNRdb_AveragedTrials(:,:,iv) = SNRdb_AveragedTrials.(Conditions{iv}); % Pulls out current condition's SNRdb for plotting in FFT on averaged trials
            PlotFreqs_AveragedTrials(:,:,iv) = AveragedFreqs.(Conditions{iv}); % Pulls out current condition's frequencies for plotting in FFT on averaged trials
            subplot(3,2,iv); % Begins subplotting current condition SNR
            plot(PlotFreqs_AveragedTrials(:,:,iv)', PlotSNRdb_AveragedTrials(:,:,iv)); % Plots SNRdb for all sensors 
            ax = gca; % Edits the plot in figure 1 above
            ax.FontSize = 18; % Sets font size to 18
            ax.Box = 'off';   % Removes the box around the plot
            xlabel('Frequency (Hz)'), ylabel('SNR (dB)'); % Applies labels to x and y axes 
            xlim([0 60]); 
            xticks([0 10 20 30 40 50 60]);
            ylim([-30 30]); 
            yticks([-30 -15 0 15 30]);
            yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
            xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
            ptitle = strcat('Condition ', Conditions{iv}(end-1:end)); 
            title({ptitle}, 'Interpreter','none') 
        end
        MeanConditionFreq = mean(PlotFreqs_AveragedTrials,3); % Averages across all conditions to create a Channel x FrequencyBin array
        MeanConditionSNRdb = mean(PlotSNRdb_AveragedTrials,3); % Averages across all subjects to create a FrequencyBin x ListVector array
        subplot(3,2,(5:6))
        plot(MeanConditionFreq', MeanConditionSNRdb'); % Plots SNRdb for all sensors 
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Frequency (Hz)'), ylabel('SNR (dB)'); % Applies labels to x and y axes 
        xlim([0 60]); 
        xticks([0 10 20 30 40 50 60]);
        ylim([-20 20]); 
        yticks([-20 -10 0 10 20]);
        yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = 'Averaged Across Conditions';
        title({ptitle}, 'Interpreter','none') 
        sgridtitle = strcat(AllSubs(i,10:12)); 
        sgtitle({sgridtitle; 'Signal-to-Noise Ratio (dB) Across All Sensors'}, 'FontSize', 30)
        print(fig1, '-dtiff', strcat(AllSubs(i,:), '_Slidewin_FFT_SNRdb_AveragedTrials_', AmpTimes(ii,52:63), 'Plots.tiff'));
        fig2 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size  
        for v = 1:size(Conditions) % Loops through the condition vector made above
            PlotSNRratio_AveragedTrial(:,:,v) = SNRratio_AveragedTrials.(Conditions{v}); % Pulls out current condition's SNRratio for plotting in FFT on averaged trials
            PlotFreqs_AveragedTrials(:,:,v) = AveragedFreqs.(Conditions{v}); % Pulls out current condition's frequencies for plotting in FFT on averaged trials
            subplot(3,2,v); % Begins subplotting current condition SNR
            plot(PlotFreqs_AveragedTrials(:,:,iii)', PlotSNRratio_AveragedTrial(:,:,v)); % Plots SNRratio for all sensors 
            ax = gca; % Edits the plot in figure 1 above
            ax.FontSize = 18; % Sets font size to 18
            ax.Box = 'off';   % Removes the box around the plot
            xlabel('Frequency (Hz)'), ylabel('SNR (Ratio)'); % Applies labels to x and y axes 
            xlim([0 60]); 
            xticks([0 10 20 30 40 50 60]);
            ylim([0 120]); 
            yticks([0 40 80 120]);
            yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
            xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
            ptitle = strcat('Condition ', Conditions{v}(end-1:end)); 
            title({ptitle}, 'Interpreter','none') 
        end
        MeanConditionFreq = mean(PlotFreqs_AveragedTrials,3); % Averages across all conditions to create a Channel x FrequencyBin array
        MeanConditionSNRratio = mean(PlotSNRratio_AveragedTrial,3); % Averages across all subjects to create a FrequencyBin x ListVector array
        subplot(3,2,(5:6))
        plot(MeanConditionFreq', MeanConditionSNRratio'); % Plots SNRratio for all sensors 
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Frequency (Hz)'), ylabel('SNR (Ratio)'); % Applies labels to x and y axes 
        xlim([0 60]); 
        xticks([0 10 20 30 40 50 60]);
        ylim([0 120]); 
        yticks([0 40 80 120]);
        yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = 'Averaged Across Conditions';
        title({ptitle}, 'Interpreter','none') 
        sgridtitle = strcat(AllSubs(i,10:12)); 
        sgtitle({sgridtitle; 'Signal-to-Noise Ratio (Relative) Across All Sensors'}, 'FontSize', 30)
        print(fig2, '-dtiff', strcat(AllSubs(i,:), '_Slidewin_FFT_SNRratio_AveragedTrials_', AmpTimes(ii,52:63), 'Plots.tiff'));
        close all % Clears all figures
    end
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

function [SNRdb, SNRratio] = freqtag_simpleSNR(data, noisebins)
% This is a simple method for computing an estimate of the signal-to-noise
% ratio for a ssVEP response in the frequency domain
% data is an amplitude spectrum in 2-D format (electrodes by frequencies)
% noisebins are the frequency bins in the spectrum NOT in Hz, but as
% relative position on the frequency axis (e.g., the 3rd and 6th frequencies 
% would be indicated as [3 6]);  
% To facilitate method checks, the entire spectrum is output, with all
% frequencies expressed as ratio (or in decibels)  relative to 
% the mean power at the frequencies used to estimate the noise. 
% see the enclosed live script for usage examples.

    
    divmat = repmat(mean(data(:, noisebins), 2), 1, size(data,2)); 
    
    SNRratio  = data./divmat; 
    
    SNRdb = 10 * log10(SNRratio);
end
