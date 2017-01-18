% This image is included with MATLAB
clearvars;
clear all;
D = imread('w.jpeg');

image(D); title('RGB image without alpha layer.');

h = size(D,1);

w = size(D,2);

% Create a transparency mask

T = 128*ones(h,w,'uint8');

% The dimensions of our image are h x w x 3 (remember, it's RGB). If

% we wish to add an alpha component, we need to give the image data a 4th

% component.

rgbaData = cat(3,D,T);

% Let's create our new image.

t = Tiff('alpha2.tif','w');

% The photometric interpretation remains RGB, even though we will be

% adding an extra sample.

t.setTag('Photometric',Tiff.Photometric.RGB);

% These three tags define the dimensions of the image in the file.

t.setTag('ImageWidth',w);

t.setTag('ImageLength',h);

t.setTag('BitsPerSample',8);

t.setTag('SamplesPerPixel',4);

% We will make the image consist of 64x64 tiles.

t.setTag('TileWidth',64);

t.setTag('TileLength',64);

t.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);

% A photometric interpretation of RGB means that the TIFF file is expecting

% three components. We have to tell it that there will really be four

% components (the alpha layer is the 4th).=

t.setTag('ExtraSamples',Tiff.ExtraSamples.UnassociatedAlpha);

t.write(rgbaData);

t.close();