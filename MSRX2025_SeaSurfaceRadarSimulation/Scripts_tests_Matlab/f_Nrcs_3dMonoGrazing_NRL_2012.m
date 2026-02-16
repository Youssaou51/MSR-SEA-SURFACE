function Sig0_NRL_dB = f_Nrcs_3dMonoGrazing_NRL_2012 (GrazAng_d, lb0_m, seaSt, windDir_d, Polar, c_ms)

%--------------------------------------------------------------------------
% FUNCTION: f_Nrcs_3dMonoGrazing_NRL_2012
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in HH or VV polarization, with respect to the empirical model of a
% the NRL Laboratory, for GRAZING angles 00.1°-60.0° and RF frequencies 
% 00.5-35.0 GHz: 
% - GrazAng_d must be between 00.1°-60.0° 
% - seaSt must be between 0-6 (integer value) 
% - f_GHz must be between 00.5-35.0 GHz 
% - (independent of winddir_d (!)) 
% [Gregers-Hansen_2012_Report]
%--------------------------------------------------------------------------
% Input variables:
% GrazAng_d : Grazing angle (deg.) [Vector] 
% lb0_m     : EM wavelength in vacuum (m) [scalar] 
% seaSt     : Sea state - Beaufort scale (-) [scalar] 
% windDir_d : wind direction with respect to the incidence azimuth 
%             direction, \phi-\phi0 (deg.) [scalar] 
% Polar     : Radar polarization ('H' or 'V') [char] 
% c_ms      : Celerity of light in vacuum (m/s) [scalar] (OPTIONAL) 
%--------------------------------------------------------------------------
% Output variables:
% Sig0_NRL_dB    : NRCS sigma0 (dB)
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% NB1 : This model does not depend on (-> does not handle) wind direction! 
% NB2 : Celerity of light in vaccum is usually taken as 3e8 even if, more
% precisely, it is 299792458 
% From NRL, 2012 version: 
% V. Gregers-Hansen, R. Mital, "An Improved Empirical Model for Radar Sea
% Clutter Reflectivity", Report, NRL/MR/5310--12-9346, 27 April 2012. 
% (see also [Gregers-Hansen_2012_TAES]) 
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, Icam Ouest / IETR, 2025-07 
%--------------------------------------------------------------------------


%% Simple checks and calculation of radar frequency: 

if isempty(c_ms) 
    c_ms = 3e8 ; % Celerity of light in vacuum (m/s) 
    % c_ms = 299792458 ; % Celerity of light in vacuum (m/s) 
end 
% 
if any( (GrazAng_d < 00.1) | (GrazAng_d > 60.0) ) 
    warning('The grazing angle should be between 00.1° and 60.0° (it is the range of data used)') ; 
end
%
if (seaSt < 0) || (seaSt > 6) 
    warning('The sea state should be between 0 and 6 (it is the range of data used)') ; 
end 
if mod(seaSt,1) 
    error('The sea state must be an integer') ; 
end 
% 
f_GHz = c_ms / lb0_m / 1e9 ; % Radar frequency (GHz) 
if (f_GHz < 00.5) || (f_GHz > 35.0) 
    warning('The radar frequency should be between 00.5 GHz and 35.0 GHz (it is the range of data used)') ; 
end


%% Constants used in empirical sea clutter model: 

if strcmp(Polar , 'H') 
    c1 = -73.00 ; 
    c2 = 20.781 ; % c2 = 20.78 ; 
    c3 = 7.351 ; 
    c4 = 25.65 ; 
    c5 = 0.00540 ; 
elseif strcmp(Polar , 'V') 
    c1 = -50.796 ; % c1 = -50.79 ; 
    c2 = 25.93 ; 
    c3 = 0.7093 ; 
    c4 = 21.588 ; % c4 = 21.58 ; 
    c5 = 0.00211 ; 
else 
    error('Impossible polarization parameter! Choose between ''H'' and ''V''') ; 
end


%% Calculation of NRCS sigma0 according to NRL model in 2012: 

Sig0_NRL_dB = c1 + c2 * log10(sind(GrazAng_d)) + (27.5+c3*GrazAng_d)*log10(f_GHz)./(1+0.95*GrazAng_d) ...
    + c4*(1+seaSt).^(1./(2+0.085*GrazAng_d+0.033*seaSt)) + c5 * GrazAng_d.^2 ; 
