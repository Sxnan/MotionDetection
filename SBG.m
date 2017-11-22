function output = SBG(im, threshold)
    getRowSize = size(im,1);
    getColSize = size(im,2);
    T = size(im,3);
    output = zeros(getRowSize,getColSize,T-1);
    for t=2:T
        diff = abs(im(:,:,1)-im(:,:,t));
        output(:,:,t-1) = diff > threshold;
    end        
end