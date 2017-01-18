function imdisplay( theImage, theWindowTitle, theGamma)
% usage:                    imdisplay( theImage, theWindowTitle, theGamma);
% optional:                 theWindowTitle, theGamma
% Beschreibung:             Bildanzeige mit Gamma-Anpassung
% theImage:                 Eingangsbild
% theWindowTitle:           Fensterüberschrift (String)
% theGamma:                 Gamma-Wert
% Beispiel:                 imdisplay( myImage, 'Mein Bild:', 2.2);

% Variable Argumente
if( nargin == 1)
	myGamma = 1;
	myWindowTitle = '';
end
if( nargin == 2)
    if( isnumeric( theWindowTitle))
        myGamma = theWindowTitle;
        myWindowTitle = '';
    else
        myGamma = 1;
        myWindowTitle = theWindowTitle;
    end
end
if( nargin == 3)
    if( ischar( theWindowTitle) && isnumeric( theGamma))
        myGamma = theGamma;
        myWindowTitle = theWindowTitle;
    elseif( ischar( theGamma) && isnumeric( theWindowTitle)) 
        myGamma = theWindowTitle;
        myWindowTitle = theGamma;
    else
        disp( 'Bad parameters (imdisplay()). Using defaults.');
        myGamma = 1;
        myWindowTitle = '';
    end
end
        

% Fenster öffnen
myScreenSize = get(0,'ScreenSize');

if( isempty( myWindowTitle))
    figure('Position',[1 1 myScreenSize(3) myScreenSize(4)]);
else
    % WindowTitle ist da
    figure('Position',[1 1 myScreenSize(3) myScreenSize(4)], 'Name', myWindowTitle, 'NumberTitle', 'off');
end

iptsetpref( 'ImshowBorder', 'tight');

% Gammakorrektur und Anzeige
if( myGamma ~= 1)
    myGammaLut = uint8( 255 * ((0:2^16-1) / (2^16-1)).^(1/myGamma));
    imshow( myGammaLut( im2uint16( theImage)+1));
else
    imshow( theImage);
end

truesize;

end