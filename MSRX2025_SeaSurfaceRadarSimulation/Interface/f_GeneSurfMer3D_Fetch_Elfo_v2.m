function [ HH_XY , X , Y , SP_KXKY , Kx , Ky , NOr_XY ] = ...
    f_GeneSurfMer3D_Fetch_Elfo_v2 ( u10 , phiw_d , l_x , l_y , n_x , n_y , sd , prec , fetch_m ) 

%--------------------------------------------------------------------------
% FUNCTION: f_GeneSurfMer3D_Fetch_Elfo_v2
%--------------------------------------------------------------------------
% Generates a 2D surface (3D problems) of Gaussian statistics (height PDF)
% and whose surface height spectrum is a sea spectrum,
% according to the model of Elfouhaily et al. [1997_Elfouhaily_JGR]
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account 
% NOTA BENE: n_s must be a power of 2 for the ifft
% Bonus: also calculates the autocorrelation function (= FT of spectrum)
%--------------------------------------------------------------------------
% Input variables:
% u10   : Wind speed at 10 m above the sea surface (m/s) [scalar]
% phiw_d: Wind direction (deg.) [scalar]
% l_x   : Desired generated surface length with respect to x-axis (m) [scalar]
% l_y   : Desired generated surface length with respect to y-axis (m) [scalar]
% n_x   : Power-of-2 number of samples of the surface with respect to x-axis [scalar]
% n_y   : Power-of-2 number of samples of the surface with respect to y-axis [scalar]
% sd    : Seed of the generated white Gaussian noise
% prec  : Precision of the calculation (1=single or 2=double) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% HH_XY : heights of the sea surface (m) [matrix of dimension [n_x n_y]]
% X     : abscissa vector of length n_x along x-axis (m)
% Y     : abscissa vector of length n_y along y-axis (m)
% SP_KXKY: surface height spectrum (dimensionless) [matrix]
% Kx    : wavevector abscissa along x associated to S_K (rad/m) [vector of length n_x]
% Ky    : wavevector abscissa along y associated to S_K (rad/m) [vector of length n_y]
% NOr_XY: normalization for the IFFT [matrix of dimension [n_x n_y]]
%--------------------------------------------------------------------------
% COMMENTS:
% prec option has been added in order to handle large surfaces 
%--------------------------------------------------------------------------
% Called functions: 
% f_SpectrumSea_IsoFetch_Elfouhaily 
% f_SpectrumSea_AngFetch_Elfouhaily 
% elfo_tot (below)
% elfo_ang (below)
%--------------------------------------------------------------------------
% Nicolas PINEL, 11/2013
% Version: 10/2025 
%--------------------------------------------------------------------------


% Initialization of the variables:
if prec == 1 % Single precision 
    % Force single precision => induced computed variables should also have
    % single precision: 
    l_x = single(l_x) ; 
    l_y = single(l_y) ; 
    n_x = single(n_x) ; 
    n_y = single(n_y) ; 
end


