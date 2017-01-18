img = imread('Segelboot.bmp');   % an rgb image
bw = sum(img,3) > 400;        % a binary image to overlay

mask = cast(bw, class(img));  % ensure the types are compatible
img_masked = img .* repmat(mask, [1 1 3]);  % apply the mask



imshow(img_masked);
