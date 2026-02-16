function [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = f_Nrcs_3dMono_EmpExpSea_Lband_Isoguchi (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION: f_Nrcs_3dMono_EmpExpSea_Lband_Isoguchi
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in HH polarization and in L band (~1.3 GHz), with respect to the empirical 
% model of Isoguchi and Shimada (TGRS 2009), for incidence angles 17°-43°:
% - Th_i_d must be between 17°-43°
% - u10_ms must be between 0-20 m/s
% - (winddir_d must be between 0°-360°) 
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d        : Incidence angle with respect to the vertical z (deg.) [Vector]
% u10_ms        : Wind speed at 10 m above the sea surface (m/s) [scalar]
% windDir_d     : Wind direction with respect to the incidence azimuth 
%                 direction, \phi-\phi0 (deg.) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_VV : NRCS under considered model in VV polarization [Vector - lin. scale]
% Nrcs_Mdl_HH : NRCS under considered model in HH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 10/2013
%--------------------------------------------------------------------------

% Applicability domain of considered model:
It = find( Th_i_d < 17 | Th_i_d > 43 ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    warning('/!\ 17° <= Th_i_d <= 43° /!\') ;
    pause(1) ;
end
if u10_ms >= 20
    disp(u10_ms) ;
    warning('/!\ u10_ms < 20 m/s /!\') ;
    pause(1) ;
end

% Coefficients c_n of the model function - see Table II of [2009_Isoguchi_TGRS]:
c01 = -24.6132  ; c10 = +.0141954   ; c19 = +1.0295942  ; c28 = -.87121872  ;
c02 = -6.31709  ; c11 = +.00217386  ; c20 = -.93111517  ; c29 = -.98821035  ;
c03 = +1.46319  ; c12 = -.00432962  ; c21 = +.32195023  ; c30 = +.94378859  ;
c04 = +2.92734  ; c13 = -.019147773 ; c22 = -.35496593  ; c31 = +.15922271  ;
c05 = -.894306  ; c14 = -.090174967 ; c23 = +.20427109  ; c32 = +.0051449332;
c06 = -.130262  ; c15 = +.047353601 ; c24 = +.0072836811; c33 = -.012543578 ;
c07 = -.317086  ; c16 = +.0071883901; c25 = +.026917075 ;
c08 = +.0231062 ; c17 = +.019573817 ; c26 = -.011457193 ;
c09 = +.0618355 ; c18 = -.0055066932; c27 = -.0014194834;

% Relationships:
X = (Th_i_d-30) / 15 ;
w_log = 10*log10(u10_ms) ; % wind speed in log. scale
w_lin = u10_ms ; % wind speed in linear scale: /!\ WE ASSUME THAT w=u10, BUT IT IS NOT SAID!!! /!\

% Equations (A2-A5) -> a_0-a_3:
Amin_0 = c01 + c02*X + c03*X.^2 ;
Amin_1 = c04 + c05*X + c06*X.^2 ;
Amin_2 = c07 + c08*X + c09*X.^2 ;
Amin_3 = c10 + c11*X + c12*X.^2 ;

% Equation (A1) -> A_0:
Amaj_0 = 10.^( (Amin_0 + Amin_1*w_log + Amin_2*w_log^2 + Amin_3*w_log^3) / 10 ) ;

% Equation (A6) -> A_1:
Amaj_1 = c13 + c14*X + c15*X.^2 + (c16+c17*X+c18*X.^2)*w_lin ;

% Equations (A8-A12) -> b_0-b_4:
B_0 = c19 + c20*X + c21*X.^2 ;
B_1 = c22 + c23*X + c24*X.^2 ;
B_2 = c25 + c26*X + c27*X.^2 ;
B_3 = c28 + c29*X + c30*X.^2 ;
B_4 = c31 + c32*X + c33*X.^2 ;

% Equation (A7) -> A_2:
Amaj_2 = (B_0 + B_1*w_lin + B_2*w_lin^2) ./ (1 + exp(B_3+B_4*w_lin)) ;

% Scattering coefficients:
SigmaH_0 = Amaj_0 ;
SigmaH_1 = Amaj_0 .* Amaj_1 ;
SigmaH_2 = Amaj_0 .* Amaj_2 ;
% SigmaH_1 = 1 .* Amaj_1 ;
% SigmaH_2 = 1 .* Amaj_2 ;

% NRCS in linear scale ([2009_Isoguchi_TGRS,eq.1]) :
Nrcs_Mdl_VV = zeros(size(Th_i_d)) ;
Nrcs_Mdl_HH = SigmaH_0 + SigmaH_1 * cosd(1*windDir_d) + SigmaH_2 * cosd(2*windDir_d) ;
%
Nrcs_Mdl_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Mdl_HH(It) = 0 ; % ou plutôt NaN
