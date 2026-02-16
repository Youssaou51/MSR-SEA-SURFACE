function Sig0_SIT_dB = f_Nrcs_3dMonoGrazing_SIT (Chi_d, lambda_m, SeaState, ph__d, polar)

% valable pour lambda_m = 3.2 cm
%
% Chi_d     : Angle d'incidence - angle de rasance (deg)
% lambda_m  : Longueur d'onde (m)
% SeaState  : Etat de mer [Beaufort scale]
% ph__d     : Angle entre LOS et vent (deg)
% polar     : 'H' ou 'V'
%
% Sig0_SIT_dB : NRCS sigma0 (dB)
%
% Tiré de [1998_Antipov_ReportDSTO]

if lambda_m ~= 3.2e-2
%     disp('MODELE VALIDE POUR 3.2 CM SEULEMENT, DESOLE') ;
    Sig0_SIT_dB = zeros(size(Chi_d)) ;
    return
end
%
ch0_d = 0.5 ;
w0_kt = 10 ;
%
Al_dB = [ -50 -53 -49 -58 ] ;
Bt_dB = [ 12.6 6.5 17 19 ] ;
Gm_dB = [ 34 34 30 50 ] ;
Dt_dB = [ -13.2 0 -12.4 -33 ] ;
%
if numel(ph__d)>1 || numel(polar)>1 
    disp('PAS PRIS EN COMPTE DANS LE CODE, DESOLE') ;
    return ;
end
if polar == 'H'
    if ph__d == 0
        ch_i = 1 ;
    elseif ph__d == 90
        ch_i = 2 ;
    else
        disp('NON TABULE, DESOLE...') ;
        return ;
    end
elseif polar == 'V'
    if ph__d == 0
        ch_i = 3 ;
    elseif ph__d == 90
        ch_i = 4 ;
    else
        disp('NON TABULE, DESOLE...') ;
        return ;
    end
end
%
al_dB = Al_dB(ch_i) ; bt_dB = Bt_dB(ch_i) ;
gm_dB = Gm_dB(ch_i) ; dt_dB = Dt_dB(ch_i) ;
%
%Ww_ms = 0.836*SeaState.^1.5 ; % http://en.wikipedia.org/wiki/Beaufort_scale
Ww_ms = 3.16 * SeaState.^0.8 ; % Vitesse du vent (...)
rap_ktms = 1.94384449 ;
Ww_kt =  Ww_ms * rap_ktms ; % Verifiée
ChLog = log10(Chi_d/ch0_d) ;
Sig0_SIT_dB = al_dB + bt_dB * ChLog + (dt_dB*ChLog+gm_dB) .* log10(Ww_kt/w0_kt) ;


