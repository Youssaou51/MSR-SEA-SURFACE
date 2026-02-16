function [Nrcs_Mdl_VV, Nrcs_Mdl_HH, Nrcs_Mdl_VH, sig_sx_LS, sig_sy_LS, AddTerm_VV, AddTerm_HH] = ...
    f_Nrcs_3dMono_StatisticSea_TSM_Elfo_Gauss_Fetch_v2 (Th_i_d, phi_rel_d, er2, u_10, fetch_m, k0_EM, kc) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_StatisticSea_TSM_Elfo_Gauss_Fetch_v2 
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations, with respect to the two-scale model (TSM), 
% whose sea surface height spectrum is the Elfouhaily spectrum for
% fully-developped seas with input parameters u_10 and omega_D (omg here)
% The local surface slope PDF is assumed to be Gaussian
% [1978_Valenzuela_BLM]
% Note: The shadowing effect is taken into account (...) 
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d: Incidence elevation angle with respect to the vertical z (deg.) [Vector]
% phi_rel_d : Radar direction relative to the wind direction (deg.) [scalar]
% er2   : Relative permittivity of transmission (lower) medium [salar]
% u_10  : Wind speed at 10 m above the sea surface (m/s) [scalar]
% fetch_m : Fetch = length of action of wind on the sea (m) [scalar]
% k0_EM : Electromagnetic wavenumber (rad/m) [scalar]
% kc    : Cutoff EM wavenumber between large/small scales (rad/m) [scalar]
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
% f_SpectrumSea_IsoFetch_Elfouhaily 
% f_SpectrumSea_AngFetch_Elfouhaily 
%--------------------------------------------------------------------------
% Nicolas PINEL, 08/2013 - Version: 2025-11 
%--------------------------------------------------------------------------

% Constant terms and input parameters: 
% aff = 1 ;
aff = 0 ;
g = 9.81 ; % Acceleration due to gravity (m/s^2) 
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]
%
% n_k_LS  =  500 ; % Number of points for LS integration over k - OK for u_10 = 5;10
n_k_LS  =  200 ; % Number of points for LS integration over k - OK for u_10 = 5;10
n_tp = 400 ; % Number of sampling points for integration over tan(psi_loc  ) (-) --- SHOULD BE >~ 400 TO AVOID OSCILLATIONS IN THE SHAPE OF Nrcs_Mdl VS Th_i_d 
n_td = 010 ; % Number of sampling points for integration over tan(delta_loc) (-) --- SHOULD BE >~ 010 (!) 
c_thr = 5.0 ; % Threshold for numerical integration over tan(psi_loc  ) AND tan(psi_loc  ) (-) --- SHOULD BE >~ 4.0 
k_max_SS = 3000 ; % Maximum wavenumber of the small-scale (SS) spectrum (rad/m) 
n_k_SS  =  500 ; % Number of points for SS integration over k - OK pour u_10 = ...
%
if isempty(kc) 
    kc = k0_EM / 4.0 ; % To be optimised, depending on f and u_10 
end 


%% Calculation of the RMS slopes of the large scales (LS) from Elfouhaily directional spectrum: 

% General relationships:
k0_surf = g / u_10^2 ; % in rad/m
xmaj = k0_surf * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4]
omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37]
%
kp = k0_surf * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
% kp = omg^2 * g / u_10^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
%
k_min_LS = 0.25 * kp ; % k_min = 0.30 * kp ; % Minimum wavenumber of the large-scale spectrum (rad/m) 
k_max_LS = kc ; % Maximum wavenumber of the large-scale (LS) spectrum (rad/m) 
log_k_min_LS = log10( k_min_LS ) ;
log_k_max_LS = log10( k_max_LS ) ;
log_k_pas_LS = ( log_k_max_LS - log_k_min_LS ) / ( n_k_LS - 1 ) ;
Log_k_LS     = log_k_min_LS : log_k_pas_LS : log_k_max_LS ;
K_LS = 10 .^ Log_k_LS ;
%
% km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24]
% cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
% omg = u_10 / cp 
% omg = round(omg*100)/100 
%
% Sp_h_LS = f_SpectrumSea_Iso_Elfouhaily( u_10 , K_LS , omg , [] ) ; % Large-scale isotropic surface spectrum 
Sp_h_LS = f_SpectrumSea_IsoFetch_Elfouhaily( u_10 , K_LS , fetch_m , [] ) ; % Large-scale isotropic surface spectrum 

