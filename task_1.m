% Load camera parameters and image
load Parameters_V1_1.mat
cam1 = Parameters;
image1 = imread("im1corrected.jpg");

load Parameters_V2_1.mat
cam2 = Parameters;
image2 = imread("im2corrected.jpg");
% Load mocap points (world coordinates) and transform them to camera coordinates
load mocapPoints3D.mat
pts3D = reshape(pts3D, [3, 39]);
R1 = cam1.Rmat;
C1 = cam1.position';
PC1 = R1 * (pts3D - C1);

R2 = cam2.Rmat;
C2 = cam2.position';
PC2 = R2 * (pts3D - C2);

% Initialization
pixelCoords1 = zeros(2, 39);
pixelCoords2 = zeros(2, 39);
prinpoint1 = cam1.prinpoint;
prinpoint2 = cam2.prinpoint;
% Project camera coordinates to 2D pixel locations
for x = 1:39
    points = PC1(:, x);
    
    mat1 = [
        cam1.foclen 0 0 0;
        0 cam1.foclen 0 0;
        0 0 1 0];
    
    mat2 = [points; 1];
    
    prod = mat1 * mat2;
    
    pixelCoords1(1, x) = prod(1)/prod(3) + prinpoint1(1);
    pixelCoords1(2, x) = prod(2)/prod(3) + prinpoint1(2);
end

for x = 1:39
    points = PC2(:, x);
    
    mat1 = [
        cam2.foclen 0 0 0;
        0 cam2.foclen 0 0;
        0 0 1 0];
    
    mat2 = [points; 1];
    
    prod = mat1 * mat2;
    
    pixelCoords2(1, x) = prod(1)/prod(3) + prinpoint2(1);
    pixelCoords2(2, x) = prod(2)/prod(3) + prinpoint2(2);
end
fig1 = figure;
ax1 = axes('Parent', fig1);
imshow(image1, 'Parent', ax1);
hold(ax1, 'on');
plot(ax1, pixelCoords1(1, :), pixelCoords1(2, :), 'go');
% Label the points
for i = 1:size(pixelCoords1, 2)
    text(pixelCoords1(1, i), pixelCoords1(2, i), num2str(i), 'Color', 'red', 'Parent', ax1);
end
hold(ax1, 'off');

fig2 = figure;
ax2 = axes('Parent', fig2);
imshow(image2, 'Parent', ax2);
hold(ax2, 'on');
plot(ax2, pixelCoords2(1, :), pixelCoords2(2, :), 'go');
% Label the points
for i = 1:size(pixelCoords2, 2)
    text(pixelCoords2(1, i), pixelCoords2(2, i), num2str(i), 'Color', 'red', 'Parent', ax2);
end
hold(ax2, 'off');
save('pixelCoordinates.mat', 'pixelCoords1', 'pixelCoords2');

%... [rest of your code]
%{
% Display the first image and overlay the 2D points
figure; % <- This line opens a new figure
imshow(image1);
hold on;
plot(pixelCoords1(1, :), pixelCoords1(2, :), 'go');
% Label the points
for i = 1:size(pixelCoords1, 2)
    text(pixelCoords1(1, i), pixelCoords1(2, i), num2str(i), 'Color', 'red');
end
hold off;

% Display the second image and overlay the 2D points
figure; % <- This line opens another new figure
imshow(image2);
hold on;
plot(pixelCoords2(1, :), pixelCoords2(2, :), 'go');
% Label the points
for i = 1:size(pixelCoords2, 2)
    text(pixelCoords2(1, i), pixelCoords2(2, i), num2str(i), 'Color', 'red');
end
hold off;
%}



