function [] = Natsounds_SingleSubjects_SlidewinFFT(AllSubs, fsamp)
% Compute FFT on Sliding Window data for specified subject files using their
% "Winmat3D.mat" files and additional input parameters

% AllSubs = filename(s) of subjects for input
% fsamp = sampling rate from sliding window analysis

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Move to correct folder
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    WinmatTimes = getfilesindir(pwd, '*Slidewin_Winmat3D_*'); % Grabs all the ASSR time bins
    for ii = 1:size(WinmatTimes, 1) % Loops through all time bins
        load(getfilesindir(pwd, WinmatTimes(ii,:))) % Loads current ASSR time in winmat
        Winmats = fieldnames(AllWinmats); % Creates vector for conditions
        for iii = 1:size(Winmats,1) % Loops through all conditions in winmats structure
            fprintf(['\nApplying FFT to ' Winmats{iii} ' (i.e., condition #' num2str(iii) ' in loop) \n'])
            ConditionMeanWinmat(:,:,iii) = mean(AllWinmats.(Winmats{iii}),3); % Averages across trials in the condition
            meanwinmat = ConditionMeanWinmat(:,:,iii); % Changes variable name to meanwinmat for consistency in function
            [amp, phase, freqs, fftcomp] = freqtag_FFT(meanwinmat, fsamp); % Applies FFT function with new sampling rate
            AllAmps.([Winmats{iii}]) = amp; % Saves current condition amp into a structure
            AllFreqs.([Winmats{iii}]) = freqs; % Saves current condition freqs into a structure
            AllFFTComps.([Winmats{iii}]) = fftcomp; % Saves current condition fftcomps into a structure
            AllPhase.([Winmats{iii}]) = phase; % Saves current condition phase into a structure
            fprintf(['\nCondition FFT application complete! \n'])
        end 
        fprintf(['\nCreating Amps, Freqs, FFTComps, and Phase structures containing all conditions\n'])
        save(strcat(AllSubs(i,:), '_', 'Slidewin_FFT_Amplitude_AveragedTrials_', (WinmatTimes(ii,32:42)), '_AllConditions.mat'), 'AllAmps') % Saves Amps structure
        save(strcat(AllSubs(i,:), '_', 'Slidewin_FFT_Frequencies_AveragedTrials_', (WinmatTimes(ii,32:42)), '_AllConditions.mat'), 'AllFreqs') % Saves Freqs structure
        save(strcat(AllSubs(i,:), '_', 'Slidewin_FFT_FFTComps_AveragedTrials_', (WinmatTimes(ii,32:42)), '_AllConditions.mat'), 'AllFFTComps') % Saves FFTComps structure
        save(strcat(AllSubs(i,:), '_', 'Slidewin_FFT_Phase_AveragedTrials_', (WinmatTimes(ii,32:42)), '_AllConditions.mat'), 'AllPhase') % Saves phase structure
        FFTConditions = ([fieldnames(AllAmps), fieldnames(AllFreqs)]); % creates vector for all conditions 
        fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
        for iv = 1:size(FFTConditions) % Loops through all of the conditions to create a figure 
            CurrentConditionFreq(:,:,iv) = AllFreqs.(FFTConditions{iv,2}); % Loads the current condition's frequencies
            CurrentConditionAmp(:,:,iv) = AllAmps.(FFTConditions{iv,1}); % Loads the current condition's amplitudes
            subplot(3,2,iv); % Begins subplotting current condition winmat output
            plot(CurrentConditionFreq(1:21,:,iv), CurrentConditionAmp(:,1:21,iv)) % Plots all sensors across averaged trials for this condition 
            ax = gca; % Edits the plot in figure 1 above
            ax.FontSize = 18; % Sets font size to 18
            ax.Box = 'off';   % Removes the box around the plot
            xlabel('Frequency (Hz)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
            xlim([0 60]); 
            xticks([0 10 20 30 40 50 60]);
            xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
            ptitle = strcat('Condition ', FFTConditions{iii}(end-2:end)); 
            title({ptitle}, 'Interpreter','none') 
        end
        MeanConditionFreq = mean(CurrentConditionFreq,3); % computes the mean Freqs across all conditions
        MeanConditionAmp = mean(CurrentConditionAmp,3); % computes the mean Amps across all conditions
        subplot(3,2,(5:6))
        plot(MeanConditionFreq(1:21), MeanConditionAmp(:,1:21)) % Plots all sensors across averaged trials averaged across conditions 
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Frequency (Hz)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
        xlim([0 60]); 
        xticks([0 10 20 30 40 50 60]);
        xline(41.2,'-k',{'41.2 Hz'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = 'Averaged Across Conditions';
        title({ptitle}, 'Interpreter','none') 
        sgridtitle = strcat(AllSubs(i,10:12)); 
        sgtitle({sgridtitle; 'Spectral Power Across All Sensors'}, 'FontSize', 30)
        print(fig1, '-dtiff', strcat(AllSubs(i,:), '_Slidewin_FFT_SpectralPower_AveragedTrials_', (WinmatTimes(ii,32:42)), '_Plots.tiff'));
        close all % Clears all figures
        fprintf(['\nFFT ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
        clearvars -except AllSubs i ii WinmatTimes
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

function [amp, phase, freqs, fftcomp] = freqtag_FFT(data, fsamp)
% This function applies the Discrete Fourier Transform on a 2-D (M-by-N) data array (data), which is loaded in matlab workspace.

% Inputs:
% data = sensors by time points 2-D matrix
% fsamp = sampling rate in Hz

% Outputs:
% amplitude spectrum (amp)
% phase spectrum
% frequencies available in the spectrum (freqs)
% complex Fourier components (fftcomp)



    NFFT = size(data,2);         % Extract the number of data points in the dataset
	fftcomp = fft(data', NFFT);  % Here, the data becomes time points by sensors using the transpose to use the matlab fft function
	phase = angle(fftcomp);      % Calculate the phase
    Mag = abs(fftcomp);          % Calculate the amplitude
               
	
	Mag(1,:) = Mag(1,:)/2;                                             % DC Frequency not twice
	if ~rem(NFFT,2)                                                    % Nyquist Frequency not twice
			Mag(NFFT/2+1, :)=Mag(NFFT/2+1, :)./2;
	end
	
	Mag=Mag/NFFT;               % After computing the fft, the coefficients will be 
                                % scaled in terms of frequency (in Hz) 
    
    Mag = Mag';                 % Sensors as rows again
    phase = phase';
    
    amp = Mag(:,1:round(NFFT./2));              % Scaling the power
    phase  = phase(:,1:round(NFFT./2));         % Scaling the phase
    select = 1:(NFFT+1)/2;                      % Scaling the frequencies
    freqs = (select - 1)'*fsamp/NFFT;
     
end
