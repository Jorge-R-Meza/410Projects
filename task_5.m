im = imread('im2corrected.jpg');
im2 = imread('im1corrected.jpg');
load  pixelCoordinates.mat
pts1 =  pixelCoords2.';
pts2 =  pixelCoords1.';

%run("wrongfunc_4.m")
run("task_4.m")
N = size(pts1, 1); % Number of point pairs
distances = zeros(N, 1); 
for i = 1:N
    % Points in homogeneous coordinates
    point1 = [pts1(i, :) 1]';
    point2 = [pts2(i, :) 1]';
    
    % Epipolar lines
    line1 = fLMedS* point1;
    line2 = fLMedS* point2;
    
    % Calculate the distances from points to the corresponding epipolar lines
    d1 = (line1' * point2)^2 / (line1(1)^2 + line1(2)^2);
    d2 = (line2' * point1)^2 / (line2(1)^2 + line2(2)^2);
    
    % Symmetric epipolar distance
    distances(i) = d1 + d2;
end

% Compute the mean of the squared distances
meanDistance = mean(distances);

% Output the result
fprintf('The mean symmetric epipolar distance is %f\n', meanDistance);