clear;clc;

%% This program is about implementing face morphing algorithm
%Please read in the color image
im = imread('huang.jpg');
% figure;imshow(im,[]);
[M,N,C] = size(im); 
imycbcr = rgb2ycbcr(im);

Y = double(imycbcr(:,:,1));
Cb = double(imycbcr(:,:,2));
Cr = double(imycbcr(:,:,3));

%% Automatic detect eye
%Compute the Eye Map C
term1 = imnormal(Cb.^2);
term2 = imnormal((255-Cr).^2);
term3 = imnormal(Cb./Cr);
EyeMapC = (term1+term2+term3)/3;
EyeMapC = imnormal(EyeMapC);

%Compute the Eye Map L
se = strel('disk',5);
temp1 = imdilate(Y,se);
temp2 = imerode(Y,se);
EyeMapL = temp1./(temp2+1);
EyeMapL = imnormal(EyeMapL);
%Use histogram equalization to enhance the result
EyeMapL = double(histeq(uint8(EyeMapL)));

%Combine as Eye Map
EyeMap = imnormal(EyeMapC.*EyeMapL);
%Dilate again
EyeMap = imdilate(EyeMap,strel('disk',3));
%Masked, normally eyes appear in the following area
mEyeMap = Gmask(EyeMap);
%Now we could automatically find the eye area
[tempinx,tempiny] = find(mEyeMap == max(max(mEyeMap)));
index_e1x = tempinx(1);
index_e1y = tempiny(1);

%Mask out the first eye and mark the second eye
mEyeMap= OneEyeMask(mEyeMap,index_e1x,index_e1y);
[tempinx,tempiny] = find(mEyeMap == max(max(mEyeMap)));
index_e2x = tempinx(1);
index_e2y = tempiny(1);

%First of all, change the eye index
if index_e2y < index_e1y
    temp = index_e2y;
    index_e2y = index_e1y;
    index_e1y = temp;
    temp = index_e2x;
    index_e2x = index_e1x;
    index_e1x = temp;
end
theta = atan((index_e1x-index_e2x)/(index_e2y-index_e1y));
% theta = 0;
%Let's use a retangle to mark the eyes
showim = im;
showim = makegreen_eye(showim,index_e1x,index_e1y,theta);
showim = makegreen_eye(showim,index_e2x,index_e2y,theta);

%% Now we will detect the mouth
% Use mouth map to detect mouth automatically
term1 = imnormal(Cr.^2);
term2 = imnormal(Cr./Cb);
MouthMap = term1.*(term1-0.2*term2).^2;
MouthMap = imnormal(imdilate(MouthMap,strel('disk',3)));
%We need to put mask on the face to make sure we are looking for the mouth
%in the right area
eye1 = [index_e1x,index_e1y];
eye2 = [index_e2x,index_e2y];
MouthMask = MMask(im,eye1,eye2);
MouthMap = MouthMap.*MouthMask;

[tempinx,tempiny] = find(MouthMap == max(max(MouthMap)));
index_mx = tempinx(1);
index_my = tempiny(1);
showim = makegreen_mouth(showim,index_mx,index_my,theta);

figure;imshow(showim,[]);
