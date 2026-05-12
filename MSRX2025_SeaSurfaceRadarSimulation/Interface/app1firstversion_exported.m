classdef app1firstversion_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        NRCSSimulationTab               matlab.ui.container.Tab
        GridLayout                      matlab.ui.container.GridLayout
        GridLayout6                     matlab.ui.container.GridLayout
        ExportButton                    matlab.ui.control.Button
        ClearButton                     matlab.ui.control.Button
        OverlayButton                   matlab.ui.control.Button
        CalculateButton                 matlab.ui.control.Button
        GridLayout3                     matlab.ui.container.GridLayout
        GridLayout5                     matlab.ui.container.GridLayout
        ResultsPanel                    matlab.ui.container.Panel
        NRCS905dBfor300incidenceangleLabel  matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
        GridLayout4                     matlab.ui.container.GridLayout
        FrequencyGHzEditField           matlab.ui.control.NumericEditField
        FrequencyGHzEditFieldLabel      matlab.ui.control.Label
        kokcEditField                   matlab.ui.control.NumericEditField
        kokcEditFieldLabel              matlab.ui.control.Label
        FetchmEditField                 matlab.ui.control.NumericEditField
        FetchmEditFieldLabel            matlab.ui.control.Label
        AnglerelativetowinddirectiondegEditField  matlab.ui.control.NumericEditField
        AnglerelativetowinddirectiondegEditFieldLabel  matlab.ui.control.Label
        Windspeedu10mSEditField         matlab.ui.control.NumericEditField
        Windspeedu10mSEditFieldLabel    matlab.ui.control.Label
        PolarizationDropDown            matlab.ui.control.DropDown
        PolarizationDropDownLabel       matlab.ui.control.Label
        ModelDropDown                   matlab.ui.control.DropDown
        ModelDropDownLabel              matlab.ui.control.Label
        FrequencybandDropDown           matlab.ui.control.DropDown
        FrequencybandDropDownLabel      matlab.ui.control.Label
        IncidenceangledegEditField      matlab.ui.control.NumericEditField
        IncidenceangledegEditFieldLabel  matlab.ui.control.Label
        InputparametersLabel            matlab.ui.control.Label
        GridLayout2                     matlab.ui.container.GridLayout
        Image2                          matlab.ui.control.Image
        Image                           matlab.ui.control.Image
        SeaSurfaceRadarSimulatorLabel   matlab.ui.control.Label
        GenerationofseasurfaceTab_2     matlab.ui.container.Tab
        GridLayout_2                    matlab.ui.container.GridLayout
        GridLayout3_2                   matlab.ui.container.GridLayout
        GridLayout7                     matlab.ui.container.GridLayout
        GridLayout9                     matlab.ui.container.GridLayout
        ExportSurfaceButton             matlab.ui.control.Button
        ClearSurfaceButton              matlab.ui.control.Button
        GenerateSurfaceButton           matlab.ui.control.Button
        GridLayout8                     matlab.ui.container.GridLayout
        Roundtothenearestpowerof2CheckBox  matlab.ui.control.CheckBox
        UsesingleprecisionCheckBox      matlab.ui.control.CheckBox
        AngularspectrumDropDown         matlab.ui.control.DropDown
        AngularspectrumDropDownLabel    matlab.ui.control.Label
        IsotropicspectrumDropDown       matlab.ui.control.DropDown
        IsotropicspectrumDropDownLabel  matlab.ui.control.Label
        RoundlengthLabel                matlab.ui.control.Label
        PrecisionLabel                  matlab.ui.control.Label
        NumberofsamplesEditField_2      matlab.ui.control.NumericEditField
        NumberofsamplesEditField_2Label  matlab.ui.control.Label
        SamplesperwavelengthEditField   matlab.ui.control.NumericEditField
        SamplesperwavelengthEditFieldLabel  matlab.ui.control.Label
        RadarfrequencyGHz130GHz2308cmEditField  matlab.ui.control.NumericEditField
        RadarfrequencyGHz130GHz2308cmLabel  matlab.ui.control.Label
        LengthYmEditField               matlab.ui.control.NumericEditField
        LengthYmEditFieldLabel          matlab.ui.control.Label
        LengthXmEditField               matlab.ui.control.NumericEditField
        LengthXmEditFieldLabel          matlab.ui.control.Label
        FetchmEditField_2               matlab.ui.control.NumericEditField
        FetchmEditField_2Label          matlab.ui.control.Label
        WinddirectiondegEditField       matlab.ui.control.NumericEditField
        WinddirectiondegEditFieldLabel  matlab.ui.control.Label
        Windspeedu10msEditField         matlab.ui.control.NumericEditField
        Windspeedu10msEditFieldLabel    matlab.ui.control.Label
        SeasurfaceparametersLabel       matlab.ui.control.Label
        GridLayout5_2                   matlab.ui.container.GridLayout
        SurfacestatisticsPanel          matlab.ui.container.Panel
        GridLayout10                    matlab.ui.container.GridLayout
        Label_8                         matlab.ui.control.Label
        Label_6                         matlab.ui.control.Label
        Label_7                         matlab.ui.control.Label
        Label                           matlab.ui.control.Label
        ZstdLabel                       matlab.ui.control.Label
        ZmaxLabel                       matlab.ui.control.Label
        ZmeanLabel                      matlab.ui.control.Label
        ZminLabel                       matlab.ui.control.Label
        UIAxes_2                        matlab.ui.control.UIAxes
        GridLayout2_2                   matlab.ui.container.GridLayout
        Image2_2                        matlab.ui.control.Image
        Image_2                         matlab.ui.control.Image
        SeaProfileRadarSimulatorLabel   matlab.ui.control.Label
        GenerationofseaProfilesTab      matlab.ui.container.Tab
        GridLayout_3                    matlab.ui.container.GridLayout
        GridLayout3_3                   matlab.ui.container.GridLayout
        GridLayout7_2                   matlab.ui.container.GridLayout
        GridLayout9_2                   matlab.ui.container.GridLayout
        ExportSurfaceButton_2           matlab.ui.control.Button
        ClearSurfaceButton_2            matlab.ui.control.Button
        GenerateProfilesButton          matlab.ui.control.Button
        GridLayout8_2                   matlab.ui.container.GridLayout
        Roundtothenearestpowerof2CheckBox_2  matlab.ui.control.CheckBox
        UsesingleprecisionCheckBox_2    matlab.ui.control.CheckBox
        IsotropicspectrumDropDown_2     matlab.ui.control.DropDown
        IsotropicspectrumDropDown_2Label  matlab.ui.control.Label
        RoundlengthLabel_2              matlab.ui.control.Label
        PrecisionLabel_2                matlab.ui.control.Label
        NumberofsamplesEditField_3      matlab.ui.control.NumericEditField
        NumberofsamplesEditField_3Label  matlab.ui.control.Label
        SamplesperwavelengthEditField_2  matlab.ui.control.NumericEditField
        SamplesperwavelengthEditField_2Label  matlab.ui.control.Label
        RadarfrequencyGHz130GHz2308cmEditField_2  matlab.ui.control.NumericEditField
        RadarfrequencyGHz130GHz2308cmLabel_2  matlab.ui.control.Label
        NprofilesEditField              matlab.ui.control.NumericEditField
        NprofilesEditFieldLabel         matlab.ui.control.Label
        LengthmEditField                matlab.ui.control.NumericEditField
        LengthmEditFieldLabel           matlab.ui.control.Label
        FetchmEditField_3               matlab.ui.control.NumericEditField
        FetchmEditField_3Label          matlab.ui.control.Label
        Windspeedu10msEditField_2       matlab.ui.control.NumericEditField
        Windspeedu10msEditField_2Label  matlab.ui.control.Label
        SeasurfaceparametersLabel_2     matlab.ui.control.Label
        GridLayout5_3                   matlab.ui.container.GridLayout
        ProfileStatisticsPanel          matlab.ui.container.Panel
        GridLayout10_2                  matlab.ui.container.GridLayout
        Label_5                         matlab.ui.control.Label
        Label_3                         matlab.ui.control.Label
        Label_4                         matlab.ui.control.Label
        Label_2                         matlab.ui.control.Label
        ZstdLabel_2                     matlab.ui.control.Label
        ZmaxLabel_2                     matlab.ui.control.Label
        ZmeanLabel_2                    matlab.ui.control.Label
        ZminLabel_2                     matlab.ui.control.Label
        UIAxes_3                        matlab.ui.control.UIAxes
        GridLayout2_3                   matlab.ui.container.GridLayout
        Image2_3                        matlab.ui.control.Image
        Image_3                         matlab.ui.control.Image
        SeaProfileRadarSimulatorLabel_2  matlab.ui.control.Label
        SeaprofileradarsimulatorTab_2   matlab.ui.container.Tab
        GridLayout_4                    matlab.ui.container.GridLayout
        GridLayout3_4                   matlab.ui.container.GridLayout
        GridLayout7_3                   matlab.ui.container.GridLayout
        GridLayout9_3                   matlab.ui.container.GridLayout
        ExportButton_2                  matlab.ui.control.Button
        ClearButton_2                   matlab.ui.control.Button
        CalculateButton_2               matlab.ui.control.Button
        GridLayout8_3                   matlab.ui.container.GridLayout
        PolarizationDropDown_2          matlab.ui.control.DropDown
        PolarizationDropDown_2Label     matlab.ui.control.Label
        SelectprofileDropDown           matlab.ui.control.DropDown
        SelectprofileDropDownLabel      matlab.ui.control.Label
        NumberofsamplesEditField        matlab.ui.control.NumericEditField
        NumberofsamplesEditFieldLabel   matlab.ui.control.Label
        SamplesperwavelengthEditField_3  matlab.ui.control.NumericEditField
        SamplesperwavelengthEditField_3Label  matlab.ui.control.Label
        RadarfrequencyGHz130GHz2308cmEditField_3  matlab.ui.control.NumericEditField
        RadarfrequencyGHz130GHz2308cmEditField_3Label  matlab.ui.control.Label
        IncidenceangledegEditField_2    matlab.ui.control.NumericEditField
        IncidenceangledegEditField_2Label  matlab.ui.control.Label
        LengthmEditField_2              matlab.ui.control.NumericEditField
        LengthmEditField_2Label         matlab.ui.control.Label
        FetchmEditField_4               matlab.ui.control.NumericEditField
        FetchmEditField_4Label          matlab.ui.control.Label
        Windspeedu10msEditField_3       matlab.ui.control.NumericEditField
        Windspeedu10msEditField_3Label  matlab.ui.control.Label
        InputparametersLabel_2          matlab.ui.control.Label
        GridLayout5_4                   matlab.ui.container.GridLayout
        UIAxes_4                        matlab.ui.control.UIAxes
        GridLayout2_4                   matlab.ui.container.GridLayout
        Image2_4                        matlab.ui.control.Image
        Image_4                         matlab.ui.control.Image
        SeaProfileRadarSimulatorLabel_3  matlab.ui.control.Label
    end

    
   properties (Access = private)
    SessionData = {}
    LastSurface = struct()
    ProfilesData cell = {}
    ProfileDropDown      matlab.ui.control.DropDown
    ProfileCountLabel    matlab.ui.control.Label
    RangeStartDropDown   matlab.ui.control.DropDown
    RangeEndDropDown     matlab.ui.control.DropDown
    UIAxes5              matlab.ui.control.UIAxes
    ProfileForNRCS       double = []
    ProfileXForNRCS      double = []
    ProfileSelectorDropDown  matlab.ui.control.DropDown
    IncidenceAngleTab4EditField  matlab.ui.control.NumericEditField
    PolarizationTab4DropDown     matlab.ui.control.DropDown
    NRCSAxes             matlab.ui.control.UIAxes
    isUIInitialized = false
   end

    
    methods (Access = private)



function initializeUIDropdowns(app)
    % Vérifier si déjà initialisé
    if app.isUIInitialized
        return;
    end
    
    % Configurer GridLayout5_3
    app.GridLayout5_3.RowHeight = {'1x', 40, 130};
    app.UIAxes_3.HitTest = 'on';
    app.UIAxes_3.PickableParts = 'all';
    app.ProfileStatisticsPanel.Layout.Row = 3;
    
    % Créer la grille de la ligne 2
    dropGrid = uigridlayout(app.GridLayout5_3);
    dropGrid.ColumnWidth = {'1x', 80, 25, 80, 30, '1x', 160};
    dropGrid.RowHeight = {'1x'};
    dropGrid.Padding = [8 4 8 4];
    dropGrid.ColumnSpacing = 4;
    dropGrid.Layout.Row = 2;
    dropGrid.Layout.Column = 1;
    dropGrid.BackgroundColor = [0.94 0.94 0.94];
    
    % Col 1 : Label "Profile range:"
    rangeLabel = uilabel(dropGrid);
    rangeLabel.Text = 'Profile range:';
    rangeLabel.FontWeight = 'bold';
    rangeLabel.FontSize = 11;
    rangeLabel.HorizontalAlignment = 'right';
    rangeLabel.Layout.Row = 1;
    rangeLabel.Layout.Column = 1;
    
    % Col 2 : Dropdown borne début
    app.RangeStartDropDown = uidropdown(dropGrid);
    app.RangeStartDropDown.Items = {'—'};
    app.RangeStartDropDown.Value = '—';
    app.RangeStartDropDown.Layout.Row = 1;
    app.RangeStartDropDown.Layout.Column = 2;
    app.RangeStartDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();
    
    % Col 3 : Tiret séparateur
    dashLabel = uilabel(dropGrid);
    dashLabel.Text = '—';
    dashLabel.HorizontalAlignment = 'center';
    dashLabel.FontSize = 14;
    dashLabel.FontWeight = 'bold';
    dashLabel.Layout.Row = 1;
    dashLabel.Layout.Column = 3;
    
    % Col 4 : Dropdown borne fin
    app.RangeEndDropDown = uidropdown(dropGrid);
    app.RangeEndDropDown.Items = {'—'};
    app.RangeEndDropDown.Value = '—';
    app.RangeEndDropDown.Layout.Row = 1;
    app.RangeEndDropDown.Layout.Column = 4;
    app.RangeEndDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();
    
    % Col 5 : espace
    sp = uilabel(dropGrid);
    sp.Text = '';
    sp.Layout.Row = 1;
    sp.Layout.Column = 5;
    
    % Col 6 : Label "Selected Profile:"
    selLabel = uilabel(dropGrid);
    selLabel.Text = 'Selected Profile:';
    selLabel.FontWeight = 'bold';
    selLabel.FontSize = 11;
    selLabel.HorizontalAlignment = 'right';
    selLabel.Layout.Row = 1;
    selLabel.Layout.Column = 6;
    
    % Col 7 : Dropdown Selected Profile
    app.ProfileDropDown = uidropdown(dropGrid);
    app.ProfileDropDown.Items = {'— Generate first —'};
    app.ProfileDropDown.Value = '— Generate first —';
    app.ProfileDropDown.Layout.Row = 1;
    app.ProfileDropDown.Layout.Column = 7;
    app.ProfileDropDown.ValueChangedFcn = @(~,~) app.onProfileDropDownChanged();
    
    % Compteur (invisible)
    app.ProfileCountLabel = uilabel(dropGrid);
    app.ProfileCountLabel.Text = '';
    app.ProfileCountLabel.Visible = 'off';
    app.ProfileCountLabel.Layout.Row = 1;
    app.ProfileCountLabel.Layout.Column = 5;
    
    % Titre et layout du panel stats
    app.ProfileStatisticsPanel.Title = 'Profile Statistics';
    app.GridLayout10_2.ColumnWidth = {70, '1x', 70, '1x'};
    app.GridLayout10_2.RowHeight = {'1x', '1x'};
    app.GridLayout10_2.Padding = [10 8 10 8];
    
    % Connecter les champs n_s
    app.LengthmEditField.ValueChangedFcn = @(~,~) app.updateNs();
    app.SamplesperwavelengthEditField_2.ValueChangedFcn = @(~,~) app.updateNs();
    app.RadarfrequencyGHz130GHz2308cmEditField_2.ValueChangedFcn = @(~,~) app.updateFreqLabelProfile();
    app.Roundtothenearestpowerof2CheckBox_2.ValueChangedFcn = @(~,~) app.updateNs();
    app.updateFreqLabelProfile();
    
    % Marquer comme initialisé
    app.isUIInitialized = true;
    
    disp('UI des profils initialisée avec succès');
end


       function onCurveClick(app, src, evt)
    % Récupérer l'index de la courbe cliquée
    idx = str2double(src.Tag);
    if isnan(idx) || idx < 1 || idx > length(app.SessionData)
        return;
    end

    entry = app.SessionData{idx};

    % Position du clic
    clickPos = evt.IntersectionPoint;
    x_click  = clickPos(1);

    % Valeur NRCS interpolée au point cliqué
    valid    = ~isnan(entry.Nrcs_dB);
    y_interp = interp1(entry.Th_i_d(valid), entry.Nrcs_dB(valid), ...
                       x_click, 'linear', 'extrap');

    % Supprimer ancien tooltip
    delete(findobj(app.UIAxes, 'Tag', 'tooltip_box'));

    % Texte tooltip avec les 7 infos
    tipText = sprintf(['Incidence Angle (deg): %.1f\n' ...
                       'NRCS (dB): %.4f\n' ...
                       'Model: %s\n' ...
                       'Pol: %s\n' ...
                       'Freq (GHz): %.2f\n' ...
                       'Wind (m/s): %.1f\n' ...
                       'Wind Angle (deg): %.0f'], ...
        x_click, y_interp, entry.model, entry.pol, ...
        entry.freq, entry.u10, entry.windDir);

    % Affichage tooltip sur le graphe
    text(app.UIAxes, x_click, y_interp, tipText, ...
        'Tag', 'tooltip_box', ...
        'BackgroundColor', [1 1 0.9], ...
        'EdgeColor', [0.3 0.3 0.3], ...
        'Margin', 6, ...
        'FontSize', 9, ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'left', ...
        'Interpreter', 'none');

    % Mettre à jour Results panel
    app.NRCS905dBfor300incidenceangleLabel.Text = ...
        sprintf('NRCS: %.2f dB  (for %.1f° — %s %s)', ...
        y_interp, x_click, entry.model, entry.pol);
end


     function clearTooltip(app, ~, ~)
        oldTip = findobj(app.UIAxes, 'Tag', 'tooltip_box');
        delete(oldTip);
     end


     function drawProfiles(app, selectedIdx)
        cla(app.UIAxes_3);
        hold(app.UIAxes_3, 'on');
        grid(app.UIAxes_3, 'on');
        xlabel(app.UIAxes_3, 'X (m)');
    ylabel(app.UIAxes_3, 'Z (m)');
    
    Ntotal = numel(app.ProfilesData);
    if Ntotal == 0
        title(app.UIAxes_3, ''); 
        hold(app.UIAxes_3, 'off'); 
        return;
    end

    % ── Plage à afficher ──
    if isfield(app.LastSurface, 'ProfileRange') && ...
       numel(app.LastSurface.ProfileRange) == 2
        iStart = app.LastSurface.ProfileRange(1);
        iEnd   = app.LastSurface.ProfileRange(2);
    else
        iStart = 1;
        iEnd   = min(5, Ntotal);
    end
    iStart = max(1, iStart);
    iEnd   = min(Ntotal, iEnd);
    indices = iStart:iEnd;
    Ndisplay = numel(indices);

    colors = lines(Ndisplay);
    for ki = 1:Ndisplay
        k = indices(ki);
        p = app.ProfilesData{k};

        if k == selectedIdx
            ls = '-';
            lw = 2.5;
        else
            ls = '--';
            lw = 0.8;
        end

        plot(app.UIAxes_3, p.X, p.H, ...
            'Color',         colors(ki,:), ...
            'LineStyle',     ls, ...
            'LineWidth',     lw, ...
            'DisplayName',   sprintf('P%d', k), ...
            'Tag',           num2str(k), ...
            'ButtonDownFcn', @(~,~) app.onProfileClick(k));
    end

    legend(app.UIAxes_3, 'Location', 'northeast');
    title(app.UIAxes_3, sprintf('Profiles P%d – P%d  |  %d total', ...
        iStart, iEnd, Ntotal));
    hold(app.UIAxes_3, 'off');
    
    % Ajuster les limites
    allX = []; allH = [];
    for ki = 1:Ndisplay
        k = indices(ki);
        allX = [allX; app.ProfilesData{k}.X(:)];
        allH = [allH; app.ProfilesData{k}.H(:)];
    end
    if ~isempty(allX)
        xlim(app.UIAxes_3, [min(allX), max(allX)]);
        mg = (max(allH)-min(allH))*0.02;
        if mg == 0; mg = 0.01; end
        ylim(app.UIAxes_3, [min(allH)-mg, max(allH)+mg]);
    end
