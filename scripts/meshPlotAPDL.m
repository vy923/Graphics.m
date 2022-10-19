%{
-------------------------------------
    Vladimir V. Yotov
    Te Pūnaha Ātea Space Institute
    University of Auckland

    Version: 10.02.2022
-------------------------------------

DESCRIPTION
    Reads in APDL mesh data. Currently supported:
        - Grid coordinates
        - Linear hex elements 
    Plots the mesh 

ASSUMES
    - Specific numeric format, i.e. it is not auto-retrieved from input file
    - All grids are in CSYS 0
    - Missing grid field implies zero
    - Grid and element IDs are pre-sorted
%}



% -----------------------------------------------
%                 I/O, PARSING
% -----------------------------------------------

% [Clean-up] workspace
clear all 
grootMod()

% Paths
locIn   = "C:\Users\vyot466\OneDrive - The University of Auckland\Code\Matlab\Misc projects\meshPlotAPDL\";     % directory
fileIn  = "flywheel.cdb";                                                   % file name

% Data flags 
flagG   = "NBLOCK";                                                         % coordinate block
flagS   = "EBLOCK";                                                         % connectivity matrix
endflag = string([repmat(' ',1,7) '-1']);                                   % end-of-block

% Read data 
A = textin(strcat(locIn,fileIn));

% Data block start row indices
startG = find(startsWith(A,flagG)) + 2;
startS = find(startsWith(A,flagS)) + 2;

% Data block end row indices
tmp = find(contains(A,endflag)) - 1;
endG = min(tmp(tmp>startG));
endS = min(tmp(tmp>startS));

% Build parsing formats 
fmtG = [repmat('%f',1,6) '\n'];
fmtS = repmat('%f',1,19);
opts = {'EmptyValue', 0, 'CollectOutput', true};

% Extract numerical data
datG = char(A(startG:endG));
datS = char(A(startS:endS));

datG = cell2mat( textscan( join(string(datG), newline), fmtG, opts{:}));
datS = cell2mat( textscan( join(string(datS), newline), fmtS, opts{:}));

% Drop unnecessary fields
G = datG(:,[1 4:end]);                      % [m x 4] [ID x y z]
S = datS(:,[11:end]);                       % [n x 9] [ID G1 G2 ... G9]
S = S(~any(S==0,2),:);                      % clear non-hex elements

% [Clean-up] workspace
clearvars *In flag* start* end* fmt* A dat* opts
 

% -----------------------------------------------
%                  BUILD MESH
% -----------------------------------------------

dg = [];                                    % indices of defective elements
nd = [];                                    % indices of non-defective elements
Q  = zeros(size(S,1),4);                    % quadrilateral face array

n = size(S,1);
m = '[%.0f/%.0f] solids';
h = waitbar(0,sprintf(m,0,n),'name','Computing hex faces...');   

for i = 1:n
    t = sort(S(i,2:end));                   % i-th element nodes, MUST be sorted
    [maskG,sortG] = ismember(G(:,1),t); 
    g = G(maskG,2:end);                     % filter grid data of t
    try
        Q(6*i-5:6*i,:) = t(grid2quad(g,false));
        nd = [nd, i];
    catch 
        dg = [dg; i];
    end

    if rem(i,ceil((n-1)/25))==0
        waitbar(i/ceil(n),h,sprintf(m,i,n))
    end
end
delete(h)

Q = Q(Q(:,1)~=0,:);
[~,idx] = unique(sort(Q,2),'rows');         % only unique nondegenerate faces
Q = Q(idx,:);


% -----------------------------------------------
%                     PLOT
% -----------------------------------------------

% Complete mesh without internal & defective faces
fig = figure(1);
    clf
    ax = axes('Position', [0 0 1 1]);
    rotate3d on
    hold on
    box on
    grid off
    axis equal
    warning off
    showLight = true;

opts.lgt = {'style'         'local'
            'color'         col('w')
            }'; 

opts.p = {  'FaceColor'     col('x11gray')
            'EdgeColor'     'k'
            'LineStyle'     '-'  
            'LineWidth'     0.2
            'EdgeAlpha'     0.5  
            'FaceAlpha'     1.0 
            'FaceLighting'  'gouraud'
            }';

p = patch('Faces', Q, 'Vertices', G(:,2:end), opts.p{:});

if showLight
    lgt = light(opts.lgt{:});
    p.FaceColor = col('w');
    ax.Color = col('k');
    p.EdgeLighting = 'gouraud';
end


