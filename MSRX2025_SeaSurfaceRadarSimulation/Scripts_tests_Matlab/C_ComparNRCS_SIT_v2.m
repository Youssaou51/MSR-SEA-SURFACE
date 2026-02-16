%% Programme qui compare la NRCS entre ma version (SITTROP) et la Matlab Toolbox
clear variables; clc; close all;
format short; format compact;

% Ajout du chemin vers les fonctions 
addpath(genpath(cd));

%% Définition des paramètres de test
% Domaines du modèle SITTROP (0.2°-10°, f fixe à 9.375 GHz pour λ = 3.2 cm, SeaState 0-7)
GrazAng_d = [0.2, 0.5, 1.0, 2:1:10]; % Angles (10 valeurs, 0.2-10°)
freq_GHz = 9.375; % Fréquence fixe pour λ = 3.2 cm (1 valeur)
seaSt = 0:7; % État de mer (8 valeurs, 0 à 7)
polar = {'H', 'V'}; % Polarisation (2 valeurs)
ph__d = [0, 90]; % Angles tabulés (2 valeurs)

% Conversion fréquence -> longueur d'onde et Hz
c_ms = 299792458; % Célérité de la lumière (précise)
freq_Hz = freq_GHz * 1e9; % Conversion en Hz
lb0_m = 0.032; % Longueur d'onde fixe (m) pour correspondre à 9.375 GHz

% Préallocation pour stocker les résultats
n_angles = length(GrazAng_d);
n_freqs = 1; % 1 seule fréquence
n_seastates = length(seaSt);
n_pol = length(polar);
n_ph = length(ph__d);
results = zeros(n_angles, n_freqs, n_seastates, n_pol, n_ph, 2); % [angle, freq, seast, pol, ph, version]

%% Boucle sur toutes les configurations
for i = 1:n_angles
    for j = 1:n_freqs
        for k = 1:n_seastates
            for m = 1:n_pol
                for p = 1:n_ph
                    % Vérifications des domaines conformes à la doc MATLAB
                    if GrazAng_d(i) < 0.2 || GrazAng_d(i) > 10.0
                        continue; 
                    end
                    if seaSt(k) < 0 || seaSt(k) > 7 || mod(seaSt(k), 1)
                        continue;
                    end

                    % Calcul avec Toolbox Matlab
                    refl = surfaceReflectivitySea('Model', 'Sittrop', 'SeaState', seaSt(k), 'Polarization', polar{m});
                    nrcs_toolbox = refl(GrazAng_d(i), freq_Hz, ph__d(p)); 
                    Nrcs_dB_toolbox = pow2db(nrcs_toolbox);

                    % Calcul avec ma version (λ fixe à 3.2 cm)
                    Sig0_SIT_dB = f_Nrcs_3dMonoGrazing_SIT(GrazAng_d(i), lb0_m, seaSt(k), ph__d(p), polar{m});

                    % Stockage des résultats (vérification NaN)
                    if isnan(Nrcs_dB_toolbox) || isinf(Nrcs_dB_toolbox) || isnan(Sig0_SIT_dB) || isinf(Sig0_SIT_dB)
                        results(i, j, k, m, p, 1) = NaN; % Toolbox
                        results(i, j, k, m, p, 2) = NaN; % Ma version
                    else
                        results(i, j, k, m, p, 1) = Nrcs_dB_toolbox; % Toolbox
                        results(i, j, k, m, p, 2) = Sig0_SIT_dB; % Ma version
                    end
                end
            end
        end
    end
end

%% Analyse et comparaison
% Calcul des statistiques globales
deltas = abs(results(:, :, :, :, :, 2) - results(:, :, :, :, :, 1));
deltas(isinf(deltas) | isnan(deltas)) = 0; 
mae = mean(deltas, 'all', 'omitnan'); % Moyenne globale
min_err = min(deltas(:), [], 'omitnan'); % Erreur minimale
max_err = max(deltas(:), [], 'omitnan'); % Erreur maximale
std_err = std(deltas(:), 'omitnan'); % Écart type des écarts
[max_delta, max_idx] = max(deltas(:), [], 'omitnan'); % Index de l'erreur maximale
[i_max, j_max, k_max, m_max, p_max] = ind2sub(size(deltas), max_idx); % Conversion en indices
disp(['MAE globale (dB) : ' num2str(mae)]);
disp(['Erreur minimale (dB) : ' num2str(min_err)]);
disp(['Erreur maximale (dB) : ' num2str(max_err)]);
disp(['Écart type (dB) : ' num2str(std_err)]);
disp(['Configuration de l''erreur maximale : Angle = ' num2str(GrazAng_d(i_max)) '°, Freq = ' num2str(freq_GHz(j_max)) ' GHz, SeaState = ' num2str(seaSt(k_max)) ', Pol = ' polar{m_max} ', ph__d = ' num2str(ph__d(p_max)) '°']);


% Affichage réduit : Seulement pour pol='V' et SeaState=3 (10 angles × 1 freq = 10 lignes)
idx_pol = 2; % 'V'
idx_seast = 4; % SeaState = 3 (index 4 pour 0:7)
disp('Comparaison NRCS (dB) pour pol=V, SeaState=3 :');
disp('Angle | Freq (GHz) | Toolbox | Ma version | Δ');
for i = 1:n_angles
    for j = 1:n_freqs
        toolbox_val = results(i, j, idx_seast, idx_pol, 1, 1); % ph__d fixe à 1 (0°)
        my_val = results(i, j, idx_seast, idx_pol, 1, 2);
        if ~isnan(toolbox_val)
            fprintf('%4.1f° | %6.2f | %8.2f | %8.2f | %8.2f\n', ...
                GrazAng_d(i), freq_GHz, toolbox_val, my_val, my_val - toolbox_val);
        end
    end
end

%% Visualisation (plots par angle pour SeaState=3, pol='V')
% figure;
% for i = 1:n_angles
%     subplot(ceil(n_angles/2), 2, i);
%     % plot(freq_GHz, squeeze(results(i, :, idx_seast, idx_pol, 1, 1)), '--o', 'LineWidth', 1); % Toolbox en interrompu
%     hold on;
%     plot(freq_GHz, squeeze(results(i, :, idx_seast, idx_pol, 1, 2)), '-', 'LineWidth', 2); % Ma version en trait fort
%     hold off;
%     legend('Toolbox', 'Ma version', 'Location', 'best');
%     title(['Angle = ' num2str(GrazAng_d(i)) ' deg (SeaState=3, V)']);
%     xlabel('Fréquence (GHz)'); ylabel('NRCS (dB)');
%     grid on;
% end

%% Sauvegarde des résultats
save('SITTROP_Validation_Results.mat', 'results', 'GrazAng_d', 'freq_GHz', 'seaSt', 'polar', 'ph__d');
disp('Résultats sauvegardés dans SITTROP_Validation_Results.mat');