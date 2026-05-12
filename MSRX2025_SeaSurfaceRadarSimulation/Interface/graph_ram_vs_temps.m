%% graph_ram_vs_temps.m
clear; clc;

freq_vals = [1.3, 2.0, 2.8, 3.6, 4.5];
n         = length(freq_vals);
colors    = lines(n);

t_AD_all  = cell(1, n);
t_GUI_all = cell(1, n);
r_AD_all  = cell(1, n);
r_GUI_all = cell(1, n);

for s = 1:n

    % ── App Designer ──
    fname = sprintf('benchmark_AD_%d_%.1fGHz.csv', s, freq_vals(s));
    if ~isfile(fname)
        fprintf('⚠️ Manquant AD scénario %d\n', s);
    else
        fid      = fopen(fname, 'r');
        t_tmp    = [];
        r_tmp    = [];
        ram0_val = NaN;

        while ~feof(fid)
            ligne = fgetl(fid);
            if ~ischar(ligne); break; end
            parts = strsplit(ligne, ';');

            % Lire RAM0_Total — référence exacte
            if length(parts) >= 2 && strcmp(parts{1}, 'RAM0_Total')
                ram0_val = str2double(parts{2});
            end

            % Lire données brutes Time_s + RAM_Total_Mo
            if length(parts) >= 4
                t_val = str2double(parts{1});
                r_val = str2double(parts{4});
                if ~isnan(t_val) && ~isnan(r_val) && t_val >= 0
                    t_tmp(end+1) = t_val;
                    r_tmp(end+1) = r_val;
                end
            end
        end
        fclose(fid);

        % Normaliser par RAM0_Total ← référence exacte ✅
        if ~isempty(r_tmp)
            if ~isnan(ram0_val)
                r_tmp = r_tmp - ram0_val;
            else
                r_tmp = r_tmp - r_tmp(1);  % fallback
            end
        end

        t_AD_all{s} = t_tmp;
        r_AD_all{s} = r_tmp;
        fprintf('AD  scénario %d (%.1f GHz) : %d mesures | RAM0=%.1f Mo\n', ...
            s, freq_vals(s), length(t_tmp), ram0_val);
    end

    % ── GUI Toolbox ──
    fname = sprintf('benchmark_GUI_%d_%.1fGHz.csv', s, freq_vals(s));
    if ~isfile(fname)
        fprintf('⚠️ Manquant GUI scénario %d\n', s);
    else
        fid      = fopen(fname, 'r');
        t_tmp    = [];
        r_tmp    = [];
        ram0_val = NaN;

        while ~feof(fid)
            ligne = fgetl(fid);
            if ~ischar(ligne); break; end
            parts = strsplit(ligne, ';');

            % Lire RAM0_Total
            if length(parts) >= 2 && strcmp(parts{1}, 'RAM0_Total')
                ram0_val = str2double(parts{2});
            end

            % Lire données brutes
            if length(parts) >= 4
                t_val = str2double(parts{1});
                r_val = str2double(parts{4});
                if ~isnan(t_val) && ~isnan(r_val) && t_val >= 0
                    t_tmp(end+1) = t_val;
                    r_tmp(end+1) = r_val;
                end
            end
        end
        fclose(fid);

        % Normaliser par RAM0_Total
        if ~isempty(r_tmp)
            if ~isnan(ram0_val)
                r_tmp = r_tmp - ram0_val;
            else
                r_tmp = r_tmp - r_tmp(1);
            end
        end

        t_GUI_all{s} = t_tmp;
        r_GUI_all{s} = r_tmp;
        fprintf('GUI scénario %d (%.1f GHz) : %d mesures | RAM0=%.1f Mo\n', ...
            s, freq_vals(s), length(t_tmp), ram0_val);
    end
end

% ── Graphique ──
figure('Name','RAM calcul f(Temps)','Position',[100 100 1100 580]);
hold on;

for s = 1:n
    if ~isempty(t_AD_all{s})
        plot(t_AD_all{s}, r_AD_all{s}, '-', ...
            'LineWidth', 2, 'Color', colors(s,:), ...
            'DisplayName', sprintf('AD  %.1f GHz', freq_vals(s)));
    end
    if ~isempty(t_GUI_all{s})
        plot(t_GUI_all{s}, r_GUI_all{s}, '--', ...
            'LineWidth', 2, 'Color', colors(s,:), ...
            'DisplayName', sprintf('GUI %.1f GHz', freq_vals(s)));
    end
end

yline(0, 'k-', 'LineWidth', 1, 'DisplayName', 'Référence (0)');

xlabel('Temps (s)',    'FontSize', 13);
ylabel('RAM calcul (Mo) — whos', 'FontSize', 13);
title({'RAM consommée par le calcul f(Temps) — méthode whos', ...
       'App Designer (—) vs GUI Layout Toolbox (- -)'}, 'FontSize', 14);
legend('Location', 'eastoutside', 'FontSize', 10);
grid on; grid minor;
