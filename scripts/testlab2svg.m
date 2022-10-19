%{
-------------------------------------
    Vladimir V. Yotov
    Te Pūnaha Ātea - Space Institute
    University of Auckland

    Version: 01.06.2022
    Update: 14.10.2022
-------------------------------------

DESCRIPTION
    plots a lot of things

REQUIRES
    grootMod.m
    col.m
    textin.m
    rgb2hex and hex2rgb

NEXT VERSIONS
    - auto export to Excel
    - make grootMod / fig calls use xfig
    - automate channel handling
    - Improve sine vibe limit style
    - add warnings to check channel order, label, etc.
    - modify to use .mat instead of .txt outputs
%}


% ------------------------------------------------------------------------
% Data
% ------------------------------------------------------------------------
%{
% Data [f y1 y2 ...]
locIn = 'C:\Users\vyot466\OneDrive - The University of Auckland\';
datIn = 'Code\Matlab\Plotting\Scripts\plotPSD\dat.txt';

dat = str2num(char(textin([locIn datIn])));

% Test limits [f spec yl yu]
lims = [    20	    0.026	12.1	67.8
            50	    0.16	188.1	1057.5
            800	    0.16	188.1	1057.5 
            2000    0.026   188.1	1057.5  ];  % ASD
%}

% clean
clear all
clc

% Paths
locRoot = 'C:\Users\vyot466\OneDrive - The University of Auckland\Desktop\';
locIn   = 'procTest\'; 
locOut  = 'procOut\';
xlsOut  = 'dataOut';

locIn   = [locRoot locIn];
locOut  = [locRoot locOut];

% File names
F = struct2cell(dir(locIn))';               % file data cell
F = string(F(:,1));                         % file names string 
F = F(contains(F,["SLIP" "VERT"]));         % Leave only ones containing test data

% figure name alignment, imag unit, etc.
padstr = @(s) pad(s,12,'_');
im = sqrt(-1);


% ------------------------------------------------------------------------
% Plot styles for Random, SRS
% ------------------------------------------------------------------------

% blank figure
global ax fig
genFig()

% line colors 
c.lims = col('coolgrey','hex');
c.spec = col('k','hex');
c.y(1) = col('dbc','hex');
c.y(2) = col('rc','hex');

opts.ref = {    'Color'         c.lims      c.spec  
                'LineStyle'     '-'         '-'
                'LineWidth'     0.0         1.7
            }';

opts.lgd = {    'FontSize'      ax.FontSize + 0.9
                'location'      'southeast'
                'LineWidth'     0.2
            }'; 

%%
% ------------------------------------------------------------------------
% SRS REF
% ------------------------------------------------------------------------
%{
genFig()

lims = [    100	    60	    12.1	67.8
            1000	2000	188.1	1057.5
            10000	2000	188.1	1057.5  ];

p.spec = plot(lims(:,1), lims(:,2), opts.ref{[1 3],:});

ax.XLabel.String = "Frequency [ Hz ]";
ax.YLabel.String = "Acceleration [ g ]";

ax.XLim = [50 20000];
ax.YLim = [10 10000];
legend('SRS, all axes', opts.lgd{:})

% Export
fig.Position(3:4) = 0.83*fig.Position(3:4); 
print('-painters','-dsvg',[locOut 'spec_SRS']);
%}


% ------------------------------------------------------------------------
% Random REF
% ------------------------------------------------------------------------
%
genFig()

ASD = tablePSD([
            20          0.026
            50          0.06
            150         0.06 
            300         0.02
            700         0.02
            800         0.06
            925         0.06
            2000        0.02
            ]);

p.spec = plot(ASD(:,1), ASD(:,2), opts.ref{[1 3],:});

ax.XLabel.String = "Frequency [ Hz ]";
ax.YLabel.String = "ASD [ g\textsuperscript{2}/Hz ]";

ax.XLim = [10 4000];
ax.YLim = [0.01 0.1];
legend('Reference spectrum, all axes', opts.lgd{:})

% Export
fig.Position(3:4) = 0.83*fig.Position(3:4); 
print('-painters','-dsvg',[locOut 'spec_Random']);
%}


