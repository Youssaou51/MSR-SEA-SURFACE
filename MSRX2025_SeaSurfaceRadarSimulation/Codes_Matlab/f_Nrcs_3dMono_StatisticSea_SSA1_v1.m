function [Nrcs_Mdl_VV, Nrcs_Mdl_HH, A_mono, B1mono_VV, Ans0, Ans2] = f_Nrcs_3dMono_StatisticSea_SSA1_v1 (Th_i_d, phi_rel_d, er2, u_10, omg, k0, r_max, aff) 

%--------------------------------------------------------------------------
% FUNCTION : f_Nrcs_3dMono_StatisticSea_SSA1_v1
%--------------------------------------------------------------------------
% Calculates the backscattering normalized radar cross section (NRCS, also 
% called scattering coefficient) of a (2D) surface for 3D problems, 
% in VV and HH polarizations, with respect to 1st-order Small-Slope 
% Approximation (SSA1) model, 
% whose sea surface height spectrum is the directional Elfouhaily spectrum 
% for fully-developped seas with input parameters u_10 and omega_D (omg here)
%--------------------------------------------------------------------------
% Input variables:
% Th_i_d: Incidence elevation angle with respect to the vertical z (deg.) [Vector]
% phi_rel_d : Radar direction relative to the wind direction (deg.) [scalar]
% er2   : Relative permittivity of transmission (lower) medium [salar]
% u_10  : Wind speed at 10 m above the sea surface (m/s) [scalar]
% omg   : Inverse of the age of the wave Omega [scalar]
% k0    : Electromagnetic wavenumber (rad/m) [scalar]
% r_max : Maximal radial distance value for numerical integration over r (m?) [scalar]
% aff   : Choice not to plot anything (=0), to plot only the correlation
% functions W0_r & W2_r (=1), or also the integrands (~=0) [scalar] 
%--------------------------------------------------------------------------
% Output variables:
% Nrcs_Mdl_VV : NRCS under considered model in VV polarization [Vector - lin. scale]
% Nrcs_Mdl_HH : NRCS under considered model in HH polarization [Vector - lin. scale]
%--------------------------------------------------------------------------
% COMMENTS:
% V = TM = p = //
% H = TE = s = \perp
% tan, cos, sin, ... are better coded than tand, cosd, sind, ...
%--------------------------------------------------------------------------
% Called functions:
% Exp_BesselIn (inside this program - see end) 
% (besseli - bulit-in Matlab function) 
%--------------------------------------------------------------------------
% Nicolas PINEL - PhD, 2025-11 
%--------------------------------------------------------------------------

% Simple relationships and constants: 
pas_nr = 1 ; 
% c_ms = 299792458 ; % Celerity of light (m/s)
c_ms = 3e8 ; % Celerity of light (m/s)
f0_Hz = 3e9 ;
u0_10 = 5 ;


% Q_0 is the absolute value of the vertical projection of the incident
% wavevector (rad/m): 
Q_0 = k0 * cos( Th_i_d * pi/180 ) ; % [Bourlier_2009_WRCM,section2.1]
% Square of the horizontal projection of the incident wavevector: 
K02 = k0^2 - Q_0.^2 ; % [Bourlier_2009_WRCM,eq.59] 
% K02 = k0^2 * sin( Th_i_d * pi/180 ).^2 ; 
% Qp0 is the absolute value of the vertical projection of the scattered
% wavevector (rad/m): 
Qp0 = sqrt( er2*k0^2 - K02 ) ; % [Bourlier_2009_WRCM,eq.59] 


% Dimensionless elements of the SPM1 polarization matrix: 
B1mono_VV = (1-er2) * (Qp0.^2+er2*K02) ./ (er2*Q_0+Qp0).^2 ; % [Bourlier_2009_WRCM,eq.57] 
B1mono_HH = (er2-1) * k0^2 ./ (Q_0+Qp0).^2 ; % [Bourlier_2009_WRCM,eq.57] 
B1mono_VV = B1mono_VV .* (+2*Q_0.^2) ; % Constant that goes from Voronovich to Elfouhaily convention [2004_Elfouhaily_WRM_B(Topical Review),below_eq.3.9] 
B1mono_HH = B1mono_HH .* (+2*Q_0.^2) ; % Constant that goes from Voronovich to Elfouhaily convention [2004_Elfouhaily_WRM_B(Topical Review),below_eq.3.9] 


