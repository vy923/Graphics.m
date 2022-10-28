%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       [ax,fig] = XFIG(opts)
%
%       Produces an empty plot with axis and figure handles 'ax', 'fig'
%
%       See also:       grootMod, v2string, mustBeStartString, mustBeMemberSCI
%       External:       v2struct
%
%   INPUTS
%       opts{:}         name-value pairs
%           n           figure number
%           x/y         x/y-axis scale, 'lin'/0/'' or 'log'/1, default = 'lin'
%           xy          x- and y- axis scale, e.gclc. xy=1 is shorthand for x='log', y='log' 
%           b           box, ''/0/'off' or 1/'on', default = 'off' 
%           h           hold, ''/0/'off' or 1/'on', default = 'on' 
%           g/gm        grid/minor grid, ''/0/'off' or 1/'on', default = 'on'
%           fs          font size, default = []
%           grootFlag   same as 'flag' in grootMod(flag), default = ''
%
%   UPDATES
%       - clean-up inputs section
%       - axis auto tight equivalent for x, tickaligned for y
%       - expand to 3D
%       - option to replace/update plot with or without n
%           - default: replace/generate new
%           - option 1: update with entirely new settings like in new call
%           - option 2: update only the settings in the call -> persistent copy of opts
%       - define presets, e.g. for matlab -> .svg -> .docx 
%
%   VERSION
%       v1.1 / 29.06.22 / V.Yotov
%  ------------------------------------------------------------------------------------------------

function [ax,fig] = xfig(opts)

arguments
    opts.n {mustBeScalarOrEmpty,mustBeInteger} = []
    opts.b {mustBeMemberSCI(opts.b,["","0","off","1","on"])} = 'off'
    opts.h {mustBeMemberSCI(opts.h,["","0","off","1","on"])} = 'on'
    opts.x {mustBeMemberSCI(opts.x,["","0","lin","1","ln","log"])} = 'lin'
    opts.y {mustBeMemberSCI(opts.y,["","0","lin","1","ln","log"])} = 'lin'
    opts.xy {mustBeMemberSCI(opts.xy,["","0","lin","1","ln","log"])} = []
    opts.g {mustBeMemberSCI(opts.g,["","0","off","1","on","xy","x","y","2","b","both"])} = 'off'
    opts.gm {mustBeMemberSCI(opts.gm,["","0","off","1","on","xy","x","y"])} = 'off'
    opts.fs {mustBeScalarOrEmpty,mustBePositive} = []
    opts.grootFlag {mustBeStartString(opts.grootFlag,'reset')} = ''
end

% Unpack opts & set groot state 
    v2struct(opts)
    grootMod(grootFlag)

% Define multiple choice arrays
    arrOnOff    = ["","0","off"; "1","on","on"];
    arrLinLog   = ["","0","lin"; "1","ln","log"];
    arrRepAdd   = ["0","off","off","replace"; "","1","on","add"];
    arrGrid     = ["","0","off"; "1","xy","on"; repmat(["x";"y"],1,3); "2","both","b"];

% Input parsing, axis scale
    if ~isempty(xy)
        parseMultiChoice(arrLinLog,xy)
        [x,y] = deal(xy);
    else
        parseMultiChoice(arrLinLog,x,y)
    end

% Input parsing, grids
    [xg,yg,xgm,ygm] = deal('off');

    parseMultiChoice(arrGrid,g)
    switch lower(g)
        case 'x';   xg = 'on';
        case 'y';   yg = 'on';
        case 'b';   [xg,yg,gm] = deal('on');  
        otherwise   [xg,yg] = deal(g);
    end

    parseMultiChoice(arrGrid,gm)
    switch lower(gm)
        case 'x';   xgm = 'on';
        case 'y';   ygm = 'on';
        otherwise   [xgm,ygm] = deal(gm);
    end

% Input parsing, misc   
    parseMultiChoice(arrOnOff,b)
    parseMultiChoice(arrRepAdd,h)

% Create empty figure
    if ~isempty(n) && n>=1
        fig = figure(n);
    else
        fig = figure;
    end

% Apply defined formatting
    clf
    ax = axes(  'Units', 'normalized', ...                                          % groot default is 'normalized'
                'FontSize', 10.0, ...                                               % groot default is 10 
                'XScale', x, ...
                'YScale', y, ...
                'NextPlot', h, ...
                'Box', b, ...
                'XGrid', xg, ...
                'YGrid', yg, ...
                'XMinorGrid', xgm, ...
                'YMinorGrid', ygm, ...
                'GridAlpha', 0.12, ...
                'MinorGridLineStyle', '-', ...
                'MinorGridAlpha', 0.05          );                                          

    set(ax,'LooseInset',get(ax,'TightInset'));


%  ------------------------------------------------------------------------------------------------

function parseMultiChoice(arr,varargin)

    v2string(varargin)
    sz1 = size(arr,1);

    for i = 1:numel(varargin)
        [chk,idxlin] = ismember(lower(varargin{i}),lower(arr));
        if chk
            idxrow = rem(idxlin,sz1);
            idxrow = idxrow + (idxrow==0)*sz1;
            assignin('caller',inputname(i+1),arr(idxrow,end))
        end
    end
    
%  ------------------------------------------------------------------------------------------------





















