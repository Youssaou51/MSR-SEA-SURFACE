function Sig0_GIT_dB = f_GrazingNRCS_Nathanson (Chi_d, lambda_m, SeaState, ph__d, polar)

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_StatisticSea_GO4
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations, with respect to the "GO4" model
% [Boisot_2015_TGRS].
% whose sea surface height spectrum is the directional Elfouhaily spectrum 
% for fully-developped seas with input parameters u_10 and omega_D (omg here)
% Nota: The shadowing effect is calculated with the Smith approach without
% correlation
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d: incidence elevation angle with respect to the vertical z (deg.) [Vector/Matrix]
% phi_rel_d : radar direction relative to the wind direction (deg.) [scalar]
% er2   : relative permittivity of transmission (lower) medium [salar]
% u_10  : wind speed at 10 m above the sea surface (m/s) [scalar]
% omg   : inverse of the age of the wave Omega [scalar]
% k0    : electromagnetic wavenumber (rad/m) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_GO4_VV : NRCS under considered model in VV polarization [Vector/Matrix - lin. scale]
% Nrcs_GO4_HH : NRCS under considered model in HH polarization [Vector/Matrix - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% ... (see [2013_Pinel_Book])
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
% Boisot et al., TGRS, vol. 53, pp. 5889-5900, 2015
%--------------------------------------------------------------------------
% Called functions:
% f_SpectrumSea_Iso_Elfouhaily
% f_SpectrumSea_Ang_Elfouhaily
%--------------------------------------------------------------------------
% Nicolas PINEL, 12/2015
%--------------------------------------------------------------------------



% Chi_d     : Angle d'incidence - angle de rasance (deg)
% lambda_m  : Longueur d'onde (m)
% SeaState  : Etat de mer [Beaufort scale]
% ph__d     : Angle entre LOS et vent (deg)
% polar     : 'H' ou 'V'
%
% Sig0_GIT_dB    : NRCS sigma0 (dB)
%
% Tiré de [1978_Horst_] + [1990_Paulus_TAP] + [1998_Antipov_ReportDSTO] + [2000_Choong_ReportDSTO]

cste1 = 0.015 ; % valeur dans [1978_Horst_] + [2000_Choong_ReportDSTO]
% cste1 = 0.02 ; % valeur dans [1990_Paulus_TAP] + [1998_Antipov_ReportDSTO]
%
cste2 = 0.015 ; % valeur dans [1978_Horst_] + [1998_Antipov_ReportDSTO] + [2000_Choong_ReportDSTO]
% cste2 = 0.02 ; % valeur dans [1990_Paulus_TAP] UNIQUEMENT (!)
%
c_Aw1 = 1.9400 ; % valeur dans [1978_Horst_] + [1998_Antipov_ReportDSTO] + [2000_Choong_ReportDSTO]
c_Aw2 = 15.4 ; % valeur dans [1978_Horst_] + [1998_Antipov_ReportDSTO] + [2000_Choong_ReportDSTO]
% c_Aw1 = 1.9425 ; % valeur dans [1990_Paulus_TAP]
% c_Aw2 = 15.0 ; % valeur dans [1990_Paulus_TAP]
%
f_GHz = 3e8/lambda_m/1e9 ;
V_w = 3.16 * SeaState.^0.8 ; % Vitesse du vent (m/s a priori [1978_Horst_])
H_av = 4.52e-3 .* V_w.^2.5 ; % Average wave height (m)
Chi_r = Chi_d * pi/180 ;
%
% Facteur correctif [2005_Spaulding_Radar] :
Gm = 1 ;
% b = 0.6 ; % [2005_Spaulding_Radar] --- TROP ELEVE A 9.2 GHz (5.5 dB au lieu de 3 dB annoncé... mais f non donné !!!)
% b = 0.4 ; % [2005_Spaulding_Radar] --- TROP ELEVE A 9.2 GHz (5.5 dB au lieu de 3 dB annoncé... mais f non donné !!!)
% Gm = 1-b*(sind(ph__d))^2 ;
%
if numel(f_GHz)>1 || numel(polar)>1
    disp('PAS PRIS EN COMPTE DANS LE CODE, DESOLE') ;
    return ;
end
if (f_GHz<1) || (f_GHz>100)
    disp('FREQUENCE PAS PRISE EN COMPTE DANS LE MODELE, DESOLE...') ;
    return ;
end
%
% Interference factor A_I:
S_ch = (14.4*lambda_m+5.5)*Chi_r.*H_av/lambda_m ;
A_I = S_ch.^4 ./ (1+S_ch.^4) ;
%
% Upwind / downwind factor A_u:
if f_GHz < 10
    A_u = Gm * exp( 0.20*cosd(ph__d)*(1-2.8*Chi_r)*(lambda_m+cste1).^-0.40 ) ;
elseif f_GHz <= 100
    A_u = Gm * exp( 0.25*cosd(ph__d)*(1-2.8*Chi_r)*(lambda_m      ).^-0.33 ) ;
end
%
% Wind speed factor A_w:
if f_GHz < 10
    qw = 1.10/(lambda_m+cste1)^0.4 ;
elseif f_GHz <= 100
    qw = 1.93/(lambda_m      )^0.4 ;
end
A_w = ( c_Aw1*V_w ./ (1+V_w/c_Aw2) ).^qw ;
%
% Reflectivity sigma0 (dBm^2/m^2):
if f_GHz < 10
    Sig0_H_dB = 10*log10( 3.90e-6*lambda_m * Chi_r.^0.400 .* A_I.*A_u.*A_w ) ;
elseif f_GHz <= 100
    Sig0_H_dB = 10*log10( 5.78e-6*1        * Chi_r.^0.547 .* A_I.*A_u.*A_w ) ;
end
%
if polar == 'H'
    Sig0_GIT_dB = Sig0_H_dB ;
elseif polar == 'V'
    if f_GHz < 3
        Sig0_GIT_dB = Sig0_H_dB - 1.73*log(H_av+cste2) + 3.76*log(lambda_m) ...
            + 2.46*log(Chi_r+0.0001) + 22.20 ;
    elseif f_GHz <= 10
        Sig0_GIT_dB = Sig0_H_dB - 1.05*log(H_av+cste2) + 1.09*log(lambda_m) ...
            + 1.27*log(Chi_r+0.0001) + 09.70 ;
    elseif f_GHz <= 100
        Sig0_GIT_dB = Sig0_H_dB - 1.38*log(H_av      ) + 3.43*log(lambda_m) ...
            + 1.31*log(Chi_r       ) + 18.55 ;
    end
end


