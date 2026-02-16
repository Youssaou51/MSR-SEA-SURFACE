function [Sh_iso] = f_SpectrumSea_IsoFetch_Elfouhaily( u_10 , K , fetch_m , u_f ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SpectrumSea_IsoFetch_Elfouhaily
%--------------------------------------------------------------------------
% Calculates the isotropic part of the sea surface height spectrum, 
% according to the model of Elfouhaily [1997_Elfouhaily_JGR,1999_Bourlier_These]
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account
%--------------------------------------------------------------------------
% Input variables:
% u_10  : wind speed at 10 m above the sea surface (m/s) [scalar]
% K     : surface wavenumber (rad/m) [Vector]
% fetch_m : fetch = length of action of wind on the sea (m) [scalar]
% u_f   : wind speed at the sea surface = friction velocity (m/s) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Sh_iso : Surface height spectrum [Vector]
%--------------------------------------------------------------------------
% COMMENTS:
% To obtain the directional spectrum, we must do: Sh_iso .* Phi_iso ./ K
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 08/2013
%--------------------------------------------------------------------------

K(K<0) = -K(K<0) ;

% Constants:
g = 9.81 ; % acceleration due to gravity (m/s^2)
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]
km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24]
% km = 363 ; % in rad/m (code Bourlier)

% General relations:
k0 = g / u_10^2 ; % in rad/m
xmaj = k0 * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4]
omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37]
kp = k0 * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
%
C  = sqrt(g*(1+K.^2/km^2)./K ) ; % Phase speed in m/s [1982_Fung_JOE], [1997_Elfouhaily_JGR,eq.24]
cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
%
% C  = sqrt(g./K ) ; % Phase speed in m/s [...]
% cp = sqrt(g/kp ) ; % Phase speed at spectral peek
%
if isempty(u_f)
    kk = 0.40 ;
    z0 = 3.7e-5 * u_10^2/g * (u_10/cp)^0.9 ; % [1997_Elfouhaily_JGR,eq.66]
    u_f = kk / log(10/z0) * u_10 ; % [1997_Elfouhaily_JGR,eq.60]
    %
%     c_d10N = ( 0.8 + 0.065 * u_10 ) * 1e-3 ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61]
%     u_f = sqrt( c_d10N ) * u_10 ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61]
end

% Relations for long-wave spectrum:
omg = u_10 / cp ;
alphp = 6e-3 * sqrt(omg) ; % [1997_Elfouhaily_JGR,eq.34]
%
if (0.84<=omgc) && (omgc<=1)
    gm = 1.7 ;
elseif (1<omgc) && (omgc<=5)
    gm = 1.7 + 6*log10(omgc) ;
%     if (omgc>5)
%         disp('/!\ \Omega_c > 5 /!\') ;
%     end
end
sgm = 0.08 * (1 + 4*omgc^-3) ;

% Parameters:
L_PM = exp(-5/4 * (kp./K).^2) ; % [1997_Elfouhaily_JGR,eq.2]
J_p = gm .^ exp(-(sqrt(K/kp)-1).^2 / (2*sgm^2)) ; % [1997_Elfouhaily_JGR,eq.3]
%
F_p = L_PM .* J_p .* exp(-omg/sqrt(10) * (sqrt(K/kp)-1)) ;

% Long-wave curvature spectrum [1997_Elfouhaily_JGR,eq.31]:
B_l = 1/2 * alphp * cp./C .* F_p ; % [1997_Elfouhaily_JGR,eq.31]

% Relations for short-wave spectrum:
cm = sqrt(2*g/km) ; % = 0.23 m/s
% cm = 0.23  % = 0.23 m/s
if u_f <= cm
    alphm = 1e-2 * (1 + 1*log(u_f/cm)) ; % [1997_Elfouhaily_JGR,eq.44]
elseif u_f > cm % the "if" is useless
    alphm = 1e-2 * (1 + 3*log(u_f/cm)) ; % [1997_Elfouhaily_JGR,eq.44]
end
%
F_m = exp( -1/4 * (K/km-1).^2 ) ; % [1997_Elfouhaily_JGR,eq.41]

% Short-wave curvature spectrum [1997_Elfouhaily_JGR,eq.40]:
B_h = 1/2 * alphm * cm./C .* F_m .* L_PM ; % [1997_Elfouhaily_JGR,eq.40]

% Isotropic spectrum:
Sh_iso = K.^-3 .* (B_l + B_h) ; % [1997_Elfouhaily_JGR,eq.30]
