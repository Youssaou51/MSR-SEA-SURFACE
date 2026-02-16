function [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = f_Nrcs_3dMono_StatisticSea_SPM1_Elfo_Gauss_Fetch_v1 (Th_i_d, phi_rel_d, er2, u_10, fetch_m, k0) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_StatisticSea_SPM1_Elfo_Gauss_Fetch_v1
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) surface for 3D problems, 
% in VV and HH polarizations, with respect to the small perturbation method
% (SPM) model, 
% whose sea surface height spectrum is the directional Elfouhaily spectrum 
% for fully-developped seas with input parameters u_10 and omega_D (omg here)
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d: incidence elevation angle with respect to the vertical z (deg.) [Vector]
% phi_rel_d : radar direction relative to the wind direction (deg.) [scalar]
% er2   : relative permittivity of transmission (lower) medium [salar]
% u_10  : wind speed at 10 m above the sea surface (m/s) [scalar]
% fetch_m : Fetch = length of action of wind on the sea (m) [scalar]
% k0    : electromagnetic wavenumber (rad/m) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_VV : NRCS under considered model in VV polarization [Vector - lin. scale]
% Nrcs_Mdl_HH : NRCS under considered model in HH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%--------------------------------------------------------------------------
% Called functions:
% (f_CoefFresnel_Ref_ElectromagFAUX) 
% (f_Noyau3dMono_SPM1_Elfo) 
% f_SpectrumSea_IsoFetch_Elfouhaily
% f_SpectrumSea_AngFetch_Elfouhaily
% (Diffusion_2d_SPM_Mer_Non_Gau_DI_1) 
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 08/2013
% Version: 2025-12 
%--------------------------------------------------------------------------

Th_i_r = Th_i_d * pi/180 ; clear Th_i_d ;

%% Coef - v1 ("classical normalization" definition of NRCS) [2001_Fuks_TAP]: 

% Constant multiplicative term:
const1 = pi * k0^4 * abs(er2-1)^2 ; % [2001_Fuks_TAP,eq5.3]

% Fresnel reflection coefficients evaluated at the incidence angle Th_i_d:
K2 = k0^2 * sin(Th_i_r).^2 ; % ... 
% Kz = sqrt(k0^2 - K2) ; % [2001_Fuks_TAP,below_eq3.1] 
Kz = k0 * cos(Th_i_r) ; % [2001_Fuks_TAP,below_eq3.1] 
Kzp = sqrt(er2*k0^2 - K2) ; % [2001_Fuks_TAP,below_eq3.2] 
R0_V = ( er2*Kz - Kzp ) ./ ( er2*Kz + Kzp ) ; % [2001_Fuks_TAP,below_eq3.6] 
R0_H = (   1*Kz - Kzp ) ./ (   1*Kz + Kzp ) ; % [2001_Fuks_TAP,below_eq3.12] 
% [R0_V, R0_H] = f_CoefFresnel_Ref_ElectromagFAUX (1, er2, Th_i_r) ;

% Polarization terms Fmono_VV and Fmono_HH:
Fmono_VV = 1/er2 * (1+R0_V).^2 .* sin(Th_i_r).^2 ... 
    - (1-R0_V).^2 .* cos(Th_i_r).^2 * cos(pi) ; % [2001_Fuks_TAP,eq5.8]
Fmono_HH = (1+R0_H).^2 * cos(pi) ; % [2001_Fuks_TAP,eq5.6]

% Coefficient in V or H pol.: 
CoefV_1 = const1 * abs(Fmono_VV).^2 ;
CoefH_1 = const1 * abs(Fmono_HH).^2 ;


%% Coef - v2 (definition of NRCS -> *4 is missing) [1978_Valenzuela_BLM]: 

