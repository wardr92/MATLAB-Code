![image](https://user-images.githubusercontent.com/89857713/197599739-6d598027-1d5f-44e6-be89-e2b9a5c031a1.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

ASSR_Bins = [301:801; 801:1301; 1301:1801; 1801:2301; 2301:2801; 2801:3301]; % Creates array for ASSR time bins  

ASSR_BinNames = ['0-1_seconds'; '1-2_seconds'; '2-3_seconds'; '3-4_seconds'; '4-5_seconds'; '5-6_seconds']; % Creates array of names for ASSR time bins  

plotflag = 0; % Show plots or not

bslvec = 1:300; % Baseline interval in sampling points

foi = 41.2; % Tagging frequency of interest

sampnew = 824; % New sampling rate

fsamp = 500; % Original sampling rate

Natsounds_SingleSubjects_SlidingWindow(AllSubs, ASSR_Bins, ASSR_BinNames, plotflag, bslvec, foi, sampnew ,fsamp) % Function to conduct sliding window analyses

Natsounds_GrandAverage_SlidingWindow() % Function to compute grand average sliding window analyses


![image](https://user-images.githubusercontent.com/89857713/197599843-e3801638-6405-4fa3-985f-2ff786088429.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

fsamp = 824; % Sampling rate from sliding window analysis

Natsounds_SingleSubjects_SlidewinFFT(AllSubs, fsamp) % Function to compute FFT for sliding window data

Natsounds_GrandAverage_SlidewinFFT() % Function to compute grand average FFT on sliding window data


![image](https://user-images.githubusercontent.com/89857713/197606430-5c90b94a-15bb-4537-b16b-35676df2d09c.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

cyclelength = 194.1748; % Length of each cycle segments (wavelength X the number of cycles)

Natsounds_SingleSubjects_SlidewinFFT_Mat2emegs(AllSubs, cyclelength) % Function to convert files to emegs format

Natsounds_GrandAverage_SlidewinFFT_Mat2emegs() % Function to convert grand average files to emegs format


![image](https://user-images.githubusercontent.com/89857713/197606713-5f0788dc-446e-4208-8f49-f039788ddc49.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

noisebins = [7 8 10 11]; % Frequency bins adjacent to foi

Natsounds_SingleSubjects_SlidewinSNR(AllSubs,noisebins) % Function to compute SNR for each specified subject

Natsounds_GrandAverage_SlidewinSNR() % Function to compute SNR grand averages
