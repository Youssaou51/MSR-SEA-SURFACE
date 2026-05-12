function [ H , X_h , S_K , K , ls_gen , k_min , k_max ] = ...
    f_GeneSurfMer2D_ElfoGauss_Fetch_v2 ( u10 , l_s , n_s , sd , fetch_m , prec ) 

%--------------------------------------------------------------------------
% FUNCTION: f_GeneSurfMer2D_ElfoGauss_Fetch_v2
%--------------------------------------------------------------------------
% Generates a 1D surface (2D problems) of Gaussian statistics (height PDF)
% and whose surface height spectrum is a sea spectrum,
% according to the model of Elfouhaily et al. [Elfouhaily_1997_JGR]
% This model takes into account both the gravity and capillary waves, 
% and takes the fetch into account
% NOTA BENE: n_s SHOULD (must?) be a power of 2 for the ifft
% Bonus: also calculates the autocorrelation function (= FT of spectrum)
%--------------------------------------------------------------------------
% Input variables:
% u10      : Wind speed at 10 m above the sea surface (m/s) [scalar]
% l_s       : Desired length of generated surface (m) [scalar]
% n_s       : (Power-of-2) number of samples of the surface [scalar]
% sd        : Seed of the generated white Gaussian noise (-) [scalar]
% fetch_m   : Fetch = length of action of wind on the sea (m) [scalar]
% prec  : Precision of the calculation (1=single or 2=double) [scalar]
%--------------------------------------------------------------------------
% Output variables:
% H     : Heights of the sea surface (m) [Vector]
% X_h   : Abscissas associated to H (m) [Vector]
% S_K   : Surface height spectrum (dimensionless) [Vector]
% K     : Abscissas associated to S_K (rad/m) [Vector]
% ls_gen: Actual length of generated surface (m) (scalar)
% k_min : Calculated minimum surface wavenumber (rad/m) (scalar)
% k_max : Calculated maximum surface wavenumber (rad/m) (scalar)
%--------------------------------------------------------------------------
% COMMENTS:
% prec option has been added in order to handle large surfaces 
%--------------------------------------------------------------------------
% Called functions:
% f_SpectrumSea_IsoFetch_Elfouhaily
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 2025-12 
%--------------------------------------------------------------------------


%% Test of the number of samples: 

if pow2(nextpow2(n_s)) ~= n_s
    warning('You should rather provide a power of 2 for the number of surface samples n_s!') ; 
    % return ;
end
%
if rem(n_s,2)
    warning('This version does not handle an odd number of samples => +1') ; 
    n_s = n_s + 1 ; 
    % return 
end
%
if prec == 1 % Single precision 
    % Force single precision => induced computed variables should also have
    % single precision: 
    l_s = single(l_s) ; 
    n_s = single(n_s) ; 
    %
    u10 = single(u10) ; 
    sd = single(sd) ; 
    % prec = single(prec) ; 
    fetch_m = single(fetch_m) ; 
end


%% Construction of the surface wavenumber vector K: 

% Construction of the positive part Kp for loading the positive spectrum S_Kp:
k_min = 2*pi / l_s ; % Minimum wavenumber of the surface spectrum along x for kx >= 0 [rad/m]
% dt_x = l_s / (n_s-0) ;
% k_max = 2*pi / (2*dt_x) ; % Maximum wavenumber of the surface spectrum along x for kx >= 0 - SHANNON => /2 [rad/m]
k_max = pi*n_s / l_s ; % Maximum wavenumber of the surface spectrum along x for kx >= 0 - SHANNON => /2 [rad/m]
dt_k = 2 * (k_max-k_min) / (n_s-1) ; % Factor 2 because kx >= 0 
K_pos = k_min : dt_k : k_max ; % kx >= 0 of length n_x/2 [rad/m]

