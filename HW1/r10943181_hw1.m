clear;
clc;

N = 21;  % filter length
k = (N - 1)/2; 

W_big = 1;
W_small = 0.8;
delta = 0.0001;
F = 0:delta:0.5;

Hd_center = 1800/8000;
W_high = 2000/8000;
W_low = 1600/8000;

h = zeros(k+2,1);
A = zeros(k+2,k+2);
S = zeros(k+2,1);  
Hd = zeros(k+2,1);
W = zeros(k+2,1);
P = []; % extreme points

% for all F
Hd_delta = zeros(size(F,2),1);
W_delta = zeros(size(F,2),1);
err = zeros(size(F,2),1);
R = zeros(size(F,2),1);

E0 = 0;
E1 = inf;
E0_all = [];

for i = 1:size(F,2)
    if(F(i)<Hd_center)
        Hd_delta(i) = 0;
    else
        Hd_delta(i) = 1;
    end
end


for i = 1:size(F,2)
    if(F(i)<=W_low)
        W_delta(i) = W_small;
    elseif(F(i)>=W_high) 
        W_delta(i) = W_big;
    else % transition band
        W_delta(i) = 0;
    end
end


% step 1
Fm = [0, 0.02, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.39, 0.45, 0.5];

while (E1-E0>delta || E1-E0<0)
    % step 2
    for i = 1:(k+2)
        for j = 1:(k+1)
            A(i,j) = cos(2*pi*(j-1)*Fm(i)); % cos(2*pi*k*F)
        end
    end
    
    
    for i = 1:(k+2)
        if(Fm(i)<=W_low)
            W(i) = W_small;
        elseif(Fm(i)>=W_high) 
            W(i) = W_big;
        else
            W(i) = 0;
        end
    end
    
    
    for i = 1:(k+2)
        A(i,(k+2)) = ((-1)^(i-1))/W(i); % (-1)^(k+1)/W(Fk+1)
    end
    
    
    for i = 1:(k+2)
        if(Fm(i)<Hd_center)
            Hd(i) = 0;
        else
            Hd(i) = 1;
        end
    end
    A
    Hd
    S = inv(A)*Hd   % A^(-1)*b
    
    
    % step 3
    R = zeros(size(F,2),1);
    for i=1:size(F,2)
        for j=1:k+1
            R(i) = R(i)+S(j)*cos(2*pi*(j-1)*F(i));
        end
        err(i) = (R(i)-Hd_delta(i))*W_delta(i);
    end
   
    
    % step 4
    temp_err = [0; err; 0;];
    ex_max = islocalmax(temp_err);
    ex_min = islocalmin(temp_err);
    
    P = [];
    for i=2:size(F,2)+1
        if(ex_max(i))
            P = [P, F(i-1)];
        end
        if(ex_min(i))
            P = [P, F(i-1)];
        end
    end
  
    if(size(P,2)~=k+2)
        disp("size(P,2)~=k+2");
    end
    P

    if(size(P,2)==k+4)
        P = P(2:k+3);
    elseif(size(P,2)==k+3)
        if(abs(err(1))>abs(err(size(F,2))))
            P = P(1:k+2);
        else
            P = P(2:k+3);
        end
    end
    
    % step 5
    E1 = E0;
    E0 = max(abs(err))
    
    Fm = P

    E0_all = [E0_all, E0]
end

% step 6
h(k+1) = S(1);
for i = 1:k
    h(k+i+1) = S(i+1)/2;
    h(k-i+1) = S(i+1)/2;
end
h


figure(1)
plot(F, R, F ,Hd_delta)
title("frequency response")
xlabel("frequency(HZ)")
legend(["my filter","ideal filter"])
x = 0:1:N-1;
figure(2)
stem(x, h)
title("impulse response")
xlabel("n")