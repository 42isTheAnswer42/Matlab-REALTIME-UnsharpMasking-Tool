% Klausur DBT 
% Sander Schmidt
% Luxemburger Str. 35
% 50674 Köln
clearvars;
clear all;

%Sehr geehrter Herr Professor Fischer,
%sehr geehrter Herr Pofessor Kunz,
%
%hiermit erhalten Sie meine DBT-Klausur-Aufgabe.
%So gut es ging habe ich Ihre Bibliothek genutzt, keine Funktion ist hier
%selbst geschrieben. Der Algorithmus läuft nach folgendem Schema ab:
%Zunächst wandeln wir das Bild von RGb zu Lab, da wir die Bildverarbeitung
%auf einem helligkeitsinvarianten Bild vollzie.hen sollen.
%Anschliessend arbeite ich mit dem Luminance-Channel des Image. Diesen
%filtere ich wie verlangt mit einem BinomialFilter. Dadurch erhalte ich ich
%einen Tiefpass-gefilterten Luminance-Channel, welchen ich vom Original
%abziehe. Ein Tiefpass-gefilterter Luminance-Channel, bedeudet, dass nur Weiche Übergänge übrig bleiben,
%alle Hochfrequenten Anteile wie Kanten fallen weg. Anschliessend ziehe ich
%diesen "Kantenlosen" und niederfrequente Channel vom Original ab um einen
%geschärften Channel, im Sinne eines hochpassgefilterten Channel zu erhalten.
%Diesen addiere ich nun zum Original-Luminance-Channel hinzu. Gewünscht war
%von Ihnen eine Addition, in Abhängigkeit der Parameter SHP Edge und SHP
%Area. Beides ist in dieser Matlab-Datei umgesetzt.
%Doch bevor ich die Luminance-Werte anpasse, muss erst festgestellt werden,
%wo sich die Kanten befinden welche geschärft werden sollen. Dazu benutze
%ich die von Ihnen gewünschten Sobel und Gradienten-Operator(welcher in Matlab nur Canny genannt wird)
% um die Kanten eines Bildes zu finden. Beide Algorithmen liefern ein
% Schwarz-Weiss Bild, welches im Code nur BW genannt wird. Diese BW-Bilder
% haben als pixelwert immer nur 1 oder 0, bei 1 wurde eine Detekton
% festgestellt, bei 0 ist diese nicht passiert. In der Kantendetektion
% heisst das, dass wir beim Wqrt 1 eine Kante haben und beim Wert 0 keine
% Kante. Bei der Korndetektion bedeudet eine 0 eine Fläche und bei 1 keine
% Fläche, also Kante.
% Um Kante und Fläche parametrisiert zu verstärken, müssen die BW-Bilder
% mit einer Schleife abgelaufen werden. Enthält der Pixelwert den Wert 1,
% so wissen wir nun , dass hier das Kriterium einer Kante erfüllt wurde. Nun können
% wir die X-Y- Position des BW-Pixels auf unser Farbiges LAB-Bild
% übertragen, und wissen nun wo darin die Kanten liegen, da die Position von
% Kanten im Lab_Bild mit der Position der Pixel mit einem Wert von 1 im
% BW/Schwarz-Weiss Bild entsprechen. Nun werden 2 Schleifen abgelaufen,
% um die Werte des Korn und Kante parametrisiert zu verstärken.
% Desweiteren habe ich mit der Funktion imnoise das von Ihnen geforderte
% Rauschen hinzugefügt. Zu beachten war dabei, den Luminance-Channel auf
% Werte zwischen 0 und 1 zu normalisieren, also durch den grösstmöglichen
% Luminance-Level (welcher 100 ist) zu dividieren um so einen
% Luminance-Channel-Wert zwischen 0 und 1 zu erhalten.
% Ich möchte kurz noch eine persönliche Erfahrung mit IHnen teilen: Sollten
% Sie zeitgleich Maple und matlab installiert haben, kann es zu
% unnachvollziehbaren Problemen kommen. Dies gipfelte bei mir darin, dass
% ich die ersten 3 Tage(!!!!!!) der Projektwoche keine Programmierung
% volziehen konnte, da ich bereits bei der Funktion imdisplay einen Absturz
% hatte. In meinem Archiv befindet sich dazu der Error-Log. Sollten SIe
% ebenfalls die gleichen Problemem haben, empfehle ich Ihnen eine
% Deinstallation des Maple Addons im Matlab Ordner, das hat bei mir
% geholfen.
% Falls Sie noch Fragen haben sollten, zögern Sie nicht nachzufragen. 
% LG Sander Schmidt

% Sander Schmidt



%Initialisierung Steuerdaten/ Erstellen der Trafo-Matirzen RGB2XYZ:
myControl = buildControlDataIE();

% 

%Bild einlesen
theRGB = imread ('Bilder/datscha.bmp');

%Auslesen der Image-Dimensionen
[width,height,z1] = size(theRGB);
%imdisplay(theRGB, 'rgbOrig',1.0);  

