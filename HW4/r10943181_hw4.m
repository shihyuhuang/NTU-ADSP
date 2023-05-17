I1 = imread('cat.jpeg');
I2 = imread('cat.jpeg');
I1_gray = rgb2gray(I1);       
I2_gray = rgb2gray(I2); 
img1 = double(I1_gray);
img2 = double(I2_gray);

L = 255;

% adjustable constants
c1 = 1/sqrt(L);
c2 = 1/sqrt(L);

% means of x and y
mean1 = mean((img1), 'all');
mean2 = mean((img2), 'all'); 

% variances of x and y
[M,N] = size(I1);
var1 = sum(((img1-mean1).^2), 'all') /(M*N);
var2 = sum(((img2-mean2).^2), 'all') /(M*N);

% covariance of x and y
conv = sum((img1-mean1).*(img2-mean2), 'all') /(M*N);

% SSIM
ssim = (2*mean1*mean2+(c1*L)^2)/(mean1^2+mean2^2+(c1*L)^2) * (2*conv+(c2*L)^2)/(var1+var2+(c2*L)^2)

subplot(1,2,1)
imshow(I1_gray);
title('image 1');
subplot(1,2,2)
imshow(I2_gray);
title('image 2');
sgt = sgtitle(['SSIM: ', num2str(ssim)]);
sgt.FontSize = 20;