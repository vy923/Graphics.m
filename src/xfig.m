function [ax,fig] = xfig(opts)
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       [ax,fig] = XFIG(opts)
%
%       See also:       grootMod, v2string, mustBeSubsOrM, mustBeMemberSCI
%       External:       v2struct
%
%   INPUTS
%       opts{:}
%           ax          exisiting axes/figure/tiledlayout object
%           layers      number of nested layers of tiledlayout axes to update
%           n           figure number
%           c           clear axes, [default:'0']
%           h           hold, [default:'on']  
%           x/y/z       x/y-axis scale, [default:'lin']
%           xy          shorthand for x=a, y=a
%           xyz         shorthand for x=a, y=a, z=a
%           b           box, [default:'off'] 
%           g           grid, [default:'off']        
%           gm          minor grid, [default:'off'] 
%           grootflag   same as 'flag' in grootMod(flag), default = ''
%
%   UPDATES
%       - tick alignment/visibility
%       - tex option for all text [req. recursive struct traverse]
%
%   VERSION
%   v1.3 / 05.11.22 / --    3d plots / nested tiledlayout support, opts applied to leayers=<num> /
%                           enhanced input handling / c=<0/1> reset axes option / examples
%   v1.2 / 03.11.22 / --    ax=<axis/figure/tiledlayout> updates or creates axes as necessary
%   v1.1 / 29.06.22 / V.Y.  wrapper for FIGURE with shortcuts and GROOTMOD
%  ------------------------------------------------------------------------------------------------

arguments
    opts.ax = []
    opts.grootflag = string.empty
    opts.n {mustBeScalarOrEmpty,mustBeInteger} = []
    opts.c {mustBeMemberSCI(opts.c,["","0","off","1","on"])} = "off"
    opts.b {mustBeMemberSCI(opts.b,["","0","off","1","on"])} = "off"
    opts.h {mustBeMemberSCI(opts.h,["","0","off","1","on"])} = "on"
    opts.x {mustBeMemberSCI(opts.x,["","0","lin","1","ln","log"])} = "lin"
    opts.y {mustBeMemberSCI(opts.y,["","0","lin","1","ln","log"])} = "lin"
    opts.z {mustBeMemberSCI(opts.z,["","0","lin","1","ln","log"])} = "lin"
    opts.xy {mustBeMemberSCI(opts.xy,["","0","lin","1","ln","log"])} = []
    opts.xyz {mustBeMemberSCI(opts.xyz,["","0","lin","1","ln","log"])} = []
    opts.g {mustBeSubsOrM(opts.g,"xyz",["0","off","1","on","2","b","all"],0,[1 1 0])} = "off"
    opts.gm {mustBeSubsOrM(opts.gm,"xyz",["0","off","1","on"],0,[1 1 0])} = "off"
    opts.layers (1,1) {mustBeNonnegative} = 0
end

% Unpack opts & set groot state 
    v2struct(opts)
    grootMod(grootflag)

% Define multiple choice arrays
    arrOnOff    = ["","0","off"; "1","on","on"];
    arrLinLog   = ["","0","lin"; "1","ln","log"];
    arrRepAdd   = ["0","off","off","replace"; "","1","on","add"];
    arrGrid     = ["0","0","off"; "1","on","on"; "2","b","all"];

% Axis scales
    if ~isempty(xyz)
        parseMultiChoice(arrLinLog,xyz)
        [x,y,z] = deal(xyz);
    elseif ~isempty(xy)
        parseMultiChoice(arrLinLog,xy,z)
        [x,y] = deal(xy);
    else
        parseMultiChoice(arrLinLog,x,y,z)
    end

% Grids, precedence 'xyz' > gm > g
    gv = false(3,2);
    parseMultiChoice(arrGrid,g,gm)
    switch g
        case "off"
        case "on",  gv(:,1) = true;
        case "all", gv(:,:) = true;
        otherwise,  gv(:,1) = ismemberLoc('xyz',opts.g);
    end
    switch gm
        case "off", gv(:,2) = false;
        case "on",  gv(:,2) = true;
        otherwise,  gv(:,2) = ismemberLoc('xyz',opts.gm);
    end
    gv = boolSwap(gv,["on" "off"]);

% Misc. input parsing
    parseMultiChoice(arrOnOff,b,c)
    parseMultiChoice(arrRepAdd,h)
    clearax = c=="on";

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
            ax = getAxisArray([],fig,'figure',layers);
        otherwise, error('xfig: ax must be Axes, Figure, TiledChartLayout or empty') 
    end

% Clear if required
    if clearax
        arrayfun(@(i)cla(ax(i),'reset'),1:numel(ax))
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
        ax(i).XGrid = gv(1);
        ax(i).YGrid = gv(2);
        ax(i).ZGrid = gv(3);
        ax(i).XMinorGrid = gv(4);
        ax(i).YMinorGrid = gv(5);
        ax(i).ZMinorGrid = gv(6);
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

function mask = ismemberLoc(compArr,A)
    mask = ismember(compArr,char(lower(A)));

%  ------------------------------------------------------------------------------------------------

function y = boolSwap(x,vals)
    y(x)=vals(1); y(~x)=vals(2); y=reshape(y,size(x));

    
%  ------------------------------------------------------------------------------------------------
%{
% EXAMPLE 1A, no change of properties on uninitialised axes
    figure(1);
    t = tiledlayout(3,3);
    nexttile(t,5,[2 2]);
    nexttile(t,4,[1 2]);
    xfig(ax=t,b=1);

    figure(2);
    g = tiledlayout(3,3);
    arrayfun(@(i)nexttile(g,i),1:(prod(g.GridSize)-1))
    [ax,fig] = xfig(ax=g,b=0)

% EXAMPLE 1B, precedence of grid specs, i.e. gm > g
    figure(3);
    e = tiledlayout(3,3);
    [ax,fig] = xfig(ax=e,b=1,g=2,gm='y')

% EXAMPLE 1C: reset g=2, b=1 settings on second xfig call with log y-axis, g=0
    xfig(n=4);
    fplot({@(x)exp(x),@(x)exp(.6*x)},[0,15])
    xfig(ax=gcf,g=2,b=1);
    xfig(ax=gca,g=0,y=1); legend;

% EXAMPLE 2, tiles, 3d plots, tikz-like axes, non-standard colors
    t = tiledlayout(4,3);
    ax = [arrayfun(@(i)nexttile(t,i),[1:4 5 8 9 12]) nexttile(t,6,[2 2])];
    
    xfig(ax=ax,b=1,g=0);
    arrayfun(@(i)fplot(ax(i),{@(x)sinc(x),@(x)sinc(.7*x)},[-i,i]),1:8);
    
    scatter3(randi(10,5),randi(10,5),randi(10,5),markeredgecolor=col('atomictangerine'))
    xfig(ax=ax(end),b=0,g=1); 
    ax(end).View=[140 35]; 
    tikzStyleAxes(gca);

% EXAMPLE 3, fractal tiles, hidden ticks, export to vector formats
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

    xfig(ax=gcf,b=1,layers=inf);    % apply settings to all layers below t(3)
    xfig(ax=t(3),g=2,layers=3);     % apply to max 3 layers below t(3)

    exportgraphics(gcf,'fractal.pdf','contenttype','vector')
    print(gcf,'-dsvg','fractal')
%}
%  ------------------------------------------------------------------------------------------------


















