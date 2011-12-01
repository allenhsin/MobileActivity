%% clean up
close all; clear all; clc;

%% parameter
readFeatureDataFileName = 'features';
writeNormalizedFeatureDataFileName = 'normFeatures';

%% read raw data from file

fidRead = fopen(readFeatureDataFileName, 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
var         = data{1};
peakFreq    = data{2};
CL          = data{3};
ANE         = data{4};
RD          = data{5};
Energy      = data{6};
SV          = data{7};
GroundTruth = data{8};

fclose(fidRead);

%% open feature file to write to

fidWrite = fopen(writeNormalizedFeatureDataFileName, 'w');


%% normalize feature

var      = var/max(abs(var));
peakFreq = peakFreq/max(abs(peakFreq));
CL       = CL/max(abs(CL));
ANE      = ANE/max(abs(ANE));
RD       = RD/max(abs(RD));
Energy   = Energy/max(abs(Energy));
SV       = SV/max(abs(SV));

%% write to file

for i = 1:length(GroundTruth)
    
    fprintf(fidWrite, '%3.5f,', var(i)        );
    fprintf(fidWrite, '%3.5f,', peakFreq(i)   );
    fprintf(fidWrite, '%3.5f,', CL(i)         );
    fprintf(fidWrite, '%3.5f,', ANE(i)        );
    fprintf(fidWrite, '%3.5f,', RD(i)         );
    fprintf(fidWrite, '%3.5f,', Energy(i)     );
    fprintf(fidWrite, '%3.5f,', SV(i)         );
    fprintf(fidWrite, '%d'    , GroundTruth(i));
    fprintf(fidWrite, '\n');
    
    
end

%% close write file

fclose(fidWrite);