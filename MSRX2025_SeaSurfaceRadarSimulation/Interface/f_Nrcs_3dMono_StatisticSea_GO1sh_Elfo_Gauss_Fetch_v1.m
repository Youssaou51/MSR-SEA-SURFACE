function [Nrcs_GO1un_VV, Nrcs_GO1un_HH, S0_SmithU_Gss, sig_sx, sig_sy] = ...
    f_Nrcs_3dMono_StatisticSea_GO1sh_Elfo_Gauss_Fetch_v1 (Th_i_d, phi_rel_d, er2, u_10, fetch_m, kc) 

%--------------------------------------------------------------------------
% FUNCTION: f_Nrcs_3dMono_StatisticSea_GO1sh_Elfo_Gauss_Fetch_v1
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations, with respect to the geometric optics (GO)
% approximation, with shadowing effect, 
% whose sea surface height spectrum is the directional Elfouhaily spectrum 
% for fully-developped seas with input parameters u_10 and omega_D (omg here)
% Nota: The shadowing effect is calculated with the Smith approach without
% correlation
% ADDENDUM: Use of an input cut-off wavenumber for calculating the RMS 
% slopes more precisely (-> large-scales) for a better agreement with 
% sea surface backscattering 
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d: Incidence elevation angle with respect to the vertical z (deg.) [Vector]
% phi_rel_d : Radar direction relative to the wind direction (deg.) [scalar]
% er2   : Relative permittivity of transmission (lower) medium (i.e. sea surface) [salar]
% u_10  : Wind speed at 10 m above the sea surface (m/s) [scalar]
% fetch_m : Fetch = length of action of wind on the sea (m) [scalar]
% kc    : Cut-off wavenumber for surface spectrum calculation (rad/m) [scalar] 
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_GO1un_VV : NRCS under considered model in VV polarization [Vector - lin. scale]
% Nrcs_GO1un_HH : NRCS under considered model in HH polarization [Vector - lin. scale]
% S0_SmithU_Gss : Shadowing function under Gaussian PDF (uncorrelated Smith) [Vector]
% sig_sx        : Sea surface RMS slope in x direction (-) [scalar]
% sig_sy        : Sea surface RMS slope in y direction (-) [scalar]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% ... (see [2013_Pinel_Book])
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%--------------------------------------------------------------------------
% Called functions:
% f_SpectrumSea_IsoFetch_Elfouhaily 
% f_SpectrumSea_AngFetch_Elfouhaily 
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 2025-12 
%--------------------------------------------------------------------------


%% Constants and simple relationships: 

er1 = 1 ; % Relative permittivity of the incidence medium (air = vacuum) (-) 
g = 9.81 ; % Acceleration due to gravity (m/s^2) 
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]
km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24]
% n_k  =  200 ; % Nbre de points pour l'integration sur k - OK pour u_10 = 5;10
n_k  =  500 ; % Nbre de points pour l'integration sur k - OK pour u_10 = 5;10
%
Th_i_r = Th_i_d * pi/180 ; clear Th_i_d ;
phi_rel_r = phi_rel_d * pi/180 ; clear phi_rel_d ;


%% Calculation of the (large-scale) surface slope PDF: 
%  Determination of the RMS slopes along x and y directions: can be done
% with the Cox and Munk formula, but here, we want to compute it from a
% spectrum model, which is here the Elfouhaily model for fulled-developped
% seas:

% General relationships:
k0_surf = g / u_10^2 ; % in rad/m
xmaj = k0_surf * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4]
omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37]
%
kp = k0_surf * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
% kp = omg^2 * g / u_10^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
%
k_min = 0.25 * kp ; % k_min = 0.30 * kp ;
k_max_c = kc ;
if isempty(kc)
    % k_max = 2000 ; % Nbre d'onde max pour l'intégration sur k -- OK pour u_10 = 5;10
    k_max_c = 3000 ; % Nbre d'onde max pour l'intégration sur k -- OK pour u_10 = 5;10
    % k_max = 4000 ; % Nbre d'onde max pour l'intégration sur k -- OK pour u_10 = 5;10
