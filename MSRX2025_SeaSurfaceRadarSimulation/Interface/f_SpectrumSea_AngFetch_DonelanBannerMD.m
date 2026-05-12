function [Phi_spr, Dt_k, Phi_spr_spatial] = f_SpectrumSea_AngFetch_DonelanBannerMD( u_10, Phi_d, K, fetch_m, StrgMdl ) 

%--------------------------------------------------------------------------
% FUNCTION: f_SpectrumSea_AngFetch_DonelanBannerMD
%--------------------------------------------------------------------------
% Calculates the angular part of the sea surface height spectrum, 
% according to the model of (Donelan-)Banner [1990_Banner_JPO], 
% with the modification of McDaniel [McDaniel_2001_WRM]. 
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account. 
% NB: Phi_d SHOULD BE BETWEEN -180° and +180°, IN FACT!
%--------------------------------------------------------------------------
% Input variables:
% u_10  : Wind speed at 10 m above the sea surface (m/s) [scalar]
% Phi_d : Wind direction (deg.) [scalar/Vector of same size as K]
% K     : Surface wavenumber (rad/m) [Vector]
% fetch_m : Fetch = length of action of wind on the sea (m) [scalar]
% StrgMdl : Choice of model: 'Don'->Donelan / 'Ban'->Donelan+Banner [String]
%--------------------------------------------------------------------------
% Output variables:
% Phi_spr : Surface height angular spreading function (ASF) [Vector]
% Dt_k    : Upwind-crosswind ratio [Vector]
% Phi_spr_spatial : ... [Vector]
%--------------------------------------------------------------------------
% COMMENTS:
% To obtain the directional spectrum, we must do: Sh_iso .* Phi_spr ./ K
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%--------------------------------------------------------------------------
% Called functions:
% (none)
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 2026-04 
%--------------------------------------------------------------------------

K(K<0) = -K(K<0) ;

I_ph = find( (Phi_d<-180) | (Phi_d>+180) , 1 ) ; % Find only the first for faster computation
% if ~isempty(I_ph)
%     disp('/!\ WARNING: Phi_d SHOULD BE BETWEEN -180° and +180° /!\') ;
% end

% Constants:
g = 9.81 ; % Acceleration due to gravity (m/s^2)
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]

% Relations:
k0 = g / u_10^2 ; % in rad/m
if isempty(fetch_m) % Case of infinite fetch => omgc = 0.84 (fully-developed sea) 
    omgc = 0.84 ; % Fully-developed sea 
else
    xmaj = k0 * fetch_m ; % dimensionless [Elfouhaily_1997_JGR,below-eq.4]
    omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [Elfouhaily_1997_JGR,eq.37]
end
kp = k0 * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
%
if strcmp(StrgMdl , 'Don') 
    if ~isempty( find(K > 2.56*kp, 1) ) % [Mouche_2005_These,p.19]
        warning('The model is not adapted to K > 2.56kp (kp = %.2f)! ', kp) ;
    end
    % Donelan formulation:
    % % Initial version [Donelan_1985_PTRSLA] -> Bt (beta) in terms of W (omega):
    % % km = 370 ; % in rad/m [Elfouhaily_1997_JGR,eq.24]
    % % W  = sqrt( g*K  .* (1+K.^2/km^2) ) ; % [Elfouhaily_1997_JGR,eq.24]
    % % wp = sqrt( g*kp  * (1+kp^2/km^2) ) ; % [Elfouhaily_1997_JGR,eq.24]
    % W  = sqrt( g*K  ) ; % [Donelan_1985_PTRSLA,eq.1.1-5]
    % wp = sqrt( g*kp ) ; % [Donelan_1985_PTRSLA,eq.1.1-5]
    % C1w = (W>=0.56*wp) & (W<=0.95*wp) ; % [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60]
    % C2w = (W> 0.95*wp) & (W<=1.60*wp) ; % [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.61]
    % % C3w = (W> 1.60*wp) ; % [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.62]
    % C3w = (W> 1.60*wp) | (W<0.56*wp) ; % [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.62]
    % Bt = 2.61*(W/wp).^(+1.3) .* C1w + 2.28*(W/wp).^(-1.3) .* C2w + 1.24 .* C3w ; % [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60-62]
    % Better version ([Donelan_1987_JGR]&[Mouche_2005_These]) -> Bt (beta) in terms of K (k):
    C1k = (K>=0.56^2*kp) & (K<=0.95^2*kp) ; % 0.56^2 = 0.31 ; 0.95^2 = 0.90 [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60]
    C2k = (K> 0.95^2*kp) & (K<=1.60^2*kp) ; % 0.95^2 = 0.90 ; 1.60^2 = 2.56 [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60]
    C3k = (K> 1.60^2*kp) | (K< 0.56^2*kp) ; % 1.60^2 = 2.56 ; 0.56^2 = 0.31 [Donelan_1985_PTRSLA,eq.9.2]&[2005_Mouche_These,eq.1.62]
    Bt = 2.61*(K/kp).^(+0.65) .* C1k + 2.28*(K/kp).^(-0.65) .* C2k + 1.24 .* C3k ; % [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60-62]
