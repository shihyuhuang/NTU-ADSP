function result = bifilter(Image,w,sigma_d,sigma_r)

% ref: bfilter2(A,w,sigma) from matlab mathworks funciton

[X,Y] = meshgrid(-w:w,-w:w); %�Z���x�}
Gd = exp(-(X.^2+Y.^2)/(2*sigma_d^2)); %�Ŷ��]�l
[hm,wn] = size(Image); 
result=zeros(hm,wn); 
for i=1:hm    
    for j=1:wn  
        temp=Image(max(i-w,1):min(i+w,hm),max(j-w,1):min(j+w,wn));
        Gr = exp(-(temp-Image(i,j)).^2/(2*sigma_r^2)); %�G�צ�m�]�l
        W = Gr.*Gd((max(i-w,1):min(i+w,hm))-i+w+1,(max(j-w,1):min(j+w,wn))-j+w+1);   %���n�o�������o�i�v��       
        result(i,j)=sum(W(:).*temp(:))/sum(W(:));            
    end
end
end

