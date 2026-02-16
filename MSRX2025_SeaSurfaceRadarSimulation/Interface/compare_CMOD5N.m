%% Comparaison CMOD5.N – 10 m/s – 5.3 GHz – Upwind 0° – VV
clear; clc; close all;

theta = 18:0.1:57;          % angles d'incidence (résolution fine)
v     = 10;                 % vent 10 m/s
phi   = 0;                  % upwind (0° relatif)

% === Version 1 
sigma0_officiel = f_calc_sigma0_cmod5_n(v, phi, theta);

% === Version 2 
[sigma0_maison, ~] = f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5N(theta, v, phi);

% Tracé
figure('Position',[200 200 900 600],'Color','w');
plot(theta, 10*log10(sigma0_officiel), 'b-',  'LineWidth', 2.8); hold on;
plot(theta, 10*log10(sigma0_maison),   'r--', 'LineWidth', 2.2);

grid on; box on;
xlabel('Angle d''incidence (°)','FontSize',14);
ylabel('NRCS VV (dB)','FontSize',14);
title('CMOD5.N – 10 m/s – 5.3 GHz – Upwind 0° – VV','FontSize',16,'FontWeight','bold');
xlim([18 57]); ylim([-18 2]);

% Légende claire
legend('f\_calc\_sigma0\_cmod5\_n ', ...
       'f\_Nrcs\_3dMono\_EmpExpSea\_Cband\_Cmod5N', ...
       'Location','southwest','FontSize',12);

% Affichage de l'écart max (pour la soutenance c'est toujours impressionnant)
%ecart_max_dB = max(abs(10*log10(sigma0_officiel) - 10*log10(sigma0_maison)));
%text(20, -30, sprintf('Écart maximal = %.4f dB', ecart_max_dB), ...
 %    'FontSize',12,'BackgroundColor','white','EdgeColor','k');

hold off;