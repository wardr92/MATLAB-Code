![image](https://user-images.githubusercontent.com/89857713/197608511-b1bed17d-f234-4ea3-b142-819fc3546060.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

Natsounds_Prepare_4_Hilbert(AllSubs); % Moves .mat All Conditions file into a new directory for Hilbert Transformations


![image](https://user-images.githubusercontent.com/89857713/197608554-e822370b-60f3-402d-a80e-d293a346a6d5.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

taggingfreq = 41.2; % Tagging frequency of interest

filterorder = 18; % Filter order

sensor2plot = 1:129; % Sensors to plot

plotflag = 0; % Show plots or not

fsamp = 500; % Current sampling rate

baselinecorr = 100:200; % Baseline correction interval in sample points

Natsounds_SingleSubjects_HilbertTransformation(AllSubs, taggingfreq, filterorder, sensor2plot, plotflag, fsamp, baselinecorr) % Hilbert Transformation function for each subject indicated

Natsounds_GrandAverage_HilbertTransformation() % Grand average Hilberts


![image](https://user-images.githubusercontent.com/89857713/197608727-1604f5aa-9026-4337-94b1-a22393be7662.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

fsamp = 500; % Sampling rate

Natsounds_SingleSubjects_HilbertTransformation_EmegsConversion(AllSubs, fsamp)% Converts all subject files into emegs format

Natsounds_GrandAverage_HilbertTransformation_EmegsConversion(fsamp) % Converts grand averaged data into emegs format
