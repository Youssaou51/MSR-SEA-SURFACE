%% benchmark_RAM_GUI.m
clear; clc;

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
output_file = sprintf('benchmark_GUI_%d_%.1fGHz.csv', scenario, freq_val);

fprintf('\n=== BENCHMARK RAM — GUI Layout Toolbox ===\n');
fprintf('=== Scénario %d — %.1f GHz ===\n\n', scenario, freq_val);

% ── ÉTAPE 1 — JVM avant ouverture GUI ──
rt_base  = java.lang.Runtime.getRuntime();
jvm_base = (rt_base.totalMemory - rt_base.freeMemory) / 1e6;
fprintf('JVM sans GUI : %.1f Mo\n', jvm_base);
fprintf('\n→ Ouvre maintenant SeaRadarSimulator\n');
fprintf('→ Appuie sur Entrée quand la fenêtre est bien ouverte\n\n');
pause;

% ── ÉTAPE 2 — JVM après ouverture GUI ──
rt_gui            = java.lang.Runtime.getRuntime();
jvm_gui           = (rt_gui.totalMemory - rt_gui.freeMemory) / 1e6;
ram_interface_GUI = jvm_gui - jvm_base;
fprintf('JVM avec GUI      : %.1f Mo\n',   jvm_gui);
fprintf('RAM interface GUI : %.1f Mo\n\n', ram_interface_GUI);

fprintf('→ Dans SeaRadarSimulator : mettre la fréquence à %.1f GHz\n', freq_val);
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
ram0_jvm   = jvm_gui;
ram0_total = ram0_mat + ram0_jvm;
fprintf('\n✅ CALCUL DÉMARRÉ\n');
fprintf('RAM référence MATLAB      : %.1f Mo\n', ram0_mat);
fprintf('RAM référence GUI Toolbox : %.1f Mo\n', ram0_jvm);
fprintf('RAM référence Total       : %.1f Mo\n\n', ram0_total);

timestamps     = [];
ram_matlab     = [];
ram_guitoolbox = [];
ram_total      = [];
t_start        = tic;
i              = 0;

while true
    t_iter = tic;
    i = i + 1;
    timestamps(i) = toc(t_start);

    [user, ~]         = memory;
    ram_matlab(i)     = user.MemUsedMATLAB / 1e6;
    rt                = java.lang.Runtime.getRuntime();
    ram_guitoolbox(i) = (rt.totalMemory - rt.freeMemory) / 1e6;
    ram_total(i)      = ram_matlab(i) + ram_guitoolbox(i);

    fprintf('[%.1f s] MATLAB: %.1f Mo | GUI: %.1f Mo | Total: %.1f Mo | Delta: %+.1f Mo\n', ...
        timestamps(i), ram_matlab(i), ram_guitoolbox(i), ram_total(i), ...
        ram_matlab(i) - ram0_mat);

    if isfile(flag_done)
        fid2  = fopen(flag_done, 'r');
        ligne = fgetl(fid2);
        fclose(fid2);
        try; delete(flag_done); catch; end

        parts = strsplit(ligne, ';');

if numel(parts) < 6
    error('Format invalide dans flag_done : attendu 6 champs, reçu %d', numel(parts));
end

calc_temps     = str2double(parts{1});
calc_ram_MB    = str2double(parts{2});
calc_ram_avant = str2double(parts{3});
calc_nx        = str2double(parts{4});
calc_ny        = str2double(parts{5});
calc_size_Mo   = str2double(parts{6});

        calc_ram_apres = calc_ram_avant + calc_ram_MB;

        fprintf('\n✅ CALCUL TERMINÉ — %.2f s\n', calc_temps);
        fprintf('RAM avant calcul : %.1f Mo\n', calc_ram_avant);
        fprintf('RAM après calcul : %.1f Mo\n', calc_ram_apres);
        fprintf('Delta RAM        : %.1f Mo\n', calc_ram_MB);
        break;
    end

    elapsed   = toc(t_iter);
    remaining = interval_s - elapsed;
    if remaining > 0; pause(remaining); end
end

% Stats
n_mes   = length(timestamps);
sm_min  = min(ram_matlab);        sm_max  = max(ram_matlab);
sm_mean = mean(ram_matlab);       sm_std  = std(ram_matlab);
sg_min  = min(ram_guitoolbox);    sg_max  = max(ram_guitoolbox);
sg_mean = mean(ram_guitoolbox);   sg_std  = std(ram_guitoolbox);
st_min  = min(ram_total);         st_max  = max(ram_total);
st_mean = mean(ram_total);        st_std  = std(ram_total);

fprintf('\n=== STATISTIQUES (%d mesures — %.2f s) ===\n', n_mes, timestamps(end));
fprintf('\n%-15s %10s %10s %10s %10s\n', '', 'Min', 'Max', 'Mean', 'Std');
fprintf('%-15s %10.2f %10.2f %10.2f %10.2f\n', 'RAM_MATLAB',     sm_min, sm_max, sm_mean, sm_std);
fprintf('%-15s %10.2f %10.2f %10.2f %10.2f\n', 'RAM_GUIToolbox', sg_min, sg_max, sg_mean, sg_std);
fprintf('%-15s %10.2f %10.2f %10.2f %10.2f\n', 'RAM_Total',      st_min, st_max, st_mean, st_std);
fprintf('\nRAM interface GUI Toolbox : %.2f Mo\n', ram_interface_GUI);

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

