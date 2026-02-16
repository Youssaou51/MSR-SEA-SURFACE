function [ ErSea_cp , omg , K_EM , Kc_TSM ] = f_Sea_ErOmg ( F_Hz , sst , sss , u_10 , fetch_m , k0SurKc_TSM ) 

%--------------------------------------------------------------------------
% FUNCTION: f_Sea_ErOmg
%--------------------------------------------------------------------------
% Calculates the sea water permittivity from a model function published by
% [Wentz_2000_Report] 
%--------------------------------------------------------------------------
% Input variables:
% F_Hz : Frequency (Hz) [Vector/Matrix]
% sst : Sea surface temperature in degrees Celsius [scalar] (typical: 15)
% sss : Sea surface salinity in parts per thousand [scalar] (typical: 35)
%--------------------------------------------------------------------------
% Output variables:
% ErSea_cp : Complex relative permittivity of seawater [Vector/Matrix] 
% omg      : Inverse wave age (-) [scalar] 
% K_EM     : Electromagnetic wavenumber (rad/m) [Vector/Matrix] 
% Kc_TSM   : Cutoff EM wavenumber between large/small scales (rad/m) [Vector/Matrix]
%--------------------------------------------------------------------------
% COMMENTS:
% Chosen convention is that the imaginary part of epsilon is > 0 
%--------------------------------------------------------------------------
% Called functions:
% f_SeaWaterPermittivity_Wentz 
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 2025-11 
%--------------------------------------------------------------------------


%% Electromagnetic calculations: 

[ Er_p , Er_s , ~ ] = f_SeaWaterPermittivity_Wentz( F_Hz*1e-9 , sst , sss ) ; 
ErSea_cp = Er_p + 1i * abs(Er_s) ; % Combine real and imaginary parts to get complex permittivity 

c_ms = 299792458 ; % Celerity of light (m/s)
%
K_EM = 2*pi * F_Hz / c_ms ; % EM wavenumber in vacuum 
%
if isempty(k0SurKc_TSM) 
    k0SurKc_TSM = 4 ; 
end
Kc_TSM = K_EM / k0SurKc_TSM ;


%% Hydrodynamic calculations: 

% Constants: 
g = 9.81 ; % acceleration due to gravity (m/s^2) 
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37] 
km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24] 
% km = 363 ; % in rad/m (code Bourlier) 

% General relationships: 
k0 = g / u_10^2 ; % in rad/m 
xmaj = k0 * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4] 
omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37] 
kp = k0 * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
%
cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek
%
omg = u_10 / cp ; % Inverse wave age (=0.84 at infinite fetch) 
