function result = makegreenp(im,p)
%This function is usded to make one pixel in the image show green
x = p(:,1);
y = p(:,2);
for i = 1:length(y)
    im(x(i),y(i),1) = 124;    
    im(x(i),y(i),2) = 252;
    im(x(i),y(i),3) = 0;
end
result = im;