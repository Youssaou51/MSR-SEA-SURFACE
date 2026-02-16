function Sigma0 = f_calc_sigma0_cmod5_n_NPi(v_ms, phi_d, Theta_d)

%--------------------------------------------------------------------------
%  CMOD5_N* - GEOPHYSICAL MODEL FUNCTION FOR THE ERS AND ASCAT C-BAND SCATTEROMETERS
%
%     A. STOFFELEN              MAY  1991 ECMWF  CMOD4
%     A. STOFFELEN, S. DE HAAN  DEC  2001 KNMI   CMOD5 PROTOTYPE
%     H. HERSBACH               JUNE 2002 ECMWF  COMPLETE REVISION
%     J. de Kloe                JULI 2003 KNMI,  rewritten in fortan90
%     A. Verhoef                JAN  2008 KNMI,  CMOD5 for neutral winds
%
%   PURPOSE
%     -------
%     SIMULATION OF BACKSCATTER GIVEN A WIND VECTOR AND ICIDENCE ANGLE.
%     CMOD5_N IS TO BE USED IN AN INVERSION ROUTINE IN ORDER TO OBTAIN
%     WIND VECTORS FROM BACKSCATTER TRIPLETS.
%--------------------------------------------------------------------------
% Inputs:
% v_ms   : Wind velocity (always >= 0) (m/s) [scalar] 
% phi_d  : Angle between azimuth and wind direction (deg.) [scalar] 
% Theta_d: Incidence angle (deg.) [Vector] 
%--------------------------------------------------------------------------
% Output(s):
% Sigma0 : coefficient de rétrodiffusion (linéaire) [Vector] 
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% %--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% https://scatterometer.knmi.nl/cmod5/ 
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 2025-12 
%--------------------------------------------------------------------------

dtor   = 57.29577951 ; 
thetaM_d  = 40.0 ; 
thetaR_d = 25.0 ; 
zPow   = 1.6 ; 

% Coefficients obtained from Hans Hersbach by Email on 5 Feb 2008 [Hersbach_2010_JAOT,Tab.1]
C = [-0.6878, -0.7957,  0.3380, -0.1728, 0.0000,  0.0040, 0.1103, ...
      0.0159,  6.7329,  2.7713, -2.2885, 0.4971, -0.7250, 0.0450, ...
      0.0066,  0.3222,  0.0120, 22.7000, 2.0813,  3.0000, 8.3659, ...
     -3.3428,  1.3236,  6.2437,  2.3893, 0.3249,  4.1590, 1.6930] ;

y0 = C(19) ; % [Hersbach_2007_JGR,eq.A10] 
pn = C(20) ; % [Hersbach_2007_JGR,eq.A10] 
a  = C(19) - (C(19)-1)/C(20) ;
b  = 1/(C(20)*(C(19)-1)^(3-1)) ;

% Angles
fi   = phi_d / dtor ;
cosFi = cos(fi) ;
cs2Fi = 2.0 * cosFi.^2 - 1.0 ;

X  = (Theta_d - thetaM_d) / thetaR_d ; 
% XX = X.^2 ;

% B0: FUNCTION OF WIND SPEED AND INCIDENCE ANGLE [Hersbach_2007_JGR,eq.A5-A6,A12] 
A0 = C(1) + C(2)*X + C(3)*X.^2 + C(4)*X.^3 ;
A1 = C(5) + C(6)*X ;
A2 = C(7) + C(8)*X ;
Gam = C(9) + C(10)*X + C(11)*X.^2 ;
S0 = C(12) + C(13)*X ;
S = A2 .* v_ms ;
A3 = 1./(1 + exp(-max(S,S0))) ; % A3 = 1./(1 + exp(-S)) ;
% if S < S0
if ~isempty(find(S < S0, 1)) 
    % S < S0 
    A3(S<S0) = A3(S<S0) .* (S(S<S0)./S0(S<S0)).^( S0(S<S0).*(1 - A3(S<S0)) ) ;
    % A3(S<S0) = A3(S<S0) .* (S0(S<S0)).^( S0(S<S0).*(1 - A3(S<S0)) ) ;
end
B0 = (A3.^Gam) .* 10.^(A0 + A1.*v_ms) ; %B0_dB = 10*log10(B0) 

% B1: FUNCTION OF WIND SPEED AND INCIDENCE ANGLE
B1 = C(15)*v_ms.*(0.5 + X - tanh(4*(X + C(16) + C(17)*v_ms))) ;
B1 = C(14)*(1 + X) - B1 ;
B1 = B1 ./ (exp(0.34*(v_ms - C(18))) + 1) ;

% B2: FUNCTION OF WIND SPEED AND INCIDENCE ANGLE
V0 = C(21) + C(22)*X + C(23)*X.^2 ;
D1 = C(24) + C(25)*X + C(26)*X.^2 ;
D2 = C(27) + C(28)*X ;
V2 = (v_ms ./ V0 + 1) ;
% if V2 < y0
% V2 = a + b*(V2 - 1).^pn ;
if ~isempty(find(V2 < y0, 1)) 
    % V2 < y0 
    V2(V2<y0) = a + b*(V2(V2<y0) - 1).^pn ;
end
B2 = (-D1 + D2.*V2).*exp(-V2) ;

% COMBINE THE THREE FOURIER TERMS
Sigma0 = B0 .* (1 + B1.*cosFi + B2.*cs2Fi).^zPow ;

% Applicability domain of the empirical/experimental model (CMOD5.N here):
It = find( Theta_d < 18 | Theta_d > 57 ) ;
if ~isempty(It)
    disp(Theta_d(It)) ;
    warning('/!\ 18° <= Th_i_d <= 58° /!\') ;
    %pause(1) ;
end
