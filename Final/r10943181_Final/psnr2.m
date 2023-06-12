function [PSNR, MSE] = psnr2(X, Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 計算?值信噪比PSNR
% 將RGB轉成YCbCr格式進行計算
% 如果直接計算會比轉後計算值要小2dB左右（當然是個別測試）
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if size(X,3)~=1   %判斷圖像時不是彩色圖，如果是，結果?3，否則?1
   org=rgb2ycbcr(X);
   test=rgb2ycbcr(Y);
   Y1=org(:,:,1);
   Y2=test(:,:,1);
   Y1=double(Y1);  %計算平方時候需要轉成double類型，否則uchar類型會丟失數據
   Y2=double(Y2);
 else              %灰度圖像，不用轉換
     Y1=double(X);
     Y2=double(Y);
 end
 
if nargin<2    
   D = Y1;
else
  if any(size(Y1)~=size(Y2))
    error('The input size is not equal to each other!');
  end
 D = Y1 - Y2; 
end
MSE = sum(D(:).*D(:)) / numel(Y1); 
PSNR = 10*log10(255^2 / MSE);
end