%%
% ========================================================================
% Sine sweep comparisons
% ========================================================================
%
f = {   % old sweep                         % new sweep                     % Old run       % New run
% -----------------------------------------------------------------------------------------------------
        "VERT-Z_sweep_0.5g_R3.txt"          "VERT-Z_sweep_0.5g_R5.txt"      "Z1"            "Z5" 
% -----------------------------------------------------------------------------------------------------
        "SLIP-Y_sweep_0.5g_R3.txt"          "SLIP-Y_sweep_0.5g_R5.txt"      "Y1"            "Y5"      
% -----------------------------------------------------------------------------------------------------
        "SLIP-X_sweep_0.5g_R1.txt"          "SLIP-X_sweep_0.5g_R2.txt"      "X1"            "X5"
% -----------------------------------------------------------------------------------------------------
        };

% add physical channel order for both runs in cols 5,6
%f = [ f repmat({[10:-1:7]}, [size(f,1) 2]) ];    
f = [ f repmat({[2 3 4 1]}, [size(f,1) 2]) ];
f(3,5:6) = {[3 2 4 1] [3 2 4 1]};

% line styles
lw = [ 0.2  0.9  0.2 ];

opts.p1 = {     'Color'                             'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                rgb2hex(0.5*col('gainsboro'))       '-'             lw(1)           'C1 X'
                rgb2hex(0.9*col('rc'))              '-'             lw(1)           'C2 Y'
                col('bc')                           '-'             lw(1)           'C3 Z'
%                col('k')                            '-.'            lw(3)           'Control'
% -----------------------------------------------------------------------------------------------------
                };

opts.p2 = {     'Color'                             'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                col('gainsboro')                    '-'             lw(2)           'C1 X'
                col('rc')                           '-'             lw(2)           'C2 Y'
                col('iceberg')                      '-'             lw(2)           'C3 Z'
                col('k')                            '-.'            lw(3)           'Control'
% -----------------------------------------------------------------------------------------------------
                };

for sc = 1:size(f,1) % Loop over sweep comparisons 
genFig()

% new data
    dat = textin( strcat(locIn,F(F==f{sc,2})) );
    dat = str2num( char(dat(61:end)) );

    %[~,idx] = sort(f{sc,5});               % < ---------------------------
    %idx = 3*fliplr(idx)-1;
    idx = 3*f{sc,5} - 1;
    
    for i = 1:size(opts.p2,1)-1
        mag = abs( dat(:,idx(i)) + im*dat(:,idx(i)+1) );
        p.p2(i) = plot(dat(:,1), mag, opts.p2{[1 i+1],1:end-1});
    end

% old data 
    dat = textin( strcat(locIn,F(F==f{sc,1})) );
    dat = str2num( char(dat(61:end)) );

    %[~,idx] = sort(f{sc,6});               % < ---------------------------
    %idx = 3*fliplr(idx)-1;
    idx = 3*f{sc,6} - 1;

    for i = 1:size(opts.p1,1)-1
        mag = abs( dat(:,idx(i)) + im*dat(:,idx(i)+1) );
        p.p1(i) = plot(dat(:,1), mag, opts.p1{[1 i+1],1:end-1});
    end

% General styles
    grid off

    ax.XLabel.String = "Frequency [ Hz ]";
    ax.YLabel.String = "Acceleration [ g ]";
   
% Legend
    lgdString = cellstr([   strcat(f{sc,4}, ", ", opts.p2(2:end,end))
                            strcat(f{sc,3}, ", ", opts.p1(2:end,end))   ]);
    lgd = legend([p.p2 p.p1]', lgdString{:}, opts.lgd{:});
    lgd.NumColumns = 2;

% Export
    print('-painters', '-dsvg', strcat(locOut, padstr( join(string(f(sc,[4 3])),'-') ), 'sweepComp') );
end

%}



