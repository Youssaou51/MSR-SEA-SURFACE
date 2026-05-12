%% SeaRadarSimulator.m - Interface avec la GUI Layout Toolbox pour simulation monostatique
addpath('C:\Users\rosil\AppData\Roaming\MathWorks\MATLAB Add-Ons\Toolboxes\GUI Layout Toolbox'); % Chemin de la toolbox

if ~isdeployed
    addpath('C:\Users\rosil\AppData\Roaming\MathWorks\MATLAB Add-Ons\Toolboxes\GUI Layout Toolbox');
end

clear variables ; clc ; close all ; 
format short ; format compact ;

set(0, 'DefaultFigureVisible', 'on');
global app;

% Fermer toute figure existante avec le même nom
oldFigs = findobj('Type', 'figure', 'Name', 'Sea Surface Radar Simulator');
if ~isempty(oldFigs)
    close(oldFigs);
end

% Création de la figure principale
fig = uifigure('Name', 'Sea Surface Radar Simulator', 'Position', [100 0 1000 700]);
%fig.WindowState = 'maximized';

% Ajout du handle de la figure à app après sa création
app.handles.fig = fig;
app.handles.curves = struct('theta', {}, 'nrcs_dB', {}, 'params', {}, 'color', {}); %structure pour stocker les courbes 

% Layout principal : Onglets pour NRCS et Surface de Mer
tabGroup = uitabgroup('Parent', fig, 'Position', [0 0 1000 700]);
tabNRCS = uitab('Parent', tabGroup, 'Title', 'NRCS Simulation'); % Premier onglet
tabSeaSurface = uitab('Parent', tabGroup, 'Title', 'Sea Surface Generation'); % Deuxième onglet
tabParallel = uitab('Parent', tabGroup, 'Title', 'Parallelisation'); % Onglet pour test de parallélisation
%% Layout principal dans l'onglet NRCS - Premier onglet
mainLayoutNRCS = uix.VBox('Parent', tabNRCS, 'Padding', 0, 'Spacing', 0);

% Bande orange en haut
headerPanel = uix.Panel('Parent', mainLayoutNRCS, 'BackgroundColor', [1 0.5 0]); % Couleur orange vif
headerLayout = uix.HBox('Parent', headerPanel, 'Padding', 5, 'Spacing', 10);

