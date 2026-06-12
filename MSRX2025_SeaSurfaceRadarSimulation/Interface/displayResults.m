function displayResults(results)
%% DISPLAYRESULTS - Affiche les résultats dans la console

fprintf('\n========================================\n');
fprintf('RÉSULTATS DU BENCHMARK\n');
fprintf('========================================\n');
fprintf('n_s = %d\n', results.n_s);
fprintf('Workers = %d\n', results.nWorkers);
fprintf('\n');
fprintf('%-10s %-15s %-18s %-12s %-12s\n', ...
    'Nprof', 'for (s)', 'parfor (s)', 'Speedup', 'Efficacité');
fprintf('%s\n', repmat('-', 1, 70));

valid_par = ~isnan(results.times_par_mean);
if any(valid_par)
    times_par_interp = interp1(results.Nprof_values(valid_par), ...
        results.times_par_mean(valid_par), results.Nprof_values, 'linear', 'extrap');
    speedup = results.times_seq_mean ./ times_par_interp;
    
    for i = 1:length(results.Nprof_values)
        if ~isnan(results.times_par_mean(i))
            eff = speedup(i) / results.nWorkers * 100;
            fprintf('%-10d %8.2f ± %-5.2f  %8.2f ± %-5.2f  %6.2fx     %5.1f%%\n', ...
                results.Nprof_values(i), ...
                results.times_seq_mean(i), results.times_seq_std(i), ...
                results.times_par_mean(i), results.times_par_std(i), ...
                speedup(i), eff);
        else
            fprintf('%-10d %8.2f ± %-5.2f  %18s %12s\n', ...
                results.Nprof_values(i), ...
                results.times_seq_mean(i), results.times_seq_std(i), ...
                'N/A', 'N/A');
        end
    end
    
    % Point de croisement
    idx_cross = find(speedup > 1, 1, 'first');
    if ~isempty(idx_cross)
        fprintf('\n>>> Point de croisement: N = %d profils\n', results.Nprof_values(idx_cross));
        fprintf('    À partir de ce nombre, parfor devient plus rapide que for\n');
    end
else
    for i = 1:length(results.Nprof_values)
        fprintf('%-10d %8.2f ± %-5.2f  %18s %12s\n', ...
            results.Nprof_values(i), ...
            results.times_seq_mean(i), results.times_seq_std(i), ...
            'N/A', 'N/A');
    end
end
fprintf('========================================\n');
end