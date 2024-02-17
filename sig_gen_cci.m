function [s1,s2,sr1,sr2,fs] = sig_gen_cci(fc1,fc2,fs,Rsym1,Rsym2,N,Pc1,Vc1,Pw1,...
            Pc2,Vc2,Pw2,Pe1,Ve1,Pe2,Ve2) 
%
% Generates simulated signals for both SOI and SNOI (i.e., co-channel interference)
%
% Input:
%   fc1     - carrier frequency of SOI
%   fc2     - carrier frequency of SNOI
%   fs      - receiver sample frequency (same for both collectors)
%   Rsym1   - Symbol rate of SOI
%   Rsym2   - Symbol rate of SNOI
%   N       - Number of samples
%   Pc1     - Collector #1 initial position vector (must not be at origin)
%   Pc2     - Collector #2 initial position vector
%   Vc1     - Collector #1 initial velocity vector
%   Vc2     - Collector #2 initial velocity vector
%   Pw1     - Collector #1 recieved SNR (dB) - vector [P_SOI P_SNOI]
%   Pw2     - Collector #2 recieved SNR (dB) - vector [P_SOI P_SNOI]
%   Pe1     - Emitter initial position vector
%   Ve1     - Emitter initial velocity vector
%   Pe2     - Interference emitter initial position vector
%   Ve2     - Interference emitter initial velocity vector
%
% Output:
%   s1      - Complex-valued signal at collector 1
%   s2      - Complex-valued signal at collector 2
%   sr1     - Real-valued signal at collector 1
%   sr2     - Real-valued signal at collector 2
%
% Needed Files:
% sig_gen.m
%
% Author: drohm
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
s1 = zeros(1,N);
s2 = zeros(1,N);
sr1 = zeros(1,N);
sr2 = zeros(1,N);

%-Generate signal pair for SOI
disp(['Measurement Predictions for SOI'])
[Sa1, Sa2, S1, S2] = sig_gen(fc1,fs,Rsym1,N,Pc1,Vc1,Pw1,Pc2,Vc2,Pw2,Pe1,Ve1);
s1 = s1+Sa1; s2 = s2+Sa2;
sr1 = sr1+S1; sr2 = sr2+S2;

%-Generate signal pair for SNOI
disp(' ')
disp(['Measurement Predictions for SNOI'])
[Sa1, Sa2, S1, S2] = sig_gen(fc2,fs,Rsym2,N,Pc1,Vc1,Pw1,Pc2,Vc2,Pw2,Pe2,Ve2);
s1 = s1+Sa1; s2 = s2+Sa2;
sr1 = sr1+S1; sr2 = sr2+S2;

%-Scale signal amplitudes by 1/2
s1 = s1/2; s2 = s2/2;
sr1 = sr1/2; sr2 = sr2/2;



