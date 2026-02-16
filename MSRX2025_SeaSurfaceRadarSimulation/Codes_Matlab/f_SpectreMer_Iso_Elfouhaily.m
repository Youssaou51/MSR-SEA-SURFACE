function [Sh_iso] = f_SpectreMer_Iso_Elfouhaily( u_10 , K , omg , u_f ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SpectreMer_Iso_Elfouhaily
%--------------------------------------------------------------------------
% Calculates the isotropic part of the sea surface height spectrum, 
% according to the model of Elfouhaily [1997_Elfouhaily_JGR,1999_Bourlier_These]
% This model takes into account both the gravity and capillary waves, 
% and is valid only for fully-developed seas (infinite fetch)
%--------------------------------------------------------------------------
% Input variables:
% u_10  : wind speed at 10 m above the sea surface (m/s) [scalar]
% K     : surface wavenumber (rad/m) [Vector]
% omg   : inverse of the age of the wave Omega [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Sh_iso : Surface height spectrum [Vector]
%--------------------------------------------------------------------------
% COMMENTS:
% ...
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 08/2013
%--------------------------------------------------------------------------

% Constants:
g = 9.81 ; % acceleration due to gravity (m/s^2)
km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24]
% km = 363 ; % in rad/m (code Bourlier)
% vphm = 0.23 ; % in m/s
vphm = sqrt(2*g/km) ; % = 0.23 m/s
kk = 0.4 ;

% Relations:
kp = omg^2 * g / u_10^2 ;
%
% omg = 0.84 * tanh( (fetch/2.2e4)^0.4 )^-0.75 ;
% uf_cms = u_f * 100 ;
% z0_cm = 0.684/uf_cms + 4.28e-5*uf_cms^2 - 4.43e-2 ;
% z0 = z0_cm / 100 ;
% u_10 = u_f/kk * log(19.5/z0) ;
%
if isempty(u_f)
    cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
    z0 = 3.7e-5 * u_10^2/g * (u_10/cp)^0.9 ; % [1997_Elfouhaily_JGR,eq.66]
    u_f = kk / log(10/z0) * u_10 ; % [1997_Elfouhaily_JGR,eq.60]
    %
%     c_d10N = ( 0.8 + 0.065 * u_10 ) * 1e-3 ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61]
%     u_f = sqrt( c_d10N ) * u_10 ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61]
end
%
vg = u_10 / omg ;
alphag = 6e-3 * sqrt(omg) ;
sgm = 0.08 * (1+4/omg^3) ;
if (0.84<=omg) && (omg<=1)
    gm = 1.7 ;
elseif (1<omg) && (omg<=5)
    gm = 1.7 + 6*log10(omg) ;
end
if u_f <= vphm
    alphac = 1e-2 * (1 + 1*log(u_f/vphm)) ;
elseif u_f > vphm % the "if" is useless
    alphac = 1e-2 * (1 + 3*log(u_f/vphm)) ;
end

% Parameters of the spectrum:
Vph = sqrt( g./K .* (1+K.^2/km^2) ) ;
F_c = exp( -1/4 * (K/km - 1).^2 ) ;
F_g = exp( -omg/sqrt(10) * (sqrt(K/kp) - 1) ) ;

% Isotropic spectrum:
% Sh_iso = K.^-3./(2*Vph) .* (alphag*vg*F_g + alphac*vphm*F_c) .* gm.^exp( -(sqrt(K/km)-1).^2/(2*sgm^2) ) .* exp(-5/4 * (kp./K).^2) ;
% Sh_iso = K.^-3./(2*Vph) .* (alphag*vg*F_g .* gm.^exp( -(sqrt(K/km)-1).^2/(2*sgm^2) ) + alphac*vphm*F_c) .* exp(-5/4 * (kp./K).^2) ;
%
B_l = 1./(2*Vph) .* (alphag*vg  *F_g) .* gm.^exp( -(sqrt(K/kp)-1).^2/(2*sgm^2) ) .* exp(-5/4 * (kp./K).^2) ;
B_h = 1./(2*Vph) .* (alphac*vphm*F_c) .* 1 .* exp(-5/4 * (kp./K).^2) ;
%
Sh_iso = K.^-3 .* (B_l + B_h) ;
