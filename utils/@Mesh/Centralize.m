function [Area,Center] = Centralize(G, G_watertight,scale)
%Centrializes G
%   scale: scale G to a unit 'ScaleArea'

if iscell(G.F)
    error('Not implemented for non-triangular meshes yet');
end
Center = mean(G.V,2);
G.V = G.V-repmat(Center,1,G.nV);
G_watertight.V = G_watertight.V - repmat(Center, 1, G_watertight.nV);

if strcmp(scale,'ScaleArea')
    Area = real(G.ComputeSurfaceArea);
    G.V = G.V*sqrt(1/Area);
    G_watertight.V = G_watertight.V*sqrt(1/Area);
end

end