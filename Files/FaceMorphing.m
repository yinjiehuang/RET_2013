clear;clc;

%This file is used to implement the face morphing algorithm
path1 = [pwd,'\Faces\kk.jpg'];
path2 = [pwd,'\Faces\hp.jpg'];
face1 = imread(path1);
face2 = imread(path2);
% face1 = imread('kk.jpg');
% face2 = imread('hp.jpg');

%% resize the two images
[M1,N1,P] = size(face1);
[M2,N2,P] = size(face2);

M = min([M1,M2]);
N = min([N1,N2]);

face1 = imresize(face1,[M,N]);
face2 = imresize(face2,[M,N]);

[f1_eye1,f1_eye2,f1_mouth,f1show] = EyeMouthD(face1);
[f2_eye1,f2_eye2,f2_mouth,f2show] = EyeMouthD(face2);

% imshow1 = makegreenp(face1,[f1_eye1;f1_eye2;f1_mouth]);
% figure; imshow(imshow1,[]);
% imshow2 = makegreenp(face2,[f2_eye1;f2_eye2;f2_mouth]);
% figure; imshow(imshow2,[]);

%% let's start face morphing
% path('C:\Users\Yinjie Huang\Downloads');
vidObj = VideoWriter('FaceMorphing.avi');
filename = 'shabi.gif';
open(vidObj);
i = 1;
for alpha = 0:0.1:1
% alpha = 0.3;
    interf_eye1 = alpha*f1_eye1+(1-alpha)*f2_eye1;
    interf_eye2 = alpha*f1_eye2+(1-alpha)*f2_eye2;
    interf_mouth = alpha*f1_mouth+(1-alpha)*f2_mouth;

% im = face1*0.5+(1-0.5)*face2;
% figure;imshow(im,[]);
    face1t = CoTrans(double(face1),[f1_eye1;f1_eye2;f1_mouth],[interf_eye1;interf_eye2;interf_mouth]);
% figure;imshow(face1t,[]);
    face2t = CoTrans(double(face2),[f2_eye1;f2_eye2;f2_mouth],[interf_eye1;interf_eye2;interf_mouth]);
% figure;imshow(face2t,[]);
    im = face1t*alpha+(1-alpha)*face2t;
    imshow(im,[]);
    pause(0.05);
    currFrame = getframe;
    im = frame2im(currFrame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    i = i+1;
    for j=1:5
    writeVideo(vidObj,currFrame);
    end
end
close(vidObj);