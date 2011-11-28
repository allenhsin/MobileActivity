%% clean up
close all; clear all; clc;

%% parameter
readFeatureDataFileName = 'normFeatures';

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

%% plot

figure(1);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(CL(i), RD(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(CL(i), RD(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(CL(i), RD(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(CL(i), RD(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(CL(i), RD(i), '.k');
    end
end
xlabel('Curve Length');
ylabel('Rhythmic Discharge');

figure(2);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(ANE(i), Energy(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(ANE(i), Energy(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(ANE(i), Energy(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(ANE(i), Energy(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(ANE(i), Energy(i), '.k');
    end
end
xlabel('Non-linear Energy');
ylabel('Total Energy');

figure(3);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(SV(i), RD(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(SV(i), RD(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(SV(i), RD(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(SV(i), RD(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(SV(i), RD(i), '.k');
    end
end
xlabel('Strength Variation');
ylabel('Rhythmic Discharge');


figure(4);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(var(i), peakFreq(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(var(i), peakFreq(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(var(i), peakFreq(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(var(i), peakFreq(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(var(i), peakFreq(i), '.k');
    end
end
xlabel('Variance');
ylabel('Peak Frequency');