% Ajout du titre
titleLabel = uilabel('Parent', headerLayout, 'Text', 'Sea Surface Radar Simulator', ...
    'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

% Ajout des deux logos avec ajustement dynamique
try
    % Chargement des deux logos
    logoICAM = imread('logo_icam.png'); 
    logoIETR = imread('logo_ietr.png');

    % Panel horizontal pour aligner les deux logos proprement
    logoPanel = uipanel('Parent', headerLayout, 'BorderType', 'none');
    logoBox   = uix.HBox('Parent', logoPanel, 'Spacing', 5);  % 20 px d'écart entre les logos
    
    % Logo ICAM
    ax1 = uiaxes('Parent', logoBox, 'Visible', 'off');
    image(ax1, logoICAM);
    axis(ax1, 'image'); axis off;

    % Logo IETR
    ax2 = uiaxes('Parent', logoBox, 'Visible', 'off');
    image(ax2, logoIETR);
    axis(ax2, 'image'); axis off;

    % Forcer les deux logos à prendre la même hauteur
    logoBox.Widths = [-1 -1];  % largeur automatique proportionnelle

    % Callback pour ajuster la taille des logo
    headerPanel.SizeChangedFcn = @resizeLogos;

    
catch
    uilabel('Parent', headerLayout, ...
            'Text', 'ICAM | IETR', ...
            'FontSize', 14, ...
            'FontWeight', 'bold');
end

% Définition des largeurs après avoir ajouté les enfants
set(headerLayout, 'Widths', [-1 250]); % Titre flexible, logos fixes 

% Contenu principal : HBox pour gauche (params) + droite (affichages)
contentLayout = uix.HBox('Parent', mainLayoutNRCS, 'Padding', 5, 'Spacing', 5);

% Section gauche : VBox pour paramètres
paramsPanel = uix.VBox('Parent', contentLayout, 'Padding', 5, 'Spacing', 10);
uilabel('Parent', paramsPanel, 'Text', 'Input Parameters', 'FontWeight', 'bold');

% Bande de fréquence
bandHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', bandHBox, 'Text', 'Frequency Band:');
bandDrop = uidropdown('Parent', bandHBox, 'Items', {'UHF: 0.3 - 1 GHz', 'L-band: 1 - 2 GHz', 'S-band: 2 - 4 GHz', 'C-band: 4 - 8 GHz', 'X-band: 8 - 12 GHz', 'Ku-band: 12 - 18 GHz', 'K-band: 18 - 27 GHz', 'Ka-band: 27 - 40 GHz', 'V-band: 40 - 75 GHz', 'W-band: 75 - 110 GHz'}, 'Value', 'C-band: 4 - 8 GHz', ...
    'ValueChangedFcn', @bandChangedCallback);

% Fréquence
freqHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', freqHBox, 'Text', 'Frequency (GHz):');
freqEdit = uieditfield('numeric', 'Parent', freqHBox, 'Value', 5.3); % Fixé à 5.3 GHz pour CMOD5

% Angle d'incidence
angleHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', angleHBox, 'Text', 'Incidence Angle (deg):');
angleEdit = uieditfield('numeric', 'Parent', angleHBox, 'Value', 30.0);

% Polarisation (dropdown HH, VV, HV)
polHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', polHBox, 'Text', 'Polarization:');
polDrop = uidropdown('Parent', polHBox, 'Items', {'HH', 'VV', 'HV'}, 'Value', 'VV');

% Vitesse du vent
windSpeedHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', windSpeedHBox, 'Text', 'Wind Speed u10 (m/s):');
windSpeedEdit = uieditfield('numeric', 'Parent', windSpeedHBox, 'Value', 10, 'Limits', [0 30]);

% Angle relatif au vent
windHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', windHBox, 'Text', 'Angle Relative to Wind direction (deg):');
windEdit = uieditfield('numeric', 'Parent', windHBox, 'Value', 0, 'Limits', [0 360]);

% Sélection du modèle avec note de validation
modelHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', modelHBox, 'Text', 'Model:');
modelDrop = uidropdown('Parent', modelHBox, 'Items', {'NRL', 'TSC', 'GIT', 'HYBRID', 'SITTROP', 'RRE', 'Quilfen', 'CMOD2-I3', 'CMOD5N', 'Isoguchi', 'XMOD1R', 'XMOD2N', 'Meissner', 'Wentz84', 'Wentz99', 'Masuko_X', 'Masuko_Ka', 'NSCAT1', 'TSM','SSA1', 'GO1sh', 'SPM1'}, 'Value', 'CMOD5N');

% Fetch (désactivé par défaut) activé seulement lors de la sélection des modèles statistiques 
fetchHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', fetchHBox, 'Text', 'Fetch (m):');
fetchEdit_NRCS = uieditfield('numeric', 'Parent', fetchHBox, 'Value', Inf, 'Limits', [0 Inf], 'Enable', 'off'); 
fetchEdit_NRCS.Tooltip = ' Fetch - Active only for TSM and GO1sh';

% K0/Kc (désactivé par défaut) activé seulement lors de la sélection des modèles TSM et GO1sh
k0kcHBox = uix.HBox('Parent', paramsPanel);
uilabel('Parent', k0kcHBox, 'Text', 'K₀/Kc :');
k0kcEdit = uieditfield('numeric', 'Parent', k0kcHBox, 'Value', 3, 'Limits', [1 Inf], 'Enable', 'off');

modelNote = uilabel('Parent', paramsPanel, 'Text', '', 'FontSize', 11,'FontWeight', 'bold', 'HorizontalAlignment', 'left');

% Ajout du callback pour mettre à jour la note lors du changement de modèle
modelDrop.ValueChangedFcn = @modelChangedCallback;


set(paramsPanel, 'Heights', [20 30 30 30 30 30 30 30 30 30 30]); % 10 hauteurs pour 10 enfants

% Section droite : VBox pour affichages + résultats
rightLayout = uix.VBox('Parent', contentLayout, 'Padding', 5, 'Spacing', 5);

% Section d'affichage : Grid pour NRCS 
displayGrid = uix.Grid('Parent', rightLayout, 'Spacing', 5);
nrcsAx = uiaxes('Parent', displayGrid);
title(nrcsAx, 'NRCS Curve');
set(displayGrid, 'Widths', -1, 'Heights', -1); 

% Section résultats
resultsPanel = uix.Panel('Parent', rightLayout, 'Title', 'Results');
resultsLayout = uix.VBox('Parent', resultsPanel, 'Padding', 5);
resultsLabel = uilabel('Parent', resultsLayout, 'Text', '', 'HorizontalAlignment', 'center');
warningLabel = uicontrol('Parent', resultsLayout, 'Style', 'text', 'String', '', 'FontSize', 8, 'HorizontalAlignment', 'center', 'ForegroundColor', [1 0.5 0]);

set(resultsLayout, 'Heights', [30 20]); % Résultat principal + label warning pour état de mer 

set(rightLayout, 'Heights', [-1 120]); % Ajusté pour inclure la section résultats

% Stockage des handles dans une structure
app.handles.bandDrop = bandDrop; 
app.handles.freqEdit = freqEdit;
app.handles.angleEdit = angleEdit;
app.handles.polDrop = polDrop;
app.handles.windSpeedEdit = windSpeedEdit;
app.handles.windEdit = windEdit;
app.handles.fetchEdit_NRCS = fetchEdit_NRCS;
app.handles.k0kcEdit = k0kcEdit;
app.handles.modelDrop = modelDrop;
app.handles.nrcsAx = nrcsAx;
app.handles.resultsLabel = resultsLabel;
app.handles.warningLabel = warningLabel;
app.handles.modelNote = modelNote;

updateModelList(bandDrop); % Filtre les modèles pour C-band au démarrage

% Section boutons en bas
btnPanel = uix.HBox('Parent', mainLayoutNRCS, 'Padding', 5, 'Spacing', 10);
calcBtn = uibutton('Parent', btnPanel, 'Text', 'Calculate', 'ButtonPushedFcn', @(btn,event) calculerCallback());
overlayBtn = uibutton('Parent', btnPanel, 'Text', 'Overlay', 'ButtonPushedFcn', @(btn,event) superposerCallback());
clearBtn = uibutton('Parent', btnPanel, 'Text', 'Clear', 'ButtonPushedFcn', @(btn,event) clearCurvesCallback());
exportBtn = uibutton('Parent', btnPanel, 'Text', 'Export', 'ButtonPushedFcn', @(btn,event) exporterCallback());

%Ajustement des hauteurs pour l'onglet NRCS
set(mainLayoutNRCS, 'Heights', [50 -1 50]); % Bande fixe à 50, contenu flexible, boutons fixes à 50

app.handles.clearBtn = clearBtn;
%% Layout principal pour l'onglet Sea Surface Generation - Deuxième onglet 
mainLayoutSeaSurface = uix.VBox('Parent', tabSeaSurface, 'Padding', 0, 'Spacing', 0);

% Bande orange en haut
headerPanel = uix.Panel('Parent', mainLayoutSeaSurface, 'BackgroundColor', [1 0.5 0]); % Couleur orange vif
headerLayout = uix.HBox('Parent', headerPanel, 'Padding', 5, 'Spacing', 10);

% Ajout du titre
titleLabel = uilabel('Parent', headerLayout, 'Text', 'Sea Surface Radar Simulator', ...
    'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

% Ajout des deux logos avec ajustement dynamique
try
    % Chargement des deux logos
    logoICAM = imread('logo_icam.png'); 
    logoIETR = imread('logo_ietr.png');

    % Panel horizontal pour aligner les deux logos proprement
    logoPanel = uipanel('Parent', headerLayout, 'BorderType', 'none');
    logoBox   = uix.HBox('Parent', logoPanel, 'Spacing', 5);  % 20 px d'écart entre les logos
    
    % Logo ICAM
    ax1 = uiaxes('Parent', logoBox, 'Visible', 'off');
    image(ax1, logoICAM);
    axis(ax1, 'image'); axis off;

    % Logo IETR
    ax2 = uiaxes('Parent', logoBox, 'Visible', 'off');
    image(ax2, logoIETR);
    axis(ax2, 'image'); axis off;


    % Forcer les deux logos à prendre la même hauteur
    logoGrid.Widths = [-1 -1];  % largeur automatique proportionnelle

    % Callback pour ajuster la taille du logo
    headerPanel.SizeChangedFcn = @resizeLogos;
  

   
catch
    uilabel('Parent', headerLayout, ...
            'Text', 'ICAM | IETR', ...
            'FontSize', 14, ...
            'FontWeight', 'bold');
end

% Définition des largeurs après avoir ajouté les enfants
set(headerLayout, 'Widths', [-1 200]); % Titre flexible, logos fixes 

% Contenu principal : HBox pour paramètres (gauche) + affichage (droite)
contentLayout = uix.HBox('Parent', mainLayoutSeaSurface, 'Padding', 5, 'Spacing', 5);

% Section gauche : VBox pour paramètres
paramsSeaSurfacePanel = uix.VBox('Parent', contentLayout, 'Padding', 5, 'Spacing', 10);
uilabel('Parent', paramsSeaSurfacePanel, 'Text', 'Sea Surface Parameters', 'FontWeight', 'bold');

% Vitesse du vent
windSpeedHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', windSpeedHBox, 'Text', 'Wind Speed u10 (m/s):');
windSpeedEditSea = uieditfield('numeric', 'Parent', windSpeedHBox, 'Value', 3, 'Limits', [0 25]);

% Direction du vent
windDirHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', windDirHBox, 'Text', 'Wind Direction (deg):');
windDirEdit = uieditfield('numeric', 'Parent', windDirHBox, 'Value', 0, 'Limits', [0 360]);

% Fetch
fetchHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', fetchHBox, 'Text', 'Fetch (m):');
fetchEdit_Sea = uieditfield('numeric', 'Parent', fetchHBox, 'Value', 500e3, 'Limits', [0 Inf]);

% Longueur X
lxHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', lxHBox, 'Text', 'Length X (m):');
lxEdit = uieditfield('numeric', 'Parent', lxHBox, 'Value', 40, 'Limits', [0 Inf]);

% Longueur Y
lyHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', lyHBox, 'Text', 'Length Y (m):');
lyEdit = uieditfield('numeric', 'Parent', lyHBox, 'Value', 30, 'Limits', [0 Inf]);

% Fréquence radar
freqHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', freqHBox, 'Text', 'Radar Frequency (GHz):');
app.handles.wavelengthLabel = uilabel('Parent', freqHBox,'Text', '1.30 GHz → λ = 23.07 cm', 'FontSize', 11); % Label pour la longueur d'onde 
freqEditSea = uieditfield('numeric', 'Parent', freqHBox, 'Value', 1.3, 'Limits', [0 100], ...
    'ValueChangedFcn', @updateWavelengthLabel);
% Initialisation au démarrage
updateWavelengthLabel(freqEditSea, []);

% Nombre d'échantillons par longueur d'onde
nlbHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', nlbHBox, 'Text', 'Samples per Wavelength (-):');
nlbEdit = uieditfield('numeric', 'Parent', nlbHBox, 'Value', 8, 'Limits', [1 Inf]);

% Option pour le choix de la précision
precisionHBox = uix.HBox('Parent', paramsSeaSurfacePanel);
uilabel('Parent', precisionHBox, 'Text', 'Precision:');
precisionCheck = uicheckbox('Parent', precisionHBox,'Text', 'Use single precision' ,'Value', 0,'Tooltip', 'Check = single (4 bytes), Unchecked = double (8 bytes, default)');
set(precisionHBox, 'Widths', [100 -1]);

% Boutons pour générer et effacer la surface
generateBtn = uibutton('Parent', paramsSeaSurfacePanel, 'Text', 'Generate Surface', 'ButtonPushedFcn', @(btn, event) generateSeaSurfaceCallback());
clearSurfaceBtn = uibutton('Parent', paramsSeaSurfacePanel, 'Text', 'Clear Surface','ButtonPushedFcn', @(btn, event) clearSeaSurfaceCallback());
exportSurfaceBtn = uibutton('Parent', paramsSeaSurfacePanel,'Text', 'Export Surface', 'ButtonPushedFcn', @(btn,event) exportSeaSurfaceCallback());

% Ajustement des hauteurs pour la section paramètres (10 enfants )
set(paramsSeaSurfacePanel, 'Heights', [20 30 30 30 30 30 30 30 30 30 30 30]);

% Section droite : VBox pour l'affichage + statistiques
displaySeaSurfacePanel = uix.VBox('Parent', contentLayout, 'Padding', 5, 'Spacing', 10);

% Graphe 3D
displayGrid = uix.Grid('Parent', displaySeaSurfacePanel, 'Spacing', 5);
app.handles.seaSurfaceAx = uiaxes('Parent', displayGrid);
title(app.handles.seaSurfaceAx, 'Sea Surface Plot');
set(displayGrid, 'Widths', -1, 'Heights', -1);

% Panneau pour les statistiques
statsPanel = uix.Panel('Parent', displaySeaSurfacePanel, 'Title', 'Surface Statistics', 'FontWeight', 'bold');

% Grille 2x2 pour disposer les stats en 2 lignes de 2 colonnes
statsGrid = uix.Grid('Parent', statsPanel, 'Spacing', 15);

% Ligne 1 : Zmin et Zmax
app.handles.zMinLabel  = uilabel('Parent', statsGrid, 'Text', 'Zmin:  — m',     'FontWeight', 'bold');
app.handles.zMaxLabel  = uilabel('Parent', statsGrid, 'Text', 'Zmax:  — m',     'FontWeight', 'bold');

% Ligne 2 : Mean et σ (std)
app.handles.zMeanLabel = uilabel('Parent', statsGrid, 'Text', 'Zmean:  — m',     'FontWeight', 'bold');
app.handles.zStdLabel  = uilabel('Parent', statsGrid, 'Text', 'Zstd: — m',   'FontWeight', 'bold');

% Configuration de la grille : 2 lignes, 2 colonnes
set(statsGrid, 'Widths', [-1 -1], 'Heights', [30 30]);

% Ajustement des hauteurs
set(displaySeaSurfacePanel, 'Heights', [-1 120]);  % Graphe flexible, stats fixes

% Ajustement des largeurs pour le contenu (paramètres et affichage)
set(contentLayout, 'Widths', [-1 -1]); 

% Ajustement des hauteurs globales pour l'onglet Sea Surface
set(mainLayoutSeaSurface, 'Heights', [50 -1]); % Bande fixe à 50, contenu flexible

% Stockage des handles pour l'onglet Sea Surface
app.handles.windSpeedEditSea = windSpeedEditSea;
app.handles.windDirEdit = windDirEdit;
app.handles.fetchEdit_Sea = fetchEdit_Sea;
app.handles.lxEdit = lxEdit;
app.handles.lyEdit = lyEdit;
app.handles.freqEditSea = freqEditSea;
app.handles.nlbEdit = nlbEdit;
app.handles.precisionCheck = precisionCheck;
%app.handles.seaSurfaceAx = seaSurfaceAx;
app.handles.clearSurfaceBtn = clearSurfaceBtn;

%% Fonction pour ajuster la taille du logo 
function resizeLogos(src, ~)
    % src est le headerPanel qui a déclenché le SizeChangedFcn
    headerPanel = src;  % On récupère le panel qui appelle la fonction
    
    if ~isvalid(headerPanel)
        return;
    end
    
    panelH = headerPanel.Position(4);  % Hauteur du bandeau orange
    targetH = max(40, panelH * 0.75);   % 75% de la hauteur, minimum 40 px
    
    % Chercher le logoBox (uix.HBox) à l'intérieur du headerPanel
    logoBox = findobj(headerPanel, 'Type', 'uix.HBox', '-depth', 3);
    if isempty(logoBox)
        return;
    end
    
    % Chercher les deux uiaxes contenant les images
    axesList = findobj(logoBox, 'Type', 'matlab.ui.control.UIAxes');
    if numel(axesList) < 2
        return;
    end
    
    ax1 = axesList(1);  % Premier logo (ICAM)
    ax2 = axesList(2);  % Deuxième logo (IETR)
    
    % Récupérer les images affichées dans chaque axe
    img1 = findobj(ax1, 'Type', 'image');
    img2 = findobj(ax2, 'Type', 'image');
    
    if isempty(img1) || isempty(img2)
        return;
    end
    
    data1 = get(img1, 'CData');
    data2 = get(img2, 'CData');
    
    % Dimensions originales des images
    [h1, w1, ~] = size(data1);
    [h2, w2, ~] = size(data2);
    
    if h1 == 0 || h2 == 0
        return;
    end
    
    % Calcul des nouvelles dimensions
    scale1 = targetH / h1;
    newW1 = w1 * scale1;
    newH = targetH;
    
    scale2 = targetH / h2;
    newW2 = w2 * scale2;
    
    % Appliquer aux axes
    ax1.Position(3:4) = [newW1, newH];
    ax2.Position(3:4) = [newW2, newH];
    
    % Centrage vertical des deux axes dans le bandeau
    verticalOffset = (panelH - newH) / 2;
    ax1.Position(2) = verticalOffset;
    ax2.Position(2) = verticalOffset;
end

%% Fonction pour mettre à jour l'affichage de la longueur d'onde dans l'onglet SeaSurface
function updateWavelengthLabel(src, ~)
    global app;

    freq_GHz = src.Value;  % valeur actuelle du champ fréquence

    if freq_GHz <= 0
        wavelength_cm = Inf;
        text = 'Inf cm';
    else
        c = 3e8;  % vitesse de la lumière en m/s
        wavelength_m = c / (freq_GHz * 1e9);     % λ en mètres
        wavelength_cm = wavelength_m * 100;       % λ en cm
        text = sprintf('→ λ = %.2f cm', wavelength_cm);
    end

    % Mise à jour du label
    app.handles.wavelengthLabel.Text = sprintf('%.2f GHz %s', freq_GHz, text);
end
    %% Fonction pour mettre à jour la note des plages valides pour les modèles
function mettreAJourNoteModele(src, noteLabel)
    switch src.Value
        case 'NRL'
            noteLabel.Text = 'Valid ranges: Incidence Angle 30°-89.9°, Frequency 0.5-35 GHz, Wind Speed u10 0-13.2 m/s';
        case 'TSC'
            noteLabel.Text = 'Valid ranges: Incidence Angle 0°-89.9°, Frequency 0.5-35 GHz, Wind Speed u10 0-11.4 m/s';
        case 'SITTROP'
            noteLabel.Text = 'Valid ranges: Incidence Angle 80°-89.8°, Frequency 9.375 GHz, Wind Speed u10 0-14.9 m/s';
        case 'GIT'
            noteLabel.Text = 'Valid ranges: Incidence Angle 80°-89.9°, Frequency 1-100 GHz, Wind Speed u10 3.2-13.2 m/s';
        case 'RRE'
            noteLabel.Text = 'Valid ranges: Incidence Angle 80°-89.9°, Frequency 9-10 GHz, Wind Speed u10 3.2-13.2 m/s';
        case 'HYBRID'
            noteLabel.Text = 'Valid ranges: Incidence Angle 60°-90°, Frequency 0.1-100 GHz, Wind Speed u10 0-11.4 m/s';
        case 'Quilfen'
            noteLabel.Text = 'Valid ranges: Incidence Angle 18°-60°, Frequency 5.3 GHz, Wind Speed u10 < 20 m/s, Wind Angle 0°-360°';
        case 'CMOD2-I3'
            noteLabel.Text = 'Valid ranges: Incidence Angle 18°-57°, Frequency 5.3 GHz, Wind Speed u10 0-25 m/s, Wind Angle 0°-360°';
        case 'CMOD5N'
            noteLabel.Text = 'Valid ranges: Incidence Angle 18°-57°, Frequency 5.3 GHz, Wind Speed u10 0-25 m/s, Wind Angle 0°-360°';
        case 'Isoguchi'
            noteLabel.Text = 'Valid ranges: Incidence Angle 17°-43°, Frequency 1.3 GHz, Wind Speed u10 0-20 m/s, Wind Angle 0°-360°';
        case 'XMOD1R'
            noteLabel.Text = 'Valid ranges: Incidence Angle 20°-60°, Frequency 10 GHz, Wind Speed u10 0-20 m/s, Wind Angle 0°-360°';
        case 'XMOD2N'
            noteLabel.Text = 'Valid ranges: Incidence Angle 18°-46°, Frequency 10 GHz, Wind Speed u10 2-25 m/s, Wind Angle 0°-360°';
        case 'Meissner'
            noteLabel.Text = 'Valid ranges: Incidence Angle 24.36°-49.29°, Frequency 1.26 GHz, Wind Speed u10 0.2-22 m/s, Wind Angle 0°-360°';
        case 'Wentz84'
            noteLabel.Text = 'Valid ranges: Incidence Angle 0°-60°, Frequency 14.6 GHz, Wind Speed u10 0-20,m/s, Wind Angle 0°-360°';
        case 'Wentz99'
            noteLabel.Text = 'Valid ranges: Incidence Angle 15°-65°, Frequency 14.6 GHz, Wind Speed u10 0-20 m/s, Wind Angle 0°-360°';
        case 'Masuko_X'
            noteLabel.Text = 'Valid ranges: Incidence Angle 30°-60°, Frequency 10 GHz, Wind Speed u19 3.2-17.2 m/s, Wind Angle 0°-360°';
        case 'Masuko_Ka'
            noteLabel.Text = 'Valid ranges: Incidence Angle 30°-60°, Frequency 34.43 GHz, Wind Speed u19 3.2-17.2 m/s, Wind Angle 0°-360°';
        case 'NSCAT1'
            noteLabel.Text = 'Valid ranges: Incidence Angle 15°-60°, Frequency 13.6 GHz , Wind Speed u10 1-30 m/s, Wind Angle 0°-360°';  
        case 'TSM'
            noteLabel.Text = 'Valid ranges: Incidence Angle 0°–80°, Frequency 0.1–100 GHz, Wind Speed u10 0–25 m/s, Wind Angle 0°-360°';
        case 'SSA1'
            noteLabel.Text = 'Valid ranges: Incidence Angle 0°–80°, Frequency 0.1–100 GHz, Wind Speed u10 3–25 m/s, Wind Angle 0°-360°';
        case 'GO1sh'
            noteLabel.Text = 'Valid ranges: Incidence Angle 0°–50°, Frequency 0.1–100 GHz, Wind Speed u10 0–25 m/s, Wind Angle 0°–360°';
        case 'SPM1'
            noteLabel.Text = 'Valid ranges: Incidence Angle 0°–80°, Frequency 0.1–100 GHz, Wind Speed u10 0–25 m/s, Wind Angle 0°–360°';
        otherwise
            noteLabel.Text = 'Valid ranges: Not specified for this model.';
    end
end

%% Fonction mise à jour bande -> fréquence  
function bandChangedCallback(src, ~)
    
    updateFrequencyFromBand(src);   % Met à jour freqEdit automatiquement
    updateModelList(src);           % Filtre les modèles
end

% Met à jour la fréquence centrale automatiquement
function updateFrequencyFromBand(drop)
    global app;
    bandText = drop.Value;
    tokens = regexp(bandText, '(\d+\.?\d*)\s*-\s*(\d+\.?\d*)', 'tokens');
    if ~isempty(tokens)
        bounds = str2double(tokens{1});
        centerFreq = mean(bounds);
        app.handles.freqEdit.Value = centerFreq;
    end
end
%% Callback principal quand on change de modèle
function modelChangedCallback(src, ~)
    
    updateAdvancedParamsVisibility(src);     % Gère l'activation/désactivation du Fetch et de K0/Kc
    updateModelNote(src);           % Met à jour la note de validation
end

% Mise à jour du champ Fetch et K0/Kc selon le modèle
function updateAdvancedParamsVisibility(drop)
    global app; %#ok<*GVMIS>
    currentModel = drop.Value;

    % Gestion du fetch
    if ismember(currentModel, {'TSM', 'SSA1', 'GO1sh', 'SPM1'})
        app.handles.fetchEdit_NRCS.Enable = 'on';

        if isinf(app.handles.fetchEdit_NRCS.Value)
            app.handles.fetchEdit_NRCS.Value = Inf;  
        end
    else
        app.handles.fetchEdit_NRCS.Enable = 'off';
        app.handles.fetchEdit_NRCS.Value = Inf; 

    end

    % Gestion du champ K0/Kc
    if ismember(currentModel, {'TSM', 'GO1sh'})
        app.handles.k0kcEdit.Enable = 'on';

        % Valeur par défaut selon le modèle 
        currentVal = app.handles.k0kcEdit.Value;

        if ~isfinite(currentVal) || currentVal <= 0 || currentVal == 3 || currentVal == 4
            if strcmp(currentModel, 'TSM')
                app.handles.k0kcEdit.Value = 4;
            elseif strcmp(currentModel, 'GO1sh')
                app.handles.k0kcEdit.Value = 3;
            end
        end   
    else
        app.handles.k0kcEdit.Enable = 'off';
    end


end

% Mise à jour de la note de validation 
function updateModelNote(drop)
    global app;
    mettreAJourNoteModele(drop, app.handles.modelNote);
end
%% Fonction pour mettre à jour la liste des modèles en fonction de la bande de fréquence
function updateModelList(src)
    global app;
    % Liste complète des modèles
    allModels = {'NRL', 'TSC', 'GIT', 'HYBRID', 'SITTROP', 'RRE', 'Quilfen', 'CMOD2-I3', 'CMOD5N', 'Isoguchi', 'XMOD1R', 'XMOD2N', 'Meissner', 'Wentz84', 'Wentz99', 'Masuko_X', 'Masuko_Ka', 'NSCAT1', 'TSM', 'SSA1', 'GO1sh', 'SPM1'};
    
    % Plages de fréquences des modèles (en GHz)
    modelFreqRanges = struct(...
    'NRL', [0.5 35], ...
    'TSC', [0.5 35], ...
    'GIT', [1 100], ...
    'HYBRID', [0.1 100], ...
    'SITTROP', [9.375 9.375], ...
    'RRE', [9 10], ...
    'Quilfen', [5.3 5.3], ...
    'CMOD2_I3', [5.3 5.3], ...
    'CMOD5N', [5.3 5.3], ...
    'Isoguchi', [1.3 1.3], ...
    'XMOD1R', [10 10], ...
    'XMOD2N', [10 10], ...
    'Meissner', [1.26 1.26], ...
    'Wentz84', [14.6 14.6], ...
    'Wentz99', [14.6 14.6], ...
    'Masuko_X', [10 10], ...
    'Masuko_Ka', [34.43 34.43], ...
    'NSCAT1', [13.6 13.6], ... 
    'TSM', [0.1 100], ...
    'GO1sh', [0.1 100],...
    'SSA1', [0.1 100], ...
    'SPM1', [0.1 100] ...
);
    
    % Plages de fréquences des bandes
    bandRanges = struct(...
        'UHF', [0.3 1], ...
        'L_band', [1 2], ...
        'S_band', [2 4], ...
        'C_band', [4 8], ...
        'X_band', [8 12], ...
        'Ku_band', [12 18], ...
        'K_band', [18 27], ...
        'Ka_band', [27 40], ...
        'V_band', [40 75], ...
        'W_band', [75 110] ...
    );
    
    % Extraire la clé de la bande sélectionnée
    bandKey = strsplit(src.Value, ':');
    bandKey = strrep(bandKey{1}, '-', '_');
    
    % Obtenir la plage de fréquences de la bande
    bandMinFreq = bandRanges.(bandKey)(1);
    bandMaxFreq = bandRanges.(bandKey)(2);
    
    % Filtrer les modèles compatibles
    validModels = {};
    for i = 1:length(allModels)
        model = allModels{i};
        modelKey = strrep(model, '-', '_'); % Remplacer les tirets pour CMOD2-I3
        modelMinFreq = modelFreqRanges.(modelKey)(1);
        modelMaxFreq = modelFreqRanges.(modelKey)(2);
        % Vérifier si la plage du modèle intersecte la plage de la bande
        if modelMinFreq <= bandMaxFreq && modelMaxFreq >= bandMinFreq
            validModels{end+1} = model;
        end
    end
    
    % Mettre à jour la liste des modèles
    app.handles.modelDrop.Items = validModels;
    
    % Si le modèle actuel n'est pas dans la liste, sélectionner le premier modèle valide
    if ~ismember(app.handles.modelDrop.Value, validModels)
        if ~isempty(validModels)
            app.handles.modelDrop.Value = validModels{1};
        else
            app.handles.modelDrop.Value = '';
            showWarning('No models available for the selected frequency band.');
        end
    end
    
    % Mettre à jour la note du modèle
    mettreAJourNoteModele(app.handles.modelDrop, app.handles.modelNote);
end

%% Fonction utilitaire pour afficher les warnings dans la console et en popup
function showWarning(message)
    global app;
    disp(message); % Console
    uialert(app.handles.fig, message, 'Warning', 'Icon', 'warning', 'Modal', true); % Popup à l'écran
end

%% Fonction Calculer pour calcul de NRCS selon les modèles 
function calculerCallback()
    global app;
    % Vérification si app.handles.nrcsAx est un objet axes valide
    if ~isvalid(app.handles.nrcsAx) || ~isa(app.handles.nrcsAx, 'matlab.ui.control.UIAxes')
        disp('Error: app.handles.nrcsAx is not a valid axes object');
        uialert(app.handles.fig, 'Error: Invalid axes object for plotting. Please restart the application.', 'Error', 'Icon', 'error', 'Modal', true);
        return;
    end

    % Réinitialisation de l'axe et du label de résultat
    cla(app.handles.nrcsAx, 'reset'); % Vide l'axe et réinitialise ses propriétés
    app.handles.resultsLabel.Text = ''; % Réinitialise le label de résultat
    app.handles.warningLabel.String = ''; % Réinitialise le label de warning


    title(app.handles.nrcsAx, 'NRCS Curves'); 
    xlabel(app.handles.nrcsAx, 'Incidence Angle (deg)');
    ylabel(app.handles.nrcsAx, 'NRCS (dB)');
    grid(app.handles.nrcsAx, 'on');
    hold(app.handles.nrcsAx, 'on');
    
    % Récupère les paramètres via les handles
    band = app.handles.bandDrop.Value; % Bande de fréquence sélectionnée
    freq = app.handles.freqEdit.Value; % Fréquence en GHz
    incidenceAngle = app.handles.angleEdit.Value; % Angle d'incidence
    pol = app.handles.polDrop.Value; % 'HH', 'VV', ou 'HV'
    windSpeed = app.handles.windSpeedEdit.Value; % Vitesse du vent en m/s
    windAngle = app.handles.windEdit.Value; % Angle relatif au vent
    model = app.handles.modelDrop.Value; % Modèle choisi
    fetch = app.handles.fetchEdit_NRCS.Value; % Fetch du premier onglet pour les modèles statistiques  
    k0SurKc = app.handles.k0kcEdit.Value; % K0/Kc pour les modèles statistiques


    % Validation de l'angle relatif au vent
    if windAngle < 0 || windAngle > 360
        showWarning('Warning: Angle Relative to Wind must be between 0° and 360°. Using 0° instead.');
        windAngle = 0;
    end

    % Validation de la fréquence par rapport à la bande de fréquence sélectionnée
    % Définition des plages de fréquences avec des noms de champs valides
    bandRanges = struct(...
        'UHF', [0.3 1], ...
        'L_band', [1 2], ...
        'S_band', [2 4], ...
        'C_band', [4 8], ...
        'X_band', [8 12], ...
        'Ku_band', [12 18], ...
        'K_band', [18 27], ...
        'Ka_band', [27 40], ...
        'V_band', [40 75], ...
        'W_band', [75 110] ...
    );
    % Extraction de la partie du nom de la bande (ex. 'UHF' à partir de 'UHF: 0.3 - 1 GHz')
    bandKey = strsplit(band, ':');
    bandKey = strrep(bandKey{1}, '-', '_'); % Remplacement des tirets par des underscores si nécessaire
    if isfield(bandRanges, bandKey)
        minFreq = bandRanges.(bandKey)(1);
        maxFreq = bandRanges.(bandKey)(2);
        if freq < minFreq || freq > maxFreq
            showWarning(['Warning: Frequency (', num2str(freq), ' GHz) is outside the ', band, ' range (', num2str(minFreq), '-', num2str(maxFreq), ' GHz). Adjusting to the nearest limit.']);
            freq = max(minFreq, min(maxFreq, freq)); % Ajustement de la fréquence aux limites
            app.handles.freqEdit.Value = freq; % Mise à jour du champ d'édition immédiatement
        end
    else
        showWarning(['Warning: Unknown frequency band: ', band]);
    end

    % Conversion de la vitesse du vent en état de mer pour les modèles semi-empiriques
    seaState = 0;
    semiEmpiricalModels = {'NRL', 'TSC', 'SITTROP', 'GIT', 'RRE', 'HYBRID'};
    if ismember(model, semiEmpiricalModels)
        seaState = round((windSpeed / 3.16)^1.25);
        if seaState < 0 || seaState > 7
            showWarning(sprintf('Warning: Converted Sea State (%d) is out of range (0-7). Using closest valid value.', seaState));
            seaState = max(0, min(7, seaState));
        end
        if abs(windSpeed - 3.16 * (seaState^(1/0.8))) > 0.5
            app.handles.warningLabel.String = sprintf('Warning: Approximated Sea State (%d) from Wind Speed (%.1f m/s) may not be exact.', seaState, windSpeed);
        else
            app.handles.warningLabel.String = '';
        end

        % Validation des plages de vitesse du vent pour chaque modèle semi-empirique
        switch model
            case 'NRL'
                if windSpeed > 13.2
                    showWarning(sprintf('Warning: Wind Speed (%.2f m/s) exceeds 13.2 m/s (Sea State > 6) for NRL model.', windSpeed));
                    windSpeed = 13.2;
                    seaState = 6;
                end
            case 'TSC'
                if windSpeed > 11.4
                    showWarning(sprintf('Warning: Wind Speed (%.2f m/s) exceeds 11.4 m/s (Sea State > 5) for TSC model.', windSpeed));
                    windSpeed = 11.4;
                    seaState = 5;
                end
            case 'SITTROP'
                if windSpeed > 14.9
                    showWarning(sprintf('Warning: Wind Speed (%.2f m/s) exceeds 14.9 m/s (Sea State > 7) for SITTROP model.', windSpeed));
                    windSpeed = 14.9;
                    seaState = 7;
                end
            case 'GIT'
                if windSpeed < 3.2 || windSpeed > 13.2
                    showWarning(sprintf('Warning: Wind Speed (%.2f m/s) out of range 3.2-13.2 m/s (Sea State 1-6) for GIT model.', windSpeed));
                    windSpeed = max(3.2, min(13.2, windSpeed));
                    seaState = round((windSpeed / 3.16)^1.25);
                    seaState = max(1, min(6, seaState));
                end
            case 'RRE'
                if windSpeed < 3.2 || windSpeed > 13.2
                    showWarning(sprintf('Warning: Wind Speed (%.2f m/s) out of range 3.2-13.2 m/s (Sea State 1-6) for RRE model.', windSpeed));
                    windSpeed = max(3.2, min(13.2, windSpeed));
                    seaState = round((windSpeed / 3.16)^1.25);
                    seaState = max(1, min(6, seaState));
                end
            case 'HYBRID'
                if windSpeed > 11.4
                    showWarning(sprintf('Warning: Wind Speed (%.2f m/s) exceeds 11.4 m/s (Sea State > 5) for HYBRID model.', windSpeed));
                    windSpeed = 11.4;
                    seaState = 5;
                end
        end
    end

    % Conversion des unités
    c = 3e8; % Vitesse de la lumière (m/s)
    lambda_m = c / (freq * 1e9); % Longueur d'onde en mètres

    % Conversion de la polarisation
    if strcmp(pol, 'HH')
        polModel = 'H';
    elseif strcmp(pol, 'VV')
        polModel = 'V';
    elseif strcmp(pol, 'HV')
        polModel = {'VH', 'HV'}; 
    else
        error('Invalid polarisation. Choose beetwen ''HH'', ''VV'', or ''HV''.');
    end

    % Définition de theta (angle d'incidence) avec plage valide pour chaque modèle 
    switch model
        case 'NRL'
            theta = 30:0.5:89.9; % Vecteur d'angles d'incidence pour NRL
            if incidenceAngle < 30 || incidenceAngle > 89.9
                showWarning('Warning: Incidence Angle must be between 30° and 89.9° for NRL model.');
                return;
            end
        case 'TSC'
            theta = 0:0.5:89.9; % Vecteur d'angles d'incidence pour TSC
            if incidenceAngle < 0 || incidenceAngle > 89.9
                showWarning('Warning: Incidence Angle must be between 0° and 89.9° for TSC model.');
                return;
            end
        case 'SITTROP'
            theta = 80:0.1:89.8; % Vecteur d'angles d'incidence pour SITTROP
            if incidenceAngle < 80 || incidenceAngle > 89.8
                showWarning('Warning: Incidence Angle must be between 80° and 89.8° for SITTROP model.');
                return;
            end
        case 'GIT'
            theta = 80:0.1:89.9; % Vecteur d'angles d'incidence pour GIT 
            if incidenceAngle < 80 || incidenceAngle > 89.9
                showWarning('Warning: Incidence Angle must be between 80° and 89.9° for GIT model.');
                return;
            end
        case 'RRE'
            theta = 80:0.1:89.9; % Vecteur d'angles d'incidence pour RRE
            if incidenceAngle < 80 || incidenceAngle > 89.9
                showWarning('Warning: Incidence Angle must be between 80° and 89.9° for RRE model.');
                return;
            end
        case 'HYBRID'
            theta = 60:0.5:90.0; % Vecteur d'angles d'incidence pour HYBRID
            if incidenceAngle < 60 || incidenceAngle > 90
                showWarning('Warning: Incidence Angle must be between 60° and 90° for HYBRID model.');
                return;
            end
        case 'Quilfen'
            theta = 18:0.5:60; % Vecteur d'angles d'incidence pour Quilfen
            if incidenceAngle < 18 || incidenceAngle > 60
                showWarning('Warning: Incidence Angle must be between 18° and 60° for Quilfen model.');
                return;
            end
        case 'CMOD2-I3'
            theta = 18:0.5:57; % Vecteur d'angles d'incidence pour CMOD2-I3
            if incidenceAngle < 18 || incidenceAngle > 57
                showWarning('Warning: Incidence Angle must be between 18° and 57° for CMOD2-I3 model.');
                return;
            end
        case 'CMOD5N'
            theta = 18:0.5:57; % Vecteur d'angles d'incidence pour CMOD5
            if incidenceAngle < 18 || incidenceAngle > 57
                showWarning('Warning: Incidence Angle must be between 18° and 57° for CMOD5 model.');
                return;
            end
        case 'Isoguchi'
            theta = 17:0.5:43; % Vecteur d'angles d'incidence pour Isoguchi
            if incidenceAngle < 17 || incidenceAngle > 43
                showWarning('Warning: Incidence Angle must be between 17° and 43° for Isoguchi model.');
                return;
            end
        case 'XMOD1R'
            theta = 20:0.5:60; % Vecteur d'angles d'incidence pour XMOD1R
            if incidenceAngle < 20 || incidenceAngle > 60
                showWarning('Warning: Incidence Angle must be between 20° and 60° for XMOD1R model.');
                return;
            end
        case 'XMOD2N'
            theta = 18:0.5:46; % Vecteur d'angles d'incidence pour XMOD2N
            if incidenceAngle < 18 || incidenceAngle > 46
                showWarning('Warning: Incidence Angle must be between 18° and 46° for XMOD2N model.');
                return;
            end
        case 'Meissner'
            theta = 24.36:0.1:49.29; % Vecteur d'angles d'incidence pour Meissner
            if incidenceAngle < 24.36 || incidenceAngle > 49.29
                showWarning('Warning: Incidence Angle must be between 24.36° and 49.29° for Meissner model.');
                return;
            end
        case 'Wentz84'
            theta = 0:0.5:60; % Vecteur d'angles d'incidence pour Wentz84
            if incidenceAngle < 0 || incidenceAngle > 60
                showWarning('Warning: Incidence Angle must be between 0° and 60° for Wentz84 model.');
                return;
            end
        case 'Wentz99'
            theta = 15:0.5:65; % Vecteur d'angles d'incidence pour Wentz99
            if incidenceAngle < 15 || (strcmp(pol, 'HH') && incidenceAngle > 55) || (~strcmp(pol, 'HH') && incidenceAngle > 65)
                showWarning('Warning: Incidence Angle must be between 15° and 65° (55° for HH pol.) for Wentz99 model.');
                return;
            end
        case 'Masuko_X'
            theta = 30:0.5:60; % Vecteur d'angles d'incidence pour Masuko_X
            if incidenceAngle < 30 || incidenceAngle > 60
                showWarning('Warning: Incidence Angle must be between 30° and 60° for Masuko_X model.');
                return;
            end
        case 'Masuko_Ka'
            theta = 30:0.5:60; % Vecteur d'angles d'incidence pour Masuko_Ka
            if incidenceAngle < 30 || incidenceAngle > 60
                showWarning('Warning: Incidence Angle must be between 30° and 60° for Masuko_Ka model.');
                return;
            end
        case 'NSCAT1'
            theta = 15:0.5:60; % Vecteur d'angles d'incidence pour NSCAT1
            if incidenceAngle < 15 || incidenceAngle > 60
                showWarning('Warning: Incidence Angle must be between 15° and 60° for NSCAT1 model.');
                return;
            end
        case 'TSM'
            theta = 0.1:0.5:80; % Vecteur d'angles d'incidence pour TSM
            if incidenceAngle > 80
                showWarning('Warning: Incidence Angle should be > 80° for TSM model');
                return;
            end
        case 'SSA1'
            theta = 0.1:0.5:70; % Vecteur d'angles d'incidence pour SSA1  
            if incidenceAngle > 70
                showWarning('Warning: Incidence Angle should be > 70° for SSA1 model');
                return;
            end
        case 'GO1sh'
            theta = 0.1:0.5:40; % Vecteur d'angles d'incidence pour GO1sh
            if incidenceAngle > 50
                showWarning('Warning: Incidence Angle should be > 50° for GO1sh model');
                return;
            end
        case 'SPM1'
            theta = 2:0.5:80; % Vecteur d'angles d'incidence pour SPM1
            if incidenceAngle > 50
                showWarning('Warning: Incidence Angle should be > 80° for SPM1 model');
                return;
            end
        otherwise
            theta = 0:0.5:90.0; % Valeur par défaut
    end

    % Conversion de l'angle d'incidence en angle de rasance pour les modèles qui l'utilisent 
    grazingTheta = 90 - theta; 

    % Calcul de la NRCS selon le modèle choisi avec validations spécifiques
    switch model
        case 'NRL'
            % Validation des plages pour NRL
            if freq < 0.5 || freq > 35.0
                showWarning('Warning: Frequency must be between 0.5 GHz and 35.0 GHz for NRL model.');
                return;
            end
            nrcs = f_Nrcs_3dMonoGrazing_NRL_2012(grazingTheta, lambda_m, seaState, windAngle, polModel, c);

        case 'TSC'
            % Validation des plages pour TSC
            if freq < 0.5 || freq > 35.0
                showWarning('Warning: Frequency must be between 0.5 GHz and 35.0 GHz for TSC model.');
                return;
            end
            nrcs = f_Nrcs_3dMonoGrazing_TSC(grazingTheta, lambda_m, seaState, windAngle, polModel);

        case 'SITTROP'
            % Validation des plages pour SITTROP
            if abs(freq - 9.375) > 0.001
                showWarning('Warning: Frequency must be fixed at 9.375 GHz (λ = 3.2 cm) for SITTROP model.');
                nrcs = zeros(size(theta));
                return;
            end
            if windAngle ~= 0 && windAngle ~= 90
                showWarning('Warning: Angle Relative to Wind must be 0° or 90° for SITTROP model.');
                return;
            end
            nrcs = f_Nrcs_3dMonoGrazing_SIT(grazingTheta, lambda_m, seaState, windAngle, polModel);

        case 'GIT'
            % Validation des plages pour GIT
            if freq < 1 || freq > 100
                showWarning('Warning: Frequency must be between 1 GHz and 100 GHz for GIT model.');
                nrcs = NaN(size(theta)); %#ok<*NASGU>
                return;
            end
            nrcs = f_Nrcs_3dMonoGrazing_GIT(grazingTheta, lambda_m, seaState, windAngle, polModel);

        case 'RRE'
            % Validation des plages pour RRE
            c_ms = 3e8; 
            f_GHz = c_ms / lambda_m * 1e-9;
            if f_GHz < 9 || f_GHz > 10
                showWarning('Warning: RRE model valid only for X band (9-10 GHz).');
                return;
            end
            nrcs = f_Nrcs_3dMonoGrazing_RRE(grazingTheta, lambda_m, seaState, windAngle, polModel);

        case 'HYBRID'
            % Validation des plages pour HYBRID
            if freq < 0.1 || freq > 100
                showWarning('Warning: Frequency must be between 0.1 GHz and 100 GHz for HYBRID model.');
                return;
            end 
            nrcs = f_Nrcs_3dMonoGrazing_HYB2(grazingTheta, lambda_m, seaState, windAngle, polModel);

        case 'Quilfen'
            % Validation des plages pour Quilfen
            if abs(freq - 5.3) > 0.001
                showWarning('Warning: Frequency must be fixed at 5.3 GHz for Quilfen model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed >= 20
                showWarning('Warning: Wind Speed must be less than 20 m/s for Quilfen model.');
                return;
            end
            if windAngle < 0 || windAngle > 360
                showWarning('Warning: Wind Angle must be between 0° and 360° for Quilfen model.');
                windAngle = 0;
            end
            [nrcsVV, ~] = f_Nrcs_3dMono_EmpExpSea_Cband_Quilfen(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                showWarning('Warning: Quilfen model supports only VV polarization. Using VV NRCS.');
                nrcs =zeros(size(theta));
                return;
            else
                showWarning('Warning: Only VV polarization is supported for Quilfen.');
                nrcs =zeros(size(theta));
                return;
            end

        case 'CMOD2-I3'
            % Validation des plages pour CMOD2-I3
            if abs(freq - 5.3) > 0.001
                showWarning('Warning: Frequency must be fixed at 5.3 GHz for CMOD2-I3 model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed < 0 || windSpeed > 25
                showWarning('Warning: Wind Speed must be between 0 and 25 m/s for CMOD2-I3 model.');
                return;
            end
            if windAngle < 0 || windAngle > 360
                showWarning('Warning: Wind Angle must be between 0° and 360° for CMOD2-I3 model.');
                windAngle = 0;
            end
            [nrcsVV, ~] = f_Nrcs_3dMono_EmpExpSea_Cband_Cmod2I3(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                showWarning('Warning: CMOD2-I3 model supports only VV polarization. Using VV NRCS.');
                nrcs =zeros(size(theta));
                return;
            else
                showWarning('Warning: Only VV polarization is supported for CMOD2-I3.');
                nrcs =zeros(size(theta));
                return;
            end

        case 'CMOD5N'
            % Validation des plages pour CMOD5
            if abs(freq - 5.3) > 0.001
                showWarning('Warning: Frequency must be fixed at 5.3 GHz for CMOD5N model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed < 0 || windSpeed > 25
                showWarning('Warning: Wind Speed must be between 0 and 25 m/s for CMOD5N model.');
                return;
            end
            if windAngle < 0 || windAngle > 360
                showWarning('Warning: Wind Angle must be between 0° and 360° for CMOD5N model.');
                windAngle = 0;
            end
            [nrcsVV, ~] = f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5N(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                showWarning('Warning: CMOD5N model supports only VV polarization. Using VV NRCS.');
                nrcs = zeros(size(theta)); 
                return;
            else
                showWarning('Warning: Only VV polarization is supported for CMOD5N.');
                nrcs =zeros(size(theta)); 
                return;
            end

        case 'Isoguchi'
            % Validation des plages pour Isoguchi
            if abs(freq - 1.3) > 0.1
                showWarning('Warning: Frequency must be approximately 1.3 GHz for Isoguchi model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed >= 20
                showWarning('Warning: Wind Speed must be less than 20 m/s for Isoguchi model.');
                return;
            end
            if windAngle < 0 || windAngle > 360
                showWarning('Warning: Wind Angle must be between 0° and 360° for Isoguchi model.');
                windAngle = 0;
            end
            [nrcsVV, nrcsHH] = f_Nrcs_3dMono_EmpExpSea_Lband_Isoguchi(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                nrcs = nrcsHH;
            else
                showWarning('Warning: Only VV and HH polarizations are supported for Isoguchi.');
                nrcs = zeros(size(theta));
                return;
            end

        case 'XMOD1R'
            % Validation des plages pour XMOD1R
            if abs(freq - 10.0) > 0.1
                showWarning('Warning: Frequency must be approximately 10 GHz for XMOD1R model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed < 0 || windSpeed > 20
                showWarning('Warning: Wind Speed must be between 0 and 20 m/s for XMOD1R model (possibly 14 m/s).');
                return;
            end
            if windAngle < 0 || windAngle > 360
                showWarning('Warning: Wind Angle must be between 0° and 360° for XMOD1R model.');
                windAngle = 0;
            end
            [nrcsVV, ~] = f_Nrcs_3dMono_EmpExpSea_Xband_Xmod1R(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                showWarning('Warning: XMOD1R model supports only VV polarization. Using VV NRCS.');
                nrcs = zeros(size(theta));
                return;
            else
                showWarning('Warning: Only VV polarization is supported for XMOD1R.');
                nrcs = zeros(size(theta)); 
                return;
            end

        case 'XMOD2N'
            % Validation des plages pour XMOD2N
            if abs(freq - 10.0) > 0.1
                showWarning('Warning: Frequency must be approximately 10 GHz for XMOD2N model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed < 2 || windSpeed > 25
                showWarning('Warning: Wind Speed must be between 2 and 25 m/s for XMOD2N model.');
                return;
            end
            if windAngle < 0 || windAngle > 360
                showWarning('Warning: Wind Angle must be between 0° and 360° for XMOD2N model.');
                windAngle = 0;
            end
            [nrcsVV, ~] = f_Nrcs_3dMono_EmpExpSea_Xband_Xmod2N(theta, windSpeed, windAngle);
           if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                showWarning('Warning: XMOD2N model supports only VV polarization. Using VV NRCS.');
                nrcs = zeros(size(theta));
                return;
            else
                showWarning('Warning: Only VV polarization is supported for XMOD2N.');
                nrcs = zeros(size(theta));
                return;
            end
        
        case 'Meissner'
            % Validation des plages pour Meissner
            if abs(freq - 1.26) > 0.01
                showWarning('Warning: Frequency must be approximately 1.26 GHz for Meissner model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed < 0.2 || windSpeed > 22
                showWarning('Warning: Wind Speed must be between 0.2 and 22 m/s for Meissner model.');
                return;
            end
            if windAngle < 0 || windAngle > 360
                showWarning('Warning: Wind Angle must be between 0° and 360° for Meissner model.');
                windAngle = 0;
            end
            [nrcsVV, nrcsHH, nrcsVH] = f_Nrcs_3dMono_EmpExpSea_Lband_Meissner(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                nrcs = nrcsHH;
            elseif strcmp(pol, 'HV')
                nrcs = nrcsVH;

            end

        case 'Wentz84'
            % Validation des plages pour Wentz84
            if abs(freq - 14.6) > 0.1
                showWarning('Warning: Frequency must be approximately 14.6 GHz for Wentz84 model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed < 0 || windSpeed > 20
                showWarning('Warning: Wind Speed must be between 0 and 20 m/s for Wentz84 model.');
                return;
            end
            [nrcsVV, nrcsHH] = f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz84(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                nrcs = nrcsHH;
            else
                showWarning('Warning: Only VV and HH polarizations are supported for Wentz84.');
                nrcs = zeros(size(theta));
                return;
            end

        case 'Wentz99'
            % Validation des plages pour Wentz99
            if abs(freq - 14.6) > 0.1
                showWarning('Warning: Frequency must be approximately 14.6 GHz for Wentz99 model.');
                nrcs = NaN(size(theta));
                return;
            end
            if windSpeed < 0 || windSpeed > 20
                showWarning('Warning: Wind Speed must be between 0 and 20 m/s for Wentz99 model.');
                return;
            end
            [nrcsVV, nrcsHH] = f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz99(theta, windSpeed, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                nrcs = nrcsHH;
            else
                showWarning('Warning: Only VV and HH polarizations are supported for Wentz99.');
                nrcs = zeros(size(theta));
                return;
            end

        case 'Masuko_X'
            % Validation des plages pour Masuko_X
            if abs(freq - 10.0) > 0.1
                showWarning('Warning: Frequency must be approximately 10 GHz for Masuko_X model.');
                nrcs = NaN(size(theta));
                return;
            end

            z_m = 19.5; % Hauteur cible pour u19 (19.5 m selon Masuko)
            fetch_m = 1e6; % Valeur par défaut de fetch
            [u19_ms] = f_Sea_WindSpeedHeightConversion_v2(windSpeed, z_m, fetch_m);

            if u19_ms < 3.2 || u19_ms > 17.2
                showWarning('Warning: Wind Speed u19 must be between 3.2 and 17.2 m/s for Masuko_X model.');
                return;
            end
            [nrcsVV, nrcsHH] = f_Nrcs_3dMono_EmpExpSea_Xband_Masuko(theta, u19_ms, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                nrcs = nrcsHH;
            else
                showWarning('Warning: Only VV and HH polarizations are supported for Masuko_X.');
                nrcs = zeros(size(theta));
                return;
            end

        case 'Masuko_Ka'
            % Validation des plages pour Masuko_Ka
            if abs(freq - 34.43) > 0.1
                showWarning('Warning: Frequency must be approximately 34.43 GHz for Masuko_Ka model.');
                nrcs = NaN(size(theta));
                return;
            end

            z_m = 19.5; % Hauteur cible pour u19 (19.5 m selon Masuko)
            fetch_m = 1e6; % Valeur par défaut de fetch
            [u19_ms] = f_Sea_WindSpeedHeightConversion_v2(windSpeed, z_m, fetch_m);

            if u19_ms < 3.2 || u19_ms > 17.2
                showWarning('Warning: Wind Speed u19 must be between 3.2 and 17.2 m/s for Masuko_Ka model.');
                return;
            end
            [nrcsVV, nrcsHH] = f_Nrcs_3dMono_EmpExpSea_Kaband_Masuko(theta, u19_ms, windAngle);
            if strcmp(pol, 'VV')
                nrcs = nrcsVV;
            elseif strcmp(pol, 'HH')
                nrcs = nrcsHH;
            else
                showWarning('Warning: Only VV and HH polarizations are supported for Masuko_Ka.');
                nrcs = zeros(size(theta));
                return;
            end

        case 'NSCAT1'
            % Validation des plages pour NSCAT1
            if abs(freq - 13.6) > 0.5
                showWarning('Warning: NSCAT1 model is designed for ~13.6 GHz (Ku-band).');
                return;
            end
            if windSpeed < 1 || windSpeed > 30
                showWarning('Warning: Wind Speed must be between 1 and 30 m/s for NSCAT1 model.');
                return;
            end

            % NSCAT1: windAngle = D - A, on fixe A = 0 → D = windAngle
            phi_wind = windAngle;
            phi_radar = 0;
            p_flag = strcmp(pol, 'VV') * 2 + strcmp(pol, 'HH') * 1;
            if p_flag == 0
                showWarning('Warning: NSCAT1 supports only VV and HH. Using VV.');
                p_flag = 2;
                return;
            end

            % Construction de inarg avec theta déjà défini
            inarg = [windSpeed * ones(length(theta), 1),phi_wind * ones(length(theta), 1),phi_radar * ones(length(theta), 1), ...
                     theta', p_flag * ones(length(theta), 1)];

            sigma0_lin = NSCAT1(inarg);
            nrcs = 10 * log10(max(eps, sigma0_lin));

        case 'TSM'
            % Paramètres physiques
            sst_C = 15; 
            sss_ppt = 35;
            k0SurKc_TSM = app.handles.k0kcEdit.Value; 

            % Calcul préliminaire
            F_Hz = freq * 1e9; 

            % Permittivité
            [er_complex, ~, K_EM , Kc_TSM] = f_Sea_ErOmg(F_Hz, sst_C, sss_ppt, windSpeed, fetch, k0SurKc_TSM);
            er2 = er_complex;

            try
                    %theta, windAngle, er2, windSpeed, fetch, K_EM, Kc_TSM 
                    
                    [nrcs_VV_lin, nrcs_HH_lin, nrcs_VH_lin, ~, ~, AddTerm_VV, AddTerm_HH] = ...
                        f_Nrcs_3dMono_StatisticSea_TSM_Elfo_Gauss_Fetch_v2(theta, windAngle, er2, windSpeed, fetch, K_EM, Kc_TSM);

            switch pol
                case 'VV'
                     nrcs = nrcs_VV_lin + AddTerm_VV;
                case 'HH'
                     nrcs = nrcs_HH_lin + AddTerm_HH;
                case 'HV'
                     nrcs = nrcs_VH_lin;
            end

            catch ME
                     showWarning(['TSM error: ' ME.message]);
                     nrcs = zeros(size(theta));
                     return;
             end

        case 'SSA1'
            % Paramètres physiques
            sst_C     = 15;     
            sss_ppt   = 35;     
            F_Hz      = freq * 1e9;
            %k0        = 2*pi*F_Hz / 3e8;  
      
            % Permittivité 
            [er2, ~,k0, ~] = f_Sea_ErOmg(F_Hz, sst_C, sss_ppt, windSpeed, fetch, 6); 
            
            f0_Hz = 3e9;        % Fréquence de référence (3 GHz)
            u0_10 = 5;          % Vent de référence
            r_max_ref = 10;     % r_max à 3 GHz et 5 m/s
            r_max = r_max_ref * sqrt(f0_Hz / F_Hz) * (u0_10 / windSpeed);
            r_max = max(r_max, 5);   
            r_max = min(r_max, 50); 
            n_r = []; 

            % Chargement du fichier de corrélation 
            % Calcul de omg 
            g = 9.81; x0 = 2.2e4;
            k0_surf = g / windSpeed^2;
            xmaj = k0_surf * fetch;
            omgc = 0.84 * tanh((xmaj/x0)^0.4)^(-0.75);
            cp = sqrt(g * (1 + (k0_surf*omgc^2)^2 / (370)^2) / (k0_surf*omgc^2));
            omg_calc = windSpeed / cp;
            omg_calc = round(omg_calc*100)/100;

            omg_str = sprintf('%.2f', omg_calc);     % ex: '0.84'
            omg_str = strrep(omg_str, '.', '-');     %  '0-84'

            u10_str = sprintf('%.0f', round(windSpeed));  % ex: '10'

            % Nom du fichier avec format exact 
            Nom = sprintf('DataSeaSurf2d/SeaSurf_2dCorrFcts_omg%s_ud%sms.mat', omg_str, u10_str);
            if exist(Nom, 'file') == 2
                try
                    
                    [nrcs_VV_lin, nrcs_HH_lin, ~, ~, ~, ~] = ...
                    f_Nrcs_3dMono_StatisticSea_SSA1_Fetch_v1(theta, windAngle, er2, windSpeed, fetch,k0, r_max, 0, n_r);  % aff = 0 
                    
                    switch pol
                        case 'VV'
                            nrcs = nrcs_VV_lin;
                        case 'HH'
                            nrcs = nrcs_HH_lin;
                        case 'HV'
                            showWarning('Warning: Only VV and HH polarization is supported for SSA1.');
                            nrcs =zeros(size(theta)); 
                            return;
                    end

                catch ME
                    showWarning(['SSA1 computation failed: ' ME.message]);
                    nrcs = zeros(size(theta));
                    app.handles.warningLabel.String = 'SSA1: computation error';
                    return;
                end
            else
                % Message si fichier manquant
                msg = sprintf('SSA1: Correlation file not found\nExpected: %s\nGenerate it with Cal_FonctionCorrelation2D_Mer_v3b.m', Nom);
                showWarning(msg);
                nrcs = zeros(size(theta));
                app.handles.warningLabel.String = 'SSA1: Missing correlation file';
                return;
            end

        case 'GO1sh'
            % Paramètres physiques (
            sst_C     = 15;
            sss_ppt   = 35;
            F_Hz      = freq * 1e9;
            k0SurKc = app.handles.k0kcEdit.Value;

            % Permittivité
            [er2, ~, ~ , Kc] = f_Sea_ErOmg(F_Hz, sst_C, sss_ppt, windSpeed, fetch, k0SurKc);

            %theta, windAngle, er2, windSpeed, fetch, Kc
            try
                [Nrcs_GO1un_VV, Nrcs_GO1un_HH, ~, sig_sx, sig_sy] = ...
                  f_Nrcs_3dMono_StatisticSea_GO1sh_Elfo_Gauss_Fetch_v1(theta, windAngle, er2, windSpeed, fetch, Kc);

                    switch pol
                         case 'VV'
                             nrcs = Nrcs_GO1un_VV;
                         case 'HH'
                             nrcs = Nrcs_GO1un_HH;
                         case 'HV'
                            showWarning('Warning: Only VV and HH polarization is supported for GO1sh.');
                            nrcs =zeros(size(theta)); 
                            return
                    end

            catch ME
                    showWarning(['GO1sh computation failed: ' ME.message]);
                    nrcs = zeros(size(theta));
                    app.handles.warningLabel.String = 'GO1sh: computation error';
                    return;
            end
        
         case 'SPM1'
            % Paramètres physiques (
            sst_C     = 15;
            sss_ppt   = 35;
            F_Hz      = freq * 1e9;
            k0SurKc = app.handles.k0kcEdit.Value;

            % Permittivité
            [er2, ~, K0 , ~] = f_Sea_ErOmg(F_Hz, sst_C, sss_ppt, windSpeed, fetch, k0SurKc);
 

            %theta, windAngle, er2, windSpeed, fetch, Kc
            try
                [Nrcs_Mdl_VV, Nrcs_Mdl_HH] = ...
                  f_Nrcs_3dMono_StatisticSea_SPM1_Elfo_Gauss_Fetch_v1 (theta, windAngle, er2, windSpeed, fetch, K0);

                    switch pol
                         case 'VV'
                             nrcs = Nrcs_Mdl_VV;
                         case 'HH'
                             nrcs = Nrcs_Mdl_HH;
                         case 'HV'
                            showWarning('Warning: Only VV and HH polarization is supported for SPM1.');
                            nrcs =zeros(size(theta)); 
                            return
                    end

            catch ME
                    showWarning(['SPM1 computation failed: ' ME.message]);
                    nrcs = zeros(size(theta));
                    app.handles.warningLabel.String = 'SPM1: computation error';
                    return;
            end
        
        otherwise
            showWarning('Warning: Unrecognised model, NRCS set to 0.');
            nrcs =zeros(size(theta));
            return;
    end

    % Conversion de NRCS linéaire en dB pour les modèles linéaires
    if ismember(model, {'Quilfen', 'CMOD2-I3', 'CMOD5N', 'Isoguchi', 'XMOD1R', 'XMOD2N', 'Meissner', 'Wentz84', 'Wentz99', 'Masuko_X', 'Masuko_Ka', 'TSM', 'SSA1', 'GO1sh', 'SPM1'})
        nrcs_dB = 10 * log10(max(eps, nrcs)); % Conversion pour les modèles linéaires
    else
        nrcs_dB = nrcs; 
    end


    % Stockage des paramètres pour la superposition
    params = struct('Freq', freq, 'Angle', incidenceAngle, 'Pol', pol, 'WindSpeed', windSpeed, 'WindAngle', windAngle, 'Model', model);
    % Ajout spécifique pour GO1sh
    if strcmp(model, 'GO1sh')
        if exist('sig_sx', 'var') && exist('sig_sy', 'var')
            params.sig_sx = sig_sx;
            params.sig_sy = sig_sy;
        else
            params.sig_sx = NaN;
            params.sig_sy = NaN;
        end
    end

    % Limite à 4 courbes
    MAX_CURVES = 4;
    if length(app.handles.curves) >= MAX_CURVES
     app.handles.curves = app.handles.curves(2:end); % Supprime la plus ancienne
    end
    app.handles.curves(end+1) = struct('theta', theta, 'nrcs_dB', nrcs_dB, 'params', params, 'color', []);

    % Affichage de la courbe NRCS 
    plot(app.handles.nrcsAx, theta, nrcs_dB, 'LineWidth', 2);
    grid(app.handles.nrcsAx, 'on');
    %legend(app.handles.nrcsAx, sprintf('%s, %s, %.2f GHz, %.1f m/s', model, pol, freq, windSpeed), 'Location', 'best');

    % Résultats : affiche uniquement la NRCS en dB pour l'angle entré
    idx = find(abs(theta - incidenceAngle) == min(abs(theta - incidenceAngle)), 1); % Trouve l'index le plus proche
    nrcsValue_dB = nrcs_dB(idx);
    app.handles.resultsLabel.Text = sprintf('NRCS: %.2f dB (for %.1f° incidence angle)', nrcsValue_dB, incidenceAngle);
end


%% Fonction Exporter : dernière courbe ou toutes les courbes

function exporterCallback()
    global app;

    if isempty(app.handles.curves)
        uialert(app.handles.fig, 'No curve data available. Please run a calculation first.', 'Error', 'Icon', 'error');
        return;
    end

    choices = {'Export last curve only', 'Export all curves (multi-column CSV)'};
    [sel, ok] = listdlg('PromptString', 'Export Option:', ...
        'SelectionMode', 'single', 'ListString', choices, 'ListSize', [350 100]);

    if ~ok || isempty(sel), return; end

    if sel == 1
        exportLastCurve();
    else
        exportAllCurves();
    end
end



% Fonction pour exporter la dernière courbe 
function exportLastCurve()
    global app;
    curve = app.handles.curves(end);
    p = curve.params;

    % Récupération des paramètres actuels
    freq = app.handles.freqEdit.Value;
    pol = app.handles.polDrop.Value;
    windSpeed = app.handles.windSpeedEdit.Value;
    windAngle = app.handles.windEdit.Value;
    model = app.handles.modelDrop.Value;

    freqStr = strrep(sprintf('%.2f', p.Freq), '.', 'p');
    windSpeedStr = strrep(sprintf('%.1f', p.WindSpeed), '.', 'p');
    windAngleStr = strrep(sprintf('%.0f', p.WindAngle), '.', 'p');
    filename = sprintf('f_%sGHz_%s_%sms_%sdeg_%s.csv', freqStr, pol, windSpeedStr, windAngleStr, model);

    data = table(curve.theta', curve.nrcs_dB', 'VariableNames', {'Theta_deg', 'NRCS_dB'});
    [file, path] = uiputfile('*.csv', 'Export Last Curve', filename);
    if isequal(file, 0), return; end

    writetable(data, fullfile(path, file), 'Delimiter', ';', 'Encoding', 'UTF-8');
    uialert(app.handles.fig, sprintf('Exported: %s', file), 'Success', 'Icon', 'success');
end


% Fonction pour exporter toutes les courbes 

function exportAllCurves()
    global app;
    curves = app.handles.curves;

    if isempty(curves)
        uialert(app.handles.fig, 'No curves to export.', 'Info');
        return;
    end

    % Trouver la longueur maximale 
    maxLen = max(cellfun(@length, {curves.theta}));

    % Créer une table vide
    data = zeros(maxLen, 2 * length(curves));  % [Theta1 NRCS1 | Theta2 NRCS2 | ...]
    colNames = {};

    for i = 1:length(curves)
        theta_i = curves(i).theta;
        nrcs_i  = curves(i).nrcs_dB;
        p       = curves(i).params;

        % Étendre à maxLen avec NaN 
        theta_full = NaN(maxLen, 1);
        nrcs_full  = NaN(maxLen, 1);

        len = length(theta_i);
        theta_full(1:len) = theta_i;
        nrcs_full(1:len)  = nrcs_i;

        % Colonnes
        colTheta = sprintf('Theta_%d', i);
        colNRCS  = sprintf('NRCS_%s_%s_%.1fGHz_%.1fms', p.Model, p.Pol, p.Freq, p.WindSpeed);

        data(:, 2*(i-1) + 1) = theta_full;
        data(:, 2*(i-1) + 2) = nrcs_full;

        colNames{end+1} = colTheta;
        colNames{end+1} = colNRCS;
    end

    dataTable = array2table(data, 'VariableNames', colNames);

    % Nom de fichier
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    defaultName = sprintf('NRCS_Multi_%s.csv', timestamp);

    [file, path] = uiputfile('*.csv', 'Export All Curves (Original Ranges)', defaultName);
    if isequal(file, 0), return; end

    writetable(dataTable, fullfile(path, file), 'Delimiter', ';', 'Encoding', 'UTF-8');
    uialert(app.handles.fig, sprintf('%d curves exported :\n%s', length(curves), file), ...
        'Success', 'Icon', 'success');
end

%% Fonction pour superposer les courbes
function superposerCallback(~,~)
    global app;

    if isempty(app.handles.curves)
        uialert(app.handles.fig, 'No curves to overlay. Please run a calculation first.', ...
                'Info', 'Icon', 'info');
        return;
    end

    cla(app.handles.nrcsAx, 'reset');
    hold(app.handles.nrcsAx, 'on');
    grid(app.handles.nrcsAx, 'on');

    app.handles.nrcsAx.ActivePositionProperty = 'position';

    n = length(app.handles.curves);
    colors = lines(min(n,7));
    lineStyles = {'-', '--', '-.', ':'};  % 1ère (ancienne) = trait plein, dernière = deux-points

    % On prépare les handles
    plotHandles = gobjects(1,n);   
    legendTexts = cell(1,n);
    
    % Variables pour calculer les limites Y globales
    all_nrcs_dB = [];
    hasGO1sh = false;
    max_from_GO = -Inf;
    use_HH_limit = false;

    for i = 1:n
        curve = app.handles.curves(i);
        p     = curve.params;

        styleIdx = min(i, numel(lineStyles));
        lnStyle  = lineStyles{styleIdx};

        % Tracé + récupération du handle
        plotHandles(i) = plot(app.handles.nrcsAx, curve.theta, curve.nrcs_dB,'LineStyle', lnStyle,'LineWidth', 1.8,'Color',colors(i,:));

        legendTexts{i} = sprintf('%s',p.Model);

        % Collecte des données pour limites
        all_nrcs_dB = [all_nrcs_dB; curve.nrcs_dB(:)];

        % Détection GO1sh
        if strcmp(p.Model, 'GO1sh')
            hasGO1sh = true;

            % Calcul ymax dynamique
            if isfield(p, 'sig_sx') && isfield(p, 'sig_sy') && ~any(isnan([p.sig_sx, p.sig_sy]))
                current_max = 10*log10(1/(2*p.sig_sx*p.sig_sy));
                max_from_GO = max(max_from_GO, current_max);
            end

            % Pour ymin : si HH présent, on prend -80 dB
            if strcmp(p.Pol, 'HH')
                use_HH_limit = true;
            end
        end

        % DataTips complets
        dt = plotHandles(i).DataTipTemplate;
        dt.DataTipRows(1).Label = 'Incidence Angle (degrees)';
        dt.DataTipRows(2).Label = 'NRCS (dB)';
        dt.DataTipRows(end+1) = dataTipTextRow('Model',        repmat({p.Model},       size(curve.theta)));
        dt.DataTipRows(end+1) = dataTipTextRow('Pol',          repmat({p.Pol},         size(curve.theta)));
        dt.DataTipRows(end+1) = dataTipTextRow('Freq (GHz)',   repmat({p.Freq},        size(curve.theta)));
        dt.DataTipRows(end+1) = dataTipTextRow('Wind (m/s)',   repmat({p.WindSpeed},   size(curve.theta)));
        dt.DataTipRows(end+1) = dataTipTextRow('Wind Angle (degrees)', repmat({p.WindAngle}, size(curve.theta)));
    end

    % Calcul des limites Y
    if hasGO1sh && isfinite(max_from_GO)
        ymax = ceil((max_from_GO )/10)*10;
    else
        ymax = ceil(max(all_nrcs_dB)/10)*10 ;
    end

    % Limite basse : -80 si GO1sh en HH, sinon -50
    if hasGO1sh && use_HH_limit
        ymin = -80;
    else
        ymin = -50;
    end

    ylim(app.handles.nrcsAx, [ymin ymax]);

    % Titre et axes
    title(app.handles.nrcsAx, sprintf('NRCS Overlay (%d curve(s)) – Click legend to delete', n));
    xlabel(app.handles.nrcsAx, 'Incidence Angle (deg)');
    ylabel(app.handles.nrcsAx, 'NRCS (dB)');

   % Légende cliquable
    lgd = legend(plotHandles, legendTexts,'FontSize',11);

    % Active le clic sur la légende pour supprimer
    lgd.ItemHitFcn = @deleteCurveFromLegend;

    % Interactions
    app.handles.nrcsAx.Interactions = [dataTipInteraction zoomInteraction panInteraction];

    hold(app.handles.nrcsAx, 'off');
end

%% Fonction appelée quand on clique sur une entrée de la légende
function deleteCurveFromLegend(~, event)
    global app;

    % Récupère l'index de la courbe cliquée
    clickedObj = event.Peer;                    % la ligne cliquée
    idx = find(app.handles.nrcsAx.Children == clickedObj, 1);

    if ~isempty(idx)
        % Supprime la courbe du graphique
        delete(clickedObj);

        % Supprime aussi de la structure app.handles.curves
        app.handles.curves(idx) = [];

        % Met à jour le titre
        remaining = length(app.handles.curves);
        if remaining > 0
            title(app.handles.nrcsAx, ...
                sprintf('NRCS Overlay – %d curve(s) – Click legend to delete', remaining), ...
                'FontSize',16, 'FontWeight','bold');
        else
            title(app.handles.nrcsAx, 'NRCS Curve');
        end

        % Met à jour la légende automatiquement
        legend(app.handles.nrcsAx, 'show');
    end
end

%% Fonction pour supprimer les courbes 

function clearCurvesCallback()
    global app;
    app.handles.curves = struct('theta', {}, 'nrcs_dB', {}, 'params', {}, 'color', {});
    cla(app.handles.nrcsAx, 'reset');
    title(app.handles.nrcsAx, 'NRCS Curve');
    xlabel(app.handles.nrcsAx, 'Incidence Angle (deg)');
    ylabel(app.handles.nrcsAx, 'NRCS (dB)');
    grid(app.handles.nrcsAx, 'on');
    app.handles.resultsLabel.Text = '';
end

%% Fonction pour générer la surface de mer
function generateSeaSurfaceCallback()
    global app;

    % Fenetre de chargement
    d = uiprogressdlg(app.handles.fig, 'Title', 'Génération', ...
        'Message', 'Generation in progress...', 'Indeterminate', 'on');
    drawnow;

    % Récupération des paramètres
    u10_ms   = app.handles.windSpeedEditSea.Value;
    phWind_d = app.handles.windDirEdit.Value;
    fetch_m  = app.handles.fetchEdit_Sea.Value;
    lx_sea_m = app.handles.lxEdit.Value;
    ly_sea_m = app.handles.lyEdit.Value;
    freq_GHz = app.handles.freqEditSea.Value;
    nlb0     = app.handles.nlbEdit.Value;

    % Validation
    if u10_ms < 1 || u10_ms > 10
        showWarning('Warning: Wind Speed u10 must be between 1 and 10 m/s.');
        return;
    end
    if phWind_d < 0 || phWind_d > 360
        showWarning('Warning: Wind Direction must be between 0° and 360°.');
        phWind_d = 0;
    end
    if fetch_m <= 0
        showWarning('Warning: Fetch must be positive.');
        fetch_m = 500e3;
    end
    if lx_sea_m <= 0 || ly_sea_m <= 0
        showWarning('Warning: Length X and Y must be positive.');
        lx_sea_m = 40; ly_sea_m = 30;
    end
    if freq_GHz <= 0
        showWarning('Warning: Radar Frequency must be positive.');
        freq_GHz = 1.3;
    end
    if nlb0 < 1
        showWarning('Warning: Samples per Wavelength must be at least 1.');
        nlb0 = 8;
    end

    % Calculs préliminaires
    c_ms  = 3e8;
    lb0_m = c_ms / (freq_GHz * 1e9);
    dxy_m = lb0_m / nlb0;

    % Vérification longueur minimale
    g    = 9.81; x0 = 2.2e4;
    k0   = g / u10_ms^2;
    xmaj = k0 * fetch_m;
    omgc = 0.84 * tanh((xmaj/x0)^0.4)^(-0.75);
    kp   = k0 * omgc^2;
    kmin = 0.3 * kp;
    lmin = 2*pi / kmin;
    if lx_sea_m < lmin || ly_sea_m < lmin
        showWarning('Warning: Surface not long enough to include all gravity waves.');
    end

    % Nombre d'échantillons
    n_x    = round(lx_sea_m / dxy_m / 2) * 2;
    n_y    = round(ly_sea_m / dxy_m / 2) * 2;
    npoints = n_x * n_y;

    % Détection RAM disponible
    if ispc
        [~, sys]       = memory;
        totalRAM_bytes = sys.PhysicalMemory.Total;
    elseif ismac
        [~, cmdout]    = system('sysctl hw.memsize');
        totalRAM_bytes = sscanf(cmdout, 'hw.memsize: %d');
    else
        [status, cmdout] = system('cat /proc/meminfo | grep MemTotal');
        if status == 0
            totalRAM_bytes = sscanf(cmdout, 'MemTotal: %d kB') * 1024;
        else
            totalRAM_bytes = 16e9;
        end
    end

    RAM_total_GB  = totalRAM_bytes / 1e9;
    RAM_max_10pct = 0.10 * totalRAM_bytes;

    % Précision
    if app.handles.precisionCheck.Value
        bytes_per_point = 4; prec = 1;
        precisionStr = 'SINGLE';
    else
        bytes_per_point = 8; prec = 2;
        precisionStr = 'DOUBLE';
    end

    % Vérification mémoire
    mem_needed_bytes = npoints * bytes_per_point + 2*max(n_x,n_y)*8;
    mem_needed_GB    = mem_needed_bytes / 1e9;
    if mem_needed_bytes > RAM_max_10pct
        msg = sprintf(['Insufficient memory!\n\n' ...
                       'Requested surface: %d × %d\n' ...
                       'Precision: %s → %.2f GB required\n' ...
                       'Total RAM: %.1f GB\n' ...
                       'Limit: 10%% = %.1f GB\n\n'], ...
                       n_x, n_y, precisionStr, mem_needed_GB, ...
                       RAM_total_GB, RAM_max_10pct/1e9);
        uialert(app.handles.fig, msg, 'Memory limit exceeded', 'Icon', 'warning');
    end

    prec = app.handles.precisionCheck.Value;

    % ── FLAG DÉBUT ──
    try
        fid = fopen('CALC_START.flag', 'w');
        fprintf(fid, 'start');
        fclose(fid);
    catch
    end

    % ── RAM avant calcul (whos) ──
    vars_avant  = whos;
    ram_avant_W = sum([vars_avant.bytes]) / 1024^2;

    % Génération surface
    tic;
    [HH_XY, X, Y] = f_GeneSurfMer3D_Fetch_Elfo_v3( ...
        u10_ms, phWind_d, lx_sea_m, ly_sea_m, n_x, n_y, 1, prec, fetch_m);
    temps_gen = toc;

    % ── RAM après calcul (whos) ──
    vars_apres   = whos;
    ram_apres_W  = sum([vars_apres.bytes]) / 1024^2;
    delta_RAM_MB = ram_apres_W - ram_avant_W;

    % Taille surface
    bytes_per_el = 8 - 4*isa(HH_XY,'single');
    mem_Mo = (numel(HH_XY) + numel(X) + numel(Y)) * bytes_per_el / 1e6;

    % Affichage performances
    fprintf('=== PERFORMANCE GUI Layout Toolbox ===\n');
    fprintf('Taille             : %d × %d\n',  n_x, n_y);
    fprintf('Temps              : %.4f s\n',   temps_gen);
    fprintf('RAM calcul (whos)  : %.2f Mo\n',  delta_RAM_MB);
    fprintf('RAM avant          : %.2f Mo\n',  ram_avant_W);
    fprintf('RAM après          : %.2f Mo\n',  ram_apres_W);
    fprintf('Taille surface     : %.1f Mo\n',  mem_Mo);
    fprintf('======================================\n');

    % Statistiques
    z_min  = min(HH_XY(:));
    z_max  = max(HH_XY(:));
    z_mean = mean(HH_XY(:));
    z_std  = std(HH_XY(:));

    app.handles.zMinLabel.Text  = sprintf('Zmin: %.4f m',  z_min);
    app.handles.zMaxLabel.Text  = sprintf('Zmax: %.4f m',  z_max);
    app.handles.zMeanLabel.Text = sprintf('Zmean: %.4f m', z_mean);
    app.handles.zStdLabel.Text  = sprintf('Zstd: %.4f m',  z_std);

    % Affichage dans l'axe
    cla(app.handles.seaSurfaceAx, 'reset');
    pasy = 2; pasx = 2;
    surf(app.handles.seaSurfaceAx, ...
        Y(1:pasy:end), X(1:pasx:end), ...
        HH_XY(1:pasx:end, 1:pasy:end));
    axis(app.handles.seaSurfaceAx, 'equal');
    shading(app.handles.seaSurfaceAx, 'interp');
    xlabel(app.handles.seaSurfaceAx, 'Y (m)');
    ylabel(app.handles.seaSurfaceAx, 'X (m)');
    zlabel(app.handles.seaSurfaceAx, 'Height (m)');

    % Stockage surface
    app.currentSurface = struct(...
        'HH_XY',             HH_XY, ...
        'X',                 X, ...
        'Y',                 Y, ...
        'windSpeed',         u10_ms, ...
        'windDirection_deg', phWind_d, ...
        'fetch_m',           fetch_m, ...
        'Lx_m',              lx_sea_m, ...
        'Ly_m',              ly_sea_m, ...
        'freq_GHz',          freq_GHz, ...
        'nx',                n_x, ...
        'ny',                n_y, ...
        'dxy_m',             dxy_m, ...
        'generated',         datestr(now, 'yyyy-mm-dd HH:MM:SS'));

    close(d);

    % Popup résultat
    msgText = sprintf('Surface %d×%d generated in %.2f s\nSize ≈ %.1f Mo\nRAM used ≈ %.1f MB', ...
        n_x, n_y, temps_gen, mem_Mo, delta_RAM_MB);
    uialert(app.handles.fig, msgText, 'Generation completed', 'Icon', 'success');

    % ── FLAG FIN — après uialert ✅ ──
    try
        fid = fopen('CALC_DONE.flag', 'w');
        fprintf(fid, '%.2f;%.2f;%.2f;%d;%d;%.2f', ...
            temps_gen, delta_RAM_MB, ram_avant_W, n_x, n_y, mem_Mo);
        fclose(fid);
    catch
    end
end


%% Fonction pour effacer la surface de mer générée et liberer la mémoire
function clearSeaSurfaceCallback()
    global app;

    % Réinitialise complètement l'axe d'affichage
    cla(app.handles.seaSurfaceAx, 'reset');
    title(app.handles.seaSurfaceAx, 'Sea Surface Plot');
    xlabel(app.handles.seaSurfaceAx, 'Y (m)');
    ylabel(app.handles.seaSurfaceAx, 'X (m)');
    zlabel(app.handles.seaSurfaceAx, 'Height (m)');
    colorbar(app.handles.seaSurfaceAx, 'off');
    grid(app.handles.seaSurfaceAx, 'off');

    app.handles.zMinLabel.Text = 'Zmin: — m';
    app.handles.zMaxLabel.Text = 'Zmax: — m';
    app.handles.stdLabel.Text   = 'Zstd: — m';

    % Libération de mémoire explicite
    if isfield(app, 'currentSurface')
        app.currentSurface = [];   
        clear global HH_XY X Y;    
    end
    
    % Force la mise à jour de l'interface graphique
    drawnow;
    
    % Demande au système de libérer la mémoire (JVM = Java Virtual Machine, utilisée par MATLAB)
    java.lang.System.gc();

    % Affiche un message de confirmation
    %uialert(app.handles.fig, 'Sea surface cleared and memory freed.', 'Success', 'Icon', 'success');
end

%% Fonction pour exporter la surface de mer générée 
function exportSeaSurfaceCallback()
    global app;

    % Vérifie qu'une surface existe
    if ~isfield(app, 'currentSurface') || isempty(app.currentSurface)
        uialert(app.handles.fig, 'No surface generated yet. Click "Generate Surface" first.', ...
                'Nothing to export', 'Icon', 'warning');
        return;
    end

    surfData = app.currentSurface;

    % Menu d'export
    choices = {...
        'Export .mat file ', ...
        'Export .csv file ', ...
        'Export .png image ', ...
        'Export ALL (.mat + .csv + .png)'};

    [sel, ok] = listdlg('PromptString', 'Select export format:', ...
                        'SelectionMode', 'single', ...
                        'ListString', choices, ...
                        'ListSize', [420 130], ...
                        'Name', 'Export Sea Surface');

    if ~ok || isempty(sel)
        return;  % Annulé
    end

    % Nom de fichier intelligent
    ts = datestr(now, 'yyyymmdd_HHMMSS');
    u10_str = sprintf('u%.1fms', surfData.windSpeed);
    fetch_str = sprintf('f%.0fkm', surfData.fetch_m / 1000);
    freq_str = sprintf('%.2fGHz', surfData.freq_GHz);
    size_str = sprintf('%dx%d', surfData.nx, surfData.ny);
    defaultName = sprintf('SeaSurface_%s_%s_%s_%s_%s', ts, u10_str, fetch_str, freq_str, size_str);

    % Demande où sauvegarder
    [baseName, pathName, ~] = uiputfile(...
        {'*.mat;*.csv;*.png', 'All supported files'; ...
         '*.mat', 'MATLAB data (*.mat)'; ...
         '*.csv', 'CSV data (*.csv)'; ...
         '*.png', 'PNG image (*.png)'}, ...
        'Export Sea Surface', defaultName);

    if isequal(baseName, 0)
        return;  % Annulé
    end

    [~, baseNameNoExt, ~] = fileparts(baseName);

    switch sel
        case 1  % Export .mat
            save(fullfile(pathName, [baseNameNoExt '.mat']), '-struct', 'surfData');
            uialert(app.handles.fig, sprintf('Exported:\n%s.mat', baseNameNoExt), 'Success', 'Icon', 'success');

                case 2  % Export .csv avec séparateur ;
            csvFile = fullfile(pathName, [baseNameNoExt '.csv']);
            
            % Maillage correct
            [Xgrid, Ygrid] = meshgrid(surfData.X, surfData.Y);
            M = [Xgrid(:), Ygrid(:), surfData.HH_XY(:)];
            
            % En-tête + données en une seule écriture propre avec ;
            fid = fopen(csvFile, 'w', 'n', 'UTF-8');
            if fid == -1
                uialert(app.handles.fig, 'Can not create the CSV file ', 'Error');
                return;
            end
            
            % En-tête avec ;
            fprintf(fid, 'X_m;Y_m;Z_m\r\n');
            
            % Données avec ; et 6 décimales (propre et lisible)
            fprintf(fid, '%.6f;%.6f;%.6f\r\n', M');
            
            fclose(fid);
            
            uialert(app.handles.fig, ...
                sprintf('CSV exported :\n%s.csv\n(%,d points)', ...
                baseNameNoExt, size(M,1)), ...
                'Success', 'Icon', 'success');
        case 3  % Export .png 
            pngFile = fullfile(pathName, [baseNameNoExt '.png']);
            exportgraphics(app.handles.seaSurfaceAx, pngFile, ...
                'Resolution', 600, 'ContentType', 'image', 'BackgroundColor', 'white');
            uialert(app.handles.fig, sprintf('Exported:\n%s.png\n', baseNameNoExt), ...
                    'Success', 'Icon', 'success');

        case 4  % TOUT exporter
            matFile = fullfile(pathName, [baseNameNoExt '.mat']);
            csvFile = fullfile(pathName, [baseNameNoExt '.csv']);
            pngFile = fullfile(pathName, [baseNameNoExt '.png']);

            % .mat
            save(matFile, '-struct', 'surfData');

            % .csv
            csvFile = fullfile(pathName, [baseNameNoExt '.csv']);
            [Xgrid, Ygrid] = meshgrid(surfData.X, surfData.Y);
            M = [Xgrid(:), Ygrid(:), surfData.HH_XY(:)];
            
            fid = fopen(csvFile, 'w', 'n', 'UTF-8');
            fprintf(fid, 'X_m;Y_m;Z_m\r\n');
            fprintf(fid, '%.6f;%.6f;%.6f\r\n', M');
            fclose(fid);

            % .png 
            exportgraphics(app.handles.seaSurfaceAx, pngFile, 'Resolution', 600, 'BackgroundColor', 'white');

            uialert(app.handles.fig, ...
                sprintf('All files exported successfully:\n• %s.mat\n• %s.csv\n• %s.png ', ...
                        baseNameNoExt, baseNameNoExt, baseNameNoExt), ...
                'Complete Export', 'Icon', 'success');
    end
end

%% Augmentation de la taille de la police 

allUI = findall(app.handles.fig);

for obj = allUI'
    try
        if isprop(obj, 'FontSize')
            
            if isa(obj, 'matlab.ui.control.DropDown') || ...
               isa(obj, 'matlab.ui.control.EditField') || ...
               isa(obj, 'matlab.ui.control.NumericEditField') || ...
               isa(obj, 'matlab.ui.control.Button') || ...
               isa(obj, 'matlab.ui.control.CheckBox') || ...
               isa(obj, 'matlab.ui.control.Label')
                obj.FontSize = 14;           
                %obj.FontWeight = 'bold';     
            end
        end
        
        % Cas des axes (graphiques)
        if isa(obj, 'matlab.ui.control.UIAxes')
            obj.FontSize = 13;
            obj.Title.FontSize = 16;
            obj.Title.FontWeight = 'bold';
            obj.XLabel.FontSize = 14;
            obj.YLabel.FontSize = 14;
            obj.ZLabel.FontSize = 14;
            obj.Legend.FontSize = 12;
        end
    catch
        
    end
end

% Titre principal 
titleLabel.FontSize = 22;
titleLabel.FontWeight = 'bold';

% Note de validation des modèles 
app.handles.modelNote.FontSize = 14;
app.handles.modelNote.FontWeight = 'bold';

% Boutons plus gros 
btns = [calcBtn, overlayBtn, clearBtn, exportBtn, generateBtn, clearSurfaceBtn, exportSurfaceBtn];
for b = btns
    if isvalid(b)
        b.FontSize = 15;
        b.FontWeight = 'bold';
    end
end