f_Hz = k0*c_ms/(2*pi) ; 
r_max_fu10 = r_max * (f0_Hz/f_Hz) * (u0_10/u_10) 
%
% Loading of autocorrelation functions (directory FCTS_NUMQ_BOURLIER_ETC): 
disp('Loading of the file of autocorrelation function:') ; 
disp('(If not available, please use the file Cal_FonctionCorrelation2D_Mer_v3b.m to create it.)') ;
% Nom = [ 'REI_Fonctions_Correlation_2D_Mer_' num2str(u_10) '.mat' ] ; 
Nom = [ 'SeaSurf_2dCorrFcts_omg' num2str(omg) '_ud' num2str(u_10) 'ms' ] ; 
Nom(Nom=='.') = '-' ; Nom = [ Nom '.mat' ] ;
C = load(Nom, 'u_10','R','W0_r','W2_r') ; % u_10, R, W0_r, W2_r, K, W0_k and W2_k 


%% Display of autocorrelation function and spectrum: 

if aff == 1
    taille = 18 ; 
    h = figure(101) ; clf ; hold on ; grid on ; 
    plot(C.R,C.W0_r/C.W0_r(1),'k','LineWidth',2) ; 
    plot(C.R,C.W2_r/C.W0_r(1),'r--','LineWidth',2) ; 
    axis([1e-2 max(C.R) -0.4 1]) ; 
    set(gca,'Xscale','log') ; set(gca,'ytick',-0.4:0.2:1) ; set(gca,'FontSize',taille-2) ; 
    xlabel('Radial distance r (m)','FontSize',taille) ; 
    ylabel('Normalised autotrrelation function','FontSize',taille) ; 
    hl = legend('W_0(r)/W_0(1)','W_2(r)/W_0(1)') ; set(hl,'FontSize',taille-2) ; 
    %
    disp('Press enter') ; 
    disp(' < PAUSE > ') ; 
    pause ; 
    %close(h) ; 
end


%% Loop on incidence angle Th_i_d 

% sh_FetchInf = 6.29e-3 * u_10^2.02 ; % [Pinel_2006_These,eq.1.70][Bourlier_2002_PIER,below_eq.23][Bourlier_2000_PIER,Tab.1.3&eq.1.44]
sh2_FetchInf = 3.953e-5 * u_10^4.04  % [Pinel_2006_These,eq.1.70][Bourlier_2002_PIER,below_eq.23][Bourlier_2000_PIER,Tab.1.3&eq.1.44]
sigma_h2 = C.W0_r(1) 
%
sh2 = sigma_h2 ; 


Ans0 = zeros(size(Th_i_d)) ;
Ans2 = zeros(size(Th_i_d)) ;
%
for i_t = 1 : 1 : length(Th_i_d) % Loop on Th_i_d 
    th_d = Th_i_d(i_t) ;
    % disp(['   - Incidence angle: ' num2str(th_d) '°' ]) ;

    % Vector of integration along r: 
    ri_max = r_max_fu10 / cos(th_d*pi/180) ;
    I_ = find(C.R >= ri_max) ; 
    if ~isempty(I_)
        Ii = 1 : pas_nr : I_(1) ;
    else
        Ii = 1 : pas_nr : length(C.R) ;
    end
    Ri = C.R(Ii) ; 
    W0_ri = C.W0_r(Ii) ;
    W2_ri = C.W2_r(Ii) ;

    % Bessel functions J0 and J2 (Bragg wavenumber kB = 2*k0*sind(th_d) [Bourlier_2009_WRCM,below_eq.26]): 
    J_0 = besselj( 0 , 2*k0*sin(th_d*pi/180) * Ri ) ; % [Bourlier_2009_WRCM,below_eq.28] 
    J_2 = besselj( 2 , 2*k0*sin(th_d*pi/180) * Ri ) ; % [Bourlier_2009_WRCM,below_eq.28] 
    % Bessel functions I0 and I1: 
    A0_ri = 4 * Q_0(i_t)^2 * (sh2-W0_ri) ; 
    A2_ri = 4 * Q_0(i_t)^2 * W2_ri ; 
    Exp_I0 = Exp_BesselIn( 0 , A0_ri  , A2_ri ) ; 
    % Exp_I0_2 = exp(-A0_ri) .* besseli(0,A2_ri) ; 
    % Exp_I0 - Exp_I0_2 
    % Exp_I0 = exp(-A0_ri) ; 
    Exp_I1 = Exp_BesselIn( 1 , A0_ri  , A2_ri ) ; 

    % Integrations along r: 
    Int0 = Ri .* J_0 .* ( Exp_I0 - exp( -4 * Q_0(i_t)^2 * sh2 ) ) ; % [Bourlier_2009_WRCM,below_eq.28] 
    Int2 = Ri .* J_2 .* Exp_I1 * 2 ; % [Bourlier_2009_WRCM,below_eq.28] 
    Ans0(i_t) = trapz( Ri , Int0 ) ; % [Bourlier_2009_WRCM,below_eq.28] 
    Ans2(i_t) = trapz( Ri , Int2 ) ; % [Bourlier_2009_WRCM,below_eq.28] 


    if aff ~= 0 % Plotting of the integrands 
        % With respect to r
        figure(102) ; clf ; taille = 12 ;
        subplot(2,1,1) ; hold on ; grid on ; plot(Ri,Int0,'k','LineWidth',3) ; 
        subplot(2,1,2) ; hold on ; grid on ; plot(Ri,Int2,'k','LineWidth',3) ; 
        LEG1(1,:) = '11   ' ;
        %
        for i_s = 1 : 1 : 2
            subplot(2,1,i_s)
            xlim([1e-4 max(Ri)]) ;
            set(gca,'Xscale','log') ; set(gca,'FontSize',taille-2) ; 
            xlabel('Radial distance in m','FontSize',taille)
            ylabel('Integrands','FontSize',taille) 
            hl = legend(LEG1) ; set(hl,'FontSize',taille-2)
            Titre = [ 'n = ' num2str((i_s-1)*2) ', Polar HH and \theta = ' num2str(th_d) '°' ] ;
            ht = title(Titre) ;  set(ht,'FontSize',taille+1,'FontWeight','bold')
        end
        %
        disp('Press enter') ; 
        disp('< PAUSE >') ;
        pause
    end


