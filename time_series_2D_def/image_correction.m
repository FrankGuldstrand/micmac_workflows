clear all; close all; clc;

% Script for correcting lens distortion and writing images
% Frank Guldstrand

% extension to images
images = imageDatastore('cam1/lensdistortion','FileExtensions','.JPG'); 
L=length(images.Files);

% images.Files=images.Files((L/2+1):end);

mkdir cam1/lensdistortionrotate

for i=2:L
    fname=[images.Files{i}];
    I=imread(fullfile(fname));
    I=imrotate(I,90);
    fname=['cam1/lensdistortionrotate/',num2str(i,'%03.0f\n'),'.tif'];
    imwrite(I,fname);
end

disp('rotate finished')
%%

clear all
images = imageDatastore('cam1/lensdistortionrotate','FileExtensions','.tif');
L=length(images.Files);

[imagePoints,boardSize] = detectCheckerboardPoints(images.Files);

squareSize = 7;
worldPoints = generateCheckerboardPoints(boardSize,squareSize);

I = readimage(images,1);
imageSize = [size(I, 1), size(I, 2)];

cameraParams = estimateCameraParameters(imagePoints,worldPoints);

savefile='cam1/cameraParams.mat';
save(savefile,'cameraParams')

disp('Cam Params Finished');

%% This is to check the computed camera parameters
% i=1;
% 
% I = images.readimage(i);
% J1 = undistortImage(I,cameraParams);                          
% 
% figure; imshowpair(I,J1,'montage');
% title('Original Image (left) vs. Corrected Image (right)');
% 
% 
% J2 = undistortImage(I,cameraParams,'OutputView','full');
% figure;
% imshow(J2);
% title('Full Output View');
% 
% figure;
% imshow(I);
% hold on;
% plot(imagePoints(:,1,i), imagePoints(:,2,i),'go');
% plot(cameraParams.ReprojectedPoints(:,1,i),cameraParams.ReprojectedPoints(:,2,i),'r+');
% legend('Detected Points','ReprojectedPoints');
% hold off;

%% Check time interval Raw
% This to assess the exifdata for time to see the interval
clearvars -except cameraParams texpc2

images = imageDatastore('cam1/raw','FileExtensions','.JPG');
L=length(images.Files);
tstamp=zeros(L,1);

for i=1:L
    fname=[images.Files{i}];
    I=imfinfo(fullfile(fname));
    I=I.DateTime(12:end);
    tstamp(i)=datenum(I);
    clear I;
end


figure (1)
plot(diff(tstamp(:,1)),'-x')
title('Cam 1')
xlabel('Nr')
ylabel('Datenum')
%%

tsd=diff(tstamp(:,1));

%%
% [~,edges]=histcounts(tsd);
% 
% IO=tsd;
% IO(tsd > edges(2))=NaN;
% [I, ]=find(isnan(IO)==1);

I=284;
%Display times
clc

for i=1:1:length(I)
disp(['Start Error ',num2str(I(i))])
dt=imfinfo(images.Files{I(i)-1});
display(['dt1=',dt.DateTime(12:end)])
dt=imfinfo(images.Files{I(i)});
display(['dt2=',dt.DateTime(12:end)])
dt=imfinfo(images.Files{I(i)+1});
display(['dt3=',dt.DateTime(12:end)])
disp(['End Error ',num2str(I(i))])
fprintf('\n')
end

%% Create time array
texp=ones(L,1)*10;
texp(1)=0;

%%
texptemp=cumsum(texp);

%%
close all
hold on
plot(diff(texptemp)/max(diff(texptemp)),'k');
plot(tsd/max(tsd),'r');
hold off

%%
savefile='texp.mat';
save(savefile,'texp')

%% SETTING INTERVAL
load('cam1/cameraParams.mat');
clearvars -except cameraParams


%%
images = imageDatastore('cam1/raw','FileExtensions','.JPG');
L=length(images.Files);

mkdir cam1/output

mkdir cam1/outputjpeg

nc=0;
for n=1:12:313 %length(images.Files)
nc=nc+1;
   fname=[images.Files{n}];
    I=imread(fullfile(fname));
    I=imrotate(I,90);
tpic=I;
tpic=undistortImage(tpic,cameraParams);
tpic=adapthisteq(tpic(:,:,1));
fname=['cam1/output/',num2str(nc,'%03.0f\n'),'.tif'];
% imshow(tpic(1200:5250,100:3900,1))
imwrite(tpic(1200:5250,100:3900),fname,'tif');

fname=['cam1/outputjpeg/',num2str(nc,'%03.0f\n'),'.JPG'];

imwrite(tpic(1200:5250,100:3900),fname,'jpg');


clear tpic
end

disp('Finished Undistortion')

%% Print Checkerboard for pixel to realscale
images = imageDatastore('cam1/lensdistortionrotate','FileExtensions','.tif');
% nc=nc+1;
tpic=imread(images.Files{1});
tpic=undistortImage(tpic,cameraParams);
% tpic=adapthisteq(tpic(:,:,1));
fname=['cam1/cbundistort.tif'];
imwrite(tpic(1200:5250,100:3900),fname,'tif');
clear tpic


