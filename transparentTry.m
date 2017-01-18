clearvars;
clear all;
close all;
%Initialisierung Steuerdaten/ Erstellen der Trafo-Matirzen RGB2XYZ:
myControl = buildControlDataIE();


% 
%Bild einlesen
theRGB = imread ('w.jpeg');
 imdisplay(theRGB , 'Kantendetektor Canny ',1.0); 
 
 %Auslesen der Image-Dimensionen
[height,width,z1] = size(theRGB);
%Kopie mit Alpha-Channel anlegen
theTransparent = repmat(theRGB,[1,1,4]);
theTransparent(:,:,4) = theTransparent(:,:,4)==0;
theTransparent = uint8(round(theTransparent*255));

tob = Tiff('theTransparent.tif','w');

%# you need to set Photometric before Compression
tob.setTag('Photometric',Tiff.Photometric.RGB)
tob.setTag('Compression',Tiff.Compression.None)

%# tell the program that channel 4 is alpha
tob.setTag('ExtraSamples',Tiff.ExtraSamples.AssociatedAlpha)

%# set additional tags (you may want to use the structure
%# version of this for convenience)
tob.setTag('ImageLength',size(theRGB,1));
tob.setTag('ImageWidth',size(theRGB,2));
tob.setTag('BitsPerSample',8);
tob.setTag('RowsPerStrip',16);
tob.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
tob.setTag('Software','MATLAB')
tob.setTag('SamplesPerPixel',4);
%tob.write(theTransparent);

%imshow (theTransparent);
%imwrite (theTransparent,'theTransparent.tif');


%Auslesen der Image-Dimensionen
[width,height,z1] = size(theRGB);




theXYZ = imMatMul( theRGB, myControl.RGB2XYZ);
theLab= imXYZ2Lab(theXYZ);


lChannel=theLab(:,:,1);



%imdisplay(theRGB, 'rgbOrig',1.0);  
thresholdSobel=0.3;




BW = edge(lChannel,'Sobel',thresholdSobel,'both');
%imshow(BW);
% Nun muss das BW Bild abgegangen werden, an den Stellen mit einer
% notierten 1 befindet sich eine Kante. Nun muss diese Kante und nur diese
% Kante verschärft werden. Also nimmt man das Originalbild und schreibt an
% Stellen an den man eine Kante detektiert hatte im BW bild, den Wert des geschärften L-Channels
% Und schreibt diesen in das LAB Bild um so ein geschärfte Kanten zu erhalten.


%Alternativ: Anlegen eines Gradientenoperators, dieser gibt Binär-Bild zurück, eine 1 steht für
%Kantendetektion
thresholdCanny=0.05;
sigma=2^.5


%Paramter sigma_local^2 / (sigma_local^2 + sigma_noise^2) liefert keine
%zufriedenstellenden Ergebnisse, deshalb Nutzung eines Canny-Filters,
%welcher einem Gradienten-Operator mit Schwellwert
BW = edge(lChannel,'Canny',[0.1,0.15], sigma);

   % BW = ~imfill(~BW,'holes'); 
imdisplay(BW, ' imfill ',1.0); 
 
 theRGB2 = imread ('w.jpeg');
 imdisplay(theRGB2, ' Ersetztes Bild 1',1.0);
 theTransparent=theRGB2;
 
 %Erstellen eines LowPassFilters um Kanten zu glätten
 h = fspecial('gaussian', [3 3], 100.1);
        HSIZE =[3 3];
        antialias=fspecial('average', HSIZE);
%Anwenden des Filters auf Luminance-Channel
lChannelFilter = imfilter(theRGB2(width, height,1), h);

 
 
 % Scan from up
 
   for H=1:height
       
 for W=1:width
  

   
        if (BW(W,H)==0 )
            theRGB2(W,H,1) =0;
             theRGB2(W,H,2)=0;
              theRGB2(W,H,3)=0;
           
        else  W=W+1;H=1;
        theRGB2(width,height,1) = imfilter(theRGB2( width,height,1), h);
           theRGB2(width,height,3) = imfilter(theRGB2(width,height,3), h);;  
           theRGB2(width,height,2) = imfilter(theRGB2(width,height,2), h);; 
           break;
            
    end
end
   end


   
 
   %Scan from down
    for H=1:height
       
 for W=1:width
  
       widthtem= width+1;
   height_temp= height+1;
        if (BW( widthtem-W, height_temp-H)==0 )
            theRGB2( widthtem-W, height_temp-H,1) =0;
             theRGB2( widthtem-W, height_temp-H,2)=0;
              theRGB2( widthtem-W, height_temp-H,3)=0;
           
        else  W=W+1;H=1;
        theRGB2(width, height,1) = imfilter(theRGB2(width, height,1), h);
           theRGB2(width, height,3) = imfilter(theRGB2(width, height,3), h);;  
           theRGB2(width, height,2)= imfilter(theRGB2(width, height,2), h);; 
            break;
    end
end
    end
    
  
   % Reget height and width, was worng setted above but code works if values are reseted. Just leave it as it is 
    [height,width,z1] = size(theRGB);
    
    
     %Erstellen eines LowPassFilters um Kanten zu glätten
 h = fspecial('gaussian', [30 30], 10000.1);
        HSIZE =[300 300];
        antialias=fspecial('average', HSIZE);
%Anwenden des Filters auf Luminance-Channel
lChannelFilter = imfilter(theRGB2(height, width,1), h);

 
  
    
   %Scan from right
    for H=1:height
       
 for W=1:width
  
       widthtem= width+1;
   height_temp= height+1;
        if (BW( height_temp-H,widthtem-W )==0 )
            theRGB2(  height_temp-H,widthtem-W,1) =0;
             theRGB2( height_temp-H,widthtem-W, 2)=0;
              theRGB2( height_temp-H,widthtem-W, 3)=0;
           
        else  W=W+1;H=1;
            theRGB2(height, width,1) =imfilter( theRGB2(  height_temp-H,widthtem-W,1), h);
           theRGB2(height, width,2) =imfilter( theRGB2(  height_temp-H,widthtem-W,2),h);
           theRGB2(height, width,2) =imfilter( theRGB2(  height_temp-H,widthtem-W,3),h);
            break;
        
            
    end
end
    end
  
 
    
      %Scan from left
 for H=1:height
       
 for W=1:width
  
           if (BW( H,W )==0 )
            theRGB2(  H,W) =0;
             theRGB2(H,W)=0;
              theRGB2(H,W)=0;
           
        else  W=1;H=H+1;
              theRGB2(H, W,3) = imfilter(theRGB2(H,W,3), h);;  
           theRGB2(H, W,2) = imfilter(theRGB2(H, W,2), h);;
             theRGB2(H, W,2) = imfilter(theRGB2(H, W,2), h);;
            break;
        
            
    end
end
    end
  

imdisplay(theRGB2, ' Ersetztes Bild  2',1.0);
 % imshow( theRGB);
 
 
 
