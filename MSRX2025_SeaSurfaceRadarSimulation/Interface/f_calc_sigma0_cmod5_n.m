function sigma0 = f_calc_sigma0_cmod5_n(v, phi, theta)

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

% inputs:
% v [m/s]      : wind velocity (always >= 0)
% phi [deg]    : angle between azimuth and wind direction
% theta [deg]  : incidence angle

% output:
% sigma0       : coefficient de rétrodiffusion (linéaire)

DTOR   = 57.29577951;
THETM  = 40.0;
THETHR = 25.0;
ZPOW   = 1.6;

% Coefficients obtained from Hans Hersbach by Email on 5 Feb 2008
C = [-0.6878, -0.7957,  0.3380, -0.1728, 0.0000,  0.0040, 0.1103, ...
      0.0159,  6.7329,  2.7713, -2.2885, 0.4971, -0.7250, 0.0450, ...
      0.0066,  0.3222,  0.0120, 22.7000, 2.0813,  3.0000, 8.3659, ...
     -3.3428,  1.3236,  6.2437,  2.3893, 0.3249,  4.1590, 1.6930];

Y0 = C(19);
PN = C(20);
A  = C(19) - (C(19)-1)/C(20);
B  = 1/(C(20)*(C(19)-1)^(3-1));

% Angles
FI   = phi / DTOR;
CSFI = cos(FI);
CS2FI = 2.0 * CSFI.^2 - 1.0;

X  = (theta - THETM) / THETHR;
XX = X.^2;

% B0: FUNCTION OF WIND SPEED AND INCIDENCE ANGLE
A0 = C(1) + C(2)*X + C(3)*XX + C(4)*X.*XX;
A1 = C(5) + C(6)*X;
A2 = C(7) + C(8)*X;
GAM = C(9) + C(10)*X + C(11)*XX;
S0 = C(12) + C(13)*X;
S = A2 .* v;
A3 = 1./(1 + exp(-max(S,S0)));
if S < S0
    A3 = A3 .* (S/S0).^( S0.*(1 - A3) );
end
B0 = (A3.^GAM) .* 10.^(A0 + A1.*v);

% B1: FUNCTION OF WIND SPEED AND INCIDENCE ANGLE
B1 = C(15)*v.*(0.5 + X - tanh(4*(X + C(16) + C(17)*v)));
B1 = C(14)*(1 + X) - B1;
B1 = B1 ./ (exp(0.34*(v - C(18))) + 1);

% B2: FUNCTION OF WIND SPEED AND INCIDENCE ANGLE
V0 = C(21) + C(22)*X + C(23)*XX;
D1 = C(24) + C(25)*X + C(26)*XX;
D2 = C(27) + C(28)*X;
V2 = (v ./ V0 + 1);
if V2 < Y0
    V2 = A + B*(V2 - 1).^PN;
end
B2 = (-D1 + D2.*V2).*exp(-V2);

% COMBINE THE THREE FOURIER TERMS
sigma0 = B0 .* (1 + B1.*CSFI + B2.*CS2FI).^ZPOW;
end
