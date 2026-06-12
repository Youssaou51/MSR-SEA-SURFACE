%% ========================================================================
%  BENCHMARK : for vs parfor — n_s = 4096
%  Avec barres d'erreur correctement attachées aux courbes
% =========================================================================
clear; close all; clc;

%% ── Section 1 : ENTREZ VOS MESURES ICI ──────────────────────────────────

% Nombres de profils testés (axe X)
Nprof = [900, 1000, 2000, 3000, 4000, 5000];

% ── 3 runs PARFOR (parallèle) ──────────────────────────────────────────
temps_parfor = [
% N=900  N=1000  N=2000  N=3000  N=4000  N=5000
   1.91,   2.26,   6.56,   16.65,   30.91,   48.21;   % run 1
   1.74,   2.27,   6.89,   18.82,   31.29,   46.42;   % run 2
   1.78,   2.30,   7.27,   17.85,   31.66,   48.59;   % run 3
];

% ── 10 runs FOR (séquentiel) ─────────────────────────────────────────
temps_for = [
% N=900   N=1000  N=2000  N=3000  N=4000  N=5000
   2.45,   4.01,   10.71,  37.88,  68.69,  197.24;   % run 1
   2.65,   5.28,   15.55,  39.00,  69.10,  203.93;   % run 2
   2.97,   4.23,   11.86,  37.77,  72.27,  191.04;   % run 3
   3.04,   4.06,   15.21,  35.88,  71.07,  211.15;   % run 4
   3.89,   4.27,   14.68,  34.79,  58.32,  203.87;   % run 5
   3.51,   3.66,   17.94,  39.00,  74.61,  190.91;   % run 6
   2.78,   3.93,   17.09,  39.50,  54.49,  202.82;   % run 7
   3.19,   3.74,   15.00,  35.52,  63.94,  224.66;   % run 8
   3.85,   4.99,  12.25,   37.88,  53.86,  213.26;   % run 9
   3.44,   3.73,   17.01,  37.53,  65.32,  223.92;   % run 10
];

%% ── Section 2 : STATISTIQUES ────────────────────────────────────────────
% Moyennes
mean_for    = mean(temps_for,    1);
mean_parfor = mean(temps_parfor, 1);

% Écart-type (symétrique)
std_for     = std(temps_for,  0, 1);
std_parfor  = std(temps_parfor, 0, 1);

% Min et Max (pour barres asymétriques si besoin)
min_for = min(temps_for, [], 1);
max_for = max(temps_for, [], 1);
min_parfor = min(temps_parfor, [], 1);
max_parfor = max(temps_parfor, [], 1);

speedup = mean_for ./ mean_parfor;

%% ── Section 3 : CONSOLE ─────────────────────────────────────────────────
fprintf('\n=== BENCHMARK for vs parfor  (n_s = 4096) ===\n');
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
fig = figure('Name', 'for vs parfor  |  n_s = 4096', ...
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
             'for ×10 (red)  vs  parfor ×3 (blue)', ...
             'n_s = 4096'}, ...
    'FontSize', 11, 'FontWeight', 'bold');

xlim(ax1, [min(Nprof)*0.95, max(Nprof)*1.05]);
ylim(ax1, [0, max([temps_for(:); temps_parfor(:)])*1.12]);

% ─────────────────────────────────────────────────────────────────────────
%  SUBPLOT DROIT : Moyennes avec barres d'erreur (errorbar standard)
%  Utilisation correcte de la fonction errorbar()
% ─────────────────────────────────────────────────────────────────────────
ax2 = subplot(1, 2, 2);
hold(ax2, 'on');
grid(ax2, 'on');
box(ax2, 'on');

% ==== Barres d'erreur pour for (symétriques) ====
% errorbar(x, y, err) - crée des barres verticales symétriques
e_for = errorbar(ax2, Nprof, mean_for, std_for, ...
    'Color', 'k', ...           % Couleur noire pour les barres
    'LineWidth', 1.5, ...       % Épaisseur des barres
    'CapSize', 6, ...           % Taille des petites barres horizontales aux extrémités
    'HandleVisibility', 'off'); % Cache de la légende

% ==== Courbe for (tracée par-dessus) ====
h_for_mean = plot(ax2, Nprof, mean_for, 'ro-', ...
    'LineWidth',       2.5, ...
    'MarkerSize',      10, ...
    'MarkerFaceColor', 'r', ...
    'Color',           'r', ...
    'DisplayName',     sprintf('for — mean ± std (n = %d runs)', size(temps_for,1)));

% ==== Barres d'erreur pour parfor (symétriques) ====
e_parfor = errorbar(ax2, Nprof, mean_parfor, std_parfor, ...
    'Color', 'k', ...           % Couleur noire pour les barres
    'LineWidth', 1.5, ...       % Épaisseur des barres
    'CapSize', 6, ...           % Taille des petites barres horizontales
    'HandleVisibility', 'off');

% ==== Courbe parfor (tracée par-dessus) ====
h_par_mean = plot(ax2, Nprof, mean_parfor, 'bs-', ...
    'LineWidth',       2.5, ...
    'MarkerSize',      10, ...
    'MarkerFaceColor', 'b', ...
    'Color',           'b', ...
    'DisplayName',     sprintf('parfor — mean ± std (n = %d runs)', size(temps_parfor,1)));

% Ligne verticale seuil de rentabilité
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
             'n_s = 4096'}, ...
    'FontSize', 11, 'FontWeight', 'bold');

xlim(ax2, [min(Nprof)-100, max(Nprof)+100]);
ylim(ax2, [0, max([mean_for + std_for, mean_parfor + std_parfor]) * 1.15]);

%% ── Titre général ────────────────────────────────────────────────────────
sgtitle(fig, ...
    'Profile Generation Benchmark  |  n_s = 4096  |  Sequential (for) vs Parallel (parfor)', ...
    'FontSize', 13, 'FontWeight', 'bold');

%% ── Sauvegarde ───────────────────────────────────────────────────────────
exportgraphics(fig, 'benchmark_for_vs_parfor_ns4096.png', 'Resolution', 200);
fprintf('\nFigure sauvegardée : benchmark_for_vs_parfor_ns4096.png\n');