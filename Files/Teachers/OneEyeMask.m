function out = OneEyeMask(im,index_e1x,index_e1y)
%This is used to mask out one eye from the image

[M,N] = size(im);
halfm = round(N/7);
masktemp = ones(M,N);
masktemp((index_e1x-halfm):(index_e1x+halfm),(index_e1y-halfm):(index_e1y+halfm)) = 0;
out = im.*masktemp;