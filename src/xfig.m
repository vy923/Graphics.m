function [ax,fig] = xfig(obj,opts)
%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       [ax,fig] = XFIG(opts)
%
%       See also:       grootMod, s2vars, mustBeSubsOrM, mustBeMemberSCI, cvec
%
%   INPUTS
%       opts{:}
%           ax          exisiting axes/figure/tiledlayout object
%           layers      number of nested layers of tiledlayout axes to update
%           n           figure number
%           c           clear axes, [default:false]
%           h           hold, [default:true]  
%           x/y/z       x/y-axis scale, [default:'lin']
%           xy          shorthand for x=a, y=a
%           xyz         shorthand for x=a, y=a, z=a
%           b           box, [default:false] 
%           g           grid, [default:false]        
%           gm          minor grid, [default:false] 
%           axc         [-] axis color
%           r3d         [-] rotate3d
%           e           [-] export, svg / pdf / pdf<num>
%           xta/yta/zta [-] x/y/z tick alignment
%           ta          [-] tick alignment
%           tex         [-] latex -> tex rendering *[req. recursive struct traverse]
%           (reset?)    [-] reset to default XFIG formatting
%           (mem?)      [-] ignore presence of axes in memory
%           tikz        [-] tikz-style 2D/3D axes *[req. callback function]
%           gmod        grootMod required state [default:true]
%
%   VERSION
%   v2.1 / xx.11.22 / --    axis color [-] / export [-] / tick alignment [-] / tex interpreter [-] /
%                           rotate3d [-] / export [-] / reset XFIG formatting [-] / clear without 
%                           resetting formatting [-] / tiledlayout vector obj [-] / vector obj [-] / 
%                           PolarAxes [+] / code mod: class-based assignment axis fields [+] / bugfix in 
%                           hierarchical assignments, e.g. minor grid [+]
%   v2.0 / 07.11.22 / --    ax=<obj> kwarg replaced by optional obj=<axes/figure/tiledlayout/integer> /
%                           new calls do not overwrite existing XFIG axis settings /  
%                           bool inputs for binary switches / performance improvements 
%   v1.3 / 05.11.22 / --    3d plots / nested tiledlayout support, opts applied to leayers=<num> /
%                           enhanced input handling / c=<0/1> reset axes option / examples
%   v1.2 / 03.11.22 / --    ax=<axis/figure/tiledlayout> updates or creates axes as necessary
%   v1.1 / 29.06.22 / V.Y.  wrapper for FIGURE with shortcuts and GROOTMOD
%  ------------------------------------------------------------------------------------------------

arguments(Repeating)
    obj
end
arguments
    opts.gmod
    opts.n {mustBeScalarOrEmpty,mustBeInteger}
    opts.c {mustBeMemberSCI(opts.c,["0","false","off","1","true","on"])}
    opts.b {mustBeMemberSCI(opts.b,["0","false","off","1","true","on"])}
    opts.h {mustBeMemberSCI(opts.h,["0","false","off","1","true","on"])}
    opts.x {mustBeMemberSCI(opts.x,["0","false","lin","1","true","log"])}
    opts.y {mustBeMemberSCI(opts.y,["0","false","lin","1","true","log"])}
    opts.z {mustBeMemberSCI(opts.z,["0","false","lin","1","true","log"])}
    opts.xy {mustBeMemberSCI(opts.xy,["0","false","lin","1","true","log"])}
    opts.xyz {mustBeMemberSCI(opts.xyz,["","0","false","lin","1","true","log"])}
    opts.g {mustBeSubsOrM(opts.g,"xyz",["0","off","false","1","true","on","2","b","all"],0,[1 1 0])}
    opts.gm {mustBeSubsOrM(opts.gm,"xyz",["0","off","false","1","true","on"],0,[1 1 0])}
    opts.layers (1,1) {mustBeNonnegative} = 0
end

