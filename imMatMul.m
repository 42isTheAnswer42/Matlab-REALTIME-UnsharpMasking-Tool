function theOutImage = imMatMul( theInImage, theInMatrix)
%Usage: theOutImage = imMatMul( theInImage, theInMatrix);
%Description: computes OutPixVec = theInMatrix * InPixVec;

[so(1) so(2) thirdD] = size( theInImage);
theOutImage = reshape( im2double( reshape( theInImage, so(1)*so(2), thirdD)) * theInMatrix', ...
                       so(1), so(2), thirdD);

