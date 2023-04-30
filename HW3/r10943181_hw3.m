I = imread('peppers.png');
img = im2double(I);
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

Cb = Cb(1:2:end,1:2:end);
Cr = Cr(1:2:end,1:2:end);

