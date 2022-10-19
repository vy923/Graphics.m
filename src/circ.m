% [3 x n+1] coordinates of an xy-plane circle w. origin O

function C = circ(r,n,O) 
    if nargin<3 || isempty(O)     O = zeros(3,1);   end
    if nargin<2 || isempty(n)     n = 200;          end
    th  = linspace(-pi,pi,n+1);
    C   = r*[cos(th); sin(th); 0*th] + O; 
end
