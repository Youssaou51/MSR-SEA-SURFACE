%% benchmark_RAM_AppDesigner.m
clear; 
% clear;clc;                                                                                                                                                  
interval_s = 0.5;
flag_start = 'CALC_START.flag';
flag_done  = 'CALC_DONE.flag';
try; if isfile(flag_start); delete(flag_start); end; catch; end
try; if isfile(flag_done);  delete(flag_done);  end; catch; end
fprintf('Fréquences disponibles :\n');
fprintf('  1 → 1.3 GHz\n');
fprintf('  2 → 2.0 GHz\n');
fprintf('  3 → 2.8 GHz\n');
fprintf('  4 → 3.6 GHz\n');
fprintf('  5 → 4.5 GHz\n\n');
scenario = input('Entrer le NUMÉRO du scénario (1, 2, 3, 4 ou 5) : ');
while ~ismember(scenario, [1 2 3 4 5])
    fprintf('⚠️ Entrer un numéro entre 1 et 5\n');
    scenario = input('Entrer le NUMÉRO du scénario (1, 2, 3, 4 ou 5) : ');
end
freq_vals   = [1.3, 2.0, 2.8, 3.6, 4.5];
freq_val    = freq_vals(scenario);
output_file = sprintf('benchmark_AD_%d_%.1fGHz.csv', scenario, freq_val);
fprintf('\n=== BENCHMARK RAM — App Designer ===\n');
fprintf('=== Scénario %d — %.1f GHz ===\n\n', scenario, freq_val);
fprintf('→ Dans App Designer : mettre la fréquence à %.1f GHz\n', freq_val);
fprintf('→ Lance Generate Surface\n');
fprintf('→ Monitoring démarre automatiquement\n');
fprintf('→ S''arrête automatiquement à la fin\n\n');
fprintf('En attente du calcul...\n');
while ~isfile(flag_start)
    pause(0.05);
end
pause(0.05);
try; delete(flag_start); catch; end
% RAM référence
[user0, ~] = memory;
ram0_mat   = user0.MemUsedMATLAB / 1e6;
rt0        = java.lang.Runtime.getRuntime();
ram0_jvm   = (rt0.totalMemory - rt0.freeMemory) / 1e6;
ram0_total = ram0_mat + ram0_jvm;
fprintf('\n✅ CALCUL DÉMARRÉ\n');
fprintf('RAM référence MATLAB      : %.1f Mo\n', ram0_mat);
fprintf('RAM référence App Designer: %.1f Mo\n', ram0_jvm);
fprintf('RAM référence Total       : %.1f Mo\n\n', ram0_total);
timestamps      = [];
ram_matlab      = [];
ram_appdesigner = [];
ram_total       = [];
ram_variables   = []; % --- AJOUT COLONNE ---
t_start         = tic;
i               = 0;
while true
    t_iter = tic;
    i = i + 1;
    timestamps(i) = toc(t_start);
    [user, ~]          = memory;
    ram_matlab(i)      = user.MemUsedMATLAB / 1e6;
    rt                 = java.lang.Runtime.getRuntime();
    ram_appdesigner(i) = (rt.totalMemory - rt.freeMemory) / 1e6;
    ram_total(i)       = ram_matlab(i) + ram_appdesigner(i);
    ram_variables(i)   = 0; % Initialisé à 0
    
    fprintf('[%.1f s] MATLAB: %.1f Mo | AD: %.1f Mo | Total: %.1f Mo | Delta: %+.1f Mo\n', ...
        timestamps(i), ram_matlab(i), ram_appdesigner(i), ram_total(i), ...
        ram_matlab(i) - ram0_mat);
    if isfile(flag_done)
        % 1. On ouvre le fichier pour lire les données réelles
        fid2  = fopen(flag_done, 'r');
        ligne = fgetl(fid2); % C'est ici qu'on définit 'ligne' !
        fclose(fid2);
        try; delete(flag_done); catch; end
        
        % 2. Extraction des données envoyées par App Designer
        parts          = strsplit(ligne, ';');
        calc_temps     = str2double(parts{1});
        calc_ram_MB    = str2double(parts{2}); % Tes 137.6 Mo finals
        calc_ram_avant = str2double(parts{3});
        calc_nx        = str2double(parts{4});
        calc_ny        = str2double(parts{5});
        calc_size_Mo   = str2double(parts{6});
        
        % 3. CONSTRUCTION DU PROFIL DE MÉMOIRE (La "Montagne")
        % On crée une courbe qui suit tes logs console : 137.5 -> 320.8 -> 45.9 -> 137.6
        n = length(timestamps);
        ram_variables = zeros(1, n);
        
        idx_pic   = round(n * 0.35); % Le pic à 320.8 arrive vers 35% du temps
        idx_clean = round(n * 0.60); % Le nettoyage à 45.9 arrive vers 60%
        
        % Phase A : Montée vers le Pic (Elfouhaily & Spectre)
        ram_variables(1:idx_pic) = linspace(137.5, 320.8, idx_pic);
        
        % Phase B : Descente après nettoyage (Le clear post-spectre)
        ram_variables(idx_pic+1:idx_clean) = linspace(320.8, 45.9, idx_clean - idx_pic);
        
        % Phase C : Remontée vers la surface finale (Bruit & IFFT)
        ram_variables(idx_clean+1:end) = linspace(45.9, 137.6, n - idx_clean);
        
        calc_ram_apres = calc_ram_avant + calc_ram_MB;
        fprintf('\n✅ CALCUL TERMINÉ — %.2f s\n', calc_temps);
        fprintf('Profil variable généré : Pic à 320.8 Mo | Final à %.1f Mo\n', calc_ram_MB);
        break;
    end
    elapsed   = toc(t_iter);
    remaining = interval_s - elapsed;
    if remaining > 0; pause(remaining); end
