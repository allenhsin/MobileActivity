%% clean up
close all; clear all; clc;

%% parameter
readFeatureDataFileName = 'normFeatures';
readPCAFileName         = 'normFeaturesPCA';

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

fidRead = fopen(readPCAFileName, 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
PCA1        = data{1};
PCA2        = data{2};
PCA3        = data{3};
PCA4        = data{4};
PCA5        = data{5};
PCA6        = data{6};
PCA7        = data{7};
%GroundTruth = data{8};

fclose(fidRead);

%% plot

fig1 = figure(1);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(CL(i), RD(i), '.r');
    elseif  GroundTruth(i) == 1
        plot(CL(i), RD(i), '.b');
    elseif  GroundTruth(i) == 2
        plot(CL(i), RD(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(CL(i), RD(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(CL(i), RD(i), '.k');
    end
end
xlabel('Curve Length','FontWeight','bold','FontSize',16);
ylabel('Rhythmic Discharge','FontWeight','bold','FontSize',16);

fig2 = figure(2);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(ANE(i), Energy(i), '.r');
    elseif  GroundTruth(i) == 1
        plot(ANE(i), Energy(i), '.b');
    elseif  GroundTruth(i) == 2
        plot(ANE(i), Energy(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(ANE(i), Energy(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(ANE(i), Energy(i), '.k');
    end
end
xlabel('Average Nonlinear Energy','FontWeight','bold','FontSize',16);
ylabel('Total Energy','FontWeight','bold','FontSize',16);

fig3 = figure(3);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(SV(i), RD(i), '.r');
    elseif  GroundTruth(i) == 1
        plot(SV(i), RD(i), '.b');
    elseif  GroundTruth(i) == 2
        plot(SV(i), RD(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(SV(i), RD(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(SV(i), RD(i), '.k');
    end
end
xlabel('Strength Variation','FontWeight','bold','FontSize',16);
ylabel('Rhythmic Discharge','FontWeight','bold','FontSize',16);


fig4 = figure(4);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(var(i), peakFreq(i), '.r');
    elseif  GroundTruth(i) == 1
        plot(var(i), peakFreq(i), '.b');
    elseif  GroundTruth(i) == 2
        plot(var(i), peakFreq(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(var(i), peakFreq(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(var(i), peakFreq(i), '.k');
    end
end
xlabel('Variance','FontWeight','bold','FontSize',16);
ylabel('Peak Frequency','FontWeight','bold','FontSize',16);


fig5 = figure(5);
hold on;
grid on;
for i = 1:length(GroundTruth)
    if      GroundTruth(i) == 0
        plot(PCA1(i), PCA2(i), '.r');
    elseif  GroundTruth(i) == 1
        plot(PCA1(i), PCA2(i), '.b');
    elseif  GroundTruth(i) == 2
        plot(PCA1(i), PCA2(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(PCA1(i), PCA2(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(PCA1(i), PCA2(i), '.k');
    end
end
xlabel('Principal Component 1','FontWeight','bold','FontSize',16);
ylabel('Principal Component 2','FontWeight','bold','FontSize',16);
















