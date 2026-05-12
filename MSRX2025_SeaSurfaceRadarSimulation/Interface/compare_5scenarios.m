%% compare_5scenarios.m
clear; clc;

freq_vals     = [1.3, 2.0, 2.8, 3.6, 4.5];
n             = length(freq_vals);
delta_max_AD  = zeros(1, n);
delta_max_GUI = zeros(1, n);

for s = 1:n

    % ── App Designer ──
    fname = sprintf('benchmark_AD_%d_%.1fGHz.csv', s, freq_vals(s));
    if ~isfile(fname)
        fprintf('⚠️ Manquant AD scénario %d\n', s);
        delta_max_AD(s) = NaN;
    else
        fid = fopen(fname, 'r');
        while ~feof(fid)
            ligne = fgetl(fid);
            if ~ischar(ligne); break; end
            parts = strsplit(ligne, ';');
            if length(parts) >= 4 && strcmp(parts{1}, 'Delta_Max_Mo')
                delta_max_AD(s) = str2double(parts{4});
                break;
            end
        end
        fclose(fid);
        fprintf('AD  scénario %d (%.1f GHz) : Delta = %.1f Mo\n', s, freq_vals(s), delta_max_AD(s));
    end

    % ── GUI Toolbox ──
    fname = sprintf('benchmark_GUI_%d_%.1fGHz.csv', s, freq_vals(s));
    if ~isfile(fname)
        fprintf('⚠️ Manquant GUI scénario %d\n', s);
        delta_max_GUI(s) = NaN;
    else
        fid = fopen(fname, 'r');
        while ~feof(fid)
            ligne = fgetl(fid);
            if ~ischar(ligne); break; end
            parts = strsplit(ligne, ';');
            if length(parts) >= 4 && strcmp(parts{1}, 'Delta_Max_Mo')
                delta_max_GUI(s) = str2double(parts{4});
                break;
            end
        end
        fclose(fid);
        fprintf('GUI scénario %d (%.1f GHz) : Delta = %.1f Mo\n', s, freq_vals(s), delta_max_GUI(s));
    end
end

% Graphique — courbes avec marqueurs
figure('Name','Comparaison Delta RAM — 5 Scénarios','Position',[100 100 950 570]);
hold on;

plot(freq_vals, delta_max_AD,  'b-o', 'LineWidth', 2, 'MarkerSize', 8, ...
    'MarkerFaceColor', [0.20 0.45 0.75], 'DisplayName', 'App Designer');
plot(freq_vals, delta_max_GUI, 'r-s', 'LineWidth', 2, 'MarkerSize', 8, ...
    'MarkerFaceColor', [0.85 0.25 0.25], 'DisplayName', 'GUI Layout Toolbox');

% Valeurs au-dessus des points
all_vals = [delta_max_AD, delta_max_GUI];
all_vals = all_vals(~isnan(all_vals));
offset   = max(all_vals) * 0.04;

for i = 1:n
    if ~isnan(delta_max_AD(i))
        text(freq_vals(i), delta_max_AD(i) + offset, ...
            sprintf('%.1f Mo', delta_max_AD(i)), ...
            'HorizontalAlignment', 'center', 'FontSize', 10, ...
            'FontWeight', 'bold', 'Color', [0.20 0.45 0.75]);
    end
    if ~isnan(delta_max_GUI(i))
        text(freq_vals(i), delta_max_GUI(i) - offset*1.8, ...
            sprintf('%.1f Mo', delta_max_GUI(i)), ...
            'HorizontalAlignment', 'center', 'FontSize', 10, ...
            'FontWeight', 'bold', 'Color', [0.85 0.25 0.25]);
    end
end

% Axes
xlim([1.0 5.0]);
ylim([0, max(all_vals) * 1.3]);
xticks(freq_vals);
xticklabels({'1.3 GHz', '2.0 GHz', '2.8 GHz', '3.6 GHz', '4.5 GHz'});

xlabel('Fréquence radar (GHz)', 'FontSize', 13);
ylabel('Delta RAM Max (Mo)',     'FontSize', 13);
title('Évolution de la RAM consommée — App Designer vs GUI Layout Toolbox', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 12);
grid on; grid minor;
