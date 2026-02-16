function [Nrcs_Went_VV, Nrcs_Went_HH] = f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz84 (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz84
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations and in Ku band (14.6 GHz), with respect to the empirical 
% model of Wentz et al. (JGR 1984), for incidence angles 0°-60°:
% - Th_i_d must be between 0°-60° [data tabulated with a step of 2°]
% - u10_ms must be between ...-... m/s
% - (winddir_d must be between 0°-360°
% The data are interpolated (linear interpolation) in dB scale
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d        : incidence angle with respect to the vertical z (deg.) [Vector]
% u10_ms        : wind speed at 10 m above the sea surface (m/s) [scalar]
% windDir_d     : wind direction with respect to the incidence azimuth 
%                 direction, \phi-\phi0 (deg.) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Went_VV  : NRCS with respect to considered model in VV polarization [linear scale]
% Nrcs_Went_HH  : NRCS with respect to considered model in HH polarization [linear scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% Wentz et al., JGR, vol. 89(C3), pp. 3689-3704, 1984
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 07/2013
%--------------------------------------------------------------------------

% Applicability domain of the empirical/experimental model (Wentz here):
It = find( Th_i_d < 0 | Th_i_d > 60 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    disp('/!\ 0° <= Th_i_d <= 60° /!\') ;
    pause(1) ;
end

Thetai = 0 : 2 : 60 ;

% VV polarisation:
S_V1 = [ 10.5 10.4 10 9.2 7.9 6.3 4.6 2.9 1.2 -0.4 -2 -3.6 -5.2 -6.7 -8.2 -9.6 -10.9 ] ;
S_V2 = [ -12 -13 -13.9 -14.7 -15.4 -16 -16.6 -17.1 -17.6 -18.2 -18.7 -19.2 -19.8 -20.3] ;
S_V  = [ S_V1 S_V2 ] ;
%
S11_V1 = [ 0 0 0 0 0 0 0 0 0 0 0 0.01 0.02 0.03 0.04 0.05 0.06 0.06 0.07 ] ;
S11_V2 = [ 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.17 0.18 ] ;
S11_V  = [ S11_V1 S11_V2 ] ;
%
S22_V1 = [ 0 0 0.01 0.03 0.05 0.08 0.11 0.15 0.19 0.23 0.27 0.30 0.33 0.36 0.39 0.42] ;
S22_V2 = [ 0.44 0.46 0.48 0.50 0.51 0.52 0.53 0.54 0.54 0.54 0.54 0.54 0.54 0.54 0.54 ] ;
S22_V  = [ S22_V1 S22_V2 ] ;
%
Alpha0_V1 = [ -0.58 -0.5 -0.41 -0.3 -0.18 -0.04 0.12 0.29 0.46 0.64 0.82 0.99 1.16 1.31 1.44 ] ; 
Alpha0_V2 = [ 1.55 1.64 1.70 1.74 1.76 1.77 1.77 1.76 1.74 1.71 1.68 1.65 1.61 1.58 1.54 1.51 ] ;
Alpha0_V  = [ Alpha0_V1 Alpha0_V2 ] ;
%
Alpha1_V1 = [ 0 0 0 0 0 0 0 0 0 0 0 -0.01 -0.02 -0.02 -0.03 -0.04 -0.05 -0.06 -0.06 ] ; 
Alpha1_V2 = [ -0.07 -0.08 -0.09 -0.1 -0.1 -0.11 -0.12 -0.13 -0.14 -0.14 -0.15 -0.16 ] ;
Alpha1_V  = [ Alpha1_V1 Alpha1_V2 ] ;
%
Alpha2_V1 = [ 0 0 0.01 0.02 0.03 0.05 0.07 0.09 0.11 0.12 0.13 0.14 0.14 0.14 0.13 0.11 0.07 ] ;
Alpha2_V2 = [ 0.03 -0.01 -0.05 -0.08 -0.12 -0.16 -0.2 -0.24 -0.28 -0.32 -0.36 -0.40 -0.44 -0.48 ] ;
Alpha2_V  = [ Alpha2_V1 Alpha2_V2 ] ;
%
A0_V = 10 .^ ( S_V/10 - Alpha0_V ) ;
A1_V = S11_V - Alpha1_V ;
A2_V = S22_V - Alpha2_V ;

% HH polarisation:
S_H1 = [ 10.5 10.4 10 9.2 7.9 6.3 4.6 2.9 1.2 -0.5 -2.2 -3.9 -5.6 -7.3 -9 -10.7 -12.4 ] ;
S_H2 = [ -14 -15.4 -16.7 -17.9 -19.1 -20.1 -21 -21.9 -22.8 -23.7 -24.6 -25.4 -26.3 -27.2] ;
S_H  = [ S_H1 S_H2 ] ;
%
S11_H1 = [ 0 0 0 0 0 0 0 0 0 0 0.01 0.03 0.05 0.08 0.1 0.13 0.15 0.18 0.20 ] ;
S11_H2 = [ 0.23 0.25 0.28 0.30 0.33 0.36 0.38 0.41 0.43 0.46 0.48 0.51 ] ;
S11_H  = [ S11_H1 S11_H2 ] ;
%
S22_H1 = [ 0 0 0.01 0.03 0.05 0.08 0.11 0.15 0.19 0.23 0.26 0.29 0.32 0.35 0.37 0.39 ] ;
S22_H2 = [ 0.41 0.42 0.43 0.44 0.45 0.46 0.46 0.46 0.46 0.46 0.46 0.46 0.46 0.46 0.46 ] ;
S22_H  = [ S22_H1 S22_H2 ] ;
%
Alpha0_H1 = [ -0.58 -0.50 -0.41 -0.30 -0.18 -0.04 0.12 0.29 0.46 0.64 0.82 1 1.17 1.34 1.50] ; 
Alpha0_H2 = [ 1.64 1.77 1.89 2 2.08 2.13 2.16 2.19 2.21 2.23 2.24 2.25 2.26 2.26 2.26 2.26 ] ;
Alpha0_H  = [ Alpha0_H1 Alpha0_H2 ] ;
%
Alpha1_H1 = [ 0 0 0 0 0 0 0 0 0 0 -0.01 -0.03 -0.06 -0.10 -0.13 -0.16 -0.19 -0.23 -0.26 ] ; 
Alpha1_H2 = [ -0.29 -0.32 -0.36 -0.39 -0.42 -0.45 -0.49 -0.52 -0.55 -0.58 -0.62 -0.65 ] ;
Alpha1_H  = [ Alpha1_H1 Alpha1_H2 ] ;
%
Alpha2_H1 = [ 0 0 0.01 0.02 0.03 0.05 0.07 0.09 0.11 0.12 0.13 0.14 0.14 0.14 0.14 0.13 0.12 ] ;
Alpha2_H2 = [ 0.11 0.09 0.07 0.04 0 -0.06 -0.13 -0.21 -0.29 -0.37 -0.45 -0.53 -0.61 -0.69 ] ;
Alpha2_H  = [ Alpha2_H1 Alpha2_H2 ] ;
%
A0_H = 10 .^ ( S_H/10 - Alpha0_H ) ;
A1_H = S11_H - Alpha1_H ;
A2_H = S22_H - Alpha2_H ;

% Calculation of the NRCS:
SigmaV_0i = A0_V .* ( u10_ms.^Alpha0_V ) ;
SigmaV_1i = ( A1_V + Alpha1_V * log10(u10_ms) ) .* SigmaV_0i ;
SigmaV_2i = ( A2_V + Alpha2_V * log10(u10_ms) ) .* SigmaV_0i ;
%
SigmaH_0i = A0_H .* ( u10_ms.^Alpha0_H ) ;
SigmaH_1i = ( A1_H + Alpha1_H * log10(u10_ms) ) .* SigmaH_0i ;
SigmaH_2i = ( A2_H + Alpha2_H * log10(u10_ms) ) .* SigmaH_0i ;

% Interpolation with respect to Th_i_d:
SigmaH_0 = interp1( Thetai , SigmaH_0i , Th_i_d ) ;
SigmaH_1 = interp1( Thetai , SigmaH_1i , Th_i_d ) ;
SigmaH_2 = interp1( Thetai , SigmaH_2i , Th_i_d ) ;
%
SigmaV_0 = interp1( Thetai , SigmaV_0i , Th_i_d ) ;
SigmaV_1 = interp1( Thetai , SigmaV_1i , Th_i_d ) ;
SigmaV_2 = interp1( Thetai , SigmaV_2i , Th_i_d ) ;

% NRCS in linear scale :
Nrcs_Went_VV = SigmaV_0 + SigmaV_1 * cosd(1*windDir_d) + SigmaV_2 * cosd(2*windDir_d) ;
Nrcs_Went_HH = SigmaH_0 + SigmaH_1 * cosd(1*windDir_d) + SigmaH_2 * cosd(2*windDir_d) ;
%
% Nrcs_Went_VV(It) = 0 ; % ou plutôt NaN
% Nrcs_Went_HH(It) = 0 ; % ou plutôt NaN
