function [eye1,eye2,mouth,showim] = EyeMouthD(im)
%This function is used to detect the eyes and mouth index of the face
%automatically
%The input image is RGB color based
%Attention, the image should be colorful

[M,N,C] = size(im); 
imycbcr = rgb2ycbcr(im);

Y = double(imycbcr(:,:,1));
Cb = double(imycbcr(:,:,2));
Cr = double(imycbcr(:,:,3));

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
% figure;imshow(EyeMap,[]);
%Masked, normally eyes appear in the following area
mask = zeros(M,N);
left = round(N/6);
right = round(5*N/6);
GRx = 1:M;
GRy = normpdf(GRx,round(M/2.5),M/4);
mask(:,left:right)=repmat(GRy',1,right-left+1);
GCx = repmat(1:left,M,1);
GCy = normpdf(GCx,0,left/3);
for i=1:M
    GCy(i,:) = GCy(i,:)/GCy(i,1)*mask(i,left);
end
[tempM,tempN]=size(GCy);
mask(:,right:(right+tempN-1)) = GCy;
mask(:,(left-tempN+1):left) = fliplr(GCy);
% figure;imshow(mask,[]);

mEyeMap = imnormal(EyeMap.*mask);
% figure;imshow(mEyeMap,[]);
% figure;imshow(mEyeMap,[]);
%Now we could automatically find the eye area
template = ones(5,5);
mEyeMap = conv2(mEyeMap,template,'same');
% figure;imshow(mEyeMap,[]);
[tempinx,tempiny] = find(mEyeMap == max(max(mEyeMap)));
index_e1x = tempinx(1);
index_e1y = tempiny(1);

%Mask out the first eye and mark the second eye
halfm = round(N/7);
masktemp = ones(M,N);
masktemp((index_e1x-halfm):(index_e1x+halfm),(index_e1y-halfm):(index_e1y+halfm)) = 0;
mEyeMap= mEyeMap.*masktemp;
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
%Let's use a retangle to mark the eyes
halfl = round(N/9);
halfw = round(N/18);
luc = [index_e1x-halfw,index_e1y-halfl];
ruc = [index_e1x-halfw,index_e1y+halfl];
llc = [index_e1x+halfw,index_e1y-halfl];
rlc = [index_e1x+halfw,index_e1y+halfl];
showim = im;
showim = makegreen(showim,luc,ruc,llc,rlc,theta);
% figure;imshow(im,[]);
luc = [index_e2x-halfw,index_e2y-halfl];
ruc = [index_e2x-halfw,index_e2y+halfl];
llc = [index_e2x+halfw,index_e2y-halfl];
rlc = [index_e2x+halfw,index_e2y+halfl];
showim = makegreen(showim,luc,ruc,llc,rlc,theta);

% Use mouth map to detect mouth automatically
term1 = imnormal(Cr.^2);
term2 = imnormal(Cr./Cb);
MouthMap = term1.*(term1-0.2*term2).^2;
MouthMap = imnormal(imdilate(MouthMap,strel('disk',3)));
% figure;imshow(MouthMap,[]);
%We need to put mask on the face to make sure we are looking for the mouth
%in the right area
eye1 = [index_e1x,index_e1y];
eye2 = [index_e2x,index_e2y];
MouthMask = MMask(im,eye1,eye2);
MouthMap = MouthMap.*MouthMask;
% figure;imshow(MouthMap,[]);
[tempinx,tempiny] = find(MouthMap == max(max(MouthMap)));
index_mx = tempinx(1);
index_my = tempiny(1);

mouth = [index_mx,index_my];

halfw = round(1.2*halfw);
halfl = round(1.8*halfl);
luc = [index_mx-halfw,index_my-halfl];
ruc = [index_mx-halfw,index_my+halfl];
llc = [index_mx+halfw,index_my-halfl];
rlc = [index_mx+halfw,index_my+halfl];
showim = makegreen(showim,luc,ruc,llc,rlc,theta);