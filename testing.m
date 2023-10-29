data = load('mocapPoints3D.mat', 'pts3D')
% Extract 3D points
X = data.pts3D(1, :);  % x-coordinates
Y = data.pts3D(2, :);  % y-coordinates
Z = data.pts3D(3, :);  % z-coordinates

% Plot the 3D points
figure;
scatter3(X, Y, Z, 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Mocap Points');
grid on;