%%
% ========================================================================
% Clean sine sweeps
% ========================================================================
%
f = {   % data                              % run label     % Phys. channel order        
% -----------------------------------------------------------------------------------------------------
        "VERT-Z_sweep_0.5g_R3.txt"          "Z1"            [2 3 4 8 1]     % C1-C3, C8, CT 
        "SLIP-Y_sweep_0.5g_R3.txt"          "Y1"            [2 3 4 8 1] 
        "SLIP-X_sweep_0.5g_R1.txt"          "X1"            [3 2 4 8 1]
% -----------------------------------------------------------------------------------------------------
        };

% add physical channel order to 3rd col
% f = [ f repmat({[10:-1:7]}, [size(f,1) 1]) ];      %[2 3 4 8 1]     % C1-C3, C8, CT  

% line styles
lw = [ 0.2  0.7  0.2 ];

opts.p2 = {     'Color'                         'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                col('applegreen')               '-'             lw(2)           'C1 X'
                col('rc')                       '-'             lw(2)           'C2 Y'
                col('iceberg')                  '-'             lw(2)           'C3 Z'
                col('gainsboro')                '-'             lw(2)           'C8 Z'
                col('k')                        '-.'            lw(3)           'Control'
% -----------------------------------------------------------------------------------------------------
                };


for sc = 1:size(f,1) % Loop over sweep comparisons 
genFig()

% data
    dat = textin( strcat(locIn,F(F==f{sc,1})) );
    dat = str2num( char(dat(61:end)) );

    % [~,idx] = sort(f{sc,3});
    % idx = 3*fliplr(idx)-1;
    idx = 3*f{sc,3} - 1;

    for i = 1:size(opts.p2,1)-1
        mag = abs( dat(:,idx(i)) + im*dat(:,idx(i)+1) );
        p.p2(i) = plot(dat(:,1), mag, opts.p2{[1 i+1],1:end-1});
    end

% General styles
    grid off

    ax.XLabel.String = "Frequency [ Hz ]";
    ax.YLabel.String = "Acceleration [ g ]";
   
% Legend
    lgdString = cellstr([ strcat(f{sc,2}, ", ", opts.p2(2:end,end)) ]);
    lgd = legend(p.p2', lgdString{:}, opts.lgd{:});

% Export
    print('-painters', '-dsvg', strcat(locOut, padstr(f{sc,2}), 'sweep') );
end
%}


%%
% ========================================================================
% Random 
% ========================================================================
%    
ASD =  [    20	        0.026	
            50          0.16
            800	        0.16 
            2000        0.026	    ];                      % GEVS 14.1 g

ASD =  [    20          0.026
            50          0.06
            150         0.06 
            300         0.02
            700         0.02
            800         0.06
            925         0.06
            2000        0.02        ];                      % Jason 8.25 g

            % freq      % min       % max
lims = [    20          -3          +3
            1000-1e-6   -3          +3
            1000        -3          +3
            2000        -3          +3      ];

freq = [20:2000]';
ASD = interpPSD(ASD,freq);

level_dB = interp1(lims(:,1),lims(:,2:3),freq,'linear');    % level scaling
lims = [freq ASD ASD.*10.^(level_dB/10)];                   % [freq ref min max] 


f = {   % data                                  % Run label     % Phys. channel order
% -----------------------------------------------------------------------------------------------------
        "VERT-Z_rand_8.25g_R1.txt"              "Z4"            [2 3 4 8 1]     % C1-C3, C8, CT 
        "SLIP-Y_rand_8.25g_R3.txt"              "Y4"            [2 3 4 8 1]
        "SLIP-X_rand_8.25g_R1.txt"              "X4"            [3 2 4 8 1]
% -----------------------------------------------------------------------------------------------------
        };

lw = [ 0.2  0.7  0.4 ];

opts.p2 = {     'Color'                         'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                col('applegreen')               '-'             lw(2)           'C1 X'
                col('rc')                       '-'             lw(2)           'C2 Y'
                col('iceberg')                  '-'             lw(2)           'C3 Z'
                col('gainsboro')                '-'             lw(2)           'C8 Z'
                col('k')                        '-.'            lw(3)           'Control'
% -----------------------------------------------------------------------------------------------------
                };

