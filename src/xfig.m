%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       [ax,fig] = XFIG(opts)
%
%       See also:       grootMod, v2string, mustBeStartString, mustBeMemberSCI
%       External:       v2struct
%
%   INPUTS
%       opts{:}         name-value pairs
%           ax          exisiting axes object
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
%       - tex opytion with grootMod fonts?
%       - expand to 3D
%       - clear axes option with default=false
%       - define presets, e.g. for matlab -> .svg -> .docx 
%
%   VERSION
%   v1.2 / 03.11.22 / --       option ax=<axis object> updates existing axes
%   v1.1 / 29.06.22 / V.Yotov
%  ------------------------------------------------------------------------------------------------

function [ax,fig] = xfig(opts)

arguments
    opts.ax = []                                                                            % checked in switch at end
    opts.grootFlag = string.empty                                                           % validated in grootMod call
    opts.n {mustBeScalarOrEmpty,mustBeInteger} = []
    opts.b {mustBeMemberSCI(opts.b,["","0","off","1","on"])} = 'off'
    opts.h {mustBeMemberSCI(opts.h,["","0","off","1","on"])} = 'on'
    opts.x {mustBeMemberSCI(opts.x,["","0","lin","1","ln","log"])} = 'lin'
    opts.y {mustBeMemberSCI(opts.y,["","0","lin","1","ln","log"])} = 'lin'
    opts.xy {mustBeMemberSCI(opts.xy,["","0","lin","1","ln","log"])} = []
    opts.g {mustBeMemberSCI(opts.g,["","0","off","1","on","xy","x","y","2","b","both"])} = 'off'
    opts.gm {mustBeMemberSCI(opts.gm,["","0","off","1","on","xy","x","y"])} = 'off'
    opts.fs {mustBeScalarOrEmpty,mustBePositive} = []
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
        case 'x',   xg = 'on';
        case 'y',   yg = 'on';
        case 'b',   [xg,yg,gm] = deal('on');  
        otherwise   [xg,yg] = deal(g);
    end

    parseMultiChoice(arrGrid,gm)
    switch lower(gm)
        case 'x',   xgm = 'on';
        case 'y',   ygm = 'on';
        otherwise,  [xgm,ygm] = deal(gm);
    end

% Input parsing, misc   
    parseMultiChoice(arrOnOff,b)
    parseMultiChoice(arrRepAdd,h)

% Get/create figure
    if ~isempty(ax)
        fig = gcf;                                                                          % existing axis object                
    elseif ~isempty(n) && n>=1 
        fig = figure(n);                                                                    % specified target figure
    else
        fig = figure;                                                                       % next unused number
    end

% Get/create axes array, autofill tiled
    switch class(ax)
        case 'matlab.graphics.axis.Axes'                                                    % do nothing
        case 'matlab.graphics.layout.TiledChartLayout'
            t = ax;
            g = t.GridSize;
            if ~isempty(t.Children)
                ax = t.Children;                                                            % only apply formatting to existing tiles
            else 
                ax = arrayfun(@(i)nexttile(t,i),1:prod(g));                                 % initialise with same size as the tiledlayout grid
            end
            if prod(g) == numel(findall(t.Children,'type','Axes'))
                ax = reshape(ax,g);
            end
        case 'double'
            if isempty(fig.Children) 
                ax = axes(fig);                                                             % create axes for the figure
            else 
                ax = fig.Children;                                                          % get existing axes of nonempty figure
            end
        otherwise, error('xfig: ax must be Axes, TiledChartLayout or empty') 
    end

% Set properties
    for i = 1:numel(ax)
        ax(i).Units = 'normalized';
        ax(i).FontSize = 10.0;
        ax(i).XScale = x;
        ax(i).YScale = y;
        ax(i).NextPlot = h;
        ax(i).Box = b;
        ax(i).XGrid = xg;
        ax(i).YGrid = yg;
        ax(i).XMinorGrid = xgm;
        ax(i).YMinorGrid = ygm;
        ax(i).GridAlpha = 0.12;
        ax(i).MinorGridLineStyle = '-';
        ax(i).MinorGridAlpha = 0.05;
        ax(i).LooseInset = ax.TightInset;
    end


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

%{
figure(1);
t = tiledlayout(3,3);
nexttile(t,5,[2 2]);
nexttile(t,4,[1 2]);
% arrayfun(@(i)nexttile(t,i),1:3)
xfig(ax=t,b=1);

figure(2);
g = tiledlayout(3,3);
arrayfun(@(i)nexttile(g,i),1:(prod(g.GridSize)-1))
[ax,fig] = xfig(ax=g,b=1)

figure(3);
e = tiledlayout(3,3);
[ax,fig] = xfig(ax=e,b=1)
%}



















