function [ax,fig] = xfig(opts)
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
%       - tex option for all text
%       + expand to 3D
%       + call with figure
%       - clear axes option with default=false
%       - define presets, e.g. for matlab -> .svg -> .docx 
%       - call with ax=n?
%       + check if ax is figure containing tiledlayout
%       + call with ax=figure, subfigure array
%       - improve parsing of multi-choice inputs e.g. by decomposing strings
%       + works automatically with 'flow'
%
%   VERSION
%   v1.3 / xx.11.22 / --    3d plots [done], enhanced input handling [in progress], call w. ax=n
%   v1.2 / 03.11.22 / --    option ax=<axis object> updates existing axes [doc. in progress]
%   v1.1 / 29.06.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

arguments
    opts.ax = []                                                                            % checked in switch at end
    opts.grootFlag = string.empty                                                           % validated in grootMod call
    % opts.tex
    % opts.c        % clear axes
    opts.n {mustBeScalarOrEmpty,mustBeInteger} = []
    opts.b {mustBeMemberSCI(opts.b,["","0","off","1","on"])} = 'off'
    opts.h {mustBeMemberSCI(opts.h,["","0","off","1","on"])} = 'on'
    opts.x {mustBeMemberSCI(opts.x,["","0","lin","1","ln","log"])} = 'lin'
    opts.y {mustBeMemberSCI(opts.y,["","0","lin","1","ln","log"])} = 'lin'
    opts.z {mustBeMemberSCI(opts.z,["","0","lin","1","ln","log"])} = 'lin'
    opts.xy {mustBeMemberSCI(opts.xy,["","0","lin","1","ln","log"])} = []
    opts.xyz {mustBeMemberSCI(opts.xyz,["","0","lin","1","ln","log"])} = []
    opts.g {mustBeMemberSCI(opts.g,["","0","off","1","on","xy","xyz","x","y","2","b","all"])} = 'off'
    opts.gm {mustBeMemberSCI(opts.gm,["","0","off","1","on","xy","xyz","x","y","z"])} = 'off'
    opts.layers (1,1) {mustBeNonnegative} = 0
end

% Unpack opts & set groot state 
    v2struct(opts)
    grootMod(grootFlag)

% Define multiple choice arrays
    arrOnOff    = ["","0","off"; "1","on","on"];
    arrLinLog   = ["","0","lin"; "1","ln","log"];
    arrRepAdd   = ["0","off","off","replace"; "","1","on","add"];
    arrGrid     = [ "","0","off"; "1","xyz","on"; repmat(["x";"y";"z";"xy"],1,3); "2","all","b"];

% Input parsing, axis scale
    if ~isempty(xyz)
        parseMultiChoice(arrLinLog,xyz)
        [x,y,z] = deal(xyz);
    elseif ~isempty(xy)
        parseMultiChoice(arrLinLog,xy,z)
        [x,y] = deal(xy);
    else
        parseMultiChoice(arrLinLog,x,y,z)
    end

% Input parsing, grids
    [xg,yg,zg,xgm,ygm,zgm] = deal('off');

    parseMultiChoice(arrGrid,g)
    switch lower(g)
        case 'x',   xg = 'on';
        case 'y',   yg = 'on';
        case 'z',   zg = 'on';
        case 'xy',  [xg,yg] = deal('on');                                                   % x/y major grids
        case 'b',   [xg,yg,zg,gm] = deal('on');                                             % all axes, minor + major grids
        otherwise   [xg,yg,zg] = deal(g);
    end

    parseMultiChoice(arrGrid,gm)
    switch lower(gm)
        case 'x',   xgm = 'on';
        case 'y',   ygm = 'on';
        case 'z',   zgm = 'on';
        case 'xy',  [xgm,ygm] = deal('on');
        otherwise,  [xgm,ygm,zgm] = deal(gm);
    end

% Input parsing, misc
    parseMultiChoice(arrOnOff,b)
    parseMultiChoice(arrRepAdd,h)

% Get/create figure for the axes
    if ~isempty(ax)
        fig = gcf;                                                                          % existing axis object                
    elseif ~isempty(n) && n>=1 
        fig = figure(n);                                                                    % specified target figure
    else
        fig = figure;                                                                       % next unused number
    end

% Get/create axes for the figure
    switch class(ax)
        case 'matlab.graphics.axis.Axes'                                                    % existing axes array, do nothing
        case 'matlab.ui.Figure'                                                             % variable ax contains a figure / subfigure / tiledlayout in figure
            ax = getAxisArray([],ax,'figure',layers);
        case 'matlab.graphics.layout.TiledChartLayout'
            ax = getAxisArray(ax,[],'tiled',layers);
        case 'double'
            fig
            ax = getAxisArray([],fig,'figure',layers);
        otherwise, error('xfig: ax must be Axes, Figure, TiledChartLayout or empty') 
    end

