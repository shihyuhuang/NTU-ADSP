clear;
clc;

N = 7;  % filter length
k = (N - 1)/2; 

W_big = 1;
W_small = 0.5;
delta = 0.001;
F = 0:delta:0.5;

Hd_center = 0.24;
W_high = 0.27;
W_low = 0.21;

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

for i = 1:size(F,2)
    if(F(i)<Hd_center)
        Hd_delta(i) = 1;
    else
        Hd_delta(i) = 0;
    end
end


for i = 1:size(F,2)
    if(F(i)<=W_low)
        W_delta(i) = W_big;
    elseif(F(i)>=W_high) 
        W_delta(i) = W_small;
    else % transition band
        W_delta(i) = 0;
    end
end


% step 1
Fm = [0.05, 0.15, 0.3, 0.4, 0.5];

for kk=1:3 %while (E1-E0>delta || E1-E0<0)
    % step 2
    for i = 1:(k+2)
        for j = 1:(k+1)
            A(i,j) = cos(2*pi*(j-1)*Fm(i)); % cos(2*pi*k*F)
        end
    end
    
    
    for i = 1:(k+2)
        if(Fm(i)<=W_low)
            W(i) = W_big;
        elseif(Fm(i)>=W_high) 
            W(i) = W_small;
        else
            W(i) = 0;
        end
    end
    
    
    for i = 1:(k+2)
        A(i,(k+2)) = ((-1)^(i-1))/W(i); % (-1)^(k+1)/W(Fk+1)
    end
    
    
    for i = 1:(k+2)
        if(Fm(i)<Hd_center)
            Hd(i) = 1;
        else
            Hd(i) = 0;
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
    figure(kk)
    plot(F, err)
    
    
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
    disp("orignial P");
    P
    if (size(P,2)==k+4)
        P = P(2:k+3)
    elseif (size(P,2)==k+3)
        if(abs(err(1))>abs(err(k+2)))
            P = P(1:k+2)
        else
            P = P(2:k+3)
        end
    elseif (size(P,2)~=k+2)
        P = P(2:k+3)

    end
    
    % step 5
    E1 = E0;
    E0 = max(abs(err))
    
    Fm = P
end

% step 6
h(k+1) = S(1);
for i = 1:k
    h(k+i+1) = S(i+1)/2;
    h(k-i+1) = S(i+1)/2;
end
h