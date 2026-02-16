function [Nrcs_Bent_VV, Nrcs_Bent_HH] = f_Nrcs_3dMono_EmpExpSea_Cband_Cmod2I3 (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Cband_Cmod2I3
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV polarization and in C band (5.3 GHz), with respect to the empirical 
% model of Bentamy et al. (TGRS 1999), for incidence angles 18°-57° ("CMOD2-I3"):
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
% Nrcs_Bent_VV  : NRCS with respect to Bentamy exp. model ("CMOD2-I3") in VV polarization [linear scale]
% Nrcs_Bent_HH  : NRCS with respect to Bentamy exp. model ("CMOD2-I3") in HH polarization [linear scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% A. Bentamy P. Queffeulou Y. Quilfen K. Katsaros, 
% "Ocean surface wind fields estimated from satellite active and passive
% microwave instruments",
% IEEE Trans. Geosci. Remote Sens., vol. 37, pp. 2469-86, 1999
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 07/2013
%--------------------------------------------------------------------------

% Applicability domain of Bentamy:
It = find( Th_i_d < 18 | Th_i_d > 57 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    disp('/!\ 18° <= Th_i_d <= 57° /!\') ;
    pause(1) ;
end

% See Appendix A of [1999_Bentamy_TGRS] (CMOD2-I3,Ifremer):
% Constants C_1 and C_2
C_1(:,1) =  [ 0.2586/4 0.1727/2 -0.1169/2 ]' ;
C_1(:,2) =  [ 0.1090/2 0.0551   -0.0961   ]' ;
%
C_2(1,:) =  [ 1.6510/4    0.1443/2 -0.1390/2  -0.04609/2 ] ;
C_2(2,:) =  [ 0.243569/2 -0.062954 -0.062954   0.074654  ] ;
C_2(3,:) =  [-0.048667/2  0.015958  0.035538  -0.014713  ]  ;

% Calculations of alpha, beta, delta and B0
c1  = -2.364211 ; c2  = -1.572398 ; c3  =  0.442234 ;
c4  = -0.083145 ; c5  =  0.384930 ; c6  =  0.171090 ;
c7  = -0.033017 ; c8  =  0.0831   ; c9  = -0.0173 ;
c10 = -0.0009 ;
%
X = ( Th_i_d - 36 ) / 19 ;
P0 = 1 ;
P1 = X ;
P2 = ( 3 * X.^2 - 1 )      / 2 ;
P3 = ( 5 * X.^2 - 3 ) .* X / 2 ;
%
alpha = c1 + c2 * P1 + c3 * P2 + c4 * P3 ;
beta  = c5 + c6 * P1 + c7 * P2 ;
%
poly3 = c8 * u10_ms + c9 * u10_ms^2 + c10 * u10_ms^3 ;
betai = betainc( u10_ms/40 , 8 , 10 ) ; % incomplete beta function
delta = poly3 * ( 1 - betai ) + 3.5 * betai^2 ;
%
B0 = 10 .^ ( alpha + beta * sqrt( u10_ms - delta ) ) ;

% Calculations of B1, B2, B3
v_min = 3  ; v_max = 25 ;
t_min = 18 ; t_max = 58 ;
%
t_n = ( 2 * Th_i_d - (t_min+t_max) ) / (t_max-t_min) ;
v_n = ( 2 * u10_ms - (v_min+v_max) ) / (v_max-v_min) ; 
%
T_t(1,:) = ones( size(t_n) ) ;
T_t(2,:) = t_n ;
T_t(3,:) = 2 * t_n .* T_t(2,:) - T_t(1,:) ;
%
T_v(1) = 1 ;
T_v(2) = v_n ;
T_v(3) = 2 * v_n * T_v(2) - T_v(1) ;
T_v(4) = 2 * v_n * T_v(3) - T_v(2) ;
%
B1 = 0 ; B3 = 0 ;
%
for i = 1 : 1 : 3
	for j = 1 : 1 : 2
		Ans1 = C_1(i,j) * T_v(j) * T_t(i,:) ;
 		B1 = B1 + Ans1 ;
	end
end
%
for i = 1 : 1 : 3
	for j = 1 : 1 : 4	
		Ans3 = C_2(i,j) * T_v(j) * T_t(i,:) ;
 		B3 = B3 + Ans3 ;
	end
end
%
B2 = tanh( B3 ) ;

% Calculations of Sigma_i
SigmaV_0 = B0 ;
SigmaV_1 = B0 .* B1 ;
SigmaV_2 = B0 .* B2 ;

% NRCS in linear scale :
Nrcs_Bent_VV = SigmaV_0 + SigmaV_1 * cosd(1*windDir_d) + SigmaV_2 * cosd(2*windDir_d) ;
Nrcs_Bent_HH = zeros(size(Nrcs_Bent_VV)) ;
%
Nrcs_Bent_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Bent_HH(It) = 0 ; % ou plutôt NaN
