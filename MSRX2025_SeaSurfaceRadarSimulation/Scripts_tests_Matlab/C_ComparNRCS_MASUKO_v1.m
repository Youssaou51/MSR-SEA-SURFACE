%% Programme qui compare la NRCS entre ma version (Masuko) et la Matlab Toolbox
clear variables; clc; close all;
format short; format compact;

% Ajout du chemin vers les fonctions 
addpath(genpath(cd));

%% Définition des paramètres de test
Th_i_d = [30, 40, 50, 60]; % Angles d'incidence (4 valeurs tabulées)
u19_ms_range = [3.2, 6, 10, 14, 17.2]; % Vitesse vent (5 valeurs, m/s)
windDir_d = [0, 90, 180]; % Directions vent (3 valeurs pour éviter l'erreur à 270°)
seaSt = 0:6; % État de mer pour dériver u19
polar = {'H', 'V'}; % Polarisation
freq_GHz = [10, 34.43]; % X-band, Ka-band
freq_Hz = freq_GHz * 1e9; % Conversion en Hz

% Préallocation
n_angles = length(Th_i_d);
n_u19 = length(u19_ms_range);
n_wind = length(windDir_d);
n_pol = length(polar);
n_freq = length(freq_GHz);
results_VV = zeros(n_angles, n_u19, n_wind, n_pol, n_freq, 2); % [angle, u19, wind, pol, freq, version]

%% Boucle sur toutes les configurations
for i = 1:n_angles
    for j = 1:n_u19
        u19_ms_j = u19_ms_range(j);
        if u19_ms_j <= 0
            continue;
        end
        for k = 1:n_wind
            for m = 1:n_pol
                for f = 1:n_freq
                    % Vérifications des domaines
                    if Th_i_d(i) < 30 || Th_i_d(i) > 60
                        continue;
                    end
                    if u19_ms_j < 3.2 || u19_ms_j > 17.2
                        continue;
                    end

                    % Calcul avec Toolbox Matlab
                    try
                        % Conversion u19_ms_j -> SeaState approximatif
                        seaState_est = (u19_ms_j / 3.16)^(1/0.8); % Inverse de u19_ms = 3.16 * SeaState^0.8
                        seaState_est = max(0, min(6, round(seaState_est))); % Limite à 0-6
                        refl = surfaceReflectivitySea('Model', 'Masuko', 'SeaState', seaState_est, 'Polarization', polar{m});
                        nrcs_toolbox = refl(Th_i_d(i), u19_ms_j, windDir_d(k)); % angle, u19, windDir
                        Nrcs_dB_toolbox = pow2db(nrcs_toolbox);
                    catch ME
                        Nrcs_dB_toolbox = NaN;
                    end

                    % Calcul avec ma version
                    if freq_GHz(f) == 10
                        [Nrcs_Mdl_VV, ~] = f_Nrcs_3dMono_EmpExpSea_Xband_Masuko(Th_i_d(i), u19_ms_j, windDir_d(k));
                    else % 34.43 GHz
                        [Nrcs_Mdl_VV, ~] = f_Nrcs_3dMono_EmpExpSea_Kaband_Masuko(Th_i_d(i), u19_ms_j, windDir_d(k));
                    end
                    Sig0_Masuko_dB = pow2db(Nrcs_Mdl_VV); % En dB

                    % Stockage
                    results_VV(i, j, k, m, f, 1) = Nrcs_dB_toolbox;
                    results_VV(i, j, k, m, f, 2) = Sig0_Masuko_dB;
                end
            end
        end
    end
end

%% Analyse et comparaison
deltas = abs(results_VV(:, :, :, :, :, 2) - results_VV(:, :, :, :, :, 1));
mae = mean(deltas, 'all', 'omitnan'); % Une seule valeur globale
disp(['MAE globale (dB) : ' num2str(mae)]);

% Affichage réduit
idx_pol = 2; % 'V'
idx_u19 = 3; % u19 = 10 m/s
idx_wind = 1; % windDir = 0°
disp('Comparaison NRCS (dB) pour pol=V, u19=10 m/s, windDir=0° :');
disp('Angle | Freq (GHz) | Toolbox | Ma version | Δ');
for i = 1:n_angles
    for f = 1:n_freq
        toolbox_val = results_VV(i, idx_u19, idx_wind, idx_pol, f, 1);
        my_val = results_VV(i, idx_u19, idx_wind, idx_pol, f, 2);
        if ~isnan(toolbox_val)
            fprintf('%4.1f° | %6.2f | %8.2f | %8.2f | %8.2f\n', ...
                Th_i_d(i), freq_GHz(f), toolbox_val, my_val, my_val - toolbox_val);
        end
    end
end

%% Visualisation
figure;
for i = 1:n_angles
    subplot(ceil(n_angles/2), 2, i);
    plot(freq_GHz, squeeze(results_VV(i, idx_u19, idx_wind, idx_pol, :, :)), '-o', 'LineWidth', 1.5);
    legend('Toolbox', 'Ma version', 'Location', 'best');
    title(['Angle = ' num2str(Th_i_d(i)) ' deg (u19=10 m/s, V, windDir=0°)']);
    xlabel('Fréquence (GHz)'); ylabel('NRCS (dB)');
    grid on;
end

%% Sauvegarde
save('Masuko_Validation_Results.mat', 'results_VV', 'Th_i_d', 'u19_ms_range', 'windDir_d', 'freq_GHz', 'seaSt', 'polar');
disp('Résultats sauvegardés dans Masuko_Validation_Results.mat');