% Default settings
    persistent axmem def fn arrbool arrscale arrhold arrgrid
    if isempty(def)
        % Remembered axes
        axmem.class = ["c" "p"]; % Supported class fiednames
        axmem.obj = matlab.graphics.GraphicsPlaceholder;

        % Selectable, Cartesian
        def.s.c.NextPlot = "add";
        def.s.c.Box = "off";
        def.s.c.XScale = "lin";
        def.s.c.YScale = "lin";
        def.s.c.ZScale = "lin";
        def.s.c.XGrid = "off";
        def.s.c.YGrid = "off";
        def.s.c.ZGrid = "off";
        def.s.c.XMinorGrid = "off";
        def.s.c.YMinorGrid = "off";
        def.s.c.ZMinorGrid = "off";

        % Selectable, Polar
        def.s.p.NextPlot = "add";
        def.s.p.Box = "off";
        def.s.p.RGrid = "on";
        def.s.p.ThetaGrid = "on";
        def.s.p.RMinorGrid = "off";
        def.s.p.ThetaMinorGrid = "off"; 

        % Initial call, Cartesian
        def.i.c.Units = 'normalized';
        def.i.c.FontSize = 10;
        def.i.c.GridAlpha = 0.10;
        def.i.c.MinorGridAlpha = 0.05;
        def.i.c.MinorGridLineStyle = '-';

        % Initial call, polar 
        def.i.p.Units = 'normalized';
        def.i.p.FontSize = 10;
        def.i.p.GridAlpha = 0.12;
        def.i.p.MinorGridAlpha = 0.05;
        def.i.p.MinorGridLineStyle = '-';
        def.i.p.TickLabelInterpreter = 'tex';                                                       % temporary, labels do not render with latex
    
        % Struct field names
        fn.s.c = string(fieldnames(def.s.c));
        fn.s.p = string(fieldnames(def.s.p));
        fn.i.c = string(fieldnames(def.i.c));
        fn.i.p = string(fieldnames(def.i.p));

        % Multi-choice arrays for argument parsing
        arrbool  = ["0","false","off"; "1","true","on"];
        arrscale = ["0","false","lin"; "1","true","log"];
        arrhold  = ["0","false","off","replace"; "1","true","on","add"];
        arrgrid  = ["0","false","off"; "1","true","on"; "2","b","all"];
    end

% Assign all selectable variables w/o defaults as <missing>
    [gmod,n,c,b,h,x,y,z,xy,xyz,g,gm] = deal(missing);

% Unpack inputs, overwriting non-missing vars, set groot
    s2vars(opts)
    grootMod(gmod)

% Get/create figure and axes
    if isempty(obj)
        fig = gcfLoc(n);
    else 
        obj = obj{1};
        switch class(obj)
            case 'double'                                                                           % xfig(6,)
                fig = gcfLoc(obj);                                                                  % specified target / xfig(n=6,)
            case 'matlab.graphics.axis.Axes'                                                        % xfig(gca,)
                ax = obj; 
                fig = gcf;
            case 'matlab.graphics.axis.PolarAxes'
                ax = obj; 
                fig = gcf;
            case 'matlab.ui.Figure'                                                                 % xfig(gcf,)
                fig = obj;
            case 'matlab.graphics.layout.TiledChartLayout'                                      
                fig = gcf;
                ax = getAxesArray(obj,[],'tiled',layers);
            otherwise
                error('xfig: obj must be <axes/figure/tiledlayout/integer/empty>')
        end 
    end
    if ~exist('ax','var')
        ax = getAxesArray([],fig,'figure',layers); 
    end
    ax = cvec(ax(:));                                                                               % Flatten

% Update existing and remebered axis handles
    axmem.obj(~isgraphics(axmem.obj)) = [];                                                         % handles list
    maskax = ismember(ax,axmem.obj);                                                                % current call axes that are on list
    axclass = getAxesClass(ax);                                                                     % class list of current axes
    axmem.obj = [axmem.obj; ax(~maskax)];                                                           % update axes list

% Axis scales, precedence x/y/z > xy > xyz
    parseMultiChoice(arrscale,x,y,z,xy,xyz)
    
    tmp = [x y z];
    xyz = repmat(string(xyz),1,3);
    xyz(~ismissing([xy xy])) = xy;
    xyz(~ismissing(tmp)) = tmp(~ismissing(tmp));

% Grids, precedence 'xyz' > gm > g
    gv = repmat(string(missing),3,2);
    parseMultiChoice(arrgrid,g,gm)

    if ~ismissing(g)
        switch g
            case "off", gv(:,:) = "off";
            case "on",  gv(:,1) = "on";
            case "all", gv(:,:) = "on";
            otherwise,  gv(:,1) = boolSwap(ismemberLoc('xyz',g),["on" "off"]);
        end
    end
    if ~ismissing(gm)
        switch gm
            case "off", gv(:,2) = "off";
            case "on",  gv(:,2) = "on";
            otherwise,  gv(:,2) = boolSwap(ismemberLoc('xyz',gm),["on" "off"]);
        end
    end

% Box, cla, hold
    parseMultiChoice(arrbool,b,c)
    parseMultiChoice(arrhold,h)

