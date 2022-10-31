function [sensors] = Natsounds_ASSR_contrast_tests(ASSR_AllConditions, sensors, freqbin);

% Only grab from predefined sensors & frequencies
ASSR_AllConditions = squeeze(ASSR_AllConditions(sensors,freqbin,:,:,:)); % Only grab ASSR from predefined sensors and frequencies

% Basic paired t-tests
for i = 1:size(ASSR_AllConditions,1)
    [~, ~, ~, stats_miso_v_neut(i)] = ttest(ASSR_AllConditions(i, 1, :), ASSR_AllConditions(i, 3, :), 'Dim', 3); % Miso vs Neutral
    [~, ~, ~, stats_unpl_v_neut(i)] = ttest(ASSR_AllConditions(i, 2, :), ASSR_AllConditions(i, 3, :), 'Dim', 3); % Unpl vs Neutral
    [~, ~, ~, stats_plea_v_neut(i)] = ttest(ASSR_AllConditions(i, 4, :), ASSR_AllConditions(i, 3, :), 'Dim', 3); % Plea vs Neutral
end

% Plot t-values
taxis = 1:6; % Time bins
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
for ii = 1:size(ASSR_AllConditions,1)
    subplot(3,1,1)
    hold on
    bar(taxis(ii), [stats_miso_v_neut(ii).tstat]); % Plot t-values from Miso vs Neutral
    title('Miso vs Neutral', 'Interpreter','none') 
    xticks([1, 2, 3, 4, 5, 6])
    xlabel('Time Bin'), ylabel('t-value'); % Applies labels to x and y axes 
    hold off
    subplot(3,1,2)
    hold on
    bar(taxis(ii), [stats_unpl_v_neut(ii).tstat]); % Plot t-values from Miso vs Neutral
    xticks([1, 2, 3, 4, 5, 6])
    xlabel('Time Bin'), ylabel('t-value'); % Applies labels to x and y axes 
    title('Unpleasant vs Neutral', 'Interpreter','none') 
    hold off
    subplot(3,1,3)
    hold on
    bar(taxis(ii), [stats_plea_v_neut(ii).tstat]); % Plot t-values from Miso vs Neutral
    xticks([1, 2, 3, 4, 5, 6])
    xlabel('Time Bin'), ylabel('t-value'); % Applies labels to x and y axes 
    title('Pleasant vs Neutral', 'Interpreter','none') 
    hold off
end 
sgtitle({'ASSR Data - t-test Contrasts'}, 'FontSize', 30);

% Basic F values for full model 
repmat = permute(ASSR_AllConditions, [1 3 2]); % Re-arranges dimensions into time x sub x condition array
for iii = 1:size(ASSR_AllConditions,1)
    [Fcontmat(iii),rcontmat,MScont,MScs, dfcs]=contrast_rep(repmat(iii,:,:),[2 1 -1 -2]); % Tests F contrast model (highest for Miso, next for unpl, then plea, and neut)
end 
    
% Plot F-values for full model
fig2 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = 1:6; % Creates a time axis
bar(taxis, Fcontmat); % Plots F-values from model contrasts
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time Bin'), ylabel('F-value'); % Apply labels to x and y axes 
xticks([1,2,3,4,5,6])
title ('ASSR Data - F-test Contrast - All Conditions');

% Basic F values for model without Misophonia
repmat2 = repmat(:,:,2:4);
for iv = 1:size(ASSR_AllConditions,1)
    [Fcontmat(iv),rcontmat,MScont,MScs, dfcs]=contrast_rep(repmat2(iv,:,:),[1 0 -1]); % Tests F contrast model (highest for unpl, then plea, and neut)
end 

% Plot F-values for  model without Misophonia
fig3 = figure('Renderer', 'painters', 'Position', [10 10 1920 1080]); % Sets up figure size 
taxis = 1:6; % Time bins
bar(taxis, Fcontmat); % Plots F-values from model contrasts
ax = gca; % Edits the plot in figure 1 above
ax.FontSize = 18; % Sets font size to 18
ax.Box = 'off';   % Removes the box around the plot
xlabel('Time Bin'), ylabel('F-value'); % Apply labels to x and y axes 
xticks([1,2,3,4,5,6])
title ('ASSR Data - F-test Contrast - All but Misophonia');

