%% C. Static image
% Tresholding RGB image to segment the tokens
% Result 2 binary images

clear all;
close all;
clc;

RGB = imread("TagImage.jpg");
% imtool(RGB); - was used to inspect pixel values 

yellowTag = RGB(:,:,1)>195 & RGB(:,:,2)>170 & RGB(:,:,3)<115;
redTag = RGB(:,:,1)>150 & RGB(:,:,2)<65 & RGB(:,:,3)<65;

% figure;
% montage({yellowTag, RGB, redTag, yellowTag | redTag}, "Size", [2 2]);

%% D. Morphological Operators & Non-Linear Filters
% Filing holes and text using Dilation and Close

se = strel('diamond', 11);

yellowDilated = imdilate(yellowTag, se); % making object slightly bigger and filling spartially
yellowClose = imclose(yellowDilated, se); % closing all the remaining gaps
yellow = imerode(yellowClose, se); % minimazing back to initial size

redDilated = imdilate(redTag, se); % making object slightly bigger and filling spartially
redClose = imclose(redDilated, se); % closing all the remaining gaps
red = imerode(redClose, se); % minimazing back to initial size

% figure;
% montage({yellow, red}, "Size", [1 2]);

%% E. Token boundaries on original image
% - Tracing the tags boundaries and overlaying them on the original image

yellowRangeFilt = rangefilt(yellow); 
redRangeFilt = rangefilt(red);

RGBandY = imoverlay(RGB, yellowRangeFilt, "blue");
RGBboundaries = imoverlay(RGBandY, redRangeFilt, "green");

% figure;
% imshow(RGBboundaries);

%% F. Tag centroids and distances 

[iY, jY] = find(yellow);
yY = mean2(iY);
xY = mean2(jY);
[iR,jR] = find(red);
yR = mean2(iR);
xR = mean2(jR);

dCityBlock  = abs(yY-yR)+abs(xY-xR);
dChessboard = max(abs(yY-yR),abs(xY-xR));
dEuclidean  = sqrt((yY-yR)^2+(xY-xR).^2);

chessx = (((xY+xR)/2) + xR)/2;
chessy = (((yY+yR)/2) + yY)/2;

dim = [0.1 0.8 0.8 0];

imshow(RGBboundaries)

hold on

plot([xY, xR],[yY, yY], '-mo', [xR, xR], [yR, yY], '-mo', 'LineWidth', 1); % city block line
plot([xY, chessx], [yY, chessy], '-go', [chessx, xR], [chessy, yR], '-go', 'Linewidth', 1); % chessboard line
plot([xY, xR], [yY, yR],'-c*','Linewidth',1); % eucledian line
str = {['Red Tag Centroid x coordinates = ',num2str(xR)],['Red Tag Centroid y coordinates = ',num2str(yR)], ...
        ['Yellow Tag Centroid x coordinates = ',num2str(xY)],['Yellow Tag Centroid y coordinates = ',num2str(yY)], ...
        ['City Block Distance = ',num2str(dCityBlock)], ...
        ['Chessboard Distance = ',num2str(dChessboard)], ...
        ['Euclidean Distance = ',num2str(dEuclidean)]};
annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor','black','Color','black');

hold off
% %% G. Adapt for webcam use 
% clear all;
% close all;
% clc;
% 
% vid = videoinput('winvideo', 1, 'MJPG_640x480');
% set(vid,'FramesPerTrigger',Inf);
% set(vid,'ReturnedColorspace', 'rgb');
% vid.FrameGrabInterval = 3;
% vid.LoggingMode = 'disk';
% videoFile = VideoWriter('TaskG.mp4', 'MPEG-4');
% vid.DiskLogger = videoFile;
% 
% dim = [0.3 0.9 0.9 0];
% 
% start(vid)
% while (vid.FramesAcquired <= 1800)
%     RGB = getsnapshot(vid);
% 
%     yellowTag = RGB(:,:,1)>125 & RGB(:,:,2)>85 & RGB(:,:,3)<35;
%     redTag = RGB(:,:,1)>130 & RGB(:,:,2)<45 & RGB(:,:,3)<35;
%     
%     se = strel('diamond', 11);
%     
%     yellowDilated = imdilate(yellowTag, se); % making object slightly bigger and filling spartially
%     yellowClose = imclose(yellowDilated, se); % closing all the remaining gaps
%     yellow = imerode(yellowClose, se); % minimazing back to initial size
%     
%     redDilated = imdilate(redTag, se); % making object slightly bigger and filling spartially
%     redClose = imclose(redDilated, se); % closing all the remaining gaps
%     red = imerode(redClose, se); % minimazing back to initial size
%     
%     yellowRangeFilt = rangefilt(yellow); 
%     redRangeFilt = rangefilt(red);
%     
%     RGBandY = imoverlay(RGB, yellowRangeFilt, "blue");
%     RGBboundaries = imoverlay(RGBandY, redRangeFilt, "green");
%     
%     [iY, jY] = find(yellow);
%     yY = mean2(iY);
%     xY = mean2(jY);
%     [iR,jR] = find(red);
%     yR = mean2(iR);
%     xR = mean2(jR);
%     
%     dCityBlock  = abs(yY-yR)+abs(xY-xR);
%     dChessboard = max(abs(yY-yR),abs(xY-xR));
%     dEuclidean  = sqrt((yY-yR)^2+(xY-xR).^2);
% 
%     chessx = (((xY+xR)/2) + xR)/2;
%     chessy = (((yY+yR)/2) + yY)/2;
% 
%     imshow(RGBboundaries);
% 
%     delete(findall(gcf,'type','annotation'));
% 
%     hold on 
%     plot([xY, xR],[yY, yY], '-mo', [xR, xR], [yR, yY], '-mo', 'LineWidth', 1); % city block line
%     plot([xY, chessx], [yY, chessy], '-go', [chessx, xR], [chessy, yR], '-go', 'Linewidth', 1); % chessboard line
%     plot([xY, xR], [yY, yR],'-c*','Linewidth',1); % eucledian line
%     str = {['Red Tag Centroid x coordinates = ',num2str(xR)],['Red Tag Centroid y coordinates = ',num2str(yR)], ...
%         ['Yellow Tag Centroid x coordinates = ',num2str(xY)],['Yellow Tag Centroid y coordinates = ',num2str(yY)], ...
%         ['City Block Distance = ',num2str(dCityBlock)], ...
%         ['Chessboard Distance = ',num2str(dChessboard)], ...
%         ['Euclidean Distance = ',num2str(dEuclidean)]};
%     annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor','black','Color','black');
%     drawnow;
%     pause(.1)
%     hold off
% end
% vid.FramesAcquired;
% vid.DiskLoggerFrameCount;
% 
% stop(vid);
% flushdata(vid);
%% Interpretation and light drawing 
clear all;
close all;
clc;









