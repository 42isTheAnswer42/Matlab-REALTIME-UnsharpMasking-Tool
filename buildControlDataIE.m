function theControl = buildControlData()

%Farb-/Dichtekorrekturen
theControl.WB.DeltaD = [-0.5;-0.5;-0.5];

%Lab-Trafo
theControl.RGB2Lab = [1/3, 1/3, 1/3; 1/2, -1/2, 0; 1/4, 1/4, -1/2];

theControl.RGB2XYZ =[0.5767309,  0.1855540,  0.1881852;
                        0.2973769,  0.6273491 , 0.0752741;
                        0.0270343,  0.0706872 , 0.9911085];
theControl.XYZ2RGB = inv( theControl.RGB2XYZ);

%Tone Mapping
theControl.TM.Method = 'RDPhotoreceptorModel';
theControl.TM.Params.f = 10;

%Gradation/Offsetkorrektur
theControl.GradationOffset.Offset = 0.7;
theControl.GradationOffset.RGBGradation = 1.0;



%Colormanagement
myMatrix5D = [ 6347,-479,-972; -8297,15954,2480; -1968,2131,7649]/10000;
myMatrix5DInv = inv( [ 6347,-479,-972; -8297,15954,2480; -1968,2131,7649]/10000);


theControl.CMOut.IProf = 'ICCProfiles/D50_XYZ.icc';%'*XYZ';
theControl.CMOut.OProf = 'ICCProfiles/AdobeRGB1998.icc';
theControl.CMOut.OProfSRGB = 'ICCProfiles/sRGB.icm'; %selbst hinzugefügt?!
theControl.CMOut.MonitorProf = 'ICCProfiles/ASUS_17420019.icm';


end %buildControlData