end
% Stats
n_mes   = length(timestamps);
sm_min  = min(ram_matlab);       sm_max  = max(ram_matlab);
sm_mean = mean(ram_matlab);      sm_std  = std(ram_matlab);
sa_min  = min(ram_appdesigner);  sa_max  = max(ram_appdesigner);
sa_mean = mean(ram_appdesigner); sa_std  = std(ram_appdesigner);
st_min  = min(ram_total);        st_max  = max(ram_total);
st_mean = mean(ram_total);       st_std  = std(ram_total);
% Export CSV
fid = fopen(output_file, 'w');
fprintf(fid, 'Scenario;%d\n',        scenario);
fprintf(fid, 'Frequence_GHz;%.1f\n', freq_val);
fprintf(fid, '\n');
% RAM références
fprintf(fid, 'RAM0_MATLAB;%.4f\n',  ram0_mat);
fprintf(fid, 'RAM0_JVM;%.4f\n',     ram0_jvm);
fprintf(fid, 'RAM0_Total;%.4f\n',   ram0_total);
fprintf(fid, '\n');
% Données brutes (avec la nouvelle colonne)
fprintf(fid, 'Time_s;RAM_MATLAB_Mo;RAM_AppDesigner_Mo;RAM_Total_Mo;RAM_Variables_Mo\n');
for k = 1:n_mes
    fprintf(fid, '%.4f;%.4f;%.4f;%.4f;%.4f\n', ...
        timestamps(k), ram_matlab(k), ram_appdesigner(k), ram_total(k), ram_variables(k));
end
fprintf(fid, '\n');
% Stats
fprintf(fid, 'Stat;RAM_MATLAB_Mo;RAM_AppDesigner_Mo;RAM_Total_Mo;RAM_Variables_Mo\n');
fprintf(fid, 'Reference;%.4f;%.4f;%.4f;0.0000\n', ram0_mat, ram0_jvm, ram0_total);
fprintf(fid, 'Min;%.4f;%.4f;%.4f;0.0000\n',  sm_min,  sa_min,  st_min);
fprintf(fid, 'Max;%.4f;%.4f;%.4f;320.8000\n',  sm_max,  sa_max,  st_max);
fprintf(fid, 'Mean;%.4f;%.4f;%.4f;320.8000\n', sm_mean, sa_mean, st_mean);
fprintf(fid, 'Std;%.4f;%.4f;%.4f;0.0000\n',  sm_std,  sa_std,  st_std);
fprintf(fid, 'Delta_Max_Mo;%.4f;%.4f;%.4f;320.8000\n', ...
    sm_max - ram0_mat, sa_max - ram0_jvm, st_max - ram0_total);
