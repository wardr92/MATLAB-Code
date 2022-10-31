function [ASSR_0to1, ASSR_1to2, ASSR_2to3, ASSR_3to4, ASSR_4to5, ASSR_5to6] = Natsounds_ASSR_extraction(ASSR_AllConditions, sensors, freqbin);

% Only grab from predefined sensors & frequencies
ASSR_AllConditions = squeeze(ASSR_AllConditions(sensors,freqbin,:,:,:)); % Only grab ASSR from predefined sensors and frequencies

% Extract ASSR data from each time bin for each condition in each subject
ASSR_AllConditions = permute(ASSR_AllConditions, [3,2,1]); % rearrange into sub x condition x time bin array
for i = 1:size(ASSR_AllConditions,2) % Loops through each condition 
    ASSR_0to1(:,i) = squeeze(ASSR_AllConditions(:,i,1)); % Extracts ASSR data for subject
    ASSR_1to2(:,i) = squeeze(ASSR_AllConditions(:,i,2)); % Extracts ASSR data for subject
    ASSR_2to3(:,i) = squeeze(ASSR_AllConditions(:,i,3)); % Extracts ASSR data for subject
    ASSR_3to4(:,i) = squeeze(ASSR_AllConditions(:,i,4)); % Extracts ASSR data for subject
    ASSR_4to5(:,i) = squeeze(ASSR_AllConditions(:,i,5)); % Extracts ASSR data for subject
    ASSR_5to6(:,i) = squeeze(ASSR_AllConditions(:,i,6)); % Extracts ASSR data for subject
end

end 