%Umwandlung in lineares RGB
theRGB = im2double (theRGB);
linRGB = - log10(theRGB);

%Darstellen der RGB-Datei, der Original-Datei also 
imdisplay(linRGB, 'linRGB Original',1.0); 

%Umwandlung in (Agfa-)Lab durch Wandlung in XYZ-Werte und Übertragung
%dieser in den Lab-Raum.


theXYZ = imMatMul( linRGB, myControl.RGB2XYZ);
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

%Auftragen eines weissen Rauschens auf LChannel, von daher normieren auf
%Werte zwiscehn 0 und 1 ( Teilen durch 100)
lChannelnoiesd = imnoise(lChannel./100,'gaussian',0,0.0001); 

%Rücktransformation auf Ursprungszustand durch multiplizieren mit 100
lChannelnoiesd=lChannelnoiesd.*100;

% Schreiben des vernoisten Channel in das Bild noisedLab
noisedLab(:,:,1)=lChannelnoiesd(:,:);

%Anzeigen des verrauschten Bildes durch Rücktransformation zu LAB und RGB
 theXYZ4 = imLab2XYZ(noisedLab);
     theRGBNOIsed= imMatMul( theXYZ4, myControl.XYZ2RGB); 
imdisplay(theRGBNOIsed, 'THE RGB NOISED',1.0); 


%Schreiben des vernoiseten Channels in Ursprungsschannel
lChannel=lChannelnoiesd;


%Filterung des Rauschens durch WienerFilterung, adaptive Anpassung durch
%Algorithmus, vgl. Dokumentation


  
%Erstellen eines Binomialfilters 7. Ordnung  
    h = [1/2 1/2];
binomialCoeff = conv(h,h);
for n = 1:7
    binomialCoeff = conv(binomialCoeff,h);
end


%Filtern des L-Channels und schreiben in binomiaLfiltered
binomiaLfiltered = filter(binomialCoeff, 1, lChannelnoiesd);
labSharpened(:,:,1)=binomiaLfiltered(:,:);
theXYZ2 = imLab2XYZ(labSharpened);
     theLinRGBSHARP= imMatMul( theXYZ2, myControl.XYZ2RGB); 
      


         imdisplay(theLinRGBSHARP, 'THE FILTER',1.0);   


lChannelFilter=binomiaLfiltered;

%Erstellen eines geschärften LChannels durch Addition hoher Frequenzen
%Schritt 1: Erstellen der Maske
lChannelSharp=lChannel-binomiaLfiltered;

%Schritt 2: Addition des geschärften Kanten-Bereichs zum Original L-Channel in Abhängigkeit
% von SHPEdge, 
% Bei SHPEdge =1 keine Veränderung, wie verlangt
SHPEdge=2.3;
lChannelNewKante=lChannelSharp*(SHPEdge-1)+lChannel;

%Schritt 3: Addition des geschärften Korn-Bereichs zum Original L-Channel in Abhängigkeit
% von SHPArea, 
% Bei SHPArea =1 keine Veränderung, wie verlangt

SHPArea=1;
lChannelNewKorn=lChannelSharp*(SHPArea-1)+lChannel;


%Anlegen eines SobelFilters, dieser gibt BW-Bild zurück, eine 1 steht für
%Kantendetektion
thresholdSobel=10;
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
 imdisplay(BW, 'Kantendetektor Canny ',1.0); 


%Ablaufen des BW-Bildes, bei Kantendetektion wird im Original-LAB-Bild der
%alte Wert des L-Channels durch den Wert des geschärtfen Channels ersetzt
% So ist sicher, dass nur die Kante ersetzt wird.

for W=1:width
    for H=1:height
        if (BW(W,H)==1 )
            
            
             labSharpened(W,H,1) =lChannelNewKante(W,H);
        
    end
end
end



%Ablaufen des BW-Bildes, bei Korndetektion, also bei Value=0,
%wird im Original-LAB-Bild der
%alte Wert des L-Channels durch den Wert des geschärtfen Channels ersetzt
% So ist sicher, dass nur das Korn ersetzt wird.

for W=1:width
    for H=1:height
        if (BW(W,H)==0 )
            
             labSharpened(W,H,1) =lChannelNewKorn(W,H);
        
    end
end
end



%Kopie des L-Channels in die zuvor mit den Original-Labwerten anglegte
%Kopie

        
      


        % Rücktransformation von Lab zu XYZ und RGB
      theXYZ = imLab2XYZ(theTestforRightConversationMatrix);
      theLinRGB= imMatMul( theXYZ, myControl.XYZ2RGB); 
      
      theXYZ2 = imLab2XYZ(labSharpened);
     theLinRGBSHARP= imMatMul( theXYZ2, myControl.XYZ2RGB); 
      


         imdisplay(theLinRGBSHARP, 'THELINRGBSHARP',1.0);   
              imdisplay(theLinRGB, 'THE RGB BACKTRANSFOMRED WITHOUT CHANGES',1.0);   
        