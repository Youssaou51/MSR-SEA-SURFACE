function uix = createUixFallbacks()
    uix.VBox  = @(varargin) local_createBox('vbox', local_parseInputs(varargin{:}));
    uix.HBox  = @(varargin) local_createBox('hbox', local_parseInputs(varargin{:}));
    uix.Panel = @(varargin) local_createPanel(local_parseInputs(varargin{:}));

    function p = local_parseInputs(varargin)
        p = struct('Parent', []);
        if nargin==1 && iscell(varargin{1}), args = varargin{1}; else args = varargin; end
        for k=1:2:length(args)
            if k+1>length(args), break; end
            key = args{k}; val = args{k+1};
            if ischar(key)||isstring(key)
                if strcmpi(char(key),'Parent'), p.Parent = val; end
            elseif isstruct(key) && isfield(key,'Parent')
                p.Parent = key.Parent;
            end
        end
        if isempty(p.Parent), p.Parent = gcf; end
    end

    function h = local_createBox(~, p)
        h = uipanel('Parent', p.Parent, 'BorderType','none');
        gl = uigridlayout(h,[1 1]);
        gl.RowHeight = {'1x'};
        gl.ColumnWidth = {'1x'};
        h.UserData = gl;
    end

    function h = local_createPanel(p)
        h = uipanel('Parent', p.Parent, 'BorderType','etchedin');
    end
end
