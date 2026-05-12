function [Sh_iso] = f_SpectrumSea_IsoFetch_Apel( u_10, K, fetch_m ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SpectrumSea_IsoFetch_Apel
%--------------------------------------------------------------------------
% Calculates the isotropic part of the sea surface height spectrum, 
% according to the model of Apel [Apel_1994_JGR,Elfouhaily_1997_JGR]. 
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account. 
%--------------------------------------------------------------------------
% Input variables:
% u_10  : Wind speed at 10 m above the sea surface (m/s) [scalar]
% K     : Surface wavenumber (rad/m) [Vector]
% fetch_m : Fetch = length of action of wind on the sea (m) [scalar]
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
amin = 0.8 ; % [Elfouhaily_1997_JGR,eq.21] 
amaj = 1.95e-3 ; % spectral constant [Elfouhaily_1997_JGR,below-eq.19]
kres = 400 ; % [Elfouhaily_1997_JGR,eq.21] 
kw = 450 ; % (rad/m) % [Elfouhaily_1997_JGR,eq.21] 
kdis = 6283 ; % (rad/m) % [Elfouhaily_1997_JGR,eq.22] 

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
% Ck = sqrt(g*(1+K.^2/km^2)./K ) ; % Phase speed in m/s [1982_Fung_JOE], [Elfouhaily_1997_JGR,eq.24]
% cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
% %
% % C  = sqrt(g./K ) ; % Phase speed in m/s [...]
% % cp = sqrt(g/kp ) ; % Phase speed at spectral peek

% Relations:
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
L_PM = exp(-5/4 * (kp./K).^2) ; % [Elfouhaily_1997_JGR,eq.2]
J_p = gm .^ exp( -(sqrt(K/kp)-1).^2 / (2*sgm^2))  ; % [Elfouhaily_1997_JGR,eq.3]
%
% s: "Curvature level of an assumed secondary gravity peak at 750 rad/m wavenumber" [Elfouhaily_1997_JGR,eq.20]: 
log_s = -4.95 + 3.45 * ( 1 - exp(-u_10/4.7) ) ; % It is probably log10, because see eq.13 
s = 10^(log_s) ; % should be OK, because log10(s) = log_s 
%
Rres = amin*K .* sech( (K-kres) / kw ) ; % [Elfouhaily_1997_JGR,eq.21]
Vdis = exp( -(K/kdis).^2 ) ; % [Elfouhaily_1997_JGR,eq.22]
%
Phi_s = (0.28 + 10*(kp./K).^1.3).^-0.5 ; % [Elfouhaily_1997_JGR,eq.23]
I_D = 1/sqrt(2*pi) * Phi_s .* erf( pi./(Phi_s*sqrt(2)) ) ; % [Elfouhaily_1997_JGR,eq.23]
%
R_ro = 1 ./ (1 + (K/100).^2) ; % [1994_Apel_JGR,eq.16]

% Isotropic spectrum:
Sh_iso = amaj*K.^-3 .* L_PM .* J_p .* (R_ro + s*Rres) .* Vdis .* I_D ; % [Elfouhaily_1997_JGR,eq.19]

warning('To be validated. May be done by comparison with [Bourlier_1999_These,chap.I]') ; 