% Construction of the wave vectors KX and KY:
% kmin_x = pi/l_x ; % Nbre d'onde min du spectre selon x pour kx>=0
% kmin_y = pi/l_y ; % Nbre d'onde min du spectre selon y pour ky>=0
kmin_x = (2*pi) / l_x ; % Nbre d'onde min du spectre selon x pour kx>=0
kmin_y = (2*pi) / l_y ; % Nbre d'onde min du spectre selon y pour ky>=0
kmax_x = pi*n_x / l_x ; % Nbre d'onde max du spectre selon x pour kx>=0
kmax_y = pi*n_y / l_y ; % Nbre d'onde max du spectre selon y pour ky>=0
% dt_x = l_x / (n_x) ; % dt_x = l_x / (n_x-1) ;
% dt_y = l_y / (n_y) ; % dt_y = l_y / (n_y-1) ;
% kmax_x = (2*pi) / (2*dt_x) ; % Nbre d'onde max du spectre selon x pour kx>=0
% kmax_y = (2*pi) / (2*dt_y) ; % Nbre d'onde max du spectre selon y pour ky>=0
% Construction des nombres d'onde kx>=0 et ky>=0
pask_x = 2 * ( kmax_x - kmin_x ) / ( n_x - 1 ) ; % Facteur 2 car kx>=0
pask_y = 2 * ( kmax_y - kmin_y ) / ( n_y - 1 ) ; % Facteur 2 car ky>=0
Kp_X = kmin_x : pask_x : kmax_x  ; % kx>=0 de longueur n_x/2
Kp_Y = kmin_y : pask_y : kmax_y  ; % ky>=0 de longueur n_y/2
%
Kx = [ -fliplr(Kp_X) 1e-22 Kp_X(1:1:end-1) ] ; % Ajout du zero -> 1e-22 en single
Ky = [ -fliplr(Kp_Y) 1e-22 Kp_Y(1:1:end-1) ] ; % Ajout du zero -> 1e-22 en single
%'A FAIRE PEUT-ETRE APRES LE CALCUL DU SPECTRE...'
%
clear Kp_X Kp_Y

% Vecteurs abscisses selon x et y 
xmax = 1 / pask_x ; xpas = xmax / n_x ;
ymax = 1 / pask_y ; ypas = ymax / n_y ;
%
X = -xmax/2 : xpas : xmax/2 - xpas ; % Vecteur dual de kx
Y = -ymax/2 : ypas : ymax/2 - ypas ; % Vecteur dual de ky
%
X = X * ( 2*pi ) ; % (2*pi) car Matlab prend exp(j*2*pi*kx*x) au lieu de exp(j*kx*x)
Y = Y * ( 2*pi ) ; % (2*pi) car Matlab prend exp(j*2*pi*ky*y) au lieu de exp(j*ky*y)
%
lx_gen = X(end)-X(1) + X(2)-X(1) ;
% ly_gen = Y(end)-Y(1) + Y(2)-Y(1) ;

% Calcul (...) du spectre
fprintf('Sea surface: Computation of Elfouhaily et al. spectrum: \n') ;
[ KKy , KKx ] = meshgrid( Ky , Kx ) ;
KK = sqrt(KKx.^2 + KKy.^2) ;
%
% omg = 0.84 ; % mer supposee completement developpee - A VERIFIER
% % MM_KXKY = elfo_tot( u10 , KK , omega ) ; % Partie isotrope   du spectre
% MM_KXKY = elfo_tot( u10 , double(KK) , omg ) ; % Partie isotrope   du spectre
% DD_KXKY = elfo_ang( u10 , KK , omg ) ; % Partie anisotrope du spectre
%
MM_KXKY = f_SpectrumSea_IsoFetch_Elfouhaily( double(u10) , double(KK) , double(fetch_m) , [] ) ; 
if prec == 1 % Single precision 
    % MM_KXKY = single(MM_KXKY) ; 
end
[~, DD_KXKY] = f_SpectrumSea_AngFetch_Elfouhaily( u10 , phiw_d , KK , fetch_m , [] )  ;
%
fprintf('End of spectrum computation \n') ;
%
%     COs2Phi = cos(2 * phi0_d*pi/180) ;
% COs2Phi = (KKX.^2-KKY.^2) ./ KK.^2 ;
%     COs2Phi = 1 ;
% %
% SGn_atan = zeros(size(KKX))-7 ;
% C1 = find(KKX>=0) ;
% C2 = find(KKX< 0 & KKY>=0) ;
% C3 = find(KKX< 0 & KKY< 0) ;
% if ~isempty(C1)
%     SGn_atan(C1) = 0 ;
% end
% if ~isempty(C2)
%     SGn_atan(C2) = +1 ;
% end
% if ~isempty(C3)
%     SGn_atan(C3) = -1 ;
% end
% %
% PHiObs_r = atan(KKY./KKX) + SGn_atan*pi ;
% PHi_r = PHiObs_r - phi0_d*pi/180 ;
% COs2Phi_ = cos(2*PHi_r) ;
% %
COs2PhiObs = (KKx.^2-KKy.^2) ./ KK.^2 ;
SIn2PhiObs = 2*KKx.*KKy ./ KK.^2 ;
COs2Phi = COs2PhiObs*cos(2*phiw_d*pi/180) + SIn2PhiObs*sin(2*phiw_d*pi/180) ;
% TT = abs((COs2Phi_-COs2Phi)./COs2Phi_)*100 ;
% TT(1,2:10)
% pause
clear COs2PhiObs SIn2PhiObs %KKX KKY
%
SP_KXKY = MM_KXKY .* (1+COs2Phi.*DD_KXKY)./(2*pi) ; % ATTENTION JACOBIEN TRANSFORMATION... 1/K
% SP_KXKY = MM_KXKY./(2*pi) ;
%
SP_KXKY = SP_KXKY ./ KK ; 