% Données brutes
fprintf(fid, 'Time_s;RAM_MATLAB_Mo;RAM_GUIToolbox_Mo;RAM_Total_Mo\n');
for k = 1:n_mes
    fprintf(fid, '%.4f;%.4f;%.4f;%.4f\n', ...
        timestamps(k), ram_matlab(k), ram_guitoolbox(k), ram_total(k));
end
fprintf(fid, '\n');

% Stats
fprintf(fid, 'Stat;RAM_MATLAB_Mo;RAM_GUIToolbox_Mo;RAM_Total_Mo\n');
fprintf(fid, 'Reference;%.4f;%.4f;%.4f\n', ram0_mat, ram0_jvm, ram0_total);
fprintf(fid, 'Min;%.4f;%.4f;%.4f\n',  sm_min,  sg_min,  st_min);
fprintf(fid, 'Max;%.4f;%.4f;%.4f\n',  sm_max,  sg_max,  st_max);
fprintf(fid, 'Mean;%.4f;%.4f;%.4f\n', sm_mean, sg_mean, st_mean);
fprintf(fid, 'Std;%.4f;%.4f;%.4f\n',  sm_std,  sg_std,  st_std);
%fprintf(fid, 'Delta_Max_Mo;%.4f;%.4f;%.4f\n', ...
   % calc_ram_MB, sg_max-ram0_jvm, calc_ram_MB+(sg_max-ram0_jvm));
% Calcul du Delta Max réel (Pic Système - Référence de base)
fprintf(fid, 'Delta_Max_Mo;%.4f;%.4f;%.4f\n', ...
    sm_max - ram0_mat, sg_max - ram0_jvm, st_max - ram0_total);

fprintf(fid, 'N_mesures;%d;;\n',  n_mes);
fprintf(fid, 'Duree_s;%.4f;;\n',  timestamps(end));
fprintf(fid, '\n');

% RAM interface GUI Toolbox
fprintf(fid, 'RAM_Interface_GUI;Mo\n');
fprintf(fid, 'JVM_sans_GUI;%.4f\n',  jvm_base);
fprintf(fid, 'JVM_avec_GUI;%.4f\n',  jvm_gui);
fprintf(fid, 'RAM_interface;%.4f\n', ram_interface_GUI);
fprintf(fid, '\n');

% Infos calcul
fprintf(fid, 'Info_calcul;Valeur\n');
fprintf(fid, 'Taille;%dx%d\n',           calc_nx, calc_ny);
fprintf(fid, 'Temps_calcul_s;%.4f\n',    calc_temps);
fprintf(fid, 'RAM_avant_MB;%.4f\n',      calc_ram_avant);
fprintf(fid, 'RAM_apres_MB;%.4f\n',      calc_ram_apres);
fprintf(fid, 'RAM_delta_MB;%.4f\n',      calc_ram_MB);
fprintf(fid, 'RAM_used_MB;%.4f\n',       calc_ram_MB);
fprintf(fid, 'Size_Mo;%.1f\n',           calc_size_Mo);
fclose(fid);
fprintf('\n→ Sauvegardé : %s\n', output_file);

% --- Graphique CORRIGÉ (Somme des Deltas) ---
figure('Name', sprintf('RAM GUI — Scénario %d — %.1f GHz', scenario, freq_val), 'Position',[100 100 1400 500]);

% calcul des deltas individuels
d_mat = sm_max - ram0_mat;
d_gui = sg_max - ram0_jvm;
d_total_somme = d_mat + d_gui; % La somme logique

subplot(1,3,1);
plot(timestamps, ram_matlab, 'b-', 'LineWidth', 1.5, 'DisplayName', 'RAM MATLAB');
hold on;
yline(ram0_mat, 'k:', 'LineWidth', 1,   'DisplayName', 'Référence');
yline(sm_mean,  'r--','LineWidth', 1.2, 'DisplayName', 'Moyenne');
yline(sm_max,   'g:', 'LineWidth', 1.2, 'DisplayName', 'Max');
xlabel('Temps (s)'); ylabel('RAM (Mo)');
title(sprintf('RAM MATLAB — Delta: +%.1f Mo', d_mat));
legend('Location','best'); grid on;

subplot(1,3,2);
plot(timestamps, ram_guitoolbox, 'r-', 'LineWidth', 1.5, 'DisplayName', 'RAM GUI Toolbox');
hold on;
yline(ram0_jvm, 'k:', 'LineWidth', 1,   'DisplayName', 'Référence');
yline(sg_mean,  'b--','LineWidth', 1.2, 'DisplayName', 'Moyenne');
yline(sg_max,   'g:', 'LineWidth', 1.2, 'DisplayName', 'Max');
xlabel('Temps (s)'); ylabel('RAM (Mo)');
title(sprintf('RAM Interface — Delta: +%.1f Mo', d_gui));
legend('Location','best'); grid on;

subplot(1,3,3);
plot(timestamps, ram_total, 'm-', 'LineWidth', 1.5, 'DisplayName', 'RAM Total');
hold on;
yline(ram0_total, 'k:', 'LineWidth', 1,   'DisplayName', 'Référence');
yline(st_mean,    'r--','LineWidth', 1.2, 'DisplayName', 'Moyenne');
yline(st_max,     'g:', 'LineWidth', 1.2, 'DisplayName', 'Max');
xlabel('Temps (s)'); ylabel('RAM (Mo)');
% On affiche la somme des deux deltas précédents
title(sprintf('RAM Total — Somme Deltas: +%.1f Mo', d_total_somme));
legend('Location','best');grid on;

sgtitle(sprintf('Benchmark GUI Toolbox — Scénario %d — %.1f GHz', scenario, freq_val));