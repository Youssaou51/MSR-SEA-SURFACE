%% Programme qui compare la NRCS entre ma version (Hybrid) et la Matlab Toolbox
clear variables; clc; close all;
format short; format compact;

% Ajout du chemin vers les fonctions 
addpath(genpath(cd));

%% Définition des paramètres de test
% Domaines du modèle Hybrid (0.1°-30°, 0.5-35 GHz, SeaState 0-5)
GrazAng_d = [0.1, 0.3, 1.0, 2:2:30]; % Angles (16 valeurs)
freq_GHz = [0.5, 5, 10, 20, 35]; % Fréquences stratégiques (5 valeurs)
seaSt = 0:5; % État de mer (6 valeurs)
polar = {'H', 'V'}; % Polarisation (2 valeurs)
ph__d = [0, 45, 90]; % Angles entre LOS et vent (3 valeurs)

% Conversion fréquence -> longueur d'onde et Hz
c_ms = 299792458; % Célérité de la lumière (précise)
freq_Hz = freq_GHz * 1e9; % Conversion en Hz
lb0_m = c_ms ./ freq_Hz; % Longueur d'onde (m)

% Préallocation pour stocker les résultats
n_angles = length(GrazAng_d);
n_freqs = length(freq_GHz);
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
                    % Vérifications des domaines
                    if GrazAng_d(i) < 0.1 || GrazAng_d(i) > 30.0 
                        continue;
                    end
                    if seaSt(k) < 0 || seaSt(k) > 5 || mod(seaSt(k), 1) 
                        continue;
                    end
                    if freq_GHz(j) < 0.5 || freq_GHz(j) > 35
                        continue;
                    end

                    % Calcul avec Toolbox Matlab
                    try
                        refl = surfaceReflectivitySea('Model', 'Hybrid', 'SeaState', seaSt(k), 'Polarization', polar{m});
                        nrcs_toolbox = refl(GrazAng_d(i), freq_Hz(j), ph__d(p));
                        Nrcs_dB_toolbox = pow2db(nrcs_toolbox);
                    catch
                        Nrcs_dB_toolbox = NaN;
                    end

                    % Calcul avec ma version
                    Sig0_HYB_dB = f_GrazingNRCS_HYB_v2(GrazAng_d(i), lb0_m(j), seaSt(k), ph__d(p), polar{m});

                    % Stockage des résultats
                    results(i, j, k, m, p, 1) = Nrcs_dB_toolbox; % Toolbox
                    results(i, j, k, m, p, 2) = Sig0_HYB_dB; % ma version
                end
            end
        end
    end
end

%% Analyse et comparaison
% Statistiques globales (moyenne sur toutes les directions de vent)
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


% Affichage réduit : Seulement pour pol='V', SeaState=5, et toutes les directions de vent
idx_pol = 1; % 'V'
idx_seast = 1; % SeaState = 5 (index 6 pour 0:5)
disp('Comparaison NRCS (dB) pour pol=H, SeaState=0 :');
disp('Angle | Freq (GHz)| Toolbox | Ma version | Δ');
for i = 1:n_angles
    for j = 1:n_freqs
        
            toolbox_val = results(i, j, idx_seast, idx_pol, 2, 1);
            my_val = results(i, j, idx_seast, idx_pol, 2, 2);
        if ~isnan(toolbox_val)
                fprintf('%4.1f° | %6.2f | %8.2f | %8.2f | %8.2f\n', ...
                    GrazAng_d(i), freq_GHz(j), toolbox_val, my_val, my_val - toolbox_val);
            
        end
    end
end

%% Visualisation (plots par angle pour SeaState=5, pol='V', une direction de vent par subplot)
figure;
n_subplots = n_angles * n_ph; % Total des sous-graphiques
for i = 1:n_angles
    for p = 1:n_ph
        subplot(ceil(n_subplots/n_ph), n_ph, (i-1)*n_ph + p);
        plot(freq_GHz, squeeze(results(i, :, idx_seast, idx_pol, p, 1)), '--o', 'LineWidth', 1); % Toolbox en interrompu
        hold on;
        plot(freq_GHz, squeeze(results(i, :, idx_seast, idx_pol, p, 2)), '-', 'LineWidth', 2); % Ma version en trait fort
        hold off;
        legend('Toolbox', 'Ma version', 'Location', 'best');
        title(['Angle = ' num2str(GrazAng_d(i)) '\circ (SeaState=5, V, ph\_d = ' num2str(ph__d(p)) '\circ)'], 'Interpreter', 'tex');
        xlabel('Fréquence (GHz)'); ylabel('NRCS (dB)');
        grid on;
    end
end

%% Sauvegarde des résultats
save('Hybrid_Validation_Results_wind.mat', 'results', 'GrazAng_d', 'freq_GHz', 'seaSt', 'polar', 'ph__d');
disp('Résultats sauvegardés dans Hybrid_Validation_Results_wind.mat');