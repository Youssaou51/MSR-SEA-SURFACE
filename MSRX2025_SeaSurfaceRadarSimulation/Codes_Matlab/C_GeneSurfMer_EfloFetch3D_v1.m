%% Program which generates a (2D) sea surface (i.e. 3D problems) by using 
% the Elfouhaily et al. spectrum model (isotropic + anisotropic parts) and 
% by taking the fetch into account 

clear variables; clc; close all;
format short; format compact;

% Ajout du chemin vers les fonctions 
addpath(genpath(cd));


%% Input parameters: 

u10_ms = 3 ; % Wind speed at 10 m above sea surface mean level (m) 
phWind_d = 0 ; % Wind direction (angle between LOS (Line Of Sight) and wind direction (deg.) 
fetch_m = 500e3 ; % Fetch = length of water over which a given wind has blown without obstruction (m) 
% 
lx_sea_m = 40 ; % Length of sea surface to be generated - in x direction (m) 
ly_sea_m = 30 ; % Length of sea surface to be generated - in y direction (m) 
freq_GHz = 1.3 ; % Radar frequency (GHz) 
nlb0 = 8 ; % Number of sampling steps per EM wavelength (-) 


%% Simple calculations: 

% Calculate the EM wavelength in vacuum based on the radar frequency: 
c_ms = 3e8; % Speed of light in vacuum (m/s) - APPROXIMATE value 
% c_ms = 299792458; % Speed of light in vacuum (m/s) - EXACT value 
lb0_m = c_ms / (freq_GHz * 1e9); % EM wavelength (m) 
%
dxy_m = lb0_m / nlb0 ; % Surface sampling step (m) - taken identical in x and y directions 


%% Check if the length of the sea surface meets the minimum condition 
% Constants:
g = 9.81 ; % acceleration due to gravity (m/s^2)
x0 = 2.2e4 ; % in m [1997_Elfouhaily_JGR,eq.37]
% General relations:
k0 = g / u10_ms^2 ; % in rad/m
xmaj = k0 * fetch_m ; % dimensionless [1997_Elfouhaily_JGR,below-eq.4]
omgc = 0.84 * tanh( (xmaj/x0)^0.4 ).^-0.75 ; % [1997_Elfouhaily_JGR,eq.37]
kp = k0 * omgc^2 ; % in rad/m [1997_Elfouhaily_JGR,below-eq.3]
%
kmin = 0.3 * kp ; % [Pinel_2014_TGRS]
lmin = 2*pi / kmin ; 
%
if lx_sea_m < lmin || ly_sea_m < lmin 
    warning('The length of the sea surface (in x or y direction) is not long enough to include all the gravity waves') ; 
end


%% Resolution of sea surface: 

% Adjustment of surface sampling step such that lx_sea_m/dxy_m is integer: 
nsamples_x = round(lx_sea_m/dxy_m/2)*2 ; 
nsamples_y = round(ly_sea_m/dxy_m/2)*2 ; 
dxRes_m = lx_sea_m/nsamples_x ; 
dyRes_m = ly_sea_m/nsamples_y ; 
%
Res = [ dxRes_m  dyRes_m ] ; 



%% Sea surface generation by Matlab Radar toolbox: 
% https://fr.mathworks.com/help/releases/R2025b/radar/ref/seasurface.seasurface.html 
% https://fr.mathworks.com/help/radar/ug/simulating-radar-returns-from-moving-sea-surfaces.html 

tic 
scene = radarScenario ; 
rng('default') ; 
% spec = seaSpectrum ; % Sea surface omnidirectional motion spectrum model 
spec = seaSpectrum('Resolution',Res) ; % Sea surface omnidirectional motion spectrum model 
Bnds = [ 0 lx_sea_m ; 0 ly_sea_m ] ; % Define boundary for the sea surface generation 
% Adds the sea surface with specified parameters ot the radar scenario: 
srf = seaSurface(scene, 'Boundary', Bnds, 'WindSpeed', u10_ms, 'Fetch', fetch_m, 'SpectralModel', spec) ; 
%
Xl = linspace(srf.Boundary(1,1),srf.Boundary(1,2),nsamples_x) ; 
Yl = linspace(srf.Boundary(2,1),srf.Boundary(2,2),nsamples_y) ; 
[XX,YY] = meshgrid(Xl,Yl) ;
% X1 = XX(:)' ; 
% Y1 = YY(:)' ; 
% hts = height(srf,[Y1;X1]) ; 
hts = height(srf,[YY(:)';XX(:)']) ; 
hts = reshape(hts,length(Xl),length(Yl)) ; 
toc 

figure(1) ; clf ; 
surf(Yl,Xl,hts) ; 
axis equal ; shading interp ; colorbar ; 
xlabel('Y (m)') ; ylabel('X (m)') ; zlabel('Height (m)') ; 



%% Sea surface generation by using my own function: 

% tic 
% [ HH_XY , X , Y ] = ... % [ HH_XY , X , Y , SP_KXKY , KX , KY , NOR_XY ] = ...
%     f_GeneSurfMer3D_Fetch_Elfo_Mofrem1 ( u10_ms , phWind_d , lx_sea_m , ly_sea_m , nsamples_x , nsamples_y , 1 , 0 , fetch_m ) ; 
% toc 
%
tic 
[ HH_XY , X , Y ] = ... % [ HH_XY , X , Y , SP_KXKY , KX , KY , NOR_XY ] = ...
    f_GeneSurfMer3D_Fetch_Elfo_v1 ( u10_ms , phWind_d , lx_sea_m , ly_sea_m , nsamples_x , nsamples_y , 1 , 2 , fetch_m ) ; 
toc 


pasy = 1 ; 
pasx = 1 ; 
% A modifier : augmenter le pas quand le nombre d'échantillons dépasse 1024, par exemple : 
% TO BE DONE 

figure(2) ; clf ; 
surf(Y(1:pasy:end),X(1:pasx:end),HH_XY(1:pasx:end,1:pasy:end)) ; 
axis equal ; shading interp ; colorbar ; 
xlabel('Y (m)') ; ylabel('X (m)') ; zlabel('Height (m)') ; 

