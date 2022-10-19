%{
-------------------------------------
    Vladimir V. Yotov
    Te Pūnaha Ātea Space Institute
    University of Auckland

    Version: 01.03.2022
-------------------------------------

NOTES
    Creates a time domain rotating force signal from a ramped sweep
    Force is proportional to omega^2, equals 1 at 1 Hz by default
%}

% Sweep settings
vars = {    5.0             30                                              % freq. range
            'output'        [0]                                             % only "acceleration"
            'sampleRate'    200
            'rampOffset'    false
            'rampCycles'    30
            'rampOrder'     -1
            'sweepType'     'log'
            'limCond'       inf
            'sweepRate'     30
        }'; 

% Axial force components
[Fx,t,f,R] = sineSweep(vars{:},'phaseShift',0);
[Fy,~,~,~] = sineSweep(vars{:},'phaseShift',0.5*pi);

% Scale force
F = [Fx(:,1) Fy(:,1)];
F = F.*f.^2;

% Write to text file 
textout(num2str([t F]),'timeData.dat');

% x,y components plot
grootMod()
fig(1) = figure(1);
    clf
    ax(1) = axes();
    set(ax(1),'LooseInset',ax(1).TightInset)
    set(ax(1),'FontSize',11.5)
    hold on

    plot(f,F(:,1))
    plot(f,F(:,2))

    lgd(1) = legend;
    lgd(1).String = {'$F_x$' '$F_y$'};
    ax(1).XLabel.String = 'Frequency';
    ax(1).YLabel.String = 'Amplitude';

% 3D plot
fig(2) = figure(2);
    clf
    ax(2) = axes('Units', 'normalized','Position',[.06 .06 .89 .94]);
    set(ax(2),'TickDir','in','TickLength',[0.01 0.015]);
    set(ax(2),'View',[45 20]);
    rotate3d on
    hold on 
    box off
    grid on
    warning off

    idx0 = 1:R.nR;
    idx1 = R.nR:length(f);
    plot3(F(idx0,1),F(idx0,2),f(idx0),'color',col('rc'))
    plot3(F(idx1,1),F(idx1,2),f(idx1),'color',col('bc'))

    ax(2).XLabel.String = '$F_y$';
    ax(2).YLabel.String = '$F_x$';
    ax(2).ZLabel.String = 'Frequency';

% exportgraphics(fig(2),'3D.pdf','ContentType','vector');
% exportgraphics(fig(1),'Fx,Fy,2D.pdf','ContentType','vector');