% Defective face nodes
if false
fig = figure(2);
    rotate3d on
    hold on
    grid on

D  = unique(S(dg,2:end));
GD = G(D,2:end);
N  = unique(S(nd,2:end));
GN = G(N,2:end);

sd = scatter3(GD(:,1),GD(:,2),GD(:,3),'filled','MarkerFaceColor','r');      % defective
sn = scatter3(GN(:,1),GN(:,2),GN(:,3),'filled','sizedata',18, ...
                'MarkerFaceColor','k','MarkerFaceAlpha',.1);                % nondefective
end


% -----------------------------------------------
%                   FUNCTIONS
% -----------------------------------------------
%{
Returns the quadrilateral connectivity mesh of the convex hull of 3 x N 
grid array g. Computed by
[1] get a convex hull triangulation
[2] compute face unit normals of all triangles
[3] get the NxN (symmetric) inner product matrix of the face normals. If
    enforceAdj==true, only adjacent faces are checked. Less efficient. 
[4] find the indices of 2 largest values per column corresponding to 
    nearly identical normals, i.e. Nx2 matrix
[5] find unique rows corresponding to coplanar triangles
[6] merge coplanar tris into ordered 4-node faces
%}
function Q = grid2quad(g,enforceAdj)

k   = convhull(g);
e12 = g(k(:,2),:) - g(k(:,1),:);                                            % vector edge P1-P2
e23 = g(k(:,3),:) - g(k(:,2),:);                                            % vector of P2-P3
vn  = cross(e12,e23);                                                       % face normal
vn  = vn./vecnorm(vn,2,2);                                                  % get unit normal

V = vn*vn';
if nargin>=2 && enforceAdj
    V = V.*adjacencyMatrix(k);                                              % Only consider adjacent faces
end

[~,idx]  = maxk(V,2,2);                                                     % max 2 col. indices of inner product matrix
triPairs = unique(sort(idx,2),'rows');                                      % coplanar triangle pairs
numTri   = size(triPairs,1);                                                % number of triangles

Q = zeros(numTri/2,4);                                                      % Initialise quad array

for i = 1:size(triPairs,1)
    T1 = k(triPairs(i,1),:);                                                % first triangle
    T2 = k(triPairs(i,2),:);                                                % second triangle

    [maskT1,idxT2] = ismember(T1,T2);
    idxT2 = sort(idxT2(maskT1));                                            % 1x2 sorted T2 indices of common nodes
    newNode = T1(~maskT1);                                                  % node to add to T2 between nodes b(a)

    if idxT2(2)-idxT2(1) == 2                                               % new node between 1 and 3
        Q(i,:) = [T2, newNode];
    else
        Q(i,:) = [T2(1:idxT2(1)), newNode, T2(idxT2(2):end)];
    end
end
end 

%{
--------------------------------------------------------------------------
Retuns the adjacency matrix for the N faces in connectivity matrix k
The adjacency condition is 2 or more common points
%}
function M = adjacencyMatrix(k)
n = size(k,1);
M = 0.5*eye(n);
for i = 1:n
    for j = i+1:n
        M(i,j) = nnz(ismember(k(j,:),k(i,:))) >= 2;
    end
end
M = M + M'; 
end 


% -----------------------------------------------
%                   MISC. CODE
% -----------------------------------------------
%{
% Plot elements, normal in blue, degenerate in red

elms = 220:220;
clf
hold on
rotate3d on

for i = elms
    t = S(i,2:end);
    [maskG,sortG] = ismember(G(:,1),t); 
    g = G(maskG,2:end); 
    k = convhull(g);
    try
        e12 = g(k(:,2),:) - g(k(:,1),:);
        e23 = g(k(:,3),:) - g(k(:,2),:); 
        vn  = cross(e12,e23);
        vn  = vn./vecnorm(vn,2,2); 
        
        [~,idx]  = maxk(vn*vn',2,2); 
        triPairs = unique(sort(idx,2),'rows');  
        numTri   = size(triPairs,1);  
        Q = zeros(numTri/2,4);  

        trisurf(k,g(:,1),g(:,2),g(:,3),'faceAlpha',1.0,'FaceColor','b')
    catch
        trisurf(k,g(:,1),g(:,2),g(:,3),'faceAlpha',1.0,'FaceColor','r')
        for i = 1:8
            tmp = sprintf('%0d',i);
            text(g(i,1), g(i,2), g(i,3), ['P' tmp], 'fontsize', 14)
        end
    end
end
%}







