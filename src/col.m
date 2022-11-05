%{
-------------------------------------
    Vladimir V. Yotov
    Te Pūnaha Ātea Space Institute
    University of Auckland

    Version: 20.05.2022
-------------------------------------

INPUTS
    col     cell/string array or single char vector of color names e.g.
            {'k','applegreen',"r2"}, ["m" "ao"], 'celadon'
    fmt     optional, 'hex'/"hex"/2 for hex output, else rgb

OUTPUTS
    cc      n x 3 numeric rgb or hex array of the same size as 'code'

NOTES
    The colortable below is obtained by 
    1. copy-paste contents the of latexcolor.com to latexcolors.dat
    2. remove any '#' that is not part of hex color 
    3. remove \' characters from \definecolor{...}
    4. parse and write onto B.dat by executing

        A = textin('latexcolors.dat');
        B = split(A,["#","{rgb}"]);
        B = [split(B(:,2),"\definecolor"), B(:,3), B(:,1)];
        B(:,1) = char(strcat("'#", deblank(B(:,1)), "';\tc = "));
        B(:,2) = strrep(B(:,2), "{", "case '");
        B(:,2) = strrep(B(:,2), "}", "';");
        B(:,2) = strcat(string(char(B(:,2))), " cx = ");
        
        B(:,3) = erase(B(:,3), ["}", "{", ","]);
        tmp = num2str(str2num(char(B(:,3))),'%.2f %.2f %.2f ');
        B = strcat(B(:,2), B(:,1), "[", tmp, "];\t\t%% ", deblank(B(:,4)));
        textout(B,'B.dat',[],[],[],true)

EXT.PACKAGES
    'hex2rgb and rgb2hex' by Chad Greene

NEXT VERSIONS 
    - UOA colortable
    - shades (shade=...)
    - tints
    - 
%}



function cc = col(code,fmt)
 
if nargin==2
    if isnumeric(fmt) 
        if fmt==2       fmt = "hex";
        else            fmt = "rgb";
        end
    elseif fmt=="hex"   fmt = "hex";
    end
else                    fmt = "rgb";
end

cc = []; 
code = string(code); % string vector of req. tokens
for i = 1:numel(code) % loop over requested colors

