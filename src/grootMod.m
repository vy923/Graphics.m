function grootMod(flag)
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       grootMod()          changes global (groot) object properties as reqired in 'rep' array
%       grootMod('reset')   recovers defaults given in col 2 of 'rep'
%                           can also be called with a substring of 'reset', e.g. 'RE'
%
%       See also:           mustBeStartString, isSubstring
%       Related:            xfig
%
%   VERSION
%   v1.4 / 03.10.22 / --    tiledlayout element order row -> column major
%   v1.3 / 27.06.22 / --    added 'hold on' equivalent, updated code
%   v1.2 / 26.06.22 / --    checks required vs. current state to avoid recomputation
%   v1.1 / 13.02.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

arguments 
    flag {mustBeStartString(flag,'reset')} = string.empty
end
reqState = isempty(flag);                                                               % required state, boolean

% Persistent variables
persistent lastState rep
if isempty(lastState)                                                                   % On first function call
    lastState = false;                                                                  % currently at default settings
end

          % name contains               old value               new value
if isempty(rep)
    rep = [ "FontName"                  "Helvetica"             "Times New Roman"
            "FontName"                  "MS Sans Serif"         "Monospaced"
            "Interpreter"               "tex"                   "tex" 
            "TiledlayoutPadding"        "loose"                 "none"
            "TiledlayoutTileSpacing"    "loose"                 "tight"
            "TiledlayoutTileIndexing"   "rowmajor"              "columnmajor"
            "AxesNextPlot"              "replace"               "add"           ]; 
end

% Change settings if required
if lastState~=reqState

    s = get(groot,'factory');                                                           % Property strucure
    f = string(fieldnames(s));                                                          % String array of field names
    
    for k = 1:size(rep,1)                                                               % Loop over repl rows
        str = f(isSubstring(rep(k,1),f));
        for i = 1:numel(str)                                                            % Loop over property fields
            if s.(str(i)) == rep(k,2)
                strtmp = strrep(str(i),'factory','default');
                set(groot, strtmp, rep(k,2+reqState));                                  % Replace if old value matches target, 2 = reset, 3 = mod
            end
        end
    end

    lastState = reqState;                                                               % update current groot setting state flag 
end


%  ------------------------------------------------------------------------------------------------
% Possible updates: 
% factoryFigurePaperPosition: [0.2500 2.5000 8 6]
% factoryFigurePaperSize: [8.5000 11]
% factoryFigurePaperUnits: 'inches'
% factoryFigurePosition: [200 200 600 500]
% factoryFigureUnits: 'pixels' -> 'points' or cm??

% axis auto tight // ax.XLimitMethod = 'padded'/'tickaligned'/'tight'
% fig.Position = [100 100 698 392].*[1, 1, 1.0, 1.0];  
% set(groot,'defaultLegendAutoUpdate','off') % or on?

% add opts for font change, etc.



