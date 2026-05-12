%% graph_temps_vs_frequence.m
clear; clc;

freq_vals = [1.3, 2.0, 2.8, 3.6, 4.5];
n         = length(freq_vals);
temps_AD  = zeros(1, n);
temps_GUI = zeros(1, n);

for s = 1:n

    % ── App Designer ──
    fname = sprintf('benchmark_AD_%d_%.1fGHz.csv', s, freq_vals(s));
    if ~isfile(fname)
        fprintf('⚠️ Manquant AD scénario %d\n', s);
        temps_AD(s) = NaN;
    else
        fid = fopen(fname, 'r');
        while ~feof(fid)
            ligne = fgetl(fid);
            if ~ischar(ligne); break; end
            parts = strsplit(ligne, ';');
            if length(parts) >= 2 && strcmp(parts{1}, 'Temps_calcul_s')
                temps_AD(s) = str2double(parts{2});
                break;
            end
        end
        fclose(fid);
        fprintf('AD  scénario %d (%.1f GHz) : %.1f s\n', s, freq_vals(s), temps_AD(s));
    end

    % ── GUI Toolbox ──
    fname = sprintf('benchmark_GUI_%d_%.1fGHz.csv', s, freq_vals(s));
    if ~isfile(fname)
        fprintf('⚠️ Manquant GUI scénario %d\n', s);
        temps_GUI(s) = NaN;
    else
        fid = fopen(fname, 'r');
        while ~feof(fid)
            ligne = fgetl(fid);
            if ~ischar(ligne); break; end
            parts = strsplit(ligne, ';');
            if length(parts) >= 2 && strcmp(parts{1}, 'Temps_calcul_s')
                temps_GUI(s) = str2double(parts{2});
                break;
            end
        end
        fclose(fid);
        fprintf('GUI scénario %d (%.1f GHz) : %.1f s\n', s, freq_vals(s), temps_GUI(s));
    end
end

% Graphique
figure('Name','Temps calcul vs Fréquence','Position',[100 100 900 500]);
hold on;

plot(freq_vals, temps_AD,  'b-o', 'LineWidth', 2, 'MarkerSize', 8, ...
    'MarkerFaceColor', [0.20 0.45 0.75], 'DisplayName', 'App Designer');
plot(freq_vals, temps_GUI, 'r-s', 'LineWidth', 2, 'MarkerSize', 8, ...
    'MarkerFaceColor', [0.85 0.25 0.25], 'DisplayName', 'GUI Layout Toolbox');

% Valeurs sur les points
all_t  = [temps_AD, temps_GUI];
all_t  = all_t(~isnan(all_t));
offset = max(all_t) * 0.04;
for i = 1:n
    if ~isnan(temps_AD(i))
        text(freq_vals(i), temps_AD(i) + offset, sprintf('%.1f s', temps_AD(i)), ...
            'HorizontalAlignment','center','FontSize',10,'FontWeight','bold', ...
            'Color',[0.20 0.45 0.75]);
    end
    if ~isnan(temps_GUI(i))
        text(freq_vals(i), temps_GUI(i) - offset*1.8, sprintf('%.1f s', temps_GUI(i)), ...
            'HorizontalAlignment','center','FontSize',10,'FontWeight','bold', ...
            'Color',[0.85 0.25 0.25]);
    end
end

xlim([1.0 5.0]);
ylim([0, max(all_t) * 1.3]);
xticks(freq_vals);
xticklabels({'1.3 GHz', '2.0 GHz', '2.8 GHz', '3.6 GHz', '4.5 GHz'});
xlabel('Fréquence radar (GHz)', 'FontSize', 13);
ylabel('Temps de calcul (s)',   'FontSize', 13);
title('Temps de calcul — App Designer vs GUI Layout Toolbox', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 12);
grid on; grid minor;