end
log_k_min = log10( k_min ) ;
log_k_max = log10( k_max_c ) ;
log_k_pas = ( log_k_max - log_k_min ) / ( n_k - 1 ) ;
Log_k     = log_k_min : log_k_pas : log_k_max ;
K = 10 .^ Log_k ;
% Sh_iso_theo = f_SpectrumSea_Iso_Elfouhaily( u_10 , K , omg , [] ) ; % Isotropic sea surface spectrum (for K <= kc) 
Sh_iso_theo = f_SpectrumSea_IsoFetch_Elfouhaily( u_10 , K , fetch_m , [] ) ; % Isotropic sea surface spectrum (for K <= kc) 
%
alpha_sea = 1/2 * trapz( K , K.^2 .* Sh_iso_theo ) ;
% [~, Dt_k] = f_SpectrumSea_Ang_Elfouhaily( u_10 , phi_rel_r * 180/pi , K , omg , [] ) ; % Angular sea surface spectrum (for K <= kc) 
[~, Dt_k] = f_SpectrumSea_AngFetch_Elfouhaily( u_10 , phi_rel_r * 180/pi , K , fetch_m , [] ) ; % Angular sea surface spectrum (for K <= kc) 
beta_sea  = 1/4 * trapz( K , K.^2 .* Sh_iso_theo .* Dt_k ) ;
sig_sx_El = sqrt( alpha_sea + beta_sea ) ;
sig_sy_El = sqrt( alpha_sea - beta_sea ) ;
%
cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek kp
% z0 = 3e-3 ;
z0 = 3.7e-5 * u_10^2/g * (u_10/cp)^0.9 ; % Roughness length [1997_Elfouhaily_JGR,eq.66]
u_12 = log(12.5/z0)/log(10/z0) * u_10 ; % from [2012_Wang_TGRS,eq36]
sig_sx_CM = sqrt( 3.16e-3 * u_12 ) ; % see [2013_Pinel_Book,eq1.83]
sig_sy_CM = sqrt( 1.92e-3 * u_12 + 3e-3 ) ; % see [2013_Pinel_Book,eq1.84]
sig_s_CM = sqrt(sig_sx_CM^2 + sig_sy_CM^2) ;
[ sig_sx_CM sig_sx_El ] 
[ sig_sy_CM sig_sy_El ] 
sig_s_El_1 = sqrt( trapz(K , K.^2 .* Sh_iso_theo) )  
sig_s_El_2 = sqrt(sig_sx_El^2 + sig_sy_El^2)  % On doit avoir sig_s_El_2 = sig_s_El_1 
%
sig_sx = sig_sx_El ; % Sea surface RMS slope in x direction (-) 
sig_sy = sig_sy_El ; % Sea surface RMS slope in y direction (-) 


% Surface slope PDF -> assumption (centered) anisotropic Gaussian:
Ux = tan(Th_i_r) * cos(phi_rel_r) / (sqrt(2) * sig_sx) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
Uy = tan(Th_i_r) * sin(phi_rel_r) / (sqrt(2) * sig_sy) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%
Ps_Gss2d_An = 1/(2*pi*sig_sx*sig_sy) * exp(-Ux.^2 -Uy.^2) ;


%% Calculation of the Fresnel reflection coefficient evaluated at a local incidence = 0 (-> monostatic configuration):
r12_H = + ( sqrt(er1) - sqrt(er2) ) / ( sqrt(er1) + sqrt(er2) ) ;
r12_V = - ( sqrt(er1) - sqrt(er2) ) / ( sqrt(er1) + sqrt(er2) ) ; % ELECTROMAGNETICS CONVENTION (FALSE IN GENERAL: TRUE ONLY FOR PARTICULAR DRAWINGS
% r12_V = + ( sqrt(er1) - sqrt(er2) ) / ( sqrt(er1) + sqrt(er2) ) ; % RIGOROUS CONVENTION (OPTICS)
% 
Coef1_VV = abs(r12_V)^2 ./ (4 * cos(Th_i_r).^5) ;
Coef1_HH = abs(r12_H)^2 ./ (4 * cos(Th_i_r).^5) ;


%% NRCS without shadow according to the convention of [2013_Pinel_Book]:
Nrcs_GO1un_VV = Coef1_VV .* Ps_Gss2d_An ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
Nrcs_GO1un_HH = Coef1_HH .* Ps_Gss2d_An ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%
Nrcs_GO1un_VV = Nrcs_GO1un_VV .* (4*pi*cos(Th_i_r)) ; 
Nrcs_GO1un_HH = Nrcs_GO1un_HH .* (4*pi*cos(Th_i_r)) ; 


%% Calculation of the shadowing function under Gaussian slope PDF, and by
% using the Smith approach without correlation:
Sig_s2 = sig_sx^2 * cos(phi_rel_r).^2 + sig_sy^2 * sin(phi_rel_r).^2 ;
Vv = abs( cot(Th_i_r) ) ./ sqrt(2*Sig_s2) ;
Lbda = exp(-Vv.^2)./(2*Vv*sqrt(pi)) - erfc(Vv)/2 ;
S0_SmithU_Gss = 1 ./ (1+Lbda) ;
