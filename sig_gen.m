function [Sa1, Sa2, S1, S2] = sig_gen(f0,fs,Rsym,N,Pc1,Vc1,Pw1,...
            Pc2,Vc2,Pw2,Pe,Ve)
%
% Generates BPSK signal pairs based upon user-defined parameters and
% cartesian emitter-collector geometries. 
%
% Input:
%   f0      - carrier frequency
%   fs      - receiver sample frequency (same for both collectors)
%   Rsym    - Symbol rate
%   N       - Number of samples
%   Pc1     - Collector #1 initial position vector (must not be at origin)
%   Pc2     - Collector #2 initial position vector
%   Vc1     - Collector #1 initial velocity vector
%   Vc2     - Collector #2 initial velocity vector
%   Pw1     - Collector #1 recieved SNR (dB)
%   Pw2     - Collector #2 recieved SNR (dB)
%   Pe      - Emitter initial position vector
%   Ve      - Emitter initial velocity vector
%
% Output:
%   Sa1     - Complex-valued signal at collector 1
%   Sa2     - Complex-valued signal at collector 2
%   S1      - Real-valued signal at collector 1
%   S2      - Real-valued signal at collector 2
%
% Author: drohm
% Modified code that was originally authored by Joel Johnson (NPGS)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

Ts = 1/fs;
Tsym = 1/Rsym;
SNR1 = 10^(Pw1/10);         % convert back from dB to get recieved SNR
SNR2 = 10^(Pw2/10);

Pc1 = [Pc1;zeros(N-1,3)];   % initialize Nx3 array for collector 1 positions
Pe1 = zeros(N,3);
Pc2 = [Pc2;zeros(N-1,3)];   % initialize Nx3 array for collector 2 positions
Pe2 = zeros(N,3);
t1 = zeros(1,N);            % time vectors
t2 = zeros(1,N);
S1 = zeros(1,N);
S2 = zeros(1,N);

A = 1;                      % signal amplitude            
c = 2.997925e8;             % speed of light
Ps = (A^2)/2;               % average power of signal

sigma1 = sqrt(Ps/SNR1);     % calculates noise amplification factors 
sigma2 = sqrt(Ps/SNR2);

%-Generat AWGN samples
Noise1 = sigma1^2*randn(N,1);
Noise2 = sigma2^2*randn(N,1);

%-Build the position vectors for the two collectors
for index = 2:N
    Pc1(index,:) = Pc1(index-1,:) + Ts*Vc1;
    Pc2(index,:) = Pc2(index-1,:) + Ts*Vc2;
end

% Determine first element of Pe1 and t1 where t1(1) is the time at
% the emitter that produces the 1st sample received at collector 1 and 
% Pe1(1,:) is the position of the emitter when it produces the 1st sample
% received by collector 1.
Petmp = Pe(1,:);
t1(1) = -norm(Pc1(1,:) - Petmp)/c;     % minus propogation time from emitter to collector
Petmp = Pe(1,:)+t1(1)*Ve;              % postition of emitter
Pe1(1,:) = Petmp;

% Determine first element of Pe2 and t2 where t2(1) is the time at
% the emitter that produces the 1st sample received at collector 2 and 
% Pe2(1,:) is the position of the emitter when it produces the 1st sample
% received by collector 2.
tempPe = Pe(1,:);
t2(1) = -norm(Pc2(1,:) - tempPe)/c;
tempPe = Pe(1,:)+t2(1)*Ve;
Pe2(1,:) = tempPe;

%-Platform and emitter positions at middle of snapshot
Pcc1 = (Pc1(N/2,:));
Pcc2 = (Pc2(N/2,:));

%-Determine the earliest time at the emitter for this pair of signals.
StartPoint = min(t1(1),t2(1));

% Next 2 lines determine offsets needed for signals 1 & 2 to enter the
% phase vector (P). This simply ensures proper line up so that bit changes
% occur at the right times.
SymbolIndex1 = 1+floor(abs(t1(1)-t2(1))/Tsym)*(t1(1)>t2(1));
SymbolIndex2 = 1+floor(abs(t1(1)-t2(1))/Tsym)*(t2(1)>t1(1));

