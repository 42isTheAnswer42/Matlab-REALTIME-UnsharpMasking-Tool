clearvars;
clear all;
close all;
%Initialisierung Steuerdaten/ Erstellen der Trafo-Matirzen RGB2XYZ:
myControl = buildControlDataIE();
%Auslesen der Image-Dimensionen

 
 theRGB2 = imread ('w.jpeg');
 theOriginal=imread ('w.jpeg');
 imdisplay(theRGB2, ' Original',1.0);
 theTransparent=theRGB2;
 theOrig=imread ('w.jpeg');
 [width,height,z1] = size(theRGB2);
 
 
 %Erstellen eines LowPassFilters um Kanten zu glätten
 h = fspecial('gaussian', [3 3], 100.1);
        HSIZE =[3 3];
        antialias=fspecial('average', HSIZE);

        
        
%Anwenden des Filters auf Luminance-Channel

theXYZ = imMatMul( theRGB2, myControl.RGB2XYZ);
theLab= imXYZ2Lab(theXYZ);
lChannel=theLab(:,:,1);
theFilter = imfilter(lChannel, h);
theLab(:,:,1)=theFilter(:,:);
theXYZ2 = imLab2XYZ(theLab);
theLinRGBSHARP= imMatMul( theXYZ2, myControl.XYZ2RGB); 
imdisplay(theLinRGBSHARP, 'THE FILTER',1.0);

thresholdCanny=0.05;
sigma=2^.5


%Paramter sigma_local^2 / (sigma_local^2 + sigma_noise^2) liefert keine
%zufriedenstellenden Ergebnisse, deshalb Nutzung eines Canny-Filters,
%welcher einem Gradienten-Operator mit Schwellwert
BW = edge(lChannel,'Canny',[0.1,0.15], sigma);

BW2 = bwmorph(BW,'diag');
BW3 = bwmorph(BW2,'close');
BW3 = bwmorph(BW3,'thin');
BW = bwmorph(BW3,'diag'); 
theMask=ones(width,height);

 
 
 % Scan from up
 
   for H=1:height
       
 for W=1:width
  

   
        if (BW(W,H)==0 )
            theRGB2(W,H,1) =0;
             theRGB2(W,H,2)=0;
              theRGB2(W,H,3)=0;
           theMask(W,H)=0 ;
        else  W=W+1;H=1;
        theRGB2(W,H,1) = imfilter(theRGB2( W,H,1), h);
           theRGB2(W,H,3) = imfilter(theRGB2(W,H,3), h);;  
           theRGB2(W,H,2) = imfilter(theRGB2(W,H,2), h);; 
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
               theMask( widthtem-W, height_temp-H)=0 ; 
        else  W=W+1;H=1;
        theRGB2(width, height,1) = imfilter(theRGB2( widthtem-W, height_temp-H,1), h);
           theRGB2(width, height,3) = imfilter(theRGB2( widthtem-W, height_temp-H,2), h);;  
           theRGB2(width, height,2)= imfilter(theRGB2( widthtem-W, height_temp-H,3), h);; 
            break;
    end
end
    end
    
  
   % Reset height and width, was worng setted above but code works if values are reseted. Just leave it as it is 
    [height,width,z1] = size(theRGB2);
    

    

  
    
   %Scan from right
    for H=1:height
       
 for W=1:width
  
       widthtem= width+1;
   height_temp= height+1;
        if (BW( height_temp-H,widthtem-W )==0 )
            theRGB2(  height_temp-H,widthtem-W,1) =0;
             theRGB2( height_temp-H,widthtem-W, 2)=0;
              theRGB2( height_temp-H,widthtem-W, 3)=0;
             theMask(  height_temp-H,widthtem-W)=0; 
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
           theMask(H,W)=0;
        else  W=1;H=H+1;
              theRGB2(H, W,3) = imfilter(theRGB2(H,W,3), h);;  
           theRGB2(H, W,2) = imfilter(theRGB2(H, W,2), h);;
             theRGB2(H, W,2) = imfilter(theRGB2(H, W,2), h);;
            break;
        
            
    end
end
 end
 
 
 BW2 = bwmorph(theMask,'diag');
BW3 = bwmorph(BW2,'close');
BW4 = bwmorph(BW3,'thin');
BW5 = bwmorph(BW4,'skel');
BW6 = bwmorph(BW5,'spur');
theMask = bwmorph(BW6,'clean');
 

        h = fspecial('gaussian', [100 100], 100.1);
        HSIZE =[600 600];
        antialias=fspecial('average', HSIZE);

theMask2 = bwmorph(theMask,'thin');

theMask2=double(theMask2);


%theOriginal(:,:,1) = roifilt2(H, theOriginal(:,:,1), theMask) ;
%theOriginal(:,:,2) = roifilt2(H, theOriginal(:,:,2), theMask) ;
%theOriginal(:,:,3) = roifilt2(H, theOriginal(:,:,3), theMask) ;
theMask2= imfilter(theMask2,H);
imdisplay (theMask2,'theMask2',1.0);

imwrite(theOrig, 'Alphabild22.png', 'png', 'Alpha',theMask2) 
%imwrite(X,'Alphabild.png','Bitdepth',16);
imdisplay(theRGB2, ' Ersetztes Bild , schwarz = transpranet 2',1.0);
 % imshow( theRGB);
 