function [Fcontmat,rcontmat,MScont,MScs, dfcs]=contrast_rep(repeatmat,weights);%[Fcontmat,refmat]=repeatcon(repeatmat,weights);%Calculates F-value for trend analysis for a repeated measures factor and%returns values in Fcontmat. Effect size estimate r(contrast) according to%Rosenthal et al. are returned in rcontmat. Neither the F-value nor the%r(contrast) gives you information about the direction of the trend!%	repeatmat: is a data array arranged such that channels/sensors etc. %				are represented as rows, subjects as columns and conditions%				in the 3. dimension.%				[sensors,subject, ]!!!!!!!!!!!!!!!!!!!!!%               Arrange the conditions in such a way that%				they correspond to the trend.%               Function sort4trend then arranges it%				in an appropriate way for contrast analysis.%	weights: always have to sum up to zero. Following weights for orthogonal%				contrasts (linear, quadratic, cubic) are suggeste by Rosenthal %				& Rosnow (1985).%			2 conditions:%				lin: [-1 1]%			3 conditions:%				lin: [-1 0 1], quad: [1 -2 1]%			4 conditions:%				lin: [-3 -1 1 3], quad: [1 -1 -1 1], cub: [-1 3 -3 1]%			5 conditions:%				lin: [-2 -1 0 1 2], quad: [2 -1 -2 -1 2], cub: [-1 2 0 -2 1]%			6 conditions:%				lin: [-5 -3 -1 1 3 5]%				quad: [5 -1 -4 -4 -1 5]%				cub: [-5 7 4 -4 -7 5]%			7 conditions:%				lin: [-3 -2 -1 0 1 2 3] 	%				quad: [5 0 -3  -4 -3 0 5]%				cub: [-1 1 1 0 -1 -1 1]%			8 conditions:%				lin: [-7 -5 -3 -1 1 3 5 7]%				quad: [7 1 -3 -5 -5 -3 1 7]%				cub: [-7 5 7 3 -3 -7 -5 7]%			9 conditions:%				lin: [-4 -3 -2 -1 0 1 2 3 4]%				quad: [28 7 -8 -17 -20 -17 -8 7 28]%				cub: [-14 7 13 9 0 -9 -13 -7 14]%			10 conditions:%				lin: [-9 -7 -5 -3 -1 1 3 5 7 9]%				quad: [6 2 -1 -3 -4 -4 -3 -1 2 6]%				cub: [-42 14 35 31 12 -12 -31 -35 -14 42]%%Function created according to R. Rosenthal & R. Rosnow (1985). Contrast%analysis: Focused comparisons in the analysis of variance. Cambridge: CUP.%%Further resource: R. Rosenthal, R. Rosnow & D.B. Rubin (2000). Contrasts%and effect sizes in behavioral research: a correlational approach. Cambridge:%CUP.%%Nathan, 2002%hier Vp als Reihe, Bedingung als Spalte[repeatmat]=sort4trend(repeatmat);[m,n,o]=size(repeatmat);for j = 1:oif abs(sum(weights)) > 0.00001, error('wrong weights !!!'), break, end    %Berechnung von Mean square contrastsumrep = sum(repeatmat(:,:,j));%summierte ?ber Vpssize(sumrep);L2 = (sum(sumrep.*weights)).^2;MScont(j,1) = L2/(m*sum(weights.^2));%Corrections of data matrix	%for Grand MeancorGM=repeatmat(:,:,j) - mean(mean(repeatmat(:,:,j)));	%for row effectrowef=mean(corGM,2);[m,n]=size(repeatmat(:,:,j));for i =1:n	corGMR(1:m,i) = corGM(1:m,i)-rowef;end	%for column effectcolef = mean(corGMR);for i =1:m	corGMRC(i,1:n)=corGMR(i,1:n)-colef;end%sum of squares for condition x subjects%this is used as error term for calculation of F. one also could%calculate seperate error terms for each trend type. see Rosnow &%Rosenthal for details. the approach here is sufficient in most cases.SScs = sum(sum(corGMRC.^2));dfcs = m*(n-1);	MScs(j,1) = SScs/dfcs;Fcont = MScont(j,1)/MScs(j,1);Fcontmat(j,1) = Fcont; %Calculat effect size r(contrast). Use of df of pooled error term will lead%to underestimation of effect size. df has to be divided by factor number%of conditions minus one.rcont=sqrt(Fcont/(Fcont+(dfcs/(n-1))));rcontmat(j,1) = rcont;end%sprintf('concerning F: degrees of freedom are 1,%d',dfcs)