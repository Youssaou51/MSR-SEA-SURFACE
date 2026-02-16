function [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz99 (Th_i_d, u10_ms, windDir_d) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz99
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient)of a (2D) sea surface for 3D problems, 
% in VV and HH polarizations and in Ku band (14.6 GHz), with respect to the empirical 
% model of Wentz and Smith (JGR 1999), for incidence angles 15°-65°:
% - Th_i_d must be between 15°-65° (55° for HH pol.)
% - u10_ms must be between 0-20 m/s
% - (winddir_d must be between 0°-360°
% The data are interpolated (linear interpolation) in dB scale
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
% Wentz et al., JGR, vol. 89(C3), pp. 3689-3704, 1984
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 07/2013
%--------------------------------------------------------------------------

% Applicability domain of the empirical/experimental model (Wentz99 here):
Ev_th = Th_i_d < 15 | Th_i_d > 65 ;
It =  Ev_th ;
In = ~Ev_th ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    disp('/!\ 15° <= Th_i_d <= 65° (55° for HH pol.) /!\') ;
    pause(1) ;
end
if u10_ms >= 20
    disp(u10_ms) ;
    disp('/!\ u10_ms < 20 m/s /!\') ;
    pause(1) ;
end

%% Coefficients of A_0P in V and H polarizations [1999_Wentz_JGR,Tab.2]:
AA_0P_V = [ -0.333199e+02  0.206369e+01 -0.252960e-01 ;
            -0.484707e+00  0.150857e-01 -0.828636e-03 ;
             0.209419e-01 -0.484725e-03 -0.127067e-03 ;
            -0.722253e-03  0.282771e-04  0.223988e-05 ;
            -0.197359e-05 -0.130800e-05  0.209310e-06 ;
             0.554852e-06 -0.208157e-07 -0.628579e-09 ;
            -0.412505e-08  0.149365e-08 -0.177410e-09 ] ;
AA_0P_H = [ -0.352134e+02  0.171875e+01  0.263735e-01 ;
            -0.700816e+00 -0.215342e-02  0.333145e-02 ;
             0.218222e-01 -0.495723e-03 -0.920586e-04 ;
            -0.428971e-03  0.303353e-04 -0.452963e-05 ;
            -0.101374e-04 -0.237352e-05  0.117252e-06 ;
             0.357085e-06 -0.249487e-07  0.528832e-08 ;
             0.317954e-08  0.283361e-08 -0.989594e-10 ] ;
M0 = ( 0:6 ).' ;

% Th_intrp_d = Th_i_d(In) ;
Th_intrp_d = Th_i_d ;
Xp1_V = zeros(size(Th_intrp_d)) ; Xp2_V = zeros(size(Th_intrp_d)) ; Xp3_V = zeros(size(Th_intrp_d)) ;
Xp1_H = zeros(size(Th_intrp_d)) ; Xp2_H = zeros(size(Th_intrp_d)) ; Xp3_H = zeros(size(Th_intrp_d)) ;
for i_trp = 1 : length(Th_intrp_d)
    th_trp_d = Th_intrp_d(i_trp) ;
    Xp1_V(i_trp) = sum( AA_0P_V(:,1) .* (th_trp_d-40).^M0 ) ;
    Xp1_H(i_trp) = sum( AA_0P_H(:,1) .* (th_trp_d-40).^M0 ) ;
    Xp2_V(i_trp) = sum( AA_0P_V(:,2) .* (th_trp_d-40).^M0 ) ;
    Xp2_H(i_trp) = sum( AA_0P_H(:,2) .* (th_trp_d-40).^M0 ) ;
    Xp3_V(i_trp) = sum( AA_0P_V(:,3) .* (th_trp_d-40).^M0 ) ;
    Xp3_H(i_trp) = sum( AA_0P_H(:,3) .* (th_trp_d-40).^M0 ) ;
end
%
Gp_V = 10.^(Xp1_V/10) ;
Gp_H = 10.^(Xp1_H/10) ;
Hp_V = Xp2_V ;
Hp_H = Xp2_H ;
Bp_V = Xp3_V ;
Bp_H = Xp3_H ;
%
% Values of A_0V and A_0H (eq.9):
A_0V = Gp_V .* u10_ms.^Hp_V .* exp(Bp_V*u10_ms) ;
A_0H = Gp_H .* u10_ms.^Hp_H .* exp(Bp_H*u10_ms) ;


%% Coefficients of A_1P in V and H polarizations [1999_Wentz_JGR,Tab.4]:
AA_1P_V = [  0.219575e+00  0.588161e-03 -0.355617e-03  0            ;
            -0.514068e-02  0.518480e-03  0.656609e-05  0            ;
             0.443523e-05 -0.104422e-04  0.119783e-05  0            ;
            -0.875588e-05 -0.153837e-06 -0.353267e-07  0            ] ;
%
AA_1P_H = [  0.442604e+00  0.128898e-01 -0.112481e-02 -0.332487e-04 ;
            -0.825727e-02  0.982790e-03  0.100865e-03  0.207059e-05 ;
             0.168152e-03 -0.136218e-03 -0.854751e-05 -0.133341e-06 ;
            -0.212250e-04  0.338862e-05  0.287316e-06  0.515220e-08 ] ;
MM1 = meshgrid(0:3).' ; % number of the column
NN1 = MM1.' ; % number of the line

% Values of A_1V and A_1H (eq.18-19):
A_1V = zeros(size(Th_i_d)) ;
A_1H = zeros(size(Th_i_d)) ;
% for i_t = 1 : length(Th_i_d)
%     th = Th_i_d(i_t) ;
%     A_1V(i_t) = sum(sum( AA_1P_V .* u10_ms.^MM1 .* (th-40).^NN1 ,2 )) ;
%     A_1H(i_t) = sum(sum( AA_1P_H .* u10_ms.^MM1 .* (th-40).^NN1 ,2 )) ;
% end


%% Coefficients of A_2P in V and H polarizations [1999_Wentz_JGR,Tab.3]:
AA_2P_V = [ -0.310929e-02  0.569782e-03 -0.134223e-04  0.974349e-07 ;
             0.844082e-03 -0.817576e-04  0.176263e-05 -0.122837e-07 ;
            -0.294355e-04  0.250476e-05 -0.530116e-07  0.367063e-09 ] ;
%
AA_2P_H = [ -0.820475e-03  0.228444e-03 -0.279677e-05 -0.186039e-07 ;
             0.585086e-03 -0.433336e-04  0.570146e-06  0.426204e-09 ;
            -0.217526e-04  0.137112e-05 -0.174164e-07 -0.738717e-11 ] ;
MM2 = meshgrid(1:3 , 1:4).' ; % number of the column
NN2 = meshgrid(1:4 , 1:3) ; % number of the line

% Values of A_2V and A_2H (eq.15):
A_2V = zeros(size(Th_i_d)) ;
A_2H = zeros(size(Th_i_d)) ;
for i_t = 1 : length(Th_i_d)
    th = Th_i_d(i_t) ;
    A_1V(i_t) = sum(sum( AA_1P_V .* u10_ms.^MM1 .* (th-40).^NN1 ,1 )) ; % sum the lines M first
    A_1H(i_t) = sum(sum( AA_1P_H .* u10_ms.^MM1 .* (th-40).^NN1 ,1 )) ; % sum the lines M first
    A_2V(i_t) = sum(sum( AA_2P_V .* u10_ms.^MM2 .* (th-10).^NN2 ,1 )) ; % sum the lines M first
    A_2H(i_t) = sum(sum( AA_2P_H .* u10_ms.^MM2 .* (th-10).^NN2 ,1 )) ; % sum the lines M first
end


% Interpolation with respect to Th_i_d:
SigmaH_0 = A_0H ;
SigmaH_1 = A_0H .* A_1H ; %SigmaH_1 = 0 ;
SigmaH_2 = A_0H .* A_2H ; %SigmaH_2 = 0 ;
%
SigmaV_0 = A_0V ;
SigmaV_1 = A_0V .* A_1V ; %SigmaV_1 = 0 ;
SigmaV_2 = A_0V .* A_2V ; %SigmaV_2 = 0 ;

% NRCS in linear scale :
Nrcs_Mdl_VV = SigmaV_0 + SigmaV_1 * cosd(1*windDir_d) + SigmaV_2 * cosd(2*windDir_d) ;
Nrcs_Mdl_HH = SigmaH_0 + SigmaH_1 * cosd(1*windDir_d) + SigmaH_2 * cosd(2*windDir_d) ;
%
Nrcs_Mdl_VV(It) = 0 ; % ou plutôt NaN
Nrcs_Mdl_HH(It) = 0 ; % ou plutôt NaN
