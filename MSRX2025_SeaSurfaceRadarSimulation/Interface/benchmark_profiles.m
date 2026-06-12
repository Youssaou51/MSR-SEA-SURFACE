%% BENCHMARK: Performance Comparison for Profile Generation
% Compare sequential (for) vs parallel (parfor) performance
% Run this script independently to analyze performance

clear; close all; clc;

%% Configuration
% Paramètres fixes pour le benchmark (vous pouvez les modifier)
u10 = 10;           % wind speed (m/s)
fetch_m = 500000;   % fetch (m)
l_s = 200;          % length (m)
freq = 1.30;        % radar frequency (GHz)
nlb = 8;            % samples per wavelength
prec = 2;           % precision (2 = double)

% Valeurs de Nprof à tester
Nprof_values = [1, 2, 4, 6, 8, 10, 12, 16, 20, 25, 30, 35, 40, 45, 50];

% Nombre de répétitions pour moyenne (plus précis)
n_repeats = 3;

%% Calcul de n_s
c_ms = 3e8;
lambda_m = c_ms / (freq * 1e9);
n_s_raw = round(l_s / lambda_m) * nlb;
n_s = 2^nextpow2(n_s_raw);

fprintf('========================================\n');
fprintf('BENCHMARK CONFIGURATION\n');
fprintf('========================================\n');
fprintf('n_s = %d samples per profile\n', n_s);
fprintf('Length = %.1f m\n', l_s);
fprintf('Frequency = %.2f GHz → λ = %.2f cm\n', freq, lambda_m*100);
fprintf('nlb = %d\n', nlb);
fprintf('Wind speed = %.1f m/s\n', u10);
fprintf('Fetch = %.0f m\n', fetch_m);
fprintf('========================================\n\n');

%% Vérifier le pool parallèle
pool = gcp('nocreate');
if isempty(pool)
    try
        fprintf('Starting parallel pool...\n');
        pool = parpool('local');
        fprintf('Pool started with %d workers\n', pool.NumWorkers);
    catch
        fprintf('Parallel Computing Toolbox not available - sequential only\n');
    end
else
    fprintf('Parallel pool already exists with %d workers\n', pool.NumWorkers);
end

if ~isempty(pool)
    nWorkers = pool.NumWorkers;
else
    nWorkers = 0;
end

%% Variables locales pour éviter la sérialisation
u10_loc = u10;
l_s_loc = l_s;
n_s_loc = n_s;
fetch_loc = fetch_m;
prec_loc = prec;

%% Benchmark séquentiel
fprintf('\n--- Running SEQUENTIAL benchmark ---\n');
times_seq = zeros(length(Nprof_values), n_repeats);

for r = 1:n_repeats
    fprintf('  Repeat %d/%d...\n', r, n_repeats);
    for idx = 1:length(Nprof_values)
        Nprof = Nprof_values(idx);
        
        tic;
        for k = 1:Nprof
            [H_k, X_h_k, ~, ~, ~, ~, ~] = f_GeneSurfMer2D_ElfoGauss_Fetch_v2b( ...
                u10_loc, l_s_loc, n_s_loc, double(k), fetch_loc, prec_loc);
        end
        times_seq(idx, r) = toc;
        
        % Progression
        if mod(idx, 5) == 0 || idx == length(Nprof_values)
            fprintf('    Nprof=%3d: %.2f s\n', Nprof, times_seq(idx, r));
        end
    end
end
times_seq_mean = mean(times_seq, 2);
times_seq_std = std(times_seq, 0, 2);

%% Benchmark parallèle (seulement si pool disponible et Nprof >= workers)
times_par = NaN(length(Nprof_values), n_repeats);

if nWorkers > 0
    fprintf('\n--- Running PARALLEL benchmark ---\n');
    for r = 1:n_repeats
        fprintf('  Repeat %d/%d...\n', r, n_repeats);
        for idx = 1:length(Nprof_values)
            Nprof = Nprof_values(idx);
            
            % Ne tester que si Nprof >= nombre de workers (sinon parallèle inutile)
            if Nprof >= nWorkers && Nprof >= 4
                tic;
                parfor k = 1:Nprof
                    [H_k, X_h_k, ~, ~, ~, ~, ~] = f_GeneSurfMer2D_ElfoGauss_Fetch_v2b( ...
                        u10_loc, l_s_loc, n_s_loc, double(k), fetch_loc, prec_loc);
                end
                times_par(idx, r) = toc;
                
                if mod(idx, 5) == 0 || idx == length(Nprof_values)
                    fprintf('    Nprof=%3d: %.2f s\n', Nprof, times_par(idx, r));
                end
            end
        end
    end
    times_par_mean = mean(times_par, 2, 'omitnan');
    times_par_std = std(times_par, 0, 2, 'omitnan');
