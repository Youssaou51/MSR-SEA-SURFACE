function [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5 (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV polarization and in C band (5.3 GHz), with respect to the empirical 
% model of Hersbach et al. (JGR 2007) "CMOD5", for incidence angles 18°-57°:
% - Th_i_d must be between 18°-57°
% - u10_ms must be between ...-... m/s
% - (winddir_d must be between 0°-360°
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
% H. Hersbach, A. Stoffelen, and S. de Haan,
% "An improved C-band scatterometer ocean geophysical model function: CMOD5",
% J. Geophys. Res., vol. 112, C03006 (18 pages), 2007
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 07/2013
%--------------------------------------------------------------------------

% Applicability domain of the empirical/experimental model (CMOD5 here):
It = find( Th_i_d < 18 | Th_i_d > 57 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    disp('/!\ 18° <= Th_i_d <= 58° /!\') ;
    pause(1) ;
end

% ci ([2007_Hersbach_JGR,Tab.A1]):

c01 = -0.688 ; %±0.010
c02 = -0.793 ; %±0.011
c03 =  0.338 ; %±0.013
c04 = -0.173 ; %±0.015
c05 =  0.0000 ; %±0.0002
c06 =  0.0040 ; %±0.0002
c07 =  0.111 ; %±0.0014
c08 =  0.0162 ; %±0.002
c09 =  6.34 ; %±0.02
c10 =  2.57 ; %±0.02
c11 = -2.18 ; %±0.03
c12 =  0.400 ; %±0.006
c13 = -0.60 ; %±0.02
c14 =  0.045 ; %±0.009
c15 =  0.007 ; %±0.002
c16 =  0.33 ; %±0.04
c17 =  0.012 ; %±0.002
c18 =  22.0 ; %±1.4
c19 =  1.95 ; %±0.02
c20 =  3.00 ; %±0.15
c21 =  8.39 ; %±0.17
c22 = -3.44 ; %±0.23
c23 =  1.36 ; %±0.3
c24 =  5.35 ; %±0.06
c25 =  1.99 ; %±0.08
c26 =  0.29 ; %±0.09
c27 =  3.80 ; %±0.03
c28 =  1.53 ; %±0.04

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
Nrcs_Mdl_VV = B_0 .* ( 1 + B_1 * cosd(1*windDir_d) + B_2 * cosd(2*windDir_d) ).^1.6 ;
Nrcs_Mdl_HH = zeros(size(Nrcs_Mdl_VV)) ;
%
Nrcs_Mdl_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Mdl_HH(It) = 0 ; % ou plutôt NaN
