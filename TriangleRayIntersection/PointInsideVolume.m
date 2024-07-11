function inside = PointInsideVolume(point, faces, vertices)
    % Check if a point is inside a volume defined by triangular faces
    %
    % Parameters:
    % point    - 1x3 array of the query point
    % faces    - Mx3 array of vertex indices defining triangular faces
    % vertices - Kx3 array of vertex coordinates
    %
    % Returns:
    % inside   - Boolean indicating whether the point is inside the volume

    % Define the single ray direction as in the Python implementation
    default_direction = [0.4395064455, 0.617598629942, 0.652231566745];
    
    % Cast rays in both directions
    [intersect_f, ~, ~, ~] = TriangleRayIntersection(point, default_direction, ...
        vertices(faces(:,1),:), vertices(faces(:,2),:), vertices(faces(:,3),:), ...
        'planeType', 'two sided', 'lineType', 'ray', 'border', 'inclusive');
    
    [intersect_b, ~, ~, ~] = TriangleRayIntersection(point, -default_direction, ...
        vertices(faces(:,1),:), vertices(faces(:,2),:), vertices(faces(:,3),:), ...
        'planeType', 'two sided', 'lineType', 'ray', 'border', 'inclusive');

    % Count intersections
    hits_f = sum(intersect_f);
    hits_b = sum(intersect_b);

    % Check if point is inside (odd number of intersections in both directions)
    inside = (mod(hits_f, 2) == 1) && (mod(hits_b, 2) == 1);

    % If the result is ambiguous, try a random direction
    if xor(mod(hits_f, 2) == 1, mod(hits_b, 2) == 1)
        new_direction = randn(1, 3);
        new_direction = new_direction / norm(new_direction);
        
        [intersect_new, ~, ~, ~] = TriangleRayIntersection(point, new_direction, ...
            vertices(faces(:,1),:), vertices(faces(:,2),:), vertices(faces(:,3),:), ...
            'planeType', 'two sided', 'lineType', 'ray', 'border', 'inclusive');
        
        hits_new = sum(intersect_new);
        inside = mod(hits_new, 2) == 1;
    end
end