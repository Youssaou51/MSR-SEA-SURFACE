function [Nrcs_Quil_VV, Nrcs_Quil_HH] = f_Nrcs_3dMono_EmpExpSea_Cband_Quilfen (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Cband_Quilfen
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV polarization and in C band (5.3 GHz), with respect to the empirical 
% model of Quilfen et al. (JGR 1998), for incidence angles 18°-60° ("CMOD_IFR2"):
% - Th_i_d must be between 18°-60°
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
% Nrcs_Quil_VV  : NRCS with respect to Quilfen exp. model ("CMOD_IFR2") in VV polarization [linear scale]
% Nrcs_Quil_HH  : NRCS with respect to Quilfen exp. model ("CMOD_IFR2") in HH polarization [linear scale]
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

% Applicability domain of Quilfen:
It = find( Th_i_d < 18 | Th_i_d > 60 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    disp('/!\ 18° <= Th_i_d <= 60° /!\') ;
    pause(1) ;
end
if u10_ms >= 20
    disp('Wind speed too high: it should be < 20 m/s...') ;
    return ;
end

% ci:
c1  = -2.437596 ;
c2  = -1.567030 ;
c3  =  0.3708242 ;
c4  = -0.040590 ;
c5  =  0.404678 ;
c6  =  0.188397 ;
c7  = -0.027262 ;
c8  =  0.064650 ;
c9  =  0.054500 ;
c10 =  0.086350 ;
c11 =  0.055100 ;
c12 = -0.058450 ;
c13 = -0.096100 ;
c14 =  0.412754 ;
c15 =  0.121785 ;
c16 = -0.024333 ;
c17 =  0.072163 ;
c18 = -0.062954 ;
c19 =  0.015958 ;
c20 = -0.069514 ;
c21 = -0.062945 ;
c22 =  0.035538 ;
c23 =  0.023049 ;
c24 =  0.074654 ;
c25 = -0.014713 ;

% Calculation of b0:
x  = ( Th_i_d - 36 ) / 19 ;
p1 = x ;
p2 =    ( 3*x.*x - 1 ) / 2. ;
p3 = x.*( 5*x.*x - 3 ) / 2. ;
%
a = c1 + c2 * p1 + c3 * p2 + c4 * p3 ;
b = c5 + c6 * p1 + c7 * p2 ;
%
vit = u10_ms ; 
b0  = a + b * sqrt(vit) ;

% Calculations of b1 and b2:
x1  = ( 2 * Th_i_d - 76) / 40. ;
p11 = x1 ;
p21 = (2 * x1 .* x1 - 1 ) ;
%
v1  = ( 2* vit - 28) / 22. ;
v2  = ( 2* v1 * v1 - 1 ) ;
v3  = ( 2*v2 - 1 ) * v1 ;
%
b1 = c8 + c9 * v1 + ( c10 + c11*v1 ) * p11 + ( c12 + c13*v1 ) * p21 ;    
b2 = c14 + c15*p11 + c16*p21 + ( c17 + c18*p11 + c19*p21 ) * v1 ;
b2 = b2 + ( c20 + c21*p11 + c22*p21 ) * v2 + ( c23 + c24*p11 + c25*p21 )* v3 ;

% Calculations of Sigma_0, Sigma_1, and Sigma_2:
SigmaV_0 = 10 .^ b0 ;
SigmaV_1 = SigmaV_0 .* b1 ;
SigmaV_2 = SigmaV_0 .* tanh(b2) ;

% NRCS in linear scale :
Nrcs_Quil_VV = SigmaV_0 + SigmaV_1 * cosd(1*windDir_d) + SigmaV_2 * cosd(2*windDir_d) ;
Nrcs_Quil_HH = zeros(size(Nrcs_Quil_VV)) ;
%
Nrcs_Quil_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Quil_HH(It) = 0 ; % ou plutôt NaN
