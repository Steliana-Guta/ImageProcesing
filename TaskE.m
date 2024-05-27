%% E. Token boundaries on original image
% - Tracing the tags boundaries and overlaying them on the original image
clear all;
close all;
clc;

RGB = imread("TagImage.jpg"); 

yellowTag = RGB(:,:,1)>195 & RGB(:,:,2)>170 & RGB(:,:,3)<115; % thresholding for the yellow tag 
redTag = RGB(:,:,1)>150 & RGB(:,:,2)<65 & RGB(:,:,3)<65; % thresholding for the red tag 

se = strel('diamond', 11);

yellowDilated = imdilate(yellowTag, se); % making object slightly bigger and filling partially
yellowClose = imclose(yellowDilated, se); % closing all the remaining gaps
yellow = imerode(yellowClose, se); % minimizing back to initial size
redDilated = imdilate(redTag, se); % making object slightly bigger and filling partially
redClose = imclose(redDilated, se); % closing all the remaining gaps
red = imerode(redClose, se); % minimizing back to initial size

yellowRangeFilt = rangefilt(yellow); % using range filter to identify the boundary of the tag
redRangeFilt = rangefilt(red); % using range filter to identify the boundary of the tag

RGBandY = imoverlay(RGB, yellowRangeFilt, "blue"); % overlaying the range filter in colour blue over the image
RGBboundaries = imoverlay(RGBandY, redRangeFilt, "green"); % overlaying the range filter in colour green over the already overlayed image

figure;
imshow(RGBboundaries);
% Displaying the image with the coloured boundaries
