function [Nrcs_Mdl_VV, Nrcs_Mdl_HH, Nrcs_Mdl_VH] = f_Nrcs_3dMono_EmpExpSea_Lband_Meissner_v2 (Th_i_d, u10_ms, windDir_d, MethIntp) 

%--------------------------------------------------------------------------
% FUNCTION: f_Nrcs_3dMono_EmpExpSea_Lband_Meissner_v2
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) sea surface for 3D problems, 
% in HH polarization and in L band (1.26 GHz), with respect to the empirical 
% model of Isoguchi and Meissner et al. (2014, JGRO), for incidence angles 29.36°; 38.44°; 46.29°:
% - Th_i_d must be about 29.36°; 38.44°; 46.29° (...) -> I CONVERTED IT 
% INTO BETWEEN 24.36° AND 49.29° 
% - u10_ms must be between 0.2-22 m/s (? [Zhao_2024_IGARSS,tab.1]) 
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
% Nrcs_Mdl_VH : NRCS under considered model in VH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% Cross-polarizations (VH, HV) are assumed to be identical 
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL, 09/2025
%--------------------------------------------------------------------------


%% Applicability domain of considered model:

thR1_d = 29.36 ; % Incidence angle for radiometer/scatterometer 1 (deg.) 
thR2_d = 38.44 ; % Incidence angle for radiometer/scatterometer 2 (deg.) 
thR3_d = 46.29 ; % Incidence angle for radiometer/scatterometer 3 (deg.) 
lm1_th = thR1_d - 5 ; % Limit of acceptable minimum angle (deg.) 
lM3_th = thR3_d + 3 ; % Limit of acceptable MAXIMUM angle (deg.) 
%
It = find( Th_i_d < lm1_th | Th_i_d > lM3_th ) ;
if ~isempty(It)
    disp(Th_i_d(It)) ;
    warning('/!\ 24.36° <= Th_i_d <= 49.36° /!\') ;
    pause(1) ;
end

%
if u10_ms > 22 || u10_ms < 0.2  % according to [Zhao_2024_IGARSS,tab.1] (?) 
    disp(u10_ms) ;
    warning('/!\ 0.2 m/s <= u10_ms <= 22 m/s /!\') ;
    pause(1) ;
end


%%

% Coefficients b_kip for VV pol. and radiometer 1 (29.36°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_VV_R1 = [ 2.7669953402e-002 ; -3.5648121980e-003 ; 2.5085738933e-004 ; -7.6604470290e-006 ; +8.3403936421e-008 ] ; 
B1i_VV_R1 = [ 3.1471932686e-004 ; -1.0708873066e-004 ; 9.8366727292e-006 ; -1.5828345752e-007 ; -2.3597221602e-009 ] ; 
B2i_VV_R1 = [ 1.9129701422e-003 ; -1.4546678790e-003 ; 2.1484907649e-004 ; -9.9712358461e-006 ; +1.5136841055e-007 ] ; 
% Coefficients b_kip for HH pol. and radiometer 1 (29.36°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_HH_R1 = [ 1.2755914080e-002 ; -1.1566306028e-003 ; 7.5880134855e-005 ; -2.1193397012e-006 ; +1.9732074898e-008 ] ; 
B1i_HH_R1 = [ 3.6370936768e-004 ; -1.1753728728e-004 ; 1.3593095709e-005 ; -3.4977915542e-007 ; +8.1882224455e-010 ] ; 
B2i_HH_R1 = [ 1.5807451212e-003 ; -9.5377945712e-004 ; 1.3424379381e-004 ; -6.0496459000e-006 ; +8.9841023600e-008 ] ; 
% Coefficients b_kip for VH pol. and radiometer 1 (29.36°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_VH_R1 = [ 1.9041911638e-004 ; -2.4137499915e-005 ; 1.6633064884e-006 ; -4.5692164746e-008 ; +4.1017449367e-010 ] ; 
B1i_VH_R1 = [ -2.5270345066e-005 ; 1.9095363812e-005 ; -2.7666404448e-006 ; 1.3956850131e-007 ; -2.3159389660e-009 ] ; 
B2i_VH_R1 = [ -3.0904528219e-005 ; 6.9945782218e-006 ; -4.5969356549e-007 ; 1.4793445441e-008 ; -2.0473917589e-010 ] ; 
%
%
% Coefficients b_kip for VV pol. and radiometer 2 (38.44°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_VV_R2 = [ 1.2863352200e-002 ; -2.0993592491e-003 ; 1.6518875147e-004 ; -5.4682006056e-006 ; +6.4132838313e-008 ] ; 
B1i_VV_R2 = [ 5.2348832960e-004 ; -2.0409803674e-004 ; 2.6073582526e-005 ; -1.1566411871e-006 ; +1.7537140274e-008 ] ; 
B2i_VV_R2 = [ 5.5889743658e-004 ; -5.0187584565e-004 ; 7.9280278992e-005 ; -3.6902553692e-006 ; +5.4847783328e-008 ] ; 
% Coefficients b_kip for HH pol. and radiometer 2 (38.44°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_HH_R2 = [ 3.7572819799e-003 ; -5.3258749393e-004 ; 4.3724484672e-005 ; -1.4681802479e-006 ; +1.7169850326e-008 ] ; 
B1i_HH_R2 = [ 3.3829156489e-004 ; -1.3147938974e-004 ; 1.8137648631e-005 ; -7.9436180922e-007 ; +1.1628671488e-008 ] ; 
B2i_HH_R2 = [ 3.7371603939e-004 ; -2.4023678467e-004 ; 3.4716850703e-005 ; -1.5485629837e-006 ; +2.2414676330e-008 ] ; 
% Coefficients b_kip for VH pol. and radiometer 2 (38.44°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_VH_R2 = [ 1.3790708068e-004 ; -2.2047630792e-005 ; 1.8770726934e-006 ; -6.2770930814e-008 ; +7.2517799883e-010 ] ; 
B1i_VH_R2 = [ 4.7769227366e-007 ; +2.5545436707e-006 ; -4.5579483792e-007 ; 2.5765445741e-008 ; -4.5614845733e-010 ] ; 
B2i_VH_R2 = [ -1.2471120703e-005 ; 2.0557144375e-006 ; 1.5545411606e-008 ; -5.1412937047e-009 ; +1.0030170313e-010 ] ; 
%
%
% Coefficients b_kip for VV pol. and radiometer 3 (46.29°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_VV_R3 = [ 7.9812841854e-003 ; -1.4250014823e-003 ; 1.1846924116e-004 ; -4.0865529161e-006 ; +4.9691503580e-008 ] ; 
B1i_VV_R3 = [ 2.8558723483e-004 ; -1.1332749701e-004 ; 1.4903721848e-005 ; -6.4922700321e-007 ; +9.4205608577e-009 ] ; 
B2i_VV_R3 = [ 4.4372478525e-004 ; -3.1164511936e-004 ; 4.9980678917e-005 ; -2.3909290707e-006 ; +3.6603560390e-008 ] ; 
% Coefficients b_kip for HH pol. and radiometer 3 (46.29°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_HH_R3 = [ 1.4664950940e-003 ; -2.4374331007e-004 ; 2.1823161004e-005 ; -7.7367920090e-007 ; +9.4709584062e-009 ] ; 
B1i_HH_R3 = [ 1.2856275234e-004 ; -5.0136994111e-005 ; 7.3669264038e-006 ; -3.1710126109e-007 ; +4.4180628101e-009 ] ; 
B2i_HH_R3 = [ 1.5707164701e-004 ; -9.3649029302e-005 ; 1.3860196514e-005 ; -6.3232563194e-007 ; +9.3928175374e-009 ] ; 
% Coefficients b_kip for VH pol. and radiometer 3 (46.29°) [Meissner_2014_JGRO,ts01.txt+eq.3]: 
B0i_VH_R3 = [ 9.7111150301e-005 ; -1.5524769836e-005 ; 1.3641790391e-006 ; -4.5902503063e-008 ; 5.3015300281e-010 ] ; 
B1i_VH_R3 = [ 2.3716636960e-006 ; 4.8176236632e-007 ; -9.6942418523e-008 ; 6.1691070717e-009 ; -1.1276100998e-010 ] ; 
B2i_VH_R3 = [ -2.2014555824e-006 ; -3.4305836137e-007 ; 2.4793080821e-007 ; -1.6036928492e-008 ; 2.8900573608e-010 ] ; 


%% Calculation of coefficients B_kp [Meissner_2014_JGRO,eq.3]: 

w = u10_ms ; % wind speed in linear scale: /!\ WE ASSUME THAT w=u10, BUT IT IS NOT SAID!!! /!\ [Zhao_2024_IGARSS,tab.1] 
W_power = w.^((1:1:5).') ; 
%
B0_VV_R1 = sum( B0i_VV_R1 .* W_power ) ; B1_VV_R1 = sum( B1i_VV_R1 .* W_power ) ; B2_VV_R1 = sum( B2i_VV_R1 .* W_power ) ; 
B0_VV_R2 = sum( B0i_VV_R2 .* W_power ) ; B1_VV_R2 = sum( B1i_VV_R2 .* W_power ) ; B2_VV_R2 = sum( B2i_VV_R2 .* W_power ) ; 
B0_VV_R3 = sum( B0i_VV_R3 .* W_power ) ; B1_VV_R3 = sum( B1i_VV_R3 .* W_power ) ; B2_VV_R3 = sum( B2i_VV_R3 .* W_power ) ; 
%
B0_HH_R1 = sum( B0i_HH_R1 .* W_power ) ; B1_HH_R1 = sum( B1i_HH_R1 .* W_power ) ; B2_HH_R1 = sum( B2i_HH_R1 .* W_power ) ; 
B0_HH_R2 = sum( B0i_HH_R2 .* W_power ) ; B1_HH_R2 = sum( B1i_HH_R2 .* W_power ) ; B2_HH_R2 = sum( B2i_HH_R2 .* W_power ) ; 
B0_HH_R3 = sum( B0i_HH_R3 .* W_power ) ; B1_HH_R3 = sum( B1i_HH_R3 .* W_power ) ; B2_HH_R3 = sum( B2i_HH_R3 .* W_power ) ; 
%
B0_VH_R1 = sum( B0i_VH_R1 .* W_power ) ; B1_VH_R1 = sum( B1i_VH_R1 .* W_power ) ; B2_VH_R1 = sum( B2i_VH_R1 .* W_power ) ; 
B0_VH_R2 = sum( B0i_VH_R2 .* W_power ) ; B1_VH_R2 = sum( B1i_VH_R2 .* W_power ) ; B2_VH_R2 = sum( B2i_VH_R2 .* W_power ) ; 
B0_VH_R3 = sum( B0i_VH_R3 .* W_power ) ; B1_VH_R3 = sum( B1i_VH_R3 .* W_power ) ; B2_VH_R3 = sum( B2i_VH_R3 .* W_power ) ; 


%% NRCS in linear scale - for each radiometer Ri [Meissner_2014_JGRO,eq.2]: 

% For radiometer 1 (29.36°): 
Nrcs_R1_VV = B0_VV_R1 + B1_VV_R1 * cosd(1*windDir_d) + B2_VV_R1 * cosd(2*windDir_d) ; 
Nrcs_R1_HH = B0_HH_R1 + B1_HH_R1 * cosd(1*windDir_d) + B2_HH_R1 * cosd(2*windDir_d) ; 
Nrcs_R1_VH = B0_VH_R1 + B1_VH_R1 * cosd(1*windDir_d) + B2_VH_R1 * cosd(2*windDir_d) ; 
% For radiometer 2 (38.44°): 
Nrcs_R2_VV = B0_VV_R2 + B1_VV_R2 * cosd(1*windDir_d) + B2_VV_R2 * cosd(2*windDir_d) ; 
Nrcs_R2_HH = B0_HH_R2 + B1_HH_R2 * cosd(1*windDir_d) + B2_HH_R2 * cosd(2*windDir_d) ; 
Nrcs_R2_VH = B0_VH_R2 + B1_VH_R2 * cosd(1*windDir_d) + B2_VH_R2 * cosd(2*windDir_d) ; 
% For radiometer 3 (46.29°): 
Nrcs_R3_VV = B0_VV_R3 + B1_VV_R3 * cosd(1*windDir_d) + B2_VV_R3 * cosd(2*windDir_d) ; 
Nrcs_R3_HH = B0_HH_R3 + B1_HH_R3 * cosd(1*windDir_d) + B2_HH_R3 * cosd(2*windDir_d) ; 
Nrcs_R3_VH = B0_VH_R3 + B1_VH_R3 * cosd(1*windDir_d) + B2_VH_R3 * cosd(2*windDir_d) ; 


%% NRCS in linear scale [Meissner_2014_JGRO,eq.2]: 

% The paper does not talk about how to handle the incidence angle: 

% => Option 1: Depending on thersholhds, we take either of the three values:
l12_th = (thR1_d + thR2_d) / 2 ; % Limit between radiometer 1 & radiometer 2 (deg.) 
l23_th = (thR2_d + thR3_d) / 2 ; % Limit between radiometer 2 & radiometer 3 (deg.) 
%
I_R1_th =  Th_i_d >= lm1_th & Th_i_d < l12_th  ; 
I_R2_th =  Th_i_d >= l12_th & Th_i_d < l23_th  ; 
I_R3_th =  Th_i_d >= l23_th & Th_i_d < lM3_th  ; 
Nrcs_Mdl_VV(I_R1_th) = Nrcs_R1_VV ; Nrcs_Mdl_VV(I_R2_th) = Nrcs_R2_VV ; Nrcs_Mdl_VV(I_R3_th) = Nrcs_R3_VV ; 
Nrcs_Mdl_HH(I_R1_th) = Nrcs_R1_HH ; Nrcs_Mdl_HH(I_R2_th) = Nrcs_R2_HH ; Nrcs_Mdl_HH(I_R3_th) = Nrcs_R3_HH ; 
Nrcs_Mdl_VH(I_R1_th) = Nrcs_R1_VH ; Nrcs_Mdl_VH(I_R2_th) = Nrcs_R2_VH ; Nrcs_Mdl_VH(I_R3_th) = Nrcs_R3_VH ; 
% 
% Nrcs_Mdl_VV = B0_VV + B1_VV * cosd(1*windDir_d) + B2_VV * cosd(2*windDir_d) ; 
% Nrcs_Mdl_HH = B0_HH + B1_HH * cosd(1*windDir_d) + B2_HH * cosd(2*windDir_d) ; 
% Nrcs_Mdl_VH = B0_VH + B1_VH * cosd(1*windDir_d) + B2_VH * cosd(2*windDir_d) ; 

% % => Option 2: We make a makima interpolation (and slight EXTRApolation down to lm1_th and up to lM3_th): 
if isempty(MethIntp)
    % MethIntp = 'makima' ; % not good extrapolation (---)
    % MethIntp = 'pchip' ; % not good extrapolation (-- )
    % MethIntp = 'spline' ; % not good extrapolation (-- )
    MethIntp = 'linear' ; % not good extrapolation around 50° (- )
end
%
for i_th = 1 : length(Th_i_d) 
    % Nrcs_Mdl_VV(i_th) = interp1([29.36 38.44 46.29], [Nrcs_R1_VV Nrcs_R2_VV Nrcs_R3_VV], Th_i_d(i_th), MethIntp, 'extrap') ; 
    % Nrcs_Mdl_HH(i_th) = interp1([29.36 38.44 46.29], [Nrcs_R1_HH Nrcs_R2_HH Nrcs_R3_HH], Th_i_d(i_th), MethIntp, 'extrap') ; 
    % Nrcs_Mdl_VH(i_th) = interp1([29.36 38.44 46.29], [Nrcs_R1_VH Nrcs_R2_VH Nrcs_R3_VH], Th_i_d(i_th), MethIntp, 'extrap') ; 
    %
    nrcs_Mdl_VV_dB = interp1([29.36 38.44 46.29], 10*log10([Nrcs_R1_VV Nrcs_R2_VV Nrcs_R3_VV]), Th_i_d(i_th), MethIntp, 'extrap') ; Nrcs_Mdl_VV(i_th) = 10^(nrcs_Mdl_VV_dB/10) ; 
    nrcs_Mdl_HH_dB = interp1([29.36 38.44 46.29], 10*log10([Nrcs_R1_HH Nrcs_R2_HH Nrcs_R3_HH]), Th_i_d(i_th), MethIntp, 'extrap') ; Nrcs_Mdl_HH(i_th) = 10^(nrcs_Mdl_HH_dB/10) ; 
    nrcs_Mdl_VH_dB = interp1([29.36 38.44 46.29], 10*log10([Nrcs_R1_VH Nrcs_R2_VH Nrcs_R3_VH]), Th_i_d(i_th), MethIntp, 'extrap') ; Nrcs_Mdl_VH(i_th) = 10^(nrcs_Mdl_VH_dB/10) ; 
end
%
% Nrcs_Mdl_VV(It) = 0 ; % ou plutôt NaN
% Nrcs_Mdl_HH(It) = 0 ; % ou plutôt NaN
