function result = ImWrap(Ax,Ay,im,u,v,x,y);
%This funciton is used to bilinear image wraping
%Ax and Ay are the indexs of the image area
%im is the image
%u v x y define the affine transformation
[M,N,P] = size(im);
tform = maketform('affine',[u' v'],[x' y']);
[UI,VI] = tforminv(tform,Ax,Ay);
[U,V] = meshgrid(1:M,1:N);
Out(:,:,1) = interp2(U,V,im(:,:,1)',UI,VI,'linear');
Out(:,:,2) = interp2(U,V,im(:,:,2)',UI,VI,'linear');
Out(:,:,3) = interp2(U,V,im(:,:,3)',UI,VI,'linear');

result = zeros(M,N);
for i = 1:length(Ax)
    result(Ax(i),Ay(i),1) = Out(i,1,1);
    result(Ax(i),Ay(i),2) = Out(i,1,2);
    result(Ax(i),Ay(i),3) = Out(i,1,3);
end