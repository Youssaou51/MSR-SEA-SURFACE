function [Nrcs_Mdl_VV, Nrcs_Mdl_HH, Nrcs_Mdl_VH, sig_sx_LS, sig_sy_LS, AddTerm_VV, AddTerm_HH] = ...
    f_Nrcs_3dMono_StatisticSea_TSM_Elfo_Gauss (Th_i_d, phi_rel_d, er2, u_10, omg, k0, kc) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_StatisticSea_TSM_Elfo_Gauss
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations, with respect to the two-scale model (TSM), 
% whose sea surface height spectrum is the Elfouhaily spectrum for
% fully-developped seas with input parameters u_10 and omega_D (omg here)
% The local surface slope PDF is assumed to be Gaussian
% [1978_Valenzuela_BLM]
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d: incidence elevation angle with respect to the vertical z (deg.) [Vector]
% phi_rel_d : radar direction relative to the wind direction (deg.) [scalar]
% er2   : relative permittivity of transmission (lower) medium [salar]
% u_10  : wind speed at 10 m above the sea surface (m/s) [scalar]
% omg   : inverse of the age of the wave Omega [scalar]
% k0    : electromagnetic wavenumber (rad/m) [scalar]
% kc    : cutoff EM wavenumber between large/small scales (rad/m) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_VV : NRCS under considered model in VV polarization [Vector - lin. scale]
% Nrcs_Mdl_HH : NRCS under considered model in HH polarization [Vector - lin. scale]
% Nrcs_Mdl_VH : NRCS under considered model in VH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 08/2013
%--------------------------------------------------------------------------

% aff = 1 ;
aff = 0 ;

% Initialization of the NRCS:
Nrcs_Mdl_HH = zeros(size(Th_i_d)) - 1 ;
Nrcs_Mdl_VV = zeros(size(Th_i_d)) - 1 ;
Nrcs_Mdl_VH = zeros(size(Th_i_d)) - 1 ;

% Calculation of the RMS slopes of the large scales from Elfouhaily directional spectrum:
g = 9.81 ; % acceleration due to gravity (m/s^2)
kp = omg^2 * g / u_10^2 ;
k_min_LS = 0.25 * kp ; % k_min = 0.30 * kp ;
k_max_LS = kc ;
% n_k_LS  =  500 ; % Nbre de points pour l'integration sur k - OK pour u_10 = 5;10
n_k_LS  =  200 ; % Nbre de points pour l'integration sur k - OK pour u_10 = 5;10
log_k_min_LS = log10( k_min_LS ) ;
log_k_max_LS = log10( k_max_LS ) ;
log_k_pas_LS = ( log_k_max_LS - log_k_min_LS ) / ( n_k_LS - 1 ) ;
Log_k_LS     = log_k_min_LS : log_k_pas_LS : log_k_max_LS ;
K_LS = 10 .^ Log_k_LS ;
Sp_LS = f_SpectrumSea_Iso_Elfouhaily( u_10 , K_LS , omg , [] ) ; % large-scale surface spectrum
sh_LS = sqrt( trapz( K_LS , Sp_LS ) ) ;
alpha_sea = 1/2 * trapz( K_LS , K_LS.^2 .* Sp_LS ) ;
[~, Dt_k_LS] = f_SpectrumSea_Ang_Elfouhaily( u_10 , phi_rel_d , K_LS , omg , [] ) ;
beta_sea  = 1/4 * trapz( K_LS , K_LS.^2 .* Sp_LS .* Dt_k_LS ) ;
sig_sx_LS = sqrt( alpha_sea + beta_sea ) ;
sig_sy_LS = sqrt( alpha_sea - beta_sea ) ;

