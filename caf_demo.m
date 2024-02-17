% Script: caf_demo.m
%
% Demo script for CAF tools showing common use of functions.
% Notes: Adjust search area by setting numdopps and maxlags. Currently
% cannot shift center of search area (to do). 
%
% 
% Author: drohm
%------------------------------------------------------------------------
%------------------------------------------------------------------------
clear all; clc;close all

fs = 400e6;             % sample rate (samples/sec)
tdurr = .001;          % seconds
N = tdurr*fs;           % samples per block
fc = fs/4;              % center frequency
Rsym1 = fc*.01;         % Modulation symbol rate (BPSK)
c = 2.997925e8;
Pc1 = [10e3 0 2e3];       % collector 1 position (x,y,z) in meters
Vc1 = [7.5e3 0 0];        % collector 2 velocity vector in m/s
Pc2 = [-10e3 0 0];     % collector 1 position (x,y,z) in meters  
Vc2 = [0 0 0];          % collector 2 velocity vector in m/s
Pw1 = 30; Pw2 = 30;     % SNR at collectors (dB)  
Pe = [0 0 0];           % emitter position (x,y,z)
Ve = [0 0 0];           % emitter velocity vector in m/s

%-Generate received signals at both collectors
[Sa1, Sa2, S1, S2] = sig_gen(fc,fs,Rsym1,N,Pc1,Vc1,Pw1,Pc2,Vc2,Pw2,Pe,Ve);

%-Compute CAF
numdopps = 256;
maxlags = 4*512;
plotswitch = 1;
[tau_vec,dopp_vec,amb] = caf_func(Sa1,Sa2,fs,N,numdopps,maxlags,plotswitch); 

% freq = -fs/2:fs/N:fs/2-fs/N;
% S1f = fftshift(fft(S1));
% plot(freq,abs(S1f))
