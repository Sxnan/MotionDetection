function output = PFD(img,lamda,gamma)
    [a, b, c] = size(img);
    output = zeros(a,b,c);
    M = zeros(a,b,c);
    for i = 2: c
        diff = abs(img(:,:,i-1) - img(:,:,i));
        M(:,:,i) = diff > lamda;
        tmp = max(output(:,:,i-1)-gamma,0);
        output(:,:,i) = max(255*M(:,:,i),tmp);
    end
    output = output(:,:,2:end)/ 255;
end