% % Loading of the sea surface spectrum (Elfouhaily et al. model [1997_Elfouhaily_JGR]):
% S_Kp = 1/2 * f_SpectreMer_IsoFetch_Elfouhaily( u_10 , K_pos , fetch_m , [] ) ; % 1/2 factor in the calculation of the specrum because K will take both positive and negative values
% % S_Kp = f_SpectrumSea_IsoFetch_Elfouhaily( double(u_10) , double(Kp) , double(fetch_m) , [] ) ; 

% Construction of the two-sided (positive and negative) wavenumber and spectrum vectors:
K   = [ -fliplr(K_pos) 1e-22 K_pos(1:end-1) ] ; % As required for ifft by Matlab: goes from -k_max to +k_max-dt_k % Addition of zero -> 1e-22 in single precision
% S_K = [ +fliplr(S_Kp ) 1e-22  S_Kp(1:end-1) ] ; % As required for ifft by Matlab: goes from -k_max to +k_max-dt_k % Addition of zero -> 1e-22 in single precision
% 'A FAIRE PEUT-ETRE APRES LE CALCUL DU SPECTRE...' 
clear K_pos 

% Computation of the sea surface height spectrum (Elfouhaily et al. model [Elfouhaily_1997_JGR]): 
% fprintf('Sea surface: Computation of Elfouhaily et al. spectrum... \n') ;
% S_K = f_SpectreMer_IsoFetch_Elfouhaily( u10 , K , fetch_m , [] ) ; 
S_K = f_SpectrumSea_IsoFetch_Elfouhaily( double(u10) , double(K) , double(fetch_m) , [] ) ; 
S_K = S_K / 2 ; % /!\ MODIFICATION FOR 2D PROBLEMS (1D SURFACES) /!\ 
%
% Case K = 0: 
S_K(K==0) = 0 ; 
if ~isempty( find(isnan(S_K), 1) ) 
    warning('S_K has NaN values') ; 
end
%
% whos


%% Generation of the Gaussian white noise (CODE PROVIDED BY C. BOURLIER): 

% randn('seed',sd) ; % Old version 
% % rng((sd)) ; % New version - BUT sometimes returns an error! 
% B0  = randn( size(K) ) ; % Generation of Gaussian white noise, centred, with unit variance 
% %
% Bc_p = ( B0(1:2:n_s-1) + 1i*B0(2:2:n_s) ) / sqrt(2) ;
% % Bc_m = fliplr( conj(Bc_p) ) ;
% % B    = [ Bc_m Bc_p(n_s/2) Bc_p(1:1:n_s/2-1) ] ;
% B    = [ fliplr(conj(Bc_p)) Bc_p(n_s/2) Bc_p(1:1:n_s/2-1) ] ;
% 
% % Normalization constant of the ifft (CODE PROVIDED BY C. BOURLIER):
% Nrmlz = (-1) .^ (0:1:n_s-1) ;  % comes from the shift of n_s/2 => phase shift of exp(1i*pi*n_s) = cos(pi*n_s)
% f_e = (2*dt_k) / (2*pi) ;
% Nrmlz = Nrmlz * sqrt(2*pi*f_e) ; % ifft in exp(2*pi * j*f*x) instead of exp(j*k*x)
% Nrmlz = Nrmlz * n_s ; % normalization imposed by Matlab
% 
% % Generation of the surface heights H (CODE PROVIDED BY C. BOURLIER):
% H  = Nrmlz .* real( ifft(sqrt(S_K).*B , n_s) ) ;
% find(isnan(H)) 
% 
% 
% % Construction of the vector of the abscissas associated to H:
% dt_x = l_s / (n_s-0) ; 
% X_h = 0 : dt_x : (n_s-1)*dt_x ; % by construction of ifft by Matlab, X ranges from 0 to (n_s-1)*dt_x by a step of dt_x
% %
% ls_gen = X_h(end) - X_h(1) ;
% %
% % l_x_h = [ length(X_h) length(H_h) ] 
% 
% 
% % See also [Gamper_2018_MsThesis,eq.3.35] 
% %
% whos 


%% Code de C. Bourlier dans la fonction F_Surface_Generation : 

