%  ------------------------------------------------------------------------------------------------
%   DESCRIPTION
%       MESHPLOTAPDL reads and plots an APDL mesh. Currently GRID/HEX8 data only
%
%       See also: GROOTMOD, XFIG
%
%   ASSUMES
%       - Specific numeric format, i.e. it is not auto-retrieved from input file
%       - All grids are in CSYS 0
%       - Missing grid field implies zero
%       - Grid and element IDs are pre-sorted
%
%   VERSION
%   v1.2 / xx.11.22 / --    generalisation for different elements, faster face computation
%   v1.1 / 08.11.22 / --    filtering to keep only visible faces for plotting
%   v1.0 / 10.02.22 / V.Y.
%  ------------------------------------------------------------------------------------------------

% -----------------------------------------------
%                 I/O, PARSING
% -----------------------------------------------

% [Clean-up] workspace
clearvars

% Paths
locIn   = "..\Code\Matlab\Graphics\data\meshPlotAPDL\";                     % directory
fileIn  = "delrin.txt";                                                     % file name

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
fmtG = [repmat('%f',1,6) '\n'];                                             % <---------- take 6 from NBLOCK
fmtE = [repmat('%f',1,19) '\n'];                                            % <---------- take 19 from EBLOCK
optsG = {'EmptyValue', 0, 'CollectOutput', true};
optsE = {'EmptyValue', NaN, 'CollectOutput', true};

% Extract numerical data
datG = char(A(startG:endG));
datE = char(A(startS:endS));

datG = cell2mat( textscan( join(string(datG), newline), fmtG, optsG{:}));
datE = cell2mat( textscan( join(string(datE), newline), fmtE, optsE{:}));

% Drop unnecessary fields
G = datG(:,[1 4:end]);                                                      % [m x 4] [ID x y z]
E = assignElementType(datE);

% [Clean-up] workspace
clearvars *In flag* start* end* fmt* A dat* opts


% -----------------------------------------------
%                  BUILD MESH
% -----------------------------------------------

F = processOrdered(mergeAsLinear(E));
% F = processUnorderedHex(mergeAsLinear(E),G,false);                         % Faces
F = processFaces(F);                                                         % Get unique and visible faces 

% -----------------------------------------------
%                     PLOT
% -----------------------------------------------

% Complete mesh without internal & defective faces
[ax,fig] = xfig(1,b=0,g=0,c=1);
    ax.DataAspectRatio = [1 1 1];
%    axis equal
    rotate3d on
    showLight = true;

opts.lgt = {'style'         'local'
            'color'         col('w')    }'; 

opts.p = {  'FaceColor'     col('coolgrey') % x11gray
            'EdgeColor'     'k'
            'LineStyle'     '-'  
            'LineWidth'     0.2
            'EdgeAlpha'     0.5  
            'FaceAlpha'     1.0
            'FaceLighting'  'gouraud'   }';

f = F.H8.vis;
v = mapSet(cvec(G(:,1)), cvec(1:max(G(:,1))), G(:,2:end));                      % <---------- Avoid expansion w/ zero rows in v by reindexing f
p = patch('Faces', f, 'Vertices', v, opts.p{:});

if showLight
    lgt = light(opts.lgt{:});
    p.EdgeAlpha = 0.1;
    p.FaceColor = col('ghostwhite');
    ax.Color = col('w');
    p.EdgeLighting = 'gouraud';
    deleteStructObj(tikzStyleAxes(ax))
end

%{
cleanfigure
matlab2tikz('monopatch.tex','standalone',true,'floatFormat','%.8g') %.15g

print(gcf,'-dsvg','wheel')
exportgraphics(gcf,'test.pdf','contenttype','vector')
%}

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

% --------------------------------------------------------------------------
% Retuns the adjacency matrix for the N faces in connectivity matrix k
% The adjacency condition is 2 or more common points

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

