clear;
clc;

k = 8; % input parameter

N = 2*k+1;
F = (0:(N-1))*(1/N);
transition_band = [(k)/(2*k+1) (k+1)/(2*k+1)];


% step 1
Hd = zeros(1,N);

for i=1:N
    if (F(i)<0.5)
        Hd(i)=j*2*pi*F(i);
    else
        Hd(i)=j*2*pi*(F(i)-1);
    end
end
H = Hd;
%H(k+1) = Hd(k+1)*0.7; % for transition band
%H(k+2) = Hd(k+2)*0.3; % for transition band

% step 2
r1 = ifft(H);

% step 3
r  = circshift(r1,k);

% step 4
% step 5
FF = 0:0.001:1;
RF = zeros(1,length(FF));
for n=1:N
    RF = RF + r(n)*exp(-j*2*pi*FF*(n-k-1));
end

HH = zeros(1,length(FF));

for i=1:length(FF)
    if (FF(i)<0.5)
        HH(i)=j*2*pi*FF(i);
    else
        HH(i)=j*2*pi*(FF(i)-1);
    end
end


figure;
subplot(3,1,1)
x = 0:1:N-1;
stem(x,real(r1))
xlim([-N N])
title('r1[n]')
xlabel('time')

subplot(3,1,2)
x = -k:1:k;
stem(x,real(r))
xlim([-N N])
title('r[n]')
xlabel('time')

subplot(3,1,3)
x = 0:1:N-1;
stem(x,real(r))
xlim([-N N])
title('h[n]')
xlabel('time')

figure;
plot(F, imag(H), 'black o', FF, imag(HH), 'blue', FF, imag(RF),'red');
title('Frequency Response');
xlabel('frequency(Hz)');
legend(["","Hd","R"])
