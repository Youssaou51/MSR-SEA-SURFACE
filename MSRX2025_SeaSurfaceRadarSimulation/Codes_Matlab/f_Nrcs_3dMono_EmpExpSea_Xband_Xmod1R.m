function [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = f_Nrcs_3dMono_EmpExpSea_Xband_Xmod1R (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Xband_Xmod1R
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV polarization and in X band (10.00 GHz), with respect to the empirical 
% model of Ren et al. (IJRS 2012) "XMOD1", for incidence angles 20°-60° (45°?):
% - Th_i_d must be between 20°-60° (45°?)
% - u10_ms must be between 0-20 m/s (rather 14?)
% - (winddir_d must be between 0°-360°
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d        : incidence angle with respect to the vertical z (deg.) [Vector]
% u10_ms        : wind speed at 10 m above the sea surface (m/s) [scalar]
% windDir_d     : wind direction with respect to the incidence azimuth 
%                 direction, \phi-\phi0 (deg.) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_VV  : NRCS with respect to considered model in VV polarization [Vector - lin. scale]
% Nrcs_Mdl_HH  : NRCS with respect to considered model in HH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% Y. Ren et al., "An algorithm for the retrieval of sea surface wind ?elds 
% using X-band TerraSAR-X data", International Journal of Remote Sensing, 
% vol. 33, no. 23, pp. 7310-7336, 2012
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 07/2013
%--------------------------------------------------------------------------

% Applicability domain of the empirical/experimental model (XMOD1-Ren here):
% It = find( Th_i_d < 20 | Th_i_d > 45 ) ;
It = find( Th_i_d < 20 | Th_i_d > 60 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
%     disp('/!\ 20° <= Th_i_d <= 45° /!\') ;
    disp('/!\ 20° <= Th_i_d <= 60° /!\') ;
    pause(1) ;
end
% if (u10_ms > 20)
if (u10_ms < 02) || (u10_ms > 20)
% if (u10_ms < 02) || (u10_ms > 14)
    disp(u10_ms) ;
    disp('Model not reliable above 20 m/s...') ;
    pause(1) ;
end

% xi [2012_Ren_IJRS,Tab.2]:
X0 = [   1.9010   1.9185   1.8876   1.902367 ] ; % ±...
X1 = [   0.8321   0.8324   0.8402   0.8349   ] ; % ±...
X2 = [ -37.6886 -37.6253 -37.5038 -37.6059   ] ; % ±...
X3 = [   1.7375   1.7475   1.7834   1.756133 ] ; % ±...
X4 = [  -0.0825  -0.0823  -0.0856  -0.08347  ] ; % ±...

% NRCS in linear scale:
i_ds = 1 ; % choice of data set!!!
% i_ds = 4 ; % choice of data set!!!
Nrcs_Mdl_VV = X0(i_ds) + X1(i_ds) * u10_ms + X2(i_ds) * sind(Th_i_d) + (X3(i_ds) + X4(i_ds) * u10_ms) * cosd(2*windDir_d) ; % [2012_Ren_IJRS,eq.3]
Nrcs_Mdl_VV = 10.^(Nrcs_Mdl_VV/10) ;
Nrcs_Mdl_HH = zeros(size(Nrcs_Mdl_VV)) ;
% Nrcs_Mdl_HH = 10.^(Nrcs_Mdl_HH/10) ;
%
Nrcs_Mdl_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Mdl_HH(It) = 0 ; % ou plutôt NaN
