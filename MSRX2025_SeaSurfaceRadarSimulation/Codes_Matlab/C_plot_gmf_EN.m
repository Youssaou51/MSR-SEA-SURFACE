% MATLAB script to plot a scatterometer Geophysical Model Function (GMF).
% This is a translation of the Python script by Anton Verhoef (KNMI).
% It creates two plots:
% 1. GMF value vs. Azimuth angle (fixed incidence, varying wind speed).
% 2. GMF value vs. Wind speed (fixed incidence, varying azimuth).
%
% https://gemini.google.com/app/64bcb303328e62b5?hl=fr


clear; clc;

% --- Configuration ---
% Specify your binary GMF file name here
fname = 'gmf_cmod7_vv.dat_little_endian'; 

if ~exist(fname, 'file')
    error('File not found: %s', fname);
end

% Dimensions of GMF table
m = 250;  % wind speed min/max = 0.2-50 (step 0.2) [m/s] --> 250 pts
n = 73;   % dir min/max = 0-180 (step 2.5) [deg]         -->  73 pts
p = 51;   % inc min/max = 16-66 (step 1) [deg]           -->  51 pts

% --- Read Binary File ---
% 'ieee-le' ensures Little Endian byte order reading
fid = fopen(fname, 'r', 'ieee-le'); 
if fid == -1
    error('Could not open file.');
end

% Read data as 32-bit floats
gmf_raw = fread(fid, 'float32');
fclose(fid);

% Remove head and tail (equivalent to python [1:-1])
% MATLAB indices start at 1, so we take from 2 to end-1
gmf_raw = gmf_raw(2:end-1);

% Reshape to 3D matrix (m x n x p)
% MATLAB uses Fortran-order (column-major) by default, matching Python's order="F"
gmf_table = reshape(gmf_raw, [m, n, p]);

% Choose incidence angle to plot
iinc_python = 34; % Original Python index
iinc = iinc_python + 1; % MATLAB index (1-based)
incidence = (iinc_python) + 16.0;

% Setup Figure
figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.7]);

% --- First plot: sigma0 vs. direction ---
subplot(1, 2, 1);
hold on; grid on;

% X-axis data for direction
pltarrx = (0:n-1) * 2.5; 

% Loop for wind speeds (Python range 9, 121, 10 -> MATLAB 10:10:120)
for ispd = 10:10:120
    % Extract data slice and convert to dB
    % 'squeeze' removes singleton dimensions to make it a vector
    gmf_val = squeeze(gmf_table(ispd, :, iinc));
    pltarry = 10.0 * log10(gmf_val);
    
    speed_val = (ispd) * 0.2; % (ispd is 1-based index, matches python ispd+1 logic roughly)
    % Note: Python used (ispd+1)*0.2 where ispd was 0-based index from loop. 
    % In MATLAB ispd is the actual index. 
    % Python: 9 (index) -> speed 2.0. MATLAB: 10 (index) -> speed 2.0.
    
    plot(pltarrx, pltarry, 'DisplayName', sprintf('%.1f m/s', speed_val));
end

title(sprintf('%s, incidence angle %.1f', fname, incidence), 'Interpreter', 'none');
xlabel('Wind direction (\circ)');
ylabel('sigma0 (dB)');
xlim([0, 225]);
xticks(0:45:225);
ylim([-40, -5]);
legend('show', 'Location', 'northeast', 'FontSize', 8);

% --- Second plot: sigma0 vs. speed ---
subplot(1, 2, 2);
hold on; grid on;

% X-axis data for speed
pltarrx_speed = (1:m) * 0.2;

% Loop for directions (Python range 0, 73, 9 -> MATLAB 1:9:73)
for idir = 1:9:73
    % Extract data slice
    gmf_val = squeeze(gmf_table(:, idir, iinc));
    pltarry_speed = 10.0 * log10(gmf_val);
    
    dir_val = (idir - 1) * 2.5;
    plot(pltarrx_speed, pltarry_speed, 'DisplayName', sprintf('%.1f\\circ', dir_val));
end

xlabel('Wind speed (m/s)');
xlim([0, 25]);
ylim([-40, -5]);
legend('show', 'Location', 'southeast', 'FontSize', 8);

% --- Save and Display ---
output_filename = [fname, '.png'];
saveas(gcf, output_filename);
fprintf('Image saved in %s\n', output_filename);