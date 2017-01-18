
	

%You need to make sure the image is saved in the 'png' format. Then you can use the 'Alpha' parameter of a png file, which is a matrix that specifies the transparency of each pixel individually. It is essentially a boolean matrix that is 1 if the pixel is transparent, and 0 if not. This can be done easily with a for loop as long as the color that you want to be transparent is always the same value (i.e. 255 for uint8). If it is not always the same value then you could define a threshold, or range of values, where that pixel would be transparent.

%Update :

%First generate the alpha matrix by iterating through the image and (assuming you set white to be transparent) whenever the pixel is white, set the alpha matrix at that pixel as 1.
X=imread('Segelboot.bmp');
% X is your image
[M,N,w] = size(X);
% Assign A as zero
A = zeros(M,N);
% Iterate through X, to assign A


A(X == 255) = 1;

imwrite(X,'your_image.png','Alpha',A);

