clear;
clc;

I = imread('cat.jpeg');
img = im2double(I);

figure(1)
image(img);
title('original');

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

matrix = [ 0.299  0.587  0.114;
          -0.169 -0.331  0.500;
           0.500 -0.419 -0.081];

Y  = matrix(1,1)*R+matrix(1,2)*G+matrix(1,3)*B; 
Cb = matrix(2,1)*R+matrix(2,2)*G+matrix(2,3)*B; 
Cr = matrix(3,1)*R+matrix(3,2)*G+matrix(3,3)*B;

% 4:2:0
Y_com = Y;
Cb_com = Cb(1:2:end,1:2:end);
Cr_com = Cr(1:2:end,1:2:end);

% reconstruct
% 1
Y_re = Y_com;

Cb_re_temp = [];
Cr_re_temp = [];
for i=1:size(Cb_com,1)
    Cb_re_temp = [Cb_re_temp;Cb_com(i,:);ones(1,ceil(size(Cb,2)/2))];
    Cr_re_temp = [Cr_re_temp;Cr_com(i,:);ones(1,ceil(size(Cr,2)/2))];
end

if mod(size(Cb,1),2)==1 % odd
    Cb_re_temp = Cb_re_temp(1:end-1,:);
    Cr_re_temp = Cr_re_temp(1:end-1,:);
end

Cb_re = [];
Cr_re = [];
for i=1:size(Cb_com,2)
    Cb_re = [Cb_re,Cb_re_temp(:,i),ones(size(Cb,1),1)];
    Cr_re = [Cr_re,Cr_re_temp(:,i),ones(size(Cr,1),1)];
end

if mod(size(Cb,2),2)==1 % odd
    Cb_re = Cb_re(:,1:end-1);
    Cr_re = Cr_re(:,1:end-1);
end

% 2
for m=1:size(Cb_com,1)-1
    Cb_re(2*m,:) = (Cb_re(2*m-1,:)+Cb_re(2*m+1,:))/2;
    Cr_re(2*m,:) = (Cr_re(2*m-1,:)+Cr_re(2*m+1,:))/2;
end

if mod(size(Cb_re,1),2)==0
    Cb_re(end,:) = Cb_re(end-1,:);
    Cr_re(end,:) = Cr_re(end-1,:);
end

for m=1:size(Cb_com,2)-1
    Cb_re(:,2*m) = (Cb_re(:,2*m-1)+Cb_re(:,2*m+1))/2;
    Cr_re(:,2*m) = (Cr_re(:,2*m-1)+Cr_re(:,2*m+1))/2;
end

if mod(size(Cb_re,2),2)==0
    Cb_re(:,end) = Cb_re(:,end-1);
    Cr_re(:,end) = Cr_re(:,end-1);
end

matrix_inv = inv(matrix);

R_af = matrix_inv(1,1)*Y_re+matrix_inv(1,2)*Cb_re+matrix_inv(1,3)*Cr_re; 
G_af = matrix_inv(2,1)*Y_re+matrix_inv(2,2)*Cb_re+matrix_inv(2,3)*Cr_re; 
B_af = matrix_inv(3,1)*Y_re+matrix_inv(3,2)*Cb_re+matrix_inv(3,3)*Cr_re;

img_af = ones(size(img));
img_af(:,:,1) = R_af;
img_af(:,:,2) = G_af;
img_af(:,:,3) = B_af;

figure(2);
image(img_af);
title('reconstruct');

MAX=1;
MES=sum(sum(sum((img-img_af).^2)))/(size(img,1)*size(img,2)*3);    %均方差
PSNR=20*log10(MAX/sqrt(MES)) 