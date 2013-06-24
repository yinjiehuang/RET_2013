function result = makegreen_eye(im,index_e1x,index_e1y,theta)
%This function is used to make the image pixel become green
[M,N,P] = size(im);

halfl = round(N/9);
halfw = round(N/18);
p1 = [index_e1x-halfw,index_e1y-halfl];
p2 = [index_e1x-halfw,index_e1y+halfl];
p3 = [index_e1x+halfw,index_e1y-halfl];
p4 = [index_e1x+halfw,index_e1y+halfl];

%Rotate the upper horizontal line
L = abs(p1(2)-p2(2))+1;
W = abs(p1(1)-p3(1))+1;

x = [p1(1)*ones(1,L),p1(1):p3(1),p3(1)*ones(1,L),p2(1):p4(1)]-p1(1);
y = [p1(2):p2(2),p1(2)*ones(1,W),p3(2):p4(2),p2(2)*ones(1,W)]-p1(2);

temp = [cos(theta), -sin(theta);sin(theta), cos(theta)]*[x;y];
x = round(temp(1,:))+p1(1);
y = round(temp(2,:))+p1(2);
x = max(x,1);
x = min(x,M);
y = max(y,1);
y = min(y,N);
for i = 1:length(y)
    im(x(i),y(i),1) = 124;
    im(x(i),y(i),2) = 252;
    im(x(i),y(i),3) = 0;
end

result = im;