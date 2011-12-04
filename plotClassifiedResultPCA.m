%% clean up
close all; clear all; clc;

%% parameter
readClassifiedResultFile = 'boostClassifiedPCAResult';

%% read raw data from file

fidRead = fopen(readClassifiedResultFile, 'r');

data = textscan(fidRead, '%f %f %f %d %d', 'delimiter', ',');
PC1         = data{1};
PC2    = data{2};
PC3          = data{3};
GroundTruth = data{4};
Classified  = data{5};

fclose(fidRead);

%% plot

sizeData = length(GroundTruth);

figure(1);
subplot(1,2,1); hold on; grid on;
for i = 1:sizeData
    if      GroundTruth(i) == 0
        plot(PC1(i), PC2(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(PC1(i), PC2(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(PC1(i), PC2(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(PC1(i), PC2(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(PC1(i), PC2(i), '.k');
    end
end
xlabel('PC1');
ylabel('PC2');
title('Ground Truth Labeling');

subplot(1,2,2); hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(PC1(i), PC2(i), 'xr');
    elseif  Classified(i) == 1
        plot(PC1(i), PC2(i), '+b');
    elseif  Classified(i) == 2
        plot(PC1(i), PC2(i), '.g');
    elseif  Classified(i) == 3
        plot(PC1(i), PC2(i), '.c');
    elseif  Classified(i) == 4
        plot(PC1(i), PC2(i), '.k');
    end
end
xlabel('PC1');
ylabel('PC2');
title('Classified Labeling');


%% accuracy

labelDiff = GroundTruth - Classified;

accu = length(find(labelDiff == 0))/length(GroundTruth);
disp(accu);









