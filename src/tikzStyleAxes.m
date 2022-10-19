%{
-------------------------------------
    Vladimir V. Yotov
    Te Pūnaha Ātea Space Institute
    University of Auckland

    Version: 02.02.2022
-------------------------------------

DESCRIPTION
    Makes plot axis graphic in the same style as pgfplots default
    Hides the original axes
    Currently only for 3D

CALL, UPDATE
    atikz = tikzStyleAxes(ax) 
    ---- 
    clearObjects(atikz)         
    atikz = tikzStyleAxes(ax)

OUTPUTS
    atikz.XAxis.Line    x-axis long line patch
    atikz.XAxis.YTick   x-axis ticks in Y-direction patch array
    atikz.XAxis.ZTick   x-axis ticks in Z-direction patch array
    atikz.YAxis.Line    ...
    ...
    
EXT.PACKAGES
    'patchline' / Brett Shoelson 
    'clearObjects' / VY function
%}



function atikz = tikzStyleAxes(ax)
if ~exist('ax','var') || isempty(ax)
    ax = gca;
end

% [1xN] Tick locations 
tx = ax.XTick;
ty = ax.YTick;
tz = ax.ZTick;

% Tick length 
lims = [ ax.XAxis.Limits; ax.YAxis.Limits; ax.ZAxis.Limits ];   % [3x2] 
len  = ax.TickLength(2) * max(diff(lims,[],2));

% [2x1] axes crossover signs
sgnx = sign([   ax.XAxis.FirstCrossoverValue
                ax.XAxis.SecondCrossoverValue ]); % y,z crossovers
sgny = sign([   ax.YAxis.FirstCrossoverValue
                ax.YAxis.SecondCrossoverValue ]); % x,z crossovers
sgnz = sign([   ax.ZAxis.FirstCrossoverValue
                ax.ZAxis.SecondCrossoverValue ]); % y,x crossovers

% [2x1] lims indexing, +ve crossover = 2, -ve = 1
idxx = 2*(sgnx>0) + (sgnx<0);   
idxy = 2*(sgny>0) + (sgny<0);
idxz = 2*(sgnz>0) + (sgnz<0);

% Tick formatting options
optsTicks = { 'EdgeColor', col('l'), ...
              'LineStyle', '-', ...
              'EdgeAlpha', 1.0, ...
              'LineWidth', 0.6, ...         % TikZ default is 0.2
              'FaceAlpha', 0.0
             };

% Generate patchline tick objects for each axis
% Format is [x1 y1 z1;  x1 y1+len z1]
for i = 1:length(tx)
    atikz.XAxis.YTick(i) = ...
    patchline(  tx(i)*[1;1], ...
                lims(2,idxx(1)) - sgnx(1)*len*[0;1], ...
                lims(3,idxx(2))*[1;1], ...
                optsTicks{:} ...
                );
    atikz.XAxis.ZTick(i) = ...
    patchline(  tx(i)*[1;1], ...
                lims(2,idxx(1))*[1;1], ...
                lims(3,idxx(2)) - sgnx(2)*len*[0;1], ...
                optsTicks{:}...
                );    
end

for i = 1:length(ty)
    atikz.YAxis.XTick(i) = ... 
    patchline(  lims(1,idxy(1)) - sgny(1)*len*[0;1], ...
                ty(i)*[1;1], ...
                lims(3,idxy(2))*[1;1], ...
                optsTicks{:} ...
                );
    atikz.YAxis.ZTick(i) = ...
    patchline(  lims(1,idxy(1))*[1;1], ...
                ty(i)*[1;1], ...
                lims(3,idxy(2)) - sgny(2)*len*[0;1], ...
                optsTicks{:}...
                );    
end

for i = 1:length(tz)
    atikz.ZAxis.YTick(i) = ...
    patchline(  lims(1,idxz(2)) - sgnz(2)*len*[0;1], ...
                lims(2,idxz(1))*[1;1], ...
                tz(i)*[1;1], ...
                optsTicks{:} ...
                );
    atikz.ZAxis.ZTick(i) = ...
    patchline(  lims(1,idxz(2))*[1;1], ...
                lims(2,idxz(1)) - sgnz(1)*len*[0;1], ...
                tz(i)*[1;1], ...
                optsTicks{:}...
                );    
end

% Axes formatting options
optsAxes = {  'EdgeColor', col('k'), ...
              'LineStyle', '-', ...
              'EdgeAlpha', 1.0, ...
              'LineWidth', 0.8, ...         % TikZ default is 0.4
              'FaceAlpha', 0.0
             };

% Generate patchline axis objects for each axis
atikz.XAxis.Line = patchline(   lims(1,:)', ...
                                lims(2,idxx(1))*[1;1], ...
                                lims(3,idxx(2))*[1;1], ...
                                optsAxes{:} ...
                                );

atikz.YAxis.Line = patchline(   lims(1,idxy(1))*[1;1], ...
                                lims(2,:)', ...
                                lims(3,idxy(2))*[1;1], ...
                                optsAxes{:} ...
                                );

atikz.ZAxis.Line = patchline(   lims(1,idxz(2))*[1;1], ...
                                lims(2,idxz(1))*[1;1], ...
                                lims(3,:)', ...
                                optsAxes{:} ...
                                );

% Hide original axes
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off';
ax.ZAxis.Visible = 'off';




