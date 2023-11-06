%Task 3a
%Use triangulation to measure objects in the scene. You’ll obtain the pixel coordinates
%by clicking on the 3D object in both images; you%ll then use these to construct the 3D point in
%the scene. Performing the following tasks:

%Measure the 3D locations of 3 points on the floor and fit a 3D plane to them. Verify that your
%computed floor plane is approximation Z = 0. What is the equation of the floor plane?

%Floor
%Cam1 
%pt1: 1290, 802
%pt2: 973, 926
%pt3: 660, 793

%Cam2 
%pt1: 1357, 593
%pt2: 1697, 695
%pt3: 1371, 750


load Parameters_V1_1.mat
cam1 = Parameters;
load Parameters_V2_1.mat
cam2 = Parameters;
kmat1 = cam1.Kmat;
kmat2 = cam2.Kmat;
pmat1 = cam1.Pmat;
pmat2 = cam2.Pmat;

fpc1 = [1290, 973, 660;
    802 926 793];
fpc2 = [1357, 1697, 1371;
    593, 695, 750];

nCoords1 = inv(kmat1) * [fpc1; ones(1, 3)];
nCoords2 = inv(kmat2) * [fpc2; ones(1, 3)];
nCoords1 = nCoords1(1:2, :)';
nCoords2 = nCoords2(1:2, :)';

worldpoints = zeros(3, 3);

for i = 1:3
    
    % Normalized image coords
    x1 = nCoords1(i, 1);
    y1 = nCoords1(i, 2);
    x2 = nCoords2(i, 1);
    y2 = nCoords2(i, 2);
    %Direct linear transformation for triangulation
    A = [y1 * pmat1(3, :) - pmat1(2, :);
        pmat1(1, :) - x1 * pmat1(3, :);
        y2 * pmat2(3, :) - pmat2(2, :);
        pmat2(1, :) - x2 * pmat2(3, :);];

    [~, ~, V] = svd(A);
    X = V(:, end) / V(end, end);

    % Extract 3D coordinates
    worldpoints(i, :) = X(1:3);
end



%The points are all aproximately Z=0
P1 = worldpoints(1,:);
P2 = worldpoints(2,:);
P3 = worldpoints(3,:);


vec1 = P2 - P1;
vec2 = P3 - P1;

normalVector = cross(vec1, vec2);

normalizedVector= normalVector / norm(normalVector);

A = normalizedVector(1);
B = normalizedVector(2);
C = normalizedVector(3);
D = -A * P1(1) - B * P1(2) - C * P1(3);

%Ax + By + Cz + D = 0
fprintf('Equation of the plane: %.4fx + %.4fy + %.4fz + %.4f = 0\n', A, B, C, D);

