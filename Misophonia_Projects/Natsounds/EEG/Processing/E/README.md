![image](https://user-images.githubusercontent.com/89857713/197606713-5f0788dc-446e-4208-8f49-f039788ddc49.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

noisebins = [7 8 10 11]; % Frequency bins adjacent to foi

Natsounds_SingleSubjects_SlidewinSNR(AllSubs,noisebins) % Function to compute SNR for each specified subject

Natsounds_GrandAverage_SlidewinSNR() % Function to compute SNR grand averages


![image](https://user-images.githubusercontent.com/89857713/197607602-7e7cf8ab-f65c-4d6c-80c7-8bec792bb671.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

cyclelength = 194.1748; % Length of each cycle segments (wavelength X the number of cycles)

Natsounds_SingleSubjects_SlidewinSNR_Mat2emegs(AllSubs, cyclelength) % Function to convert files to emegs format

Natsounds_GrandAverage_SlidewinSNR_Mat2emegs() % Function to convert grand average files to emegs format
