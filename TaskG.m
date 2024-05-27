%% G. Adapt for webcam use 
clear all;
close all;
clc;

camera = webcam(1); % start webcam 1
videoFile = VideoWriter('TaskG.mp4', 'MPEG-4'); % write video to file TaskG.mp4
videoFile.FrameRate = 3; % set frame rate
open(videoFile) % start video file 
ax = gcf(); % settings constant variable for video writing capabilities at the bottom of the loop
frames = 310; %settings the frame number for the loop
dim = [0.3 0.9 0.9 0]; % dimensions of annotation box 

for i = 1:frames
    RGB = snapshot(camera); % opens figure with the live feed
    
    yellowTag = RGB(:,:,1)>195 & RGB(:,:,2)>170 & RGB(:,:,3)<115; % thresholding for the yellow tag 
    redTag = RGB(:,:,1)>150 & RGB(:,:,2)<65 & RGB(:,:,3)<65; % thresholding for the red tag 
    
    se = strel('diamond', 11);
    yellowDilated = imdilate(yellowTag, se); % making object slightly bigger and filling holes partially
    yellowClose = imclose(yellowDilated, se); % closing all the remaining gaps
    yellow = imerode(yellowClose, se); % minimizing back to initial size
    redDilated = imdilate(redTag, se); % making object slightly bigger and filling holes partially
    redClose = imclose(redDilated, se); % closing all the remaining gaps
    red = imerode(redClose, se); % minimizing back to initial size
    
    yellowRangeFilt = rangefilt(yellow); % using range filter to identify the boundary of the tag
    redRangeFilt = rangefilt(red); % using range filter to identify the boundary of the tag
    
    RGBandY = imoverlay(RGB, yellowRangeFilt, "blue"); % overlaying the range filter in colour blue over the image
    RGBboundaries = imoverlay(RGBandY, redRangeFilt, "green"); % overlaying the range filter in colour green over the already overlayed image
    
    [iY, jY] = find(yellow); % searching for the (i,j) coordinates of the yellow tag
    yY = mean2(iY); % mean of the length to find centroid
    xY = mean2(jY); %mean if the hight to find centroid
    [iR,jR] = find(red); % searching for the (i,j) coordinates of the red tag
    yR = mean2(iR); % mean of the length to find centroid
    xR = mean2(jR); %mean if the hight to find centroid
    
    dCityBlock  = abs(yY-yR)+abs(xY-xR); % calculating the City Block distance 
    dChessboard = max(abs(yY-yR),abs(xY-xR)); % calculating the Chessboard distance
    dEuclidean  = sqrt((yY-yR)^2+(xY-xR).^2); % calculating the Euclidean distance 
    
    chessx = (((xY+xR)/2) + xR)/2; 
    chessy = (((yY+yR)/2) + yY)/2;
    
    imshow(RGBboundaries) % displaying image 
    delete(findall(gcf,'type','annotation')); % delete old annotation if existent
    % plotting visuals for the above calculations 
    hold on
    plot([xY, xR],[yY, yY], '-mo', [xR, xR], [yR, yY], '-mo', 'LineWidth', 1); % city block line
    plot([xY, chessx], [yY, chessy], '-go', [chessx, xR], [chessy, yR], '-go', 'Linewidth', 1); % chessboard line
    plot([xY, xR], [yY, yR],'-c*','Linewidth',1); % eucledian line
    string = {['Red Tag Centroid x coordinates = ',num2str(xR)],['Red Tag Centroid y coordinates = ',num2str(yR)], ...
           ['Yellow Tag Centroid x coordinates = ',num2str(xY)],['Yellow Tag Centroid y coordinates = ',num2str(yY)], ...
           ['City Block Distance = ',num2str(dCityBlock)], ...
           ['Chessboard Distance = ',num2str(dChessboard)], ...
           ['Euclidean Distance = ',num2str(dEuclidean)]}; % string that will be displayed in the annotation box
    annotation('textbox',dim,'String',string,'FitBoxToText','on','EdgeColor','black','Color','black'); % creating the annotation box
    drawnow; % updates figure and processes any pending call-backs
    frame = getframe(ax); % get the frame ready to be written to video file 
    writeVideo(videoFile, frame); % writing frame to video file 
    hold off

end

close(videoFile);
