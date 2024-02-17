function [tau_vec,dopp_vec,amb] = caf_func(s1,s2,fs,N,numdopps,maxlags,plotswitch)
%
% This function computes the cross ambiguity function for TDOA and FDOA
% estimation.
%
% INPUT:
% s1            - input signal 1 (complex-valued)
% s2            - input signal 2 (complex-valued)           
% fs            - sample rate of input signals (must be the same)
% N             - number of input signal samples to use
% numdopps      - number of doppler bins to compute (ex. 256)
% maxlags       - max lags to compute for TDOA
% plotswitch    - call plotting function
%
% OUTPUT:
% tau_vec       - TDOA axis vector
% dopp_vec      - FDOA axis vector
% amb           - 2-D cross ambiquity function (CAF)
%
% Author: drohm
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
num_dopps = numdopps;           % number of doppler bins to compute
doppler_spacing = .1*fs/N;      % spacing between doppler bins
fdopp = [-num_dopps/2*1:1:num_dopps/2*1-1]*doppler_spacing;    % vector of doppler bin frequencies  

tau_spacing = .1*1/fs; % Get the tau spacing

for mm = 1:num_dopps    % loop over Doppler bins of interest
  comp_exp = exp(-j.*2.*pi.*fdopp(mm).*[0:N-1]./fs);
  h_mm = s2.*comp_exp;  % frequency shift input 1 to doppler bin of interest
  A(:,mm) = xcorr(h_mm,s1,maxlags,'unbiased');  % Compute the CAF
end   
amb = A;

tau_vec = [-maxlags:maxlags].*tau_spacing;
dopp_vec = [-numdopps/2:1:numdopps/2-1].*doppler_spacing;
if plotswitch == 1
    plotcaf(amb,dopp_vec,tau_vec)
end