end

%% ===== CALLED FUNCTIONS BELOW ===== %%

function [h,p,ci,stats] = ttest(x,m,varargin)
%TTEST  One-sample and paired-sample t-test.
%   H = TTEST(X) performs a t-test of the hypothesis that the data in the
%   vector X come from a distribution with mean zero, and returns the
%   result of the test in H.  H=0 indicates that the null hypothesis
%   ("mean is zero") cannot be rejected at the 5% significance level.  H=1
%   indicates that the null hypothesis can be rejected at the 5% level.
%   The data are assumed to come from a normal distribution with unknown
%   variance.
%
%   X can also be a matrix or an N-D array.   For matrices, TTEST performs
%   separate t-tests along each column of X, and returns a vector of
%   results.  For N-D arrays, TTEST works along the first non-singleton
%   dimension of X.
%
%   TTEST treats NaNs as missing values, and ignores them.
%
%   H = TTEST(X,M) performs a t-test of the hypothesis that the data in
%   X come from a distribution with mean M.  M must be a scalar.
%
%   H = TTEST(X,Y) performs a paired t-test of the hypothesis that two
%   matched samples, in the vectors X and Y, come from distributions with
%   equal means. The difference X-Y is assumed to come from a normal
%   distribution with unknown variance.  X and Y must have the same length.
%   X and Y can also be matrices or N-D arrays of the same size.
%
%   [H,P] = TTEST(...) returns the p-value, i.e., the probability of
%   observing the given result, or one more extreme, by chance if the null
%   hypothesis is true.  Small values of P cast doubt on the validity of
%   the null hypothesis.
%
%   [H,P,CI] = TTEST(...) returns a 100*(1-ALPHA)% confidence interval for
%   the true mean of X, or of X-Y for a paired test.
%
%   [H,P,CI,STATS] = TTEST(...) returns a structure with the following fields:
%      'tstat' -- the value of the test statistic
%      'df'    -- the degrees of freedom of the test
%      'sd'    -- the estimated population standard deviation.  For a
%                 paired test, this is the std. dev. of X-Y.
%
%   [...] = TTEST(X,Y,'PARAM1',val1,'PARAM2',val2,...) specifies one or
%   more of the following name/value pairs:
%
%       Parameter       Value
%       'alpha'         A value ALPHA between 0 and 1 specifying the
%                       significance level as (100*ALPHA)%. Default is
%                       0.05 for 5% significance.
%       'dim'           Dimension DIM to work along. For example, specifying
%                       'dim' as 1 tests the column means. Default is the
%                       first non-singleton dimension.
%       'tail'          A string specifying the alternative hypothesis:
%           'both'  -- "mean is not M" (two-tailed test)
%           'right' -- "mean is greater than M" (right-tailed test)
%           'left'  -- "mean is less than M" (left-tailed test)
%
%   See also TTEST2, ZTEST, SIGNTEST, SIGNRANK, VARTEST.

%   References:
%      [1] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, page 206.

%   Copyright 1993-2017 The MathWorks, Inc.


if nargin > 2
    [varargin{:}] = convertStringsToChars(varargin{:});
end

if nargin < 2 || isempty(m)
    m = 0;
elseif ~isscalar(m) % paired t-test
    if ~isequal(size(m),size(x))
        error(message('stats:ttest:InputSizeMismatch'));
    end
    x = x - m;
    m = 0;
end

% Process remaining arguments
alpha = 0.05;
tail = 0;    % code for two-sided
dim = '';