% User-defined options, including <missing>, Cartesian/Polar
    inp.c.NextPlot = h;
    inp.c.Box = b;
    inp.c.XScale = xyz(1);
    inp.c.YScale = xyz(2);
    inp.c.ZScale = xyz(3);
    inp.c.XGrid = gv(1);
    inp.c.YGrid = gv(2);
    inp.c.ZGrid = gv(3);
    inp.c.XMinorGrid = gv(4);
    inp.c.YMinorGrid = gv(5);
    inp.c.ZMinorGrid = gv(6);

    inp.p.NextPlot = h;
    inp.p.Box = b;
    inp.p.RGrid = gv(1);
    inp.p.ThetaGrid = gv(2);
    inp.p.RMinorGrid = gv(4);
    inp.p.ThetaMinorGrid = gv(5); 
    
% Fields of property struct from current call
    for j = 1:numel(axmem.class)

        axc = axmem.class(j);
        maskinp = arrayfun(@(i)~ismissing(inp.(axc).(i)),fn.s.(axc));

        % Always update
        idx = find(maskinp);  
        idn = find(axclass==axc);

        for i = 1:numel(idn)
            id = idn(i);
            if c=="on" 
                cla(ax(id),'reset');
            end
            for k = 1:numel(idx)
                ax(id).(fn.s.(axc)(idx(k))) = inp.(axc).(fn.s.(axc)(idx(k)));                       % inputs available from current call
            end 
            ax(id).LooseInset = ax(id).TightInset;                                                  % always refresh
        end

        % Settings only assigned on first call
        idx = find(~maskinp);
        idn = find((~maskax | c=="on") & axclass==axc);                                             % reapply formatting if axes were cleared

        for i = 1:numel(idn)
            id = idn(i);
            for k = 1:numel(fn.i.(axc))
                ax(id).(fn.i.(axc)(k)) = def.i.(axc).(fn.i.(axc)(k));                               % defaults for e.g. FontSize
            end
            for k = 1:numel(idx)
                ax(id).(fn.s.(axc)(idx(k))) = def.s.(axc).(fn.s.(axc)(idx(k)));                     % values not in INP structure
            end
        end
        
    end


%  ------------------------------------------------------------------------------------------------

function parseMultiChoice(arr,varargin)

    len = size(arr,1);
    vs = lower(string(varargin));

    for i = 1:numel(vs)                                                                            % e.g. parseMultiChoice(arrLinLog,x,y,z)
        if ~ismissing(vs(i))
            [chk,idxlin] = ismember(vs(i),lower(arr));
            if chk
                idxrow = rem(idxlin,len);
                idxrow = idxrow + (idxrow==0)*len;
                assignin('caller',inputname(i+1),arr(idxrow,end))
            end
        end
    end

%  ------------------------------------------------------------------------------------------------

function ax = getAxesArray(ax,fig,type,layers)

    switch type
        case 'tiled'
            t = ax; g = t.GridSize;
            if ~isempty(t.Children)
                ax = getAxes(t,layers);                                                             % only apply formatting to existing tiles, max 'rec' nested layers
            else 
                ax = arrayfun(@(i)nexttile(t,i),1:prod(g));                                         % initialise with same size as the tiledlayout grid
            end
        case 'figure'
            if isempty(fig.Children)
                ax = axes(fig);                                                                     % create axes for the figure
            elseif isa(fig.Children,'matlab.graphics.layout.TiledChartLayout') 
                ax = getAxesArray(fig.Children,[],'tiled',layers);                                  % single recursive call as 'tiled'
            else
                ax = getAxes(fig,layers);                                                           % get existing axes of nonempty figure
            end
    end

%  ------------------------------------------------------------------------------------------------

function ax = getAxes(fig,layers)

    ax = [  cvec(findobj(fig.Children,'type','Axes','-depth',layers))
            cvec(findobj(fig.Children,'type','PolarAxes','-depth',layers))  ];

%  ------------------------------------------------------------------------------------------------

function c = getAxesClass(ax)

    c = string(repmat(missing,size(ax)));
    for i = 1:numel(ax)
        switch class(ax(i))
            case 'matlab.graphics.axis.Axes', c(i) = "c"; % Cartesian
            case 'matlab.graphics.axis.PolarAxes', c(i) = "p"; % Polar
            otherwise, error('xfig: only Cartesian and polar axes are supported')
        end
    end


%  ------------------------------------------------------------------------------------------------

function mask = ismemberLoc(comparr,A)

    if ismissing(A), mask = missing;
    else, mask = ismember(comparr,char(lower(A)));
    end