opts.ref = {   'Color'                         'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                col('l')                       '-'             0.2           'Reference ASD'
                col('d')                       '-'             1.2           'Tolerances'
% -----------------------------------------------------------------------------------------------------
                };


for sc = 1:size(f,1)
genFig()

% limits
    p.ref(1) = plot(lims(:,1), lims(:,2), opts.ref{[1 2],1:end-1});
    p.ref(2:3) = plot(lims(:,1), lims(:,3:4), opts.ref{[1 3],1:end-1});

% rand data
    dat = textin( strcat(locIn,F(F==f{sc,1})) );
    dat = str2num( char(dat(62:end)) );

    % [~,idx] = sort(f{sc,3});
    % idx = 2*fliplr(idx);
    idx = 2*f{sc,3};

    for i = 1:size(opts.p2,1)-1
        p.p2(i) = plot(dat(:,1), dat(:,idx(i)), opts.p2{[1 i+1],1:end-1});
    end

% General styles
    ax.XLabel.String = "Frequency [ Hz ]";
    ax.YLabel.String = "ASD [ g\textsuperscript{2}/Hz ]";
   
% Legend
    lgdString = cellstr([   opts.ref(2:end,end)
                            strcat(f{sc,2}, ", ", opts.p2(2:end,end))   ]);
    lgd = legend([p.ref(1:2) p.p2]', lgdString{:}, opts.lgd{:});

% Export
    print('-painters', '-dsvg', strcat(locOut, padstr(f{sc,2}), 'random') );
end 
%}