else
    times_par_mean = NaN(size(Nprof_values));
    times_par_std = NaN(size(Nprof_values));
    fprintf('\nParallel benchmark skipped (no pool available)\n');
end

%% Sauvegarder les résultats
results.Nprof_values = Nprof_values;
results.times_seq_mean = times_seq_mean;
results.times_seq_std = times_seq_std;
results.times_par_mean = times_par_mean;
results.times_par_std = times_par_std;
results.n_s = n_s;
results.nlb = nlb;
results.l_s = l_s;
results.freq = freq;
results.u10 = u10;
results.fetch_m = fetch_m;
results.nWorkers = nWorkers;
results.date = datestr(now);

save('benchmark_results.mat', 'results');
fprintf('\nResults saved to benchmark_results.mat\n');

%% Créer le graphique
fprintf('\n--- Generating plots ---\n');

% Figure principale
figure('Name', 'Profile Generation Benchmark', 'Position', [100 100 1200 800], 'Color', 'white');

% Subplot 1: Temps d'exécution
subplot(2, 2, 1);
hold on;

% Courbe séquentielle
errorbar(Nprof_values, times_seq_mean, times_seq_std, 'b-o', 'LineWidth', 2, ...
    'MarkerSize', 8, 'MarkerFaceColor', 'b', 'DisplayName', 'Sequential (for)');

% Courbe parallèle (si disponible)
valid_par = ~isnan(times_par_mean);
if any(valid_par)
    errorbar(Nprof_values(valid_par), times_par_mean(valid_par), times_par_std(valid_par), ...
        'r-s', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'r', ...
        'DisplayName', sprintf('Parallel (parfor) - %d workers', nWorkers));
end

