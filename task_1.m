% Load camera parameters and image
load Parameters_V2_1.mat
cam1 = Parameters;
image1 = imread("im2corrected.jpg");
% Load mocap points (world coordinates) and transform them to camera coordinates
load mocapPoints3D.mat
pts3D = reshape(pts3D, [3, 39]);
R = cam1.Rmat;
C = cam1.position';
PC = R * (pts3D - C);
% Initialization
pixelCoords = zeros(2, 39);
prinpoint1 = cam1.prinpoint;
% Project camera coordinates to 2D pixel locations
for x = 1:39
    points = PC(:, x);
    
    mat1 = [
        cam1.foclen 0 0 0;
        0 cam1.foclen 0 0;
        0 0 1 0];
    
    mat2 = [points; 1];
    
    prod = mat1 * mat2;
    
    pixelCoords(1, x) = prod(1)/prod(3) + prinpoint1(1);
    pixelCoords(2, x) = prod(2)/prod(3) + prinpoint1(2);
end
% Display the image and overlay the 2D points
imshow(image1);
hold on;
plot(pixelCoords(1, :), pixelCoords(2, :), 'go');
% Label the points
for i = 1:size(pixelCoords, 2)
    text(pixelCoords(1, i), pixelCoords(2, i), num2str(i), 'Color', 'red');
end
hold off;
%{
imshow('im1corrected.jpg');
axis on
hold on;
% Plot cross at row 100, column 50
plot(50,100, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
maxX = max(pixelCoords(1, :));
maxY = max(pixelCoords(2, :));
[imgHeight, imgWidth, ~] = size(image1);
disp(['Max X: ', num2str(maxX), ' Image Width: ', num2str(imgWidth)]);
disp(['Max Y: ', num2str(maxY), ' Image Height: ', num2str(imgHeight)]);
%}

%{
imshow('im1corrected.jpg');
axis on
hold on;
% Plot cross at row 100, column 50
plot(50,100, 'r+', 'MarkerSize', 30, 'LineWidth', 2);

maxX = max(pixelCoords(1, :));
maxY = max(pixelCoords(2, :));
[imgHeight, imgWidth, ~] = size(image1);
disp(['Max X: ', num2str(maxX), ' Image Width: ', num2str(imgWidth)]);
disp(['Max Y: ', num2str(maxY), ' Image Height: ', num2str(imgHeight)]);
%}


