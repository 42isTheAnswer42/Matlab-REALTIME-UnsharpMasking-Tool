function [input, theRGB,noisedLab ,labSharpened ,theLab,theXYZ, myHeader,linRGB,lChannel ] = getFileAndAShapetoLinRGB( myControl )
%GETFILE Summary of this function goes here
%   Detailed explanation goes here

 
[myTotalFileName, myStatus] = getRawFile4Read( '*.*');
if myStatus==0
    return;
end




[ theRGB, myHeader] = imread( myTotalFileName);

%Auslesen der Image-Dimensionen
[width,height,z1] = size(theRGB);
%imdisplay(theRGB, 'rgbOrig',1.0);  
input.width=width;
input.height=height;
%Umwandlung in lineares RGB
theRGB = im2double (theRGB);
theRGB = - log10(theRGB);
linRGB = 10.^(- theRGB);



%Darstellen der RGB-Datei, der Originammmmmmmmmmmmmmmmmmmmmmmm ml-Datei also 
%imdisplay(linRGB, 'linRGB Original',1.0); 

%Umwandlung in (Agfa-)Lab durch Wandlung in XYZ-Werte und Übertragung
%dieser in den Lab-Raum.
%Agfa-Lab ist Lab, bitte belehren Sie mich eines besseren wenn Sie es
%können.

RGB2Lab = [1/3, 1/3, 1/3; 1/2, -1/2, 0; 1/4, 1/4, -1/2];

RGB2XYZ =[0.5767309,  0.1855540,  0.1881852;
                        0.2973769,  0.6273491 , 0.0752741;
                        0.0270343,  0.0706872 , 0.9911085];
XYZ2RGB = inv(RGB2XYZ);
 
theXYZ = imMatMul( linRGB,RGB2XYZ);
theLab= imXYZ2Lab(theXYZ);

%Erstellen einer Kopie für das gefilterte Bild 
%Rücktransformation in anderen Farbraum zu Testzwecken ob Transformation
%vollzogen

  theTestforRightConversationMatrix= theLab;      

 %Erstellen einer Kopie in die dann der angepasste L-Channel eingefügt
 %wird.
labSharpened = theLab;
  
noisedLab     = theLab;
  
%Separieren des Luminance-Channels. Dieser ist definitiv in Channel 1 zu
%finden, da in Channel 2 und 3 negative sowie positive Werte zu finden
%sind. Dies ist logisch wenn man bedenkt, dass sich der Farbraum von -a bis +a sowie -b bis +b erstrecken kann. Das Maximimum in Channel 1 beträgt ebenso 100, was für den
%LAB-CHannel in CHannel 1 spricht.

lChannel=theLab(:,:,1);
%    imdisplay(theLab(:,:,1), 'the l channel ',2.2); 
input.theRGB=theRGB;
input.theXYZ=theXYZ;
input.width=width;
input.height=height;
input.theLab=theLab;
'RDPhotoreceptorModel';

end 