if nargin>=3
    if isnumeric(varargin{1})
        % Old syntax
        %    TTEST(X,M,ALPHA,TAIL,DIM)
        alpha = varargin{1};
        if nargin>=4
            tail = varargin{2};
             if nargin>=5
                dim = varargin{3};
             end
        end
                
    elseif nargin==3 
            error(message('stats:ttest:BadAlpha'));
   
    else
        % Calling sequence with named arguments
        okargs =   {'alpha' 'tail' 'dim'};
        defaults = {0.05    'both' ''};
        [alpha, tail, dim] = ...
                         internal.stats.parseArgs(okargs,defaults,varargin{:});
    end
end

% Argument error checking
if isempty(alpha)
    alpha = 0.05;
elseif ~isscalar(alpha) || ~isnumeric(alpha) || isnan(alpha) || (alpha <= 0) || (alpha >= 1)
    error(message('stats:ttest:BadAlpha'));
end
if isempty(tail)
    tail = 0;
elseif isnumeric(tail) && isscalar(tail) && ismember(tail,[-1 0 1])
    % OK, grandfathered
else
    [~,tail] = internal.stats.getParamVal(tail,{'left','both','right'},'''tail''');
    tail = tail - 2;
end

if isempty(dim)
    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end

nans = isnan(x);
if any(nans(:))
    samplesize = sum(~nans,dim);
else
    samplesize = size(x,dim); % a scalar, => a scalar call to tinv
end
df = max(samplesize - ones('like',x), 0); % make sure df is the same type as X
xmean = nanmean(x,dim);
sdpop = nanstd(x,[],dim);
sqrtn = sqrt(samplesize);
xdiff = (xmean - m);

% Check for rounding issues causing spurious differences
fix = (xdiff~=0) ...                                     % a difference
    & (abs(xdiff) < 100*sqrtn.*max(eps(xmean),eps(m)));  % but a small one
if any(fix(:))
    % Fix any columns that are constant, even if computed difference is
    % non-zero but small
    constvalue = min(x,[],dim);
    fix = fix & all(x==constvalue | isnan(x),dim);
end
if any(fix(:))
    % Set difference and standard deviation to 0, and recompute mean
    xdiff(fix) = 0;
    sdpop(fix) = 0;
    xmean = xdiff+m;
end

ser = sdpop ./ sqrtn;
tval = xdiff ./ ser;
if nargout > 3
    stats = struct('tstat', tval, 'df', df, 'sd', sdpop);
    if isscalar(df) && ~isscalar(tval)
        stats.df = repmat(stats.df,size(tval));
    end
end

% Compute the correct p-value for the test, and confidence intervals
% if requested.
if tail == 0 % two-tailed test
    p = 2 * tcdf(-abs(tval), df);
    if nargout > 2
        crit = tinv((1 - alpha / 2), df) .* ser;
        ci = cat(dim, xmean - crit, xmean + crit);
    end
elseif tail == 1 % right one-tailed test
    p = tcdf(-tval, df);
    if nargout > 2
        crit = tinv(1 - alpha, df) .* ser;
        ci = cat(dim, xmean - crit, Inf(size(p)));
    end
elseif tail == -1 % left one-tailed test
    p = tcdf(tval, df);
    if nargout > 2
        crit = tinv(1 - alpha, df) .* ser;
        ci = cat(dim, -Inf(size(p)), xmean + crit);
    end
end
% Determine if the actual significance exceeds the desired significance
h = cast(p <= alpha, 'like', p);
h(isnan(p)) = NaN; % p==NaN => neither <= alpha nor > alpha
end 

