function plotcaf(amb,dopp_vec, tau_vec)
%
% This is a function for plotting the cross ambiguity function (CAF). It
% takes input from the computecaf.m function.
%
% INPUT:
% amb               - 2-D ambiquity function
% tau_vec           - TDOA axis vector
% dopp_vec          - FDOA axis vector
%
% OUTPUT:
% flag              - diagnostics flag
% 
% Author: drohm
%------------------------------------------------------------------------
Z = amb;
flag = 1;

figure
surf(1e6*tau_vec, dopp_vec, abs(Z'));
view(3)
shading interp
lightangle(-30,30)
set(gcf,'Renderer','zbuffer')
set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.3,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit')

colormap jet
axis tight
title('CAF');
xlabel('TDOA (microsec)');
ylabel('FDOA (Hz)');
zlabel('|A(t,f)|')

% amb = abs(Z');
% [mm,nn] = find(amb == max(max(amb)));
% td=interp(amb(mm,:),8);
% tf=interp(amb(:,nn),8);
% tdvec = interp(tau_vec,8);
% fdvec = interp(dopp_vec,8);
% [tdmax,tdn] = max(td);
% [fdmax,fdn] = max(tf);
% tdest=tdvec(tdn);
% fdest=fdvec(fdn);
% 
%  disp(' ')
%  disp(['Measured TDOA = ',num2str(tdest),' (sec)'])
%  disp(['Measured TDOA = ',num2str(fdest),' (Hz)'])
%  disp(' ')
% 
% figure 
% subplot(2,1,1) % This is the 2-D view along the TDOA axis 
% plot(1e6*tau_vec,amb(mm,:),'b','LineWidth',1.2)
% xlabel('TDOA (microsec)'); ylabel('Magnitude');
% title(['CAF Method Estimated TDOA = ',num2str(TDOAe),' (microsec)'])
% grid off; axis tight 
% subplot(2,1,2) % This is the 2-D view along the FDOA axis 
% plot(dopp_vec,amb(:,nn),'b','LineWidth',1.2)
% xlabel('FDOA (Hz)'); ylabel('Magnitude'); 
% title(['CAF Method Estimated FDOA = ',num2str(FDOAe),' (Hz)'])
% grid off;axis tight
 
%--This one is a 2-D view looking down on the plane %% 
figure
imagesc(1e6*tau_vec, dopp_vec, abs(Z'));
%contour(1e6*tau_vec, 1e-3*dopp_vec, abs(Z'),10);
shading interp
colormap jet
axis tight;grid on
title('CAF');
xlabel('TDOA (microsec)');
ylabel('FDOA (Hz)');
zlabel('|A(t,f)|')

