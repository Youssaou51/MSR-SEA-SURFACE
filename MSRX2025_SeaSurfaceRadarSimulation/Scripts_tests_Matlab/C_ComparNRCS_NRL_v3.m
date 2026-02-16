%% Programme qui compare la NRCS entre ma version (NRL) et la Matlab Toolbox
clear variables; clc; close all;
format short; format compact;

% Ajout du chemin vers les fonctions 
addpath(genpath(cd));

%% Définition des paramètres de test
% Domaines du modèle NRL (0.1°-60°, 0.5-35 GHz, SeaState 0-6)
GrazAng_d = [0.1, 0.3, 1.0, 2:2:60]; % Angles (31 valeurs)
freq_GHz = [0.5, 5, 10, 20, 35]; % Fréquences stratégiques (5 valeurs)
seaSt = 0:6; % État de mer (7 valeurs)
polar = {'H', 'V'}; % Polarisation (2 valeurs)

% Conversion fréquence -> longueur d'onde et Hz
c_ms = 299792458; % Célérité de la lumière (précise)
freq_Hz = freq_GHz * 1e9; % Conversion en Hz
lb0_m = c_ms ./ freq_Hz; % Longueur d'onde (m)

% Préallocation pour stocker les résultats
n_angles = length(GrazAng_d);
n_freqs = length(freq_GHz);
n_seastates = length(seaSt);
n_pol = length(polar);
results = zeros(n_angles, n_freqs, n_seastates, n_pol, 2); % [angle, freq, seast, pol, version]

%% Boucle sur toutes les configurations
for i = 1:n_angles
    for j = 1:n_freqs
        for k = 1:n_seastates
            for m = 1:n_pol
                % Vérifications des domaines 
                if GrazAng_d(i) < 0.1 || GrazAng_d(i) > 60.0
                    continue; 
                end
                if seaSt(k) < 0 || seaSt(k) > 6 || mod(seaSt(k), 1)
                    continue;
                end
                if freq_GHz(j) < 0.5 || freq_GHz(j) > 35
                    continue;
                end

                % Calcul avec Toolbox Matlab
                refl = surfaceReflectivitySea('Model', 'NRL', 'SeaState', seaSt(k), 'Polarization', polar{m});
                nrcs_toolbox = refl(GrazAng_d(i), freq_Hz(j));
                Nrcs_dB_toolbox = pow2db(nrcs_toolbox);

                % Calcul avec ma version
                Sig0_NRL_dB = f_Nrcs_3dMonoGrazing_NRL_2012(GrazAng_d(i), lb0_m(j), seaSt(k), 0, polar{m}, c_ms); % ph__d fixé à 0

                % Calcul version NRL report 2012 : 
                SigZ = NRL_SigmaSea(freq_Hz(j), seaSt(k), polar{m}, GrazAng_d(i), []); 

                % Stockage des résultats
                results(i, j, k, m, 1) = Nrcs_dB_toolbox; % Toolbox
                results(i, j, k, m, 2) = Sig0_NRL_dB; % ma version
            end
        end
    end
end

%% Analyse et comparaison
% Calcul des statistiques globales
deltas = abs(results(:, :, :, :, 2) - results(:, :, :, :, 1));
deltas(isinf(deltas) | isnan(deltas)) = 0; 
mae = mean(deltas, 'all', 'omitnan'); % Moyenne globale
min_err = min(deltas(:), [], 'omitnan'); % Erreur minimale
max_err = max(deltas(:), [], 'omitnan'); % Erreur maximale
std_err = std(deltas(:), 'omitnan'); % Écart type des écarts
[max_delta, max_idx] = max(deltas(:), [], 'omitnan'); % Index de l'erreur maximale
[i_max, j_max, k_max, m_max] = ind2sub(size(deltas), max_idx); % Conversion en indices
disp(['MAE globale (dB) : ' num2str(mae)]);
disp(['Erreur minimale (dB) : ' num2str(min_err)]);
disp(['Erreur maximale (dB) : ' num2str(max_err)]);
disp(['Écart type (dB) : ' num2str(std_err)]);
disp(['Configuration de l''erreur maximale : Angle = ' num2str(GrazAng_d(i_max)) '°, Freq = ' num2str(freq_GHz(j_max)) ' GHz, SeaState = ' num2str(seaSt(k_max)) ', Pol = ' polar{m_max} ]);


% Affichage réduit : Seulement pour pol='V' et SeaState=3 (moyen, 31 angles × 5 freq = 155 lignes)
idx_pol = 2; % 'V'
idx_seast = 4; % SeaState = 3 (index 4 pour 0:6)
disp('Comparaison NRCS (dB) pour pol=V, SeaState=3 :');
disp('Angle | Freq (GHz) | Toolbox | Ma version | Δ');
for i = 1:n_angles
    for j = 1:n_freqs
        toolbox_val = results(i, j, idx_seast, idx_pol, 1);
        my_val = results(i, j, idx_seast, idx_pol, 2);
        if ~isnan(toolbox_val)
            fprintf('%4.1f° | %6.2f | %8.2f | %8.2f | %8.2f\n', ...
                GrazAng_d(i), freq_GHz(j), toolbox_val, my_val, my_val - toolbox_val);
        end
    end
end

%% Visualisation (plots par angle pour SeaState=3, pol='V')
figure;
for i = 1:n_angles
    subplot(ceil(n_angles/2), 2, i);
    plot(freq_GHz, squeeze(results(i, :, idx_seast, idx_pol, 1)), '--o', 'LineWidth', 1); % Toolbox en interrompu
    hold on;
    plot(freq_GHz, squeeze(results(i, :, idx_seast, idx_pol, 2)), '-', 'LineWidth', 2); % Ma version en trait fort
    hold off;
    legend('Toolbox', 'Ma version', 'Location', 'best');
    title(['Angle = ' num2str(GrazAng_d(i)) '° (SeaState=3, V)']);
    xlabel('Fréquence (GHz)'); ylabel('NRCS (dB)');
    grid on;
end

%% Sauvegarde des résultats
save('NRL_Validation_Results.mat', 'results', 'GrazAng_d', 'freq_GHz', 'seaSt', 'polar');
disp('Résultats sauvegardés dans NRL_Validation_Results.mat');