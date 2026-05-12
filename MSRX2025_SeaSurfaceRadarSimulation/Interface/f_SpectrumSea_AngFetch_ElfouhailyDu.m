function [Phi_spr, Dt_k] = f_SpectrumSea_AngFetch_ElfouhailyDu( u_10 , Phi_d , K , fetch_m , u_f , StrgMdl ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SpectrumSea_AngFetch_ElfouhailyDu
%--------------------------------------------------------------------------
% Calculates the angular part of the sea surface height spectrum, 
% according to the model of Elfouhaily [Elfouhaily_1997_JGR]. 
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account. 
%--------------------------------------------------------------------------
% Input variables:
% u_10  : Wind speed at 10 m above the sea surface (m/s) [scalar]
% Phi_d : Wind direction (deg.) [scalar/Vector of same size as K]
% K     : Surface wavenumber (rad/m) [Vector]
% fetch_m : Fetch = length of action of wind on the sea (m) [scalar]
% u_f   : Wind speed at the sea surface = friction velocity (m/s) [scalar]
% StrgMdl : Choice of model: 'El'->Eloufhaily / 'Du'->Du [String]
%--------------------------------------------------------------------------
% Output variables:
% Phi_spr : Surface height angular spreading function (ASF) [Vector]
% Dt_k    : Upwind-crosswind ratio [Vector]
%--------------------------------------------------------------------------
% COMMENTS:
% To obtain the directional spectrum, we must do: Sh_iso .* Phi_iso ./ K
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 2026-04 
%--------------------------------------------------------------------------

K(K<0) = -K(K<0) ;

% Constants:
g = 9.81 ; % acceleration due to gravity (m/s^2)
x0 = 2.2e4 ; % in m [Elfouhaily_1997_JGR,eq.37]
km = 370 ; % in rad/m [Elfouhaily_1997_JGR,eq.24]
% km = 363 ; % in rad/m (code Bourlier)
a0 = log(2)/4 ; % [Elfouhaily_1997_JGR,eq.59]
ap = 4 ; % [Elfouhaily_1997_JGR,eq.59]
kk = 0.4 ;

% Relations:
k0 = g / u_10^2 ; % in rad/m
xmaj = k0 * fetch_m ; % dimensionless [Elfouhaily_1997_JGR,below-eq.4]
omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [Elfouhaily_1997_JGR,eq.37]
if isempty(fetch_m) % Case of infinite fetch => omgc = 0.84 (fully-developed sea) 
    omgc = 0.84 ; % fully-developed sea 
end
kp = k0 * omgc^2 ; % in rad/m [Elfouhaily_1997_JGR,below-eq.3]
%
C  = sqrt(g*(1+K.^2/km^2)./K ) ; % Phase speed in m/s [Fung_1982_JOE], [Elfouhaily_1997_JGR,eq.24]
cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
%
% C  = sqrt(g./K ) ; % Phase speed in m/s [...]
% cp = sqrt(g/kp ) ; % Phase speed at spectral peek
%
if isempty(u_f)
    cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
    z0 = 3.7e-5 * u_10^2/g * (u_10/cp)^0.9 ; % [Elfouhaily_1997_JGR,eq.66]
    u_f = kk / log(10/z0) * u_10 ; % [Elfouhaily_1997_JGR,eq.60]
    %
    % c_d10N = ( 0.8 + 0.065 * u_10 ) * 1e-3 ; % C. Bourlier -> [Elfouhaily_1997_JGR,eq.61]
    % u_f = sqrt( c_d10N ) * u_10 ; % C. Bourlier -> [Elfouhaily_1997_JGR,eq.61]
end
%
cm = sqrt(2*g/km) ; % = 0.23 m/s [Du_2017_RS,below_eq.9] 
am = 0.13*u_f/cm ; % [Elfouhaily_1997_JGR,eq.59]&[Du_2017_RS,eq.6] 
%
if strcmp(StrgMdl , 'El') 
    Dt_k = tanh( a0 + ap*(C/cp).^2.5 + am*(cm./C).^2.5 ) ; % [Elfouhaily_1997_JGR,eq.57]&[Du_2017_RS,eq.5] 
elseif strcmp(StrgMdl , 'Du') 
    K_x = K.^1.1 * cm^1.65 ; % [Du_2017_RS,below_eq.9] 
    S_d = tanh( u_f*K_x + g./(cp^2*K_x) - 20/cp*sqrt(g*u_f^2.55) + 2.55*u_f ) ; 
    a0 = -log(2)/4 ; % [Du_2017_RS,below_eq.7] -> opposite of that of Elfouhaily et al. 
    ad = +log(2)/2 ; % [Du_2017_RS,below_eq.7] 
    am = am * 2 ; % [Du_2017_RS,below_eq.9] 
    Dt_k = tanh( a0 + ad*S_d + ap*(C/cp).^2.5 + am*(cm./C).^2.5 ) ; % [Du_2017_RS,eq.7] 
else 
    error('Invalid input variable StrgMdl! Please double check.') ; 
end

% Surface height angular spreading function (ASF):
Phi_spr = 1/(2*pi) * ( 1 + Dt_k .* cos(2*Phi_d * pi/180) ) ;