function [Fcontmat,rcontmat,MScont,MScs, dfcs]=contrast_rep(repeatmat,weights);
%[Fcontmat,refmat]=repeatcon(repeatmat,weights);
%Calculates F-value for trend analysis for a repeated measures factor and
%returns values in Fcontmat. Effect size estimate r(contrast) according to
%Rosenthal et al. are returned in rcontmat. Neither the F-value nor the
%r(contrast) gives you information about the direction of the trend!
%	repeatmat: is a data array arranged such that channels/sensors etc. 
%				are represented as rows, subjects as columns and conditions
%				in the 3. dimension.
%				[sensors,subject, ]!!!!!!!!!!!!!!!!!!!!!
%               Arrange the conditions in such a way that
%				they correspond to the trend.
%               Function sort4trend then arranges it
%				in an appropriate way for contrast analysis.
%	weights: always have to sum up to zero. Following weights for orthogonal
%				contrasts (linear, quadratic, cubic) are suggeste by Rosenthal 
%				& Rosnow (1985).
%			2 conditions:
%				lin: [-1 1]
%			3 conditions:
%				lin: [-1 0 1], quad: [1 -2 1]
%			4 conditions:
%				lin: [-3 -1 1 3], quad: [1 -1 -1 1], cub: [-1 3 -3 1]
%			5 conditions:
%				lin: [-2 -1 0 1 2], quad: [2 -1 -2 -1 2], cub: [-1 2 0 -2 1]
%			6 conditions:
%				lin: [-5 -3 -1 1 3 5]
%				quad: [5 -1 -4 -4 -1 5]
%				cub: [-5 7 4 -4 -7 5]
%			7 conditions:
%				lin: [-3 -2 -1 0 1 2 3] 	
%				quad: [5 0 -3  -4 -3 0 5]
%				cub: [-1 1 1 0 -1 -1 1]
%			8 conditions:
%				lin: [-7 -5 -3 -1 1 3 5 7]
%				quad: [7 1 -3 -5 -5 -3 1 7]
%				cub: [-7 5 7 3 -3 -7 -5 7]
%			9 conditions:
%				lin: [-4 -3 -2 -1 0 1 2 3 4]
%				quad: [28 7 -8 -17 -20 -17 -8 7 28]
%				cub: [-14 7 13 9 0 -9 -13 -7 14]
%			10 conditions:
%				lin: [-9 -7 -5 -3 -1 1 3 5 7 9]
%				quad: [6 2 -1 -3 -4 -4 -3 -1 2 6]
%				cub: [-42 14 35 31 12 -12 -31 -35 -14 42]
%
%Function created according to R. Rosenthal & R. Rosnow (1985). Contrast
%analysis: Focused comparisons in the analysis of variance. Cambridge: CUP.
%
%Further resource: R. Rosenthal, R. Rosnow & D.B. Rubin (2000). Contrasts
%and effect sizes in behavioral research: a correlational approach. Cambridge:
%CUP.
%
%Nathan, 2002

%hier Vp als Reihe, Bedingung als Spalte

[repeatmat]=sort4trend(repeatmat);

[m,n,o]=size(repeatmat);

for j = 1:o

if abs(sum(weights)) > 0.00001, error('wrong weights !!!'), break, end    

%Berechnung von Mean square contrast
sumrep = sum(repeatmat(:,:,j));%summierte ?ber Vps

size(sumrep);

L2 = (sum(sumrep.*weights)).^2;

MScont(j,1) = L2/(m*sum(weights.^2));

%Corrections of data matrix

	%for Grand Mean

corGM=repeatmat(:,:,j) - mean(mean(repeatmat(:,:,j)));

	%for row effect

rowef=mean(corGM,2);

[m,n]=size(repeatmat(:,:,j));

for i =1:n
	corGMR(1:m,i) = corGM(1:m,i)-rowef;
end

	%for column effect

colef = mean(corGMR);

for i =1:m
	corGMRC(i,1:n)=corGMR(i,1:n)-colef;
end

%sum of squares for condition x subjects
%this is used as error term for calculation of F. one also could
%calculate seperate error terms for each trend type. see Rosnow &
%Rosenthal for details. the approach here is sufficient in most cases.

SScs = sum(sum(corGMRC.^2));

dfcs = m*(n-1);
	
MScs(j,1) = SScs/dfcs;

Fcont = MScont(j,1)/MScs(j,1);

Fcontmat(j,1) = Fcont; 

%Calculat effect size r(contrast). Use of df of pooled error term will lead
%to underestimation of effect size. df has to be divided by factor number
%of conditions minus one.

rcont=sqrt(Fcont/(Fcont+(dfcs/(n-1))));

rcontmat(j,1) = rcont;

end

%sprintf('concerning F: degrees of freedom are 1,%d',dfcs)
end 
