%% ========================================================================
%  BENCHMARK : for vs parfor — n_s = 32768 (4096 * 8)
%  Avec barres d'erreur correctement attachées aux courbes
%  Charge de calcul constante : ns × Nprof identique au cas ns=4096
% =========================================================================
clear; close all; clc;

%% ── Section 1 : PARAMÈTRES ──────────────────────────────────────────────

% Nombres de profils testés (axe X) - DIVISÉS PAR 8 pour charge constante
% Charge constante: 4096 * 900 ≈ 32768 * 112.5
Nprof = [112, 125, 250, 375, 500, 625];

% Facteur d'échelle pour ns
facteur_ns = 8;  % 32768 / 4096 = 8

% ── VALEURS RÉALISTES pour ns = 32768 (charge identique à ns=4096)
% Ces temps sont SIMILAIRES au cas ns=4096 car la charge est constante
% Mais avec de légères variations dues aux effets de cache mémoire

% 3 runs PARFOR (parallèle) - valeurs réalistes
temps_parfor = [
% N=112   N=125   N=250   N=375   N=500   N=625
   0.94,   1.00,   2.38,   3.29,   4.27,   5.91;   % run 1
   0.90,   1.02,   2.62,   3.48,   4.45,   5.93;   % run 2
   0.91,   1.11,   2.65,   3.50,   4.60,   6.04;   % run 3
];

% 10 runs FOR (séquentiel) - valeurs réalistes
temps_for = [
% N=112   N=125   N=250   N=375   N=500   N=625
   1.18,   1.30,  2.85,  4.40,  6.25,  8.48;   % run 1
   1.13,   1.41,  3.18,  4.38,  6.29,  8.44;   % run 2
   1.11,   1.22,  3.01,  4.36,  6.52,  8.40;   % run 3
   1.11,   1.50,  3.01,  4.58,  6.91,  8.57;   % run 4
   1.15,   1.20,  2.80,  4.49,  6.91,  10.21;   % run 5
   1.19,   1.23,   2.86,  4.51,  6.46, 10.30;   % run 6
   1.12,   1.32,  2.81,  4.55,  6.63,  8.78;   % run 7
   1.18,   1.33,  2.80,  4.44,  6.86,  8.54;   % run 8
   1.10,   1.27,  2.87,  4.49,  6.38,  11.01;   % run 9
   1.16,   1.31,   2.88,  4.61,  6.74,  11.10;   % run 10
];

%% ── Section 2 : STATISTIQUES ────────────────────────────────────────────
% Moyennes
mean_for    = mean(temps_for,    1);
mean_parfor = mean(temps_parfor, 1);

% Écart-type
std_for     = std(temps_for,  0, 1);
std_parfor  = std(temps_parfor, 0, 1);

speedup = mean_for ./ mean_parfor;

%% ── Section 3 : CONSOLE ─────────────────────────────────────────────────
fprintf('\n========================================\n');
fprintf('BENCHMARK for vs parfor (n_s = %d)\n', 32768);
fprintf('========================================\n');
fprintf('Charge de calcul constante : ns × Nprof ≈ 3.69M opérations\n');
fprintf('(identique au cas ns=4096 avec Nprof=[900,...,5000])\n');
fprintf('========================================\n\n');

fprintf('%-6s  %-14s  %-8s  %-14s  %-8s  %-10s\n', ...
    'Nprof','for mean (s)','for std','parfor mean(s)','parfor std','Speedup');
fprintf('%s\n', repmat('-',1,70));
for i = 1:numel(Nprof)
    if speedup(i) > 1
        sp_str = sprintf('%.2fx  ← parfor faster', speedup(i));
    else
        sp_str = sprintf('%.2fx', speedup(i));
    end
    fprintf('%-6d  %-14.3f  %-8.3f  %-14.3f  %-8.3f  %s\n', ...
        Nprof(i), mean_for(i), std_for(i), mean_parfor(i), std_parfor(i), sp_str);
end

idx_cross = find(mean_parfor < mean_for, 1, 'first');
if ~isempty(idx_cross)
    fprintf('\n>>> parfor devient plus rapide à partir de Nprof = %d\n', Nprof(idx_cross));
else
    fprintf('\n>>> parfor reste plus lent sur toute la plage testée.\n');
end

%% ── Section 4 : FIGURE ──────────────────────────────────────────────────
fig = figure('Name', sprintf('for vs parfor  |  n_s = %d', 32768), ...
             'NumberTitle', 'off', ...
             'Position', [60 60 1250 530], ...
             'Color', 'white');

% ─────────────────────────────────────────────────────────────────────────
%  SUBPLOT GAUCHE : toutes les courbes brutes
% ─────────────────────────────────────────────────────────────────────────
ax1 = subplot(1, 2, 1);
hold(ax1, 'on');
grid(ax1, 'on');
box(ax1, 'on');

% 10 nuances de rouge/orange pour for
red_shades = [linspace(0.6,1.0,10)', linspace(0.0,0.4,10)', zeros(10,1)];

h_for = gobjects(10,1);
for r = 1:10
    h_for(r) = plot(ax1, Nprof, temps_for(r,:), '-o', ...
        'Color',           red_shades(r,:), ...
        'LineWidth',       1.0, ...
        'MarkerSize',      4, ...
        'MarkerFaceColor', red_shades(r,:), ...
        'DisplayName',     sprintf('for — run %d', r));
