function [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = f_Nrcs_3dMono_EmpExpSea_Xband_Masuko (Th_i_d, u19_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Xband_Masuko
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations and in X band (10.00 GHz), with respect to the empirical 
% model of Masuko et al. (JGR 1986), for incidence angles 30°,40°,50°,60°:
% - Th_i_d must be between 30°-60° [data tabulated with a step of 10°]
% - u10_ms must be between 3.2-17.2 m/s [...]
% - (winddir_d must be between 0°-360° [data tabulated with a step of 90°])
% For the other values, the data are interpolated in dB scale 
% (1D linear interpolation here)
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d        : incidence angle with respect to the vertical z (deg.) [Vector]
% u19_ms        : wind speed at 19.5 m above the sea surface (m/s) [scalar]
% windDir_d     : wind direction with respect to the incidence azimuth 
%                 direction, \phi-\phi0 (deg.) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_VV : NRCS under considered model in VV polarization [Vector - lin. scale]
% Nrcs_Mdl_HH : NRCS under considered model in HH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% M. Masuko K. Okamoto M. Shimada and S. Niwa,
% "Measurements of microwave bsckscattering signatures of the oecan surface 
% using X band ang Ka Band airbone scatterometers",
% J. Geo. Res. 91(C11), pp. 13065-13088, 1986
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 07/2013
%--------------------------------------------------------------------------

% Applicability domain of the empirical/experimental model (Masuko here):
% It = find( Th_i_d < 0 | Th_i_d > 70 ) ;
It = find( Th_i_d < 30 | Th_i_d > 60 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
%     disp('/!\ 0° <= Th_i_d <= 70° /!\') ;
    disp('/!\ 30° <= Th_i_d <= 60° /!\') ;
    pause(1) ;
end
if (u19_ms < 3.2) || (u19_ms > 17.2)
    disp(u19_ms) ;
    disp('/!\ 3.2 m/s <= u19_ms <= 17.2 m/s /!\') ;
    pause(1) ;
end

% Constants (see Table 3 of [1986_Masuko_JGR]):
GV_up = [ -2.762 -3.534 -4.077 -4.281 ] ; % G coef. - upwind     (VV) - 10.00 GHz
GV_do = [ -3.008 -3.807 -4.327 -4.364 ] ; % G coef. - downwind   (VV) - 10.00 GHz
GV_cr = [ -3.074 -3.807 -4.464 -4.599 ] ; % G coef. - cross-wind (VV) - 10.00 GHz
% GV_up = [ -2.633 -2.800 -3.629 -3.962 ] ; % G coef. - upwind     (VV) - 34.43 GHz
% GV_do = [ -2.307 -3.404 -4.120 -4.157 ] ; % G coef. - downwind   (VV) - 34.43 GHz
% GV_cr = [ -3.315 -4.333 -5.170 -4.897 ] ; % G coef. - cross-wind (VV) - 34.43 GHz
%
GH_up = [ -2.827 -3.826 -4.547 -4.925 ] ; % G coef. - upwind     (HH) - 10.00 GHz
GH_do = [ -2.996 -4.271 -5.178 -5.404 ] ; % G coef. - downwind   (HH) - 10.00 GHz
GH_cr = [ -3.134 -4.152 -5.027 -5.636 ] ; % G coef. - cross-wind (HH) - 10.00 GHz
% GH_up = [ -2.357 -3.723 -4.797 -4.668 ] ; % G coef. - upwind     (HH) - 34.43 GHz
% GH_do = [ -2.520 -4.687 -5.478 -4.959 ] ; % G coef. - downwind   (HH) - 34.43 GHz
% GH_cr = [ -2.323 -4.993 -5.085 -5.095 ] ; % G coef. - cross-wind (HH) - 34.43 GHz
%
HV_up = [ 1.704 1.977 2.240 2.296 ] ; % H coef. - upwind     (VV) - 10.00 GHz
HV_do = [ 1.787 2.104 2.488 2.309 ] ; % G coef. - downwind   (VV) - 10.00 GHz
HV_cr = [ 1.548 1.690 2.120 2.048 ] ; % G coef. - cross-wind (VV) - 10.00 GHz
% HV_up = [ 1.488 1.285 1.791 1.884 ] ; % H coef. - upwind     (VV) - 34.43 GHz
% HV_do = [ 1.002 1.721 2.112 1.809 ] ; % G coef. - downwind   (VV) - 34.43 GHz
% HV_cr = [ 1.668 2.155 2.600 2.125 ] ; % G coef. - cross-wind (VV) - 34.43 GHz
%
HH_up = [ 1.720 2.083 2.363 2.492 ] ; % G coef. - upwind     (HH) - 10.00 GHz
HH_do = [ 1.692 2.304 2.823 2.696 ] ; % G coef. - downwind   (HH) - 10.00 GHz
HH_cr = [ 1.628 1.861 2.370 2.634 ] ; % G coef. - cross-wind (HH) - 10.00 GHz
% HH_up = [ 1.180 1.951 2.544 2.211 ] ; % G coef. - upwind     (HH) - 34.43 GHz
% HH_do = [ 1.081 2.610 2.913 2.148 ] ; % G coef. - downwind   (HH) - 34.43 GHz
% HH_cr = [ 0.677 2.576 2.299 2.110 ] ; % G coef. - cross-wind (HH) - 34.43 GHz

% NRCSs (dB) (see eq.7 of [1986_Masuko_JGR]):
SigmaV1_up = 10 * ( GV_up + HV_up * log10(u19_ms) ) ;
SigmaV1_do = 10 * ( GV_do + HV_do * log10(u19_ms) ) ;
SigmaV1_cr = 10 * ( GV_cr + HV_cr * log10(u19_ms) ) ;
%
SigmaH1_up = 10 * ( GH_up + HH_up * log10(u19_ms) ) ;
SigmaH1_do = 10 * ( GH_do + HH_do * log10(u19_ms) ) ;
SigmaH1_cr = 10 * ( GH_cr + HH_cr * log10(u19_ms) ) ;

% Linear interpolation in dB scale:
Theta1 = [ 30 40 50 60 ] ;
SigmaV_up = interp1( Theta1 , SigmaV1_up , Th_i_d ) ;
SigmaV_do = interp1( Theta1 , SigmaV1_do , Th_i_d ) ;
SigmaV_cr = interp1( Theta1 , SigmaV1_cr , Th_i_d ) ;
%
SigmaH_up = interp1( Theta1 , SigmaH1_up , Th_i_d ) ;
SigmaH_do = interp1( Theta1 , SigmaH1_do , Th_i_d ) ;
SigmaH_cr = interp1( Theta1 , SigmaH1_cr , Th_i_d ) ;

% Conversion to linear scale:
SigmaV_up = 10 .^ ( SigmaV_up/10 ) ;
SigmaV_do = 10 .^ ( SigmaV_do/10 ) ;
SigmaV_cr = 10 .^ ( SigmaV_cr/10 ) ;
%
SigmaH_up = 10 .^ ( SigmaH_up/10 ) ;
SigmaH_do = 10 .^ ( SigmaH_do/10 ) ;
SigmaH_cr = 10 .^ ( SigmaH_cr/10 ) ;

% NRCSs of the harmonics (linear scale) (to be calculated: upwind->phi=0, downwind->phi=pi, crosswind->phi=pi/2):
SigmaV_0 = 1/4 * ( SigmaV_up + SigmaV_do + 2*SigmaV_cr ) ; % Did the author really pu 1/4, not 1/2???
SigmaV_1 = 1/2 * ( SigmaV_up - SigmaV_do ) ;
SigmaV_2 = 1/4 * ( SigmaV_up + SigmaV_do - 2*SigmaV_cr ) ; % Did the author really pu 1/4, not 1/2???
%
SigmaH_0 = 1/4 * ( SigmaH_up + SigmaH_do + 2*SigmaH_cr ) ; % Did the author really pu 1/4, not 1/2???
SigmaH_1 = 1/2 * ( SigmaH_up - SigmaH_do ) ;
SigmaH_2 = 1/4 * ( SigmaH_up + SigmaH_do - 2*SigmaH_cr ) ; % Did the author really pu 1/4, not 1/2???

% NRCS in linear scale :
Nrcs_Mdl_VV = SigmaV_0 + SigmaV_1 * cosd(1*windDir_d) + SigmaV_2 * cosd(2*windDir_d) ;
Nrcs_Mdl_HH = SigmaH_0 + SigmaH_1 * cosd(1*windDir_d) + SigmaH_2 * cosd(2*windDir_d) ;
%
Nrcs_Mdl_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Mdl_HH(It) = 0 ; % ou plutôt NaN


%% Values at normal incidence -> Table 5:

g =  1.787 ; %  1.787 @ 10.00 GHz,  1.455 @ 34.43 GHz
h = -0.569 ; % -0.569 @ 10.00 GHz, -0.857 @ 34.43 GHz
sig0_dB = 10 * ( g + h * log10(u19_ms) ) ;
sig0_lin = 10^(sig0_dB/10) ;
%
Nrcs_Mdl_VV((Th_i_d <= +1) & (Th_i_d >= -1)) = sig0_lin ;
Nrcs_Mdl_HH((Th_i_d <= +1) & (Th_i_d >= -1)) = sig0_lin ;