sh_LS = sqrt( trapz( K_LS , Sp_h_LS ) ) ;
alpha_sea = 1/2 * trapz( K_LS , K_LS.^2 .* Sp_h_LS ) ;
% [~, Dt_k_LS] = f_SpectrumSea_Ang_Elfouhaily( u_10 , phi_rel_d , K_LS , omg , [] ) ; % Large-scale angular surface spectrum 
[~, Dt_k_LS] = f_SpectrumSea_AngFetch_Elfouhaily( u_10 , phi_rel_d , K_LS , fetch_m , [] ) ; % Large-scale angular surface spectrum 
beta_sea  = 1/4 * trapz( K_LS , K_LS.^2 .* Sp_h_LS .* Dt_k_LS ) ; 
clear Log_k_LS K_LS Sp_h_LS Dt_k_LS ; 
sig_sx_LS = sqrt( alpha_sea + beta_sea ) ;
sig_sy_LS = sqrt( alpha_sea - beta_sea ) ;
%
z0 = 3e-3 ;
u_12 = log(12.5/z0)/log(10/z0) * u_10 ; % From [2012_Wang_TGRS,eq36]
sig_sx_int = sqrt( 3.16e-3 * u_12 ) ; % [Pinel_Book,eq1.83]
sig_sy_int = sqrt( 1.92e-3 * u_12 + 3e-3 ) ; % [Pinel_Book,eq1.84]
sig_sx_ch = sig_sx_LS ; 
sig_sy_ch = sig_sy_LS ; 
% sig_sx_ch = sig_sx_int ; 
% sig_sy_ch = sig_sy_int ; 

% Integration variables TanPsi and TanDlt (tangent of tilt angles Psi and Delta):
% min_tp = -5.0*sig_sx_LS ; max_tp = +5.0*sig_sx_LS ; %n_tp = 500 ;
% min_td = -5.0*sig_sy_LS ; max_td = +5.0*sig_sy_LS ; %n_td = 500 ;
%
min_tp = -c_thr*sig_sx_ch ; max_tp = +c_thr*sig_sx_ch ; %n_tp = 100 ;
min_td = -c_thr*sig_sy_ch ; max_td = +c_thr*sig_sy_ch ; %n_td = 100 ;
%
% min_tp = -5.0*sig_sx_LS ; max_tp = +5.0*sig_sx_LS ; %n_tp = 010 ;
% min_td = -5.0*sig_sy_LS ; max_td = +5.0*sig_sy_LS ; %n_td = 010 ;
%
%
% min_tp = -6.0*sig_sx_ch ; max_tp = +5.0*sig_sx_ch ; %n_tp = 100 ;
% min_td = -5.0*sig_sy_ch ; max_td = +5.0*sig_sy_ch ; %n_td = 100 ;
%
% min_tp = -10.0*sig_sx_LS ; max_tp = +10.0*sig_sx_LS ; %n_tp = 500 ;
% min_td = -10.0*sig_sy_LS ; max_td = +10.0*sig_sy_LS ; %n_td = 500 ;
%
pas_tp = (max_tp-min_tp)/(n_tp-1) ;
pas_td = (max_td-min_td)/(n_td-1) ;
TanPsi_l = min_tp : pas_tp : max_tp ;
TanDlt_l = min_td : pas_td : max_td ;
[TAn_psi, TAn_dlt] = meshgrid(TanPsi_l, TanDlt_l) ;
%
% Associated tilt angles:
PSi_r = atan(TAn_psi) ; % Tilt angle Psi  , in-plane     tilt angle (rad) 
DLt_r = atan(TAn_dlt) ; % Tilt angle Delta, out-of-plane tilt angle (rad) 

