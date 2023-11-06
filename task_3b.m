%Task 3b
%Measure the 3D locations of 3 points on the wall that has white vertical stripes painted on
%it and fit a plane. What is the equation of the wall plane?

%Wall
%Cam1
%pt1: 1209, 283 
%pt2: 1447, 272
%pt3: 1260, 560

%Cam2
%pt1: 354, 173
%pt2: 690, 168
%pt3: 465, 494


load Parameters_V1_1.mat
cam1 = Parameters;
load Parameters_V2_1.mat
cam2 = Parameters;
kmat1 = cam1.Kmat;
kmat2 = cam2.Kmat;
pmat1 = cam1.Pmat;
pmat2 = cam2.Pmat;

fpc1 = [1209, 1447, 1260;
    283, 272, 560];
fpc2 = [354, 690, 465;
    173, 168, 494];

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

