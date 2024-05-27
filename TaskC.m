%% C. Static image
% Thresholding RGB image to segment the tokens
% Result 2 binary images

clear all;
close all;
clc;

RGB = imread("TagImage.jpg");
% imtool(RGB); - was used to inspect pixel values 

yellowTag = RGB(:,:,1)>195 & RGB(:,:,2)>170 & RGB(:,:,3)<115; % thresholding for the yellow tag 
redTag = RGB(:,:,1)>150 & RGB(:,:,2)<65 & RGB(:,:,3)<65; % thresholding for the red tag 

figure;
montage({RGB, yellowTag, redTag, yellowTag | redTag}, "Size", [2 2]); 
% Displaying the initial picture, each thresholded image and a combinations of both thresholded tags 