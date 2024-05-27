%% D. Morphological Operators & Non-Linear Filters
% Filing holes and text using Dilation, Closing and Erosion
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

figure;
montage({yellow, red}, "Size", [1 2]);
% Displaying each tag after manipulation and filing 