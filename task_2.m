%Task 2
%Use the 39 2D pixel locations computed in task 1 and perform triangulation to recover the
%3D points. Compare the accuracy of your computed points and the mocap data using the mean
%square error (this should be small).
run("task_1.m")
kmat1 = cam1.Kmat;
kmat2 = cam2.Kmat;
normalizedCoords1 = inv(kmat1) * [pixelCoords1; ones(1, 39)];
normalizedCoords2 = inv(kmat2) * [pixelCoords2; ones(1, 39)];
normalizedCoords1 = normalizedCoords1(1:2, :)';
normalizedCoords2 = normalizedCoords2(1:2, :)';
reconstructed3DPoints = zeros(39, 3);
for markerIdx = 1:39
point3D = triangulate(normalizedCoords1(markerIdx, :), normalizedCoords2(markerIdx, :), cam1.Pmat, cam2.Pmat);
reconstructed3DPoints(markerIdx, :) = point3D;
end
squaredDifferences = (reconstructed3DPoints - transpose(pts3D)).^2;
mse = mean(squaredDifferences, 1);
