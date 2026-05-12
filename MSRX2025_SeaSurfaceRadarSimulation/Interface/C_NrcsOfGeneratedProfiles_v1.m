%
%   Scattering from perfectly-conducting surface
%   Main program
%
%   Prof. Christophe BOURLIER, 2022
%   Laboratory IETR, Site of Nantes, FRANCE
%
%   Version 3: 
%   Dr. Nicolas PINEL, 2026-04


clear variables ; clc ; close all ; 
format short ; format compact ; 

%%%%%%%%%%
%% Inputs %
%%%%%%%%%%

% Input parameters for the generation of sea profiles: 
u10 = 5 ; % Wind speed at 10 m above the sea surface (m/s) 
fetch_m = 1e6 ; % Fetch = length of action of wind on the sea (m) 
l_s = 30 ; % Desired length of generated surface (m) 
f_GHz = 3 ; % Radar frequency (GHz) 
nlb0 = 8 ; % Number of samples per wavelength (-) 
prec = 2 ; % Precision of the calculation (1=single or 2=double) 
acc_fft = 0 ; % FFT acceleration (=1) or not (=0) by rounding (or not) the number of samples of the surface by a power of 2 
n_prof = 5 ; % Number of generated sea profiles (-) 

% Input parameters for the calculation of the associated NRCS: 
Polar = 'TE' ; % Either 'TE' or 'TM' polarization - TE (Dirichlet) or TM (Neumann) 
l_g = 6 ; % Ratio g/l_s (extent of the Thorsos wave) 
th_i_d = 30 ; % Incidence angle (deg.) 
%
Th_s_r = ( -90:1:90 ) * pi/180 ; % Observation angle (rad.) 


%% Constants: 

c_ms = 3e8; % Speed of light in vacuum (m/s) - Exact value: 299,792,458 
g = 9.81; % Acceleration due to gravity (m/s^2)
x0 = 2.2e4; % Constant (m) 


%% Simple calculations: 

% Preliminary calculations: 
lb0_m = c_ms / (f_GHz * 1e9) ; % EM wavelength (m)
dx_m = lb0_m / nlb0 ; % Surface sampling step (m)

% Checking the minimum surface length:
k0_s = g / u10^2 ; % in rad/m 
xmaj = k0_s * fetch_m ; % Dimensionless 
omgc = 0.84 * tanh((xmaj / x0)^0.4)^(-0.75) ; % [1997_Elfouhaily_JGR,eq.37]
kp = k0_s * omgc^2 ; % in rad/m
kmin = 0.3 * kp ; % [Pinel_2014_TGRS]
lmin = 2 * pi / kmin ; % Minimum surface length
if l_s < lmin 
    warning('The length of the sea surface is not long enough to include all gravity waves.') ; 
    %return;
end

% Adjusting the number of surface samples (must be pair, at least): 
n_s0 = round(l_s / dx_m / 2) * 2 ; 
%
if acc_fft == 1 % FFT acceleration by rounding the number of samples of the surface by a power of 2 
    n_s = pow2(round(log2(n_s0))) ; % It is not exactly the nearest power-of-2 in a linear scale, but nevermind... 
else
    n_s = n_s0 ; 
end


%% Generation of sea profile(s): 

HH = zeros(n_prof,n_s) ; 
%
for i_prof = 1 : n_prof 
    sd = i_prof ; % Seed of the generated white Gaussian noise (-) 
    [ HH(i_prof,:) , X_h , S_K , K , ls_gen , k_min , k_max ] = f_GeneSurfMer2D_ElfoGauss_Fetch_v2b ( u10 , l_s , n_s , sd , fetch_m , prec ) ; 
end




figure(1) ; clf ; hold on ; grid on ; size_ = 16 ; 
plot(X_h,HH, 'LineWidth',2.5) ; 
xlabel('x (m)','FontSize',size_) ; 
ylabel('z (m)','FontSize',size_) ; 
title('Sea surface profile(s)','FontSize',size_,'FontWeight','bold') ; 
set(gca,'FontSize',size_) ; 
X_lim_Su = -X_h(end):X_h(end)/5:X_h(end) ;
xlim([X_lim_Su(1) X_lim_Su(end)]) ; set(gca,'xtick',X_lim_Su) ; 





