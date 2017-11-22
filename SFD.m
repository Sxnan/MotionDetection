function output = SFD(img, lamda)
    [a, b, c] = size(img);
    output = zeros(a,b,c-1);
    for i = 2: c
        diff = abs(img(:,:,i-1) - img(:,:,i));
        output(:,:,i-1) = diff > lamda;
    end
end