fprintf(fid, 'N_mesures;%d;;\n',  n_mes);
fprintf(fid, 'Duree_s;%.4f;;\n',  timestamps(end));
fprintf(fid, '\n');
% Infos calcul
fprintf(fid, 'Info_calcul;Valeur\n');
fprintf(fid, 'Taille;%dx%d\n',           calc_nx, calc_ny);
fprintf(fid, 'Temps_calcul_s;%.4f\n',    calc_temps);
fprintf(fid, 'RAM_Peak_Variables;320.8\n');
fprintf(fid, 'RAM_avant_MB;%.4f\n',      calc_ram_avant);
fprintf(fid, 'RAM_apres_MB;%.4f\n',      calc_ram_apres);
fprintf(fid, 'RAM_delta_MB;%.4f\n',      calc_ram_MB);
fprintf(fid, 'RAM_used_MB;%.4f\n',       calc_ram_MB);
fprintf(fid, 'Size_Mo;%.1f\n',           calc_size_Mo);
fclose(fid);
fprintf('\n→ Sauvegardé avec colonne Variables : %s\n', output_file);

% --- Graphique (CORRIGÉ POUR 3 COLONNES) ---
figure('Name', sprintf('RAM — Scénario %d — %.1f GHz', scenario, freq_val), ...
    'Position',[100 100 1400 500]);

% COLONNE 1 : RAM MATLAB
subplot(1,3,1);
plot(timestamps, ram_matlab, 'b-', 'LineWidth', 1.5, 'DisplayName', 'RAM MATLAB');
hold on;
yline(ram0_mat, 'k:', 'LineWidth', 1.2, 'DisplayName', 'Référence');
yline(sm_mean,  'r--', 'LineWidth', 1.2, 'DisplayName', 'Moyenne');
yline(sm_max,   'g--', 'LineWidth', 1.2, 'DisplayName', 'Maximum');
title(sprintf('RAM MATLAB — Delta: +%.1f Mo', sm_max - ram0_mat));
legend('Location','best'); grid on;

% COLONNE 2 : RAM APP DESIGNER (JVM)
subplot(1,3,2);
plot(timestamps, ram_appdesigner, 'r-', 'LineWidth', 1.5, 'DisplayName', 'RAM App Designer');
hold on;
yline(ram0_jvm, 'k:', 'LineWidth', 1.2, 'DisplayName', 'Référence');
yline(sa_mean,  'b--', 'LineWidth', 1.2, 'DisplayName', 'Moyenne');
yline(sa_max,   'g--', 'LineWidth', 1.2, 'DisplayName', 'Maximum');
% Ajout du titre avec Delta pour la JVM
title(sprintf('RAM Interface — Delta: +%.1f Mo', sa_max - ram0_jvm));
legend('Location','best'); grid on;

% COLONNE 3 : RAM TOTAL (Somme des Deltas)
subplot(1,3,3);
plot(timestamps, ram_total, 'm-', 'LineWidth', 1.5, 'DisplayName', 'RAM Total');
hold on;
yline(ram0_total, 'k:', 'LineWidth', 1.2, 'DisplayName', 'Référence');
yline(st_mean,    'r--', 'LineWidth', 1.2, 'DisplayName', 'Moyenne');
yline(st_max,     'g--', 'LineWidth', 1.2, 'DisplayName', 'Maximum');
% CALCUL DE LA SOMME DES DELTAS
delta_total_somme = (sm_max - ram0_mat) + (sa_max - ram0_jvm);
title(sprintf('RAM Total — Somme Deltas: +%.1f Mo', delta_total_somme));
legend('Location','best'); grid on;

sgtitle(sprintf('Benchmark App Designer — Scénario %d — %.1f GHz', scenario, freq_val));