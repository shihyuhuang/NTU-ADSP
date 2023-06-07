clc;
clear;

x = [47 23 0.7 0 13 83 93 101];
y = [72 273 1 1 28 38 3.92 38.8];

[Fx, Fy] = fftreal(x,y)


function [Fx, Fy] = fftreal(x, y)
    % Step 1: f3[n] = f1[n] + jf2[n]   
    f3 = x + 1i*y;

    % Step 2: F3[m] = DFT{f3[n]}
    F3 = fft(f3); 

    % Step 3
    N = length(x);
    reverse_f3 = F3(end:-1:1);
    shifted_F3 = [reverse_f3(mod((0:N-1)-1, N)+1)];
    Fx = (F3 + conj(shifted_F3))/2;  
    Fy = (F3 - conj(shifted_F3))/(2*1i); 

end