end

     function onProfileClick(app, idx)
    if idx < 1 || idx > numel(app.ProfilesData)
        return;
    end

    H = app.ProfilesData{idx}.H;

    % Stats
    app.Label_2.Text = sprintf('%.4f m', min(H));
    app.Label_3.Text = sprintf('%.4f m', max(H));
    app.Label_4.Text = sprintf('%.4f m', mean(H));
    app.Label_5.Text = sprintf('%.4f m', std(H));

    % Synchroniser dropdown
    targetItem = sprintf('P%d', idx);
    if ismember(targetItem, app.ProfileDropDown.Items)
        app.ProfileDropDown.Value = targetItem;
    end

    % Vérifier plage
    if isfield(app.LastSurface, 'ProfileRange') && numel(app.LastSurface.ProfileRange) == 2
        iStart = app.LastSurface.ProfileRange(1);
        iEnd   = app.LastSurface.ProfileRange(2);
    else
        iStart = 1;
        iEnd   = min(5, numel(app.ProfilesData));
    end

    % Recentrer si hors plage
    if idx < iStart || idx > iEnd
        rangeSize = iEnd - iStart;
        newStart  = max(1, idx - floor(rangeSize/2));
        newEnd    = min(numel(app.ProfilesData), newStart + rangeSize);
        app.LastSurface.ProfileRange = [newStart, newEnd];
        app.fillRangeDropDowns(numel(app.ProfilesData), newStart, newEnd);
    end

    app.drawProfiles(idx);
     end


       function onProfileDropDownChanged(app)
    val = app.ProfileDropDown.Value;

    if contains(val, '—') || isempty(app.ProfilesData)
        return;
    end

    idx = str2double(val(2:end));
    if isnan(idx) || idx < 1 || idx > numel(app.ProfilesData)
        return;
    end

    H = app.ProfilesData{idx}.H;

    % Stats
    app.Label_2.Text = sprintf('%.4f m', min(H));
    app.Label_3.Text = sprintf('%.4f m', max(H));
    app.Label_4.Text = sprintf('%.4f m', mean(H));
    app.Label_5.Text = sprintf('%.4f m', std(H));

    % Lire plage actuelle
    if isfield(app.LastSurface, 'ProfileRange') && numel(app.LastSurface.ProfileRange) == 2
        iStart = app.LastSurface.ProfileRange(1);
        iEnd   = app.LastSurface.ProfileRange(2);
    else
        iStart = 1;
        iEnd   = min(5, numel(app.ProfilesData));
        app.LastSurface.ProfileRange = [iStart, iEnd];
    end

    % Ajuster si hors plage
    if idx < iStart || idx > iEnd
        rangeSize = iEnd - iStart;
        newStart  = max(1, idx - floor(rangeSize/2));
        newEnd    = newStart + rangeSize;
        if newEnd > numel(app.ProfilesData)
            newEnd   = numel(app.ProfilesData);
            newStart = max(1, newEnd - rangeSize);
        end
        app.LastSurface.ProfileRange = [newStart, newEnd];
        app.fillRangeDropDowns(numel(app.ProfilesData), newStart, newEnd);
    end

    app.drawProfiles(idx);
end

  function updateNs(app)
    l_s  = app.LengthmEditField.Value;
    freq = app.RadarfrequencyGHz130GHz2308cmEditField_2.Value;
    nlb  = app.SamplesperwavelengthEditField_2.Value;

    if l_s <= 0 || freq <= 0 || nlb < 1
        app.NumberofsamplesEditField_3.Value = 0;
        return;
    end

    c_ms     = 3e8;
    lambda_m = c_ms / (freq * 1e9);
    n_s_raw  = round(l_s / lambda_m) * nlb;

    % ⭐ CORRECTION : utiliser la bonne checkbox ⭐
    if app.Roundtothenearestpowerof2CheckBox_2.Value  % ← _2 au lieu de rien
        n_s = 2^round(log2(max(1, n_s_raw)));
        l_s_new = n_s * lambda_m / nlb;
        app.LengthmEditField.Value = l_s_new;
    else
        n_s = n_s_raw;
    end

    app.NumberofsamplesEditField_3.Value = n_s;
end

        function updateNsSurface(app)
    lx   = app.LengthXmEditField.Value;
    ly   = app.LengthYmEditField.Value;
    freq = app.RadarfrequencyGHz130GHz2308cmEditField.Value;
    nlb  = app.SamplesperwavelengthEditField.Value;

    if lx <= 0 || ly <= 0 || freq <= 0 || nlb < 1
        app.NumberofsamplesEditField_2.Value = 0;
        return;
    end

    c_ms     = 3e8;
    lambda_m = c_ms / (freq * 1e9);
    dxy_m    = lambda_m / nlb;
    n_x      = round(lx / dxy_m / 2) * 2;
    n_y      = round(ly / dxy_m / 2) * 2;

    if app.Roundtothenearestpowerof2CheckBox.Value
        n_x = 2^round(log2(max(1, n_x)));
        n_y = 2^round(log2(max(1, n_y)));
        app.LengthXmEditField.Value = n_x * dxy_m;
        app.LengthYmEditField.Value = n_y * dxy_m;
    end

    app.NumberofsamplesEditField_2.Value = n_x * n_y;
end

        function onRangeDropDownChanged(app)
    if isempty(app.ProfilesData); return; end

    vs = app.RangeStartDropDown.Value;
    ve = app.RangeEndDropDown.Value;

    if contains(vs,'—') || contains(ve,'—'); return; end

    iStart = str2double(vs);
    iEnd   = str2double(ve);

    if isnan(iStart) || isnan(iEnd); return; end
    
    if iEnd < iStart
        iEnd = iStart;
        app.RangeEndDropDown.ValueChangedFcn = [];
        app.RangeEndDropDown.Value = num2str(iEnd);
        app.RangeEndDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();
    end

    % Limiter à 5 profils
    if (iEnd - iStart + 1) > 5
        iEnd = iStart + 4;
        app.RangeEndDropDown.ValueChangedFcn = [];
        if ismember(num2str(iEnd), app.RangeEndDropDown.Items)
            app.RangeEndDropDown.Value = num2str(iEnd);
        end
        app.RangeEndDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();
    end

    % Stocker et redessiner
    app.LastSurface.ProfileRange = [iStart, iEnd];

    app.Label_2.Text = '—';
    app.Label_4.Text = '—';
    app.Label_3.Text = '—';
    app.Label_5.Text = '—';

    if ismember('— Select a profile —', app.ProfileDropDown.Items)
        app.ProfileDropDown.Value = '— Select a profile —';
    end

    app.drawProfiles(-1);
end

       function fillRangeDropDowns(app, Nprof, iStart, iEnd)
    items = arrayfun(@(k) num2str(k), 1:Nprof, 'UniformOutput', false);

    app.RangeStartDropDown.ValueChangedFcn = [];
    app.RangeEndDropDown.ValueChangedFcn   = [];

    app.RangeStartDropDown.Items = items;
    app.RangeEndDropDown.Items   = items;

    app.RangeStartDropDown.Value = num2str(iStart);
    app.RangeEndDropDown.Value   = num2str(iEnd);

    app.RangeStartDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();
    app.RangeEndDropDown.ValueChangedFcn   = @(~,~) app.onRangeDropDownChanged();
end

       function updateFreqLabelSurface(app)
    freq = app.RadarfrequencyGHz130GHz2308cmEditField.Value;
    if freq <= 0; return; end
    lambda_cm = (3e8 / (freq * 1e9)) * 100;
    app.RadarfrequencyGHz130GHz2308cmLabel.Text = ...
        sprintf('Radar frequency (GHz):\n%.2f GHz → λ = %.2f cm', freq, lambda_cm);
end

       function updateFreqLabelProfile(app)
    freq = app.RadarfrequencyGHz130GHz2308cmEditField_2.Value;
    if freq <= 0; return; end
    lambda_cm = (3e8 / (freq * 1e9)) * 100;
    app.RadarfrequencyGHz130GHz2308cmLabel_2.Text = ...
        sprintf('Radar frequency (GHz):\n%.2f GHz → λ = %.2f cm', freq, lambda_cm);
    app.updateNs();
end

       function updateFreqLabelTab4(app)
    freq = app.RadarfrequencyGHz130GHz2308cmEditField_3.Value;
    if freq <= 0; return; end
    lambda_cm = (3e8 / (freq * 1e9)) * 100;
    app.RadarfrequencyGHz130GHz2308cmEditField_3Label.Text = ...
        sprintf('Radar frequency (GHz):\n%.2f GHz → λ = %.2f cm', freq, lambda_cm);
