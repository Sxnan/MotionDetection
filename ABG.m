function output = ABG(im, threshold, alpha)
    getRowSize = size(im,1);
    getColSize = size(im,2);
    T = size(im,3);
    B = zeros(getRowSize,getColSize,T);
    B(:,:,1)=im(:,:,1);
    output = zeros(getRowSize,getColSize,T-1);
    for t=2:T
        diff = abs(B(:,:,t-1)-im(:,:,t));
        output(:,:,t-1) = diff > threshold;
        B(:,:,t) = alpha*im(:,:,t) + (1-alpha)*B(:,:,t-1);
    end        
    
    
end