function [TDOA_b, FDOA_b] = tdoa_fdoa_center(f0,Pe1_b,Pe2_b,Ve,Pc1_b,Vc1,Pc2_b,Vc2)
           
% For use with sig_gen.m in helping to determine the predicted TDOA 
% and FDOA are for two signal vectors.
%
% Input:
%   f0      - carrier frequency
%   Pe1_b   - [x y z] Emitter position wrt collector 1 at middle sample
%   Pe2_b   - [x y z] Emitter position wrt collector 2 at middle sample
%   Ve      - [x y z] Emitter velocity
%   Pc1_b   - [x y z] Collector 1 position at middle sample
%   Vc1     - [x y z] Collector 1 velocity
%   Pc2_b   - [x y z] Collector 2 position at middle sample
%   Vc2     - [x y z] Collector 2 velocity
%
% Output:
%   TDOA_b  - TDOA at the middle of collect
%   FDOA_b  - FDOA at the middle of collect
%
% Author: D.R.Ohm
% Modified code originally authored by Joel Johnson (NPGS)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
c = 2.997925e8;     % speed of light

%-Calculate the Doppler shifts between the emitter and
% collector 1 and collector 2 at the middle of the collection
doppler1_b = f0/c*dot(Ve-Vc1,Pe1_b-Pc1_b)/norm(Pe1_b-Pc1_b)
doppler2_b = f0/c*dot(Ve-Vc2,Pe2_b-Pc2_b)/norm(Pe2_b-Pc2_b)

%-Calculates the FDOA at the middle of the collection time
FDOA_b = doppler1_b-doppler2_b;

%-Calculates the TDOA between the two collectors at the middle 
% of the collection time
TDOA_b = (norm(Pe2_b-Pc2_b) - norm(Pe1_b-Pc1_b))/c;

%-Displays the results in the command line
disp('')
disp('At the middle of the collection, ')
disp(['TDOA = ',num2str(TDOA_b), 'seconds.']);
disp(['FDOA = ',num2str(FDOA_b), 'Hz.']);
disp('');