% --------------------------------------------------------------------------
% Computes face orientations from H8s with unknown node ordering

function F = processUnorderedHex(E,G,enforceAdj)            % F.H8 -> all faces, incl. duplicate
    if nargin < 3 
        enforceAdj = false; 
    end

    dg = [];                                                % indices of defective elements
    nd = [];                                                % indices of non-defective elements
    Q  = zeros(size(E.H8,1),4);                             % quadrilateral face array
    
    n = size(E.H8,1);
    m = '[%.0f/%.0f] solids';
    h = waitbar(0,sprintf(m,0,n),'name','Computing hex faces...');   
    
    for i = 1:n
        t = sort(E.H8(i,2:end));                            % i-th element nodes, MUST be sorted
        [maskG,sortG] = ismember(G(:,1),t); 
        g = G(maskG,2:end);                                 % filter grid data of t
        try
            Q(6*i-5:6*i,:) = t(grid2quad(g,enforceAdj));    % enforceadj setting
            nd = [nd, i];
        catch 
            dg = [dg; i];
        end
    
        if rem(i,ceil((n-1)/25))==0
            waitbar(i/ceil(n),h,sprintf(m,i,n))
        end
    end

    F.H8 = Q(Q(:,1)~=0,:);
    delete(h)
end

% --------------------------------------------------------------------------
% Filters out internal faces

function F = processFaces(Q)
    % Keep one instance of internal faces
    Qs = sort(Q.H8,2);
    [~,q2u] = unique(Qs,'rows');

    % Only visible faces
    idx  = setdiff(1:size(Q.H8,1),q2u);                  % index of faces occurring multiple times
    mask = ismember(Qs,Qs(idx,:),'rows');

    % Output
    F.H8.all = Q.H8(q2u,:);
    F.H8.vis = Q.H8(~mask,:);
end

% --------------------------------------------------------------------------
% Assigns H8/H20 elements

function E = assignElementType(dat)
    mask.H8 = all(dat(:,8:10)==[0 8  0], 2) & dat(:,2)~=200;
    E.H8 = dat(mask.H8,11:end);

    mask.H20 = all(dat(:,8:10)==[0 20 0], 2) & dat(:,2)~=200;
    idx.H20 = find(mask.H20); 
    E.H20 = [dat(idx.H20,11:end) dat(1+idx.H20,1:12)];
end

% --------------------------------------------------------------------------
% Clears midside nodes

function E = convertToLinear(E)
    E.H20 = E.H20(:,1:9);
end

% --------------------------------------------------------------------------
% Clears midside nodes

function E = mergeAsLinear(E)
    E = convertToLinear(E);
    E.H8 = [E.H8; E.H20];
end

% --------------------------------------------------------------------------
% Process using known ordering

function F = processOrdered(E)
    m.H8 = [    1   2   3   4 
                5   6   7   8 
                1   2   6   5
                2   3   7   6
                3   4   8   7
                4   1   5   8   ] + 1;                      % offset for element ID column
    F.H8 = reshape(E.H8(:,m.H8), 6*size(E.H8,1), 4);        % k:6:end is the k-th face array
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

% Indivudual patches
for i = 1:length(Q)
     patch('XData', G(Q(i,1:4)',2), 'YData', G(Q(i,1:4)',3), 'ZData', G(Q(i,1:4)',4), opts.p{:});
end

% Defective face nodes
%{
    xfig(2,g=1);
        rotate3d on
    
    D  = unique(E(dg,2:end));
    GD = G(D,2:end);
    N  = unique(E(nd,2:end));
    GN = G(N,2:end);
    
    sd = scatter3(GD(:,1),GD(:,2),GD(:,3),'filled','MarkerFaceColor','r');      % defective
    sn = scatter3(GN(:,1),GN(:,2),GN(:,3),'filled','sizedata',18, ...
                    'MarkerFaceColor','k','MarkerFaceAlpha',.1);                % nondefective
%}
%}