%  ------------------------------------------------------------------------------------------------

function y = boolSwap(x,vals) 
    y(x)=vals(1); y(~x)=vals(2); y=reshape(y,size(x));

%  ------------------------------------------------------------------------------------------------

function fig = gcfLoc(n)

    persistent g
    if isempty(g), g = groot; 
    end

    cf = g.CurrentFigure;
    if isempty(cf) || isempty(n) || cf.Number==n, fig = gcf;
    else, fig = figure; 
    end


%  ------------------------------------------------------------------------------------------------
%{
% EXAMPLE 1A, no change of properties on uninitialised axes
    figure(1);
    t = tiledlayout(3,3);
    nexttile(t,5,[2 2]);
    nexttile(t,4,[1 2]);
    xfig(t,b=1);

    figure(2);
    g = tiledlayout(3,3);
    arrayfun(@(i)nexttile(g,i),1:(prod(g.GridSize)-1))
    [ax,fig] = xfig(g,b=0)
    xfig(ax,g=2); % add grids

% EXAMPLE 1B, precedence of grid specs, i.e. gm > g
    xfig(3);
    e = tiledlayout(3,3);
    [ax,fig] = xfig(e,b=1,g=2,gm='y')

% EXAMPLE 1C: update settings in consecutive calls
    xfig(n=4);
    fplot({@(x)exp(x),@(x)exp(.6*x)},[0,15])
    xfig(gcf,g=1,b=1);
    xfig(gca,gm='xy',y=1); legend;

% EXAMPLE 2, tiles, 3d plots, tikz-like axes, non-standard colors
    t = tiledlayout(4,3);
    ax = [arrayfun(@(i)nexttile(t,i),[1:4 5 8 9 12]) nexttile(t,6,[2 2])];
    
    xfig(ax,b=1,g=0);
    arrayfun(@(i)fplot(ax(i),{@(x)sinc(x),@(x)sinc(.7*x)},[-i,i]),1:8);
    
    scatter3(randi(10,6),randi(10,6),randi(10,6),markeredgecolor=col('atomictangerine'))
    xfig(ax(end),b=0,g=1); 
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
        if i~=n, idx = [1:k k+1:k:k^2];
        else, idx = 1:k^2;
        end
        ax = arrayfun(@(d)nexttile(t(i),d),idx);
        arrayfun(@(d)set(ax(d),'xticklabel',[],'yticklabel',[],'TickLength',[0,0]),1:numel(ax));
        arrayfun(@(d)fplot(ax(d),{@(x)sinc(x),@(x)sinc(.7*x)},[-d,d]),1:numel(ax))
    end
    xfig(gcf,b=1,layers=inf);   % apply settings to all layers below t(3)
    xfig(t(3),g=2,layers=2);    % apply to max 2 layers below t(3)

    exportgraphics(gcf,'fractal.pdf','contenttype','vector')
    print(gcf,'-dsvg','fractal')

% EXAMPLE 4A, basic polar plot, then place in tiledlayout
    xfig(polaraxes,gm=1); 
    polarplot(sin(0:.01:2*pi),cos(0:.01:2*pi),color=col('rc'));

% EXAMPLE 4B, place polar axes in tiled layout
    t = tiledlayout(2,3);

    for i = 1:t(1).GridSize(2)
        t(i+1) = tiledlayout(t(1),1,1);
        t(i+1).Layout.Tile = t(1).GridSize(1) + i;

        set(xfig(polaraxes,gm=0),'Parent',t(i+1));
        polarplot(-1+2.5*i*sin(0:.01:2*pi),cos(2.5*i+(0:.01:2*pi)),color=col('dbc'));
        polarplot(-1+2.5*(1-.05/i^2)*i*sin(0:.01:2*pi),cos(2.5*(1-.05/i^2)*i+(0:.01:2*pi)),color=col('coolgrey'));

        xfig(nexttile(t(1)),b=0,gm=1); 
        fplot({@(x)sinc(x),@(x)sinc(.7*x)},[-3*i,3*i]);
    end

% EXAMPLE 5, apply xfig settings to a .fig loaded from file
    grootMod(false)  % reset to default 
    f=@(x)tanh(x).*sin(x.^2); figure; fplot({f,@(x)1.5*f(.5*x)},1.0*[-pi,pi]);  % plot some stuff
    savefig(gcf); pause(5); close;  % export figure
    xfig; close; xfig(openfig('untitled'),g=2);  % reopen with xfig

%}
%  ------------------------------------------------------------------------------------------------


















