function [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5NA (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5NA
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV polarization and in C band (5.3 GHz), with respect to the empirical 
% model of Hersbach et al. (JAOT 2010) "CMOD5.N", for incidence angles 18°-57°:
% - Th_i_d must be between 18°-57°
% - u10_ms must be between ...-... m/s
% - (winddir_d must be between 0°-360°
% and with correction by Verspeek et al. (TGRS 2012) in the angular range:
% - Th_i_d between 27.5°-36.6° 
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d        : incidence angle with respect to the vertical z (deg.) [Vector]
% u10_ms        : wind speed at 10 m above the sea surface (m/s) [scalar]
% windDir_d     : wind direction with respect to the incidence azimuth 
%                 direction, \phi-\phi0 (deg.) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_VV  : NRCS with respect to considered model in VV polarization [Vector - lin. scale]
% Nrcs_Mdl_HH  : NRCS with respect to considered model in HH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% Y. Quilfen B. Chapron T. Elfouhaily K. Katsaros J. Tournadre,
% "Observation of tropical cyclones by high resolution scatterometry",
% J. Geophys. Res. 103, pp. 7767-7786, 1998
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 07/2013
%--------------------------------------------------------------------------

% Applicability domain of the empirical/experimental model (CMOD5.N here):
It = find( Th_i_d < 18 | Th_i_d > 57 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    disp('/!\ 18° <= Th_i_d <= 58° /!\') ;
    pause(1) ;
end

% ci ([2010_Hersbach_JAOT,Tab.1]):

c01 = -0.6878 ; %±...
c02 = -0.7957 ; %±...
c03 =  0.3380 ; %±...
c04 = -0.1728 ; %±...
c05 =  0.0000 ; %±...
c06 =  0.0040 ; %±...
c07 =  0.1103 ; %±...
c08 =  0.0159 ; %±...
c09 =  6.7329 ; %±...
c10 =  2.7713 ; %±...
c11 = -2.2885 ; %±...
c12 =  0.4971 ; %±...
c13 = -0.7250 ; %±...
c14 =  0.0450 ; %±...
c15 =  0.0066 ; %±...
c16 =  0.3222 ; %±...
c17 =  0.0120 ; %±...
c18 =  22.700 ; %±...
c19 =  2.0813 ; %±...
c20 =  3.0000 ; %±...
c21 =  8.3659 ; %±...
c22 = -3.3428 ; %±...
c23 =  1.3236 ; %±...
c24 =  6.2437 ; %±...
c25 =  2.3893 ; %±...
c26 =  0.3249 ; %±...
c27 =  4.1590 ; %±...
c28 =  1.6930 ; %±...

p = 1.6 ; % ????????????????????????????????????????????????????????????
disp('/!\ VALEUR DE P A CONFIRMER /!\') ;

X = (Th_i_d-40)/25 ;

% Functions [2007_Hersbach_JGR,eq.A5-A6,A12]:
A_0 = c01 + c02 * X + c03 * X.^2 + c04 * X.^3 ;
A_1 = c05 + c06 * X ;
A_2 = c07 + c08 * X ;
Gmm = c09 + c10 * X + c11 * X.^2 ;
S_0 = c12 + c13 * X ;
Nu0 = c21 + c22 * X + c23 * X.^2 ;
D_1 = c24 + c25 * X + c26 * X.^2 ;
D_2 = c27 + c28 * X ;

% Calculation of B_0 term [2007_Hersbach_JGR,eq.A2]:
G_S0_ = 1 ./ (1 + exp(-S_0       )) ; % [2007_Hersbach_JGR,eq.A4]
G_A2v = 1 ./ (1 + exp(-A_2*u10_ms)) ; % [2007_Hersbach_JGR,eq.A4]
Al = S_0 .* (1 - G_S0_) ; % [2007_Hersbach_JGR,eq.A4]
F_A2v_S0 = S_0.^Al .* G_S0_ .* (A_2*u10_ms < S_0) + G_A2v .* (A_2*u10_ms >= S_0) ; % [2007_Hersbach_JGR,eq.A3]
%
B_0 = 10.^(A_0 + A_1*u10_ms) .* F_A2v_S0.^Gmm ; % [2007_Hersbach_JGR,eq.A2]

% Calculation of B_1 term [2007_Hersbach_JGR,eq.A7]:
TanhB1 = tanh(4 * (X+c16+c17*u10_ms)) ;
Num_B1 = c14 * (1+X) - c15*u10_ms * (0.5+X-TanhB1) ;
B_1 = Num_B1 ./ (1 + exp(0.34*(u10_ms-c18))) ;

% Calculation of B_2 term [2007_Hersbach_JGR,eq.A8]:
y0 = c19 ; n = c20 ; % [2007_Hersbach_JGR,eq.A10]
a = y0 - (y0-1)/n ; % [2007_Hersbach_JGR,eq.A11]
b = 1 / ( n * (y0-1)^(n-1) ) ; % [2007_Hersbach_JGR,eq.A11]
Y = (u10_ms + Nu0) ./ Nu0 ;
V_2 = ( a + b*(Y-1).^n ) .* (Y < y0) + Y .* (Y >= y0)  ;
%
B_2 = (-D_1 + D_2.*V_2) .* exp(-V_2) ;

% NRCS in linear scale :
Nrcs_Mdl_VV_0 = B_0 .* ( 1 + B_1 * cosd(1*windDir_d) + B_2 * cosd(2*windDir_d) ).^p ;


% Correction [Verspeek_2012_TGRS - EXPRESSED IN DB]: 
a0 =  5.7236425879 ; 
a1 = -0.4226930560 ; 
a2 =  0.0105605079 ;
a3 = -0.0000864832 ; 
B0_corr_dB = a0 + a1*Th_i_d + a2*Th_i_d.^2 + a3*Th_i_d.^3 ; % [Verspeek_2012_TGRS,eq.3] 
%
Nrcs_Mdl_VV = Nrcs_Mdl_VV_0 .* 10.^(B0_corr_dB/10) ; % [Verspeek_2012_TGRS,eq.3]+[Elyouncha_2015_SPIEProc,eq.6]  


Nrcs_Mdl_HH = zeros(size(Nrcs_Mdl_VV)) ;
%
Nrcs_Mdl_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Mdl_HH(It) = 0 ; % ou plutôt NaN
