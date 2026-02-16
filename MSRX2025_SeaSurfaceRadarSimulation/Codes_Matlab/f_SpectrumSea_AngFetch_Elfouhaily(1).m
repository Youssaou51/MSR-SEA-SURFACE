function [Phi_iso, Dt_k] = f_SpectrumSea_AngFetch_Elfouhaily( u_10 , phi_d , K , fetch_m , u_f ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SpectrumSea_AngFetch_Elfouhaily
%--------------------------------------------------------------------------
% Calculates the angular part of the sea surface height spectrum, 
% according to the model of Elfouhaily [1997_Elfouhaily_JGR]
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account
%--------------------------------------------------------------------------
% Input variables:
% u_10  : wind speed at 10 m above the sea surface (m/s) [scalar]
% phi_d : wind direction (deg.) [scalar]
% K     : surface wavenumber (rad/m) [Vector]
% fetch_m : fetch = length of action of wind on the sea (m) [scalar]
% u_f   : wind speed at the sea surface = friction velocity (m/s) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Phi_iso : Surface height spreading (angular) function [Vector]
%--------------------------------------------------------------------------
% COMMENTS:
% To obtain the directional spectrum, we must do: Sh_iso .* Phi_iso ./ K
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
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
a0 = log(2)/4 ; % [1997_Elfouhaily_JGR,eq.59]
ap = 4 ; % [1997_Elfouhaily_JGR,eq.59]
kk = 0.4 ;

% Relations:
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
    cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
    z0 = 3.7e-5 * u_10^2/g * (u_10/cp)^0.9 ; % [1997_Elfouhaily_JGR,eq.66]
    u_f = kk / log(10/z0) * u_10 ; % [1997_Elfouhaily_JGR,eq.60]
    %
%     c_d10N = ( 0.8 + 0.065 * u_10 ) * 1e-3 ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61]
%     u_f = sqrt( c_d10N ) * u_10 ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61]
end
%
cm = sqrt(2*g/km) ; % = 0.23 m/s
am = 0.13*u_f/cm ; % [1997_Elfouhaily_JGR,eq.59]
%
Dt_k = tanh(a0 + ap*(C/cp).^2.5 + am*(cm./C).^2.5) ; % [1997_Elfouhaily_JGR,eq.57]

% Spreading function:
Phi_iso = 1/(2*pi) * (1 + Dt_k*cosd(2*phi_d)) ;
