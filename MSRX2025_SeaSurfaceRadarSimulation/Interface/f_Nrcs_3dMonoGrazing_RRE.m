function Sig0_RRE_dB = f_Nrcs_3dMonoGrazing_RRE (Chi_d, lambda_m, seaState, ph__d, polar) 

%--------------------------------------------------------------------------
% FUNCTION: f_Nrcs_3dMonoGrazing_RRE 
%--------------------------------------------------------------------------
% Calculates the monostatic NRCS of sea surfaces for 3D problems, according
% to the empirical GMF (Geophysical Model Function) model called RRE (Royal
% Radar Establishment model) [Ward_2013_IET] 
% Valid for (0.1° <) Chi_d < 10°, sea states 1-6 and both HH and VV pol.
% and  9 < f_GHz < 10 [Rosenberg_2022_IET,Tab.4.1] 
%--------------------------------------------------------------------------
% Input variables: 
% Chi_d     : GRAZING (incidence) angle (deg.) [Vector] 
% lambda_m  : EM wavelength (m) [scalar] 
% seaState  : Sea state [Beaufort scale] [scalar] 
% ph__d     : Angle between LOS and wind direction (deg.) [scalar] 
% polar     : 'H' or 'V'
%--------------------------------------------------------------------------
% Output variables:
% Sig0_RRE_dB : NRCS sigma0 in given pol. (dB)
%--------------------------------------------------------------------------
% COMMENTS:
% Taken from [Rosenberg_2022_IET,chap.4] 
%--------------------------------------------------------------------------
% Called functions:
% (none) 
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 09/2025 
%--------------------------------------------------------------------------


%% Checks on regions of validity: 

c_ms = 3e8 ; % Celerity of light in vacuum (m/s) - approximate value (299792458) 
f_GHz = c_ms / lambda_m * 1e-9 ; 
if f_GHz < 9 || f_GHz > 10 % [Rosenberg_2022_IET,Tab.4.1] 
    warning('RRE model valid only for X band') ; 
end
%
if find(Chi_d < 0.1 | Chi_d > 10) % [Rosenberg_2022_IET,Tab.4.1] 
    warning('RRE model valid only for grazing angles 0.1° <= \chi <= 10°') ; 
end
%
if seaState < 1 || seaState > 6 % [Rosenberg_2022_IET,Tab.4.1] 
    error('RRE model valid only for sea states 1 <= ss <= 6') ; 
end
%
if find(rem(seaState,1)) 
    error('RRE model valid only for integer values of sea states') ; 
end
%
if numel(ph__d)>1 || numel(polar)>1 || numel(seaState)>1 
    error('Vector: not handled by this code version, sorry') ; 
end


%% RRE mean backscatter model coefficients [Rosenberg_2022_IET,Tab.4.1]: 

A_RRE_HH = [   -52  -46  -42  -39  -37 -35.5 ] ; 
B_RRE_HH = [    21 17.5 12.5 10.5    7   3.5 ] ; 
C_RRE_HH = [ 1.015 3.39 2.03 1.35 2.03  2.37 ] ; 
%
A_RRE_VV = [ -51.5 -45.5  -41 -38.5 -36 -34.5 ] ; 
B_RRE_VV = [    15    12 11.5    11 9.5     8 ] ; 
C_RRE_VV = [   8.2   9.5    8   7.5   7   6.5 ] ; 


%% NRCS model [Rosenberg_2022_IET,eq.4.2]: 

Ith01 = Chi_d >= 0.1 & Chi_d <= 01 ; 
Ith10 = Chi_d >   01 & Chi_d <= 10 ; 
%
if polar == 'H' 
    aRRE = A_RRE_HH(seaState) ; 
    bRRE = B_RRE_HH(seaState) ; 
    cRRE = C_RRE_HH(seaState) ; 
elseif polar == 'V' 
    aRRE = A_RRE_VV(seaState) ; 
    bRRE = B_RRE_VV(seaState) ; 
    cRRE = C_RRE_VV(seaState) ; 
else
    error('polar must be either "V" or "H"') ; 
end
%
Sig0_RRE_dB(Ith01) = aRRE + bRRE * log10(Chi_d(Ith01)) ; 
Sig0_RRE_dB(Ith10) = aRRE + cRRE * log10(Chi_d(Ith10)) ; 