elseif strcmp(StrgMdl , 'Ban')
    if ~isempty( find(K > 370, 1) )
        warning('The model is valid only up to the equilibrium domain! ') ;
    end
    % Banner formulation:
    C0k = (K< 0.56^2*kp) ; % 0.56^2 = 0.31 [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60]
    C1k = (K>=0.56^2*kp) & (K<=0.95^2*kp) ; % 0.56^2 = 0.31 ; 0.95^2 = 0.90 [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60]
    C2k = (K> 0.95^2*kp) & (K<=1.60^2*kp) ; % 0.95^2 = 0.90 ; 1.60^2 = 2.56 [Donelan_1985_PTRSLA,eq.9.2]&[Banner_1990_JPO,eq.2.9a-TypoOnLowerLimit]&[Mouche_2005_These,eq.1.61]
    C4k = (K> 1.60^2*kp) ; % 1.60^2 = 2.56 [Donelan_1985_PTRSLA,eq.9.2]&[Banner_1990_JPO,eq.2.9b]&[Mouche_2005_These,eq.1.61]
    Bt = 1.24 .* C0k + 2.61*(K/kp).^(+0.65) .* C1k + 2.28*(K/kp).^(-0.65) .* C2k + 10.^( -0.4 + 0.8393*exp(-0.567*log(K/kp)) ) .* C4k ; % [Banner_1990_JPO,eq.2.9]&[Mouche_2005_These,eq.1.60-63]
elseif strcmp(StrgMdl , 'McD') 
    % McDaniel formulation: 
    C0k = (K< 0.56^2*kp) ; % 0.56^2 = 0.31 [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60]
    C1k = (K>=0.56^2*kp) & (K<=0.95^2*kp) ; % 0.56^2 = 0.31 ; 0.95^2 = 0.90 [Donelan_1985_PTRSLA,eq.9.2]&[Mouche_2005_These,eq.1.60]
    C2k = (K> 0.95^2*kp) & (K<=1.60^2*kp) ; % 0.95^2 = 0.90 ; 1.60^2 = 2.56 [Donelan_1985_PTRSLA,eq.9.2]&[Banner_1990_JPO,eq.2.9a-TypoOnLowerLimit]&[Mouche_2005_These,eq.1.61]
    C4k = (K> 1.60^2*kp) ; % 1.60^2 = 2.56 [Donelan_1985_PTRSLA,eq.9.2]&[Banner_1990_JPO,eq.2.9b]&[Mouche_2005_These,eq.1.61]
    Bt = 1.24 .* C0k + 2.61*(K/kp).^(+0.65) .* C1k + 2.28*(K/kp).^(-0.65) .* C2k + ...
    exp(-K.^2/100^2) .* exp(-0.921 + 1.114*(K/kp).^-0.567) .* C4k ; % [Banner_1990_JPO,eq.2.9]&[McDaniel_2001_WRM,eq.4.8]&[Mouche_2005_These,eq.1.60-62]