% % Multiplicative term in [1978_Valenzuela_BLM]:
% Term1 = 4 * pi * k0^4 * cos(Th_i_r).^4 ; % [1978_Valenzuela_BLM,eq4.5]
% 
% % So-called "first-order scattering coefficients" in [1978_Valenzuela_BLM]:
% SqrtDen = sqrt( er2 - sin(Th_i_r).^2 ) ;
% TermV = er2*(1+sin(Th_i_r).^2) - sin(Th_i_r).^2 ;
% G1_HH = (er2-1)*1     ./ (   1*cos(Th_i_r) + SqrtDen ).^2 ; % [1978_Valenzuela_BLM,eq4.6]
% G1_VV = (er2-1)*TermV ./ ( er2*cos(Th_i_r) + SqrtDen ).^2 ; % [1978_Valenzuela_BLM,eq4.7]
% 
% CoefV_2 = Term1 .* abs(G1_VV).^2 ; 
% CoefH_2 = Term1 .* abs(G1_HH).^2 ; 
% CoefV_2 = CoefV_2 * 4 ; % (definition of NRCS -> *4 is missing) 
% CoefH_2 = CoefH_2 * 4 ; % (definition of NRCS -> *4 is missing) 


%% Coef - v3 (definition of NRCS -> *4*pi is missing): 

% k0x = k0 * sin(Th_i_r) * cos(phi_rel_d * pi/180) ;
% k0y = k0 * sin(Th_i_r) * sin(phi_rel_d * pi/180) ;
% [ B_Mdl_Elfo_VV , B_Mdl_Elfo_HH , ~ , ~ , elfo_voro_mono_B ] = f_Noyau3dMono_SPM1_Elfo ( k0 , k0x , k0y , er2 ) ;
% CoefV_3 = abs(B_Mdl_Elfo_VV).^2 ;
% CoefH_3 = abs(B_Mdl_Elfo_HH).^2 ;
% CoefV_3 = CoefV_3 * 4*pi ; % (definition of NRCS -> *4*pi is missing) 
% CoefH_3 = CoefH_3 * 4*pi ; % (definition of NRCS -> *4*pi is missing) 


%% Choice of version (NB: THEY GIVE NEARLY THE SAME RESULTS!): 

% CoefV_2 - CoefV_1 
% CoefV_3 - CoefV_1 
% CoefH_2 - CoefH_1 
% CoefH_3 - CoefH_1 
%
CoefV = CoefV_1 ; 
CoefH = CoefH_1 ; 


%% Sea surface spectrum evaluated at Bragg wavenumber kB=2*k0*sin(Theta_i): 

K_B = 2 * k0 * sin(Th_i_r) ; % Bragg wavenumber (rad/m) 
% Sh_iso_kB  = f_SpectrumSea_Iso_Elfouhaily( u_10 , K_B , omg , [] ) ; % Isotropic sea surface spectrum at Bragg wavenumber K_B 
Sh_iso_kB = f_SpectrumSea_IsoFetch_Elfouhaily( u_10 , K_B , fetch_m , [] ) ; % Isotropic sea surface spectrum at Bragg wavenumber K_B 
% Phi_iso_kB = f_SpectrumSea_Ang_Elfouhaily( u_10 , phi_rel_d , K_B , omg , [] ) ; % Angular sea surface spectrum at Bragg wavenumber K_B 
[Phi_iso_kB, ~] = f_SpectrumSea_AngFetch_Elfouhaily( u_10 , phi_rel_d , K_B , fetch_m , [] ) ; % Angular sea surface spectrum at Bragg wavenumber K_B 
Spect_kB = Sh_iso_kB .* Phi_iso_kB ./ K_B ;


%% NRCS : 

% [ SpmV_0 , SpmV_2 , SpmH_0 , SpmH_2 ] = ...
%     Diffusion_2d_SPM_Mer_Non_Gau_DI_1( Th_i_r * 180/pi , er2 , u_10 , 3e8/(2*pi)*k0 * 1e-9 ) ;
% Nrcs_Mdl_VV2 = SpmV_0 + SpmV_2*cos(2*phi_rel_d * pi/180) ;
% Nrcs_Mdl_HH2 = SpmH_0 + SpmH_2*cos(2*phi_rel_d * pi/180) ;
%
Nrcs_Mdl_VV = CoefV .* Spect_kB ; % [1978_Valenzuela_BLM,eq4.5] 
Nrcs_Mdl_HH = CoefH .* Spect_kB ; % [1978_Valenzuela_BLM,eq4.5] 
%
r_GO = 4*pi * cos(Th_i_r) ; % ratio of GO in [1978_Valenzuela_BLM,eq3.4] relatively to my GO model