end

    function onSurfaceClick(app, src, evt)
    if ~isfield(app.LastSurface, 'HH_XY'); return; end
    
    clickPos = evt.IntersectionPoint;
    if isempty(clickPos) || numel(clickPos) < 2; return; end

    HH_XY = app.LastSurface.HH_XY;
    X     = app.LastSurface.X;
    Y     = app.LastSurface.Y;

    % Récupérer les coordonnées du clic
    % Dans UIAxes_2, l'axe X représente Y (m) et l'axe Y représente X (m)
    y_click = clickPos(1);  % Position Y sur la carte
    x_click = clickPos(2);  % Position X sur la carte
    
    [~, iy] = min(abs(Y - y_click));
    [~, ix] = min(abs(X - x_click));
    
    % Profil à Y constant (coupe selon X)
    profil_Z = HH_XY(:, iy);

    % Rendre visible UIAxes5 et ajuster le layout
    app.UIAxes5.Visible = 'on';
    app.GridLayout5_2.RowHeight = {'1x', 150, 130};

    % Tracer le profil
    cla(app.UIAxes5);
    plot(app.UIAxes5, X, profil_Z, 'b-', 'LineWidth', 1.5);
    hold(app.UIAxes5, 'on');
    
    % Marquer le point cliqué
    plot(app.UIAxes5, X(ix), profil_Z(ix), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    
    % Afficher les coordonnées du point
    text(app.UIAxes5, X(ix) + 0.02*diff(xlim(app.UIAxes5)), profil_Z(ix), ...
        sprintf('  Y = %.2f m\n  Z = %.3f m', Y(iy), profil_Z(ix)), ...
        'FontSize', 9, 'Color', 'k', 'VerticalAlignment', 'bottom', ...
        'BackgroundColor', [1 1 0.9], 'EdgeColor', [0.5 0.5 0.5]);
    
    hold(app.UIAxes5, 'off');
    
    % Configurer les axes du profil
    xlabel(app.UIAxes5, 'X (m)');
    ylabel(app.UIAxes5, 'Z (m)');
    title(app.UIAxes5, sprintf('Profil à Y = %.2f m', Y(iy)));
    grid(app.UIAxes5, 'on');
    app.UIAxes5.FontSize = 10;
    
    % Ajuster les limites Y pour bien voir
    zMin = min(profil_Z);
    zMax = max(profil_Z);
    margin = max(0.1, (zMax - zMin) * 0.1);
    ylim(app.UIAxes5, [zMin - margin, zMax + margin]);

    % Ligne rouge sur la surface 3D pour indiquer la coupe
    hold(app.UIAxes_2, 'on');
    delete(findobj(app.UIAxes_2, 'Tag', 'profile_line'));
    
    % La ligne est à X constant (x_click) sur toute l'étendue de Y
    zTop = max(HH_XY(:));
    lineZ = repmat(zTop * 1.05, size(Y));
    lineX = repmat(x_click, size(Y));
    
    plot3(app.UIAxes_2, Y, lineX, lineZ, ...
        'r-', 'LineWidth', 2, 'Tag', 'profile_line');
    hold(app.UIAxes_2, 'off');

    % Reconnecter le callback de clic sur la surface
    hSurf = findobj(app.UIAxes_2, 'Type', 'surface');
    if ~isempty(hSurf)
        hSurf(1).ButtonDownFcn = @(s, e) app.onSurfaceClick(s, e);
        hSurf(1).HitTest = 'on';
        hSurf(1).PickableParts = 'all';
    end
end

    function onProfileSelectorChanged(app)
    val = app.SelectprofileDropDown.Value;
    if isempty(app.ProfilesData) || contains(val, '—'); return; end

    idx = str2double(val(2:end));
    if isnan(idx) || idx < 1 || idx > numel(app.ProfilesData); return; end

    app.ProfileForNRCS  = app.ProfilesData{idx}.H;
    app.ProfileXForNRCS = app.ProfilesData{idx}.X;

    % Afficher profil dans UIAxes_4
    cla(app.UIAxes_4);
    plot(app.UIAxes_4, app.ProfileXForNRCS, app.ProfileForNRCS, ...
        'Color', [0.1 0.3 0.8], 'LineWidth', 1.2);
    grid(app.UIAxes_4, 'on');
    xlabel(app.UIAxes_4, 'X (m)');
    ylabel(app.UIAxes_4, 'Z (m)');
    title(app.UIAxes_4, sprintf('Profile %s — select then click Calculate', val));

    % Effacer NRCS précédent
    cla(app.NRCSAxes);
    title(app.NRCSAxes, 'NRCS — click Calculate');
end

        function plotSpectra(app)
    u10     = app.Windspeedu10msEditField.Value;
    fetch_m = app.FetchmEditField_2.Value;
    isoMdl  = strtrim(app.IsotropicspectrumDropDown.Value);
    angMdl  = strtrim(app.AngularspectrumDropDown.Value);

    if u10 <= 0 || fetch_m <= 0
        uialert(app.UIFigure, 'Please set Wind speed u10 and Fetch first.', ...
            'Missing parameters', 'Icon', 'warning');
        return;
    end

    K = logspace(log10(0.01), log10(1000), 600);

    try
        switch isoMdl
            case {'Apel', 'Apel '}
                Sh_iso = f_SpectrumSea_IsoFetch_Apel(u10, K, fetch_m);
                isoLabel = 'Apel (1994)';
            case 'Elfouhaily'
                g = 9.81; x0 = 2.2e4; km = 370;
                k0 = g / u10^2;
                xmaj = k0 * fetch_m;
                omgc = 0.84 * tanh((xmaj/x0)^0.4)^(-0.75);
                kp = k0 * omgc^2;
                alphp = 6e-3 * omgc^0.55;
                if omgc <= 1; gm = 1.7; else; gm = 1.7 + 6*log10(omgc); end
                sgm = 0.08 * (1 + 4*omgc^(-3));
                cp = sqrt(g*(1+kp^2/km^2)/kp);
                z0 = 3.7e-5 * u10^2/g * (u10/cp)^0.9;
                u_f = 0.4 / log(10/z0) * u10;
                L_PM = exp(-5/4*(kp./K).^2);
                J_p = gm .^ exp(-(sqrt(K/kp)-1).^2/(2*sgm^2));
                B_l = 0.5*alphp * L_PM .* J_p .* sqrt(K/kp);
                alphhf = 1.8e-2;
                B_h = alphhf * (1 + 2.5*(K/km).^(5/2)) .* exp(-0.25*(K/km-1).^2);
                Sh_iso = (B_l + B_h.*(K > 10*kp)) ./ K.^3;
                isoLabel = 'Elfouhaily (1997)';
            case {'Donelan', 'Donelan-Pierson'}
                g = 9.81; km = 370;
                k0 = g / u10^2;
                xmaj = k0 * fetch_m;
                omgc = 11.6 * xmaj^(-0.23);
                if omgc < 0.84; omgc = 0.84; end
                kp = k0 * omgc^2;
                cp = sqrt(g*(1+kp^2/km^2)/kp);
                z0 = 3.7e-5 * u10^2/g * (u10/cp)^0.9;
                u_f = 0.4 / log(10/z0) * u10;
                Sh_iso = f_SpectrumSea_IsoFetch_DonelanPierson(u10, K, fetch_m, u_f);
                isoLabel = 'Donelan-Pierson (1987)';
            otherwise
                return;
        end

        Phi_d = 0;
        switch angMdl
            case 'Elfouhaily'
                [Phi_spr, ~] = f_SpectrumSea_AngFetch_ElfouhailyDu(u10, Phi_d, K, fetch_m, [], 'El');
                angLabel = 'Elfouhaily (1997)';
            case 'Du'
                [Phi_spr, ~] = f_SpectrumSea_AngFetch_ElfouhailyDu(u10, Phi_d, K, fetch_m, [], 'Du');
                angLabel = 'Du (2017)';
            case 'Donelan'
                [Phi_spr, ~, ~] = f_SpectrumSea_AngFetch_DonelanBannerMD(u10, Phi_d, K, fetch_m, 'Don');
                angLabel = 'Donelan (1985)';
            case 'Banner'
                [Phi_spr, ~, ~] = f_SpectrumSea_AngFetch_DonelanBannerMD(u10, Phi_d, K, fetch_m, 'Ban');
                angLabel = 'Banner (1990)';
            case 'McDaniel'
                [Phi_spr, ~, ~] = f_SpectrumSea_AngFetch_DonelanBannerMD(u10, Phi_d, K, fetch_m, 'McD');
                angLabel = 'McDaniel (2001)';
            otherwise
                Phi_spr = ones(size(K)) / (2*pi);
                angLabel = 'Flat';
        end

        Sh_dir = Sh_iso .* Phi_spr;

    catch ME
        uialert(app.UIFigure, ['Spectrum error: ' ME.message], 'Spectrum error', 'Icon', 'warning');
        return;
    end

    fig = findobj('Tag', 'SpectraFig');
    if isempty(fig)
        fig = figure('Tag', 'SpectraFig', 'Name', 'Sea Surface Spectra', 'Position', [200 200 900 500]);
    else
        clf(fig);
    end

    ax1 = subplot(1, 2, 1, 'Parent', fig);
    loglog(ax1, K, Sh_iso, 'b-', 'LineWidth', 2);
    grid(ax1, 'on');
    xlabel(ax1, 'K (rad/m)');
    ylabel(ax1, 'S_h^{iso} (m^3/rad)');
    title(ax1, sprintf('Isotropic spectrum\n%s\nu_{10}=%.1f m/s | fetch=%.0e m', isoLabel, u10, fetch_m));
    set(ax1, 'FontSize', 10);
    xlim(ax1, [min(K) max(K)]);

    ax2 = subplot(1, 2, 2, 'Parent', fig);
    semilogx(ax2, K, Phi_spr, 'r-', 'LineWidth', 2);
    hold(ax2, 'on');
    semilogx(ax2, K, Sh_dir / max(Sh_dir), 'k--', 'LineWidth', 1.5, 'DisplayName', 'Directional (normalized)');
    hold(ax2, 'off');
    grid(ax2, 'on');
    xlabel(ax2, 'K (rad/m)');
    ylabel(ax2, '\Phi_{spr} (1/rad)');
    title(ax2, sprintf('Angular spreading function\n%s\n\\phi_d=0° (upwind)', angLabel));
    legend(ax2, {['Φ_{spr} — ' angLabel], 'S_{dir} (norm.)'}, 'Location', 'northeast', 'FontSize', 8);
    set(ax2, 'FontSize', 10);
    xlim(ax2, [min(K) max(K)]);

    sgtitle(fig, sprintf('Sea Surface Height Spectrum  —  u_{10} = %.1f m/s  |  fetch = %.0e m', u10, fetch_m), ...
        'FontSize', 12, 'FontWeight', 'bold');
end

       function plotSpectraProfile(app)
    u10     = app.Windspeedu10msEditField_2.Value;
    fetch_m = app.FetchmEditField_3.Value;
    isoMdl  = strtrim(app.IsotropicspectrumDropDown_2.Value);

    if u10 <= 0 || fetch_m <= 0
        uialert(app.UIFigure, 'Please set Wind speed u10 and Fetch first.', ...
            'Missing parameters', 'Icon', 'warning');
        return;
    end

    K = logspace(log10(0.01), log10(1000), 600);

    try
        switch isoMdl
            case {'Apel', 'Apel '}
                Sh_iso = f_SpectrumSea_IsoFetch_Apel(u10, K, fetch_m);
                isoLabel = 'Apel (1994)';
            case 'Elfouhaily'
                g = 9.81; x0 = 2.2e4; km = 370;
                k0 = g / u10^2;
                xmaj = k0 * fetch_m;
                omgc = 0.84 * tanh((xmaj/x0)^0.4)^(-0.75);
                kp = k0 * omgc^2;
                alphp = 6e-3 * omgc^0.55;
                if omgc <= 1; gm = 1.7; else; gm = 1.7 + 6*log10(omgc); end
                sgm = 0.08 * (1 + 4*omgc^(-3));
                L_PM = exp(-5/4*(kp./K).^2);
                J_p = gm .^ exp(-(sqrt(K/kp)-1).^2/(2*sgm^2));
                B_l = 0.5*alphp * L_PM .* J_p .* sqrt(K/kp);
                alphhf = 1.8e-2;
                B_h = alphhf * (1 + 2.5*(K/km).^(5/2)) .* exp(-0.25*(K/km-1).^2);
                Sh_iso = (B_l + B_h.*(K > 10*kp)) ./ K.^3;
                isoLabel = 'Elfouhaily (1997)';
            case {'Donelan', 'Donelan-Pierson'}
                g = 9.81; km = 370;
                k0 = g / u10^2;
                xmaj = k0 * fetch_m;
                omgc = 11.6 * xmaj^(-0.23);
                if omgc < 0.84; omgc = 0.84; end
                kp = k0 * omgc^2;
                cp = sqrt(g*(1+kp^2/km^2)/kp);
                z0 = 3.7e-5 * u10^2/g * (u10/cp)^0.9;
                u_f = 0.4 / log(10/z0) * u10;
                Sh_iso = f_SpectrumSea_IsoFetch_DonelanPierson(u10, K, fetch_m, u_f);
                isoLabel = 'Donelan-Pierson (1987)';
            otherwise
                return;
        end

    catch ME
        uialert(app.UIFigure, ['Spectrum error: ' ME.message], 'Spectrum error', 'Icon', 'warning');
        return;
    end

    fig = findobj('Tag', 'SpectraFig3');
    if isempty(fig)
        fig = figure('Tag', 'SpectraFig3', 'Name', 'Isotropic Spectrum — Profiles', ...
            'Position', [200 200 600 450]);
    else
        clf(fig);
    end

    ax = axes('Parent', fig);
    loglog(ax, K, Sh_iso, 'b-', 'LineWidth', 2.5);
    grid(ax, 'on');
    xlabel(ax, 'K (rad/m)', 'FontSize', 11);
    ylabel(ax, 'S_h^{iso} (m^3/rad)', 'FontSize', 11);
    title(ax, sprintf('Isotropic Spectrum — %s\nu_{10} = %.1f m/s  |  fetch = %.0e m', ...
        isoLabel, u10, fetch_m), 'FontSize', 12, 'FontWeight', 'bold');
    set(ax, 'FontSize', 10);
    xlim(ax, [min(K) max(K)]);
end



        %% ── STARTUP ─────────────────────────────────────────────────────

 function startupFcn(app)
    % ── Démarrer le pool parallèle si disponible ──
    try
        if isempty(gcp('nocreate'))
            parpool('local');
        end
    catch
        % Parallel Computing Toolbox non disponible — mode séquentiel
    end

    app.SessionData = {};
    app.UIAxes_2.Box = 'off';
    app.UIAxes_2.Color = 'none';
    app.UIAxes_2.ZColor = 'none';
    
    % ── Label NRCS ──
    app.NRCS905dBfor300incidenceangleLabel.Position = [10 5 500 60];

    FrequencybandDropDownValueChanged(app, []);

    % ═══════════════════════════════════════════════════════════════
    %  ONGLET 3 : Generation of sea Profiles (adapté pour nouvelle app)
    % ═══════════════════════════════════════════════════════════════
    
    % ── Valeurs par défaut onglet 3 ──
    app.Windspeedu10msEditField_2.Value = 10;
    app.FetchmEditField_3.Value = 500000;
    app.LengthmEditField.Value = 200;
    app.RadarfrequencyGHz130GHz2308cmEditField_2.Value = 1.30;
    app.SamplesperwavelengthEditField_2.Value = 4;
    app.NprofilesEditField.Value = 5;
    app.UsesingleprecisionCheckBox_2.Value = false;

    % ── Connecter les boutons onglet 3 (noms adaptés) ──
    app.GenerateProfilesButton.ButtonPushedFcn = @(~,~) GenerateProfilesButtonPushed(app, []);
    app.ClearSurfaceButton_2.ButtonPushedFcn = @(~,~) ClearSurfaceButton_2Pushed(app, []);
    app.ExportSurfaceButton_2.ButtonPushedFcn = @(~,~) ExportSurfaceButton_2Pushed(app, []);

    % ═══════════════════════════════════════════════════════════════
    %  CONFIGURATION GRIDLAYOUT5_3 (remplace GridLayout30)
    % ═══════════════════════════════════════════════════════════════
    app.GridLayout5_3.RowHeight = {'1x', 40, 130};
    app.UIAxes_3.HitTest = 'on';
    app.UIAxes_3.PickableParts = 'all';
    app.ProfileStatisticsPanel.Layout.Row = 3;

    % ── Créer la grille de la ligne 2 ──
    dropGrid = uigridlayout(app.GridLayout5_3);
    dropGrid.ColumnWidth = {'1x', 80, 25, 80, 30, '1x', 160};
    dropGrid.RowHeight = {'1x'};
    dropGrid.Padding = [8 4 8 4];
    dropGrid.ColumnSpacing = 4;
    dropGrid.Layout.Row = 2;
    dropGrid.Layout.Column = 1;
    dropGrid.BackgroundColor = [0.94 0.94 0.94];

    % ── Col 1 : Label "Profile range:" ──
    rangeLabel = uilabel(dropGrid);
    rangeLabel.Text = 'Profile range:';
    rangeLabel.FontWeight = 'bold';
    rangeLabel.FontSize = 11;
    rangeLabel.HorizontalAlignment = 'right';
    rangeLabel.Layout.Row = 1;
    rangeLabel.Layout.Column = 1;

    % ── Col 2 : Dropdown borne début ──
    app.RangeStartDropDown = uidropdown(dropGrid);
    app.RangeStartDropDown.Items = {'—'};
    app.RangeStartDropDown.Value = '—';
    app.RangeStartDropDown.Layout.Row = 1;
    app.RangeStartDropDown.Layout.Column = 2;
    app.RangeStartDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();

    % ── Col 3 : Tiret séparateur ──
    dashLabel = uilabel(dropGrid);
    dashLabel.Text = '—';
    dashLabel.HorizontalAlignment = 'center';
    dashLabel.FontSize = 14;
    dashLabel.FontWeight = 'bold';
    dashLabel.Layout.Row = 1;
    dashLabel.Layout.Column = 3;

    % ── Col 4 : Dropdown borne fin ──
    app.RangeEndDropDown = uidropdown(dropGrid);
    app.RangeEndDropDown.Items = {'—'};
    app.RangeEndDropDown.Value = '—';
    app.RangeEndDropDown.Layout.Row = 1;
    app.RangeEndDropDown.Layout.Column = 4;
    app.RangeEndDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();

    % ── Col 5 : espace ──
    sp = uilabel(dropGrid);
    sp.Text = '';
    sp.Layout.Row = 1;
    sp.Layout.Column = 5;

    % ── Col 6 : Label "Selected Profile:" ──
    selLabel = uilabel(dropGrid);
    selLabel.Text = 'Selected Profile:';
    selLabel.FontWeight = 'bold';
    selLabel.FontSize = 11;
    selLabel.HorizontalAlignment = 'right';
    selLabel.Layout.Row = 1;
    selLabel.Layout.Column = 6;

    % ── Col 7 : Dropdown Selected Profile ──
    app.ProfileDropDown = uidropdown(dropGrid);
    app.ProfileDropDown.Items = {'— Generate first —'};
    app.ProfileDropDown.Value = '— Generate first —';
    app.ProfileDropDown.Layout.Row = 1;
    app.ProfileDropDown.Layout.Column = 7;
    app.ProfileDropDown.ValueChangedFcn = @(~,~) app.onProfileDropDownChanged();

    % ── Compteur (invisible) ──
    app.ProfileCountLabel = uilabel(dropGrid);
    app.ProfileCountLabel.Text = '';
    app.ProfileCountLabel.Visible = 'off';
    app.ProfileCountLabel.Layout.Row = 1;
    app.ProfileCountLabel.Layout.Column = 5;

    % ── Titre et layout du panel stats ──
    app.ProfileStatisticsPanel.Title = 'Profile Statistics';
    app.GridLayout10_2.ColumnWidth = {70, '1x', 70, '1x'};
    app.GridLayout10_2.RowHeight = {'1x', '1x'};
    app.GridLayout10_2.Padding = [10 8 10 8];

    % ── Connecter les champs n_s ──
    app.LengthmEditField.ValueChangedFcn = @(~,~) app.updateNs();
    app.SamplesperwavelengthEditField_2.ValueChangedFcn = @(~,~) app.updateNs();
    
    % ── Onglet 3 : fréquence → label + n_s ──
    app.RadarfrequencyGHz130GHz2308cmEditField_2.ValueChangedFcn = @(~,~) app.updateFreqLabelProfile();
    app.updateFreqLabelProfile();
    
    app.Roundtothenearestpowerof2CheckBox_2.ValueChangedFcn = @(~,~) app.updateNs();
    app.updateNs();

    % ═══════════════════════════════════════════════════════════════
    %  ONGLET 2 : Generation of sea surface (adapté)
    % ═══════════════════════════════════════════════════════════════
    
    app.RadarfrequencyGHz130GHz2308cmEditField.ValueChangedFcn = @(~,~) app.updateFreqLabelSurface();
    app.updateFreqLabelSurface();
    
    app.Roundtothenearestpowerof2CheckBox.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.updateNsSurface();

    % ── Connecter les champs onglet 2 pour mise à jour automatique de n_s ──
    app.LengthXmEditField.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.LengthYmEditField.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.RadarfrequencyGHz130GHz2308cmEditField.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.SamplesperwavelengthEditField.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.Roundtothenearestpowerof2CheckBox.ValueChangedFcn = @(~,~) app.updateNsSurface();



    % ── Valeurs par défaut onglet 2 ──
app.Windspeedu10msEditField.Value   = 8;
app.WinddirectiondegEditField.Value = 0;
app.FetchmEditField_2.Value         = 500000;
app.LengthXmEditField.Value         = 40;
app.LengthYmEditField.Value         = 30;
app.RadarfrequencyGHz130GHz2308cmEditField.Value = 1.30;
app.SamplesperwavelengthEditField.Value           = 8;

    % ── Calculer n_s initial ──
    app.updateNsSurface();

    % ── Number of samples — lecture seule ──
    app.NumberofsamplesEditField_3.Editable = 'off';
    app.NumberofsamplesEditField_2.Editable = 'off';

    % ═══════════════════════════════════════════════════════════════
    %  ONGLET 2 : Clic sur surface et profil
    % ═══════════════════════════════════════════════════════════════
    app.GridLayout5_2.RowHeight = {'1x', 0, 130};
    app.SurfacestatisticsPanel.Layout.Row = 3;

    app.UIAxes5 = uiaxes(app.GridLayout5_2);
    app.UIAxes5.Layout.Row = 2;
    app.UIAxes5.Layout.Column = 1;
    app.UIAxes5.Visible = 'off';
    xlabel(app.UIAxes5, 'X (m)');
    ylabel(app.UIAxes5, 'Z (m)');
    app.UIAxes5.XGrid = 'on';
    app.UIAxes5.YGrid = 'on';
    app.UIAxes5.FontSize = 9;

    app.UIAxes_2.ButtonDownFcn = @(src,evt) app.onSurfaceClick(src, evt);
    app.UIAxes_2.HitTest = 'on';
    app.UIAxes_2.PickableParts = 'all';

    % ═══════════════════════════════════════════════════════════════
    %  ONGLET 4 : Sea profile radar simulator
    % ═══════════════════════════════════════════════════════════════
    
    % Champs lecture seule (copiés depuis onglet 3)
    app.Windspeedu10msEditField_3.Editable = 'off';
    app.FetchmEditField_4.Editable = 'off';
    app.LengthmEditField_2.Editable = 'off';
    app.RadarfrequencyGHz130GHz2308cmEditField_3.Editable = 'off';
    app.SamplesperwavelengthEditField_3.Editable = 'off';
    app.NumberofsamplesEditField.Editable = 'off';

    % ── Label fréquence dynamique onglet 4 ──
    app.RadarfrequencyGHz130GHz2308cmEditField_3.ValueChangedFcn = @(~,~) app.updateFreqLabelTab4();

    % Valeurs initiales par défaut
    app.Windspeedu10msEditField_3.Value = 0;
    app.FetchmEditField_4.Value = 0;
    app.LengthmEditField_2.Value = 0;
    app.RadarfrequencyGHz130GHz2308cmEditField_3.Value = 0;
    app.SamplesperwavelengthEditField_3.Value = 0;
    app.NumberofsamplesEditField.Value = 0;

    % ── Connecter les boutons onglet 4 ──
    app.CalculateButton_2.ButtonPushedFcn = @(~,~) app.CalculateButton_2Pushed([]);
    app.ClearButton_2.ButtonPushedFcn = @(~,~) app.ClearButton_2Pushed([]);

    % ── Dropdown pour choisir le profil (existe déjà : SelectprofileDropDown) ──
    % On s'assure que le callback est connecté
    app.SelectprofileDropDown.ValueChangedFcn = @(~,~) app.onProfileSelectorChanged();

    % ── Diviser UIAxes_4 en 2 zones : profil (haut) + NRCS (bas) ──
    app.GridLayout5_4.RowHeight = {'1x', '1x'};
    app.UIAxes_4.Layout.Row = 1;

    % ── Créer UIAxes pour le NRCS (ligne 2) ──
    if isempty(app.NRCSAxes) || ~isvalid(app.NRCSAxes)
        app.NRCSAxes = uiaxes(app.GridLayout5_4);
        app.NRCSAxes.Layout.Row = 2;
        app.NRCSAxes.Layout.Column = 1;
        xlabel(app.NRCSAxes, 'Scattering angle θ_{sca} (deg)');
        ylabel(app.NRCSAxes, 'NRCS (dB)');
        app.NRCSAxes.XGrid = 'on';
        app.NRCSAxes.YGrid = 'on';
    end

    

    % ═══════════════════════════════════════════════════════════════
    %  SPECTRES
    % ═══════════════════════════════════════════════════════════════
    app.IsotropicspectrumDropDown.ValueChangedFcn = @(~,~) app.plotSpectra();
    app.AngularspectrumDropDown.ValueChangedFcn = @(~,~) app.plotSpectra();
    app.IsotropicspectrumDropDown_2.ValueChangedFcn = @(~,~) app.plotSpectraProfile();


      % ═══════════════════════════════════════════════════════════════
    %  SPECTRES - MISE À JOUR AUTOMATIQUE (ONGLE 2)
    % ═══════════════════════════════════════════════════════════════
    
    % Quand l'utilisateur change le spectre isotrope → recalcul automatique
    app.IsotropicspectrumDropDown.ValueChangedFcn = @(~,~) app.plotSpectra();
    
    % Quand l'utilisateur change le spectre angulaire → recalcul automatique
    app.AngularspectrumDropDown.ValueChangedFcn = @(~,~) app.plotSpectra();
    
    % Quand l'utilisateur change le spectre isotrope (onglet 3) → recalcul
    app.IsotropicspectrumDropDown_2.ValueChangedFcn = @(~,~) app.plotSpectraProfile();
    
    % Quand l'utilisateur change la fréquence (onglet 2) → mettre à jour l'affichage
    app.RadarfrequencyGHz130GHz2308cmEditField.ValueChangedFcn = @(~,~) app.updateFreqLabelSurface();
    
    % Quand l'utilisateur change la fréquence (onglet 3) → mettre à jour l'affichage ET n_s
    app.RadarfrequencyGHz130GHz2308cmEditField_2.ValueChangedFcn = @(~,~) app.updateFreqLabelProfile();
    
    % Quand l'utilisateur change la fréquence (onglet 4) → mettre à jour l'affichage
    app.RadarfrequencyGHz130GHz2308cmEditField_3.ValueChangedFcn = @(~,~) app.updateFreqLabelTab4();
    
    % Mettre à jour les labels au démarrage
    app.updateFreqLabelSurface();
    app.updateFreqLabelProfile();
    app.updateFreqLabelTab4();
    
    % ═══════════════════════════════════════════════════════════════
    %  MISE À JOUR AUTOMATIQUE DE n_s (ONGLET 3)
    % ═══════════════════════════════════════════════════════════════
    app.LengthmEditField.ValueChangedFcn = @(~,~) app.updateNs();
    app.SamplesperwavelengthEditField_2.ValueChangedFcn = @(~,~) app.updateNs();
    app.Roundtothenearestpowerof2CheckBox.ValueChangedFcn = @(~,~) app.updateNsSurface();
    
    % ═══════════════════════════════════════════════════════════════
    %  MISE À JOUR AUTOMATIQUE DE n_s (ONGLET 2)
    % ═══════════════════════════════════════════════════════════════
    app.LengthXmEditField.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.LengthYmEditField.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.SamplesperwavelengthEditField.ValueChangedFcn = @(~,~) app.updateNsSurface();
    app.Roundtothenearestpowerof2CheckBox.ValueChangedFcn = @(~,~) app.updateNsSurface();
    
    % Calcul initial
    app.updateNs();
    app.updateNsSurface();
    
    % ═══════════════════════════════════════════════════════════════
    %  AFFICHAGE DU SPECTRE AU DÉMARRAGE (comme dans l'ancienne app)
    % ═══════════════════════════════════════════════════════════════
    %app.plotSpectra();
    %app.plotSpectraProfile();

    disp('=== Application initialisée avec succès ===');
end

    end % methods (Access = private) — helpers
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            u10=app.Windspeedu10mSEditField.Value; windDir=app.AnglerelativetowinddirectiondegEditField.Value;
            pol=app.PolarizationDropDown.Value; model=app.ModelDropDown.Value;
            freq=app.FrequencyGHzEditField.Value; th_user=app.IncidenceangledegEditField.Value;
            Nrcs_VV=[]; Nrcs_HH=[]; Nrcs_VH=[]; Th_i_d=[];
            try
                switch model
                    case 'Isoguchi'; Th_i_d=(17:0.5:43)'; [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Lband_Isoguchi(Th_i_d,u10,windDir); Nrcs_VH=NaN(size(Th_i_d));
                    case 'Meissner'; Th_i_d=(24.36:0.5:49.29)'; [Nrcs_VV,Nrcs_HH,Nrcs_VH]=f_Nrcs_3dMono_EmpExpSea_Lband_Meissner_v2(Th_i_d,u10,windDir,'linear');
                    case 'Quilfen'
                        if u10>19.9; uialert(app.UIFigure,'Quilfen : u10 doit être < 20 m/s','Paramètre invalide','Icon','warning'); return; end
                        Th_i_d=(18:0.5:60); [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Cband_Quilfen(Th_i_d,u10,windDir); Nrcs_VV=Nrcs_VV(:); Nrcs_HH=Nrcs_HH(:); Th_i_d=Th_i_d(:); Nrcs_VH=NaN(size(Th_i_d));
                    case 'CMOD2-I3'; Th_i_d=(18:0.5:57); [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Cband_Cmod2I3(Th_i_d,u10,windDir); Nrcs_VV=Nrcs_VV(:); Nrcs_HH=Nrcs_HH(:); Th_i_d=Th_i_d(:); Nrcs_VH=NaN(size(Th_i_d));
                    case 'CMOD5';  Th_i_d=(18:0.5:57)'; [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5(Th_i_d,u10,windDir);  Nrcs_VV=Nrcs_VV(:); Nrcs_HH=Nrcs_HH(:); Nrcs_VH=NaN(size(Th_i_d));
                    case 'CMOD5N'; Th_i_d=(18:0.5:57)'; [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Cband_Cmod5N(Th_i_d,u10,windDir); Nrcs_VV=Nrcs_VV(:); Nrcs_HH=Nrcs_HH(:); Nrcs_VH=NaN(size(Th_i_d));
                    case 'XMOD1R'; Th_i_d=(20:0.5:60)'; [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Xband_Xmod1R(Th_i_d,u10,windDir); Nrcs_VV=Nrcs_VV(:); Nrcs_HH=Nrcs_HH(:); Nrcs_VH=NaN(size(Th_i_d));
                    case 'XMOD2N'; Th_i_d=(18:0.5:46)'; [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Xband_Xmod2N(Th_i_d,u10,windDir); Nrcs_VV=Nrcs_VV(:); Nrcs_HH=Nrcs_HH(:); Nrcs_VH=NaN(size(Th_i_d));
                    case {'NRL','TSC','GIT','HYBRID','RRE','SITTROP'}
                        c_ms=3e8; lambda_m=c_ms/(freq*1e9); seaState=max(0,min(7,round((u10/3.16)^1.25)));
                        switch model
                            case 'NRL';     if u10>13.2;u10=13.2;seaState=6;end; Chi_d=(0.1:0.5:60)';
                            case 'TSC';     if u10>11.4;u10=11.4;seaState=5;end; Chi_d=(0.1:0.5:89.9)';
                            case 'GIT';     u10=max(3.2,min(13.2,u10));seaState=max(1,min(6,round((u10/3.16)^1.25)));Chi_d=(0.1:0.5:9.9)';
                            case 'HYBRID';  if u10>11.4;u10=11.4;seaState=5;end;Chi_d=(0:0.5:30)';
                            case 'RRE';     u10=max(3.2,min(13.2,u10));seaState=max(1,min(6,round((u10/3.16)^1.25)));Chi_d=(0.1:0.5:9.9)';
                            case 'SITTROP'; if u10>14.9;u10=14.9;end;Chi_d=(0.2:0.1:9.8)';
                        end
                        Th_i_d=90-Chi_d; if strcmp(pol,'VV');polModel='V';else;polModel='H';end
                        switch model
                            case 'NRL';     Nrcs_dB_raw=f_Nrcs_3dMonoGrazing_NRL_2012(Chi_d,lambda_m,seaState,windDir,polModel,c_ms);
                            case 'TSC';     Nrcs_dB_raw=f_Nrcs_3dMonoGrazing_TSC(Chi_d,lambda_m,seaState,windDir,polModel);
                            case 'GIT';     Nrcs_dB_raw=f_Nrcs_3dMonoGrazing_GIT(Chi_d,lambda_m,seaState,windDir,polModel);
                            case 'HYBRID';  Nrcs_dB_raw=f_Nrcs_3dMonoGrazing_HYB2(Chi_d,lambda_m,seaState,windDir,polModel);
                            case 'RRE';     Nrcs_dB_raw=f_Nrcs_3dMonoGrazing_RRE(Chi_d,lambda_m,seaState,windDir,polModel);
                            case 'SITTROP'; Nrcs_dB_raw=f_Nrcs_3dMonoGrazing_SIT(Chi_d,lambda_m,seaState,windDir,polModel);
                        end
                        Nrcs_dB_raw=Nrcs_dB_raw(:); Nrcs_VV=10.^(Nrcs_dB_raw/10); Nrcs_HH=Nrcs_VV; Nrcs_VH=NaN(size(Th_i_d));
                    case {'TSM','GO1sh','SPM1'}
                        sst_C=15;sss_ppt=35;F_Hz=freq*1e9;fetch_m=app.FetchmEditField.Value;if fetch_m<=0;fetch_m=500000;end
                        k0SurKc=app.kokcEditField.Value;if k0SurKc<=0;k0SurKc=4;end
                        [er2,~,K_EM,Kc]=f_Sea_ErOmg(F_Hz,sst_C,sss_ppt,u10,fetch_m,k0SurKc);
                        switch model
                            case 'TSM'; Th_i_d=(0.1:0.5:80)'; [Nrcs_VV_raw,Nrcs_HH_raw,Nrcs_VH_raw,~,~,AddVV,AddHH]=f_Nrcs_3dMono_StatisticSea_TSM_Elfo_Gauss_Fetch_v2(Th_i_d,windDir,er2,u10,fetch_m,K_EM,Kc); Nrcs_VV=Nrcs_VV_raw(:)+AddVV(:);Nrcs_HH=Nrcs_HH_raw(:)+AddHH(:);Nrcs_VH=Nrcs_VH_raw(:);
                            case 'GO1sh'; Th_i_d=(0.1:0.5:50)'; [Nrcs_VV,Nrcs_HH,~,~,~]=f_Nrcs_3dMono_StatisticSea_GO1sh_Elfo_Gauss_Fetch_v1(Th_i_d,windDir,er2,u10,fetch_m,Kc); Nrcs_VV=Nrcs_VV(:);Nrcs_HH=Nrcs_HH(:);Nrcs_VH=NaN(size(Th_i_d));
                            case 'SPM1';  Th_i_d=(2:0.5:80)';   [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_StatisticSea_SPM1_Elfo_Gauss_Fetch_v1(Th_i_d,windDir,er2,u10,fetch_m,K_EM); Nrcs_VV=Nrcs_VV(:);Nrcs_HH=Nrcs_HH(:);Nrcs_VH=NaN(size(Th_i_d));
                        end
                    case 'Wentz84'; Th_i_d=(0:1:60)';   [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz84(Th_i_d,u10,windDir); Nrcs_VH=NaN(size(Th_i_d));
                    case 'Wentz99'; Th_i_d=(15:0.5:65)'; [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Kuband_Wentz99(Th_i_d,u10,windDir); Nrcs_VH=NaN(size(Th_i_d));
                    case 'Masuko Ka'; Th_i_d=(30:0.5:60)'; [u19,~,~,~]=f_Sea_WindSpeedHeightConversion_v2(u10,19.5,500000); [Nrcs_VV,Nrcs_HH]=f_Nrcs_3dMono_EmpExpSea_Kaband_Masuko(Th_i_d,u19,windDir); Nrcs_VH=NaN(size(Th_i_d));
                end
            catch ME; uialert(app.UIFigure,['Erreur: ' ME.message],'Erreur calcul','Icon','error'); return; end
            switch pol; case 'VV'; Nrcs_lin=Nrcs_VV; case 'HH'; Nrcs_lin=Nrcs_HH; case 'VH'; Nrcs_lin=Nrcs_VH; otherwise; Nrcs_lin=Nrcs_VV; end
            Nrcs_lin(Nrcs_lin<=0)=NaN; Nrcs_dB=10*log10(Nrcs_lin);
            entry.Th_i_d=Th_i_d; entry.Nrcs_dB=Nrcs_dB; entry.Nrcs_lin=Nrcs_lin; entry.model=model; entry.pol=pol; entry.u10=u10; entry.windDir=windDir; entry.freq=freq;
            entry.label=sprintf('%s | %s | u10=%.1f | φ=%.0f°',model,pol,u10,windDir);
            app.SessionData{end+1}=entry;
            if length(app.SessionData)>1; cla(app.UIAxes); end
            hold(app.UIAxes,'on');
            plot(app.UIAxes,Th_i_d,Nrcs_dB,'LineWidth',2,'DisplayName',entry.label);
            xlabel(app.UIAxes,'Angle d''incidence (deg)'); ylabel(app.UIAxes,'NRCS (dB)');
            title(app.UIAxes,sprintf('NRCS — %s — %s — %.2f GHz',model,pol,freq));
            grid(app.UIAxes,'on'); legend(app.UIAxes,'show','Location','northeast'); hold(app.UIAxes,'off');
            valid=~isnan(Nrcs_dB)&isfinite(Nrcs_dB);
            if sum(valid)<2; app.NRCS905dBfor300incidenceangleLabel.Text='Pas assez de points valides.'; return; end
            Th_valid=Th_i_d(valid); Nrcs_valid=Nrcs_dB(valid);
            if th_user>=min(Th_valid)&&th_user<=max(Th_valid)
                val_dB=interp1(Th_valid,Nrcs_valid,th_user,'linear');
                app.NRCS905dBfor300incidenceangleLabel.Text=sprintf('NRCS: %.2f dB  (θ=%.1f° — %s %s)',val_dB,th_user,model,pol);
            else
                app.NRCS905dBfor300incidenceangleLabel.Text=sprintf('Angle %.1f° hors plage [%.1f°–%.1f°]',th_user,min(Th_valid),max(Th_valid));
            end
        end

        % Button pushed function: OverlayButton
        function OverlayButtonPushed(app, event)
             if isempty(app.SessionData); uialert(app.UIFigure,'Aucun calcul en session.','Overlay','Icon','warning'); return; end
            lineStyles={'-','--',':','-.'}; lineWidths=[2,2,2.5,2.5]; markers={'none','none','none','o'};
            colors=lines(length(app.SessionData));
            cla(app.UIAxes); hold(app.UIAxes,'on'); app.UIAxes.ButtonDownFcn=@(s,e)app.clearTooltip(s,e);
            all_x_min=Inf;all_x_max=-Inf;all_y_min=Inf;all_y_max=-Inf;
            for k=1:length(app.SessionData)
                entry=app.SessionData{k}; ls=lineStyles{mod(k-1,4)+1}; lw=lineWidths(mod(k-1,4)+1); mrk=markers{mod(k-1,4)+1};
                plot(app.UIAxes,entry.Th_i_d,entry.Nrcs_dB,'LineStyle',ls,'LineWidth',lw,'Marker',mrk,'MarkerSize',4,'Color',colors(k,:),'DisplayName',entry.label,'Tag',num2str(k),'ButtonDownFcn',@(s,e)app.onCurveClick(s,e));
                valid=~isnan(entry.Nrcs_dB);
                if any(valid); all_x_min=min(all_x_min,min(entry.Th_i_d(valid)));all_x_max=max(all_x_max,max(entry.Th_i_d(valid)));all_y_min=min(all_y_min,min(entry.Nrcs_dB(valid)));all_y_max=max(all_y_max,max(entry.Nrcs_dB(valid))); end
            end
            if ~isinf(all_x_min); mx=(all_x_max-all_x_min)*0.05;my=(all_y_max-all_y_min)*0.1;xlim(app.UIAxes,[all_x_min-mx,all_x_max+mx]);ylim(app.UIAxes,[all_y_min-my,all_y_max+my]); end
            xlabel(app.UIAxes,'Incidence Angle (deg)'); ylabel(app.UIAxes,'NRCS (dB)');
            title(app.UIAxes,sprintf('NRCS Overlay (%d courbes)',length(app.SessionData)));
            grid(app.UIAxes,'on'); legend(app.UIAxes,'show','Location','northeast'); hold(app.UIAxes,'off');
      
        end

        % Button pushed function: ClearButton
        function ClearButtonPushed(app, event)
            cla(app.UIAxes); legend(app.UIAxes,'off');
            app.NRCS905dBfor300incidenceangleLabel.Text=''; app.SessionData={};
      
        end

        % Button pushed function: ExportButton
        function ExportButtonPushed(app, event)
             if isempty(app.UIAxes.Children); uialert(app.UIFigure,'Aucune courbe à exporter.','Export','Icon','warning'); return; end
            [file,path]=uiputfile({'*.png','Image PNG';'*.mat','Données MATLAB'},'Exporter');
            if ischar(file)
                fullpath=fullfile(path,file); [~,~,ext]=fileparts(file);
                if strcmp(ext,'.png'); exportgraphics(app.UIAxes,fullpath,'Resolution',150); uialert(app.UIFigure,'Graphe exporté en PNG.','Export OK');
                elseif strcmp(ext,'.mat')
                    lns=app.UIAxes.Children; data=struct();
                    for k=1:length(lns); if isa(lns(k),'matlab.graphics.chart.primitive.Line'); data(k).x=lns(k).XData;data(k).y=lns(k).YData;data(k).name=lns(k).DisplayName; end; end
                    save(fullpath,'data'); uialert(app.UIFigure,'Données exportées en .mat.','Export OK');
                end
            end
        end

       % Button pushed function: GenerateSurfaceButton
function GenerateSurfaceButtonPushed(app, event)
    u10 = app.Windspeedu10msEditField.Value; 
    phiw_d = app.WinddirectiondegEditField.Value;
    fetch_m = app.FetchmEditField_2.Value; 
    lx = app.LengthXmEditField.Value; 
    ly = app.LengthYmEditField.Value;
    freq = app.RadarfrequencyGHz130GHz2308cmEditField.Value; 
    nlb = app.SamplesperwavelengthEditField.Value;
    prec = 2 - app.UsesingleprecisionCheckBox.Value;
    
    if u10 < 1 || u10 > 10
        uialert(app.UIFigure, 'Wind Speed u10 doit être entre 1 et 10 m/s.', ...
            'Paramètre invalide', 'Icon', 'warning'); 
        return; 
    end
    if fetch_m <= 0; fetch_m = 500e3; end
    
    c_ms = 3e8; 
    lb0_m = c_ms / (freq * 1e9); 
    dxy_m = lb0_m / nlb;
    n_x_raw = round(lx / dxy_m / 2) * 2; 
    n_y_raw = round(ly / dxy_m / 2) * 2;
    
    if app.Roundtothenearestpowerof2CheckBox.Value
        n_x = 2^round(log2(max(1, n_x_raw)));
        n_y = 2^round(log2(max(1, n_y_raw)));
    else
        n_x = 2^nextpow2(n_x_raw);
        n_y = 2^nextpow2(n_y_raw);
    end
    
    d = uiprogressdlg(app.UIFigure, 'Title', 'Génération', ...
        'Message', 'Generation in progress...', 'Indeterminate', 'on'); 
    drawnow;
    
    vars_avant = whos; 
    ram_avant_W = sum([vars_avant.bytes]) / 1024^2;
    
    try
        tic; 
        [HH_XY, X, Y] = f_GeneSurfMer3D_Fetch_Elfo_v3(u10, phiw_d, lx, ly, n_x, n_y, 1, prec, fetch_m); 
        temps_gen = toc; 
        close(d);
    catch ME
        close(d); 
        uialert(app.UIFigure, ['Erreur : ' ME.message], 'Erreur génération', 'Icon', 'error'); 
        return; 
    end
    
    vars_apres = whos; 
    ram_apres_W = sum([vars_apres.bytes]) / 1024^2; 
    delta_RAM_MB = ram_apres_W - ram_avant_W;
    bytes_per_el = 8 - 4 * isa(HH_XY, 'single'); 
    mem_Mo = (numel(HH_XY) + numel(X) + numel(Y)) * bytes_per_el / 1e6;
    
    % Stats
    app.ZminLabel.Text = 'Zmin:'; 
    app.ZmaxLabel.Text = 'Zmax:'; 
    app.ZmeanLabel.Text = 'Zmean:'; 
    app.ZstdLabel.Text = 'Zstd:';
    app.Label.Text = sprintf('%.4f m', min(HH_XY(:))); 
    app.Label_7.Text = sprintf('%.4f m', mean(HH_XY(:)));
    app.Label_6.Text = sprintf('%.4f m', max(HH_XY(:))); 
    app.Label_8.Text = sprintf('%.4f m', std(HH_XY(:)));
    
    % ⭐ AFFICHAGE SURFACE - VERSION AMÉLIORÉE ⭐
    cla(app.UIAxes_2);
    
    % Afficher TOUS les points (pas de sous-échantillonnage)
    h = surf(app.UIAxes_2, Y, X, HH_XY);
    
    % Améliorer l'apparence
    shading(app.UIAxes_2, 'interp');  % Lissage
    colormap(app.UIAxes_2, 'jet');
    
    % ⭐ ACTIVER LA ROTATION SOURIS ⭐
    rotate3d(app.UIAxes_2, 'on');     % Active la rotation 3D
    
    % Vue initiale plus esthétique
    view(app.UIAxes_2, -45, 30);
    
    % Ajuster les proportions
    axis(app.UIAxes_2, 'tight');
    app.UIAxes_2.DataAspectRatio = [1 1 0.2];  % Z moins écrasé
    
    % Labels
    xlabel(app.UIAxes_2, 'Y (m)');
    ylabel(app.UIAxes_2, 'X (m)');
    zlabel(app.UIAxes_2, 'Z (m)');
    
    % Style
    app.UIAxes_2.Box = 'on';           % Boîte visible
    app.UIAxes_2.Color = [0.95 0.95 0.95];
    app.UIAxes_2.ZAxis.Visible = 'on'; % Afficher l'axe Z
    
    % Colorbar
    cb = colorbar(app.UIAxes_2);
    cb.Label.String = 'Height (m)';
    cb.FontSize = 9;
    
    % ⭐ ACTIVER LE CLIC SUR LA SURFACE ⭐
    h.HitTest = 'on';
    h.PickableParts = 'all';
    h.ButtonDownFcn = @(s, e) app.onSurfaceClick(s, e);
    app.UIAxes_2.HitTest = 'on';       % Important pour la rotation
    
    % Stocker les données
    app.LastSurface.HH_XY = HH_XY; 
    app.LastSurface.X = X; 
    app.LastSurface.Y = Y; 
    app.LastSurface.windSpeed = u10; 
    app.LastSurface.fetch_m = fetch_m; 
    app.LastSurface.freq_GHz = freq; 
    app.LastSurface.nx = n_x; 
    app.LastSurface.ny = n_y;
    
    uialert(app.UIFigure, ...
        sprintf('Surface %d×%d generated in %.2f s\nSize ≈ %.1f Mo\nRAM used ≈ %.1f MB', ...
        n_x, n_y, temps_gen, mem_Mo, delta_RAM_MB), ...
        'Generation completed', 'Icon', 'success');
    
    app.plotSpectra();
end

        % Button pushed function: ClearSurfaceButton
        function ClearSurfaceButtonPushed(app, event)
            cla(app.UIAxes_2); app.UIAxes5.Visible='off'; app.GridLayout5_2.RowHeight={'1x',0,130}; cla(app.UIAxes5);
            app.Label.Text='—'; app.Label_7.Text='—'; app.Label_6.Text='—'; app.Label_8.Text='—'; app.LastSurface=struct();
        end

        % Button pushed function: ExportSurfaceButton
        function ExportSurfaceButtonPushed(app, event)
            if ~isfield(app.LastSurface,'HH_XY'); uialert(app.UIFigure,'Aucune surface à exporter.','Export','Icon','warning'); return; end
            formats={'Export .mat file','Export .csv file','Export .png image','Export ALL (.mat + .csv + .png)'};
            [idx,ok]=listdlg('PromptString','Select export format:','SelectionMode','single','ListString',formats,'ListSize',[300 120],'Name','Export Sea Surface','OKString','OK','CancelString','Cancel');
            if ~ok; return; end; folder=uigetdir('','Choisir le dossier'); if folder==0; return; end
            HH_XY=app.LastSurface.HH_XY; X=app.LastSurface.X; Y=app.LastSurface.Y;
            switch idx
                case 1; save(fullfile(folder,'SeaSurface.mat'),'HH_XY','X','Y'); uialert(app.UIFigure,'Surface exportée','Export OK','Icon','success');
                case 2; writematrix(HH_XY,fullfile(folder,'SeaSurface.csv')); uialert(app.UIFigure,'Surface exportée','Export OK','Icon','success');
                case 3; exportgraphics(app.UIAxes_2,fullfile(folder,'SeaSurface.png'),'Resolution',150); uialert(app.UIFigure,'Image exportée','Export OK','Icon','success');
                case 4; save(fullfile(folder,'SeaSurface.mat'),'HH_XY','X','Y'); writematrix(HH_XY,fullfile(folder,'SeaSurface.csv')); exportgraphics(app.UIAxes_2,fullfile(folder,'SeaSurface.png'),'Resolution',150); uialert(app.UIFigure,'3 fichiers exportés','Export ALL OK','Icon','success');
            end
        end

        % Button pushed function: GenerateProfilesButton
        function GenerateProfilesButtonPushed(app, event)

 % ⭐ INITIALISER L'UI SI NÉCESSAIRE ⭐
    if ~app.isUIInitialized
        app.initializeUIDropdowns();
    end
    
    u10     = app.Windspeedu10msEditField_2.Value;
    fetch_m = app.FetchmEditField_3.Value;
    l_s     = app.LengthmEditField.Value;
    freq    = app.RadarfrequencyGHz130GHz2308cmEditField_2.Value;
    nlb     = app.SamplesperwavelengthEditField_2.Value;  % ✅ Confirmé : _2
    Nprof   = app.NprofilesEditField.Value;
    prec    = 2;

    if u10 <= 0 || l_s <= 0 || fetch_m <= 0 || freq <= 0 || nlb < 1 || Nprof < 1
        uialert(app.UIFigure, ...
            'Paramètres invalides.', 'Paramètre invalide', 'Icon', 'warning');
        return;
    end

    c_ms     = 3e8;
    lambda_m = c_ms / (freq * 1e9);
    n_s      = round(l_s / lambda_m) * nlb;
    n_s      = 2^nextpow2(n_s);

    d = uiprogressdlg(app.UIFigure, ...
        'Title',         'Génération des profils', ...
        'Message',       sprintf('Generating %d profiles (n_s = %d)...', Nprof, n_s), ...
        'Indeterminate', 'on');
    drawnow;

    % RAM avant calcul
    vars_avant  = whos;
    ram_avant_W = sum([vars_avant.bytes]) / 1024^2;

    % Pré-allocation
    H_all = cell(1, Nprof);
    X_all = cell(1, Nprof);

    try
        tic;
        parfor k = 1:Nprof
            [H_k, X_h_k, ~, ~, ~, ~, ~] = f_GeneSurfMer2D_ElfoGauss_Fetch_v2b( ...
                u10, l_s, n_s, double(k), fetch_m, prec);
            H_all{k} = H_k(:);
            X_all{k} = X_h_k(:);
        end
        temps_gen = toc;
    catch ME
        close(d);
        uialert(app.UIFigure, ['Erreur : ' ME.message], ...
            'Erreur génération', 'Icon', 'error');
        return;
    end
    close(d);

    % Stocker dans app.ProfilesData
    app.ProfilesData = cell(1, Nprof);
    for k = 1:Nprof
        app.ProfilesData{k}.H = H_all{k};
        app.ProfilesData{k}.X = X_all{k};
    end

    % RAM après calcul
    vars_apres   = whos;
    ram_apres_W  = sum([vars_apres.bytes]) / 1024^2;
    delta_RAM_MB = ram_apres_W - ram_avant_W;

    % Taille mémoire des profils
    mem_Mo = 0;
    for k = 1:Nprof
        mem_Mo = mem_Mo + (numel(app.ProfilesData{k}.H) + numel(app.ProfilesData{k}.X)) * 8 / 1e6;
    end

    % Reset stats avec les BONS NOMS
    % Label_2 = Zmin, Label_3 = Zmax, Label_4 = Zmean, Label_5 = Zstd
    app.Label_2.Text = '—';
    app.Label_3.Text = '—';
    app.Label_4.Text = '—';
    app.Label_5.Text = '—';

    % Remplir le dropdown Selected Profile
    items = arrayfun(@(k) sprintf('P%d', k), 1:Nprof, 'UniformOutput', false);
    app.ProfileDropDown.Items = [{'— Select a profile —'}, items];
    app.ProfileDropDown.Value = '— Select a profile —';

    % Initialiser la plage par défaut 1-5
    iEnd = min(5, Nprof);
    app.LastSurface.ProfileRange = [1, iEnd];
    app.fillRangeDropDowns(Nprof, 1, iEnd);

    % Afficher les profils
    app.drawProfiles(-1);

    % Synchroniser les paramètres vers l'onglet 4
    app.Windspeedu10msEditField_3.Value = u10;
    app.FetchmEditField_4.Value = fetch_m;
    app.LengthmEditField_2.Value = l_s;
    app.RadarfrequencyGHz130GHz2308cmEditField_3.Value = freq;
    app.SamplesperwavelengthEditField_3.Value = nlb;
    app.NumberofsamplesEditField.Value = n_s;
    app.updateFreqLabelTab4();

    % Remplir le dropdown de sélection de profil (onglet 4)
    items4 = arrayfun(@(k) sprintf('P%d', k), 1:Nprof, 'UniformOutput', false);
    app.SelectprofileDropDown.Items = items4;
    app.SelectprofileDropDown.Value = items4{1};
    app.onProfileSelectorChanged();

    app.plotSpectraProfile();

    % Message avec performances
    uialert(app.UIFigure, ...
        sprintf(['%d profiles generated in %.2f s (parallel)\n' ...
                 'n_s = %d samples per profile\n' ...
                 'Size ≈ %.2f Mo\n' ...
                 'RAM used ≈ %.1f MB'], ...
                 Nprof, temps_gen, n_s, mem_Mo, delta_RAM_MB), ...
        'Generation completed', 'Icon', 'success');

        end

        % Button pushed function: ClearSurfaceButton_2
        function ClearSurfaceButton_2Pushed(app, event)
             % Vérifier si l'UI est initialisée
    if ~app.isUIInitialized
        return;
    end
    
    app.ProfilesData = {};
    cla(app.UIAxes_3);
    title(app.UIAxes_3, '');
    legend(app.UIAxes_3, 'off');
    
    if ~isempty(app.RangeStartDropDown) && isvalid(app.RangeStartDropDown)
        app.RangeStartDropDown.ValueChangedFcn = [];
        app.RangeEndDropDown.ValueChangedFcn = [];
        app.RangeStartDropDown.Items = {'—'};
        app.RangeEndDropDown.Items = {'—'};
        app.RangeStartDropDown.Value = '—';
        app.RangeEndDropDown.Value = '—';
        app.RangeStartDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();
        app.RangeEndDropDown.ValueChangedFcn = @(~,~) app.onRangeDropDownChanged();
    end
    
    if ~isempty(app.ProfileDropDown) && isvalid(app.ProfileDropDown)
        app.ProfileDropDown.Items = {'— Generate first —'};
        app.ProfileDropDown.Value = '— Generate first —';
    end
    
    app.Label_2.Text = '—';
    app.Label_4.Text = '—';
    app.Label_3.Text = '—';
    app.Label_5.Text = '—';

        end

        % Button pushed function: ExportSurfaceButton_2
        function ExportSurfaceButton_2Pushed(app, event)
             if isempty(app.ProfilesData); uialert(app.UIFigure,'No profiles to export.','Export','Icon','warning'); return; end
            [file,path]=uiputfile({'*.csv','CSV file (*.csv)';'*.mat','MATLAB file (*.mat)';'*.png','PNG image (*.png)'},'Export profiles');
            if isequal(file,0); return; end; [~,~,ext]=fileparts(file); fullpath=fullfile(path,file);
            switch lower(ext)
                case '.csv'
                    fid=fopen(fullpath,'w'); fprintf(fid,'Profile,X_m,Z_m\n');
                    for k=1:numel(app.ProfilesData); p=app.ProfilesData{k}; for i=1:numel(p.H); fprintf(fid,'P%d,%.6f,%.6f\n',k,p.X(i),p.H(i)); end; end
                    fclose(fid); uialert(app.UIFigure,sprintf('%d profiles exported to:\n%s',numel(app.ProfilesData),fullpath),'Export OK','Icon','success');
                case '.mat'; ProfilesData=app.ProfilesData; save(fullpath,'ProfilesData'); uialert(app.UIFigure,'Exported','Export OK','Icon','success');
                case '.png'; exportgraphics(app.UIAxes_3,fullpath,'Resolution',150); uialert(app.UIFigure,'Graph exported','Export OK','Icon','success');
            end
        end


         % Button pushed function: CalculateButton_2
       function CalculateButton_2Pushed(app, event)
    if isempty(app.ProfilesData)
        uialert(app.UIFigure, ...
            'No profiles loaded. Generate profiles in Tab 3 first.', ...
            'No profile', 'Icon', 'warning');
        return;
    end

    u10     = app.Windspeedu10msEditField_3.Value;
    freq    = app.RadarfrequencyGHz130GHz2308cmEditField_3.Value;
    fetch_m = app.FetchmEditField_4.Value;
    th_i_d  = app.IncidenceangledegEditField_2.Value;
    Polar   = app.PolarizationDropDown_2.Value;

    NprofTotal = numel(app.ProfilesData);
    n_s        = length(app.ProfilesData{1}.X);
    
    selectedProfile = app.SelectprofileDropDown.Value;
    selectedIdx = str2double(selectedProfile(2:end));
    if isnan(selectedIdx); selectedIdx = 1; end
    
    mem_GB_one = (n_s^2 * 16) / 1e9;
    if mem_GB_one > 2.0
        uialert(app.UIFigure, sprintf([ ...
            'Profile too large!\nn_s = %d → %.1f GB/profile\n' ...
            'Reduce Length or Samples/wavelength'], n_s, mem_GB_one), ...
            'Profile too large', 'Icon', 'warning');
        return;
    end

    % Popup compact
    choiceList = { ...
        sprintf('All (%d)', NprofTotal), ...
        sprintf('Single (%s)', selectedProfile), ...
        'Range (max 5)', ...
        'Custom...' };

    [sel, ok] = listdlg( ...
        'PromptString', sprintf('n_s=%d | %.2f GB/prof', n_s, mem_GB_one), ...
        'ListString', choiceList, ...
        'SelectionMode', 'single', ...
        'ListSize', [220 120], ...
        'Name', 'NRCS');
    if ~ok; return; end

    profilesToCompute = [];
    
    switch sel
        case 1  % All
            profilesToCompute = 1:NprofTotal;
        case 2  % Single
            profilesToCompute = selectedIdx;
        case 3  % Range
            prompt = {'Start profile:', 'End profile:'};
            dlgtitle = 'Profile Range (max 5)';
            dims = [1 35];
            def = {'1', num2str(min(5, NprofTotal))};
            answer = inputdlg(prompt, dlgtitle, dims, def);
            if isempty(answer); return; end
            
            iStart = max(1, round(str2double(answer{1})));
            iEnd = min(NprofTotal, round(str2double(answer{2})));
            
            % Corriger si inversé
            if iStart > iEnd
                [iStart, iEnd] = deal(iEnd, iStart);
            end
            
            currentCount = iEnd - iStart + 1;
            
            % ⭐ AJUSTEMENT INTELLIGENT POUR AVOIR EXACTEMENT 5 PROFILS ⭐
            if currentCount > 5
                % Calculer le centre exact de la plage demandée
                center = (iStart + iEnd) / 2;
                
                % Plage centrée sur le milieu
                newStart = floor(center) - 2;
                newEnd = floor(center) + 2;
                
                % Si le nombre est impair, ajuster pour bien centrer
                if mod(floor(center), 2) == 0
                    newStart = floor(center) - 2;
                    newEnd = floor(center) + 3;
                    % Re-ajuster si nécessaire
                    if (newEnd - newStart + 1) > 5
                        newEnd = newEnd - 1;
                    end
                end
                
                % Ajuster les bornes si elles dépassent
                if newStart < 1
                    newStart = 1;
                    newEnd = 5;
                end
                if newEnd > NprofTotal
                    newEnd = NprofTotal;
                    newStart = max(1, NprofTotal - 4);
                end
                
                % Vérifier qu'on a bien 5 profils, sinon ajuster
                if (newEnd - newStart + 1) < 5 && NprofTotal >= 5
                    if newStart > 1 && newEnd < NprofTotal
                        newStart = max(1, newStart - (5 - (newEnd - newStart + 1)));
                    elseif newStart == 1
                        newEnd = min(NprofTotal, newEnd + (5 - (newEnd - newStart + 1)));
                    elseif newEnd == NprofTotal
                        newStart = max(1, newStart - (5 - (newEnd - newStart + 1)));
                    end
                end
                
                iStart = newStart;
                iEnd = newEnd;
                
                uialert(app.UIFigure, ...
                    sprintf('Adjusted to 5 profiles: P%d to P%d', iStart, iEnd), ...
                    'Range adjusted', 'Icon', 'info');
            end
            
            profilesToCompute = iStart:iEnd;
        case 4  % Custom
            answer = inputdlg('Number of profiles:', 'Custom', [1 30], {'5'});
            if isempty(answer); return; end
            N = min(NprofTotal, max(1, round(str2double(answer{1}))));
            profilesToCompute = 1:N;
    end
    
    NprofActual = length(profilesToCompute);
    if NprofActual == 0; return; end

    % Constantes
    c_ms    = 3e8;
    lb0_m   = c_ms / (freq * 1e9);
    k0_EM   = 2*pi / lb0_m;
    eta_inc = 119.9169832 * pi;
    k0_sea  = 9.81 / u10^2;
    Th_s_r  = (-89:1:89) * pi/180;

    % Préparer les données
    ProfileX = cell(1, NprofActual);
    ProfileH = cell(1, NprofActual);
    ProfileIndices = profilesToCompute;
    for j = 1:NprofActual
        k = profilesToCompute(j);
        ProfileX{j} = app.ProfilesData{k}.X(:)';
        ProfileH{j} = app.ProfilesData{k}.H(:)';
    end

    d = uiprogressdlg(app.UIFigure, ...
        'Title', 'NRCS Calculation', ...
        'Message', sprintf('Computing %d profiles...', NprofActual), ...
        'Indeterminate', 'on');
    drawnow;

    NRCS_all = zeros(NprofActual, length(Th_s_r));
    calcOK   = false(1, NprofActual);

    try
        tic;
        for j = 1:NprofActual
            X_h = ProfileX{j};
            H   = ProfileH{j};
            k   = ProfileIndices(j);
            try
                g_thorsos = (X_h(end) - X_h(1)) / 6;
                Dx    = gradient(X_h);
                DerZ  = gradient(H) ./ Dx;
                Der2Z = gradient(DerZ) ./ Dx;
                V     = ones(size(X_h));

                [Psi_inc, ~] = F_IIncidenteWave_Thorsos(th_i_d, g_thorsos, k0_EM, X_h, H);
                p_inc_num = trapz(X_h, abs(Psi_inc).^2 / (2*eta_inc));

                ZZ = F_IImpedanceMatrices(X_h, H, Dx, DerZ, Der2Z, V, k0_EM, Polar);
                Current = linsolve(ZZ, Psi_inc.');
                Current = Current.';

                if strcmp(Polar, 'TE')
                    D_Psi = Current; Psi_s = zeros(size(X_h));
                else
                    Psi_s = Current; D_Psi = zeros(size(X_h));
                end

                Psi_sca = F_IFarField(X_h, H, Dx, DerZ, V, k0_EM, Psi_s, D_Psi, Th_s_r);
                coef = eta_inc / (p_inc_num * 16 * pi * k0_sea);
                Nrcs = coef * abs(Psi_sca).^2;
                NRCS_all(j, :) = 10 * log10(Nrcs + eps);
                calcOK(j) = true;

            catch ME_k
                NRCS_all(j, :) = NaN;
                fprintf('Error P%d: %s\n', k, ME_k.message);
            end
        end
        temps_calc = toc;
        close(d);
    catch ME
        close(d);
        uialert(app.UIFigure, ['Error: ' ME.message], 'Error', 'Icon', 'error');
        return;
    end

    % Affichage
    Th_s_d = Th_s_r * 180/pi;
    th_retro = -th_i_d;
    [~, i_r] = min(abs(Th_s_d - th_retro));
    if numel(i_r) > 1; i_r = i_r(1); end

    cla(app.NRCSAxes);
    hold(app.NRCSAxes, 'on');
    colors = lines(NprofActual);

    for j = 1:NprofActual
        if calcOK(j)
            plot(app.NRCSAxes, Th_s_d, NRCS_all(j,:), ...
                'LineWidth', 1.2, 'Color', colors(j,:), ...
                'DisplayName', sprintf('P%d', ProfileIndices(j)));
        end
    end

    nOK = sum(calcOK);
    if nOK > 1
        NRCS_mean = mean(NRCS_all(calcOK, :), 1);
        plot(app.NRCSAxes, Th_s_d, NRCS_mean, ...
            'LineWidth', 2.5, 'Color', 'k', 'LineStyle', '--', ...
            'DisplayName', sprintf('Mean (%d)', nOK));
        retro_mean = NRCS_mean(i_r);
    elseif nOK == 1
        retro_mean = NRCS_all(find(calcOK,1), i_r);
    else
        retro_mean = NaN;
    end

    if ~isnan(retro_mean)
        retro_str = sprintf('%.1f dB', retro_mean);
        plot(app.NRCSAxes, th_retro, retro_mean, 'kv', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
        text(app.NRCSAxes, th_retro+2, retro_mean, retro_str, 'FontSize', 8);
    else
        retro_str = 'N/A';
    end

    hold(app.NRCSAxes, 'off');
    grid(app.NRCSAxes, 'on');
    xlabel(app.NRCSAxes, '\theta_{sca} (deg)');
    ylabel(app.NRCSAxes, 'NRCS (dB)');
    title(app.NRCSAxes, sprintf('NRCS — %s — θ_{inc}=%d° — %.2f GHz', Polar, th_i_d, freq));
    xlim(app.NRCSAxes, [-90 90]);
    legend(app.NRCSAxes, 'Location', 'northeast', 'FontSize', 8);

    uialert(app.UIFigure, sprintf('OK: %d/%d profiles\nθ=%d° backscatter: %s', ...
        nOK, NprofActual, th_i_d, retro_str), 'NRCS OK', 'Icon', 'success');
end
        % Button pushed function: ClearButton_2
        function ClearButton_2Pushed(app, event)
             cla(app.UIAxes_4);
    if isprop(app, 'NRCSAxes') && ~isempty(app.NRCSAxes)
        cla(app.NRCSAxes);
    end
    app.SelectprofileDropDown.Items = {'— Generate profiles first —'};
    app.SelectprofileDropDown.Value = '— Generate profiles first —';
    app.Windspeedu10msEditField_3.Value = 0;
    app.FetchmEditField_4.Value = 0;
    app.LengthmEditField_2.Value = 0;
    app.RadarfrequencyGHz130GHz2308cmEditField_3.Value = 0;
    app.SamplesperwavelengthEditField_3.Value = 0;
    app.NumberofsamplesEditField.Value = 0;
        end

        % Button pushed function: ExportButton_2
        function ExportButton_2Pushed(app, event)
             % Export NRCS results
            if isempty(app.NRCSAxes.Children); uialert(app.UIFigure,'No NRCS to export.','Export','Icon','warning'); return; end
            [file,path]=uiputfile({'*.png','PNG image (*.png)';'*.mat','MATLAB file (*.mat)'},'Export NRCS');
            if isequal(file,0); return; end; [~,~,ext]=fileparts(file); fullpath=fullfile(path,file);
            switch lower(ext)
                case '.png'; exportgraphics(app.NRCSAxes,fullpath,'Resolution',150); uialert(app.UIFigure,'NRCS exported','Export OK','Icon','success');
                case '.mat'; ax=app.NRCSAxes; lns=ax.Children; data=struct();
                    for k=1:length(lns)
                        if isa(lns(k),'matlab.graphics.chart.primitive.Line')
                            data(k).x=lns(k).XData;
                            data(k).y=lns(k).YData;
                            data(k).name=lns(k).DisplayName;
                        end
                    end
                    save(fullpath,'data'); 
                    uialert(app.UIFigure,'Data exported','Export OK','Icon','success');
            end
     
        end

        % Value changed function: FrequencybandDropDown
       function FrequencybandDropDownValueChanged(app, event)
    band = app.FrequencybandDropDown.Value;
    switch band
        case 'UHF: 0.3-1 GHz'
            app.ModelDropDown.Items = {'NRL','TSC','HYBRID','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'TSM';
            app.FrequencyGHzEditField.Value = 0.65;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'L-band: 1-2 GHz'
            app.ModelDropDown.Items = {'Isoguchi','Meissner','NRL','TSC','HYBRID','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'Isoguchi';
            app.FrequencyGHzEditField.Value = 1.5;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'S-band: 2-4 GHz'
            app.ModelDropDown.Items = {'NRL','TSC','HYBRID','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'TSM';
            app.FrequencyGHzEditField.Value = 3.0;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'C-band: 4-8 GHz'
            app.ModelDropDown.Items = {'Quilfen','CMOD2-I3','CMOD5','CMOD5N','NRL','TSC','HYBRID','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'CMOD5N';
            app.FrequencyGHzEditField.Value = 6.0;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'X-band: 8-12 GHz'
            app.ModelDropDown.Items = {'XMOD1R','XMOD2N','Masuko X','NRL','TSC','GIT','HYBRID','RRE','SITTROP','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'XMOD1R';
            app.FrequencyGHzEditField.Value = 10.0;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'Ku-band: 12-18 GHz'
            app.ModelDropDown.Items = {'Wentz84','Wentz99','NRL','TSC','HYBRID','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'Wentz84';
            app.FrequencyGHzEditField.Value = 15.0;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'K-band: 18-27 GHz'
            app.ModelDropDown.Items = {'NRL','TSC','HYBRID','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'TSM';
            app.FrequencyGHzEditField.Value = 22.5;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'Ka-band: 27-40 GHz'
            app.ModelDropDown.Items = {'Masuko Ka','NRL','TSC','HYBRID','TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'Masuko Ka';
            app.FrequencyGHzEditField.Value = 33.5;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'V-band: 40-75 GHz'
            app.ModelDropDown.Items = {'TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'TSM';
            app.FrequencyGHzEditField.Value = 57.5;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
            
        case 'W-band: 75-110 GHz'
            app.ModelDropDown.Items = {'TSM','GO1sh','SPM1'};
            app.ModelDropDown.Value = 'TSM';
            app.FrequencyGHzEditField.Value = 92.5;
            app.Windspeedu10mSEditField.Value = 8;
            app.FetchmEditField.Value = 500000;
            app.kokcEditField.Value = 4;
            app.IncidenceangledegEditField.Value = 30;
            app.AnglerelativetowinddirectiondegEditField.Value = 0;
    end
    ModelDropDownValueChanged(app, []);
end

        % Value changed function: ModelDropDown
       function ModelDropDownValueChanged(app, event)
    model = app.ModelDropDown.Value;
    switch model
        case 'Isoguchi'
            app.PolarizationDropDown.Items = {'HH'};
            app.PolarizationDropDown.Value = 'HH';
        case {'Meissner','TSM'}
            app.PolarizationDropDown.Items = {'VV','HH','VH'};
            app.PolarizationDropDown.Value = 'VV';
        case {'Quilfen','CMOD2-I3','CMOD5','CMOD5N','XMOD1R','XMOD2N'}
            app.PolarizationDropDown.Items = {'VV'};
            app.PolarizationDropDown.Value = 'VV';
        otherwise
            app.PolarizationDropDown.Items = {'VV','HH'};
            app.PolarizationDropDown.Value = 'VV';
    end
    
    % Gérer Fetch et kokc
    if ismember(model, {'TSM','GO1sh','SPM1'})
        app.FetchmEditField.Enable = 'on';
        app.kokcEditField.Enable = 'on';
        if strcmp(model, 'TSM')
            app.kokcEditField.Value = 4;
        elseif strcmp(model, 'GO1sh')
            app.kokcEditField.Value = 3;
        end
    else
        app.FetchmEditField.Enable = 'off';
        app.kokcEditField.Enable = 'off';
    end
       end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 876 703];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [21 10 795 664];

            % Create NRCSSimulationTab
            app.NRCSSimulationTab = uitab(app.TabGroup);
            app.NRCSSimulationTab.Title = 'NRCS Simulation';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.NRCSSimulationTab);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {50, '1x', 50};
            app.GridLayout.RowSpacing = 4;
            app.GridLayout.Padding = [8 0 10 10];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GridLayout);
            app.GridLayout2.ColumnWidth = {'1x', 90, 90};
            app.GridLayout2.RowHeight = {'1x'};
            app.GridLayout2.ColumnSpacing = 8;
            app.GridLayout2.Padding = [5 5 10 10];
            app.GridLayout2.Layout.Row = 1;
            app.GridLayout2.Layout.Column = 1;

            % Create SeaSurfaceRadarSimulatorLabel
            app.SeaSurfaceRadarSimulatorLabel = uilabel(app.GridLayout2);
            app.SeaSurfaceRadarSimulatorLabel.FontSize = 18;
            app.SeaSurfaceRadarSimulatorLabel.FontWeight = 'bold';
            app.SeaSurfaceRadarSimulatorLabel.Layout.Row = 1;
            app.SeaSurfaceRadarSimulatorLabel.Layout.Column = 1;
            app.SeaSurfaceRadarSimulatorLabel.Text = 'Sea Surface Radar Simulator';

            % Create Image
            app.Image = uiimage(app.GridLayout2);
            app.Image.Layout.Row = 1;
            app.Image.Layout.Column = 2;
            app.Image.VerticalAlignment = 'top';
            app.Image.ImageSource = 'logo_icam.png';

            % Create Image2
            app.Image2 = uiimage(app.GridLayout2);
            app.Image2.Layout.Row = 1;
            app.Image2.Layout.Column = 3;
            app.Image2.ImageSource = 'logo_ietr.png';

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.GridLayout);
            app.GridLayout3.RowHeight = {'1x'};
            app.GridLayout3.Padding = [0 0 0 0];
            app.GridLayout3.Layout.Row = 2;
            app.GridLayout3.Layout.Column = 1;

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.GridLayout3);
            app.GridLayout4.RowHeight = {28, 28, 28, 28, 28, 28, 28, 28, 28, 28};
            app.GridLayout4.Layout.Row = 1;
            app.GridLayout4.Layout.Column = 1;

            % Create InputparametersLabel
            app.InputparametersLabel = uilabel(app.GridLayout4);
            app.InputparametersLabel.FontSize = 14;
            app.InputparametersLabel.FontWeight = 'bold';
            app.InputparametersLabel.Layout.Row = 1;
            app.InputparametersLabel.Layout.Column = [1 2];
            app.InputparametersLabel.Text = 'Input parameters';

            % Create IncidenceangledegEditFieldLabel
            app.IncidenceangledegEditFieldLabel = uilabel(app.GridLayout4);
            app.IncidenceangledegEditFieldLabel.HorizontalAlignment = 'center';
            app.IncidenceangledegEditFieldLabel.Layout.Row = 4;
            app.IncidenceangledegEditFieldLabel.Layout.Column = 1;
            app.IncidenceangledegEditFieldLabel.Text = 'Incidence angle (deg):';

            % Create IncidenceangledegEditField
            app.IncidenceangledegEditField = uieditfield(app.GridLayout4, 'numeric');
            app.IncidenceangledegEditField.HorizontalAlignment = 'left';
            app.IncidenceangledegEditField.Layout.Row = 4;
            app.IncidenceangledegEditField.Layout.Column = 2;

            % Create FrequencybandDropDownLabel
            app.FrequencybandDropDownLabel = uilabel(app.GridLayout4);
            app.FrequencybandDropDownLabel.HorizontalAlignment = 'center';
            app.FrequencybandDropDownLabel.Layout.Row = 2;
            app.FrequencybandDropDownLabel.Layout.Column = 1;
            app.FrequencybandDropDownLabel.Text = 'Frequency band:';

            % Create FrequencybandDropDown
            app.FrequencybandDropDown = uidropdown(app.GridLayout4);
            app.FrequencybandDropDown.Items = {'UHF: 0.3-1 GHz', 'L-band: 1-2 GHz', 'S-band: 2-4 GHz', 'C-band: 4-8 GHz', 'X-band: 8-12 GHz', 'Ku-band: 12-18 GHz', 'K-band: 18-27 GHz', 'Ka-band: 27-40 GHz', 'V-band: 40-75 GHz', 'W-band: 75-110 GHz'};
            app.FrequencybandDropDown.ValueChangedFcn = createCallbackFcn(app, @FrequencybandDropDownValueChanged, true);
            app.FrequencybandDropDown.Layout.Row = 2;
            app.FrequencybandDropDown.Layout.Column = 2;
            app.FrequencybandDropDown.Value = 'UHF: 0.3-1 GHz';

            % Create ModelDropDownLabel
            app.ModelDropDownLabel = uilabel(app.GridLayout4);
            app.ModelDropDownLabel.HorizontalAlignment = 'center';
            app.ModelDropDownLabel.Layout.Row = 5;
            app.ModelDropDownLabel.Layout.Column = 1;
            app.ModelDropDownLabel.Text = 'Model:';

            % Create ModelDropDown
            app.ModelDropDown = uidropdown(app.GridLayout4);
            app.ModelDropDown.Items = {'TSM', 'TSC', 'HYBRID', 'NRL', 'GO1sh', 'SPM1'};
            app.ModelDropDown.ValueChangedFcn = createCallbackFcn(app, @ModelDropDownValueChanged, true);
            app.ModelDropDown.Layout.Row = 5;
            app.ModelDropDown.Layout.Column = 2;
            app.ModelDropDown.Value = 'TSM';

            % Create PolarizationDropDownLabel
            app.PolarizationDropDownLabel = uilabel(app.GridLayout4);
            app.PolarizationDropDownLabel.HorizontalAlignment = 'center';
            app.PolarizationDropDownLabel.Layout.Row = 6;
            app.PolarizationDropDownLabel.Layout.Column = 1;
            app.PolarizationDropDownLabel.Text = 'Polarization:';

            % Create PolarizationDropDown
            app.PolarizationDropDown = uidropdown(app.GridLayout4);
            app.PolarizationDropDown.Items = {'VV', 'HH', 'VH'};
            app.PolarizationDropDown.Layout.Row = 6;
            app.PolarizationDropDown.Layout.Column = 2;
            app.PolarizationDropDown.Value = 'VV';

            % Create Windspeedu10mSEditFieldLabel
            app.Windspeedu10mSEditFieldLabel = uilabel(app.GridLayout4);
            app.Windspeedu10mSEditFieldLabel.HorizontalAlignment = 'center';
            app.Windspeedu10mSEditFieldLabel.Layout.Row = 7;
            app.Windspeedu10mSEditFieldLabel.Layout.Column = 1;
            app.Windspeedu10mSEditFieldLabel.Text = 'Wind speed u10 (m/S);';

            % Create Windspeedu10mSEditField
            app.Windspeedu10mSEditField = uieditfield(app.GridLayout4, 'numeric');
            app.Windspeedu10mSEditField.HorizontalAlignment = 'left';
            app.Windspeedu10mSEditField.Layout.Row = 7;
            app.Windspeedu10mSEditField.Layout.Column = 2;

            % Create AnglerelativetowinddirectiondegEditFieldLabel
            app.AnglerelativetowinddirectiondegEditFieldLabel = uilabel(app.GridLayout4);
            app.AnglerelativetowinddirectiondegEditFieldLabel.HorizontalAlignment = 'right';
            app.AnglerelativetowinddirectiondegEditFieldLabel.Layout.Row = 8;
            app.AnglerelativetowinddirectiondegEditFieldLabel.Layout.Column = 1;
            app.AnglerelativetowinddirectiondegEditFieldLabel.Text = 'Angle relative to wind direction (deg):';

            % Create AnglerelativetowinddirectiondegEditField
            app.AnglerelativetowinddirectiondegEditField = uieditfield(app.GridLayout4, 'numeric');
            app.AnglerelativetowinddirectiondegEditField.HorizontalAlignment = 'left';
            app.AnglerelativetowinddirectiondegEditField.Layout.Row = 8;
            app.AnglerelativetowinddirectiondegEditField.Layout.Column = 2;

            % Create FetchmEditFieldLabel
            app.FetchmEditFieldLabel = uilabel(app.GridLayout4);
            app.FetchmEditFieldLabel.HorizontalAlignment = 'center';
            app.FetchmEditFieldLabel.Layout.Row = 9;
            app.FetchmEditFieldLabel.Layout.Column = 1;
            app.FetchmEditFieldLabel.Text = 'Fetch (m):';

            % Create FetchmEditField
            app.FetchmEditField = uieditfield(app.GridLayout4, 'numeric');
            app.FetchmEditField.HorizontalAlignment = 'left';
            app.FetchmEditField.Layout.Row = 9;
            app.FetchmEditField.Layout.Column = 2;

            % Create kokcEditFieldLabel
            app.kokcEditFieldLabel = uilabel(app.GridLayout4);
            app.kokcEditFieldLabel.HorizontalAlignment = 'center';
            app.kokcEditFieldLabel.Layout.Row = 10;
            app.kokcEditFieldLabel.Layout.Column = 1;
            app.kokcEditFieldLabel.Text = 'ko/kc:';

            % Create kokcEditField
            app.kokcEditField = uieditfield(app.GridLayout4, 'numeric');
            app.kokcEditField.HorizontalAlignment = 'left';
            app.kokcEditField.Layout.Row = 10;
            app.kokcEditField.Layout.Column = 2;

            % Create FrequencyGHzEditFieldLabel
            app.FrequencyGHzEditFieldLabel = uilabel(app.GridLayout4);
            app.FrequencyGHzEditFieldLabel.HorizontalAlignment = 'center';
            app.FrequencyGHzEditFieldLabel.Layout.Row = 3;
            app.FrequencyGHzEditFieldLabel.Layout.Column = 1;
            app.FrequencyGHzEditFieldLabel.Text = 'Frequency (GHz):';

            % Create FrequencyGHzEditField
            app.FrequencyGHzEditField = uieditfield(app.GridLayout4, 'numeric');
            app.FrequencyGHzEditField.HorizontalAlignment = 'left';
            app.FrequencyGHzEditField.Layout.Row = 3;
            app.FrequencyGHzEditField.Layout.Column = 2;

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.GridLayout3);
            app.GridLayout5.ColumnWidth = {'1x'};
            app.GridLayout5.RowHeight = {'1x', 100};
            app.GridLayout5.Layout.Row = 1;
            app.GridLayout5.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout5);
            title(app.UIAxes, 'NRCS curves')
            xlabel(app.UIAxes, 'Incidence angle (deg)')
            ylabel(app.UIAxes, 'NRCS (dB)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Layout.Row = 1;
            app.UIAxes.Layout.Column = 1;

            % Create ResultsPanel
            app.ResultsPanel = uipanel(app.GridLayout5);
            app.ResultsPanel.TitlePosition = 'centertop';
            app.ResultsPanel.Title = 'Results';
            app.ResultsPanel.Layout.Row = 2;
            app.ResultsPanel.Layout.Column = 1;
            app.ResultsPanel.FontWeight = 'bold';

            % Create NRCS905dBfor300incidenceangleLabel
            app.NRCS905dBfor300incidenceangleLabel = uilabel(app.ResultsPanel);
            app.NRCS905dBfor300incidenceangleLabel.Position = [61 35 228 22];
            app.NRCS905dBfor300incidenceangleLabel.Text = 'NRCS:-9.05 dB (for 30.0 incidence angle)';

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.GridLayout);
            app.GridLayout6.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout6.RowHeight = {'1x'};
            app.GridLayout6.Layout.Row = 3;
            app.GridLayout6.Layout.Column = 1;

            % Create CalculateButton
            app.CalculateButton = uibutton(app.GridLayout6, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.FontWeight = 'bold';
            app.CalculateButton.Layout.Row = 1;
            app.CalculateButton.Layout.Column = 1;
            app.CalculateButton.Text = 'Calculate';

            % Create OverlayButton
            app.OverlayButton = uibutton(app.GridLayout6, 'push');
            app.OverlayButton.ButtonPushedFcn = createCallbackFcn(app, @OverlayButtonPushed, true);
            app.OverlayButton.FontWeight = 'bold';
            app.OverlayButton.Layout.Row = 1;
            app.OverlayButton.Layout.Column = 2;
            app.OverlayButton.Text = 'Overlay';

            % Create ClearButton
            app.ClearButton = uibutton(app.GridLayout6, 'push');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.FontWeight = 'bold';
            app.ClearButton.Layout.Row = 1;
            app.ClearButton.Layout.Column = 3;
            app.ClearButton.Text = 'Clear';

            % Create ExportButton
            app.ExportButton = uibutton(app.GridLayout6, 'push');
            app.ExportButton.ButtonPushedFcn = createCallbackFcn(app, @ExportButtonPushed, true);
            app.ExportButton.FontWeight = 'bold';
            app.ExportButton.Layout.Row = 1;
            app.ExportButton.Layout.Column = 4;
            app.ExportButton.Text = 'Export';

            % Create GenerationofseasurfaceTab_2
            app.GenerationofseasurfaceTab_2 = uitab(app.TabGroup);
            app.GenerationofseasurfaceTab_2.Title = 'Generation of sea surface';

            % Create GridLayout_2
            app.GridLayout_2 = uigridlayout(app.GenerationofseasurfaceTab_2);
            app.GridLayout_2.ColumnWidth = {'1x'};
            app.GridLayout_2.RowHeight = {50, '1x'};
            app.GridLayout_2.RowSpacing = 4;
            app.GridLayout_2.Padding = [8 0 10 10];

            % Create GridLayout2_2
            app.GridLayout2_2 = uigridlayout(app.GridLayout_2);
            app.GridLayout2_2.ColumnWidth = {'1x', 90, 90};
            app.GridLayout2_2.RowHeight = {'1x'};
            app.GridLayout2_2.ColumnSpacing = 8;
            app.GridLayout2_2.Padding = [5 5 10 10];
            app.GridLayout2_2.Layout.Row = 1;
            app.GridLayout2_2.Layout.Column = 1;

            % Create SeaProfileRadarSimulatorLabel
            app.SeaProfileRadarSimulatorLabel = uilabel(app.GridLayout2_2);
            app.SeaProfileRadarSimulatorLabel.FontSize = 18;
            app.SeaProfileRadarSimulatorLabel.FontWeight = 'bold';
            app.SeaProfileRadarSimulatorLabel.Layout.Row = 1;
            app.SeaProfileRadarSimulatorLabel.Layout.Column = 1;
            app.SeaProfileRadarSimulatorLabel.Text = 'Sea Profile Radar Simulator';

            % Create Image_2
            app.Image_2 = uiimage(app.GridLayout2_2);
            app.Image_2.Layout.Row = 1;
            app.Image_2.Layout.Column = 2;
            app.Image_2.VerticalAlignment = 'top';
            app.Image_2.ImageSource = 'logo_icam.png';

            % Create Image2_2
            app.Image2_2 = uiimage(app.GridLayout2_2);
            app.Image2_2.Layout.Row = 1;
            app.Image2_2.Layout.Column = 3;
            app.Image2_2.ImageSource = 'logo_ietr.png';

            % Create GridLayout3_2
            app.GridLayout3_2 = uigridlayout(app.GridLayout_2);
            app.GridLayout3_2.RowHeight = {'1x'};
            app.GridLayout3_2.Padding = [0 0 0 0];
            app.GridLayout3_2.Layout.Row = 2;
            app.GridLayout3_2.Layout.Column = 1;

            % Create GridLayout5_2
            app.GridLayout5_2 = uigridlayout(app.GridLayout3_2);
            app.GridLayout5_2.ColumnWidth = {'1x'};
            app.GridLayout5_2.RowHeight = {'1x', 130};
            app.GridLayout5_2.Layout.Row = 1;
            app.GridLayout5_2.Layout.Column = 2;

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.GridLayout5_2);
            title(app.UIAxes_2, 'NRCS curves')
            xlabel(app.UIAxes_2, 'Incidence angle (deg)')
            ylabel(app.UIAxes_2, 'NRCS (dB)')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.Layout.Row = 1;
            app.UIAxes_2.Layout.Column = 1;

            % Create SurfacestatisticsPanel
            app.SurfacestatisticsPanel = uipanel(app.GridLayout5_2);
            app.SurfacestatisticsPanel.TitlePosition = 'centertop';
            app.SurfacestatisticsPanel.Title = 'Surface statistics';
            app.SurfacestatisticsPanel.Layout.Row = 2;
            app.SurfacestatisticsPanel.Layout.Column = 1;
            app.SurfacestatisticsPanel.FontWeight = 'bold';

            % Create GridLayout10
            app.GridLayout10 = uigridlayout(app.SurfacestatisticsPanel);
            app.GridLayout10.ColumnWidth = {50, '1x', 50, '1x'};

            % Create ZminLabel
            app.ZminLabel = uilabel(app.GridLayout10);
            app.ZminLabel.HorizontalAlignment = 'center';
            app.ZminLabel.Layout.Row = 1;
            app.ZminLabel.Layout.Column = 1;
            app.ZminLabel.Text = 'Zmin';

            % Create ZmeanLabel
            app.ZmeanLabel = uilabel(app.GridLayout10);
            app.ZmeanLabel.HorizontalAlignment = 'center';
            app.ZmeanLabel.Layout.Row = 2;
            app.ZmeanLabel.Layout.Column = 1;
            app.ZmeanLabel.Text = 'Zmean';

            % Create ZmaxLabel
            app.ZmaxLabel = uilabel(app.GridLayout10);
            app.ZmaxLabel.HorizontalAlignment = 'center';
            app.ZmaxLabel.Layout.Row = 1;
            app.ZmaxLabel.Layout.Column = 3;
            app.ZmaxLabel.Text = 'Zmax';

            % Create ZstdLabel
            app.ZstdLabel = uilabel(app.GridLayout10);
            app.ZstdLabel.HorizontalAlignment = 'center';
            app.ZstdLabel.Layout.Row = 2;
            app.ZstdLabel.Layout.Column = 3;
            app.ZstdLabel.Text = 'Zstd';

            % Create Label
            app.Label = uilabel(app.GridLayout10);
            app.Label.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label.Layout.Row = 1;
            app.Label.Layout.Column = 2;
            app.Label.Text = '';

            % Create Label_7
            app.Label_7 = uilabel(app.GridLayout10);
            app.Label_7.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label_7.Layout.Row = 2;
            app.Label_7.Layout.Column = 2;
            app.Label_7.Text = '';

            % Create Label_6
            app.Label_6 = uilabel(app.GridLayout10);
            app.Label_6.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label_6.Layout.Row = 1;
            app.Label_6.Layout.Column = 4;
            app.Label_6.Text = '';

            % Create Label_8
            app.Label_8 = uilabel(app.GridLayout10);
            app.Label_8.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label_8.Layout.Row = 2;
            app.Label_8.Layout.Column = 4;
            app.Label_8.Text = '';

            % Create GridLayout7
            app.GridLayout7 = uigridlayout(app.GridLayout3_2);
            app.GridLayout7.ColumnWidth = {'1x'};
            app.GridLayout7.RowHeight = {'1x', 130};
            app.GridLayout7.RowSpacing = 8;
            app.GridLayout7.Padding = [0 0 0 0];
            app.GridLayout7.Layout.Row = 1;
            app.GridLayout7.Layout.Column = 1;

            % Create GridLayout8
            app.GridLayout8 = uigridlayout(app.GridLayout7);
            app.GridLayout8.RowHeight = {25, 25, 25, 25, 25, 25, 25, 25, 29, 25, 25, 25, 25};
            app.GridLayout8.ColumnSpacing = 6;
            app.GridLayout8.RowSpacing = 6;
            app.GridLayout8.Layout.Row = 1;
            app.GridLayout8.Layout.Column = 1;

            % Create SeasurfaceparametersLabel
            app.SeasurfaceparametersLabel = uilabel(app.GridLayout8);
            app.SeasurfaceparametersLabel.FontSize = 14;
            app.SeasurfaceparametersLabel.FontWeight = 'bold';
            app.SeasurfaceparametersLabel.Layout.Row = 1;
            app.SeasurfaceparametersLabel.Layout.Column = [1 2];
            app.SeasurfaceparametersLabel.Text = 'Sea surface parameters';

            % Create Windspeedu10msEditFieldLabel
            app.Windspeedu10msEditFieldLabel = uilabel(app.GridLayout8);
            app.Windspeedu10msEditFieldLabel.HorizontalAlignment = 'center';
            app.Windspeedu10msEditFieldLabel.Layout.Row = 2;
            app.Windspeedu10msEditFieldLabel.Layout.Column = 1;
            app.Windspeedu10msEditFieldLabel.Text = 'Wind speed u10 (m/s):';

            % Create Windspeedu10msEditField
            app.Windspeedu10msEditField = uieditfield(app.GridLayout8, 'numeric');
            app.Windspeedu10msEditField.Layout.Row = 2;
            app.Windspeedu10msEditField.Layout.Column = 2;
            app.Windspeedu10msEditField.Value = 8;

            % Create WinddirectiondegEditFieldLabel
            app.WinddirectiondegEditFieldLabel = uilabel(app.GridLayout8);
            app.WinddirectiondegEditFieldLabel.HorizontalAlignment = 'center';
            app.WinddirectiondegEditFieldLabel.Layout.Row = 3;
            app.WinddirectiondegEditFieldLabel.Layout.Column = 1;
            app.WinddirectiondegEditFieldLabel.Text = 'Wind direction(deg):';

            % Create WinddirectiondegEditField
            app.WinddirectiondegEditField = uieditfield(app.GridLayout8, 'numeric');
            app.WinddirectiondegEditField.Layout.Row = 3;
            app.WinddirectiondegEditField.Layout.Column = 2;

            % Create FetchmEditField_2Label
            app.FetchmEditField_2Label = uilabel(app.GridLayout8);
            app.FetchmEditField_2Label.HorizontalAlignment = 'center';
            app.FetchmEditField_2Label.Layout.Row = 6;
            app.FetchmEditField_2Label.Layout.Column = 1;
            app.FetchmEditField_2Label.Text = 'Fetch (m):';

            % Create FetchmEditField_2
            app.FetchmEditField_2 = uieditfield(app.GridLayout8, 'numeric');
            app.FetchmEditField_2.Layout.Row = 6;
            app.FetchmEditField_2.Layout.Column = 2;
            app.FetchmEditField_2.Value = 500000;

            % Create LengthXmEditFieldLabel
            app.LengthXmEditFieldLabel = uilabel(app.GridLayout8);
            app.LengthXmEditFieldLabel.HorizontalAlignment = 'center';
            app.LengthXmEditFieldLabel.Layout.Row = 7;
            app.LengthXmEditFieldLabel.Layout.Column = 1;
            app.LengthXmEditFieldLabel.Text = 'Length X (m):';

            % Create LengthXmEditField
            app.LengthXmEditField = uieditfield(app.GridLayout8, 'numeric');
            app.LengthXmEditField.Layout.Row = 7;
            app.LengthXmEditField.Layout.Column = 2;
            app.LengthXmEditField.Value = 40;

            % Create LengthYmEditFieldLabel
            app.LengthYmEditFieldLabel = uilabel(app.GridLayout8);
            app.LengthYmEditFieldLabel.HorizontalAlignment = 'center';
            app.LengthYmEditFieldLabel.Layout.Row = 8;
            app.LengthYmEditFieldLabel.Layout.Column = 1;
            app.LengthYmEditFieldLabel.Text = 'Length Y (m):';

            % Create LengthYmEditField
            app.LengthYmEditField = uieditfield(app.GridLayout8, 'numeric');
            app.LengthYmEditField.Layout.Row = 8;
            app.LengthYmEditField.Layout.Column = 2;
            app.LengthYmEditField.Value = 30;

            % Create RadarfrequencyGHz130GHz2308cmLabel
            app.RadarfrequencyGHz130GHz2308cmLabel = uilabel(app.GridLayout8);
            app.RadarfrequencyGHz130GHz2308cmLabel.HorizontalAlignment = 'center';
            app.RadarfrequencyGHz130GHz2308cmLabel.WordWrap = 'on';
            app.RadarfrequencyGHz130GHz2308cmLabel.Layout.Row = 9;
            app.RadarfrequencyGHz130GHz2308cmLabel.Layout.Column = 1;
            app.RadarfrequencyGHz130GHz2308cmLabel.Text = 'Radar frequency (GHz) :        1.30 GHz → λ = 23.08 cm';

            % Create RadarfrequencyGHz130GHz2308cmEditField
            app.RadarfrequencyGHz130GHz2308cmEditField = uieditfield(app.GridLayout8, 'numeric');
            app.RadarfrequencyGHz130GHz2308cmEditField.Layout.Row = 9;
            app.RadarfrequencyGHz130GHz2308cmEditField.Layout.Column = 2;
            app.RadarfrequencyGHz130GHz2308cmEditField.Value = 1.3;

            % Create SamplesperwavelengthEditFieldLabel
            app.SamplesperwavelengthEditFieldLabel = uilabel(app.GridLayout8);
            app.SamplesperwavelengthEditFieldLabel.HorizontalAlignment = 'center';
            app.SamplesperwavelengthEditFieldLabel.Layout.Row = 10;
            app.SamplesperwavelengthEditFieldLabel.Layout.Column = 1;
            app.SamplesperwavelengthEditFieldLabel.Text = 'Samples per wavelength (-):';

            % Create SamplesperwavelengthEditField
            app.SamplesperwavelengthEditField = uieditfield(app.GridLayout8, 'numeric');
            app.SamplesperwavelengthEditField.Layout.Row = 10;
            app.SamplesperwavelengthEditField.Layout.Column = 2;

            % Create NumberofsamplesEditField_2Label
            app.NumberofsamplesEditField_2Label = uilabel(app.GridLayout8);
            app.NumberofsamplesEditField_2Label.HorizontalAlignment = 'center';
            app.NumberofsamplesEditField_2Label.Layout.Row = 11;
            app.NumberofsamplesEditField_2Label.Layout.Column = 1;
            app.NumberofsamplesEditField_2Label.Text = 'Number of samples';

            % Create NumberofsamplesEditField_2
            app.NumberofsamplesEditField_2 = uieditfield(app.GridLayout8, 'numeric');
            app.NumberofsamplesEditField_2.Layout.Row = 11;
            app.NumberofsamplesEditField_2.Layout.Column = 2;

            % Create PrecisionLabel
            app.PrecisionLabel = uilabel(app.GridLayout8);
            app.PrecisionLabel.HorizontalAlignment = 'center';
            app.PrecisionLabel.Layout.Row = 12;
            app.PrecisionLabel.Layout.Column = 1;
            app.PrecisionLabel.Text = 'Precision :';

            % Create RoundlengthLabel
            app.RoundlengthLabel = uilabel(app.GridLayout8);
            app.RoundlengthLabel.HorizontalAlignment = 'center';
            app.RoundlengthLabel.Layout.Row = 13;
            app.RoundlengthLabel.Layout.Column = 1;
            app.RoundlengthLabel.Text = 'Round length:';

            % Create IsotropicspectrumDropDownLabel
            app.IsotropicspectrumDropDownLabel = uilabel(app.GridLayout8);
            app.IsotropicspectrumDropDownLabel.HorizontalAlignment = 'center';
            app.IsotropicspectrumDropDownLabel.Layout.Row = 4;
            app.IsotropicspectrumDropDownLabel.Layout.Column = 1;
            app.IsotropicspectrumDropDownLabel.Text = 'Isotropic spectrum';

            % Create IsotropicspectrumDropDown
            app.IsotropicspectrumDropDown = uidropdown(app.GridLayout8);
            app.IsotropicspectrumDropDown.Items = {'Apel', 'Elfouhaily', 'Donelan'};
            app.IsotropicspectrumDropDown.Layout.Row = 4;
            app.IsotropicspectrumDropDown.Layout.Column = 2;
            app.IsotropicspectrumDropDown.Value = 'Apel';

            % Create AngularspectrumDropDownLabel
            app.AngularspectrumDropDownLabel = uilabel(app.GridLayout8);
            app.AngularspectrumDropDownLabel.HorizontalAlignment = 'center';
            app.AngularspectrumDropDownLabel.Layout.Row = 5;
            app.AngularspectrumDropDownLabel.Layout.Column = 1;
            app.AngularspectrumDropDownLabel.Text = 'Angular spectrum';

            % Create AngularspectrumDropDown
            app.AngularspectrumDropDown = uidropdown(app.GridLayout8);
            app.AngularspectrumDropDown.Items = {'Elfouhaily', 'Du', 'Donelan', 'Banner', 'McDaniel'};
            app.AngularspectrumDropDown.Layout.Row = 5;
            app.AngularspectrumDropDown.Layout.Column = 2;
            app.AngularspectrumDropDown.Value = 'Elfouhaily';

            % Create UsesingleprecisionCheckBox
            app.UsesingleprecisionCheckBox = uicheckbox(app.GridLayout8);
            app.UsesingleprecisionCheckBox.Text = 'Use single precision';
            app.UsesingleprecisionCheckBox.Layout.Row = 12;
            app.UsesingleprecisionCheckBox.Layout.Column = 2;

            % Create Roundtothenearestpowerof2CheckBox
            app.Roundtothenearestpowerof2CheckBox = uicheckbox(app.GridLayout8);
            app.Roundtothenearestpowerof2CheckBox.Text = 'Round to the nearest power of 2';
            app.Roundtothenearestpowerof2CheckBox.Layout.Row = 13;
            app.Roundtothenearestpowerof2CheckBox.Layout.Column = 2;

            % Create GridLayout9
            app.GridLayout9 = uigridlayout(app.GridLayout7);
            app.GridLayout9.ColumnWidth = {'1x'};
            app.GridLayout9.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout9.Layout.Row = 2;
            app.GridLayout9.Layout.Column = 1;

            % Create GenerateSurfaceButton
            app.GenerateSurfaceButton = uibutton(app.GridLayout9, 'push');
            app.GenerateSurfaceButton.ButtonPushedFcn = createCallbackFcn(app, @GenerateSurfaceButtonPushed, true);
            app.GenerateSurfaceButton.Layout.Row = 1;
            app.GenerateSurfaceButton.Layout.Column = 1;
            app.GenerateSurfaceButton.Text = 'Generate Surface';

            % Create ClearSurfaceButton
            app.ClearSurfaceButton = uibutton(app.GridLayout9, 'push');
            app.ClearSurfaceButton.ButtonPushedFcn = createCallbackFcn(app, @ClearSurfaceButtonPushed, true);
            app.ClearSurfaceButton.Layout.Row = 2;
            app.ClearSurfaceButton.Layout.Column = 1;
            app.ClearSurfaceButton.Text = 'Clear Surface';

            % Create ExportSurfaceButton
            app.ExportSurfaceButton = uibutton(app.GridLayout9, 'push');
            app.ExportSurfaceButton.ButtonPushedFcn = createCallbackFcn(app, @ExportSurfaceButtonPushed, true);
            app.ExportSurfaceButton.Layout.Row = 3;
            app.ExportSurfaceButton.Layout.Column = 1;
            app.ExportSurfaceButton.Text = 'Export Surface';

            % Create GenerationofseaProfilesTab
            app.GenerationofseaProfilesTab = uitab(app.TabGroup);
            app.GenerationofseaProfilesTab.Title = 'Generation of sea Profiles';

            % Create GridLayout_3
            app.GridLayout_3 = uigridlayout(app.GenerationofseaProfilesTab);
            app.GridLayout_3.ColumnWidth = {'1x'};
            app.GridLayout_3.RowHeight = {50, '1x'};
            app.GridLayout_3.RowSpacing = 4;
            app.GridLayout_3.Padding = [8 0 10 10];

            % Create GridLayout2_3
            app.GridLayout2_3 = uigridlayout(app.GridLayout_3);
            app.GridLayout2_3.ColumnWidth = {'1x', 90, 90};
            app.GridLayout2_3.RowHeight = {'1x'};
            app.GridLayout2_3.ColumnSpacing = 8;
            app.GridLayout2_3.Padding = [5 5 10 10];
            app.GridLayout2_3.Layout.Row = 1;
            app.GridLayout2_3.Layout.Column = 1;

            % Create SeaProfileRadarSimulatorLabel_2
            app.SeaProfileRadarSimulatorLabel_2 = uilabel(app.GridLayout2_3);
            app.SeaProfileRadarSimulatorLabel_2.FontSize = 18;
            app.SeaProfileRadarSimulatorLabel_2.FontWeight = 'bold';
            app.SeaProfileRadarSimulatorLabel_2.Layout.Row = 1;
            app.SeaProfileRadarSimulatorLabel_2.Layout.Column = 1;
            app.SeaProfileRadarSimulatorLabel_2.Text = 'Sea Profile Radar Simulator';

            % Create Image_3
            app.Image_3 = uiimage(app.GridLayout2_3);
            app.Image_3.Layout.Row = 1;
            app.Image_3.Layout.Column = 2;
            app.Image_3.VerticalAlignment = 'top';
            app.Image_3.ImageSource = 'logo_icam.png';

            % Create Image2_3
            app.Image2_3 = uiimage(app.GridLayout2_3);
            app.Image2_3.Layout.Row = 1;
            app.Image2_3.Layout.Column = 3;
            app.Image2_3.ImageSource = 'logo_ietr.png';

            % Create GridLayout3_3
            app.GridLayout3_3 = uigridlayout(app.GridLayout_3);
            app.GridLayout3_3.RowHeight = {'1x'};
            app.GridLayout3_3.Padding = [0 0 0 0];
            app.GridLayout3_3.Layout.Row = 2;
            app.GridLayout3_3.Layout.Column = 1;

            % Create GridLayout5_3
            app.GridLayout5_3 = uigridlayout(app.GridLayout3_3);
            app.GridLayout5_3.ColumnWidth = {'1x'};
            app.GridLayout5_3.RowHeight = {'1x', 130};
            app.GridLayout5_3.Layout.Row = 1;
            app.GridLayout5_3.Layout.Column = 2;

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.GridLayout5_3);
            xlabel(app.UIAxes_3, 'X')
            ylabel(app.UIAxes_3, 'Y')
            zlabel(app.UIAxes_3, 'Z')
            app.UIAxes_3.Layout.Row = 1;
            app.UIAxes_3.Layout.Column = 1;

            % Create ProfileStatisticsPanel
            app.ProfileStatisticsPanel = uipanel(app.GridLayout5_3);
            app.ProfileStatisticsPanel.TitlePosition = 'centertop';
            app.ProfileStatisticsPanel.Title = 'Profile Statistics';
            app.ProfileStatisticsPanel.Layout.Row = 2;
            app.ProfileStatisticsPanel.Layout.Column = 1;
            app.ProfileStatisticsPanel.FontWeight = 'bold';

            % Create GridLayout10_2
            app.GridLayout10_2 = uigridlayout(app.ProfileStatisticsPanel);
            app.GridLayout10_2.ColumnWidth = {50, '1x', 50, '1x'};

            % Create ZminLabel_2
            app.ZminLabel_2 = uilabel(app.GridLayout10_2);
            app.ZminLabel_2.HorizontalAlignment = 'center';
            app.ZminLabel_2.Layout.Row = 1;
            app.ZminLabel_2.Layout.Column = 1;
            app.ZminLabel_2.Text = 'Zmin';

            % Create ZmeanLabel_2
            app.ZmeanLabel_2 = uilabel(app.GridLayout10_2);
            app.ZmeanLabel_2.HorizontalAlignment = 'center';
            app.ZmeanLabel_2.Layout.Row = 2;
            app.ZmeanLabel_2.Layout.Column = 1;
            app.ZmeanLabel_2.Text = 'Zmean';

            % Create ZmaxLabel_2
            app.ZmaxLabel_2 = uilabel(app.GridLayout10_2);
            app.ZmaxLabel_2.HorizontalAlignment = 'center';
            app.ZmaxLabel_2.Layout.Row = 1;
            app.ZmaxLabel_2.Layout.Column = 3;
            app.ZmaxLabel_2.Text = 'Zmax';

            % Create ZstdLabel_2
            app.ZstdLabel_2 = uilabel(app.GridLayout10_2);
            app.ZstdLabel_2.HorizontalAlignment = 'center';
            app.ZstdLabel_2.Layout.Row = 2;
            app.ZstdLabel_2.Layout.Column = 3;
            app.ZstdLabel_2.Text = 'Zstd';

            % Create Label_2
            app.Label_2 = uilabel(app.GridLayout10_2);
            app.Label_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label_2.Layout.Row = 1;
            app.Label_2.Layout.Column = 2;
            app.Label_2.Text = '';

            % Create Label_4
            app.Label_4 = uilabel(app.GridLayout10_2);
            app.Label_4.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label_4.Layout.Row = 2;
            app.Label_4.Layout.Column = 2;
            app.Label_4.Text = '';

            % Create Label_3
            app.Label_3 = uilabel(app.GridLayout10_2);
            app.Label_3.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label_3.Layout.Row = 1;
            app.Label_3.Layout.Column = 4;
            app.Label_3.Text = '';

            % Create Label_5
            app.Label_5 = uilabel(app.GridLayout10_2);
            app.Label_5.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Label_5.Layout.Row = 2;
            app.Label_5.Layout.Column = 4;
            app.Label_5.Text = '';

            % Create GridLayout7_2
            app.GridLayout7_2 = uigridlayout(app.GridLayout3_3);
            app.GridLayout7_2.ColumnWidth = {'1x'};
            app.GridLayout7_2.RowHeight = {'1x', 130};
            app.GridLayout7_2.RowSpacing = 8;
            app.GridLayout7_2.Padding = [0 0 0 0];
            app.GridLayout7_2.Layout.Row = 1;
            app.GridLayout7_2.Layout.Column = 1;

            % Create GridLayout8_2
            app.GridLayout8_2 = uigridlayout(app.GridLayout7_2);
            app.GridLayout8_2.RowHeight = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30};
            app.GridLayout8_2.ColumnSpacing = 8;
            app.GridLayout8_2.RowSpacing = 6;
            app.GridLayout8_2.Layout.Row = 1;
            app.GridLayout8_2.Layout.Column = 1;

            % Create SeasurfaceparametersLabel_2
            app.SeasurfaceparametersLabel_2 = uilabel(app.GridLayout8_2);
            app.SeasurfaceparametersLabel_2.FontSize = 14;
            app.SeasurfaceparametersLabel_2.FontWeight = 'bold';
            app.SeasurfaceparametersLabel_2.Layout.Row = 1;
            app.SeasurfaceparametersLabel_2.Layout.Column = [1 2];
            app.SeasurfaceparametersLabel_2.Text = 'Sea surface parameters';

            % Create Windspeedu10msEditField_2Label
            app.Windspeedu10msEditField_2Label = uilabel(app.GridLayout8_2);
            app.Windspeedu10msEditField_2Label.HorizontalAlignment = 'center';
            app.Windspeedu10msEditField_2Label.Layout.Row = 2;
            app.Windspeedu10msEditField_2Label.Layout.Column = 1;
            app.Windspeedu10msEditField_2Label.Text = 'Wind speed u10 (m/s):';

            % Create Windspeedu10msEditField_2
            app.Windspeedu10msEditField_2 = uieditfield(app.GridLayout8_2, 'numeric');
            app.Windspeedu10msEditField_2.Layout.Row = 2;
            app.Windspeedu10msEditField_2.Layout.Column = 2;
            app.Windspeedu10msEditField_2.Value = 10;

            % Create FetchmEditField_3Label
            app.FetchmEditField_3Label = uilabel(app.GridLayout8_2);
            app.FetchmEditField_3Label.HorizontalAlignment = 'center';
            app.FetchmEditField_3Label.Layout.Row = 4;
            app.FetchmEditField_3Label.Layout.Column = 1;
            app.FetchmEditField_3Label.Text = 'Fetch (m):';

            % Create FetchmEditField_3
            app.FetchmEditField_3 = uieditfield(app.GridLayout8_2, 'numeric');
            app.FetchmEditField_3.Layout.Row = 4;
            app.FetchmEditField_3.Layout.Column = 2;
            app.FetchmEditField_3.Value = 500000;

            % Create LengthmEditFieldLabel
            app.LengthmEditFieldLabel = uilabel(app.GridLayout8_2);
            app.LengthmEditFieldLabel.HorizontalAlignment = 'center';
            app.LengthmEditFieldLabel.Layout.Row = 5;
            app.LengthmEditFieldLabel.Layout.Column = 1;
            app.LengthmEditFieldLabel.Text = 'Length (m):';

            % Create LengthmEditField
            app.LengthmEditField = uieditfield(app.GridLayout8_2, 'numeric');
            app.LengthmEditField.Layout.Row = 5;
            app.LengthmEditField.Layout.Column = 2;
            app.LengthmEditField.Value = 500;

            % Create NprofilesEditFieldLabel
            app.NprofilesEditFieldLabel = uilabel(app.GridLayout8_2);
            app.NprofilesEditFieldLabel.HorizontalAlignment = 'center';
            app.NprofilesEditFieldLabel.Layout.Row = 11;
            app.NprofilesEditFieldLabel.Layout.Column = 1;
            app.NprofilesEditFieldLabel.Text = 'Nprofiles:';

            % Create NprofilesEditField
            app.NprofilesEditField = uieditfield(app.GridLayout8_2, 'numeric');
            app.NprofilesEditField.Layout.Row = 11;
            app.NprofilesEditField.Layout.Column = 2;
            app.NprofilesEditField.Value = 5;

            % Create RadarfrequencyGHz130GHz2308cmLabel_2
            app.RadarfrequencyGHz130GHz2308cmLabel_2 = uilabel(app.GridLayout8_2);
            app.RadarfrequencyGHz130GHz2308cmLabel_2.HorizontalAlignment = 'center';
            app.RadarfrequencyGHz130GHz2308cmLabel_2.WordWrap = 'on';
            app.RadarfrequencyGHz130GHz2308cmLabel_2.Layout.Row = 6;
            app.RadarfrequencyGHz130GHz2308cmLabel_2.Layout.Column = 1;
            app.RadarfrequencyGHz130GHz2308cmLabel_2.Text = 'Radar frequency (GHz) :        1.30 GHz → λ = 23.08 cm';

            % Create RadarfrequencyGHz130GHz2308cmEditField_2
            app.RadarfrequencyGHz130GHz2308cmEditField_2 = uieditfield(app.GridLayout8_2, 'numeric');
            app.RadarfrequencyGHz130GHz2308cmEditField_2.Layout.Row = 6;
            app.RadarfrequencyGHz130GHz2308cmEditField_2.Layout.Column = 2;
            app.RadarfrequencyGHz130GHz2308cmEditField_2.Value = 1.3;

            % Create SamplesperwavelengthEditField_2Label
            app.SamplesperwavelengthEditField_2Label = uilabel(app.GridLayout8_2);
            app.SamplesperwavelengthEditField_2Label.HorizontalAlignment = 'center';
            app.SamplesperwavelengthEditField_2Label.Layout.Row = 7;
            app.SamplesperwavelengthEditField_2Label.Layout.Column = 1;
            app.SamplesperwavelengthEditField_2Label.Text = 'Samples per wavelength (-):';

            % Create SamplesperwavelengthEditField_2
            app.SamplesperwavelengthEditField_2 = uieditfield(app.GridLayout8_2, 'numeric');
            app.SamplesperwavelengthEditField_2.Layout.Row = 7;
            app.SamplesperwavelengthEditField_2.Layout.Column = 2;
            app.SamplesperwavelengthEditField_2.Value = 8;

            % Create NumberofsamplesEditField_3Label
            app.NumberofsamplesEditField_3Label = uilabel(app.GridLayout8_2);
            app.NumberofsamplesEditField_3Label.HorizontalAlignment = 'center';
            app.NumberofsamplesEditField_3Label.Layout.Row = 8;
            app.NumberofsamplesEditField_3Label.Layout.Column = 1;
            app.NumberofsamplesEditField_3Label.Text = 'Number of samples';

            % Create NumberofsamplesEditField_3
            app.NumberofsamplesEditField_3 = uieditfield(app.GridLayout8_2, 'numeric');
            app.NumberofsamplesEditField_3.Layout.Row = 8;
            app.NumberofsamplesEditField_3.Layout.Column = 2;

            % Create PrecisionLabel_2
            app.PrecisionLabel_2 = uilabel(app.GridLayout8_2);
            app.PrecisionLabel_2.HorizontalAlignment = 'center';
            app.PrecisionLabel_2.Layout.Row = 9;
            app.PrecisionLabel_2.Layout.Column = 1;
            app.PrecisionLabel_2.Text = 'Precision :';

            % Create RoundlengthLabel_2
            app.RoundlengthLabel_2 = uilabel(app.GridLayout8_2);
            app.RoundlengthLabel_2.HorizontalAlignment = 'center';
            app.RoundlengthLabel_2.Layout.Row = 10;
            app.RoundlengthLabel_2.Layout.Column = 1;
            app.RoundlengthLabel_2.Text = 'Round length:';

            % Create IsotropicspectrumDropDown_2Label
            app.IsotropicspectrumDropDown_2Label = uilabel(app.GridLayout8_2);
            app.IsotropicspectrumDropDown_2Label.HorizontalAlignment = 'center';
            app.IsotropicspectrumDropDown_2Label.Layout.Row = 3;
            app.IsotropicspectrumDropDown_2Label.Layout.Column = 1;
            app.IsotropicspectrumDropDown_2Label.Text = 'Isotropic spectrum';

            % Create IsotropicspectrumDropDown_2
            app.IsotropicspectrumDropDown_2 = uidropdown(app.GridLayout8_2);
            app.IsotropicspectrumDropDown_2.Items = {'Apel', 'Elfouhaily', 'Donelan'};
            app.IsotropicspectrumDropDown_2.Layout.Row = 3;
            app.IsotropicspectrumDropDown_2.Layout.Column = 2;
            app.IsotropicspectrumDropDown_2.Value = 'Apel';

            % Create UsesingleprecisionCheckBox_2
            app.UsesingleprecisionCheckBox_2 = uicheckbox(app.GridLayout8_2);
            app.UsesingleprecisionCheckBox_2.Text = 'Use single precision';
            app.UsesingleprecisionCheckBox_2.Layout.Row = 9;
            app.UsesingleprecisionCheckBox_2.Layout.Column = 2;

            % Create Roundtothenearestpowerof2CheckBox_2
            app.Roundtothenearestpowerof2CheckBox_2 = uicheckbox(app.GridLayout8_2);
            app.Roundtothenearestpowerof2CheckBox_2.Text = 'Round to the nearest power of 2';
            app.Roundtothenearestpowerof2CheckBox_2.Layout.Row = 10;
            app.Roundtothenearestpowerof2CheckBox_2.Layout.Column = 2;

            % Create GridLayout9_2
            app.GridLayout9_2 = uigridlayout(app.GridLayout7_2);
            app.GridLayout9_2.ColumnWidth = {'1x'};
            app.GridLayout9_2.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout9_2.Layout.Row = 2;
            app.GridLayout9_2.Layout.Column = 1;

            % Create GenerateProfilesButton
            app.GenerateProfilesButton = uibutton(app.GridLayout9_2, 'push');
            app.GenerateProfilesButton.ButtonPushedFcn = createCallbackFcn(app, @GenerateProfilesButtonPushed, true);
            app.GenerateProfilesButton.FontWeight = 'bold';
            app.GenerateProfilesButton.Layout.Row = 1;
            app.GenerateProfilesButton.Layout.Column = 1;
            app.GenerateProfilesButton.Text = 'Generate Profiles';

            % Create ClearSurfaceButton_2
            app.ClearSurfaceButton_2 = uibutton(app.GridLayout9_2, 'push');
            app.ClearSurfaceButton_2.ButtonPushedFcn = createCallbackFcn(app, @ClearSurfaceButton_2Pushed, true);
            app.ClearSurfaceButton_2.FontWeight = 'bold';
            app.ClearSurfaceButton_2.Layout.Row = 2;
            app.ClearSurfaceButton_2.Layout.Column = 1;
            app.ClearSurfaceButton_2.Text = 'Clear Surface';

            % Create ExportSurfaceButton_2
            app.ExportSurfaceButton_2 = uibutton(app.GridLayout9_2, 'push');
            app.ExportSurfaceButton_2.ButtonPushedFcn = createCallbackFcn(app, @ExportSurfaceButton_2Pushed, true);
            app.ExportSurfaceButton_2.FontWeight = 'bold';
            app.ExportSurfaceButton_2.Layout.Row = 3;
            app.ExportSurfaceButton_2.Layout.Column = 1;
            app.ExportSurfaceButton_2.Text = 'Export Surface';

            % Create SeaprofileradarsimulatorTab_2
            app.SeaprofileradarsimulatorTab_2 = uitab(app.TabGroup);
            app.SeaprofileradarsimulatorTab_2.Title = 'Sea profile radar simulator';

            % Create GridLayout_4
            app.GridLayout_4 = uigridlayout(app.SeaprofileradarsimulatorTab_2);
            app.GridLayout_4.ColumnWidth = {'1x'};
            app.GridLayout_4.RowHeight = {50, '1x'};
            app.GridLayout_4.RowSpacing = 4;
            app.GridLayout_4.Padding = [8 0 10 10];

            % Create GridLayout2_4
            app.GridLayout2_4 = uigridlayout(app.GridLayout_4);
            app.GridLayout2_4.ColumnWidth = {'1x', 90, 90};
            app.GridLayout2_4.RowHeight = {'1x'};
            app.GridLayout2_4.ColumnSpacing = 8;
            app.GridLayout2_4.Padding = [5 5 10 10];
            app.GridLayout2_4.Layout.Row = 1;
            app.GridLayout2_4.Layout.Column = 1;

            % Create SeaProfileRadarSimulatorLabel_3
            app.SeaProfileRadarSimulatorLabel_3 = uilabel(app.GridLayout2_4);
            app.SeaProfileRadarSimulatorLabel_3.FontSize = 18;
            app.SeaProfileRadarSimulatorLabel_3.FontWeight = 'bold';
            app.SeaProfileRadarSimulatorLabel_3.Layout.Row = 1;
            app.SeaProfileRadarSimulatorLabel_3.Layout.Column = 1;
            app.SeaProfileRadarSimulatorLabel_3.Text = 'Sea Profile Radar Simulator';

            % Create Image_4
            app.Image_4 = uiimage(app.GridLayout2_4);
            app.Image_4.Layout.Row = 1;
            app.Image_4.Layout.Column = 2;
            app.Image_4.VerticalAlignment = 'top';
            app.Image_4.ImageSource = 'logo_icam.png';

            % Create Image2_4
            app.Image2_4 = uiimage(app.GridLayout2_4);
            app.Image2_4.Layout.Row = 1;
            app.Image2_4.Layout.Column = 3;
            app.Image2_4.ImageSource = 'logo_ietr.png';

            % Create GridLayout3_4
            app.GridLayout3_4 = uigridlayout(app.GridLayout_4);
            app.GridLayout3_4.RowHeight = {'1x'};
            app.GridLayout3_4.Padding = [0 0 0 0];
            app.GridLayout3_4.Layout.Row = 2;
            app.GridLayout3_4.Layout.Column = 1;

            % Create GridLayout5_4
            app.GridLayout5_4 = uigridlayout(app.GridLayout3_4);
            app.GridLayout5_4.ColumnWidth = {'1x'};
            app.GridLayout5_4.RowHeight = {'1x'};
            app.GridLayout5_4.Layout.Row = 1;
            app.GridLayout5_4.Layout.Column = 2;

            % Create UIAxes_4
            app.UIAxes_4 = uiaxes(app.GridLayout5_4);
            xlabel(app.UIAxes_4, 'X')
            ylabel(app.UIAxes_4, 'Y')
            zlabel(app.UIAxes_4, 'Z')
            app.UIAxes_4.Layout.Row = 1;
            app.UIAxes_4.Layout.Column = 1;

            % Create GridLayout7_3
            app.GridLayout7_3 = uigridlayout(app.GridLayout3_4);
            app.GridLayout7_3.ColumnWidth = {'1x'};
            app.GridLayout7_3.RowHeight = {'1x', 130};
            app.GridLayout7_3.RowSpacing = 8;
            app.GridLayout7_3.Padding = [0 0 0 0];
            app.GridLayout7_3.Layout.Row = 1;
            app.GridLayout7_3.Layout.Column = 1;

            % Create GridLayout8_3
            app.GridLayout8_3 = uigridlayout(app.GridLayout7_3);
            app.GridLayout8_3.RowHeight = {32, 32, 32, 32, 32, 32, 32, 32, 32, 32};
            app.GridLayout8_3.ColumnSpacing = 8;
            app.GridLayout8_3.RowSpacing = 6;
            app.GridLayout8_3.Layout.Row = 1;
            app.GridLayout8_3.Layout.Column = 1;

            % Create InputparametersLabel_2
            app.InputparametersLabel_2 = uilabel(app.GridLayout8_3);
            app.InputparametersLabel_2.FontSize = 14;
            app.InputparametersLabel_2.FontWeight = 'bold';
            app.InputparametersLabel_2.Layout.Row = 1;
            app.InputparametersLabel_2.Layout.Column = [1 2];
            app.InputparametersLabel_2.Text = 'Input parameters';

            % Create Windspeedu10msEditField_3Label
            app.Windspeedu10msEditField_3Label = uilabel(app.GridLayout8_3);
            app.Windspeedu10msEditField_3Label.HorizontalAlignment = 'center';
            app.Windspeedu10msEditField_3Label.Layout.Row = 2;
            app.Windspeedu10msEditField_3Label.Layout.Column = 1;
            app.Windspeedu10msEditField_3Label.Text = 'Wind speed u10 (m/s):';

            % Create Windspeedu10msEditField_3
            app.Windspeedu10msEditField_3 = uieditfield(app.GridLayout8_3, 'numeric');
            app.Windspeedu10msEditField_3.Layout.Row = 2;
            app.Windspeedu10msEditField_3.Layout.Column = 2;

            % Create FetchmEditField_4Label
            app.FetchmEditField_4Label = uilabel(app.GridLayout8_3);
            app.FetchmEditField_4Label.HorizontalAlignment = 'center';
            app.FetchmEditField_4Label.Layout.Row = 3;
            app.FetchmEditField_4Label.Layout.Column = 1;
            app.FetchmEditField_4Label.Text = 'Fetch (m):';

            % Create FetchmEditField_4
            app.FetchmEditField_4 = uieditfield(app.GridLayout8_3, 'numeric');
            app.FetchmEditField_4.Layout.Row = 3;
            app.FetchmEditField_4.Layout.Column = 2;

            % Create LengthmEditField_2Label
            app.LengthmEditField_2Label = uilabel(app.GridLayout8_3);
            app.LengthmEditField_2Label.HorizontalAlignment = 'center';
            app.LengthmEditField_2Label.Layout.Row = 4;
            app.LengthmEditField_2Label.Layout.Column = 1;
            app.LengthmEditField_2Label.Text = 'Length (m):';

            % Create LengthmEditField_2
            app.LengthmEditField_2 = uieditfield(app.GridLayout8_3, 'numeric');
            app.LengthmEditField_2.Layout.Row = 4;
            app.LengthmEditField_2.Layout.Column = 2;

            % Create IncidenceangledegEditField_2Label
            app.IncidenceangledegEditField_2Label = uilabel(app.GridLayout8_3);
            app.IncidenceangledegEditField_2Label.HorizontalAlignment = 'center';
            app.IncidenceangledegEditField_2Label.Layout.Row = 9;
            app.IncidenceangledegEditField_2Label.Layout.Column = 1;
            app.IncidenceangledegEditField_2Label.Text = 'Incidence angle (deg):';

            % Create IncidenceangledegEditField_2
            app.IncidenceangledegEditField_2 = uieditfield(app.GridLayout8_3, 'numeric');
            app.IncidenceangledegEditField_2.Layout.Row = 9;
            app.IncidenceangledegEditField_2.Layout.Column = 2;
            app.IncidenceangledegEditField_2.Value = 30;

            % Create RadarfrequencyGHz130GHz2308cmEditField_3Label
            app.RadarfrequencyGHz130GHz2308cmEditField_3Label = uilabel(app.GridLayout8_3);
            app.RadarfrequencyGHz130GHz2308cmEditField_3Label.HorizontalAlignment = 'center';
            app.RadarfrequencyGHz130GHz2308cmEditField_3Label.WordWrap = 'on';
            app.RadarfrequencyGHz130GHz2308cmEditField_3Label.Layout.Row = 5;
            app.RadarfrequencyGHz130GHz2308cmEditField_3Label.Layout.Column = 1;
            app.RadarfrequencyGHz130GHz2308cmEditField_3Label.Text = 'Radar frequency (GHz) :        1.30 GHz → λ = 23.08 cm';

            % Create RadarfrequencyGHz130GHz2308cmEditField_3
            app.RadarfrequencyGHz130GHz2308cmEditField_3 = uieditfield(app.GridLayout8_3, 'numeric');
            app.RadarfrequencyGHz130GHz2308cmEditField_3.Layout.Row = 5;
            app.RadarfrequencyGHz130GHz2308cmEditField_3.Layout.Column = 2;

            % Create SamplesperwavelengthEditField_3Label
            app.SamplesperwavelengthEditField_3Label = uilabel(app.GridLayout8_3);
            app.SamplesperwavelengthEditField_3Label.HorizontalAlignment = 'center';
            app.SamplesperwavelengthEditField_3Label.Layout.Row = 6;
            app.SamplesperwavelengthEditField_3Label.Layout.Column = 1;
            app.SamplesperwavelengthEditField_3Label.Text = 'Samples per wavelength (-):';

            % Create SamplesperwavelengthEditField_3
            app.SamplesperwavelengthEditField_3 = uieditfield(app.GridLayout8_3, 'numeric');
            app.SamplesperwavelengthEditField_3.Layout.Row = 6;
            app.SamplesperwavelengthEditField_3.Layout.Column = 2;

            % Create NumberofsamplesEditFieldLabel
            app.NumberofsamplesEditFieldLabel = uilabel(app.GridLayout8_3);
            app.NumberofsamplesEditFieldLabel.HorizontalAlignment = 'center';
            app.NumberofsamplesEditFieldLabel.Layout.Row = 7;
            app.NumberofsamplesEditFieldLabel.Layout.Column = 1;
            app.NumberofsamplesEditFieldLabel.Text = 'Number of samples';

            % Create NumberofsamplesEditField
            app.NumberofsamplesEditField = uieditfield(app.GridLayout8_3, 'numeric');
            app.NumberofsamplesEditField.Layout.Row = 7;
            app.NumberofsamplesEditField.Layout.Column = 2;

            % Create SelectprofileDropDownLabel
            app.SelectprofileDropDownLabel = uilabel(app.GridLayout8_3);
            app.SelectprofileDropDownLabel.HorizontalAlignment = 'center';
            app.SelectprofileDropDownLabel.Layout.Row = 8;
            app.SelectprofileDropDownLabel.Layout.Column = 1;
            app.SelectprofileDropDownLabel.Text = 'Select profile';

            % Create SelectprofileDropDown
            app.SelectprofileDropDown = uidropdown(app.GridLayout8_3);
            app.SelectprofileDropDown.Items = {'__Generate profilesfirst__'};
            app.SelectprofileDropDown.Layout.Row = 8;
            app.SelectprofileDropDown.Layout.Column = 2;
            app.SelectprofileDropDown.Value = '__Generate profilesfirst__';

            % Create PolarizationDropDown_2Label
            app.PolarizationDropDown_2Label = uilabel(app.GridLayout8_3);
            app.PolarizationDropDown_2Label.HorizontalAlignment = 'center';
            app.PolarizationDropDown_2Label.Layout.Row = 10;
            app.PolarizationDropDown_2Label.Layout.Column = 1;
            app.PolarizationDropDown_2Label.Text = 'Polarization:';

            % Create PolarizationDropDown_2
            app.PolarizationDropDown_2 = uidropdown(app.GridLayout8_3);
            app.PolarizationDropDown_2.Items = {'TE', 'TM'};
            app.PolarizationDropDown_2.Layout.Row = 10;
            app.PolarizationDropDown_2.Layout.Column = 2;
            app.PolarizationDropDown_2.Value = 'TE';

            % Create GridLayout9_3
            app.GridLayout9_3 = uigridlayout(app.GridLayout7_3);
            app.GridLayout9_3.ColumnWidth = {'1x'};
            app.GridLayout9_3.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout9_3.Layout.Row = 2;
            app.GridLayout9_3.Layout.Column = 1;

            % Create CalculateButton_2
            app.CalculateButton_2 = uibutton(app.GridLayout9_3, 'push');
            app.CalculateButton_2.ButtonPushedFcn = createCallbackFcn(app, @CalculateButton_2Pushed, true);
            app.CalculateButton_2.Layout.Row = 1;
            app.CalculateButton_2.Layout.Column = 1;
            app.CalculateButton_2.Text = 'Calculate';

            % Create ClearButton_2
            app.ClearButton_2 = uibutton(app.GridLayout9_3, 'push');
            app.ClearButton_2.ButtonPushedFcn = createCallbackFcn(app, @ClearButton_2Pushed, true);
            app.ClearButton_2.Layout.Row = 2;
            app.ClearButton_2.Layout.Column = 1;
            app.ClearButton_2.Text = 'Clear';

            % Create ExportButton_2
            app.ExportButton_2 = uibutton(app.GridLayout9_3, 'push');
            app.ExportButton_2.ButtonPushedFcn = createCallbackFcn(app, @ExportButton_2Pushed, true);
            app.ExportButton_2.Layout.Row = 3;
            app.ExportButton_2.Layout.Column = 1;
            app.ExportButton_2.Text = 'Export';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1firstversion_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            runStartupFcn(app, @startupFcn) 

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end