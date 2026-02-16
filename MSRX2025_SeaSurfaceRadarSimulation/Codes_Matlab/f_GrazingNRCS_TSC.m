function Sig0_TSC_dB = f_GrazingNRCS_TSC (Chi_d, lambda_m, SeaState, ph__d, polar)

% Chi_d     : Angle d'incidence - angle de rasance (deg)
% lambda_m  : Longueur d'onde (m)
% SeaState  : Etat de mer [Beaufort scale]
% ph__d     : Angle entre LOS et vent (deg)
% polar     : 'H' ou 'V'
%
% Sig0_TSC_dB    : NRCS sigma0 (dB)
%
% Tiré de [1998_Antipov_ReportDSTO] + [2000_Choong_ReportDSTO]

rap_ftm = 3.2808399 ;
lb_ft = lambda_m * rap_ftm ; % radar wavelength (feet)
Chi_r = Chi_d * pi/180 ;
f_GHz = 3e8/lambda_m/1e9 ;
%
% Facteur correctif [2005_Spaulding_Radar] :
Gm = 1 ;
% b = 0.6 ; % [2005_Spaulding_Radar] --- TROP ELEVE A 9.2 GHz (5.5 dB au lieu de 3 dB annoncé... mais f non donné !!!)
% b = 0.4 ; % [2005_Spaulding_Radar] --- TROP ELEVE A 9.2 GHz (5.5 dB au lieu de 3 dB annoncé... mais f non donné !!!)
% Gm = 1-b*(sind(ph__d))^2 ;
%
% Low grazing angle factor G_A :
S_h = 0.115 * SeaState.^1.95 ; % surface height standard deviation (m)
S_a = 14.9*Chi_r .* (S_h+0.25)/lb_ft ;
G_A = S_a.^1.5 ./ (1+S_a.^1.5) ;
%
% Wind speed factor G_w :
V_w = 6.2 * SeaState.^0.8 ; % wind speed
Q = Chi_r.^0.6 ;
a1 = ( 1+(lb_ft/0.03)^3 )^0.1 ;
a2 = ( 1+(lb_ft/0.1 )^3 )^0.1 ;
A3 = ( 1+(lb_ft/0.3 )^3 ).^(Q/3) ;
A4 = 1 + 0.35*Q ;
A = 2.63*a1./(a2*A3.*A4) ;
G_w = ((V_w+4.0)/15).^A ;
%
% Aspect factor G_u :
G_u = Gm * exp( 0.3*cosd(ph__d) * exp(-Chi_r/0.17)/(lb_ft^2+0.005)^0.2 ) ;
G_u(Chi_r==pi/2) = 1 ;
%
% Reflectivity sigma0 (dBm^2/m^2) :
Sig0_H_lin = 1.7e-5*Chi_r.^0.5 .* G_u.*G_w.*G_A/(lb_ft+0.05)^1.8 ;
Sig0_H_dB = 10*log10( Sig0_H_lin ) ;
%
if numel(f_GHz)>1 || numel(polar)>1 
    disp('PAS PRIS EN COMPTE DANS LE CODE, DESOLE') ;
    return ;
end
%
if polar == 'H'
    Sig0_TSC_dB = Sig0_H_dB ;
elseif polar == 'V'
    if f_GHz < 2
        Sig0_TSC_dB = Sig0_H_dB - 1.73*log(2.507*S_h+0.05) + 3.76*log(lb_ft) ...
            + 2.46*log(sin(Chi_r)+0.0001) + 19.8 ;
    else
        Sig0_TSC_dB = Sig0_H_dB - 1.05*log(2.507*S_h+0.05) + 1.09*log(lb_ft) ...
            + 1.27*log(sin(Chi_r)+0.0001) + 9.65 ;
    end
end


