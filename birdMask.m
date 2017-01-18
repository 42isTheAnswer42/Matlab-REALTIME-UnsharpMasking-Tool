
clearvars;
%Create a logical array BirdMask that is true for pixels that you want to continue to show, and false for background pixels. Display the sky image first. Then
clear all;
%Initialisierung Steuerdaten/ Erstellen der Trafo-Matirzen RGB2XYZ:
myControl = buildControlDataIE();

X=imread('w.jpeg');
% X is your image
[M,N,w] = size(X);
sigma=2^.5




theXYZ = imMatMul( X, myControl.RGB2XYZ);
theLab= imXYZ2Lab(theXYZ);


lChannel=theLab(:,:,1);


%Paramter sigma_local^2 / (sigma_local^2 + sigma_noise^2) liefert keine
%zufriedenstellenden Ergebnisse, deshalb Nutzung eines Canny-Filters,
%welcher einem Gradienten-Operator mit Schwellwert
BW = edge(lChannel,'Canny',[0.1,0.15], sigma);

imshow (BW);
%image(X, 'AlphaData', BW);
%imshow(C);%
BW=double(BW);

imwrite(X, 'Alphabild22.png', 'png', 'Alpha',BW) 
%imwrite(X,'Alphabild.png','Bitdepth',16);