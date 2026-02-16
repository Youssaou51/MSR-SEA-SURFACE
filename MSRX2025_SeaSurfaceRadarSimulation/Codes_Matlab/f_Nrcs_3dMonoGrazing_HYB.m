function Sig0_HYB_dB = f_Nrcs_3dMonoGrazing_HYB (Chi_d, lambda_m, seaState, ph__d, polar)

% Chi_d     : Angle d'incidence - angle de rasance (deg)
% lambda_m  : Longueur d'onde (m)
% seaState  : Etat de mer [Beaufort scale]
% ph__d     : Angle entre LOS et vent (deg)
% polar     : 'H' ou 'V'
%
% Sig0_HYB_dB    : NRCS sigma0 (dB)
%
% Tiré de [1998_Antipov_ReportDSTO] + [1990_Reilly_RST] + [2000_Choong_ReportDSTO]

c_t = 0.0660 ; % valeur dans [1990_Reilly_RST]
% c_t = 0.0632 ; % valeur dans [1998_Antipov_ReportDSTO] + [2000_Choong_ReportDSTO]
%
f_GHz = 3e8/lambda_m/1e9 ;
%
% Reference reflectivity sigma0ref (sea state 5):
if numel(f_GHz)>1 || numel(polar)>1 || numel(seaState)>1
    disp('PAS PRIS EN COMPTE DANS LE CODE, DESOLE') ;
    return ;
end
if f_GHz <= 12.5
    Sig0Ref_dB = 24.4*log10(f_GHz) - 65.2 ; % f en GHz a priori [1990_Reilly_RST]
else
    Sig0Ref_dB = 3.25*log10(f_GHz) - 42.0 ; % f en GHz a priori [1990_Reilly_RST]
end
%
% Grazing angle adjustment Kg:
chr_d = 0.1 ; % reference grazing angle (deg)
s_h = 0.031 * seaState.^2 ; % root-mean-sqaure wave height (m)
Cht_d = asind(c_t*lambda_m./s_h) ; % transitional angle (deg) - lambda en m a priori [1990_Reilly_RST]
%
Kg = zeros(size(Chi_d)) ;
% I_t = (Cht_d>=chr_d) ;
for ii = 1 : length(Chi_d)
    if Cht_d(ii) >= chr_d
        if Chi_d(ii) < chr_d
            Kg(ii) = 0 ;
        elseif Chi_d(ii) <= Cht_d(ii)
            Kg(ii) = 20*log10(Chi_d(ii)/chr_d) ;
        elseif Chi_d(ii) <= 30
            Kg(ii) = 20*log10(Cht_d(ii)/chr_d) + 10*log10(Chi_d(ii)/Cht_d(ii)) ;
        else
            disp('ATTENTION ANGLE PAS PRIS EN COMPTE DANS LE MODELE') ;
            return ;
        end % Fin if sur Chi_d
    else
        if Chi_d(ii) < chr_d
            Kg(ii) = 0 ;
        else
            Kg(ii) = 10*log10(Chi_d(ii)/chr_d) ;
        end  % Fin if sur Chi_d
    end % Fin if sur Cht_d
end % Fin boucle for
%
% Sea state adjustment ks:
ks = 5 * (seaState-5) ;
%
% Polarization adjustment Kp:
hav = 0.08 * seaState.^2 ;
if polar == 'V'
    Kp = zeros(size(Chi_d)) ;
elseif polar == 'H'
    if f_GHz < 3
        Kp = 1.7*log(hav+0.015) - 3.8*log(lambda_m) ...
            - 2.5*log(Chi_d/57.3+0.0001) - 22.2 ; % Chi en deg - lambda en m a priori [1990_Reilly_RST]
    elseif f_GHz <= 10
        Kp = 1.1*log(hav+0.015) - 1.1*log(lambda_m) ...
            - 1.3*log(Chi_d/57.3+0.0001) - 09.7 ; % Chi en deg - lambda en m a priori [1990_Reilly_RST]
    else
        Kp = 1.4*log(hav      ) - 3.4*log(lambda_m) ...
            - 1.3*log(Chi_d/57.3       ) - 18.6 ; % Chi en deg - lambda en m a priori [1990_Reilly_RST]
    end
end % Fin if polar
%
% Wind direction adjustment kd:
kd = ( 2+1.7*log10(0.1/lambda_m) ) * (cosd(ph__d)-1) ; % lambda en m a priori [1990_Reilly_RST]
%
Sig0_HYB_dB = Sig0Ref_dB + Kg + ks + Kp + kd ;