else 
    error('Invalid input variable StrgMdl! Please double check.') ; 
end
%
Phi_r = Phi_d * pi/180 ;

% Spreading function:
Phi_spr = Bt/2 .* sech(Bt .* Phi_r).^2 ; % [Banner_1990_JPO,eq.2.8]&[Donelan_1985_PTRSLA,eq.9.1]
% Phi_spr_spatial = 0.5 * ( Bt/2 .* sech(Bt .* Phi_r).^2 + Bt/2 .* sech(Bt .* (Phi_r-pi)).^2 ) ; % [Banner_1990_JPO,eq.2.8&2.10]&[Donelan_1985_PTRSLA,eq.9.1]
Phi_spr_spatial = 0.5 * ( Bt/2 .* sech(Bt .* Phi_r).^2 + Bt/2 .* sech(Bt .* (abs(Phi_r-pi).*(abs(Phi_r-pi)<pi)+abs(Phi_r+pi).*(abs(Phi_r-pi)>=pi))).^2 ) ; % [Banner_1990_JPO,eq.2.8&2.10]&[Donelan_1985_PTRSLA,eq.9.1]
if strcmp(StrgMdl , 'McD')
    % Modification of McDaniel:
    kT = 349 ; % in m^-1
    U_T = 27.91 - 0.0218*K ; % in m/s
    Alph2 = ( 1 - exp(-u_10*(K/kT).^2) ) .* ( 0.4 - 0.2*tanh(0.1*(u_10-U_T)) ) ; % [McDaniel_2001_WRM,eq.4.7]
    Phi_spr = Phi_spr + Bt/2 .* Alph2 .* cos(2 * Phi_d*pi/180) ; % [Banner_1990_JPO,eq.2.8]&[Donelan_1985_PTRSLA,eq.9.1]&[McDaniel_2001_WRM,eq.4.9]
    Phi_spr_spatial = Phi_spr_spatial + Alph2 .* cos(2 * Phi_r) ; % [Banner_1990_JPO,eq.2.8]&[Donelan_1985_PTRSLA,eq.9.1]&[Banner_1990_JPO,eq.2.10]&[McDaniel_2001_WRM,eq.4.9]
end
% Cn = 1 ;
Cn = 1 ./ tanh(Bt*pi) ; % [McDaniel_2001_WRM,eq.4.5]&[Banner_1990_JPO,eq.3.1] 
% Cn = 1 ./ tanh(2*Bt*pi) ; % TO BE PROVED MORE RIGOROUSLY...
% if strcmp(StrgMdl , 'McD') 
%     Cn(C4k) = 1/(2*pi) ; % ??? [McDaniel_2001_WRM,below_eq.4.7] NOT VERY CLEAR - IT SEEMS THAT NO, BY CHECKING \int_{-pi}^{+pi} Phi_spr(Phi_d)*dPhi_d = 1 -> trapz(Phi_d*pi/180,Phi_spr) 
% end
Phi_spr = Cn .* Phi_spr ; % Obtained by checking that \int_{-pi}^{+pi} Phi_spr(Phi_d)*dPhi_d = 1 -> trapz(Phi_d*pi/180,Phi_spr) 
Phi_spr_spatial = Cn .* Phi_spr_spatial ; % ... 
%
if strcmp(StrgMdl , 'McD') 
    Dt_k = ( 1 - sech(Bt*pi/2).^2 + 2*Alph2 ) ./ ( 1 + sech(Bt*pi/2).^2 ) ; % [Elfouhaily_1997_JGR,eq.54]&[McDaniel_2001_WRM,eq.4.10] 
else 
    Dt_k = ( 1 - sech(Bt*pi/2).^2 ) ./ ( 1 + sech(Bt*pi/2).^2 ) ; % [Elfouhaily_1997_JGR,eq.54]&[McDaniel_2001_WRM,eq.4.10] 
end 

warning('IL RESTE A VALIDER EN COMPARANT MES COURBES AVEC CELLES DES ARTICLES PUBLIES') ; 
