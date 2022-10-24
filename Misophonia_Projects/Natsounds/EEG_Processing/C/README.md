
![image](https://user-images.githubusercontent.com/89857713/197597017-ad21426a-de73-4ed2-b7c9-2c8fed20f01a.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

Natsounds_Prepare_4_ASSR(AllSubs) % Function that moves files to ASSR folder


![image](https://user-images.githubusercontent.com/89857713/197597181-54df8c9d-037f-4b84-acd3-c22bf7ab3b46.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

timewinSP = [301:749; 750:1198; 1199:1647; 1648:2096; 2097:2545; 2546:2994]; % Create array for time windows in sample points

Natsounds_SingleSubjects_RawFFT(AllSubs, timewinSP) % Function to compute raw FFTs 

Natsounds_GrandAverage_RawFFT() % Function to compute grand average raw FFTs