% Assign properties
    for i = 1:numel(ax)
        ax(i).Units = 'normalized';
        ax(i).FontSize = 10.0;
        ax(i).NextPlot = h;
        ax(i).Box = b;
        ax(i).XScale = x;
        ax(i).YScale = y;
        ax(i).ZScale = z;
        ax(i).XGrid = xg;
        ax(i).YGrid = yg;
        ax(i).ZGrid = zg;
        ax(i).XMinorGrid = xgm;
        ax(i).YMinorGrid = ygm;
        ax(i).ZMinorGrid = zgm;
        ax(i).GridAlpha = 0.12;
        ax(i).MinorGridLineStyle = '-';
        ax(i).MinorGridAlpha = 0.05;
        ax(i).LooseInset = ax(i).TightInset;
    end


%  ------------------------------------------------------------------------------------------------

function parseMultiChoice(arr,varargin)

    v2string(varargin)                                                                      % convert varargin from cell to string
    sz1 = size(arr,1);

    for i = 1:numel(varargin)                                                               % e.g. parseMultiChoice(arrLinLog,x,y,z)
        [chk,idxlin] = ismember(lower(varargin{i}),lower(arr));
        if chk
            idxrow = rem(idxlin,sz1);
            idxrow = idxrow + (idxrow==0)*sz1;
            assignin('caller',inputname(i+1),arr(idxrow,end))
        end
    end

%  ------------------------------------------------------------------------------------------------

function ax = getAxisArray(ax,fig,type,layers)

    switch type
        case 'tiled'
            t = ax; g = t.GridSize;
            if ~isempty(t.Children)
                ax = getAxes(t,layers);                                                     % only apply formatting to existing tiles, max 'rec' nested layers
            else 
                ax = arrayfun(@(i)nexttile(t,i),1:prod(g));                                 % initialise with same size as the tiledlayout grid
            end
            if prod(g) == numel(getAxes(t,layers))
                ax = reshape(ax,g);
            end
        case 'figure'
            if isempty(fig.Children)
                ax = axes(fig);                                                             % create axes for the figure
            elseif isa(fig.Children,'matlab.graphics.layout.TiledChartLayout') 
                ax = getAxisArray(fig.Children,[],'tiled',layers);                          % single recursive call as 'tiled'
            else
                ax = getAxes(fig,layers);                                                   % get existing axes of nonempty figure
            end
    end

%  ------------------------------------------------------------------------------------------------

function ax = getAxes(fig,layers)

    ax = findobj(fig.Children,'type','Axes','-depth',layers);

%  ------------------------------------------------------------------------------------------------


%{
% ---------------------------

figure(1);
    t = tiledlayout(3,3);
    nexttile(t,5,[2 2]);
    nexttile(t,4,[1 2]);
    % arrayfun(@(i)nexttile(t,i),1:3)
    xfig(ax=t,b=1);

figure(2);
    g = tiledlayout(3,3);
    arrayfun(@(i)nexttile(g,i),1:(prod(g.GridSize)-1))
    [ax,fig] = xfig(ax=g,b=0)

figure(3);
    e = tiledlayout(3,3);
    [ax,fig] = xfig(ax=e,b=1)

xfig(n=4);
    fplot({@(x)sinc(x),@(x)sinc(.7*x)},[-5,5])
    xfig(ax=gcf,g=2,b=1);
    xfig(ax=gca,g=0);

% ---------------------------

    t = tiledlayout(4,3);
    ax = [arrayfun(@(i)nexttile(t,i),[1:4 5 8 9 12]) nexttile(t,6,[2 2])];
    
    xfig(ax=ax,b=1,g=0);
    arrayfun(@(i)fplot(ax(i),{@(x)sinc(x),@(x)sinc(.7*x)},[-i,i]),1:8);
    
    scatter3(randi(10,5),randi(10,5),randi(10,5),markeredgecolor=col('atomictangerine'))
    xfig(ax=ax(end),b=0,g=1); 
    ax(end).View=[140 35]; 
    tikzStyleAxes(gca)

% ---------------------------

k = 4; 
n = 8;
for i = 1:n
    if i==1
        t(i) = tiledlayout(k,k);
    else 
        t(i) = tiledlayout(t(i-1),k,k);
        t(i).Layout.Tile = k+2;
        t(i).Layout.TileSpan = [k-1 k-1];
    end
    if i~=n
        vec = [1:k k+1:k:k^2];
    else
        vec = 1:k^2;
    end
    ax = arrayfun(@(d)nexttile(t(i),d),vec);
    arrayfun(@(d)set(ax(d),'xticklabel',[],'yticklabel',[],'TickLength',[0,0]),1:numel(ax));
    arrayfun(@(d)fplot(ax(d),{@(x)sinc(x),@(x)sinc(.7*x)},[-d,d]),1:numel(ax))
end
xfig(ax=gcf,b=1,layers=inf);
xfig(ax=t(3),g=2,layers=3);
exportgraphics(gcf,'figvec.pdf','contenttype','vector')

% ---------------------------

%}



















