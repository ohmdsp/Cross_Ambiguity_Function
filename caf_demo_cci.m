% Script: caf_demo_cci.m
%
% Demo script for CAF with co-channel interference.
% 
% Author: drohm
%------------------------------------------------------------------------
%------------------------------------------------------------------------
clear all; clc;close all

c = 2.997925e8;
fs = 1e6;      % sample rate (samples/sec)
tdurr = .1;      % seconds
N = tdurr*fs;   % samples per block

%-Parameters for SOI
fc1 = fs/6;
Rsym1 = fc1*.1;
Pe1 = [10000 0 20000];       % emitter position (x,y,z)
Ve1 = [0 0 0];       % emitter velocity vector in m/s
Pw1 = 10; Pw2 = 20;

%-Parameters for SNOI
fc2 = fs/5;
Rsym2 = fc2*.1;
Pe2 = [0 0 0];       % emitter position (x,y,z)
Ve2 = [0 0 0];       % emitter velocity vector in m/s
%Pw1 = 20; Pw2 = 20;

%-Collector positions and velocities
Pc1 = [30000 0 0];  % collector 1 position (x,y,z) in meters
Vc1 = [78000 0 0];  % collector 2 velocity vector in m/s
Pc2 = [-1000 0 0];  % collector 1 position (x,y,z) in meters  
Vc2 = [0 0 0];      % collector 2 velocity vector in m/s

%-Generate received signals at both collectors
[Sa1, Sa2, S1, S2] = sig_gen_cci(fc1,fc2,fs,Rsym1,Rsym2,N,Pc1,Vc1,Pw1,...
    Pc2,Vc2,Pw2,Pe1,Ve1,Pe2,Ve2);

%-Compute CAF
numdopps = 512;
maxlags = 512;
plotswitch = 1;
[tau_vec,dopp_vec,amb] = caf_func(Sa1,Sa2,fs,N,numdopps,maxlags,plotswitch); 

% freq = -fs/2:fs/N:fs/2-fs/N;
% S1f = fftshift(fft(S1));
% plot(freq,abs(S1f))