% Integration variables TanPsi and TanDlt (tangent of tilt angles Psi and Delta):
% min_tp = -5.0*sig_sx_LS ; max_tp = +5.0*sig_sx_LS ; n_tp = 500 ;
% min_td = -5.0*sig_sy_LS ; max_td = +5.0*sig_sy_LS ; n_td = 500 ;
%
min_tp = -5.0*sig_sx_LS ; max_tp = +5.0*sig_sx_LS ; n_tp = 100 ;
min_td = -5.0*sig_sy_LS ; max_td = +5.0*sig_sy_LS ; n_td = 100 ;
%
% min_tp = -5.0*sig_sx_LS ; max_tp = +5.0*sig_sx_LS ; n_tp = 010 ;
% min_td = -5.0*sig_sy_LS ; max_td = +5.0*sig_sy_LS ; n_td = 010 ;
%
%
min_tp = -6.0*sig_sx_LS ; max_tp = +5.0*sig_sx_LS ; n_tp = 100 ;
min_td = -5.0*sig_sy_LS ; max_td = +5.0*sig_sy_LS ; n_td = 100 ;
%
% min_tp = -10.0*sig_sx_LS ; max_tp = +10.0*sig_sx_LS ; n_tp = 500 ;
% min_td = -10.0*sig_sy_LS ; max_td = +10.0*sig_sy_LS ; n_td = 500 ;
%
pas_tp = (max_tp-min_tp)/(n_tp-1) ;
pas_td = (max_td-min_td)/(n_td-1) ;
TanPsi_l = min_tp : pas_tp : max_tp ;
TanDlt_l = min_td : pas_td : max_td ;
[TANPSI, TANDLT] = meshgrid(TanPsi_l, TanDlt_l) ;
%
% Associated tilt angles:
PSI_R = atan(TANPSI) ; % Tilt angle Psi  , in-plane     tilt angle
DLT_R = atan(TANDLT) ; % Tilt angle Delta, out-of-plane tilt angle