k0_EM = 2*pi / lb0_m ; % EM wavenumber (rad/) 
%
figure(11) ; clf ; hold on ; grid on ;
figure(21) ; clf ; hold on ; grid on ;
figure(31) ; clf ; hold on ; grid on ; 
%
for i_prof = 1 : n_prof 
    % Incident field on rough sea profile(s): 
    [ Psi_inc , i_inc ] = F_IIncidenteWave_Thorsos( th_i_d , g, k0_EM, X_h, HH(i_prof,:) ) ; 
    %
    eta_inc = 119.9169832 * pi ; % (Ohm) - valid only in the vacuum (http://en.wikipedia.org/wiki/Impedance_of_free_space)
    p_inc = i_inc / eta_inc
    pwr_inc_num = trapz(X_h , abs(Psi_inc).^2/(2*eta_inc))
    %
    % % OPTIONAL: Calculation of incident power:
    % eta_inc = 119.9169832 * pi ; % (Ohm) - valid only in the vacuum (http://en.wikipedia.org/wiki/Impedance_of_free_space)
    % n_kx = 1000 ;
    % K_x_0 = linspace(-k0, +k0, n_kx) ;
    % k_ix = k0 * sin(theta_inc * pi/180) ; % [Tsang_2000_W_vol2,eq.4.1.32]
    % Gss2 = exp( -(K_x_0-k_ix).^2 * g^2 / 4 ) ;
    % K_z_0 = sqrt(k0^2 - K_x_0.^2) ;
    % pwr_inc_tsg = g^2/(4*eta_inc*k0) * trapz(K_x_0 , K_z_0.*Gss2)  % [Tsang_2000_W_vol2,eq.4.1.45]
    %
    figure(11) ; %clf ; hold on ; grid on ;
    plot(X_h,20*log10(abs(Psi_inc)), 'LineWidth',1.5, 'DisplayName','Thorsos') ; 
    xlabel('x (m)','FontSize',size_) ; 
    ylabel('|\psi_{inc}| [dB]','FontSize',size_) ; 
    title(['Incident field \psi_{inc} (\theta_{inc} = ' num2str(th_i_d) '°)'],'FontSize',size_,'FontWeight','bold') ; 
    set(gca,'FontSize',size_) ;
    xlim([X_lim_Su(1) X_lim_Su(end)]) ; set(gca,'xtick',X_lim_Su) ; 
    Y_lim = -40:5:0 ;
    ylim([Y_lim(1) Y_lim(end)]) ; set(gca,'ytick',Y_lim) ; 
    %
    % Impedance matrix: 
    Dx = gradient(X_h) ; % Surface sampling step (m) --- Dx = dx*ones(size(X)) ; 
    DerZ = gradient(HH(i_prof,:)) ./ Dx ; % First derivative of H over X_h (-) --- DerZ = diff(Z) ; DerZ = [ DerZ(1) DerZ ]/dx ; 
    Der2Z = gradient(DerZ       ) ./ Dx ; % Second derivative of H over X_h (m^-1) --- Der2Z = diff(DerZ) ; Der2Z = [ Der2Z Der2Z(end) ]/dx ;
    V = ones(size(X_h)) ; % Sense of the surface normal (+1 or -1) (Vector) 
    tic
    ZZ = F_IImpedanceMatrices( X_h , HH(i_prof,:) , Dx , DerZ , Der2Z , V , k0_EM , Polar ) ;
    dt_ZZ = toc 
    %
    % Solve the linear system ZZ x Current = Psi_inc => Current: 
    tic 
    Current = linsolve( ZZ , Psi_inc.'  ) ; 
    dt_linsolve = toc
    Current = Current.' ;
    figure(21) ; %clf ; hold on ; grid on ;
    plot(X_h,20*log10(abs(Current)), 'LineWidth',1.5) ; 
    xlabel('x [\lambda_0]','FontSize',size_) ; 
    if strcmp(Polar,'TE')
        ylabel('|\partial\psi/\partial n| [dB]','FontSize',size_) ; 
    else
        ylabel('|\psi| [dB]','FontSize',size_) ; 
    end
    title(['Surface current: \theta_{inc} = ' num2str(th_i_d) '°, ' Polar ' pol.'],'FontSize',size_,'FontWeight','bold') ; 
    set(gca,'FontSize',size_) ; 
    xlim([X_lim_Su(1) X_lim_Su(end)]) ; set(gca,'xtick',X_lim_Su) ; 
    %
    % NRCS:
    coef = 1/pwr_inc_num/(16*pi*k0_s)*eta_inc ;
    if strcmp(Polar,'TE')
        D_Psi = Current ; Psi = zeros(size(Current)) ;
    else
        Psi = Current ; D_Psi = zeros(size(Psi)) ;
    end
    Psi_sca = F_IFarField( X_h, HH(i_prof,:), Dx , DerZ , V , k0_EM , Psi , D_Psi , Th_s_r ) ;
    Nrcs = coef*abs(Psi_sca).^2 ;
    figure(31) ; %clf ; hold on ; grid on ; 
    Th_s_d = Th_s_r * 180/pi ; 
    plot(Th_s_d,10*log10(Nrcs), 'LineWidth',1.5) ; 
    xlabel('\theta_{sca} [°]','FontSize',size_) ; 
    ylabel('NRCS [dB]','FontSize',size_) ; 
    title(['NRCS: \theta_{inc} = ' num2str(th_i_d) '°, ' Polar ' pol.'],'FontSize',size_,'FontWeight','bold') ; 
    set(gca,'FontSize',size_) ; 
    X_lim_Th = -90:30:90 ; xlim([X_lim_Th(1) X_lim_Th(end)]) ; set(gca,'xtick',X_lim_Th) ; 
end
