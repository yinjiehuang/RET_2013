function SkinMap = sdetect(imycbcr)
%This function is uesed to detect the skin are of the face and help to
%construct the meshes to do face morphing

[M,N,C] = size(imycbcr);
Y = double(imycbcr(:,:,1));
Cb = double(imycbcr(:,:,2));
Cr = double(imycbcr(:,:,3));

%These are some constants predefined
Wcb = 46.97;
WLcb = 23;
WHcb = 14;
Wcr = 38.76;
WLcr = 20;
WHcr = 10;
Kl = 125;
Kh = 188;
Ymin = 16;
Ymax = 235;

indexY1 = find(Y < Kl);
indexY2 = find(Y > Kh);
indexY3 = find(Y >=Kl & Y<=Kh);
indexY4 = find(Y < Kl | Y> Kh);

barCbY = zeros(M,N);
barCrY = zeros(M,N);
WcbY = zeros(M,N);
WcrY = zeros(M,N);

%Let's compute the corresponding values
barCbY(indexY1) = 108+(Kl-Y(indexY1))*(118-108)/(Kl-Ymin);
barCbY(indexY2) = 108+(Y(indexY2)-Kh)*(118-108)/(Ymax-Kh);

barCrY(indexY1) = 154-(Kl-Y(indexY1))*(154-144)/(Kl-Ymin);
barCrY(indexY2) = 154+(Y(indexY2)-Kh)*(154-132)/(Ymax-Kh);

WcbY(indexY1) = WLcb+(Y(indexY1)-Ymin)*(Wcb-WLcb)/(Kl-Ymin);
WcbY(indexY2) = WHcb+(Ymax-Y(indexY2))*(Wcb-WHcb)/(Ymax-Kh);

WcrY(indexY1) = WLcr+(Y(indexY1)-Ymin)*(Wcr-WLcr)/(Kl-Ymin);
WcrY(indexY2) = WHcr+(Ymax-Y(indexY2))*(Wcr-WHcr)/(Ymax-Kh);

%Now compute the transformed Cb and Cr channel
Cbp = zeros(M,N);
Crp = zeros(M,N);

temp = barCbY(indexY4);
Cbp(indexY4) = (Cb(indexY4)-temp)*Wcb./WcbY(indexY4)+temp;
Cbp(indexY3) = Cb(indexY3);

temp = barCrY(indexY4);
Crp(indexY4) = (Cr(indexY4)-temp)*Wcr./WcrY(indexY4)+temp;
Crp(indexY3) = Cr(indexY3);


%Now we could cluster based on this transformed color space
ab(:,:,1) = Cbp;
ab(:,:,2) = Crp;

nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
SkinMap = reshape(cluster_idx,nrows,ncols);