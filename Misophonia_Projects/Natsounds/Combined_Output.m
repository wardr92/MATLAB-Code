function[Combined_Rating] = Combined_Output(Valence_Ratings, Arousal_Ratings);

% Checks to make sure valence and arousal data matrices match
if size(Valence_Ratings) == size(Arousal_Ratings)
    
    % Loops through all misophonia ratings to compute a combined score
    for x = 1:size(Valence_Ratings,1)
        Combined_Rating(x,:) = sqrt((Valence_Ratings(x,:).^2) + (Arousal_Ratings(x,:).^2));
    end
else 
    fprintf('Valence & Arousal Data Not Correct - Double Check Variables\n')
end
end