%-Build the Pe1 and t1 vectors
%-(ie. positions and times when the recieved samples were emitted)
for index = 2:N      
      temp = inf;
      t1(index) = 0;
      %-1st guess is that emitter will advance Ts seconds
      tempPe = Pe(1,:)+(t1(index-1)+Ts)*Ve;
      
      %-Iteratively determines actual time and position for
      % emitter based on instantateous geometry
      while abs(temp-t1(index))>1/f0
          temp = t1(index);
          t1(index) = (index-1)*Ts-norm(Pc1(index,:)-tempPe)/c;
          %-Due to negative times, must multiply Ve by Elapsed time!
          tempPe = Pe1(1,:)+abs(t1(1)-t1(index))*Ve;
      end
      Pe1(index,:) = tempPe;
end

%-Build the Pe2 and t2 vectors
for index = 2:N
      temp = inf;
      t2(index) = 0;
      %-1st guess is that emitter will advance Ts seconds
      tempPe = Pe2(1,:)+(t2(index-1)+Ts)*Ve;
      
      %-Iteratively determins actual time and position for
      % emitter based on instantateous geometry
      while abs(temp-t2(index))>1/f0
          temp = t2(index);
          t2(index) = (index-1)*Ts-norm(Pc2(index,:)-tempPe)/c;
          %-Due to negative times, must multiply Ve by Elapsed time!
          tempPe = Pe2(1,:)+abs(t2(1)-t2(index))*Ve;
      end
      Pe2(index,:) = tempPe;
end

%-This seed insures that every time the program is run (on same computer), 
% the BPSK signals created will have the same random set of data bits
rand('seed',49);

%-Create enough random #'s to figure phase shift
% Since BPSK, random #'s determines if phase is 0 or pi (map onto 1s and 0s)
r = rand(N,1);
P = (r>0.5)*0 + (r<=0.5)*1; 

%-Build transmitted signal #1 vector. These represent pieces of the
% signal that were transmitted by the emitter to arrive at collector 1 at
% its sample intervals. Symbol index is phase adjustment.
S1(1) = A*cos(2*pi*f0*t1(1) + P(SymbolIndex1)*pi) + Noise1(1);

%-The if statement inside the loop changes the data bit if the time has
% advanced into the next symbol period.

for index = 2:N
    if t1(index)-StartPoint>=(SymbolIndex1)*Tsym;
        SymbolIndex1 = SymbolIndex1+1;
    end
    S1(index) = A*cos(2*pi*f0*t1(index)+P(SymbolIndex1)*pi)+Noise1(index);
end

Sa1 = hilbert(S1);  % Calculates the complex-valued signal S1
 
%-Build transmitted signal #2 vector.These represent pieces of the
% signal that were transmitted by the emitter to arrive at collector 2 at
% its sample intervals.
S2(1) = A*cos(2*pi*f0*t2(1) + P(SymbolIndex2)*pi) + Noise2(1);

%-The if statement inside the loop changes the data bit if the time has
% advanced into the next symbol period.
for index = 2:N
    if t2(index)-StartPoint>=(SymbolIndex2)*Tsym;
        SymbolIndex2 = SymbolIndex2+1;
    end
    S2(index) = A*cos(2*pi*f0*t2(index)+P(SymbolIndex2)*pi)+Noise2(index);
end

Sa2 = hilbert(S2);  % Calculates the complex-valued signal S2

%-This function call calculates and displays the explected TDOAs and
% FDOAs at the beginning and end of the collection time. (mod - to get
% TDOA and FDOA predictions at middle time)
%tdoa_fdoa(f0,Pe1(1,:),Pe1(N,:),Pe2(1,:),Pe2(N,:),Ve,Pc1(1,:),Pc1(N,:),Vc1,Pc2(1,:),Pc2(N,:),Vc2);
tdoa_fdoa_center(f0,Pe1(N/2,:),Pe2(N/2,:),Ve,Pc1(N/2,:),Vc1,Pc2(N/2,:),Vc2);

% freq = -fs/2:fs/N:fs/2-fs/N;
% S1f = fftshift(fft(S1));
% S2f = fftshift(fft(S2));


