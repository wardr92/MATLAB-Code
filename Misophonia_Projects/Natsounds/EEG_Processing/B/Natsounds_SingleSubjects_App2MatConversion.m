function [] = Natsounds_SingleSubjects_App2MatConversion(AllSubs)
% Converts all .app data into .mat format for each subject specified  

% AllSubs = filename(s) of subjects for input

cd('/Volumes/CSEA HDD/Misophonia Projects/EEG/NatSounds/Analyses/EEG/PreProcessing') % Moves to correct folder
for i = 1:size(AllSubs,1) % Loops through all folders
    cd(AllSubs(i,:)); % Moves into the current selected folder
    fprintf(['\nProcessing ' (AllSubs(i,:)) ' (i.e., participant #'  num2str(i) ' in loop) \n'])
    Files2Delete = dir('*.app*.mat*'); % Double check .app.mat files don't exist
    for d = 1:size(Files2Delete,1) % Loops through all .app.mat files present
        delete(Files2Delete(d).name); % Deletes older .app.mat files present
    end
    Files2Delete2 = dir('*.app0'); % Deletes condition 0 filler trials
    for d = 1:size(Files2Delete2,1) % Loops through all .app.mat files present
        delete(Files2Delete2(d).name); % Deletes older .app.mat files present
    end
    AllApps = getfilesindir(pwd, '*.app*'); % Grabs all .app files in the current folder
    for ii = 1:size(AllApps,1) % Loops through all .app files present and applies app2mat to them
        fprintf(['\nConverting condition ' (AllApps(ii,end)) ' (i.e., condition #' num2str(ii) ' in loop) \n'])
        app2mat(deblank(AllApps(ii,:)),0); % Performs app2mat function for current .app file
        fprintf(['\nCondition app2mat conversion complete! \n'])
    end
    AllMats = getfilesindir(pwd, '*.app*.mat'); % Grabs all .app.mat files in the current folder
    fprintf(['\nCreating structures for all conditions in .app.mat and ERP formats \n'])
    for iii = 1:size(AllMats,1)
        load(AllMats(iii,:)); % Loads the condition specific .app.mat outmat file to the workspace
        Apps.(['Condition_', AllMats(iii,end-4:end-4)]) = outmat(:,:,:); % Saves condition .app.mat outmat as a field in structure
        ERPs.(['Condition_' AllMats(iii,end-4:end-4)]) = mean(outmat,3); % Averages trials in this condition
    end
    save(strcat(AllSubs(i,:), '_', 'App_AllConditions.mat'), 'Apps') % Saves the participant's combined .app.mat conditions as a file
    save(strcat(AllSubs(i,:), '_', 'ERPs_AllConditions.mat'), 'ERPs') % Saves the participant's combined .app.mat conditions as a file
    fprintf(['\n.app.mat and ERP structures containing all conditions complete! \n'])
    Conditions = fieldnames(ERPs); % Creates vector for all conditions based on the number of fields present in ERPs
        taxis = -600:2:6000; % Creates time axis in ms based on current epoch
    fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size properties
    for iv = 1:size(Conditions,1) % Loops through the condition vector made above
        PlotERP(:,:,iv) = ERPs.(Conditions{iv}); % Pulls out current condition's ERP for plotting
        subplot(3,2,iv); % Begins subplotting current ERP
        plot(taxis, PlotERP(:,:,iv)'); % Plots all sensors across averaged trials for this condition 
        ax = gca; % Edits the plot in figure 1 above
        ax.FontSize = 18; % Sets font size to 18
        ax.Box = 'off';   % Removes the box around the plot
        xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Applies labels to x and y axes 
        xlim([-600 6000]); 
        xticks([-600 0 1000 2000 3000 4000 5000 6000]);
        xline(0,'-k',{'Stimulus Onset'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
        ptitle = strcat('Condition ', Conditions{iv}(end)); 
        title({ ptitle}, 'Interpreter','none') 
    end
    PlotERPAll = mean(PlotERP,3);
    subplot(3,2,(5:6))
    plot(taxis, PlotERPAll')
    ax = gca; % Edits the plot in figure 1 above
    ax.FontSize = 18; % Sets font size to 18
    ax.Box = 'off';   % Removes the box around the plot
    xlabel('Time (ms)'), ylabel('Amplitude (µV)'); % Apply labels to x and y axes 
    xlim([-600 6000]); 
    xticks([-600 0 1000 2000 3000 4000 5000 6000]);
    xline(0,'-k',{'Stimulus Onset'}, 'linewidth', 2, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    yline(0,'-k', 'linewidth', 1, 'labelverticalalignment', 'top', 'labelorientation', 'horizontal');
    ptitle = 'Averaged Across Conditions'; 
    title({ptitle}, 'Interpreter','none') 
    sgridtitle = strcat(AllSubs(i,10:end)); 
    sgtitle({sgridtitle; 'ERPs Across All Sensors'}, 'FontSize', 30)
    print(fig1, '-dtiff', strcat(AllSubs(i,:), '_ERP_Plots.tiff'));
    close all % Clears all figures
    Files2Delete3 = dir('*.app*.mat*'); % Deletes the raw .app.mat files since structure exists now
    for d = 1:size(Files2Delete3,1) % Loops through all .app.mat files present
        delete(Files2Delete3(d).name); % Deletes single .app.mat files present
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

function [outmat] = app2mat(filemat, plotflag)
% app2mat
% reads emegs app file, and turns it into mat with 3 dimensions
for fileindex = 1: size(filemat,1)

    [Data,Version,LHeader,ScaleBins,NChan,NPoints,NTrials,SampRate,AvgRefStatus,File,Path,FilePath,EegMegStatus,NChanExtra,AppFileFormatVal]=...
        ReadAppData(deblank(filemat(fileindex,:)));
    
    if plotflag, plot(Data'), title(deblank(filemat(fileindex,:))), pause(1), end

    outmat = zeros(size(Data,1), size(Data,2), NTrials); 
    
    for x = 1:NTrials
         [outmat(:,:,x),Version,LHeader,ScaleBins,NChan,NPoints,NTrials,SampRate,AvgRefStatus,File,Path,FilePath,EegMegStatus,NChanExtra,AppFileFormatVal]=...
        ReadAppData(deblank(filemat(fileindex,:)),x);
    end

eval(['save ' deblank(filemat(fileindex,:)) '.mat outmat -mat']); 

fclose('all');

end
end 
