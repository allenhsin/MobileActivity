%% clean up
close all; clear all; clc;

%% parameter
readFeatureDataFileName = 'normFeatures';
writePCAFileName        = 'normFeaturesPCA';

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

%% PCA

[COEFF,SCORE] = princomp([SV RD ANE CL Energy var peakFreq]);

%% write to output file

fidWrite = fopen(writePCAFileName, 'w');
for i = 1:length(GroundTruth)
    fprintf(fidWrite, '%3.5f,', SCORE(i,1)    );
    fprintf(fidWrite, '%3.5f,', SCORE(i,2)    );
    fprintf(fidWrite, '%3.5f,', SCORE(i,3)    );
    fprintf(fidWrite, '%3.5f,', SCORE(i,4)    );
    fprintf(fidWrite, '%3.5f,', SCORE(i,5)    );
    fprintf(fidWrite, '%3.5f,', SCORE(i,6)    );
    fprintf(fidWrite, '%3.5f,', SCORE(i,7)    );
    fprintf(fidWrite, '%d'    , GroundTruth(i));
    fprintf(fidWrite, '\n');
end
fclose(fidWrite);