% Local surface slope PDF -> assumed to be Gaussian:
% Ux = tan(Th_i_d*pi/180) * cos(phi_rel_d*pi/180) / (sqrt(2) * sig_sx) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% Uy = tan(Th_i_d*pi/180) * sin(phi_rel_d*pi/180) / (sqrt(2) * sig_sy) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
UXLOC_LS = TANPSI / (sqrt(2) * sig_sx_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
UYLOC_LS = TANDLT / (sqrt(2) * sig_sy_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% UX_LS = tan(th_i_r + PSI_R) .* cos(phi_rel_d*pi/180 + DLT_R) / (sqrt(2) * sig_sx_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% UY_LS = tan(th_i_r + PSI_R) .* sin(phi_rel_d*pi/180 + DLT_R) / (sqrt(2) * sig_sy_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%
PSLOC_GSS2D_AN_LS = 1/(2*pi*sig_sx_LS*sig_sy_LS) * exp(-UXLOC_LS.^2 -UYLOC_LS.^2) ;
%
if aff == 1
    figure(10) ; clf ;
    mesh(PSLOC_GSS2D_AN_LS) ;
    title(['Large-scale slope PDF']) ;
    pause(1.0) ;
end

% Calculation of the short-scale RMS height -> complementary term, see [2008_Soriano_GRSL,eq24]:
k_min_SS = k_max_LS ;
k_max_SS = 3000 ;
n_k_SS  =  500 ; % Nbre de points pour l'integration sur k - OK pour u_10 = ...
log_k_min_SS = log10( k_min_SS ) ;
log_k_max_SS = log10( k_max_SS ) ;
log_k_pas_SS = ( log_k_max_SS - log_k_min_SS ) / ( n_k_SS - 1 ) ;
Log_k_SS     = log_k_min_SS : log_k_pas_SS : log_k_max_SS ;
K_SS = 10 .^ Log_k_SS ;
Sh_SS = f_SpectrumSea_Iso_Elfouhaily( u_10 , K_SS , omg , [] ) ; % large-scale surface spectrum
sh_SS = sqrt( trapz( K_SS , Sh_SS ) ) ;
sh_CM = 6.29e-3 * u_10^2.02 ;
%
qq = 2 * k0 ;
Qz = qq * cos(Th_i_d * pi/180) ;
%
% [Nrcs_GO1un_VV, Nrcs_GO1un_HH, S0_SmithU_Gss, sig_sx, sig_sy, Fact_Defs] = ...
%     f_Nrcs_3dMono_StatisticSea_GO1sh_Elfo_Gauss (Th_i_d, phi_rel_d, er2, u_10, omg) ;
%
er1 = 1 ;
r12_H = + ( sqrt(er1) - sqrt(er2) ) / ( sqrt(er1) + sqrt(er2) ) ;
r12_V = - ( sqrt(er1) - sqrt(er2) ) / ( sqrt(er1) + sqrt(er2) ) ; % ELECTROMAGNETICS CONVENTION (FALSE IN GENERAL: TRUE ONLY FOR PARTICULAR DRAWINGS
% r12_V = + ( sqrt(er1) - sqrt(er2) ) / ( sqrt(er1) + sqrt(er2) ) ; % RIGOROUS CONVENTION (OPTICS)
Coef1_VV = abs(r12_V)^2 ./ (4 * cos(Th_i_d * pi/180).^5) ;
Coef1_HH = abs(r12_H)^2 ./ (4 * cos(Th_i_d * pi/180).^5) ;
Ux_LS = tan(Th_i_d*pi/180) * cos(phi_rel_d*pi/180) / (sqrt(2) * sig_sx_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
Uy_LS = tan(Th_i_d*pi/180) * sin(phi_rel_d*pi/180) / (sqrt(2) * sig_sy_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
Ps_Gss2d_An_LS = 1/(2*pi*sig_sx_LS*sig_sy_LS) * exp(-Ux_LS.^2 -Uy_LS.^2) ;
Nrcs_GO1un_VV = Coef1_VV .* Ps_Gss2d_An_LS ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
Nrcs_GO1un_HH = Coef1_HH .* Ps_Gss2d_An_LS ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
Sig_s2_LS = sig_sx_LS^2 * cos(phi_rel_d * pi/180).^2 + sig_sy_LS^2 * sin(phi_rel_d * pi/180).^2 ;
Vv_LS = abs( cot(Th_i_d * pi/180) ) ./ sqrt(2*Sig_s2_LS) ;
Lbda_LS = exp(-Vv_LS.^2)./(2*Vv_LS*sqrt(pi)) - erfc(Vv_LS)/2 ;
S0_SmithU_Gss_LS = 1 ./ (1+Lbda_LS) ;
%
Nrcs_GO1sh_VV = (4*pi*cosd(Th_i_d)) / (4*pi) .* Nrcs_GO1un_VV .* S0_SmithU_Gss_LS ;
Nrcs_GO1sh_HH = (4*pi*cosd(Th_i_d)) / (4*pi) .* Nrcs_GO1un_HH .* S0_SmithU_Gss_LS ;
%
AddTerm_VV = Nrcs_GO1sh_VV * exp(-qq^2*sh_SS^2) .* ( 1 - exp(-Qz.^2.*sh_LS^2) ) ;
AddTerm_HH = Nrcs_GO1sh_HH * exp(-qq^2*sh_SS^2) .* ( 1 - exp(-Qz.^2.*sh_LS^2) ) ;
AddTerm_VH = 0 ;



for i_th = 1 : length(Th_i_d)
    %
    th_i_r = Th_i_d(i_th) * pi/180 ;

% % Local surface slope PDF -> assumed to be Gaussian:
% % Ux = tan(Th_i_d*pi/180) * cos(phi_rel_d*pi/180) / (sqrt(2) * sig_sx) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% % Uy = tan(Th_i_d*pi/180) * sin(phi_rel_d*pi/180) / (sqrt(2) * sig_sy) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% UX_LS = TANPSI / (sqrt(2) * sig_sx_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% UY_LS = TANDLT / (sqrt(2) * sig_sy_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% % UX_LS = tan(th_i_r + PSI_R) .* cos(phi_rel_d*pi/180 + DLT_R) / (sqrt(2) * sig_sx_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% % UY_LS = tan(th_i_r + PSI_R) .* sin(phi_rel_d*pi/180 + DLT_R) / (sqrt(2) * sig_sy_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% %
% PS_GSS2D_AN_LS = 1/(2*pi*sig_sx_LS*sig_sy_LS) * exp(-UX_LS.^2 -UY_LS.^2) ;
% %
% if aff == 1
%     figure(10) ; clf ;
%     mesh(PS_GSS2D_AN_LS) ;
% %     pause ;
% end

% Relations:
TH_LOC_R = +acos( cos(th_i_r + PSI_R) .* cos(DLT_R) ) ; % [1978_Valenzuela_BLM,above-eq5.1]
% TH_LOC_R = -acos( cos(th_i_r + PSI_R) .* cos(atan(DLT_R).*cos(PSI_R)) ) ; % [2007_Mouche_JGR,below-eqA2]
ALPHA_I = sin(TH_LOC_R) ; % [1978_Valenzuela_BLM,below-eq5.3]
ALPHA__ = sin(th_i_r + PSI_R) ; % [1978_Valenzuela_BLM,below-eq5.3]
GAMMA__ = cos(th_i_r + PSI_R) ; % [1978_Valenzuela_BLM,below-eq5.3]

% Multiplicative term in [1978_Valenzuela_BLM]:
TERM1_LOC = 4 * pi * k0^4 * cos(TH_LOC_R).^4 ; % [1978_Valenzuela_BLM,eq4.5]

% Local "first-order scattering coefficients" in [1978_Valenzuela_BLM]:
SQRTDEN_LOC = sqrt( er2 - sin(TH_LOC_R).^2 ) ;
TERMV_LOC = er2*( 1 + sin(TH_LOC_R).^2 ) - sin(TH_LOC_R).^2 ;
G1_LOC_HH = (er2-1)*1         ./ (   1*cos(TH_LOC_R) + SQRTDEN_LOC ).^2 ; % [1978_Valenzuela_BLM,eq4.6]
G1_LOC_VV = (er2-1)*TERMV_LOC ./ ( er2*cos(TH_LOC_R) + SQRTDEN_LOC ).^2 ; % [1978_Valenzuela_BLM,eq4.7]

% Tilted "first-order scattering coefficients":
COEFC_ = ( ALPHA__.*cos(DLT_R) ./ ALPHA_I ).^2 ;
COEFS_ = (          sin(DLT_R) ./ ALPHA_I ).^2 ;
COEFCS = ( ALPHA__.*sin(DLT_R).*cos(DLT_R) ./ ALPHA_I ).^2 ;
%
POW_G1_HH = abs( COEFC_.*G1_LOC_HH + COEFS_.*G1_LOC_VV ).^2 ;
POW_G1_VV = abs( COEFC_.*G1_LOC_VV + COEFS_.*G1_LOC_HH ).^2 ;
POW_G1_VH = COEFCS .* abs( G1_LOC_VV - G1_LOC_HH ).^2 ;
%
% POW_G1_HH = abs( G1_LOC_HH ).^2 ;
% POW_G1_VV = abs( G1_LOC_VV ).^2 ;
% POW_G1_VH = zeros(size(G1_LOC_HH)) ;

% Sea surface spectrum: Elfouhaily, fully-developped seas:
KX_LOC = 2 * k0 * ALPHA__ ;
% KX_LOC = 2 * k0 * sin(th_i_r) ;
KY_LOC = 2 * k0 * GAMMA__ .* sin(DLT_R) ;
PHI_LOC_D = 180/pi * atan(KY_LOC./KX_LOC) + phi_rel_d ;
PHI_LOC_D = 180/pi * atan(tan(th_i_r + PSI_R).*sin(DLT_R)) + phi_rel_d ;
% PHI_LOC_D = phi_rel_d ;
SH_ISO_LOC  = f_SpectrumSea_Iso_Elfouhaily( u_10 , KX_LOC , omg , [] ) ;
PHI_ISO_LOC = f_SpectrumSea_Ang_Elfouhaily( u_10 , PHI_LOC_D , KX_LOC , omg , [] ) ; %%%%% SUR POUR LE PARAMETRE D'ENTREE EN K ??? EN PHI ??? %%%%%
SH_DIR_LOC = SH_ISO_LOC .* PHI_ISO_LOC ./ KX_LOC ; %%%%% SUR POUR LE PARAMETRE DIVISEUR EN K ??? %%%%%
% find(~KX_LOC) 
% High-frequency part = short-scale part of the spectre:
SH_DIR_LOC_SS = SH_DIR_LOC .* (KX_LOC >= kc) ;
% any(imag(SH_DIR_LOC_SS(:))) 
% [ KX_LOC(1,:) ; SH_ISO_LOC(1,:) ]
% KX_LOC(1,:)
% SH_ISO_LOC(1,:)
% PHI_ISO_LOC(1,:)
% pause ;


% Sea surface spectrum evaluated at Bragg wavenumber kB=2*k0*sin(Theta_i):
k_B = 2 * k0 * sin(th_i_r) ;
sh_iso_kB  = f_SpectrumSea_Iso_Elfouhaily( u_10 , k_B , omg , [] ) ;
phi_iso_kB = f_SpectrumSea_Ang_Elfouhaily( u_10 , phi_rel_d , k_B , omg , [] ) ;
spect_kB = sh_iso_kB .* phi_iso_kB ./ k_B ;
spect_kB_SS = spect_kB .* (k_B >= kc) ;
spect_mean_SS = mean(mean(SH_DIR_LOC_SS)) ;



% Local NRCS under the SPM1 model:
% SIG0_LOCSPM_HH = TERM1_LOC .* POW_G1_HH .* SH_DIR_LOC_SS ;
% SIG0_LOCSPM_VV = TERM1_LOC .* POW_G1_VV .* SH_DIR_LOC_SS ;
% SIG0_LOCSPM_VH = TERM1_LOC .* POW_G1_VH .* SH_DIR_LOC_SS ;
SIG0_LOCSPM_HH = TERM1_LOC .* POW_G1_HH .* SH_DIR_LOC_SS / pi ;
SIG0_LOCSPM_VV = TERM1_LOC .* POW_G1_VV .* SH_DIR_LOC_SS / pi ;
SIG0_LOCSPM_VH = TERM1_LOC .* POW_G1_VH .* SH_DIR_LOC_SS / pi ;
% any(imag(SIG0_LOCSPM_HH(:))) 
% imag(SIG0_LOCSPM_HH)
%
% [SIG0_LOCSPM_VV0, SIG0_LOCSPM_HH0] = f_Nrcs_3dMono_StatisticSea_SPM1_Elfo_Gauss (th_i_r * 180/pi, phi_rel_d, er2, u_10, omg, k0) ;
% SIG0_LOCSPM_VV = SIG0_LOCSPM_VV0 / 1 * ones(size(TANPSI)) ;
% SIG0_LOCSPM_HH = SIG0_LOCSPM_HH0 / 1 * ones(size(TANPSI)) ;
% % SIG0_LOCSPM_VV = SIG0_LOCSPM_VV0 / (max_tp-min_tp) / (max_td-min_td) * ones(size(TANPSI)) ;
% % SIG0_LOCSPM_HH = SIG0_LOCSPM_HH0 / (max_tp-min_tp) / (max_td-min_td) * ones(size(TANPSI)) ;
% Nrcs_Mdl_VH = zeros(size(SIG0_LOCSPM_VV)) ;

% Double numerical integration over the local surface slopes -> NRCS of TSM:
if aff == 1
    az = 0; el = 60;
    %
    figure(11) ; clf ;
    subplot(221) ;
%     mesh(SIG0_LOCSPM_HH) ;
    mesh(real(SIG0_LOCSPM_HH)) ;
	title(['Local SPM1 NRCS (HH) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
    view(az, el);
    subplot(223) ;
%     mesh(SIG0_LOCSPM_VV) ;
    mesh(real(SIG0_LOCSPM_VV)) ;
	title(['Local SPM1 NRCS (VV) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
    view(az, el);
%     pause(0.5) ;
    %
    %
%     figure(12) ; clf ;
    subplot(222) ;
%     mesh(SIG0_LOCSPM_HH .* PS_GSS2D_AN_LS) ;
    mesh(real(SIG0_LOCSPM_HH .* PSLOC_GSS2D_AN_LS)) ;
	title(['Integrand (HH) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
    view(az, el);
    subplot(224) ;
%     mesh(SIG0_LOCSPM_VV .* PS_GSS2D_AN_LS) ;
    mesh(real(SIG0_LOCSPM_VV .* PSLOC_GSS2D_AN_LS)) ;
	title(['Integrand (VV) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
    view(az, el);
    pause(0.5) ;
end
Nrcs_Mdl_HH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_HH .* PSLOC_GSS2D_AN_LS ) ) ;
Nrcs_Mdl_VV(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_VV .* PSLOC_GSS2D_AN_LS ) ) ;
Nrcs_Mdl_VH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_VH .* PSLOC_GSS2D_AN_LS ) ) ;
% Nrcs_Mdl_HH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_HH .* 1 ) ) ;
% Nrcs_Mdl_VV(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_VV .* 1 ) ) ;
% Nrcs_Mdl_VH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_VH .* 1 ) ) ;
%
fprintf('.') ;

end

Nrcs_Mdl_HH = Nrcs_Mdl_HH + AddTerm_HH ;
Nrcs_Mdl_VV = Nrcs_Mdl_VV + AddTerm_VV ;
Nrcs_Mdl_VH = Nrcs_Mdl_VH + AddTerm_VH ;

fprintf('\n') ;
%
r_GO = 4*pi * cos(th_i_r) ; % ratio of GO in [1978_Valenzuela_BLM,eq3.4] relatively to my GO model
