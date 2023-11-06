load  pixelCoordinates.mat
matchedPoints1 =  pixelCoords2.';
matchedPoints2 =  pixelCoords1.';

[fLMedS,inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,NumTrials=2000)

I1 = imread("im2corrected.jpg");
I2 = imread("im1corrected.jpg");
%fRANSAC = estimateFundamentalMatrix(matchedPoints1, ...
  %  matchedPoints2,Method="RANSAC", ...
   % NumTrials=2000,DistanceThreshold=1e-4)
figure;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,"montage",PlotOptions=["ro","go","y--"]);
title("Putative Point Matches");