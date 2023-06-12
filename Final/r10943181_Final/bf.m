function result = bf(I,w,sigma_d,sigma_r,xx,yy)

% ref: bfilter2(A,w,sigma) from matlab mathworks funciton

R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
ImageR = im2double(R);
ImageG = im2double(G);
ImageB = im2double(B);
[X,Y] = meshgrid(-w:w,-w:w); 
Gs = exp(-(X.^2+Y.^2)/(2*sigma_d^2)); 
[hm,wn] = size(ImageR); 
result=zeros(hm,wn); 
for i=1:hm    
    for j=1:wn  
        temp=ImageR(max(i-w,1):min(i+w,hm),max(j-w,1):min(j+w,wn));
        Gr = exp(-(temp-ImageR(i,j)).^2/(2*sigma_r^2));       
        W = Gr.*Gs((max(i-w,1):min(i+w,hm))-i+w+1,(max(j-w,1):min(j+w,wn))-j+w+1); 
        if(i==yy)
            if(j==xx)
                W1=W;
            end
        end
       result(i,j)=sum(W(:).*temp(:))/sum(W(:));            
    end
end 

[X,Y] = meshgrid(-w:w,-w:w); 
Gs = exp(-(X.^2+Y.^2)/(2*sigma_d^2)); 
[hm,wn] = size(ImageG); 
result=zeros(hm,wn); 
for i=1:hm    
    for j=1:wn  
        temp=ImageG(max(i-w,1):min(i+w,hm),max(j-w,1):min(j+w,wn));
        Gr = exp(-(temp-ImageG(i,j)).^2/(2*sigma_r^2));       
        W = Gr.*Gs((max(i-w,1):min(i+w,hm))-i+w+1,(max(j-w,1):min(j+w,wn))-j+w+1); 
        if(i==yy)
            if(j==xx)
                W2=W;
            end
        end
       result(i,j)=sum(W(:).*temp(:))/sum(W(:));            
    end
end 

[X,Y] = meshgrid(-w:w,-w:w); 
Gs = exp(-(X.^2+Y.^2)/(2*sigma_d^2)); 
[hm,wn] = size(ImageB); 
result=zeros(hm,wn); 
for i=1:hm    
    for j=1:wn  
        temp=ImageB(max(i-w,1):min(i+w,hm),max(j-w,1):min(j+w,wn));
        Gr = exp(-(temp-ImageB(i,j)).^2/(2*sigma_r^2));       
        W = Gr.*Gs((max(i-w,1):min(i+w,hm))-i+w+1,(max(j-w,1):min(j+w,wn))-j+w+1); 
        if(i==yy)
            if(j==xx)
                W3=W;
            end
        end
       result(i,j)=sum(W(:).*temp(:))/sum(W(:));            
    end
end 

Wt=W1+W2+W3;
surf(X,Y,Wt);
title(['Spectrum of bifilter with sigma_d =', num2str(sigma_d), ' sigma_r =', num2str(sigma_r)]);

end

