%% clean up
close all; clear all; clc;

%% parameter
readFeatureDataFileName = 'features';

TWL             = 5; % sec
NUM_OF_ACTIVITY = 5;

%% read raw data from file

fidRead = fopen(readFeatureDataFileName, 'r');

data = textscan(fidRead, '%f %f %f %f %d', 'delimiter', ',');
var         = data{1};
peakFreq    = data{2};
CL          = data{3};
ANE         = data{4};
GroundTruth = data{5};

fclose(fidRead);

%% plot

figure(1);
hold on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        %plot(CL(i), ANE(i), '.r');
    elseif  GroundTruth(i) == 1
        %plot(CL(i), ANE(i), '.b');
    elseif  GroundTruth(i) == 2
        %plot(CL(i), ANE(i), '.g');
    elseif  GroundTruth(i) == 3
        %plot(CL(i), ANE(i), '.k');
    elseif  GroundTruth(i) == 4
        %plot(CL(i), ANE(i), '.m');
    end
end