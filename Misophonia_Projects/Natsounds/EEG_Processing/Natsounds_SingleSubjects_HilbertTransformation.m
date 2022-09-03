function [] = Natsounds_SingleSubjects_HilbertTransformation(AllSubs, taggingfreq, filterorder, sensor2plot, plotflag, fsamp, baselinecorr)
% Compute Hilbert Transformations on specified subject files using their
% "App_AllConditions.mat" files and additional input parameters

% AllSubs = filename(s) of subjects for input
% taggingfreq = the frequency of interest
% filterorder = Butterworth filter order to use
% sensor2plot = sensors we want to plot
% plotflag = plot these sensors (or use 0 to skip plotting)
% fsamp = original sampling rate. 
% baselinecor = baseline correction interval in sample points

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/HilbertTransformed'); % Moves to Hilbert directory
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    load(getfilesindir(pwd, '*App_AllConditions.mat')) % Loads the App_AllConditions structure
    Conditions = fieldnames(Apps); % creates vector for all conditions
    for ii = 1:size(Conditions) % Loops through all condition vectors
        fprintf(['\nApplying Hilbert Transform to ' Conditions{ii} ' (i.e., condition #' num2str(ii) ' in loop)! \n'])
        dataset = Apps.(Conditions{ii}); % Grabs the current condition's .app.mat file and names it "dataset"
        dataset = mean(dataset,3); % Averages across all trials to create channel x timepoint array
        [power, phase, complex] = freqtag_HILB_natsounds(dataset, taggingfreq, filterorder, sensor2plot, plotflag, fsamp);
        inmat = power; % Rename variable for baseline correction function
        [data] = bslcorr(inmat, baselinecorr); % Baseline corrects 100 to 200 sample points 
        AllHilbertPower.([Conditions{ii}]) = data; % Saves Hilbert transform power for current condition into structure
        AllHilbertPhase.([Conditions{ii}]) = phase; % Saves Hilbert transform phase for current condition into structure
        AllHilbertComplex.([Conditions{ii}]) = complex; % Saves Hilbert transform complex for current condition into structure
    end 
    fprintf(['\nCreating HilbertPower, HilbertPhase, and HilbertComplex structures containing all conditions! \n'])
    save(strcat(AllSubs(i,:), '_', 'HilbertTransform_Power', '_AllConditions.mat'), 'AllHilbertPower') % Saves AllHilbertPower structure
    save(strcat(AllSubs(i,:), '_', 'HilbertTransform_Phase', '_AllConditions.mat'), 'AllHilbertPhase') % Saves AllHilbertPhase structure
    save(strcat(AllSubs(i,:), '_', 'HilbertTransform_Complex', '_AllConditions.mat'), 'AllHilbertComplex') % Saves AllHilbertComplex structure
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

function [power, phase, complex] = freqtag_HILB_natsounds(dataset, taggingfreq, filterorder, sensor2plot, plotflag, fsamp)

%This function applies the Fast Fourier Transform on a 2-D data, where M are sensors and N time points.
%taggingfreq is the tagging frequency
%filterorder is the order of the filter to be aplied on the data
%fsamp is the sampling rate 

    taxis = 0:1000/fsamp:size(dataset,2)*1000/fsamp - 1000/fsamp;   % Calculate the time axis
    taxis = taxis/1000; 
   
    uppercutoffHz = taggingfreq + .1;                            % Design the LOW pass filter around the taggingfreq   
    [Blow,Alow] = butter(filterorder, uppercutoffHz/(fsamp/2));  
    
    lowercutoffHz = taggingfreq - .1;                            % Design the HIGH pass filter around the taggingfreq
    [Bhigh,Ahigh] = butter(filterorder, lowercutoffHz/(fsamp/2), 'high'); 
	
	
     dataset = dataset';             % The filtfilt function takes the time-point as rows and sensors as columns
    
  
     lowpassdata = filtfilt(Blow,Alow, dataset);               % Filter the data using the low-pass filter 
     lowhighpassdata = filtfilt(Bhigh, Ahigh, lowpassdata);    % Filter the low-pass data using the high-pass filter
     
   
     tempmat = hilbert(lowhighpassdata);                    % Calculate Hilbert Transform on the filtered data
     
    
     tempmat = tempmat';                                    % Sensors as rowls again
     

      taxis = -600:2:6000; % converts taxis to ms
      if plotflag                                            % Plot shows filtered data in blue, imaginary (hilbert) part in red, absolute value (envelope) in black 
          fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
        for sensor = 1:size(sensor2plot,2) % Loops through all sensors specified
            currentsensor = sensor2plot(sensor);
            fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
            plot(taxis, lowhighpassdata(:,currentsensor)), 
            hold on, 
            plot(taxis, imag(tempmat(currentsensor,:)), 'r'), 
            plot(taxis, abs(tempmat(currentsensor,:)), 'k')
            ax = gca; % Edits the plot in figure 1 above
            ax.FontSize = 18; % Sets font size to 18
            ax.Box = 'off';   % Removes the box around the plot
            xlabel('Time (ms)'), ylabel('Amplitude'); % Apply labels to x and y axes 
            title (['Sensor # ' num2str(sensor2plot(sensor))]);
            pause(.5)
            hold off
            close all
        end
      end
     
 power = abs(tempmat);                                 % Amplitude over time (real part)
 phase = angle(tempmat);                               % Phase over time 
 complex = tempmat;                                    % Imaginary part
end 

function [data] = bslcorr(inmat, bslvec);
% bslcorrmat
% corrects 129 channel ar mat 
% by subtracting mean of baseline in samplepoints

if isempty (bslvec), 
    bslvec = 1:size(inmat,2); 
end

for chan = 1 : size(inmat, 1)
data(chan,:) = inmat(chan,:)-mean(inmat(chan,bslvec),2);
end