% Local surface slope PDF -> assumed to be Gaussian:
% Ux = tan(Th_i_d*pi/180) * cos(phi_rel_d*pi/180) / (sqrt(2) * sig_sx) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% Uy = tan(Th_i_d*pi/180) * sin(phi_rel_d*pi/180) / (sqrt(2) * sig_sy) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
UXloc_LS = TAn_psi / (sqrt(2) * sig_sx_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
UYloc_LS = TAn_dlt / (sqrt(2) * sig_sy_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% UX_LS = tan(th_i_r + PSI_R) .* cos(phi_rel_d*pi/180 + DLT_R) / (sqrt(2) * sig_sx_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% UY_LS = tan(th_i_r + PSI_R) .* sin(phi_rel_d*pi/180 + DLT_R) / (sqrt(2) * sig_sy_LS) ; % tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%
PSloc_Gss2D_LS = 1/(2*pi*sig_sx_LS*sig_sy_LS) * exp(-UXloc_LS.^2 -UYloc_LS.^2) ; 
clear TAn_psi TAn_dlt ; 
%
if aff == 1
    figure(10) ; clf ; grid on ; hold on ; 
    mesh(PSloc_Gss2D_LS) ;
    title(['Large-scale slope PDF']) ;
    pause(1.0) ;
end


% Initialization of the NRCS:
Nrcs_Mdl_HH = zeros(size(Th_i_d)) - 1 ;
Nrcs_Mdl_VV = zeros(size(Th_i_d)) - 1 ;
Nrcs_Mdl_VH = zeros(size(Th_i_d)) - 1 ;
%
for i_th = 1 : length(Th_i_d)
    %
    th_i_r = Th_i_d(i_th) * pi/180 ;

    % Relationships:
    COsTh_loc = cos(th_i_r + PSi_r) .* cos(DLt_r) ;
    II_AngSh = (COsTh_loc>=0) ; % Angular shadowing points defined by abs(local angle)>pi/2, i.e. cos(local angle)<0
    TH_Loc_r = +acos( cos(th_i_r + PSi_r) .* cos(DLt_r) ) ; % [1978_Valenzuela_BLM,above-eq5.1]
    % TH_LOC_R = -acos( cos(th_i_r + PSI_R) .* cos(atan(DLT_R).*cos(PSI_R)) ) ; % [2007_Mouche_JGR,below-eqA2]
    ALpha_i = sin(TH_Loc_r) ; % [1978_Valenzuela_BLM,below-eq5.3]
    ALpha__ = sin(th_i_r + PSi_r) ; % [1978_Valenzuela_BLM,below-eq5.3]
    GAmma__ = cos(th_i_r + PSi_r) ; % [1978_Valenzuela_BLM,below-eq5.3]

    % Local "first-order scattering coefficients" in [1978_Valenzuela_BLM]:
    SQrtDen_Loc = sqrt( er2 - sin(TH_Loc_r).^2 ) ;
    TErmV_Loc = er2*( 1 + sin(TH_Loc_r).^2 ) - sin(TH_Loc_r).^2 ;
    G1_LOC_HH = (er2-1)*1         ./ (   1*cos(TH_Loc_r) + SQrtDen_Loc ).^2 ; % [1978_Valenzuela_BLM,eq4.6]
    G1_LOC_VV = (er2-1)*TErmV_Loc ./ ( er2*cos(TH_Loc_r) + SQrtDen_Loc ).^2 ; % [1978_Valenzuela_BLM,eq4.7]

    % Tilted "first-order scattering coefficients":
    COefC_ = ( ALpha__.*cos(DLt_r) ./ ALpha_i ).^2 ;
    COefS_ = (          sin(DLt_r) ./ ALpha_i ).^2 ;
    COefCS = ( ALpha__.*sin(DLt_r).*cos(DLt_r) ./ ALpha_i ).^2 ;
    %
    POw_G1_HH = abs( COefC_.*G1_LOC_HH + COefS_.*G1_LOC_VV ).^2 ;
    POw_G1_VV = abs( COefC_.*G1_LOC_VV + COefS_.*G1_LOC_HH ).^2 ;
    POw_G1_VH = COefCS .* abs( G1_LOC_VV - G1_LOC_HH ).^2 ;
    %
    % POW_G1_HH = abs( G1_LOC_HH ).^2 ;
    % POW_G1_VV = abs( G1_LOC_VV ).^2 ;
    % POW_G1_VH = zeros(size(G1_LOC_HH)) ;

    % Sea surface spectrum: Elfouhaily, fully-developped seas:
    KX_Loc = 2 * k0_EM * ALpha__ ;
    % KX_LOC = 2 * k0 * sin(th_i_r) ;
    KY_Loc = 2 * k0_EM * GAmma__ .* sin(DLt_r) ;
    PHi_Loc_d = 180/pi * atan(KY_Loc./KX_Loc) + phi_rel_d ;
    PHi_Loc_d = 180/pi * atan(tan(th_i_r + PSi_r).*sin(DLt_r)) + phi_rel_d ;
    % PHI_LOC_D = phi_rel_d ;
    % SH_Iso_Loc  = f_SpectrumSea_Iso_Elfouhaily( u_10 , KX_Loc , omg , [] ) ; % Local isotropic surface spectrum 
    SH_Iso_Loc = f_SpectrumSea_IsoFetch_Elfouhaily( u_10 , KX_Loc , fetch_m , [] ) ; % Local isotropic surface spectrum 
    % PHI_Iso_Loc = f_SpectrumSea_Ang_Elfouhaily( u_10 , PHi_Loc_d , KX_Loc , omg , [] ) ; %%%%% SUR POUR LE PARAMETRE D'ENTREE EN K ??? EN PHI ??? %%%%% % Local angular surface spectrum 
    PHI_Iso_Loc = f_SpectrumSea_AngFetch_Elfouhaily( u_10 , PHi_Loc_d , KX_Loc , fetch_m , [] ) ; %%%%% SUR POUR LE PARAMETRE D'ENTREE EN K ??? EN PHI ??? %%%%% % Local angular surface spectrum 
    SH_Dir_Loc = SH_Iso_Loc .* PHI_Iso_Loc ./ KX_Loc ; %%%%% SUR POUR LE PARAMETRE DIVISEUR EN K ??? %%%%%
    % find(~KX_LOC)
    % High-frequency part = short-scale part of the spectre:
    SH_Dir_Loc_SS = SH_Dir_Loc .* (KX_Loc >= kc) ;
    % any(imag(SH_DIR_LOC_SS(:)))
    % [ KX_LOC(1,:) ; SH_ISO_LOC(1,:) ]
    % KX_LOC(1,:)
    % SH_ISO_LOC(1,:)
    % PHI_ISO_LOC(1,:)
    % pause ;


    % Sea surface spectrum evaluated at Bragg wavenumber kB=2*k0*sin(Theta_i):
    k_B = 2 * k0_EM * sin(th_i_r) ;
    % sh_iso_kB  = f_SpectrumSea_Iso_Elfouhaily( u_10 , k_B , omg , [] ) ; % Isotropic surface spectrum at Bragg wavenumber 
    sh_iso_kB = f_SpectrumSea_IsoFetch_Elfouhaily( u_10 , k_B , fetch_m , [] ) ; % Isotropic surface spectrum at Bragg wavenumber 
    % phi_iso_kB = f_SpectrumSea_Ang_Elfouhaily( u_10 , phi_rel_d , k_B , omg , [] ) ; % Angular surface spectrum at Bragg wavenumber 
    phi_iso_kB = f_SpectrumSea_AngFetch_Elfouhaily( u_10 , phi_rel_d , k_B , fetch_m , [] ) ; % Angular surface spectrum at Bragg wavenumber 

    spect_kB = sh_iso_kB .* phi_iso_kB ./ k_B ;
    spect_kB_SS = spect_kB .* (k_B >= kc) ;
    spect_mean_SS = mean(mean(SH_Dir_Loc_SS)) ;


    % Multiplicative term in [1978_Valenzuela_BLM]:
    TErm1_Loc = 4 * pi * k0_EM^4 * cos(TH_Loc_r).^4 ; % [1978_Valenzuela_BLM,eq4.5]

    % Local NRCS under the SPM1 model:
    % SIG0_LOCSPM_HH = TERM1_LOC .* POW_G1_HH .* SH_DIR_LOC_SS ;
    % SIG0_LOCSPM_VV = TERM1_LOC .* POW_G1_VV .* SH_DIR_LOC_SS ;
    % SIG0_LOCSPM_VH = TERM1_LOC .* POW_G1_VH .* SH_DIR_LOC_SS ;
    SIg0_LocSPM_HH = TErm1_Loc .* POw_G1_HH .* SH_Dir_Loc_SS / pi ;
    SIg0_LocSPM_VV = TErm1_Loc .* POw_G1_VV .* SH_Dir_Loc_SS / pi ;
    SIg0_LocSPM_VH = TErm1_Loc .* POw_G1_VH .* SH_Dir_Loc_SS / pi ;
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
        mesh(real(SIg0_LocSPM_HH)) ;
    	title(['Local SPM1 NRCS (HH) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
        view(az, el);
        subplot(223) ;
        %     mesh(SIG0_LOCSPM_VV) ;
        mesh(real(SIg0_LocSPM_VV)) ;
    	title(['Local SPM1 NRCS (VV) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
        view(az, el);
        %     pause(0.5) ;
        %
        %
        %     figure(12) ; clf ;
        subplot(222) ;
        %     mesh(SIG0_LOCSPM_HH .* PS_GSS2D_AN_LS) ;
        mesh(real(SIg0_LocSPM_HH .* PSloc_Gss2D_LS)) ;
    	title(['Integrand (HH) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
        view(az, el);
        subplot(224) ;
        %     mesh(SIG0_LOCSPM_VV .* PS_GSS2D_AN_LS) ;
        mesh(real(SIg0_LocSPM_VV .* PSloc_Gss2D_LS)) ;
    	title(['Integrand (VV) - \theta_0 = ' num2str(th_i_r*180/pi) '°']) ;
        view(az, el);
        pause(0.5) ;
    end
    %
    Nrcs_Mdl_HH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIg0_LocSPM_HH .* PSloc_Gss2D_LS .* II_AngSh ) ) ;
    Nrcs_Mdl_VV(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIg0_LocSPM_VV .* PSloc_Gss2D_LS .* II_AngSh ) ) ;
    Nrcs_Mdl_VH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIg0_LocSPM_VH .* PSloc_Gss2D_LS .* II_AngSh ) ) ;
    % Nrcs_Mdl_HH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_HH .* 1 ) ) ;
    % Nrcs_Mdl_VV(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_VV .* 1 ) ) ;
    % Nrcs_Mdl_VH(i_th) = trapz( TanPsi_l , trapz( TanDlt_l , SIG0_LOCSPM_VH .* 1 ) ) ;
    %
    % fprintf('.') ;

end % End of loop on Th_i_d 


% Calculation of the short-scale RMS height -> complementary term, see [2008_Soriano_GRSL,eq24]:
k_min_SS = k_max_LS ;
log_k_min_SS = log10( k_min_SS ) ;
log_k_max_SS = log10( k_max_SS ) ;
log_k_pas_SS = ( log_k_max_SS - log_k_min_SS ) / ( n_k_SS - 1 ) ;
Log_k_SS     = log_k_min_SS : log_k_pas_SS : log_k_max_SS ;
K_SS = 10 .^ Log_k_SS ;
% Sp_h_SS = f_SpectrumSea_Iso_Elfouhaily( u_10 , K_SS , omg , [] ) ; % Small-scale isotropic surface spectrum 
Sp_h_SS = f_SpectrumSea_IsoFetch_Elfouhaily( u_10 , K_SS , fetch_m , [] ) ; % Small-scale isotropic surface spectrum 
sh_SS = sqrt( trapz( K_SS , Sp_h_SS ) ) ; 
clear Log_k_SS K_SS Sp_h_SS ; 
sh_CM = 6.29e-3 * u_10^2.02 ;
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
qq = 2 * k0_EM ;
Qz = qq * cos(Th_i_d * pi/180) ;
AddTerm_VV = Nrcs_GO1sh_VV * exp(-qq^2*sh_SS^2) .* ( 1 - exp(-Qz.^2.*sh_LS^2) ) ;
AddTerm_HH = Nrcs_GO1sh_HH * exp(-qq^2*sh_SS^2) .* ( 1 - exp(-Qz.^2.*sh_LS^2) ) ;
AddTerm_VH = 0 ;


Nrcs_Mdl_HH = Nrcs_Mdl_HH + AddTerm_HH ; Nrcs_Mdl_HH = 4*pi * Nrcs_Mdl_HH ; 
Nrcs_Mdl_VV = Nrcs_Mdl_VV + AddTerm_VV ; Nrcs_Mdl_VV = 4*pi * Nrcs_Mdl_VV ; 
Nrcs_Mdl_VH = Nrcs_Mdl_VH + AddTerm_VH ; Nrcs_Mdl_VH = 4*pi * Nrcs_Mdl_VH ; 

% fprintf('\n') ;
%
r_GO = 4*pi * cos(th_i_r) ; % ratio of GO in [1978_Valenzuela_BLM,eq3.4] relatively to my GO model
