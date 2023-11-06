%Task 3c
load Parameters_V1_1.mat
cam1 = Parameters;
load Parameters_V2_1.mat
cam2 = Parameters;
kmat1 = cam1.Kmat;
kmat2 = cam2.Kmat;
pmat1 = cam1.Pmat;
pmat2 = cam2.Pmat;
%Answer the following additional questions:
% How tall is the doorway?
%cam1
%[1126, 556]
%[1131, 292]

%cam2
%[267, 520]
%[231, 183]

fpc1 = [1126, 1131;
    556, 292];
fpc2 = [267, 231;
    520, 183];

nCoords1 = inv(kmat1) * [fpc1; ones(1, 2)];
nCoords2 = inv(kmat2) * [fpc2; ones(1, 2)];
nCoords1 = nCoords1(1:2, :)';
nCoords2 = nCoords2(1:2, :)';

worldpoints = zeros(2, 3);

for i = 1:2
    
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
doorHeight = P2(3)-P1(3);


% How tall is the person?
%cam1
%[562, 722]
%[578,406]

%cam2
%[1023, 773]
%[1043, 354]

fpc1 = [562, 578;
    722, 406];
fpc2 = [1023, 1043;
    773, 354];

nCoords1 = inv(kmat1) * [fpc1; ones(1, 2)];
nCoords2 = inv(kmat2) * [fpc2; ones(1, 2)];
nCoords1 = nCoords1(1:2, :)';
nCoords2 = nCoords2(1:2, :)';

worldpoints = zeros(2, 3);

for i = 1:2
    
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
personHeight = P2(3)-P1(3);

% What is the 3D location of the center of the camera that can be seen in both images?
%cam1
%1462, 271
%cam2
%717, 168
fpc1 = [1462;271];
fpc2 = [717;168];

nCoords1 = inv(kmat1) * [fpc1; ones(1, 1)];
nCoords2 = inv(kmat2) * [fpc2; ones(1, 1)];
nCoords1 = nCoords1(1:2, :)';
nCoords2 = nCoords2(1:2, :)';

worldpoints = zeros(1, 3);


% Normalized image coords
x1 = nCoords1(1, 1);
y1 = nCoords1(1, 2);
x2 = nCoords2(1, 1);
y2 = nCoords2(1, 2);
%Direct linear transformation for triangulation
A = [y1 * pmat1(3, :) - pmat1(2, :);
    pmat1(1, :) - x1 * pmat1(3, :);
    y2 * pmat2(3, :) - pmat2(2, :);
    pmat2(1, :) - x2 * pmat2(3, :);];

[~, ~, V] = svd(A);
X = V(:, end) / V(end, end);

% Extract 3D coordinates
worldpoints(1, :) = X(1:3);

camLocation = worldpoints;
cL1 = camLocation(1);
cL2 = camLocation(2);
cL3 = camLocation(3);

fprintf('All Values in mm\nDoor Height: %.4f\nPerson Height: %.4f\nCamera Location: %.4f, %.4f, %.4f\n', doorHeight, personHeight, cL1, cL2, cL3);
