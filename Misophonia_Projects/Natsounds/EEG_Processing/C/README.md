
![image](https://user-images.githubusercontent.com/89857713/197597017-ad21426a-de73-4ed2-b7c9-2c8fed20f01a.png)

clc;clear % Cleans up workspace

AllSubs = getfilesindir(pwd, 'natsounds*'); % Grabs all subject folders

Natsounds_Prepare_4_ASSR(AllSubs) % Function that moves files to ASSR folder