% Vérifications :
%
sh_CM = 6.29e-3 * u10^2.02 ;
sh_Elfo0 = sqrt( trapz(Ky,trapz(Kx,SP_KXKY)) ) ;
sh_Elfo1 = sqrt( trapz(Ky,trapz(Kx, MM_KXKY  .* (1+COs2Phi.*DD_KXKY )./(2*pi * KK))) ) ;
Sh___CM_Elfo0_Elfo1 = [ sh_CM sh_Elfo0 sh_Elfo1 ] 
COsCarrePhi = KKx.^2 ./ KK.^2 ;
SInCarrePhi = KKy.^2 ./ KK.^2 ;
% u12 = log(12.5)/log(10) * u10 ; % A VERIFIER - /!\ FAUX /!\
z0 = 3e-3 ;
u12 = log(12.5/z0)/log(10/z0) * u10 ; % d'après [2012_Wang_TGRS,eq36] => 1.0823
spx_CM_ = sqrt(3.16e-3 * u12) ;
spx_Elfo0 = sqrt( trapz(Ky,trapz(Kx,SP_KXKY./1.*KK.^2.*COsCarrePhi)) ) ; % Voir These Christophe, eq. I.85
spx_Elfo1 = sqrt( trapz(Ky,trapz(Kx,MM_KXKY  .* (1+COs2Phi.*DD_KXKY )./(2*pi).*KK.*COsCarrePhi)) ) ; % Voir These Christophe, eq. I.85
Spx___CM_Elfo0_Elfo1 = [ spx_CM_ spx_Elfo0 spx_Elfo1 ] 
spy_CM_ = sqrt(1.92e-3 * u12 + 3e-3) ;
spy_Elfo0 = sqrt( trapz(Ky,trapz(Kx,SP_KXKY./1.*KK.^2.*SInCarrePhi)) ) ; % Voir These Christophe, eq. I.85
spy_Elfo1 = sqrt( trapz(Ky,trapz(Kx,MM_KXKY  .* (1+COs2Phi.*DD_KXKY )./(2*pi).*KK.*SInCarrePhi)) ) ; % Voir These Christophe, eq. I.85
Spy___CM_Elfo0_Elfo1 = [ spy_CM_ spy_Elfo0 spy_Elfo1 ] 
%
% sh_Elfo = sqrt( trapz(KY,trapz(KX,SP_KXKY)) ) /(1) ;
% sh_CM = 6.29e-3 * u10^2.02 ;
% Sh_CM_Elfo = [sh_CM sh_Elfo] 
% %     sh_Elfo = sqrt( trapz(KY,trapz(KX,MM_KXKY./KK)) / (2*pi) )
% COsCarrePhi = KKX.^2 ./ KK.^2 ;
% SInCarrePhi = KKY.^2 ./ KK.^2 ;
% spx_Elfo = sqrt( trapz(KY,trapz(KX,SP_KXKY./1.*KK.^2.*COsCarrePhi)) ) ; % Voir These Christophe, eq. I.85
% spy_Elfo = sqrt( trapz(KY,trapz(KX,SP_KXKY./1.*KK.^2.*SInCarrePhi)) ) ; % Voir These Christophe, eq. I.85
% % spx_Elfo = sqrt( trapz(KY,trapz(KX,SP_KXKY./KK.*KK.^2.*COsCarrePhi)) ) ; % Voir These Christophe, eq. I.85
% % spy_Elfo = sqrt( trapz(KY,trapz(KX,SP_KXKY./KK.*KK.^2.*SInCarrePhi)) ) ; % Voir These Christophe, eq. I.85
% % u12 = log(12.5)/log(10) * u10 ; % A VERIFIER - /!\ FAUX /!\
% z0 = 3e-3 ;
% u12 = log(12.5/z0)/log(10/z0) * u10 ; % d'après [2012_Wang_TGRS,eq36] => 1.0823
% spx_CM_ = sqrt(3.16e-3 * u12) ;
% spy_CM_ = sqrt(1.92e-3 * u12 + 3e-3) ;
% SpX_CM_Elfo = [spx_CM_ spx_Elfo] 
% SpY_CM_Elfo = [spy_CM_ spy_Elfo] 

