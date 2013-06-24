function out = Gmask(im)
%This function is used to create a gaussian mask

[M,N]= size(im);
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

out = imnormal(im.*mask);