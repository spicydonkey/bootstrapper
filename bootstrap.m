function [booterr,bootmean,bootFeval,I_bootsamp] = bootstrap(nboot,bootfun,D,bootfrac)
%BOOTSTRAP
%
%   [err,mu,F,I] = bootstrap(B,fun,data,frac)
%
% DKS 2020

%%% Input check.
if nargin < 3
    error('Not enough input arguments to run bootstrap.');
end
if nargin == 3
    bootfrac = 1;
end
    
%%% Input parsing.
% p = inputParser;
% addParameter(p,'UseParallel',false);

%%% Set up bootstrapper.
N_D = size(D,1);                    % number of data points
N_bootsamp = round(bootfrac*N_D);   % number of data in bootstrapped sample
eta = N_bootsamp/N_D;               % actual bootstrap sampled fraction
I_bootsamp = randi(N_bootsamp,[nboot,N_bootsamp]);      % index to bootstrapping sample

%%% Bootstrapping.
bootFeval = cell(nboot,1);   % preallocate as cell array containing function output
% parfor ii = 1:nboot
progressbar('bootstrap');
for ii = 1:nboot
    F = feval(bootfun,D(I_bootsamp(ii,:)));
    bootFeval{ii} = F(:)';
    progressbar(ii/nboot);
end
bootFeval = vertcat(bootFeval{:});
bootmean = mean(bootFeval,1,'omitnan');
booterr = sqrt(eta)*std(bootFeval,1,1,'omitnan');

end