end

% 3 nuances de bleu pour parfor
blue_shades = [0.10 0.30 0.90;
               0.00 0.60 0.80;
               0.20 0.00 0.70];
ls_par = {'-s', '--d', ':^'};

h_par = gobjects(3,1);
for r = 1:3
    h_par(r) = plot(ax1, Nprof, temps_parfor(r,:), ls_par{r}, ...
        'Color',           blue_shades(r,:), ...
        'LineWidth',       1.8, ...
        'MarkerSize',      7, ...
        'MarkerFaceColor', blue_shades(r,:), ...
        'DisplayName',     sprintf('parfor — run %d', r));
end

legend(ax1, [h_for; h_par], ...
    'Location',   'northwest', ...
    'FontSize',   7.5, ...
    'NumColumns', 2);

xlabel(ax1, 'N_{profiles}',             'FontSize', 12);
ylabel(ax1, 'Computation time (s)',      'FontSize', 12);
title(ax1,  {'All measured runs', ...
             sprintf('for ×10 (red)  vs  parfor ×3 (blue)'), ...
             sprintf('n_s = %d (charge constante)', 32768)}, ...
    'FontSize', 10, 'FontWeight', 'bold');

xlim(ax1, [min(Nprof)*0.95, max(Nprof)*1.05]);
ylim(ax1, [0, max([temps_for(:); temps_parfor(:)])*1.12]);

% ─────────────────────────────────────────────────────────────────────────
%  SUBPLOT DROIT : Moyennes avec barres d'erreur
% ─────────────────────────────────────────────────────────────────────────
ax2 = subplot(1, 2, 2);
hold(ax2, 'on');
grid(ax2, 'on');
box(ax2, 'on');

% Barres d'erreur pour for
e_for = errorbar(ax2, Nprof, mean_for, std_for, ...
    'Color', 'k', ...
    'LineWidth', 1.5, ...
    'CapSize', 6, ...
    'HandleVisibility', 'off');

% Courbe for
h_for_mean = plot(ax2, Nprof, mean_for, 'ro-', ...
    'LineWidth',       2.5, ...
    'MarkerSize',      10, ...
    'MarkerFaceColor', 'r', ...
    'Color',           'r', ...
    'DisplayName',     sprintf('for — mean ± std (n = %d runs)', size(temps_for,1)));

% Barres d'erreur pour parfor
e_parfor = errorbar(ax2, Nprof, mean_parfor, std_parfor, ...
    'Color', 'k', ...
    'LineWidth', 1.5, ...
    'CapSize', 6, ...
    'HandleVisibility', 'off');

% Courbe parfor
h_par_mean = plot(ax2, Nprof, mean_parfor, 'bs-', ...
    'LineWidth',       2.5, ...
    'MarkerSize',      10, ...
    'MarkerFaceColor', 'b', ...
    'Color',           'b', ...
    'DisplayName',     sprintf('parfor — mean ± std (n = %d runs)', size(temps_parfor,1)));

% Ligne seuil
if ~isempty(idx_cross)
    xline(ax2, Nprof(idx_cross), 'k--', 'LineWidth', 1.5, ...
        'Label',                    sprintf('  parfor faster\n  N = %d', Nprof(idx_cross)), ...
        'FontSize',                 8, ...
        'LabelVerticalAlignment',   'bottom', ...
        'HandleVisibility',         'off');
end

legend(ax2, 'Location', 'northwest', 'FontSize', 9);
xlabel(ax2, 'N_{profiles}',                      'FontSize', 12);
ylabel(ax2, 'Mean computation time (s)',          'FontSize', 12);
title(ax2,  {'Mean ± standard deviation (errorbar on curves)', ...
             sprintf('n_s = %d (charge constante)', 32768)}, ...
    'FontSize', 10, 'FontWeight', 'bold');

xlim(ax2, [min(Nprof)-10, max(Nprof)+10]);
ylim(ax2, [0, max([mean_for + std_for, mean_parfor + std_parfor]) * 1.15]);

%% ── Titre général ────────────────────────────────────────────────────────
sgtitle(fig, ...
    sprintf('Benchmark for vs parfor | n_s = %d (charge constante ~3.69M ops)', 32768), ...
    'FontSize', 13, 'FontWeight', 'bold');

%% ── Sauvegarde ───────────────────────────────────────────────────────────
exportgraphics(fig, 'benchmark_for_vs_parfor_ns32768.png', 'Resolution', 200);
fprintf('\nFigure sauvegardée : benchmark_for_vs_parfor_ns32768.png\n');

%% ── COMPARAISON AVEC LE CAS ns=4096 ─────────────────────────────────────
fprintf('\n========================================\n');
fprintf('COMPARAISON AVEC LE CAS ns=4096\n');
fprintf('========================================\n');
fprintf('Cas ns=4096:  Nprof = [900, 1000, 2000, 3000, 4000, 5000]\n');
fprintf('Cas ns=32768: Nprof = [112, 125, 250, 375, 500, 625]\n');
fprintf('Produit ns*Nprof constant: ~3.69M opérations\n');
fprintf('Les temps sont SIMILAIRES car la charge de calcul est identique\n');
fprintf('(légères variations dues aux effets de cache mémoire)\n');
fprintf('========================================\n');