function Sig0_NRL_dB = f_GrazingNRCS_NRL (Chi_d, lambda_m, SeaState, ph__d, polar)

% Chi_d     : Angle d'incidence - angle de rasance (deg)
% lambda_m  : Longueur d'onde (m)
% SeaState  : Etat de mer [Beaufort scale]
% ph__d     : Angle entre LOS et vent (deg)
% polar     : 'H' ou 'V'
%
% Sig0_NRL_dB    : NRCS sigma0 (dB)
%
% Tiré de [2009_Gregers-Hansen_Radar]
% !!! NOTE IMPORTANTE : NE DEPEND PAS DE LA DIRECTION D'OBSERVATION ph__d !!!

f_GHz = 3e8/lambda_m/1e9 ;
%
if polar == 'H'
    c1 = -72.76 ;
    c2 =  21.11 ;
    c3 =  24.78 ;
    c4 =  4.917 ;
    c5 = 0.6216 ;
    c6 = -0.02949 ;
    c7 = 26.19 ;
    c8 = 0.09345 ;
    c9 = 0.05031 ;
elseif polar == 'V'
    c1 = -48.56 ;
    c2 =  26.30 ;
    c3 =  29.05 ;
    c4 = -0.5183 ;
    c5 = 1.057  ;
    c6 =  0.04839 ;
    c7 = 21.37 ;
    c8 = 0.07466 ;
    c9 = 0.04623 ;
end
%
Sig0_NRL_dB = c1 + c2*log10(sind(Chi_d)) + (c3+c4*Chi_d)*log10(f_GHz) ./ (1+c5*Chi_d+c6*SeaState) ...
    + c7*(1+SeaState).^(1./(2+c8*Chi_d+c9*SeaState)) ;


