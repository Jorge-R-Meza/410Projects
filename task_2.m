%Task 2
%Use the 39 2D pixel locations computed in task 1 and perform triangulation to recover the
%3D points. Compare the accuracy of your computed points and the mocap data using the mean
%square error (this should be small).
run("task_1.m")

kmat1 = cam1.Kmat;
kmat2 = cam2.Kmat;
pmat1 = cam1.Pmat;
pmat2 = cam2.Pmat;

nCoords1 = inv(kmat1) * [pixelCoords1; ones(1, 39)];
nCoords2 = inv(kmat2) * [pixelCoords2; ones(1, 39)];
nCoords1 = nCoords1(1:2, :)';
nCoords2 = nCoords2(1:2, :)';

worldpoints = zeros(39, 3);

for i = 1:39
    
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

% Calculate MSE
squaredDiff = (worldpoints - transpose(pts3D)).^2;
mse = mean(squaredDiff, 1);
fprintf('X MSE: %s\nY MSE: %s\nZ MSE: %s\n', mse(1), mse(2), mse(3));
