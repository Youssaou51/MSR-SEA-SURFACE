%% Programme qui compare la NRCS entre ma version et celle de Matlab + celle de [Gregers-Hansen_2012_Report] 

clear variables ; clc ; close all ; 
format short ; format compact ; 
%
% addpath('D:\0-Matlab_Icam\FCTS') ; 
addpath(genpath(cd)) ;


%% NRL model - provided by Matlab (Radar Toolbox): 

GrazAng_d = [0.1 0.3 1.0 2:2:60 ] ; % Grazinng angle ([0:90] (default) | length-Q row vector) (deg.) 
freq    = 10e9 ; % Radar frequency ([0 1e20] (default) | length-R row vector) (Hz) 
lookangle_d = [] ; % Look angle with respect to wind direction (0 (default) | scalar) (deg.) 
seaSt = 6 ; % Sea state (1 (default) | nonnegative integer) (-) 
Pol = 'V' ; % Polarization ('H' (default) | 'V') 
NrcsModel = 'NRL' ; % Sea reflectivity model ('NRL' (default) | 'APL' | 'GIT' | 'Hybrid' | 'Masuko' | 'Nathanson' | 'RRE' | 'Sittrop' | 'TSC' | 'ConstantGamma') 
%
refl = surfaceReflectivitySea(Model=NrcsModel, SeaState=seaSt, Polarization=Pol) ; % Reflectivity parameters of sea surface 
nrcs = refl(GrazAng_d, freq) ; % Normalized Radar Cross Section (NRCS) (-) 
Nrcs_dB = pow2db(nrcs) ; % Convert power to decibels (-> 10*log10(...)) (dB) 


%% NRL model - provided by [Gregers-Hansen_2012_Report]: 

SigZ = NRL_SigmaSea(freq*1e-9,seaSt,Pol,GrazAng_d,lookangle_d) ; 


%% NRL model - my version: 

c_ms = 3e8 ; % Celerity of light in vacuum (m/s) 
c_ms = 299792458 ; % Celerity of light in vacuum (m/s) 
lb0_m = c_ms / freq ; % EM wavelength in vacuum (m) 
%
% Sig0_NRL_dB = f_Nrcs_3dMonoGrazing_NRL (GrazAng, lb0_m, seaSt, lookangle_d, Pol) ; 
Sig0_NRL_dB = f_Nrcs_3dMonoGrazing_NRL_2012 (GrazAng_d, lb0_m, seaSt, lookangle_d, Pol, c_ms) ; 


%% Comparison between the different versions: 

[ Nrcs_dB.' ; SigZ-Nrcs_dB.' ; Sig0_NRL_dB-Nrcs_dB.' ] 
