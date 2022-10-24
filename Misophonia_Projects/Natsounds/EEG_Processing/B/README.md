![image](https://user-images.githubusercontent.com/89857713/197596778-18ea9949-c706-4e3f-afcc-0ac4faf7af1a.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

Natsounds_SingleSubjects_App2MatConversion(AllSubs) % Function that converts .app files to .mat files for each subject specified 

Natsounds_GrandAverage_App2MatConversion() % Function that computes grand average ERP from converted .mat files 
