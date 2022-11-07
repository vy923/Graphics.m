function grootMod(flag)
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       grootMod()          changes global (groot) object properties as reqired in 'rep' array
%       grootMod(false)     recovers defaults given in col 2 of 'rep'
%
%       See also:           col
%       Related:            xfig
%
%   VERSION
%   v2.0 / 06.11.22 / --    rep string -> cell / flag string -> bool or missing / updated code
%   v1.4 / 03.10.22 / --    tiledlayout element order row -> column major
%   v1.3 / 27.06.22 / --    added 'hold on' equivalent, code clean-up
%   v1.2 / 26.06.22 / --    checks required vs. current state to avoid recomputation
%   v1.1 / 13.02.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

% Validation
if nargin < 1 || isempty(flag) || ismissing(flag)
    flag = true;
else, mustBeMember(flag,[0 1])
end
persistent state rep

% Assign on first function call
if isempty(state) 
    state = false;
    rep = { "FontName"                  "Helvetica"                 "Times"
            "FontName"                  "MS Sans Serif"             "Monospaced"
            "Interpreter"               "tex"                       "latex" 
            "TiledlayoutPadding"        "loose"                     "none"
            "TiledlayoutTileSpacing"    "loose"                     "tight"
            "TiledlayoutTileIndexing"   "rowmajor"                  "columnmajor"
            "AxesNextPlot"              "replace"                   "add"           
            "BackgroundColor"           [0.9400 0.9400 0.9400]      col('w')
            "FigureColor"               [0.9400 0.9400 0.9400]      col('w')            }; 
end

% Change settings if required
if state~=flag
    s = get(groot,'factory');                                                           % Property strucure
    f = string(fieldnames(s));                                                          % String array of field names 
    
    for k = 1:size(rep,1)                                                               % Loop over repl rows
        str = f(isSubstring(rep{k,1},f));
        for i = 1:numel(str)                                                            % Loop over property fields
            if isequaln(s.(str(i)),rep{k,2})
                strtmp = strrep(str(i),'factory','default');
                set(groot,strtmp,rep{k,2+flag});                                        % Replace if old value matches target, 2 = reset, 3 = mod
            end
        end
    end
    state = flag;                                                                       % update current groot state with last call's one
end