% Complex Hermitian Gaussian white noise
randn('seed',sd) ; % rng(sd) ; 
B = randn(n_s,1) ;
Bc = B(1:2:n_s-3) + 1i*B(2:2:n_s-2) ;
Bi = [ Bc ; B(n_s-1) ; conj(fliplr(Bc)) ; B(n_s) ] ;
K = 2*pi*(-n_s/2+1:1:n_s/2)/l_s ;
%
% S = S_K * 2*pi ; 
Sz = sqrt(l_s*S_K * 2*pi) ;
Sz = Sz .* Bi.' ;
St = [ Sz(n_s/2+1:1:n_s) Sz(1:1:n_s/2) ] ;
St = [ St(n_s) St(1:1:n_s-1) ] ;
Fs = n_s*ifft(St,n_s)/l_s ;
Fs = [ Fs(2:1:n_s) Fs(1)] ;
H = [ Fs(n_s/2+1:1:n_s) Fs(1:1:n_s/2) ] ;
H = real(H) ; 
% H = H - mean(H) ;
% if isfield(Scatterer,'sigma_z') % To force the value to sigma_z
%     H = H * Scatterer.sigma_z / std(H) ;
% end
dx = l_s/n_s ;
X_h = (-n_s/2+1:1:n_s/2) * dx ; 
ls_gen = X_h(end) - X_h(1) + X_h(2)-X_h(1) ;
%
% whos 


%%

% % Normalization constant of the ifft (CODE PROVIDED BY C. BOURLIER):
% NrmlzW = (-1) .^ (0:1:n_s-1) ;  % comes from the shift of n_s/2 => phase shift of exp(1i*pi*n_s) = cos(pi*n_s)
% % f_e = (2*dt_k) / (2*pi) ;
% NrmlzW = NrmlzW * (2*pi) ; % ifft in exp(2*pi * j*f*x) instead of exp(j*k*x)
% NrmlzW = NrmlzW * f_e * n_s ; % normalization imposed by Matlab
% 
% % ifft of the spectrum (CODE PROVIDED BY C. BOURLIER):
% Wh = NrmlzW .* fftshift( ifft( S_K , n_s ) ) ;
% %
% Ws = NrmlzW .* fftshift( ifft( K.^2.*S_K , n_s ) ) ;
% 
% % Construction of the vector of the abscissas associated to W:
% X_w = -n_s/2*dt_x : dt_x : +(n_s/2-1)*dt_x ;


%% Vérifications: 

% sh_CM = 6.29e-3 * u10^2.02 ;
% sh_Elfo0 = sqrt( trapz(K,S_K) ) ;
% Sh___CM_Elfo0_Elfo1 = [ sh_CM sh_Elfo0 ] 
% %
% % z0 = 3e-3 ;
% %
% g = 9.81 ; % Acceleration due to gravity (m/s^2) 
% x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]
% km = 370 ; % in rad/m [1997_Elfouhaily_JGR,eq.24]
% k0_surf = g / u10^2 ; % in rad/m
% xmaj = k0_surf * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4]
% omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37]
% kp = k0_surf * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
% cp = sqrt(g*(1+kp^2/km^2)/kp ) ; % Phase speed at spectral peek kp
% z0 = 3.7e-5 * u10^2/g * (u10/cp)^0.9 ; % Roughness length [1997_Elfouhaily_JGR,eq.66]
% % z0 = 3e-3 ;
% u12 = log(12.5/z0)/log(10/z0) * u10 ; % From [2012_Wang_TGRS,eq36] => 1.0823 for z0 = 3e-3 
% %
% spx_CM_ = sqrt(3.16e-3 * u12) ; 
% spx_Elfo0 = sqrt( trapz(K,S_K.*K.^2) ) ; % Voir These Christophe, eq. I.85 
% Spx___CM_Elfo0_Elfo1 = [ spx_CM_ spx_Elfo0 ] 
% 
% 
% if k_min > 0.25*kp 
%     warning('The surface is too small to represent the full spectrum (kmin should be <= 0.25*kp)') ; 
%     k_min 
%     0.25*kp 
%     % return 
% end



