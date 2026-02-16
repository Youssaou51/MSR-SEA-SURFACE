% Script MATLAB pour tracer la GMF (Geophysical Model Function) d'un diffusiomètre.
% Traduction du script Python d'Anton Verhoef (KNMI)
%
% https://gemini.google.com/app/64bcb303328e62b5?hl=fr

clear; clc;

% --- Configuration ---
fname = 'gmf_cmod7_vv.dat_little_endian'; % Remplacez par le nom de votre fichier binaire
if ~exist(fname, 'file')
    error('Le fichier %s n''existe pas.', fname);
end

% Dimensions de la table GMF
m = 250;  % vitesse du vent (0.2-50 m/s, pas de 0.2)
n = 73;   % direction (0-180 deg, pas de 2.5)
p = 51;   % incidence (16-66 deg, pas de 1)

% --- Lecture du fichier binaire ---
fid = fopen(fname, 'r');
% Lecture en float32 (single precision)
gmf_raw = fread(fid, 'float32');
fclose(fid);

% Suppression du premier et du dernier élément (head and tail)
gmf_raw = gmf_raw(2:end-1);

% Reshape en matrice 3D (m x n x p)
% MATLAB est naturellement en ordre Fortran (column-major)
gmf_table = reshape(gmf_raw, [m, n, p]);

% --- Paramètres de tracé ---
iinc = 35; % Index de l'angle d'incidence (34 en Python + 1 pour MATLAB)
incidence = (iinc - 1) + 16.0;

figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.7]);

% --- Premier graphique : sigma0 vs. Direction ---
subplot(1, 2, 1);
hold on; grid on;
pltarrx = (0:n-1) * 2.5; % Axe des directions

% Boucle sur les vitesses (équivalent à range(9, 121, 10) en Python)
for ispd = 10:10:120
    % Extraction et conversion en dB (10 * log10)
    % squeeze est utilisé pour réduire la dimension de la matrice extraite
    pltarry = 10 * log10(squeeze(gmf_table(ispd, :, iinc)));
    
    speed_val = ispd * 0.2;
    plot(pltarrx, pltarry, 'DisplayName', sprintf('%.1f m/s', speed_val));
end

title(sprintf('%s, incidence angle %.1f', fname, incidence), 'Interpreter', 'none');
xlabel('Wind direction (°)');
ylabel('sigma0 (dB)');
xlim([0, 225]);
xticks(0:45:225);
ylim([-40, -5]);
legend('show', 'Location', 'northeast', 'FontSize', 8);

% --- Deuxième graphique : sigma0 vs. Vitesse ---
subplot(1, 2, 2);
hold on; grid on;
pltarrx_speed = (1:m) * 0.2; % Axe des vitesses

% Boucle sur les directions (équivalent à range(0, 73, 9) en Python)
for idir = 1:9:73
    pltarry_speed = 10 * log10(squeeze(gmf_table(:, idir, iinc)));
    
    dir_val = (idir - 1) * 2.5;
    plot(pltarrx_speed, pltarry_speed, 'DisplayName', sprintf('%.1f°', dir_val));
end

xlabel('Wind speed (m/s)');
xlim([0, 25]);
ylim([-40, -5]);
legend('show', 'Location', 'southeast', 'FontSize', 8);

% --- Sauvegarde ---
saveas(gcf, [fname, '.png']);
fprintf('Image sauvegardée sous %s.png\n', fname);