switch code(i)
% LATEXCOLORS.COM
case 'airforceblue';           cx = '#5D8AA8';	c = [0.36 0.54 0.66];		% Air Force blue
case 'aliceblue';              cx = '#F0F8FF';	c = [0.94 0.97 1.00];		% Alice blue
case 'alizarin';               cx = '#E32636';	c = [0.82 0.10 0.26];		% Alizarin
case 'almond';                 cx = '#EFDECD';	c = [0.94 0.87 0.80];		% Almond
case 'amaranth';               cx = '#E52B50';	c = [0.90 0.17 0.31];		% Amaranth
case 'amber';                  cx = '#FFBF00';	c = [1.00 0.75 0.00];		% Amber
case 'amber(sae/ece)';         cx = '#FF7E00';	c = [1.00 0.49 0.00];		% Amber (SAE/ECE)
case 'americanrose';           cx = '#FF033E';	c = [1.00 0.01 0.24];		% American rose
case 'amethyst';               cx = '#9966CC';	c = [0.60 0.40 0.80];		% Amethyst
case 'anti-flashwhite';        cx = '#F2F3F4';	c = [0.95 0.95 0.96];		% Anti-flash white
case 'antiquebrass';           cx = '#CD9575';	c = [0.80 0.58 0.46];		% Antique brass
case 'antiquefuchsia';         cx = '#915C83';	c = [0.57 0.36 0.51];		% Antique fuchsia
case 'antiquewhite';           cx = '#FAEBD7';	c = [0.98 0.92 0.84];		% Antique white
case 'ao';                     cx = '#0000FF';	c = [0.00 0.00 1.00];		% Ao
case 'ao(english)';            cx = '#008000';	c = [0.00 0.50 0.00];		% Ao (English)
case 'applegreen';             cx = '#8DB600';	c = [0.55 0.71 0.00];		% Apple green
case 'apricot';                cx = '#FBCEB1';	c = [0.98 0.81 0.69];		% Apricot
case 'aqua';                   cx = '#00FFFF';	c = [0.00 1.00 1.00];		% Aqua
case 'aquamarine';             cx = '#7FFFD0';	c = [0.50 1.00 0.83];		% Aquamarine
case 'armygreen';              cx = '#4B5320';	c = [0.29 0.33 0.13];		% Army green
case 'arsenic';                cx = '#3B444B';	c = [0.23 0.27 0.29];		% Arsenic
case 'arylideyellow';          cx = '#E9D66B';	c = [0.91 0.84 0.42];		% Arylide yellow
case 'ashgrey';                cx = '#B2BEB5';	c = [0.70 0.75 0.71];		% Ash grey
case 'asparagus';              cx = '#87A96B';	c = [0.53 0.66 0.42];		% Asparagus
case 'atomictangerine';        cx = '#FF9966';	c = [1.00 0.60 0.40];		% Atomic tangerine
case 'auburn';                 cx = '#6D351A';	c = [0.43 0.21 0.10];		% Auburn
case 'aureolin';               cx = '#FDEE00';	c = [0.99 0.93 0.00];		% Aureolin
case 'aurometalsaurus';        cx = '#6E7F80';	c = [0.43 0.50 0.50];		% AuroMetalSaurus
case 'awesome';                cx = '#FF2052';	c = [1.00 0.13 0.32];		% Awesome
case 'azure(colorwheel)';      cx = '#007FFF';	c = [0.00 0.50 1.00];		% Azure (color wheel)
case 'azure(web)(azuremist)';  cx = '#F0FFFF';	c = [0.94 1.00 1.00];		% Azure (web) (Azure mist)
case 'babyblue';               cx = '#89CFF0';	c = [0.54 0.81 0.94];		% Baby blue
case 'babyblueeyes';           cx = '#A1CAF1';	c = [0.63 0.79 0.95];		% Baby blue eyes
case 'babypink';               cx = '#F4C2C2';	c = [0.96 0.76 0.76];		% Baby pink
case 'ballblue';               cx = '#21ABCD';	c = [0.13 0.67 0.80];		% Ball Blue
case 'bananamania';            cx = '#FAE7B5';	c = [0.98 0.91 0.71];		% Banana Mania
case 'bananayellow';           cx = '#FFE135';	c = [1.00 0.88 0.21];		% Banana Yellow
case 'battleshipgrey';         cx = '#848482';	c = [0.52 0.52 0.51];		% Battleship grey
case 'bazaar';                 cx = '#98777B';	c = [0.60 0.47 0.48];		% Bazaar
case 'beaublue';               cx = '#BCD4E6';	c = [0.74 0.83 0.90];		% Beau blue
case 'beaver';                 cx = '#9F8170';	c = [0.62 0.51 0.44];		% Beaver
case 'beige';                  cx = '#F5F5DC';	c = [0.96 0.96 0.86];		% Beige
case 'bisque';                 cx = '#FFE4C4';	c = [1.00 0.89 0.77];		% Bisque
case 'bistre';                 cx = '#3D2B1F';	c = [0.24 0.17 0.12];		% Bistre
case 'bittersweet';            cx = '#FE6F5E';	c = [1.00 0.44 0.37];		% Bittersweet
case 'black';                  cx = '#000000';	c = [0.00 0.00 0.00];		% Black
case 'blanchedalmond';         cx = '#FFEBCD';	c = [1.00 0.92 0.80];		% Blanched Almond
case 'bleudefrance';           cx = '#318CE7';	c = [0.19 0.55 0.91];		% Bleu de France
case 'blizzardblue';           cx = '#ACE5EE';	c = [0.67 0.90 0.93];		% Blizzard Blue
case 'blond';                  cx = '#FAF0BE';	c = [0.98 0.94 0.75];		% Blond
case 'blue';                   cx = '#0000FF';	c = [0.00 0.00 1.00];		% Blue
case 'blue(munsell)';          cx = '#0093AF';	c = [0.00 0.50 0.69];		% Blue (Munsell)
case 'blue(ncs)';              cx = '#0087BD';	c = [0.00 0.53 0.74];		% Blue (NCS)
case 'blue(pigment)';          cx = '#333399';	c = [0.20 0.20 0.60];		% Blue (pigment)
case 'blue(ryb)';              cx = '#0247FE';	c = [0.01 0.28 1.00];		% Blue (RYB)
case 'bluebell';               cx = '#A2A2D0';	c = [0.64 0.64 0.82];		% Blue Bell
case 'bluegray';               cx = '#6699CC';	c = [0.40 0.60 0.80];		% Blue Gray
case 'blue-green';             cx = '#00DDDD';	c = [0.00 0.87 0.87];		% Blue-green
case 'blue-violet';            cx = '#8A2BE2';	c = [0.54 0.17 0.89];		% Blue-violet
case 'blush';                  cx = '#DE5D83';	c = [0.87 0.36 0.51];		% Blush
case 'bole';                   cx = '#79443B';	c = [0.47 0.27 0.23];		% Bole
case 'bondiblue';              cx = '#0095B6';	c = [0.00 0.58 0.71];		% Bondi blue
case 'bostonuniversityred';    cx = '#CC0000';	c = [0.80 0.00 0.00];		% Boston University Red
case 'brandeisblue';           cx = '#0070FF';	c = [0.00 0.44 1.00];		% Brandeis blue
case 'brass';                  cx = '#B5A642';	c = [0.71 0.65 0.26];		% Brass
case 'brickred';               cx = '#CB4154';	c = [0.80 0.25 0.33];		% Brick red
case 'brightcerulean';         cx = '#1DACD6';	c = [0.11 0.67 0.84];		% Bright cerulean
case 'brightgreen';            cx = '#66FF00';	c = [0.40 1.00 0.00];		% Bright green
case 'brightlavender';         cx = '#BF94E4';	c = [0.75 0.58 0.89];		% Bright lavender
case 'brightmaroon';           cx = '#C32148';	c = [0.76 0.13 0.28];		% Bright maroon
case 'brightpink';             cx = '#FF007F';	c = [1.00 0.00 0.50];		% Bright pink
case 'brightturquoise';        cx = '#08E8DE';	c = [0.03 0.91 0.87];		% Bright turquoise
case 'brightube';              cx = '#D19FE8';	c = [0.82 0.62 0.91];		% Bright ube
case 'brilliantlavender';      cx = '#F4BBFF';	c = [0.96 0.73 1.00];		% Brilliant lavender
case 'brilliantrose';          cx = '#FF55A3';	c = [1.00 0.33 0.64];		% Brilliant rose
case 'brinkpink';              cx = '#FB607F';	c = [0.98 0.38 0.50];		% Brink pink
case 'britishracinggreen';     cx = '#004225';	c = [0.00 0.26 0.15];		% British racing green
case 'bronze';                 cx = '#CD7F32';	c = [0.80 0.50 0.20];		% Bronze
case 'brown';                  cx = '#964B00';	c = [0.59 0.29 0.00];		% Brown (traditional)
case 'brown(web)';             cx = '#A52A2A';	c = [0.65 0.16 0.16];		% Brown (web)
case 'bubblegum';              cx = '#FFC1CC';	c = [0.99 0.76 0.80];		% Bubble gum
case 'bubbles';                cx = '#E7FEFF';	c = [0.91 1.00 1.00];		% Bubbles
case 'buff';                   cx = '#F0DC82';	c = [0.94 0.86 0.51];		% Buff
case 'bulgarianrose';          cx = '#480607';	c = [0.28 0.02 0.03];		% Bulgarian rose
case 'burgundy';               cx = '#800020';	c = [0.50 0.00 0.13];		% Burgundy
case 'burlywood';              cx = '#DEB887';	c = [0.87 0.72 0.53];		% Burlywood
case 'burntorange';            cx = '#CC5500';	c = [0.80 0.33 0.00];		% Burnt orange
case 'burntsienna';            cx = '#E97451';	c = [0.91 0.45 0.32];		% Burnt sienna
case 'burntumber';             cx = '#8A3324';	c = [0.54 0.20 0.14];		% Burnt umber
case 'byzantine';              cx = '#BD33A4';	c = [0.74 0.20 0.64];		% Byzantine
case 'byzantium';              cx = '#702963';	c = [0.44 0.16 0.39];		% Byzantium
case 'cadet';                  cx = '#536872';	c = [0.33 0.41 0.47];		% Cadet
case 'cadetblue';              cx = '#5F9EA0';	c = [0.37 0.62 0.63];		% Cadet blue
case 'cadetgrey';              cx = '#91A3B0';	c = [0.57 0.64 0.69];		% Cadet grey
case 'cadmiumgreen';           cx = '#006B3C';	c = [0.00 0.42 0.24];		% Cadmium Green
case 'cadmiumorange';          cx = '#ED872D';	c = [0.93 0.53 0.18];		% Cadmium Orange
case 'cadmiumred';             cx = '#E30022';	c = [0.89 0.00 0.13];		% Cadmium Red
case 'cadmiumyellow';          cx = '#FFF600';	c = [1.00 0.96 0.00];		% Cadmium Yellow
case 'calpolypomonagreen';     cx = '#1E4D2B';	c = [0.12 0.30 0.17];		% Cal Poly Pomona green
case 'cambridgeblue';          cx = '#A3C1AD';	c = [0.64 0.76 0.68];		% Cambridge Blue
case 'camel';                  cx = '#C19A6B';	c = [0.76 0.60 0.42];		% Camel
case 'camouflagegreen';        cx = '#78866B';	c = [0.47 0.53 0.42];		% Camouflage green
case 'canaryyellow';           cx = '#FFEF00';	c = [1.00 0.94 0.00];		% Canary yellow
case 'candyapplered';          cx = '#FF0800';	c = [1.00 0.03 0.00];		% Candy apple red
case 'candypink';              cx = '#E4717A';	c = [0.89 0.44 0.48];		% Candy pink
case 'capri';                  cx = '#00BFFF';	c = [0.00 0.75 1.00];		% Capri
case 'caputmortuum';           cx = '#592720';	c = [0.35 0.15 0.13];		% Caput mortuum
case 'cardinal';               cx = '#C41E3A';	c = [0.77 0.12 0.23];		% Cardinal
case 'caribbeangreen';         cx = '#00CC99';	c = [0.00 0.80 0.60];		% Caribbean green
case 'carmine';                cx = '#960018';	c = [0.59 0.00 0.09];		% Carmine
case 'carminepink';            cx = '#EB4C42';	c = [0.92 0.30 0.26];		% Carmine pink
case 'carminered';             cx = '#FF0038';	c = [1.00 0.00 0.22];		% Carmine red
case 'carnationpink';          cx = '#FFA6C9';	c = [1.00 0.65 0.79];		% Carnation pink
case 'carnelian';              cx = '#B31B1B';	c = [0.70 0.11 0.11];		% Carnelian
case 'carolinablue';           cx = '#99BADD';	c = [0.60 0.73 0.89];		% Carolina blue
case 'carrotorange';           cx = '#ED9121';	c = [0.93 0.57 0.13];		% Carrot orange
case 'ceil';                   cx = '#92A1CF';	c = [0.57 0.63 0.81];		% Ceil
case 'celadon';                cx = '#ACE1AF';	c = [0.67 0.88 0.69];		% Celadon
case 'celestialblue';          cx = '#4997D0';	c = [0.29 0.59 0.82];		% Celestial blue
case 'cerise';                 cx = '#DE3163';	c = [0.87 0.19 0.39];		% Cerise
case 'cerisepink';             cx = '#EC3B83';	c = [0.93 0.23 0.51];		% Cerise pink
case 'cerulean';               cx = '#007BA7';	c = [0.00 0.48 0.65];		% Cerulean
case 'ceruleanblue';           cx = '#2A52BE';	c = [0.16 0.32 0.75];		% Cerulean blue
case 'chamoisee';              cx = '#A0785A';	c = [0.63 0.47 0.35];		% Chamoisee
case 'champagne';              cx = '#F7E7CE';	c = [0.97 0.91 0.81];		% Champagne
case 'charcoal';               cx = '#36454F';	c = [0.21 0.27 0.31];		% Charcoal
case 'chartreuse';             cx = '#DFFF00';	c = [0.87 1.00 0.00];		% Chartreuse (traditional)
case 'chartreuse(web)';        cx = '#7FFF00';	c = [0.50 1.00 0.00];		% Chartreuse (web)
case 'cherryblossompink';      cx = '#FFB7C5';	c = [1.00 0.72 0.77];		% Cherry blossom pink
case 'chestnut';               cx = '#CD5C5C';	c = [0.80 0.36 0.36];		% Chestnut
case 'chocolate';              cx = '#7B3F00';	c = [0.48 0.25 0.00];		% Chocolate (traditional)
case 'chocolate(web)';         cx = '#D2691E';	c = [0.82 0.41 0.12];		% Chocolate (web)
case 'chromeyellow';           cx = '#FFA700';	c = [1.00 0.65 0.00];		% Chrome yellow
case 'cinereous';              cx = '#98817B';	c = [0.60 0.51 0.48];		% Cinereous
case 'cinnabar';               cx = '#E34234';	c = [0.89 0.26 0.20];		% Cinnabar
case 'cinnamon';               cx = '#D2691E';	c = [0.82 0.41 0.12];		% Cinnamon
case 'citrine';                cx = '#E4D00A';	c = [0.89 0.82 0.04];		% Citrine
case 'classicrose';            cx = '#FBCCE7';	c = [0.98 0.80 0.91];		% Classic rose
case 'cobalt';                 cx = '#0047AB';	c = [0.00 0.28 0.67];		% Cobalt
case 'cocoabrown';             cx = '#D2691E';	c = [0.82 0.41 0.12];		% Cocoa brown
case 'columbiablue';           cx = '#9BDDFF';	c = [0.61 0.87 1.00];		% Columbia blue
case 'coolblack';              cx = '#002E63';	c = [0.00 0.18 0.39];		% Cool black
case 'coolgrey';               cx = '#8C92AC';	c = [0.55 0.57 0.67];		% Cool grey
case 'copper';                 cx = '#B87333';	c = [0.72 0.45 0.20];		% Copper
case 'copperrose';             cx = '#996666';	c = [0.60 0.40 0.40];		% Copper rose
case 'coquelicot';             cx = '#FF3800';	c = [1.00 0.22 0.00];		% Coquelicot
case 'coral';                  cx = '#FF7F50';	c = [1.00 0.50 0.31];		% Coral
case 'coralpink';              cx = '#F88379';	c = [0.97 0.51 0.47];		% Coral pink
case 'coralred';               cx = '#FF4040';	c = [1.00 0.25 0.25];		% Coral red
case 'cordovan';               cx = '#893F45';	c = [0.54 0.25 0.27];		% Cordovan
case 'corn';                   cx = '#FBEC5D';	c = [0.98 0.93 0.36];		% Corn
case 'cornellred';             cx = '#B31B1B';	c = [0.70 0.11 0.11];		% Cornell Red
case 'cornflowerblue';         cx = '#6495ED';	c = [0.39 0.58 0.93];		% Cornflower blue
case 'cornsilk';               cx = '#FFF8DC';	c = [1.00 0.97 0.86];		% Cornsilk
case 'cosmiclatte';            cx = '#FFF8E7';	c = [1.00 0.97 0.91];		% Cosmic latte
case 'cottoncandy';            cx = '#FFBCD9';	c = [1.00 0.74 0.85];		% Cotton candy
case 'cream';                  cx = '#FFFDD0';	c = [1.00 0.99 0.82];		% Cream
case 'crimson';                cx = '#DC143C';	c = [0.86 0.08 0.24];		% Crimson
case 'crimsonglory';           cx = '#BE0032';	c = [0.75 0.00 0.20];		% Crimson glory
case 'cyan';                   cx = '#00FFFF';	c = [0.00 1.00 1.00];		% Cyan
case 'cyan(process)';          cx = '#00B7EB';	c = [0.00 0.72 0.92];		% Cyan (process)
case 'daffodil';               cx = '#FFFF31';	c = [1.00 1.00 0.19];		% Daffodil
case 'dandelion';              cx = '#F0E130';	c = [0.94 0.88 0.19];		% Dandelion
case 'darkblue';               cx = '#00008B';	c = [0.00 0.00 0.55];		% Dark blue
case 'darkbrown';              cx = '#654321';	c = [0.40 0.26 0.13];		% Dark brown
case 'darkbyzantium';          cx = '#5D3954';	c = [0.36 0.22 0.33];		% Dark byzantium
case 'darkcandyapplered';      cx = '#A40000';	c = [0.64 0.00 0.00];		% Dark candy apple red
case 'darkcerulean';           cx = '#08457E';	c = [0.03 0.27 0.49];		% Dark cerulean
case 'darkchampagne';          cx = '#C2B280';	c = [0.76 0.70 0.50];		% Dark champagne
case 'darkchestnut';           cx = '#986960';	c = [0.60 0.41 0.38];		% Dark chestnut
case 'darkcoral';              cx = '#CD5B45';	c = [0.80 0.36 0.27];		% Dark coral
case 'darkcyan';               cx = '#008B8B';	c = [0.00 0.55 0.55];		% Dark cyan
case 'darkelectricblue';       cx = '#536878';	c = [0.33 0.41 0.47];		% Dark electric blue
case 'darkgoldenrod';          cx = '#B8860B';	c = [0.72 0.53 0.04];		% Dark goldenrod
case 'darkgray';               cx = '#A9A9A9';	c = [0.66 0.66 0.66];		% Dark gray
case 'darkgreen';              cx = '#013220';	c = [0.00 0.20 0.13];		% Dark green
case 'darkjunglegreen';        cx = '#1A2421';	c = [0.10 0.14 0.13];		% Dark jungle green
case 'darkkhaki';              cx = '#BDB76B';	c = [0.74 0.72 0.42];		% Dark khaki
case 'darklava';               cx = '#483C32';	c = [0.28 0.24 0.20];		% Dark lava
case 'darklavender';           cx = '#734F96';	c = [0.45 0.31 0.59];		% Dark lavender
case 'darkmagenta';            cx = '#8B008B';	c = [0.55 0.00 0.55];		% Dark magenta
case 'darkmidnightblue';       cx = '#003366';	c = [0.00 0.20 0.40];		% Dark midnight blue
case 'darkolivegreen';         cx = '#556B2F';	c = [0.33 0.42 0.18];		% Dark olive green
case 'darkorange';             cx = '#FF8C00';	c = [1.00 0.55 0.00];		% Dark orange
case 'darkorchid';             cx = '#9932CC';	c = [0.60 0.20 0.80];		% Dark orchid
case 'darkpastelblue';         cx = '#779ECB';	c = [0.47 0.62 0.80];		% Dark pastel blue
case 'darkpastelgreen';        cx = '#03C03C';	c = [0.01 0.75 0.24];		% Dark pastel green
case 'darkpastelpurple';       cx = '#966FD6';	c = [0.59 0.44 0.84];		% Dark pastel purple
case 'darkpastelred';          cx = '#C23B22';	c = [0.76 0.23 0.13];		% Dark pastel red
case 'darkpink';               cx = '#E75480';	c = [0.91 0.33 0.50];		% Dark pink
case 'darkpowderblue';         cx = '#003399';	c = [0.00 0.20 0.60];		% Dark powder blue
case 'darkraspberry';          cx = '#872657';	c = [0.53 0.15 0.34];		% Dark raspberry
case 'darkred';                cx = '#8B0000';	c = [0.55 0.00 0.00];		% Dark red
case 'darksalmon';             cx = '#E9967A';	c = [0.91 0.59 0.48];		% Dark salmon
case 'darkscarlet';            cx = '#560319';	c = [0.34 0.01 0.10];		% Dark scarlet
case 'darkseagreen';           cx = '#8FBC8F';	c = [0.56 0.74 0.56];		% Dark sea green
case 'darksienna';             cx = '#3C1414';	c = [0.24 0.08 0.08];		% Dark sienna
case 'darkslateblue';          cx = '#483D8B';	c = [0.28 0.24 0.55];		% Dark slate blue
case 'darkslategray';          cx = '#2F4F4F';	c = [0.18 0.31 0.31];		% Dark slate gray
case 'darkspringgreen';        cx = '#177245';	c = [0.09 0.45 0.27];		% Dark spring green
case 'darktan';                cx = '#918151';	c = [0.57 0.51 0.32];		% Dark tan
case 'darktangerine';          cx = '#FFA812';	c = [1.00 0.66 0.07];		% Dark tangerine
case 'darktaupe';              cx = '#483C32';	c = [0.28 0.24 0.20];		% Dark taupe
case 'darkterracotta';         cx = '#CC4E5C';	c = [0.80 0.31 0.36];		% Dark terra cotta
case 'darkturquoise';          cx = '#00CED1';	c = [0.00 0.81 0.82];		% Dark turquoise
case 'darkviolet';             cx = '#9400D3';	c = [0.58 0.00 0.83];		% Dark violet
case 'dartmouthgreen';         cx = '#00693E';	c = [0.05 0.50 0.06];		% Dartmouth green
case 'davysgrey';              cx = '#555555';	c = [0.33 0.33 0.33];		% Davy's grey
case 'debianred';              cx = '#D70A53';	c = [0.84 0.04 0.33];		% Debian red
case 'deepcarmine';            cx = '#A9203E';	c = [0.66 0.13 0.24];		% Deep carmine
case 'deepcarminepink';        cx = '#EF3038';	c = [0.94 0.19 0.22];		% Deep carmine pink
case 'deepcarrotorange';       cx = '#E9692C';	c = [0.91 0.41 0.17];		% Deep carrot orange
case 'deepcerise';             cx = '#DA3287';	c = [0.85 0.20 0.53];		% Deep cerise
case 'deepchampagne';          cx = '#FAD6A5';	c = [0.98 0.84 0.65];		% Deep champagne
case 'deepchestnut';           cx = '#B94E48';	c = [0.73 0.31 0.28];		% Deep chestnut
case 'deepfuchsia';            cx = '#C154C1';	c = [0.76 0.33 0.76];		% Deep fuchsia
case 'deepjunglegreen';        cx = '#004B49';	c = [0.00 0.29 0.29];		% Deep jungle green
case 'deeplilac';              cx = '#9955BB';	c = [0.60 0.33 0.73];		% Deep lilac
case 'deepmagenta';            cx = '#CC00CC';	c = [0.80 0.00 0.80];		% Deep magenta
case 'deeppeach';              cx = '#FFCBA4';	c = [1.00 0.80 0.64];		% Deep peach
case 'deeppink';               cx = '#FF1493';	c = [1.00 0.08 0.58];		% Deep pink
case 'deepsaffron';            cx = '#FF9933';	c = [1.00 0.60 0.20];		% Deep saffron
case 'deepskyblue';            cx = '#00BFFF';	c = [0.00 0.75 1.00];		% Deep sky blue
case 'denim';                  cx = '#1560BD';	c = [0.08 0.38 0.74];		% Denim
case 'desert';                 cx = '#C19A6B';	c = [0.76 0.60 0.42];		% Desert
case 'desertsand';             cx = '#EDC9AF';	c = [0.93 0.79 0.69];		% Desert sand
case 'dimgray';                cx = '#696969';	c = [0.41 0.41 0.41];		% Dim gray
case 'dodgerblue';             cx = '#1E90FF';	c = [0.12 0.56 1.00];		% Dodger blue
case 'dogwoodrose';            cx = '#D71868';	c = [0.84 0.09 0.41];		% Dogwood rose
case 'dollarbill';             cx = '#85BB65';	c = [0.52 0.73 0.40];		% Dollar bill
case 'drab';                   cx = '#967117';	c = [0.59 0.44 0.09];		% Drab
case 'dukeblue';               cx = '#00009C';	c = [0.00 0.00 0.61];		% Duke blue
case 'earthyellow';            cx = '#E1A95F';	c = [0.88 0.66 0.37];		% Earth yellow
case 'ecru';                   cx = '#C2B280';	c = [0.76 0.70 0.50];		% Ecru
case 'eggplant';               cx = '#614051';	c = [0.38 0.25 0.32];		% Eggplant
case 'eggshell';               cx = '#F0EAD6';	c = [0.94 0.92 0.84];		% Eggshell
case 'egyptianblue';           cx = '#1034A6';	c = [0.06 0.20 0.65];		% Egyptian blue
case 'electricblue';           cx = '#7DF9FF';	c = [0.49 0.98 1.00];		% Electric blue
case 'electriccrimson';        cx = '#FF003F';	c = [1.00 0.00 0.25];		% Electric crimson
case 'electriccyan';           cx = '#00FFFF';	c = [0.00 1.00 1.00];		% Electric cyan
case 'electricgreen';          cx = '#00FF00';	c = [0.00 1.00 0.00];		% Electric green
case 'electricindigo';         cx = '#6F00FF';	c = [0.44 0.00 1.00];		% Electric indigo
case 'electriclavender';       cx = '#F4BBFF';	c = [0.96 0.73 1.00];		% Electric lavender
case 'electriclime';           cx = '#CCFF00';	c = [0.80 1.00 0.00];		% Electric lime
case 'electricpurple';         cx = '#BF00FF';	c = [0.75 0.00 1.00];		% Electric purple
case 'electricultramarine';    cx = '#3F00FF';	c = [0.25 0.00 1.00];		% Electric ultramarine
case 'electricviolet';         cx = '#8F00FF';	c = [0.56 0.00 1.00];		% Electric violet
case 'electricyellow';         cx = '#FFFF00';	c = [1.00 1.00 0.00];		% Electric Yellow
case 'emerald';                cx = '#50C878';	c = [0.31 0.78 0.47];		% Emerald
case 'etonblue';               cx = '#96C8A2';	c = [0.59 0.78 0.64];		% Eton blue
case 'fallow';                 cx = '#C19A6B';	c = [0.76 0.60 0.42];		% Fallow
case 'falured';                cx = '#801818';	c = [0.50 0.09 0.09];		% Falu red
case 'fandango';               cx = '#B53389';	c = [0.71 0.20 0.54];		% Fandango
case 'fashionfuchsia';         cx = '#F400A1';	c = [0.96 0.00 0.63];		% Fashion fuchsia
case 'fawn';                   cx = '#E5AA70';	c = [0.90 0.67 0.44];		% Fawn
case 'feldgrau';               cx = '#4D5D53';	c = [0.30 0.36 0.33];		% Feldgrau
case 'ferngreen';              cx = '#4F7942';	c = [0.31 0.47 0.26];		% Fern green
case 'ferrarired';             cx = '#FF2800';	c = [1.00 0.11 0.00];		% Ferrari Red
case 'fielddrab';              cx = '#6C541E';	c = [0.42 0.33 0.12];		% Field drab
case 'firebrick';              cx = '#B22222';	c = [0.70 0.13 0.13];		% Firebrick
case 'fireenginered';          cx = '#CE2029';	c = [0.81 0.09 0.13];		% Fire engine red
case 'flame';                  cx = '#E25822';	c = [0.89 0.35 0.13];		% Flame
case 'flamingopink';           cx = '#FC8EAC';	c = [0.99 0.56 0.67];		% Flamingo pink
case 'flavescent';             cx = '#F7E98E';	c = [0.97 0.91 0.56];		% Flavescent
case 'flax';                   cx = '#EEDC82';	c = [0.93 0.86 0.51];		% Flax
case 'floralwhite';            cx = '#FFFAF0';	c = [1.00 0.98 0.94];		% Floral white
case 'fluorescentorange';      cx = '#FFBF00';	c = [1.00 0.75 0.00];		% Fluorescent orange
case 'fluorescentpink';        cx = '#FF1493';	c = [1.00 0.08 0.58];		% Fluorescent pink
case 'fluorescentyellow';      cx = '#CCFF00';	c = [0.80 1.00 0.00];		% Fluorescent yellow
case 'folly';                  cx = '#FF004F';	c = [1.00 0.00 0.31];		% Folly
case 'forestgreen';            cx = '#014421';	c = [0.00 0.27 0.13];		% Forest green (traditional)
case 'forestgreen(web)';       cx = '#228B22';	c = [0.13 0.55 0.13];		% Forest green (web)
case 'frenchbeige';            cx = '#A67B5B';	c = [0.65 0.48 0.36];		% French beige
case 'frenchblue';             cx = '#0072BB';	c = [0.00 0.45 0.73];		% French blue
case 'frenchlilac';            cx = '#86608E';	c = [0.53 0.38 0.56];		% French lilac
case 'frenchrose';             cx = '#F64A8A';	c = [0.96 0.29 0.54];		% French rose
case 'fuchsia';                cx = '#FF00FF';	c = [1.00 0.00 1.00];		% Fuchsia
case 'fuchsiapink';            cx = '#FF77FF';	c = [1.00 0.47 1.00];		% Fuchsia pink
case 'fulvous';                cx = '#E48400';	c = [0.86 0.52 0.00];		% Fulvous
case 'fuzzywuzzy';             cx = '#CC6666';	c = [0.80 0.40 0.40];		% Fuzzy Wuzzy
case 'gainsboro';              cx = '#DCDCDC';	c = [0.86 0.86 0.86];		% Gainsboro
case 'gamboge';                cx = '#E49B0F';	c = [0.89 0.61 0.06];		% Gamboge
case 'ghostwhite';             cx = '#F8F8FF';	c = [0.97 0.97 1.00];		% Ghost white
case 'ginger';                 cx = '#B06500';	c = [0.69 0.40 0.00];		% Ginger
case 'glaucous';               cx = '#6082B6';	c = [0.38 0.51 0.71];		% Glaucous
case 'gold(metallic)';         cx = '#D4AF37';	c = [0.83 0.69 0.22];		% Gold (metallic)
case 'gold(web)(golden)';      cx = '#FFD700';	c = [1.00 0.84 0.00];		% Gold (web) (Golden)
case 'goldenbrown';            cx = '#996515';	c = [0.60 0.40 0.08];		% Golden brown
case 'goldenpoppy';            cx = '#FCC200';	c = [0.99 0.76 0.00];		% Golden poppy
case 'goldenyellow';           cx = '#FFDF00';	c = [1.00 0.87 0.00];		% Golden yellow
case 'goldenrod';              cx = '#DAA520';	c = [0.85 0.65 0.13];		% Goldenrod
case 'grannysmithapple';       cx = '#A8E4A0';	c = [0.66 0.89 0.63];		% Granny Smith Apple
case 'gray';                   cx = '#808080';	c = [0.50 0.50 0.50];		% Gray
case 'gray(html/cssgray)';     cx = '#7F7F7F';	c = [0.50 0.50 0.50];		% Gray (HTML/CSS gray)
case 'x11gray';                cx = '#BEBEBE';	c = [0.75 0.75 0.75];		% Gray (X11 gray)
case 'gray-asparagus';         cx = '#465945';	c = [0.27 0.35 0.27];		% Gray-asparagus
case 'green(colorwheel)';      cx = '#00FF00';	c = [0.00 1.00 0.00];		% Green (color wheel) (X11 green)
case 'green(html/cssgreen)';   cx = '#008000';	c = [0.00 0.50 0.00];		% Green (HTML/CSS green)
case 'green(munsell)';         cx = '#00A877';	c = [0.00 0.66 0.47];		% Green (Munsell)
case 'green(ncs)';             cx = '#009F6B';	c = [0.00 0.62 0.42];		% Green (NCS)
case 'green(pigment)';         cx = '#00A550';	c = [0.00 0.65 0.31];		% Green (pigment)
case 'green(ryb)';             cx = '#66B032';	c = [0.40 0.69 0.20];		% Green (RYB)
case 'green-yellow';           cx = '#ADFF2F';	c = [0.68 1.00 0.18];		% Green-yellow
case 'grullo';                 cx = '#A99A86';	c = [0.66 0.60 0.53];		% Grullo
case 'guppiegreen';            cx = '#00FF7F';	c = [0.00 1.00 0.50];		% Guppie green
case 'halayaube';              cx = '#663854';	c = [0.40 0.22 0.33];		% Halaya ube
case 'hanblue';                cx = '#446CCF';	c = [0.27 0.42 0.81];		% Han blue
case 'hanpurple';              cx = '#5218FA';	c = [0.32 0.09 0.98];		% Han purple
case 'hansayellow';            cx = '#E9D66B';	c = [0.91 0.84 0.42];		% Hansa yellow
case 'harlequin';              cx = '#3FFF00';	c = [0.25 1.00 0.00];		% Harlequin
case 'harvardcrimson';         cx = '#C90016';	c = [0.79 0.00 0.09];		% Harvard crimson
case 'harvestgold';            cx = '#DA9100';	c = [0.85 0.57 0.00];		% Harvest Gold
case 'heartgold';              cx = '#808000';	c = [0.50 0.50 0.00];		% Heart Gold
case 'heliotrope';             cx = '#DF73FF';	c = [0.87 0.45 1.00];		% Heliotrope
case 'hollywoodcerise';        cx = '#F400A1';	c = [0.96 0.00 0.63];		% Hollywood cerise
case 'honeydew';               cx = '#F0FFF0';	c = [0.94 1.00 0.94];		% Honeydew
case 'hookersgreen';           cx = '#007000';	c = [0.00 0.44 0.00];		% Hooker's green
case 'hotmagenta';             cx = '#FF1DCE';	c = [1.00 0.11 0.81];		% Hot magenta
case 'hotpink';                cx = '#FF69B4';	c = [1.00 0.41 0.71];		% Hot pink
case 'huntergreen';            cx = '#355E3B';	c = [0.21 0.37 0.23];		% Hunter green
case 'iceberg';                cx = '#71A6D2';	c = [0.44 0.65 0.82];		% Iceberg
case 'icterine';               cx = '#FCF75E';	c = [0.99 0.97 0.37];		% Icterine
case 'inchworm';               cx = '#B2EC5D';	c = [0.70 0.93 0.36];		% Inchworm
case 'indiagreen';             cx = '#138808';	c = [0.07 0.53 0.03];		% India green
case 'indianred';              cx = '#CD5C5C';	c = [0.80 0.36 0.36];		% Indian red
case 'indianyellow';           cx = '#E3A857';	c = [0.89 0.66 0.34];		% Indian yellow
case 'indigo(dye)';            cx = '#00416A';	c = [0.00 0.25 0.42];		% Indigo (dye)
case 'indigo(web)';            cx = '#4B0082';	c = [0.29 0.00 0.51];		% Indigo (web)
case 'internationalkleinblue'; cx = '#002FA7';	c = [0.00 0.18 0.65];		% International Klein Blue
case 'internationalorange';    cx = '#FF4F00';	c = [1.00 0.31 0.00];		% International orange
case 'iris';                   cx = '#5A4FCF';	c = [0.35 0.31 0.81];		% Iris
case 'isabelline';             cx = '#F4F0EC';	c = [0.96 0.94 0.93];		% Isabelline
case 'islamicgreen';           cx = '#009000';	c = [0.00 0.56 0.00];		% Islamic green
case 'ivory';                  cx = '#FFFFF0';	c = [1.00 1.00 0.94];		% Ivory
case 'jade';                   cx = '#00A86B';	c = [0.00 0.66 0.42];		% Jade
case 'jasper';                 cx = '#D73B3E';	c = [0.84 0.23 0.24];		% Jasper
case 'jazzberryjam';           cx = '#A50B5E';	c = [0.65 0.04 0.37];		% Jazzberry jam
case 'jonquil';                cx = '#FADA5E';	c = [0.98 0.85 0.37];		% Jonquil
case 'junebud';                cx = '#BDDA57';	c = [0.74 0.85 0.34];		% June bud
case 'junglegreen';            cx = '#29AB87';	c = [0.16 0.67 0.53];		% Jungle green
case 'kellygreen';             cx = '#4CBB17';	c = [0.30 0.73 0.09];		% Kelly green
case 'khaki(html/css)(khaki)'; cx = '#C3B091';	c = [0.76 0.69 0.57];		% Khaki (HTML/CSS) (Khaki)
case 'khaki(x11)(lightkhaki)'; cx = '#F0E68C';	c = [0.94 0.90 0.55];		% Khaki (X11) (Light khaki)
case 'lasallegreen';           cx = '#087830';	c = [0.03 0.47 0.19];		% La Salle Green
case 'languidlavender';        cx = '#D6CADD';	c = [0.84 0.79 0.87];		% Languid lavender
case 'lapislazuli';            cx = '#26619C';	c = [0.15 0.38 0.61];		% Lapis lazuli
case 'laserlemon';             cx = '#FEFE22';	c = [1.00 1.00 0.13];		% Laser Lemon
case 'lava';                   cx = '#CF1020';	c = [0.81 0.06 0.13];		% Lava
case 'lavender(floral)';       cx = '#B57EDC';	c = [0.71 0.49 0.86];		% Lavender (floral)
case 'lavender(web)';          cx = '#E6E6FA';	c = [0.90 0.90 0.98];		% Lavender (web)
case 'lavenderblue';           cx = '#CCCCFF';	c = [0.80 0.80 1.00];		% Lavender blue
case 'lavenderblush';          cx = '#FFF0F5';	c = [1.00 0.94 0.96];		% Lavender blush
case 'lavendergray';           cx = '#C4C3D0';	c = [0.77 0.76 0.82];		% Lavender gray
case 'lavenderindigo';         cx = '#9457EB';	c = [0.58 0.34 0.92];		% Lavender indigo
case 'lavendermagenta';        cx = '#EE82EE';	c = [0.93 0.51 0.93];		% Lavender magenta
case 'lavendermist';           cx = '#E6E6FA';	c = [0.90 0.90 0.98];		% Lavender mist
case 'lavenderpink';           cx = '#FBAED2';	c = [0.98 0.68 0.82];		% Lavender pink
case 'lavenderpurple';         cx = '#967BB6';	c = [0.59 0.48 0.71];		% Lavender purple
case 'lavenderrose';           cx = '#FBA0E3';	c = [0.98 0.63 0.89];		% Lavender rose
case 'lawngreen';              cx = '#7CFC00';	c = [0.49 0.99 0.00];		% Lawn green
case 'lemon';                  cx = '#FFF700';	c = [1.00 0.97 0.00];		% Lemon
case 'lemonchiffon';           cx = '#FFFACD';	c = [1.00 0.98 0.80];		% Lemon chiffon
case 'lightapricot';           cx = '#FDD5B1';	c = [0.99 0.84 0.69];		% Light apricot
case 'lightblue';              cx = '#ADD8E6';	c = [0.68 0.85 0.90];		% Light blue
case 'lightbrown';             cx = '#B5651D';	c = [0.71 0.40 0.11];		% Light brown
case 'lightcarminepink';       cx = '#E66771';	c = [0.90 0.40 0.38];		% Light carmine pink
case 'lightcoral';             cx = '#F08080';	c = [0.94 0.50 0.50];		% Light coral
case 'lightcornflowerblue';    cx = '#93CCEA';	c = [0.60 0.81 0.93];		% Light cornflower blue
case 'lightcyan';              cx = '#E0FFFF';	c = [0.88 1.00 1.00];		% Light cyan
case 'lightfuchsiapink';       cx = '#F984EF';	c = [0.98 0.52 0.90];		% Light fuchsia pink
case 'lightgoldenrodyellow';   cx = '#FAFAD2';	c = [0.98 0.98 0.82];		% Light goldenrod yellow
case 'lightgray';              cx = '#D3D3D3';	c = [0.83 0.83 0.83];		% Light gray
case 'lightgreen';             cx = '#90EE90';	c = [0.56 0.93 0.56];		% Light green
case 'lightkhaki';             cx = '#F0E68C';	c = [0.94 0.90 0.55];		% Light khaki
case 'lightmauve';             cx = '#DCD0FF';	c = [0.86 0.82 1.00];		% Light mauve
case 'lightpastelpurple';      cx = '#B19CD9';	c = [0.69 0.61 0.85];		% Light pastel purple
case 'lightpink';              cx = '#FFB6C1';	c = [1.00 0.71 0.76];		% Light pink
case 'lightsalmon';            cx = '#FFA07A';	c = [1.00 0.63 0.48];		% Light salmon
case 'lightsalmonpink';        cx = '#FF9999';	c = [1.00 0.60 0.60];		% Light salmon pink
case 'lightseagreen';          cx = '#20B2AA';	c = [0.13 0.70 0.67];		% Light sea green
case 'lightskyblue';           cx = '#87CEEB';	c = [0.53 0.81 0.98];		% Light sky blue
case 'lightslategray';         cx = '#778899';	c = [0.47 0.53 0.60];		% Light slate gray
case 'lighttaupe';             cx = '#B38B6D';	c = [0.70 0.55 0.43];		% Light taupe
case 'lightthulianpink';       cx = '#E68FAC';	c = [0.90 0.56 0.67];		% Light Thulian pink
case 'lightyellow';            cx = '#FFFFED';	c = [1.00 1.00 0.88];		% Light yellow
case 'lilac';                  cx = '#C8A2C8';	c = [0.78 0.64 0.78];		% Lilac
case 'lime(colorwheel)';       cx = '#BFFF00';	c = [0.75 1.00 0.00];		% Lime (color wheel)
case 'lime(web)';              cx = '#00FF00';	c = [0.00 1.00 0.00];		% Lime (web) (X11 green)
case 'limegreen';              cx = '#32CD32';	c = [0.20 0.80 0.20];		% Lime green
case 'lincolngreen';           cx = '#195905';	c = [0.11 0.35 0.02];		% Lincoln green
case 'linen';                  cx = '#FAF0E6';	c = [0.98 0.94 0.90];		% Linen
case 'liver';                  cx = '#534B4F';	c = [0.33 0.29 0.31];		% Liver
case 'lust';                   cx = '#E62020';	c = [0.90 0.13 0.13];		% Lust
case 'macaroniandcheese';      cx = '#FFBD88';	c = [1.00 0.74 0.53];		% Macaroni and Cheese
case 'magenta';                cx = '#FF00FF';	c = [1.00 0.00 1.00];		% Magenta
case 'magenta(dye)';           cx = '#CA1F7B';	c = [0.79 0.08 0.48];		% Magenta (dye)
case 'magenta(process)';       cx = '#FF0090';	c = [1.00 0.00 0.56];		% Magenta (process)
case 'magicmint';              cx = '#AAF0D1';	c = [0.67 0.94 0.82];		% Magic mint
case 'magnolia';               cx = '#F8F4FF';	c = [0.97 0.96 1.00];		% Magnolia
case 'mahogany';               cx = '#C04000';	c = [0.75 0.25 0.00];		% Mahogany
case 'maize';                  cx = '#FBEC5D';	c = [0.98 0.93 0.37];		% Maize
case 'majorelleblue';          cx = '#6050DC';	c = [0.38 0.31 0.86];		% Majorelle Blue
case 'malachite';              cx = '#0BDA51';	c = [0.04 0.85 0.32];		% Malachite
case 'manatee';                cx = '#979AAA';	c = [0.59 0.60 0.67];		% Manatee
case 'mangotango';             cx = '#FF8243';	c = [1.00 0.51 0.26];		% Mango Tango
case 'maroon(html/css)';       cx = '#800000';	c = [0.50 0.00 0.00];		% Maroon (HTML/CSS)
case 'maroon(x11)';            cx = '#B03060';	c = [0.69 0.19 0.38];		% Maroon (X11)
case 'mauve';                  cx = '#E0B0FF';	c = [0.88 0.69 1.00];		% Mauve
case 'mauvetaupe';             cx = '#915F6D';	c = [0.57 0.37 0.43];		% Mauve taupe
case 'mauvelous';              cx = '#EF98AA';	c = [0.94 0.60 0.67];		% Mauvelous
case 'mayablue';               cx = '#73C2FB';	c = [0.45 0.76 0.98];		% Maya blue
case 'meatbrown';              cx = '#E5B73B';	c = [0.90 0.72 0.23];		% Meat brown
case 'mediumaquamarine';       cx = '#66DDAA';	c = [0.40 0.80 0.67];		% Medium aquamarine
case 'mediumblue';             cx = '#0000CD';	c = [0.00 0.00 0.80];		% Medium blue
case 'mediumcandyapplered';    cx = '#E2062C';	c = [0.89 0.02 0.17];		% Medium candy apple red
case 'mediumcarmine';          cx = '#AF4035';	c = [0.69 0.25 0.21];		% Medium carmine
case 'mediumchampagne';        cx = '#F3E5AB';	c = [0.95 0.90 0.67];		% Medium champagne
case 'mediumelectricblue';     cx = '#035096';	c = [0.01 0.31 0.59];		% Medium electric blue
case 'mediumjunglegreen';      cx = '#1C352D';	c = [0.11 0.21 0.18];		% Medium jungle green
case 'mediumlavendermagenta';  cx = '#DDA0DD';	c = [0.80 0.60 0.80];		% Medium lavender magenta
case 'mediumorchid';           cx = '#BA55D3';	c = [0.73 0.33 0.83];		% Medium orchid
case 'mediumpersianblue';      cx = '#0067A5';	c = [0.00 0.40 0.65];		% Medium Persian blue
case 'mediumpurple';           cx = '#9370DB';	c = [0.58 0.44 0.86];		% Medium purple
case 'mediumred-violet';       cx = '#BB3385';	c = [0.73 0.20 0.52];		% Medium red-violet
case 'mediumseagreen';         cx = '#3CB371';	c = [0.24 0.70 0.44];		% Medium sea green
case 'mediumslateblue';        cx = '#7B68EE';	c = [0.48 0.41 0.93];		% Medium slate blue
case 'mediumspringbud';        cx = '#C9DC87';	c = [0.79 0.86 0.54];		% Medium spring bud
case 'mediumspringgreen';      cx = '#00FA9A';	c = [0.00 0.98 0.60];		% Medium spring green
case 'mediumtaupe';            cx = '#674C47';	c = [0.40 0.30 0.28];		% Medium taupe
case 'mediumtealblue';         cx = '#0054B4';	c = [0.00 0.33 0.71];		% Medium teal blue
case 'mediumturquoise';        cx = '#48D1CC';	c = [0.28 0.82 0.80];		% Medium turquoise
case 'mediumviolet-red';       cx = '#C71585';	c = [0.78 0.08 0.52];		% Medium violet-red
case 'melon';                  cx = '#FDBCB4';	c = [0.99 0.74 0.71];		% Melon
case 'midnightblue';           cx = '#191970';	c = [0.10 0.10 0.44];		% Midnight blue
case 'midnightgreen';          cx = '#004953';	c = [0.00 0.29 0.33];		% Midnight green (eagle green)
case 'mikadoyellow';           cx = '#FFC40C';	c = [1.00 0.77 0.05];		% Mikado yellow
case 'mint';                   cx = '#3EB489';	c = [0.24 0.71 0.54];		% Mint
case 'mintcream';              cx = '#F5FFFA';	c = [0.96 1.00 0.98];		% Mint cream
case 'mintgreen';              cx = '#98FF98';	c = [0.60 1.00 0.60];		% Mint green
case 'mistyrose';              cx = '#FFE4E1';	c = [1.00 0.89 0.88];		% Misty rose
case 'moccasin';               cx = '#FAEBD7';	c = [0.98 0.92 0.84];		% Moccasin
case 'modebeige';              cx = '#967117';	c = [0.59 0.44 0.09];		% Mode beige
case 'moonstoneblue';          cx = '#73A9C2';	c = [0.45 0.66 0.76];		% Moonstone blue
case 'mordantred19';           cx = '#AE0C00';	c = [0.68 0.05 0.00];		% Mordant red 19
case 'mossgreen';              cx = '#ADDFAD';	c = [0.68 0.87 0.68];		% Moss green
case 'mountainmeadow';         cx = '#30BA8F';	c = [0.19 0.73 0.56];		% Mountain Meadow
case 'mountbattenpink';        cx = '#997A8D';	c = [0.60 0.48 0.55];		% Mountbatten pink
case 'mulberry';               cx = '#C54B8C';	c = [0.77 0.29 0.55];		% Mulberry
case 'mustard';                cx = '#FFDB58';	c = [1.00 0.86 0.35];		% Mustard
case 'myrtle';                 cx = '#21421E';	c = [0.13 0.26 0.12];		% Myrtle
case 'msugreen';               cx = '#18453B';	c = [0.09 0.27 0.23];		% MSU Green
case 'nadeshikopink';          cx = '#F6ADC6';	c = [0.96 0.68 0.78];		% Nadeshiko pink
case 'napiergreen';            cx = '#2A8000';	c = [0.16 0.50 0.00];		% Napier green
case 'naplesyellow';           cx = '#FADA5E';	c = [0.98 0.85 0.37];		% Naples yellow
case 'navajowhite';            cx = '#FFDEAD';	c = [1.00 0.87 0.68];		% Navajo white
case 'navyblue';               cx = '#000080';	c = [0.00 0.00 0.50];		% Navy blue
case 'neoncarrot';             cx = '#FFA343';	c = [1.00 0.64 0.26];		% Neon Carrot
case 'neonfuchsia';            cx = '#FE59C2';	c = [1.00 0.25 0.39];		% Neon fuchsia
case 'neongreen';              cx = '#39FF14';	c = [0.22 0.88 0.08];		% Neon green
case 'non-photoblue';          cx = '#A4DDED';	c = [0.64 0.87 0.93];		% Non-photo blue
case 'oceanboatblue';          cx = '#0077BE';	c = [0.00 0.47 0.75];		% Ocean Boat Blue
case 'ochre';                  cx = '#CC7722';	c = [0.80 0.47 0.13];		% Ochre
case 'officegreen';            cx = '#008000';	c = [0.00 0.50 0.00];		% Office green
case 'oldgold';                cx = '#CFB53B';	c = [0.81 0.71 0.23];		% Old gold
case 'oldlace';                cx = '#FDF5E6';	c = [0.99 0.96 0.90];		% Old lace
case 'oldlavender';            cx = '#796878';	c = [0.47 0.41 0.47];		% Old lavender
case 'oldmauve';               cx = '#673147';	c = [0.40 0.19 0.28];		% Old mauve
case 'oldrose';                cx = '#C08081';	c = [0.75 0.50 0.51];		% Old rose
case 'olive';                  cx = '#808000';	c = [0.50 0.50 0.00];		% Olive
case 'olivedrab3';             cx = '#6B8E23';	c = [0.42 0.56 0.14];		% Olive Drab (web) (Olive Drab3)
case 'olivedrab7';             cx = '#3C341F';	c = [0.24 0.20 0.12];		% Olive Drab 7
case 'olivine';                cx = '#9AB973';	c = [0.60 0.73 0.45];		% Olivine
case 'onyx';                   cx = '#0F0F0F';	c = [0.06 0.06 0.06];		% Onyx
case 'operamauve';             cx = '#B784A7';	c = [0.72 0.52 0.65];		% Opera mauve
case 'orange(colorwheel)';     cx = '#FF7F00';	c = [1.00 0.50 0.00];		% Orange (color wheel)
case 'orange(ryb)';            cx = '#FB9902';	c = [0.98 0.60 0.01];		% Orange (RYB)
case 'orange(webcolor)';       cx = '#FFA500';	c = [1.00 0.65 0.00];		% Orange (web color)
case 'orangepeel';             cx = '#FF9F00';	c = [1.00 0.62 0.00];		% Orange peel
case 'orange-red';             cx = '#FF4500';	c = [1.00 0.27 0.00];		% Orange-red
case 'orchid';                 cx = '#DA70D6';	c = [0.85 0.44 0.84];		% Orchid
case 'otterbrown';             cx = '#654321';	c = [0.40 0.26 0.13];		% Otter brown
case 'outerspace';             cx = '#414A4C';	c = [0.25 0.29 0.30];		% Outer Space
case 'outrageousorange';       cx = '#FF6E4A';	c = [1.00 0.43 0.29];		% Outrageous Orange
case 'oxfordblue';             cx = '#002147';	c = [0.00 0.13 0.28];		% Oxford Blue
case 'oucrimsonred';           cx = '#990000';	c = [0.60 0.00 0.00];		% OU Crimson Red
case 'pakistangreen';          cx = '#006600';	c = [0.00 0.40 0.00];		% Pakistan green
case 'palatinateblue';         cx = '#273BE2';	c = [0.15 0.23 0.89];		% Palatinate blue
case 'palatinatepurple';       cx = '#682860';	c = [0.41 0.16 0.38];		% Palatinate purple
case 'paleaqua';               cx = '#BCD4E6';	c = [0.74 0.83 0.90];		% Pale aqua
case 'paleblue';               cx = '#AFEEEE';	c = [0.69 0.93 0.93];		% Pale blue
case 'palebrown';              cx = '#987654';	c = [0.60 0.46 0.33];		% Pale brown
case 'palecarmine';            cx = '#AF4035';	c = [0.69 0.25 0.21];		% Pale carmine
case 'palecerulean';           cx = '#9BC4E2';	c = [0.61 0.77 0.89];		% Pale cerulean
case 'palechestnut';           cx = '#DDADAF';	c = [0.87 0.68 0.69];		% Pale chestnut
case 'palecopper';             cx = '#DA8A67';	c = [0.85 0.54 0.40];		% Pale copper
case 'palecornflowerblue';     cx = '#ABCDEF';	c = [0.67 0.80 0.94];		% Pale cornflower blue
case 'palegold';               cx = '#E6BE8A';	c = [0.90 0.75 0.54];		% Pale gold
case 'palegoldenrod';          cx = '#EEE8AA';	c = [0.93 0.91 0.67];		% Pale goldenrod
case 'palegreen';              cx = '#98FB98';	c = [0.60 0.98 0.60];		% Pale green
case 'palemagenta';            cx = '#F984E5';	c = [0.98 0.52 0.90];		% Pale magenta
case 'palepink';               cx = '#FADADD';	c = [0.98 0.85 0.87];		% Pale pink
case 'paleplum';               cx = '#DDA0DD';	c = [0.80 0.60 0.80];		% Pale plum
case 'palered-violet';         cx = '#DB7093';	c = [0.86 0.44 0.58];		% Pale red-violet
case 'palerobineggblue';       cx = '#96DED1';	c = [0.59 0.87 0.82];		% Pale robin egg blue
case 'palesilver';             cx = '#C9C0BB';	c = [0.79 0.75 0.73];		% Pale silver
case 'palespringbud';          cx = '#ECEBBD';	c = [0.93 0.92 0.74];		% Pale spring bud
case 'paletaupe';              cx = '#BC987E';	c = [0.74 0.60 0.49];		% Pale taupe
case 'paleviolet-red';         cx = '#DB7093';	c = [0.86 0.44 0.58];		% Pale violet-red
case 'pansypurple';            cx = '#78184A';	c = [0.47 0.09 0.29];		% Pansy purple
case 'papayawhip';             cx = '#FFEFD5';	c = [1.00 0.94 0.84];		% Papaya whip
case 'parisgreen';             cx = '#50C878';	c = [0.31 0.78 0.47];		% Paris Green
case 'pastelblue';             cx = '#AEC6CF';	c = [0.68 0.78 0.81];		% Pastel blue
case 'pastelbrown';            cx = '#836953';	c = [0.51 0.41 0.33];		% Pastel brown
case 'pastelgray';             cx = '#CFCFC4';	c = [0.81 0.81 0.77];		% Pastel gray
case 'pastelgreen';            cx = '#77DD77';	c = [0.47 0.87 0.47];		% Pastel green
case 'pastelmagenta';          cx = '#F49AC2';	c = [0.96 0.60 0.76];		% Pastel magenta
case 'pastelorange';           cx = '#FFB347';	c = [1.00 0.70 0.28];		% Pastel orange
case 'pastelpink';             cx = '#FFD1DC';	c = [1.00 0.82 0.86];		% Pastel pink
case 'pastelpurple';           cx = '#B39EB5';	c = [0.70 0.62 0.71];		% Pastel purple
case 'pastelred';              cx = '#FF6961';	c = [1.00 0.41 0.38];		% Pastel red
case 'pastelviolet';           cx = '#CB99C9';	c = [0.80 0.60 0.79];		% Pastel violet
case 'pastelyellow';           cx = '#FDFD96';	c = [0.99 0.99 0.59];		% Pastel yellow
case 'patriarch';              cx = '#800080';	c = [0.50 0.00 0.50];		% Patriarch
case 'paynesgrey';             cx = '#40404F';	c = [0.25 0.25 0.28];		% Payne's grey
case 'peach';                  cx = '#FFE5B4';	c = [1.00 0.90 0.71];		% Peach
case 'peach-orange';           cx = '#FFCC99';	c = [1.00 0.80 0.60];		% Peach-orange
case 'peachpuff';              cx = '#FFDAB9';	c = [1.00 0.85 0.73];		% Peach puff
case 'peach-yellow';           cx = '#FADFAD';	c = [0.98 0.87 0.68];		% Peach-yellow
case 'pear';                   cx = '#D1E231';	c = [0.82 0.89 0.19];		% Pear
case 'pearl';                  cx = '#F0EAD6';	c = [0.94 0.92 0.84];		% Pearl
case 'peridot';                cx = '#E6E200';	c = [0.90 0.89 0.00];		% Peridot
case 'periwinkle';             cx = '#CCCCFF';	c = [0.80 0.80 1.00];		% Periwinkle
case 'persianblue';            cx = '#1C39BB';	c = [0.11 0.22 0.73];		% Persian blue
case 'persiangreen';           cx = '#00A693';	c = [0.00 0.65 0.58];		% Persian green
case 'persianindigo';          cx = '#32127A';	c = [0.20 0.07 0.48];		% Persian indigo
case 'persianorange';          cx = '#D99058';	c = [0.85 0.56 0.35];		% Persian orange
case 'peru';                   cx = '#CD853F';	c = [0.80 0.52 0.25];		% Peru
case 'persianpink';            cx = '#F77FBE';	c = [0.97 0.50 0.75];		% Persian pink
case 'persianplum';            cx = '#701C1C';	c = [0.44 0.11 0.11];		% Persian plum
case 'persianred';             cx = '#CC3333';	c = [0.80 0.20 0.20];		% Persian red
case 'persianrose';            cx = '#FE28A2';	c = [1.00 0.16 0.64];		% Persian rose
case 'persimmon';              cx = '#EC5800';	c = [0.93 0.35 0.00];		% Persimmon
case 'phlox';                  cx = '#DF00FF';	c = [0.87 0.00 1.00];		% Phlox
case 'phthaloblue';            cx = '#000F89';	c = [0.00 0.06 0.54];		% Phthalo blue
case 'phthalogreen';           cx = '#123524';	c = [0.07 0.21 0.14];		% Phthalo green
case 'piggypink';              cx = '#FDDDE6';	c = [0.99 0.87 0.90];		% Piggy pink
case 'pinegreen';              cx = '#01796F';	c = [0.00 0.47 0.44];		% Pine green
case 'pink';                   cx = '#FFC0CB';	c = [1.00 0.75 0.80];		% Pink
case 'pink-orange';            cx = '#FF9966';	c = [1.00 0.60 0.40];		% Pink-orange
case 'pinkpearl';              cx = '#E7ACCF';	c = [0.91 0.67 0.81];		% Pink pearl
case 'pinksherbet';            cx = '#F78FA7';	c = [0.97 0.56 0.65];		% Pink Sherbet
case 'pistachio';              cx = '#93C572';	c = [0.58 0.77 0.45];		% Pistachio
case 'platinum';               cx = '#E5E4E2';	c = [0.90 0.89 0.89];		% Platinum
case 'plum';                   cx = '#8E4585';	c = [0.56 0.27 0.52];		% Plum (traditional)
case 'plum(web)';              cx = '#DDA0DD';	c = [0.80 0.60 0.80];		% Plum (web)
case 'portlandorange';         cx = '#FF5A36';	c = [1.00 0.35 0.21];		% Portland Orange
case 'powderblue(web)';        cx = '#B0E0E6';	c = [0.69 0.88 0.90];		% Powder blue (web)
case 'princetonorange';        cx = '#FF8F00';	c = [1.00 0.56 0.00];		% Princeton orange
case 'prune';                  cx = '#701C1C';	c = [0.44 0.11 0.11];		% Prune
case 'prussianblue';           cx = '#003153';	c = [0.00 0.19 0.33];		% Prussian blue
case 'psychedelicpurple';      cx = '#DF00FF';	c = [0.87 0.00 1.00];		% Psychedelic purple
case 'puce';                   cx = '#CC8899';	c = [0.80 0.53 0.60];		% Puce
case 'pumpkin';                cx = '#FF7518';	c = [1.00 0.46 0.09];		% Pumpkin
case 'purple(html/css)';       cx = '#800080';	c = [0.50 0.00 0.50];		% Purple (HTML/CSS)
case 'purple(munsell)';        cx = '#9F00C5';	c = [0.62 0.00 0.77];		% Purple (Munsell)
case 'purple(x11)';            cx = '#A020F0';	c = [0.63 0.36 0.94];		% Purple (X11)
case 'purpleheart';            cx = '#69359C';	c = [0.41 0.21 0.61];		% Purple Heart
case 'purplemountainmajesty';  cx = '#9678B6';	c = [0.59 0.47 0.71];		% Purple mountain majesty
case 'purplepizzazz';          cx = '#FE4EDA';	c = [1.00 0.31 0.85];		% Purple pizzazz
case 'purpletaupe';            cx = '#50404D';	c = [0.31 0.25 0.30];		% Purple taupe
case 'radicalred';             cx = '#FF355E';	c = [1.00 0.21 0.37];		% Radical Red
case 'raspberry';              cx = '#E30B5D';	c = [0.89 0.04 0.36];		% Raspberry
case 'raspberryglace';         cx = '#915F6D';	c = [0.57 0.37 0.43];		% Raspberry glace
case 'raspberrypink';          cx = '#E25098';	c = [0.89 0.31 0.61];		% Raspberry pink
case 'raspberryrose';          cx = '#B3446C';	c = [0.70 0.27 0.42];		% Raspberry rose
case 'rawumber';               cx = '#826644';	c = [0.51 0.40 0.27];		% Raw umber
case 'razzledazzlerose';       cx = '#FF33CC';	c = [1.00 0.20 0.80];		% Razzle dazzle rose
case 'razzmatazz';             cx = '#E3256B';	c = [0.89 0.15 0.42];		% Razzmatazz
case 'red';                    cx = '#FF0000';	c = [1.00 0.00 0.00];		% Red
case 'red(munsell)';           cx = '#F2003C';	c = [0.95 0.00 0.24];		% Red (Munsell)
case 'red(ncs)';               cx = '#C40233';	c = [0.77 0.01 0.20];		% Red (NCS)
case 'red(pigment)';           cx = '#ED1C24';	c = [0.93 0.11 0.14];		% Red (pigment)
case 'red(ryb)';               cx = '#FE2712';	c = [1.00 0.15 0.07];		% Red (RYB)
case 'red-brown';              cx = '#A52A2A';	c = [0.65 0.16 0.16];		% Red-brown
case 'red-violet';             cx = '#C71585';	c = [0.78 0.08 0.52];		% Red-violet
case 'redwood';                cx = '#AB4E52';	c = [0.67 0.31 0.32];		% Redwood
case 'regalia';                cx = '#522D80';	c = [0.32 0.18 0.50];		% Regalia
case 'richblack';              cx = '#004040';	c = [0.00 0.25 0.25];		% Rich black
case 'richbrilliantlavender';  cx = '#F1A7FE';	c = [0.95 0.65 1.00];		% Rich brilliant lavender
case 'richcarmine';            cx = '#D70040';	c = [0.84 0.00 0.25];		% Rich carmine
case 'richelectricblue';       cx = '#0892D0';	c = [0.03 0.57 0.82];		% Rich electric blue
case 'richlavender';           cx = '#A76BCF';	c = [0.67 0.38 0.80];		% Rich lavender
case 'richlilac';              cx = '#B666D2';	c = [0.71 0.40 0.82];		% Rich lilac
case 'richmaroon';             cx = '#B03060';	c = [0.69 0.19 0.38];		% Rich maroon
case 'riflegreen';             cx = '#414833';	c = [0.25 0.28 0.20];		% Rifle green
case 'robineggblue';           cx = '#00CCCC';	c = [0.00 0.80 0.80];		% Robin egg blue
case 'rose';                   cx = '#FF007F';	c = [1.00 0.00 0.50];		% Rose
case 'rosebonbon';             cx = '#F9429E';	c = [0.98 0.26 0.62];		% Rose bonbon
case 'roseebony';              cx = '#674846';	c = [0.40 0.30 0.28];		% Rose ebony
case 'rosegold';               cx = '#B76E79';	c = [0.72 0.43 0.47];		% Rose gold
case 'rosemadder';             cx = '#E32636';	c = [0.89 0.15 0.21];		% Rose madder
case 'rosepink';               cx = '#FF66CC';	c = [1.00 0.40 0.80];		% Rose pink
case 'rosequartz';             cx = '#AA98A9';	c = [0.67 0.60 0.66];		% Rose quartz
case 'rosetaupe';              cx = '#905D5D';	c = [0.56 0.36 0.36];		% Rose taupe
case 'rosevale';               cx = '#AB4E52';	c = [0.67 0.31 0.32];		% Rose vale
case 'rosewood';               cx = '#65000B';	c = [0.40 0.00 0.04];		% Rosewood
case 'rossocorsa';             cx = '#D40000';	c = [0.83 0.00 0.00];		% Rosso corsa
case 'rosybrown';              cx = '#BC8F8F';	c = [0.74 0.56 0.56];		% Rosy brown
case 'royalazure';             cx = '#0038A8';	c = [0.00 0.22 0.66];		% Royal azure
case 'royalblue';              cx = '#002366';	c = [0.00 0.14 0.40];		% Royal blue (traditional)
case 'royalblue(web)';         cx = '#4169E1';	c = [0.25 0.41 0.88];		% Royal blue (web)
case 'royalfuchsia';           cx = '#CA2C92';	c = [0.79 0.17 0.57];		% Royal fuchsia
case 'royalpurple';            cx = '#7851A9';	c = [0.47 0.32 0.66];		% Royal purple
case 'ruby';                   cx = '#E0115F';	c = [0.88 0.07 0.37];		% Ruby
case 'ruddy';                  cx = '#FF0028';	c = [1.00 0.00 0.16];		% Ruddy
case 'ruddybrown';             cx = '#BB6528';	c = [0.73 0.40 0.16];		% Ruddy brown
case 'ruddypink';              cx = '#E18E96';	c = [0.88 0.56 0.59];		% Ruddy pink
case 'rufous';                 cx = '#A81C07';	c = [0.66 0.11 0.03];		% Rufous
case 'russet';                 cx = '#80461B';	c = [0.50 0.27 0.11];		% Russet
case 'rust';                   cx = '#B7410E';	c = [0.72 0.25 0.05];		% Rust
case 'sacramentostategreen';   cx = '#00563F';	c = [0.00 0.34 0.25];		% Sacramento State green
case 'saddlebrown';            cx = '#8B4513';	c = [0.55 0.27 0.07];		% Saddle brown
case 'safetyorange';           cx = '#FF6700';	c = [1.00 0.40 0.00];		% Safety orange (blaze orange)
case 'saffron';                cx = '#F4C430';	c = [0.96 0.77 0.19];		% Saffron
case 'stpatricksblue';         cx = '#23297A';	c = [0.14 0.16 0.48];		% St. Patrick's blue
case 'salmon';                 cx = '#FF8C69';	c = [1.00 0.55 0.41];		% Salmon
case 'salmonpink';             cx = '#FF91A4';	c = [1.00 0.57 0.64];		% Salmon pink
case 'sand';                   cx = '#C2B280';	c = [0.76 0.70 0.50];		% Sand
case 'sanddune';               cx = '#967117';	c = [0.59 0.44 0.09];		% Sand dune
case 'sandstorm';              cx = '#ECD540';	c = [0.93 0.84 0.25];		% Sandstorm
case 'sandybrown';             cx = '#F4A460';	c = [0.96 0.64 0.38];		% Sandy brown
case 'sandytaupe';             cx = '#967117';	c = [0.59 0.44 0.09];		% Sandy taupe
case 'sangria';                cx = '#92000A';	c = [0.57 0.00 0.04];		% Sangria
case 'sapgreen';               cx = '#507D2A';	c = [0.31 0.49 0.16];		% Sap green
case 'sapphire';               cx = '#082567';	c = [0.03 0.15 0.40];		% Sapphire
case 'satinsheengold';         cx = '#CBA135';	c = [0.80 0.63 0.21];		% Satin sheen gold
case 'scarlet';                cx = '#FF2000';	c = [1.00 0.13 0.00];		% Scarlet
case 'schoolbusyellow';        cx = '#FFD800';	c = [1.00 0.85 0.00];		% School bus yellow
case 'screamingreen';          cx = '#76FF7A';	c = [0.46 1.00 0.44];		% Screamin' Green
case 'seagreen';               cx = '#2E8B57';	c = [0.18 0.55 0.34];		% Sea green
case 'sealbrown';              cx = '#321414';	c = [0.20 0.08 0.08];		% Seal brown
case 'seashell';               cx = '#FFF5EE';	c = [1.00 0.96 0.93];		% Seashell
case 'selectiveyellow';        cx = '#FFBA00';	c = [1.00 0.73 0.00];		% Selective yellow
case 'sepia';                  cx = '#704214';	c = [0.44 0.26 0.08];		% Sepia
case 'shadow';                 cx = '#8A795D';	c = [0.54 0.47 0.36];		% Shadow
case 'shamrockgreen';          cx = '#009E60';	c = [0.00 0.62 0.38];		% Shamrock green
case 'shockingpink';           cx = '#FC0FC0';	c = [0.99 0.06 0.75];		% Shocking pink
case 'sienna';                 cx = '#882D17';	c = [0.53 0.18 0.09];		% Sienna
case 'silver';                 cx = '#C0C0C0';	c = [0.75 0.75 0.75];		% Silver
case 'sinopia';                cx = '#CB410B';	c = [0.80 0.25 0.04];		% Sinopia
case 'skobeloff';              cx = '#007474';	c = [0.00 0.48 0.45];		% Skobeloff
case 'skyblue';                cx = '#87CEEB';	c = [0.53 0.81 0.92];		% Sky blue
case 'skymagenta';             cx = '#CF71AF';	c = [0.81 0.44 0.69];		% Sky magenta
case 'slateblue';              cx = '#6A5ACD';	c = [0.42 0.35 0.80];		% Slate blue
case 'slategray';              cx = '#708090';	c = [0.44 0.50 0.56];		% Slate gray
case 'smalt(darkpowderblue)';  cx = '#003399';	c = [0.00 0.20 0.60];		% Smalt (Dark powder blue)
case 'smokeytopaz';            cx = '#933D41';	c = [0.58 0.25 0.03];		% Smokey topaz
case 'smokyblack';             cx = '#100C08';	c = [0.06 0.05 0.03];		% Smoky black
case 'snow';                   cx = '#FFFAFA';	c = [1.00 0.98 0.98];		% Snow
case 'spirodiscoball';         cx = '#0FC0FC';	c = [0.06 0.75 0.99];		% Spiro Disco Ball
case 'splashedwhite';          cx = '#FEFDFF';	c = [1.00 0.99 1.00];		% Splashed white
case 'springbud';              cx = '#A7FC00';	c = [0.65 0.99 0.00];		% Spring bud
case 'springgreen';            cx = '#00FF7F';	c = [0.00 1.00 0.50];		% Spring green
case 'steelblue';              cx = '#4682B4';	c = [0.27 0.51 0.71];		% Steel blue
case 'stildegrainyellow';      cx = '#FADA5E';	c = [0.98 0.85 0.37];		% Stil de grain yellow
case 'straw';                  cx = '#E4D96F';	c = [0.89 0.85 0.44];		% Straw
case 'sunglow';                cx = '#FFCC33';	c = [1.00 0.80 0.20];		% Sunglow
case 'sunset';                 cx = '#FAD6A5';	c = [0.98 0.84 0.65];		% Sunset
case 'tan';                    cx = '#D2B48C';	c = [0.82 0.71 0.55];		% Tan
case 'tangelo';                cx = '#F94D00';	c = [0.98 0.30 0.00];		% Tangelo
case 'tangerine';              cx = '#F28500';	c = [0.95 0.52 0.00];		% Tangerine
case 'tangerineyellow';        cx = '#FFCC00';	c = [1.00 0.80 0.00];		% Tangerine yellow
case 'taupe';                  cx = '#483C32';	c = [0.28 0.24 0.20];		% Taupe
case 'taupegray';              cx = '#8B8589';	c = [0.55 0.52 0.54];		% Taupe gray
case 'teagreen';               cx = '#D0F0C0';	c = [0.82 0.94 0.75];		% Tea green
case 'tearose(orange)';        cx = '#F88379';	c = [0.97 0.51 0.47];		% Tea rose (orange)
case 'tearose(rose)';          cx = '#F4C2C2';	c = [0.96 0.76 0.76];		% Tea rose (rose)
case 'teal';                   cx = '#008080';	c = [0.00 0.50 0.50];		% Teal
case 'tealblue';               cx = '#367588';	c = [0.21 0.46 0.53];		% Teal blue
case 'tealgreen';              cx = '#006D5B';	c = [0.00 0.51 0.50];		% Teal green
case 'tenné(tawny)';           cx = '#CD5700';	c = [0.80 0.34 0.00];		% Tenné (Tawny)
case 'terracotta';             cx = '#E2725B';	c = [0.89 0.45 0.36];		% Terra cotta
case 'thistle';                cx = '#D8BFD8';	c = [0.85 0.75 0.85];		% Thistle
case 'thulianpink';            cx = '#DE6FA1';	c = [0.87 0.44 0.63];		% Thulian pink
case 'ticklemepink';           cx = '#FC89AC';	c = [0.99 0.54 0.67];		% Tickle Me Pink
case 'tiffanyblue';            cx = '#0ABAB5';	c = [0.04 0.73 0.71];		% Tiffany Blue
case 'tigerseye';              cx = '#E08D3C';	c = [0.88 0.55 0.24];		% Tiger's eye
case 'timberwolf';             cx = '#DBD7D2';	c = [0.86 0.84 0.82];		% Timberwolf
case 'titaniumyellow';         cx = '#EEE600';	c = [0.93 0.90 0.00];		% Titanium yellow
case 'tomato';                 cx = '#FF6347';	c = [1.00 0.39 0.28];		% Tomato
case 'toolbox';                cx = '#746CC0';	c = [0.45 0.42 0.75];		% Toolbox
case 'tractorred';             cx = '#FD0E35';	c = [0.99 0.05 0.21];		% Tractor red
case 'trolleygrey';            cx = '#808080';	c = [0.50 0.50 0.50];		% Trolley Grey
case 'tropicalrainforest';     cx = '#00755E';	c = [0.00 0.46 0.37];		% Tropical rain forest
case 'trueblue';               cx = '#0073CF';	c = [0.00 0.45 0.81];		% True Blue
case 'tuftsblue';              cx = '#417DC1';	c = [0.28 0.57 0.81];		% Tufts Blue
case 'tumbleweed';             cx = '#DEAA88';	c = [0.87 0.67 0.53];		% Tumbleweed
case 'turkishrose';            cx = '#B57281';	c = [0.71 0.45 0.51];		% Turkish rose
case 'turquoise';              cx = '#30D5C8';	c = [0.19 0.84 0.78];		% Turquoise
case 'turquoiseblue';          cx = '#00FFEF';	c = [0.00 1.00 0.94];		% Turquoise blue
case 'turquoisegreen';         cx = '#A0D6B4';	c = [0.63 0.84 0.71];		% Turquoise green
case 'tuscanred';              cx = '#823535';	c = [0.51 0.21 0.21];		% Tuscan red
case 'twilightlavender';       cx = '#8A496B';	c = [0.54 0.29 0.42];		% Twilight lavender
case 'tyrianpurple';           cx = '#66023C';	c = [0.40 0.01 0.24];		% Tyrian purple
case 'uablue';                 cx = '#0033AA';	c = [0.00 0.20 0.67];		% UA blue
case 'uared';                  cx = '#D9004C';	c = [0.85 0.00 0.30];		% UA red
case 'ube';                    cx = '#8878C3';	c = [0.53 0.47 0.76];		% Ube
case 'uclablue';               cx = '#536895';	c = [0.33 0.41 0.58];		% UCLA Blue
case 'uclagold';               cx = '#FFB300';	c = [1.00 0.70 0.00];		% UCLA Gold
case 'ufogreen';               cx = '#3CD070';	c = [0.24 0.82 0.44];		% UFO Green
case 'ultramarine';            cx = '#120A8F';	c = [0.07 0.04 0.56];		% Ultramarine
case 'ultramarineblue';        cx = '#4166F5';	c = [0.25 0.40 0.96];		% Ultramarine blue
case 'ultrapink';              cx = '#FF6FFF';	c = [1.00 0.44 1.00];		% Ultra pink
case 'umber';                  cx = '#635147';	c = [0.39 0.32 0.28];		% Umber
case 'unitednationsblue';      cx = '#5B92E5';	c = [0.36 0.57 0.90];		% United Nations blue
case 'unmellowyellow';         cx = '#FFFF66';	c = [1.00 1.00 0.40];		% Unmellow Yellow
case 'upforestgreen';          cx = '#014421';	c = [0.00 0.27 0.13];		% UP Forest green
case 'upmaroon';               cx = '#7B1113';	c = [0.48 0.07 0.07];		% UP Maroon
case 'upsdellred';             cx = '#AE2029';	c = [0.68 0.09 0.13];		% Upsdell red
case 'urobilin';               cx = '#E1AD21';	c = [0.88 0.68 0.13];		% Urobilin
case 'usccardinal';            cx = '#990000';	c = [0.60 0.00 0.00];		% USC Cardinal
case 'uscgold';                cx = '#FFCC00';	c = [1.00 0.80 0.00];		% USC Gold
case 'utahcrimson';            cx = '#D3003F';	c = [0.83 0.00 0.25];		% Utah Crimson
case 'vanilla';                cx = '#F3E5AB';	c = [0.95 0.90 0.67];		% Vanilla
case 'vegasgold';              cx = '#C5B358';	c = [0.77 0.70 0.35];		% Vegas gold
case 'venetianred';            cx = '#C80815';	c = [0.78 0.03 0.08];		% Venetian red
case 'verdigris';              cx = '#43B3AE';	c = [0.26 0.70 0.68];		% Verdigris
case 'vermilion';              cx = '#E34234';	c = [0.89 0.26 0.20];		% Vermilion
case 'veronica';               cx = '#A020F0';	c = [0.63 0.36 0.94];		% Veronica
case 'violet';                 cx = '#8F00FF';	c = [0.56 0.00 1.00];		% Violet
case 'violet(colorwheel)';     cx = '#7F00FF';	c = [0.50 0.00 1.00];		% Violet (color wheel)
case 'violet(ryb)';            cx = '#8601AF';	c = [0.53 0.00 0.69];		% Violet (RYB)
case 'violet(web)';            cx = '#EE82EE';	c = [0.93 0.51 0.93];		% Violet (web)
case 'viridian';               cx = '#40826D';	c = [0.25 0.51 0.43];		% Viridian
case 'vividauburn';            cx = '#922724';	c = [0.58 0.15 0.14];		% Vivid auburn
case 'vividburgundy';          cx = '#9F1D35';	c = [0.62 0.11 0.21];		% Vivid burgundy
case 'vividcerise';            cx = '#DA1D81';	c = [0.85 0.11 0.51];		% Vivid cerise
case 'vividtangerine';         cx = '#FFA089';	c = [1.00 0.63 0.54];		% Vivid tangerine
case 'vividviolet';            cx = '#9F00FF';	c = [0.62 0.00 1.00];		% Vivid violet
case 'warmblack';              cx = '#004242';	c = [0.00 0.26 0.26];		% Warm black
case 'wenge';                  cx = '#645452';	c = [0.39 0.33 0.32];		% Wenge
case 'wheat';                  cx = '#F5DEB3';	c = [0.96 0.87 0.70];		% Wheat
case 'white';                  cx = '#FFFFFF';	c = [1.00 1.00 1.00];		% White
case 'whitesmoke';             cx = '#F5F5F5';	c = [0.96 0.96 0.96];		% White smoke
case 'wildblueyonder';         cx = '#A2ADD0';	c = [0.64 0.68 0.82];		% Wild blue yonder
case 'wildstrawberry';         cx = '#FF43A4';	c = [1.00 0.26 0.64];		% Wild Strawberry
case 'wildwatermelon';         cx = '#FC6C85';	c = [0.99 0.42 0.52];		% Wild Watermelon
case 'wisteria';               cx = '#C9A0DC';	c = [0.79 0.63 0.86];		% Wisteria
case 'xanadu';                 cx = '#738678';	c = [0.45 0.53 0.47];		% Xanadu
case 'yaleblue';               cx = '#0F4D92';	c = [0.06 0.30 0.57];		% Yale Blue
case 'yellow';                 cx = '#FFFF00';	c = [1.00 1.00 0.00];		% Yellow
case 'yellow(munsell)';        cx = '#EFCC00';	c = [0.94 0.80 0.00];		% Yellow (Munsell)
case 'yellow(ncs)';            cx = '#FFD300';	c = [1.00 0.83 0.00];		% Yellow (NCS)
case 'yellow(process)';        cx = '#FFEF00';	c = [1.00 0.94 0.00];		% Yellow (process)
case 'yellow(ryb)';            cx = '#FEFE33';	c = [1.00 1.00 0.20];		% Yellow (RYB)
case 'yellow-green';           cx = '#9ACD32';	c = [0.60 0.80 0.20];		% Yellow-green
case 'zaffre';                 cx = '#0014A8';	c = [0.00 0.08 0.66];		% Zaffre
case 'zinnwalditebrown';       cx = '#2C1608';	c = [0.17 0.09 0.03];		% Zinnwaldite brown
% ARROW3 function
case 'k';                      cx = [];         c = [0.00,0.00,0.00];       % black
case 'y';                      cx = []; 		c = [1.00,1.00,0.00];       % yellow
case 'm';                      cx = []; 		c = [1.00,0.00,1.00];       % magenta
case 'c';                      cx = []; 		c = [0.00,1.00,1.00];       % cyan
case 'r';                      cx = []; 		c = [1.00,0.00,0.00];       % red 
case 'g';                      cx = []; 		c = [0.00,1.00,0.00];       % green
case 'b';                      cx = []; 		c = [0.00,0.00,1.00];       % blue
case 'a';                      cx = []; 		c = [0.42,0.59,0.24];       % asparagus
case 'd';                      cx = []; 		c = [0.25,0.25,0.25];       % dark gray
case 'e';                      cx = []; 		c = [0.00,0.50,0.00];       % evergreen
case 'f';   				   cx = []; 		c = [0.70,0.13,0.13];       % firebrick
case 'h';   				   cx = []; 		c = [1.00,0.41,0.71];       % hot pink
case 'i';   				   cx = []; 		c = [0.29,0.00,0.51];       % indigo
case 'j';   				   cx = []; 		c = [0.00,0.66,0.42];       % jade
case 'l';   				   cx = []; 		c = [0.50,0.50,0.50];       % light gray
case 'n';   				   cx = []; 		c = [0.50,0.20,0.00];       % nutbrown
case 'p';   				   cx = []; 		c = [0.75,0.75,0.00];       % pear
case 'q';   				   cx = []; 		c = [1.00,0.50,0.00];       % kumquat
case 's';   				   cx = []; 		c = [0.00,0.75,0.75];       % sky blue
case 't';   				   cx = []; 		c = [0.80,0.34,0.00];       % tawny
case 'u';   				   cx = []; 		c = [0.50,0.00,0.13];       % burgundy
case 'v';   				   cx = []; 		c = [0.75,0.00,0.75];       % violet
case 'z';   				   cx = []; 		c = [0.38,0.74,0.99];       % azure
case 'w';   				   cx = []; 		c = [1.00,1.00,1.00];       % white
% MATLAB extended table
case 'b2';  				   cx = '#0072BD';  c = [];  					% blue 
case 'f2';  				   cx = '#D95319';  c = [];              		% brick
case 'y2';  				   cx = '#EDB120';  c = [];              		% gold
case 'm2';  				   cx = '#7E2F8E';  c = [];              		% purple
case 'g2';  				   cx = '#77AC30';  c = [];              		% green 
case 'c2';  				   cx = '#4DBEEE';  c = [];              		% dark cyan
case 'u2';  				   cx = '#A2142F';  c = [];              		% burgundy
% max contr. colmaps : 'c1'
case 'bc';                     cx = [];         c = [0.17,0.21,0.59];       % blue
case 'rc';                     cx = [];         c = [0.94,0.30,0.13];       % red-orange
case 'dbc';                    cx = [];         c = [0.102,0.126,0.354];    % 0.6 x bc
% color not found
otherwise 
    error(strcat("Requested color '",sprintf(code(i)),"' is not in the colortable"));
end

% Covenrt to requested output type
switch fmt 
    case "hex"
        if exist('cx','var') && ~isempty(cx)
            cc = [cc; string(cx)];
        else 
            cc = [cc; string(rgb2hex(c))];
        end
    case "rgb"
        if isempty(c)
            cc = [cc; hex2rgb(cx)];
        else
            cc = [cc; c];
        end
end % code(i) conversion
end % FOR loop over output colors

% Reshape to 'code' dimensions if output is hex
if fmt=="hex"
    cc = reshape(cc,size(code));
end