xlabel('Number of Profiles (N_{prof})', 'FontSize', 12);
ylabel('Execution Time (seconds)', 'FontSize', 12);
title('Execution Time vs Number of Profiles', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northwest', 'FontSize', 10);
grid on;
hold off;

% Subplot 2: Speedup (T_seq / T_par)
subplot(2, 2, 2);
if any(valid_par)
    % Interpoler les temps parallèles pour tous les points
    times_par_interp = interp1(Nprof_values(valid_par), times_par_mean(valid_par), ...
        Nprof_values, 'linear', 'extrap');
    speedup = times_seq_mean ./ times_par_interp;
    
    hold on;
    % Barres pour le speedup
    bar(Nprof_values, speedup, 'FaceColor', [0.3 0.7 0.3], 'EdgeColor', 'k');
    % Ligne de seuil (speedup = 1)
    plot([min(Nprof_values), max(Nprof_values)], [1, 1], 'r--', 'LineWidth', 2, ...
        'DisplayName', 'No gain threshold');
    
    xlabel('Number of Profiles (N_{prof})', 'FontSize', 12);
    ylabel('Speedup (T_{seq} / T_{par})', 'FontSize', 12);
    title('Parallel Speedup', 'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'northwest', 'FontSize', 10);
    grid on;
    
    % Ajouter des labels sur les barres
    for i = 1:length(Nprof_values)
        if speedup(i) > 0.5
            text(Nprof_values(i), speedup(i) + 0.05, sprintf('%.2fx', speedup(i)), ...
                'HorizontalAlignment', 'center', 'FontSize', 8);
        end
    end
    hold off;
else
    text(0.5, 0.5, 'Parallel data not available\n(no parallel pool or Nprof too small)', ...
        'HorizontalAlignment', 'center', 'FontSize', 12);
    axis off;
end

% Subplot 3: Efficacité parallèle
subplot(2, 2, 3);
if any(valid_par) && nWorkers > 0
    efficiency = speedup / nWorkers * 100;
    
    hold on;
    bar(Nprof_values, efficiency, 'FaceColor', [0.7 0.3 0.7], 'EdgeColor', 'k');
    plot([min(Nprof_values), max(Nprof_values)], [100, 100], 'r--', 'LineWidth', 2, ...
        'DisplayName', 'Ideal (100%%)');
    
    xlabel('Number of Profiles (N_{prof})', 'FontSize', 12);
    ylabel('Parallel Efficiency (%%)', 'FontSize', 12);
    title(sprintf('Parallel Efficiency (%d workers)', nWorkers), 'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'northeast', 'FontSize', 10);
    grid on;
    ylim([0, max(110, max(efficiency) * 1.1)]);
    hold off;
else
    text(0.5, 0.5, 'Efficiency data not available', ...
        'HorizontalAlignment', 'center', 'FontSize', 12);
    axis off;
end

% Subplot 4: Résumé et recommandation
subplot(2, 2, 4);
axis off;

% Calculer le gain maximum
if any(valid_par)
    [max_speedup, idx_max] = max(speedup);
    best_Nprof = Nprof_values(idx_max);
    
    % Seuil recommandé (où speedup > 1.2)
    threshold_idx = find(speedup > 1.2, 1, 'first');
    if ~isempty(threshold_idx)
        recommended_Nprof = Nprof_values(threshold_idx);
    else
        recommended_Nprof = NaN;
    end
else
    max_speedup = NaN;
    best_Nprof = NaN;
    recommended_Nprof = NaN;
end

% Texte du résumé
summary_text = {
    '══════════════════════════════════════════════'
    '           BENCHMARK SUMMARY'
    '══════════════════════════════════════════════'
    sprintf('n_s (samples/profile): %d', n_s)
    sprintf('Length: %.1f m', l_s)
    sprintf('Frequency: %.2f GHz', freq)
    sprintf('Wavelength: %.2f cm', lambda_m * 100)
    sprintf('Wind speed: %.1f m/s', u10)
    sprintf('Fetch: %.0f km', fetch_m / 1000)
    sprintf('nlb: %d', nlb)
    sprintf('Workers: %d', nWorkers)
    '──────────────────────────────────────────────'
    sprintf('Time (N=%d): Seq = %.2f ± %.2f s', Nprof_values(end), times_seq_mean(end), times_seq_std(end))
    };

if any(valid_par) && ~isnan(times_par_mean(end))
    summary_text{end+1} = sprintf('Time (N=%d): Par = %.2f ± %.2f s', Nprof_values(end), times_par_mean(end), times_par_std(end));
    summary_text{end+1} = sprintf('Speedup (N=%d): %.2fx', Nprof_values(end), speedup(end));
end

if ~isnan(max_speedup)
    summary_text{end+1} = sprintf('Max Speedup: %.2fx at N=%d', max_speedup, best_Nprof);
end

summary_text{end+1} = '──────────────────────────────────────────────';
summary_text{end+1} = 'RECOMMENDATION:';

if any(valid_par)
    if ~isnan(recommended_Nprof)
        summary_text{end+1} = sprintf('✓ Use parallel mode for Nprof ≥ %d', recommended_Nprof);
        summary_text{end+1} = sprintf('  (Speedup > 1.2 at N=%d)', recommended_Nprof);
    elseif max_speedup > 1.1
        summary_text{end+1} = '✓ Parallel mode is beneficial for all Nprof ≥ workers';
    else
        summary_text{end+1} = '⚠ Parallel mode NOT beneficial with current settings';
        summary_text{end+1} = '  → Increase Length or Samples/wavelength';
        summary_text{end+1} = sprintf('  → Current n_s = %d (recommend n_s ≥ 2000)', n_s);
    end
else
    summary_text{end+1} = '⚠ Parallel mode not available';
    summary_text{end+1} = '  → Install Parallel Computing Toolbox';
    summary_text{end+1} = '  → Or run "parpool" manually';
end

text(0.05, 0.95, summary_text, 'Units', 'normalized', ...
    'VerticalAlignment', 'top', 'FontSize', 9, 'FontName', 'Courier New', ...
    'BackgroundColor', [0.95 0.95 0.95], 'EdgeColor', [0.3 0.3 0.3]);

% Titre global
sgtitle(sprintf('Profile Generation Performance Benchmark (n_s = %d)', n_s), ...
    'FontSize', 16, 'FontWeight', 'bold');

%% Sauvegarder la figure
saveas(gcf, 'benchmark_results.png');
savefig('benchmark_results.fig');
fprintf('Plots saved to benchmark_results.png and benchmark_results.fig\n');

%% Afficher le résumé dans la console
fprintf('\n========================================\n');
fprintf('BENCHMARK RESULTS SUMMARY\n');
fprintf('========================================\n');
fprintf('n_s = %d\n', n_s);
fprintf('Workers = %d\n', nWorkers);
fprintf('\n');
fprintf('Nprof   Sequential(s)   Parallel(s)   Speedup   Efficiency\n');
fprintf('-----   -------------   -----------   -------   ----------\n');
for i = 1:length(Nprof_values)
    if ~isnan(times_par_mean(i))
        fprintf('%3d     %8.2f ± %5.2f    %8.2f ± %5.2f    %6.2fx     %5.1f%%\n', ...
            Nprof_values(i), times_seq_mean(i), times_seq_std(i), ...
            times_par_mean(i), times_par_std(i), speedup(i), speedup(i)/nWorkers*100);
    else
        fprintf('%3d     %8.2f ± %5.2f        N/A          N/A       N/A\n', ...
            Nprof_values(i), times_seq_mean(i), times_seq_std(i));
    end
end
fprintf('========================================\n');

%% Nettoyage (optionnel - fermer le pool si vous voulez)
% delete(gcp('nocreate'));