end % End of loop on Th_i_d


A_mono = 1 ./ ( 4 * pi * Q_0.^2 ) ; % [Bourlier_2009_WRCM,above_eq.23] 
Sig11_0_VV = 2*pi*A_mono .* abs(B1mono_VV).^2 .* Ans0 ; % [Bourlier_2009_WRCM,below_eq.28] 
Sig11_2_VV = 2*pi*A_mono .* abs(B1mono_VV).^2 .* Ans2 ; % [Bourlier_2009_WRCM,below_eq.28] 
Sig11_0_HH = 2*pi*A_mono .* abs(B1mono_HH).^2 .* Ans0 ; % [Bourlier_2009_WRCM,below_eq.28] 
Sig11_2_HH = 2*pi*A_mono .* abs(B1mono_HH).^2 .* Ans2 ; % [Bourlier_2009_WRCM,below_eq.28] 
%
% [Bourlier_2009_WRCM,eq.23]: 
Nrcs_Mdl_VV = Sig11_0_VV + Sig11_2_VV * cos( 2 * phi_rel_d * pi/180 ) ; 
Nrcs_Mdl_HH = Sig11_0_HH + Sig11_2_HH * cos( 2 * phi_rel_d * pi/180 ) ; 


%--------------------------------------------------------------------------
% FUNCTION Exp_BesselIn: 
% Function which computes exp(-A) * I_n(B), with I_n(B) = besseli(n,B) 
% For B >>1, the function converges if A > B; then, 
% A (power series?) expansion of I_n(B) is used (Abramowitz 9.7.1)
%--------------------------------------------------------------------------
% n : Equation order of besseli [scalar]
% A : Vector
% B : Vector with SAME dimension as B
%--------------------------------------------------------------------------
% Called functions: 
% (besseli - bulit-in Matlab function)
%--------------------------------------------------------------------------
% C. Bourlier, 02/12/2008 
% N. Pinel, 2025-11 
%--------------------------------------------------------------------------

function res = Exp_BesselIn( n , A , B )

res = zeros( size(A) ) ;
Gg = find( B >  20 ) ; %' Case where b >  20 ' ;
Pp = find( B <= 20 ) ; %' Case where b <= 20 ' ;

if ~isempty(Pp)
	Ap = A(Pp) ;
	Bp = B(Pp) ;
	res(Pp) = exp(-Ap) .* besseli(n,Bp) ;
end

if ~isempty(Gg)
	Ag = A(Gg) ;
	Bg = B(Gg) ;
	mu   = 4 * n^2 ;
	ansg = 1 - (mu-1)./(8*Bg) + (mu-1)*(mu-9)./(2*(8*Bg).^2) - (mu-1)*(mu-9)*(mu-25)./(6*(8*Bg).^3) ;
	res(Gg) = ansg .* exp(Bg-Ag) ./ sqrt(2*pi*Bg)  ; 
end

