function [ Er_p , Er_s , Dt_m ] = f_SeaWaterPermittivity_Wentz( F_GHz , t_dcls , s_ppth ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SeaWaterPermittivity_Wentz
%--------------------------------------------------------------------------
% Calculates the sea water permittivity from a model function published by
% Ellison et al. [Wentz_2000_Report]
% Valid for:
% ...
%--------------------------------------------------------------------------
% Input variables:
% F_GHz : Frequency (GHz) [Vector/Matrix]
% t_dcls : Temperature in degrees Celsius [scalar] (typical: 15)
% s_ppth : Salinity in parts per thousand [scalar] (typical: 35)
%--------------------------------------------------------------------------
% Output variables:
% Er_p : Real      part of relative permittivity [Vector/Matrix]
% Er_s : Imaginary part of relative permittivity [Vector/Matrix]
% Dt_m : Skin depth (m) [Vector/Matrix]
%--------------------------------------------------------------------------
% COMMENTS:
% /!\ Chosen convention is that the imaginary part of epsilon is < 0 /!\
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 12/2015
%--------------------------------------------------------------------------

% Constants:
c_ms = 299792458 ; % Celerity of light in vacuum (m/s)

% Simple relationships:
F_Hz = F_GHz * 1e9 ; % Convert frequency from GHz to Hz 
t_S = t_dcls ; % water temperature in Celsius units [Wentz_2000_Report,below_eq.36]
s = s_ppth ; % salinity in parts per thousand [Wentz_2000_Report,below_eq.42]
Lb_cm = c_ms./F_Hz * 1e2 ; % radiation wavelength in cm

% Conductivity of seawater:
cmaj = 0.5536 * s ; % chlorinity in parts per thousand [Wentz_2000_Report,eq.41]
dt_t = 25 - t_S ; % [Wentz_2000_Report,eq.42]
zt = 2.03e-2 + 1.27e-4*dt_t + 2.46e-6*dt_t^2 - cmaj * ( 3.34e-5 - 4.60e-7*dt_t + 4.60e-8*dt_t^2 ) ; % [Wentz_2000_Report,eq.40]
sig = 3.39e9 * cmaj^0.892 * exp(-dt_t * zt) ; % [Wentz_2000_Report,eq.39]

% Static dielectric constant:
er_S0 = 87.90 * exp(-0.004585 * t_S) ; % very good fit for 0<=t_S<=40°C [Wentz_2000_Report,eq.36]
er_S = er_S0 * exp( -3.45e-3*s + 4.69e-6*s^2 + 1.36e-5*s*t_S ) ; % [Wentz_2000_Report,eq.43]

% Relaxation wavelength (cm):
lb_R0_cm = 3.30 * exp(-0.0346 * t_S + 0.00017 * t_S^2) ; % [Wentz_2000_Report,eq.38]
lb_R_cm = lb_R0_cm - 6.54e-3 * ( 1 - 3.06e-2*t_S + 2.0e-4*t_S^2 ) * s ; % [Wentz_2000_Report,eq.44]

% Real and imaginary parts of relative permittivity:
nn = 0.012 ; % [Wentz_2000_Report,above_eq.38]
er_inf = 4.44 ; % [Wentz_2000_Report,above_eq.38]
Er_cp = er_inf + (er_S - er_inf)./(1+(1j*lb_R_cm./Lb_cm).^(1-nn)) - 2*1j*sig*Lb_cm/(c_ms*1e2) ; % [Wentz_2000_Report,eq.35]
%
Er_p = real(Er_cp) ;
Er_s = imag(Er_cp) ;

% Determination of skin depth (m) [Pinel_2006_These,eq.1.20]:
c_ms = 299792458 ; % Celerity of light (m/s)
% Dt_m = 1 ./ (2*pi*F_Hz/c_ms .* -imag(sqrt(Er_cp)) ) ; 
Dt_m = 1 ./ (2*pi*F_Hz/c_ms .* abs(imag(sqrt(Er_cp))) ) ; 