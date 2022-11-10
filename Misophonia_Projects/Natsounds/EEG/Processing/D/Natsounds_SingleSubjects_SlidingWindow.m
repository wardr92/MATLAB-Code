function [] = Natsounds_SingleSubjects_SlidingWindow(AllSubs, ASSR_Bins, ASSR_BinNames, plotflag, bslvec, foi, sampnew ,fsamp)
% Compute Sliding Window Analysis on specified subject files using their
% "App_AllConditions.mat" files and additional input parameters

% AllSubs = filename(s) of subjects for input
% ASSR_Bins = the time windows of interest in sample points (6 x length array)
% ASSR_BinNames = array to provide names to each ASSR Bin
% plotflag = plot (1) or don't plot (0) 
% bslvec = vector of baseline segment in sample points
% foi = the frequency of interest
% sampnew = new sampling rate
% fsamp = original sampling rate

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/ASSR'); % Move to correct folder
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    load(getfilesindir(pwd, '*App_AllConditions.mat')) % Loads the App_AllConditions structure
    Conditions = fieldnames(Apps); % creates vector for all conditions
    for ii = 1:size(ASSR_Bins,1) % Loop through all ASSR time bins  
        for iii = 1:size(Conditions) % Loops through all condition vectors
            fprintf(['\nApplying sliding window to ' Conditions{iii} ' (i.e., condition #' num2str(iii) ' in loop) at ASSR Time Bin of ' ASSR_BinNames(ii,:) '! \n'])
            outmat = Apps.(Conditions{iii}); % Grabs the current condition's .app.mat file and names it "outmat"
            [trialamp,winmat3d,phasestabmat,trialSNR] = flex_slidewin(outmat, plotflag, bslvec, (ASSR_Bins(ii,:)), foi, sampnew, fsamp, append(AllSubs(i,:), '_', ASSR_BinNames(ii,:), '_', (Conditions{iii}))); % Applies sliding window to the outmat file
            AllTrialAmps.([Conditions{iii}]) = trialamp; % Saves current condition TrialAmp into a structure
            AllWinmats.([Conditions{iii}]) = winmat3d; % Saves current condition Winmat3d into a structure
            AllTrialSNRs.([Conditions{iii}]) = trialSNR; % Saves current condition TrialSNR into a structure
            AllPhaseStabMats.([Conditions{iii}]) = phasestabmat; % Saves current condition phasestabmat into a structure
            fprintf(['\nCondition sliding window application complete for ASSR Time Bin ' ASSR_BinNames(ii,:) '! \n'])
        end
        fprintf(['\nCreating TrialSNR, TrialAmp, PhaseStab, and Winmat3D structures containing all conditions for ASSR Time Bin! \n'])
        save(strcat(AllSubs(i,:), '_', 'Slidewin_Amplitude_', ASSR_BinNames(ii,:), '_AllConditions.mat'), 'AllTrialAmps') % Saves TrialAmp structure
        save(strcat(AllSubs(i,:), '_', 'Slidewin_Winmat3D_', ASSR_BinNames(ii,:), '_AllConditions.mat'), 'AllWinmats') % Saves Winmat3D structure
        save(strcat(AllSubs(i,:), '_', 'Slidewin_SNR_', ASSR_BinNames(ii,:), '_AllConditions.mat'), 'AllTrialSNRs') % Saves SNR structure
        save(strcat(AllSubs(i,:), '_', 'Slidewin_PhaseStab_', ASSR_BinNames(ii,:), '_AllConditions.mat'), 'AllPhaseStabMats') % Saves PhaseStabMat structure
        fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
        for iv = 1:size(Conditions) % Loops through all of the conditions to create a figure 
            Slidewinmean(:,:,iv) = mean(AllWinmats.(Conditions{iv}),3); % Averages across trials for sliding window output
            subplot(3,2,iv); % Begins subplotting current condition winmat output
            plot(Slidewinmean(:,:,iv)'); % Plots all sensors across averaged trials for this condition 
            ax = gca; % Edits the plot in figure 1 above
            ax.FontSize = 18; % Sets font size to 18
            ax.Box = 'off';   % Removes the box around the plot
            xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
            xlim([0 160]); 
            xticks([0 40 80 120 160]);
            yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
            ptitle = strcat('Condition ', Conditions{iv}(end-1:end)); 
            title({ptitle}, 'Interpreter','none') 
        end
        SlidewinmeanAllCons = mean(Slidewinmean,3);
        subplot(3,2,(5:6))
        plot(SlidewinmeanAllCons')
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Apply labels to x and y axes 
        xlim([0 160]); 
        xticks([0 40 80 120 160]);
        yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = 'Averaged Across Conditions'; 
        title({ptitle}, 'Interpreter','none') 
        sgridtitle = strcat(AllSubs(i,10:12)); 
        sgtitle({sgridtitle; 'Sliding Window Outcomess Across All Sensors'}, 'FontSize', 30)
        print(fig1, '-dtiff', strcat(AllSubs(i,:), '_', ASSR_BinNames(ii,:), '_Slidewin_Plots.tiff'));
        close all % Clears all figures
        Files2Delete = dir('*.slidwin.mat'); % Deletes the raw .app.mat files since structure exists now
        for d = 1:size(Files2Delete,1) % Loops through all slidwin.mat files present
            delete(Files2Delete(d).name); % Deletes older slidwin.mat files present
        end
    end
    fprintf(['\nSliding window complete for ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
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

function [trialamp,winmat3d,phasestabmat,trialSNR] = flex_slidewin(data, plotflag, bslvec, ssvepvec, foi, sampnew, fsamp, outname)
% This function performs a sliding window averaging analysis as described for example in Morgan et al. 1996; Wieser % et al., 2016
% Inputs:
% data = sensors by time points 2-D matrix
% bslvec = sample points to be used for baseline subtraction
% ssvepvec = a vector containing the sample points to be used in sliding window analysis
% foi = driving frequency of interest in Hz
% fsampnew = new sample rate (if needed)
% fsamp = sampling rate in Hz

% Outputs:
% ssVEP amplitude at the frequency of interest for each trial (trialamp)
% three dimensional array of sliding window averages for each trial, in the time domain (winmat3d)
% the phase stability average of complex coefficients across moving windows
% ssVEP signal-to-noise ratio in decibels at the frequency of interest for each trial (trialamp) 
  
 % this to be done outside the loop to save time, needed for winshift proc
 sampcycle=1000/sampnew; % sampling interval of the new samplerate
 tempvec = round((1000/foi)/sampcycle); % this makes sure that average window duration is exactly the duration in sp of one cyle at foi
 longvec = repmat(tempvec,1,4000); % repeat this many times, at least for duration of entire epoch, subsegments are created later 
 winshiftvec_long = [1 cumsum(longvec)+1]; % use cumsum function to create growing vector of indices for start of the winshift
 tempindexvec = find(winshiftvec_long > ((ssvepvec(end)-ssvepvec(1)).*sampnew./fsamp)); % find the last possible window onset
 endindex = tempindexvec(1);  % this is the first index for which the winshiftvector exceeds the data segment 
 winshiftvec = winshiftvec_long(1:endindex-9);
 
 % need this stuff for the spectrum
 shiftcycle=round(tempvec*8); % 8 cycles of the ssVEP are used here, hardcoded for this toolbox to avoid confusion
 samp=1000/sampnew;
        freqres = 1000/(shiftcycle*samp); % 6 lines of code to find the appropriate bin for the frequency of interest for each segment
        freqbins = 0:freqres:(sampnew/2); 
        min_diff_vec = freqbins-foi;  
        min_diff_vec = abs(min_diff_vec); 
        targetbin=find(min_diff_vec==min(min_diff_vec));
   
    trialamp = []; 
    trialSNR = []; 
    phasestabmat = [];  
    
    NTrials = size(data,3); 
    
    disp('Trial index:')

  for trial = 1:NTrials
        
        Data = squeeze(data(:, ssvepvec, trial)); 
       
        fouriersum = []; 
        
        disp(trial)
  
%===========================================================
    % 1. resample data
%===========================================================   
    
        Data=double(Data'); % make sure data are double precision in case they come from eeglab
            
        resampled=resample(Data,sampnew,fsamp);           
            
        Data = resampled';  
    
%===========================================================
	% 2. Baseline correction
%===========================================================
	
     datamat = bslcorr(Data, bslvec);

%==========================================================
	% 3. moving window procedure with 4 cycles
%===========================================================
	
	 winmatsum = zeros(size(datamat,1),shiftcycle); %4 cycles
	
	 if plotflag, h = figure; end
   
     for winshiftstep = 1:length(winshiftvec)
		
        winmatsum = (winmatsum + freqtag_regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))); % time domain averaging for win file
        
        %for within-trial phase locking
        fouriermat = fft(freqtag_regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))');
        fouriercomp = fouriermat(targetbin,:)'; 
        
        if winshiftstep ==1
            fouriersum = fouriercomp./abs(fouriercomp);
        else
            fouriersum = fouriersum + fouriercomp./abs(fouriercomp);
        end
        
       if plotflag
           subplot(2,1,1), plot(1:sampcycle:shiftcycle*sampcycle, freqtag_regressionMAT(datamat(:,[winshiftvec(winshiftstep):winshiftvec(winshiftstep)+(shiftcycle-1)]))'), title(['sliding window starting at ' num2str((winshiftvec(winshiftstep))*sampcycle)  ' ms ']), xlabel('time in milliseconds')
           subplot(2,1,2), plot(1:sampcycle:shiftcycle*sampcycle, winmatsum'), title(['sum of sliding windows; number of shifts:' num2str(winshiftstep) ]), ylabel('microvolts')
           pause(.4)
       end        
  
    end
    
    winmat = winmatsum./length(winshiftvec);

	%===========================================================
	% 4. determine amplitude and Phase using fft of 
    % averaged sliding windows (variable winmat)
	%=========================================================== 
	
	NFFT = shiftcycle-1; % one cycle in sp of the desired frequency times 4 oscillations (-1)
	NumUniquePts = ceil((NFFT+1)/2); 
	fftMat = fft (winmat', (shiftcycle-1));  % transpose: channels as columns (fft columnwise)
	Mag = abs(fftMat);                                                   % Amplitude berechnen
	Mag = Mag*2;   
	
	Mag(1) = Mag(1)/2;                                                    % DC only once in the full spectrum, no need to correct as above. 
	if ~rem(NFFT,2)                                                       % same with Nyquist
        Mag(length(Mag))=Mag(length(Mag))/2;
	end
	
	Mag=Mag/NFFT;                                                        
    
    trialamp = [trialamp Mag((targetbin),:)'];
    
    trialSNR = [trialSNR log10(Mag((targetbin),:)'./ mean(Mag(([targetbin-2 targetbin+2]),:))').*10]; % a very crude SNR estimate if someone needs it
    
    % phase stability

    phasestabmat = [phasestabmat abs(fouriersum./winshiftstep)]; 
    
    winmat3d(:, :, trial) = winmat; 
        
   end % trials
   
   outmat.fftamp = trialamp; 
   outmat.phasestabmat = phasestabmat; 
   outmat.winmat = winmat3d; 
   
   eval(['save ' outname '.slidwin.mat outmat -mat']);

   fclose('all');
end 