%Libération de mémoire : effacer toutes les matrices 2D inutiles :
clear COsCarrePhi SInCarrePhi COs2Phi DD_KXKY MM_KXKY KK KKx KKy DD_KXKY2 MM_KXKY2
% Voir aussi l'aide Matlab...
% whos
% pause



% Generation de la surface

% Generation du bruit blanc Gaussien HERMITIEN, centre de variance unitaire
fprintf('Génération BBG hermitien \n') ;
% randn('seed',double(sd))     ; BR = randn([n_x n_y]) ; 
% randn('seed',double(sd+100)) ; BI = randn([n_x n_y]) ; 
% rng(double(sd),'v4')     ; BR = randn([n_x n_y]) ; 
% rng(double(sd+100),'v4') ; BI = randn([n_x n_y]) ; 
rng((sd)) ; BR = randn([n_x n_y]) ;
rng((sd+100)) ; BI = randn([n_x n_y]) ;

B0 = BR + 1i * BI ;
clear BR BI
BH = zeros( [ n_x n_y ] ) ;

for ix = 2 : 1 : n_x
    for iy = 2 : 1 : n_y
        BH(ix,iy) = 0.5 * ( B0(ix,iy) + conj(B0(n_x+2-ix,n_y+2-iy)) ) ;
    end
end
%
clear B0
% whos
% pause

% Constante de normalisation de la ifft
fprintf('Constante de normalisation de la IFFT2 \n') ;
Nor_X = (-1) .^ (0:1:n_x-1) ; % Provient du decalage de n_x/2 => dephasage de exp(j*pi*n_x)=cos(pi*n_x)
Nor_Y = (-1) .^ (0:1:n_y-1) ; % Provient du decalage de n_y/2 => dephasage de exp(j*pi*n_y)=cos(pi*n_y)
[ NOr_Y , NOr_X ] = meshgrid( Nor_Y , Nor_X ) ;
clear Nor_X Nor_Y
NOr_XY = NOr_X .* NOr_Y ;
NOr_XY = NOr_XY * n_x * n_y * sqrt( pask_x * pask_y ) ; % Normalisation imposee par Matlab
%
clear NOr_X NOr_Y



% Surface
fprintf('Calcul de la IFFT2 \n') ;
HH_KXKY = sqrt(SP_KXKY) .* BH ;
clear BH
HH_XY = NOr_XY .* ifft2(HH_KXKY , n_x , n_y ) ;
clear HH_KXKY

%clear KK KKx KKy MM_KXKY DD_KXKY COs2PhiObs SIn2PhiObs
%clear BH HH_KXKY NOr_X NOr_Y

HH_XY = real(HH_XY) ; % La partie imaginaire est NULLE

% whos
%Libération de mémoire : effacer toutes les matrices 2D inutiles :
% clear NOR_XY
% clear HH_KXKY
% Voir aussi l'aide Matlab...
