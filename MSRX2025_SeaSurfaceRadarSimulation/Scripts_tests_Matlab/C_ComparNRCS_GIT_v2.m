%% Programme qui compare la NRCS entre ma version (GIT) et la Matlab Toolbox
clear variables; clc; close all;
format short; format compact;

% Ajout du chemin vers les fonctions 
addpath(genpath(cd));

%% Définition des paramètres de test
% Domaines du modèle GIT (0.1°-10°, 1-100 GHz, SeaState 1-6)
GrazAng_d = [0.1, 0.3, 1.0, 2:2:10]; % Angles (jusqu'à 10°)
freq_GHz = [1, 5, 7, 9]; % Fréquences 
seaSt = 1:6; % État de mer (6 valeurs)
polar = {'H', 'V'}; % Polarisation
ph__d = [0, 45, 90]; % Angles entre LOS et vent

% Conversion fréquence -> longueur d'onde et Hz
c_ms = 299792458;
freq_Hz = freq_GHz * 1e9;
lb0_m = c_ms ./ freq_Hz;

% Préallocation
n_angles = length(GrazAng_d);
n_freqs = length(freq_GHz);
n_seastates = length(seaSt);
n_pol = length(polar);
n_ph = length(ph__d);
results = zeros(n_angles, n_freqs, n_seastates, n_pol, n_ph, 2);

%% Boucle sur toutes les configurations
for i = 1:n_angles
    for j = 1:n_freqs
        for k = 1:n_seastates
            for m = 1:n_pol
                for p = 1:n_ph
                    % Vérifications domaine GIT
                    if GrazAng_d(i) < 0.1 || GrazAng_d(i) > 10.0
                        continue; 
                    end
                    if seaSt(k) < 1 || seaSt(k) > 6
                        continue;
                    end
                    if freq_GHz(j) < 1 || freq_GHz(j) > 100
                        continue;
                    end

                    % Toolbox Matlab
                    refl = surfaceReflectivitySea('Model', 'GIT', ...
                        'SeaState', seaSt(k), 'Polarization', polar{m});
                    nrcs_toolbox = refl(GrazAng_d(i), freq_Hz(j), ph__d(p));
                    Nrcs_dB_toolbox = pow2db(nrcs_toolbox);

                    % Ma version
                    Sig0_GIT_dB = f_Nrcs_3dMonoGrazing_GIT(GrazAng_d(i), lb0_m(j), ...
                        seaSt(k), ph__d(p), polar{m});

                    % Stockage
                    if isnan(Nrcs_dB_toolbox) || isnan(Sig0_GIT_dB) || ...
                       isinf(Nrcs_dB_toolbox) || isinf(Sig0_GIT_dB)
                        results(i,j,k,m,p,1:2) = NaN;
                    else
                        results(i,j,k,m,p,1) = Nrcs_dB_toolbox; % Toolbox
                        results(i,j,k,m,p,2) = Sig0_GIT_dB;      % Ma version
                    end
                end
            end
        end
    end
end

%% Analyse et comparaison
deltas = abs(results(:,:,:,:,:,2) - results(:,:,:,:,:,1));  
deltas(isinf(deltas) | isnan(deltas)) = 0;  % On ignore les NaN/inf dans les stats

% Statistiques globales sur l'ensemble des configurations testées
mae_global = mean(deltas, 'all', 'omitnan');        % Mean Absolute Error globale
min_err    = min(deltas(:), [], 'omitnan');         % Erreur minimale
max_err    = max(deltas(:), [], 'omitnan');         % Erreur maximale
std_err    = std(deltas(:), 'omitnan');             % Écart-type des écarts

% Recherche de la configuration donnant l'erreur maximale
[max_delta, max_idx] = max(deltas(:), [], 'omitnan');
[i_max, j_max, k_max, m_max, p_max, ~] = ind2sub(size(deltas), max_idx);

% Affichage des statistiques globales
disp(['MAE globale (dB)              : ' num2str(mae_global)]);
disp(['Erreur minimale (dB)          : ' num2str(min_err)]);
disp(['Erreur maximale (dB)          : ' num2str(max_err)]);
disp(['Écart-type des écarts (dB)    : ' num2str(std_err)]);
disp(['Configuration de l''erreur max :Angle = ' num2str(GrazAng_d(i_max)) '°, Freq = ' num2str(freq_GHz(j_max)) ' GHz, SeaState = ' num2str(seaSt(k_max)) ', Pol = ' polar{m_max} ', Angle vent = ' num2str(ph__d(p_max)) '°']);


%% Affichage réduit : pol=V, SeaState=3, vent=0°
idx_pol = 2; % 'V'
idx_seast = 3; % SeaState=3 → index 3 (car 1:6)
idx_ph = 1; % Vent = 0°
disp('Comparaison NRCS (dB) pour pol=V, SeaState=3, vent=0° :');
disp('Angle | Freq (GHz) | Toolbox | Ma version | Δ');
for i = 1:n_angles
    for j = 1:n_freqs
        toolbox_val = results(i,j,idx_seast,idx_pol,idx_ph,1);
        my_val      = results(i,j,idx_seast,idx_pol,idx_ph,2);
        if ~isnan(toolbox_val)
            fprintf('%4.1f° | %6.2f | %8.2f | %8.2f | %8.2f\n', ...
                GrazAng_d(i), freq_GHz(j), toolbox_val, my_val, my_val - toolbox_val);
        end
    end
end

 %% Visualisation
 % figure;
 % for i = 1:n_angles
 %     subplot(ceil(n_angles/2),2,i);
 %     plot(freq_GHz, squeeze(results(i,:,idx_seast,idx_pol,idx_ph,:)), '-o','LineWidth',1.5);
 %     legend('Toolbox','Ma version','Location','best');
 %     title(['Angle = ' num2str(GrazAng_d(i)) '° (SeaState=3, V, vent=0°)']);
 %     xlabel('Fréquence (GHz)'); ylabel('NRCS (dB)');
 %     grid on;
 % end

%% Sauvegarde
save('GIT_Validation_Results.mat','results','GrazAng_d','freq_GHz','seaSt','polar','ph__d');
disp('Résultats sauvegardés dans GIT_Validation_Results.mat');
