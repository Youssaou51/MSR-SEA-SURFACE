function [Sh_iso] = f_SpectrumSea_IsoFetch_DonelanPierson( u_10, K, fetch_m, u_f ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SpectrumSea_IsoFetch_DonelanPierson
%--------------------------------------------------------------------------
% Calculates the isotropic part of the sea surface height spectrum, 
% according to the model of Donelan&Pierson
% [Donelan_1987_JGR,Elfouhaily_1997_JGR]. 
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account. 
%--------------------------------------------------------------------------
% Input variables:
% u_10  : Wind speed at 10 m above the sea surface (m/s) [scalar]
% K     : Surface wavenumber (rad/m) [Vector]
% fetch_m : Fetch = length of action of wind on the sea (m) [scalar]
% u_f   : Wind speed at the sea surface = friction velocity (m/s) [scalar]
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
% Nicolas PINEL - PhD, 2026-04 
%--------------------------------------------------------------------------

% Constants:
g = 9.81 ; % Acceleration due to gravity (m/s^2)
km = 370 ; % in rad/m [Elfouhaily_1997_JGR,below-eq.13,eq.24]
nu_w = 1.220e-6 ; % Kinematic viscosity of water (@15°C):
% http://www.engineeringtoolbox.com/water-dynamic-kinematic-viscosity-d_596.html 
% http://www.kayelaby.npl.co.uk/general_physics/2_7/2_7_9.html
% http://ittc.sname.org/CD%202011/pdf%20Procedures%202011/7.5-02-01-03.pdf
rho_a = 1.22 ; % Volume density of air (kg/m^3) - @15°C - http://en.wikipedia.org/wiki/Density_of_air
rho_w = 1026 ; % Volume density of seawater (kg/m^3) - @15°C - http://ittc.sname.org/CD%202011/pdf%20Procedures%202011/7.5-02-01-03.pdf
lna1 = 22 ; % [Elfouhaily_1997_JGR,eq.13] 
lna2 = 4.6 ; % [Elfouhaily_1997_JGR,eq.13] 
b = 3 ; % [Elfouhaily_1997_JGR,eq.13] 
n1 = 5 ; % [Elfouhaily_1997_JGR,eq.12] 
n2 = 1.15 ; % [Elfouhaily_1997_JGR,eq.12] 

% General relations:
k0 = g / u_10^2 ; % in rad/m [Elfouhaily_1997_JGR,below-eq.3]
xmaj = k0 * fetch_m ; % dimensionless [Elfouhaily_1997_JGR,below-eq.4]
omgc = 11.6 * xmaj^-0.23 ; % [Elfouhaily_1997_JGR,eq.4]
if (omgc < 0.84) % This should not happen 
    warning('omgc should be >= 084, but it is here equal to: %.2f',omgc) ; 
    omgc = 0.84 ;
end
kp = k0 * omgc^2 ; % in rad/m [Elfouhaily_1997_JGR,below-eq.3]
%
Ck = sqrt(g*(1+K.^2/km^2)./K ) ; % Phase speed in m/s [1982_Fung_JOE], [Elfouhaily_1997_JGR,eq.24]
cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
%
% C  = sqrt(g./K ) ; % Phase speed in m/s [...]
% cp = sqrt(g/kp ) ; % Phase speed at spectral peek

% Relations for long-wave (low-frequency) spectrum:
% if (0.84<=omgc) && (omgc<=5)
    alphp = 6e-3 * omgc^0.55 ; % [Elfouhaily_1997_JGR,below-eq.3]
% end
%
if (omgc<=1) % if (0.84<=omgc) && (omgc<=1) 
    gm = 1.7 ;
else % elseif (1<omgc) && (omgc<=5) 
    gm = 1.7 + 6*log10(omgc) ;
%     if (omgc>5)
%         disp('/!\ \Omega_c > 5 /!\') ;
%     end
end
sgm = 0.08 * (1 + 4*omgc^-3) ; % [Elfouhaily_1997_JGR,below_eq.3] 

% Parameters:
L_PM = exp( -5/4 * (kp./K).^2 ) ; % [Elfouhaily_1997_JGR,eq.2]
J_p = gm .^ exp( -(sqrt(K/kp)-1).^2 / (2*sgm^2) ) ; % [Elfouhaily_1997_JGR,below_eq.3] 

% Long-wave (low-frequency) curvature spectrum [Elfouhaily_1997_JGR,eq.1]:
B_l = 1/2 * alphp * L_PM .* J_p .* sqrt(K/kp) ; % [Elfouhaily_1997_JGR,eq.1]


% Relations for short-wave (high-frequency) spectrum:
D_omg = 4*nu_w*K.^2 ./ (Ck.*K) ; % D over omega [Elfouhaily_1997_JGR,eq.below-10]
%
N = (n1-n2) * abs((K.^2-km^2)./(K.^2+km^2)).^b + n2 ; % [Elfouhaily_1997_JGR,eq.12]
%
Alph = exp( (lna1-lna2) * abs((K.^2-km^2)./(K.^2+km^2)).^b + lna2 ) ; % [Elfouhaily_1997_JGR,eq.13]


% Wind speed at the height pi/K [Elfouhaily_1997_JGR,eq.60]: 
kk = 0.40 ; 
z0 = 3.7e-5 * u_10^2/g * (u_10/cp)^0.9 ; % [Elfouhaily_1997_JGR,eq.66] 
if isempty(u_f)
    u_f = kk / log(10/z0) * u_10 ; % [Elfouhaily_1997_JGR,eq.60]
    %
    % Estimation of u_f by assuming neutral stability condition: 
    % c_d10N = ( 0.8 + 0.065 * u_10 ) * 1e-3 ; % C. Bourlier -> [Elfouhaily_1997_JGR,eq.61]
    % u_f = sqrt( c_d10N ) * u_10 ; % C. Bourlier -> [Elfouhaily_1997_JGR,eq.61]
end
U_pik = u_f/kk * log((pi./K)/z0) ; % [Elfouhaily_1997_JGR,eq.60] 

% beta over omega, with phi=0 [Elfouhaily_1997_JGR,eq.16]: 
Bt_omg = 0.194*rho_a/rho_w * (U_pik*cos(0)./Ck - 1).^2 ; 

% phi_max = max(Bt_omg) ; % = ??? "is the maximum of the applied spreading function" 
phi_max = 0.25 ; % = ??? "is the maximum of the applied spreading function" 

% Short-wave (high-frequency) curvature spectrum [Elfouhaily_1997_JGR,eq.17]:
B_h = 1/phi_max * (abs( (Bt_omg-D_omg)./Alph) ).^(1./N) ; 

% Isotropic spectrum [Elfouhaily_1997_JGR,eq.18]: 
Sh_iso = K.^-3 .* ( B_l.*(K<=10*kp) + B_h.*(K> 10*kp) ) ; 

warning('To be validated <-> phi_max = ?. May be done by comparison with [Bourlier_1999_These,chap.I]') ; 
