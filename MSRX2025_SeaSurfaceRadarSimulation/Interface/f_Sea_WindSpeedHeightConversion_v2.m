function [Uz_ms, Uz_NSA_ms, U_f, U_f_NSA] = f_Sea_WindSpeedHeightConversion_v2 (U10_ms, z_m, fetch_m) 

%--------------------------------------------------------------------------
% FUNCTION: f_Sea_WindSpeedHeightConversion 
%--------------------------------------------------------------------------
% Calculates the wind speed above the sea surface at a given height, given
% the value of the wind speed at 10 m. It takes the fetch (in m) into 
% account. It seems to be valid mainly (only?) for 1 <= U10 <= 20 m/s. 
% This models is based on the following paper [1997_Elfouhaily_JGR]: 
% T. Elfouhaily et al., "A unified directional spectrum for long and short 
% wind-driven waves", Journal of Geophysical Research, vol. 102, pp. 
% 15,781-15,796, pp. 1997. 
%--------------------------------------------------------------------------
% Input variables: 
% U10_ms    : Wind speed at 10 m above the sea surface (m/s) [Vector] 
% z_m       : Height at which to evaluate the wind speed (m) [scalar] 
% fetch_m   : Fetch = length of action of wind on the sea (m) [scalar] 
%--------------------------------------------------------------------------
% Output variables:
% Uz_ms     : Wind speed at z_m above the sea surface (m/s) [Vector] 
% Uz_NSA_ms : Approximate calculation of uz_ms under NSA (m/s) [Vector] 
% U_f       : Wind friction (wind at the sea surface) (m/s) [Vector] 
% U_f_NSA   : Approximate calculation of U_f under NSA (m/s) [Vector] 
%--------------------------------------------------------------------------
% COMMENTS:
% Deduced from f_SpectreMer_IsoFetch_Elfouhaily.m [1997_Elfouhaily_JGR] 
%--------------------------------------------------------------------------
% Called functions:
% (none) 
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 10/2025 
%--------------------------------------------------------------------------

if ~isempty( find(U10_ms < 1 | U10_ms > 20, 1 ) ) 
    warning('u_10 should be in the range 1-20 m/s') ; 
end

% Constants:
g = 9.81 ; % acceleration due to gravity (m/s^2)
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]
km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24]
% km = 363 ; % in rad/m (code Bourlier)

% General relations:
K0 = g ./ U10_ms.^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3] 
if ~isempty(fetch_m) 
    Xmaj = K0 * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4]
    Omgc = 0.84 * tanh( (Xmaj/x0).^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37]
else
    Omgc = 0.84 ; % [1997_Elfouhaily_JGR,eq.37]
end
Kp = K0 .* Omgc.^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
%
Cp = sqrt(g*(1+Kp.^2/km^2) ./ Kp ) ; % Phase speed at spectral peek
%
Z0 = 3.7e-5 * U10_ms.^2/g .* (U10_ms./Cp).^0.9 ; % [1997_Elfouhaily_JGR,eq.66] - /!\ model of Donelan et al., 1993 /!\ 
Z0(U10_ms==0) = 0 ; 
kk = 0.40 ; 
U_f = kk ./ log(10./Z0) .* U10_ms ; % [1997_Elfouhaily_JGR,eq.60][Ulaby_2014_Book,eq.16.3]
% Z0_uf = 0.684./(U_f*1e2) + 4.28e-5*(U_f*1e2).^2 - 4.43e-2 ; % [Bourlier_1999_These,eq.I.55,Ulaby_1986_BookVolIII] 
%
% Approximate calculcation under NSA (Neutral Stability Assumption): 
C_d10N = ( 0.8 + 0.065 * U10_ms ) * 1e-3 ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61]
U_f_NSA = sqrt( C_d10N ) .* U10_ms ; % C. Bourlier -> [1997_Elfouhaily_JGR,eq.61][Ulaby_2014_Book,eq.16.7]

% Wind speed at height z_m: 
% Uz_ms     = U_f    /kk .* log(z_m./Z0) ; % [1997_Elfouhaily_JGR,eq.60] 
Uz_ms  = U10_ms .* log(z_m./Z0)./log(10./Z0) ; % [1997_Elfouhaily_JGR,eq.60] 
Uz_NSA_ms = U_f_NSA/kk .* log(z_m./Z0) ; % [1997_Elfouhaily_JGR,eq.60] 
Uz_ms(U10_ms==0) = 0 ; 
Uz_NSA_ms(U10_ms==0) = 0 ; 

% Check on conditions of applicability of [1997_Elfouhaily_JGR,eq.60]: 
v = 14e-6 ; % [1997_Elfouhaily_JGR,eq.62] 
Dt_v_NSA = v ./ U_f_NSA ; 
if ~isempty( find(z_m < 10 * Dt_v_NSA, 1 ) ) 
    warning('z_m should be much greater than Dt_v_NSA') ; 
end