%%
% ========================================================================
% High-level sine 
% ========================================================================
%{
            % freq      % X, Y      % Z          
ref =  [    5	        2.5	        2.2	
            45          2.5	        2.2
            50          6.25        5.5
            100	        6.25	    5.5       ];

f = {   % data                                  % Run label     % Phys. channel order
% -----------------------------------------------------------------------------------------------------
%        "VERT-X_sineVibe_6.25g_R1-2.txt"        "X4"            [10 9 8 7]
%        "SLIP-Y_sineVibe_6.25g_R1.txt"          "Y4"            [10 9 8 7]
%        "SLIP-Z_sineVibe_5.5g_R1.txt"           "Z4"            [10 9 8 7]
% -----------------------------------------------------------------------------------------------------
        };

lw = [ 0.2  0.7  0.2 ];

opts.p2 = {     'Color'                         'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                col('applegreen')               '-'             lw(2)           'Ch.4 [X]'
                col('rc')                       '-'             lw(2)           'Ch.3 [Y]'
                col('iceberg')                  '-'             lw(2)           'Ch.2 [Z]'
                col('k')                        '-.'            lw(3)           'Control'
% -----------------------------------------------------------------------------------------------------
                };

opts.ref = {   'Color'                         'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                col('l')                       '-'             0.4           'Ref. amplitude'
                col('k')                       '-'             0.4           'Tolerances'
% -----------------------------------------------------------------------------------------------------
                };

for sc = 1:size(f,1) 
genFig()

% limits
    if contains(f{sc,2},["X" "Y"])
        lims = [ ref(:,1)   ref(:,2).*[1.0, 0.9, 1.1] ];
    else
        lims = [ ref(:,1)   ref(:,3).*[1.0, 0.9, 1.1] ];
    end

    p.ref(1) = plot(lims(:,1), lims(:,2), opts.ref{[1 2],1:end-1});
    p.ref(2:3) = plot(lims(:,1), lims(:,3:4), opts.ref{[1 3],1:end-1});

% sineVibe data
    dat = textin( strcat(locIn,F(F==f{sc,1})) );
    dat = str2num( char(dat(61:end)) );

    [~,idx] = sort(f{sc,3});
    idx = 3*fliplr(idx)-1;

    for i = 1:size(opts.p2,1)-1
        mag = abs( dat(:,idx(i)) + im*dat(:,idx(i)+1) );
        p.p2(i) = plot(dat(:,1), mag, opts.p2{[1 i+1],1:end-1});
    end

% General styles
    ax.XLabel.String = "Frequency [ Hz ]";
    ax.YLabel.String = "Acceleration [ g ]";
   
% Legend
    lgdString = cellstr([   opts.ref(2:end,end)
                            strcat(f{sc,2}, ", ", opts.p2(2:end,end))   ]);
    lgd = legend([p.ref(1:2) p.p2]', lgdString{:}, opts.lgd{:});

% Export
    print('-painters', '-dsvg', strcat(locOut, padstr(f{sc,2}), 'sineVibe') );
end
%}


%%
% ========================================================================
% Sine burst [QSL] 
% ========================================================================
%
            % freq      % X, Y      % Z          
ref =  [    15	        10.0        10.0     
            ];

f = {   % data                                  % Run label     % Phys. channel order
% -----------------------------------------------------------------------------------------------------
        "VERT-Z_QSL_10g_R4.txt"                 "Z2"            [1 2 3 7 8]
        "SLIP-Y_QSL_10g_R4.txt"                 "Y2"            [1 2 3 7 8]
        "SLIP-X_QSL_10g_R1.txt"                 "X2"            [2 1 3 7 8]
% -----------------------------------------------------------------------------------------------------
        };

lw = [ 0.2  0.5  0.3 ];

opts.p2 = {     'Color'                         'LineStyle'     'LineWidth'     'Label'
% -----------------------------------------------------------------------------------------------------
                col('applegreen')               '-'             lw(2)           'C1 X'
                col('rc')                       '-'             lw(2)           'C2 Y'
                col('iceberg')                  '-'             lw(2)           'C3 Z'
                col('gainsboro')                '-'             lw(2)           'C8 Z'
                col('k')                        '-'             lw(3)           'Control'
% -----------------------------------------------------------------------------------------------------
                };

for sc = 1:size(f,1)    
genFig()

% QSL data
    dat = textin( strcat(locIn,F(F==f{sc,1})) );
    dat = str2num( char(dat(50:end)) );

    %[~,idx] = sort(f{sc,3});
    %idx = 2*fliplr(idx);
    idx = 2*f{sc,3};

    for i = 1:size(opts.p2,1)-1
        p.p2(i) = plot(dat(:,1), dat(:,idx(i)), opts.p2{[1 i+1],1:end-1});
    end

% General styles
    ax.XLabel.String = "Time [ s ]";
    ax.YLabel.String = "Acceleration [ g ]";
    ax.XScale = "linear";
    ax.YScale = "linear";
   
% Legend
    lgdString = cellstr([   strcat(f{sc,2}, ", ", opts.p2(2:end,end))   ]);
    lgd = legend([p.p2]', lgdString{:}, opts.lgd{:});

% Export normal
    print( '-painters', '-dsvg', strcat(locOut, padstr(f{sc,2}), 'QSL') );
% Export zoomed 
    ax.XLim = mean(ax.XLim) + 2*[-1 1]/ref(1,1);
    print( '-painters', '-dsvg', strcat(locOut, padstr(f{sc,2}), 'QSL-zoom') );

% Downsample and export 
%    datInterp = interp1(dat(:,1), dat, dat(1,1):1/6400:dat(end,1), 'makima');
%    textout(num2str(datInterp,'%.4E\t'),f{sc,2});

end % for plot
%}


%%
% ========================================================================
% UTILITY FUNCTIONS
% ========================================================================

function genFig

global ax fig
grootMod

fig = figure(1);
    clf
    ax = axes(  'Units', 'normalized', ...
                'XScale', 'log', ...
                'YScale', 'log', ...
                'MinorGridLineStyle', '-', ...
                'MinorGridAlpha', 0.05, ...
                'GridAlpha', 0.15, ...
                'lineWidth', 0.6, ...
                'FontSize', 8.4        );   % Adjusted for Word report template, 100% scaling

    set(0,'defaultLegendAutoUpdate', 'off')
    set(ax,'LooseInset',get(ax,'TightInset'));

    axis auto tight
    hold on
    grid on
    grid minor
    box on

    fig.Position = [100 100 698 392].*[1, 1, 1.0, 1.0];  
end














