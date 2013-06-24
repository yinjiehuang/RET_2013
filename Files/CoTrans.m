function face1t = CoTrans(face1,P1,P2)
%This function is used to transform the coordinates of the two faces
%P1 is the indexes of eye1, eye2 and mouth in face 1
%P2 is the indexes of eye1, eye2 and mouth in face 2

F1E1 = P1(1,:);
F1E2 = P1(2,:);
F1M = P1(3,:);

F2E1 = P2(1,:);
F2E2 = P2(2,:);
F2M = P2(3,:);

%First of all, we need to partition the image pixels into five different
%areas
[M,N,P] = size(face1);
x = 1:M;
y = 1:N;
[X,Y] = ndgrid(x,y);
%Index of area 1
xv = [1,1,F2E1(1),1];
yv = [1,N,F2E1(2),1];
Area1 = double(inpolygon(X,Y,xv,yv));
[A1x,A1y] = find(Area1==1);
RA1 = ImWrap(A1x,A1y,face1,[1 1 F1E1(1)],[1 N F1E1(2)],[1 1 F2E1(1)],[1 N F2E1(2)]);
%Index of area 2
xv = [F2E1(1),1,F2E2(1),F2E1(1)];
yv = [F2E1(2),N,F2E2(2),F2E1(2)];
Area2 = double(inpolygon(X,Y,xv,yv));
[A2x,A2y] = find(Area2==1);
RA2 = ImWrap(A2x,A2y,face1,[F1E1(1) 1 F1E2(1)],[F1E1(2) N F1E2(2)],[F2E1(1) 1 F2E2(1)],[F2E1(2) N F2E2(2)]);
%Index of area 3
xv = [1,F2E1(1),M,1];
yv = [1,F2E1(2),1,1];
Area3 = double(inpolygon(X,Y,xv,yv));
[A3x,A3y] = find(Area3==1);
RA3 = ImWrap(A3x,A3y,face1,[1 F1E1(1) M],[1 F1E1(2) 1],[1 F2E1(1) M],[1 F2E1(2) 1]);
%Index of area 4
xv = [F2E1(1),F2M(1),M,F2E1(1)];
yv = [F2E1(2),F2M(2),1,F2E1(2)];
Area4 = double(inpolygon(X,Y,xv,yv));
[A4x,A4y] = find(Area4==1);
RA4 = ImWrap(A4x,A4y,face1,[F1E1(1) F1M(1) M],[F1E1(2) F1M(2) 1],[F2E1(1) F2M(1) M],[F2E1(2) F2M(2) 1]);
%Index of area 5
xv = [F2E1(1),F2E2(1),F2M(1),F2E1(1)];
yv = [F2E1(2),F2E2(2),F2M(2),F2E1(2)];
Area5 = double(inpolygon(X,Y,xv,yv));
[A5x,A5y] = find(Area5==1);
RA5 = ImWrap(A5x,A5y,face1,[F1E1(1) F1E2(1) F1M(1)],[F1E1(2) F1E2(2) F1M(2)],[F2E1(1) F2E2(1) F2M(1)],[F2E1(2) F2E2(2) F2M(2)]);
%Index of area 6
xv = [F2M(1),F2E2(1),M,F2M(1)];
yv = [F2M(2),F2E2(2),N,F2M(2)];
Area6 = double(inpolygon(X,Y,xv,yv));
[A6x,A6y] = find(Area6==1);
RA6 = ImWrap(A6x,A6y,face1,[F1M(1) F1E2(1) M],[F1M(2) F1E2(2) N],[F2M(1) F2E2(1) M],[F2M(2) F2E2(2) N]);
%Index of area 7
xv = [F2E2(1),1,M,F2E2(1)];
yv = [F2E2(2),N,N,F2E2(2)];
Area7 = double(inpolygon(X,Y,xv,yv));
[A7x,A7y] = find(Area7==1);
RA7 = ImWrap(A7x,A7y,face1,[F1E2(1) 1 M],[F1E2(2) N N],[F2E2(1) 1 M],[F2E2(2) N N]);
%Index of area 8
xv = [M,F2M(1),M,M];
yv = [1,F2M(2),N,1];
Area8 = double(inpolygon(X,Y,xv,yv));
[A8x,A8y] = find(Area8==1);
RA8 = ImWrap(A8x,A8y,face1,[M F1M(1) M],[1 F1M(2) N],[M F2M(1) M],[1 F2M(2) N]);

face1t = RA1+RA2+RA3+RA4+RA5+RA6+RA7+RA8;
TRA1 = rgb2gray(RA1);
TRA2 = rgb2gray(RA2);
TRA3 = rgb2gray(RA3);
TRA4 = rgb2gray(RA4);
TRA5 = rgb2gray(RA5);
TRA6 = rgb2gray(RA6);
TRA7 = rgb2gray(RA7);
TRA8 = rgb2gray(RA8);
[Inx1,Iny1] = find(TRA1 == TRA3 & TRA1~=0 & TRA3~=0);
[Inx2,Iny2] = find(TRA1 == TRA2 & TRA1~=0 & TRA2~=0);
[Inx3,Iny3] = find(TRA2 == TRA5 & TRA2~=0 & TRA5~=0);
[Inx4,Iny4] = find(TRA2 == TRA7 & TRA2~=0 & TRA7~=0);
[Inx5,Iny5] = find(TRA3 == TRA4 & TRA3~=0 & TRA4~=0);
[Inx6,Iny6] = find(TRA4 == TRA5 & TRA4~=0 & TRA5~=0);
[Inx7,Iny7] = find(TRA5 == TRA6 & TRA5~=0 & TRA6~=0);
[Inx8,Iny8] = find(TRA6 == TRA7 & TRA6~=0 & TRA7~=0);
[Inx9,Iny9] = find(TRA4 == TRA8 & TRA4~=0 & TRA8~=0);
[Inx10,Iny10] = find(TRA8 == TRA6 & TRA8~=0 & TRA6~=0);
Inx = [Inx1;Inx2;Inx3;Inx4;Inx5;Inx6;Inx7;Inx8;Inx9;Inx10];
Iny = [Iny1;Iny2;Iny3;Iny4;Iny5;Iny6;Iny7;Iny8;Iny9;Iny10];
for i = 1:length(Inx)
    face1t(Inx(i),Iny(i),1) = face1t(Inx(i),Iny(i),1)/2;
    face1t(Inx(i),Iny(i),2) = face1t(Inx(i),Iny(i),2)/2;    
    face1t(Inx(i),Iny(i),3) = face1t(Inx(i),Iny(i),3)/2;
end
face1t = uint8(face1t);
