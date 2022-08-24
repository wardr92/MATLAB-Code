function [Trials] = natsounds_CON_FileSort()

% This function grabs the .CON file of a subject and converts each "letter"
% into a numerical string for EMEGS processing 

subfile = getfilesindir(pwd, '*.dat'); % Loads name of .dat file
Trials = readcell(subfile); % Loads .dat file
Trials = Trials(:,5:6); % Grab only relevant columns
Trials(1:9,2) = Trials(1:9,1); % Grab the first 9 trials from column one and place in column 2
Trials = Trials(:,2); % Make only one column for condition file
for ii = 1:size(Trials,1) % converts letters to numbered conditions
    if Trials{ii,1} == 'M'
        Trials{ii,1} = 1;
    elseif Trials{ii,1} == 'U'
        Trials{ii,1} = 2;
    elseif Trials{ii,1} == 'P'
        Trials{ii,1} = 4;
    elseif Trials{ii,1} == 'N'
        Trials{ii,1} = 3;
    end
end
Trials = cell2mat(Trials);  % Converts dat to array

end

