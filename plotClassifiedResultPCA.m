%% clean up
close all; clear all; clc;

%% parameter
readClassifiedResultFile = 'boostClassifiedPCAResult';

%% read raw data from file

fidRead = fopen(readClassifiedResultFile, 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d %d', 'delimiter', ',');
PC1         = data{1};
PC2    = data{2};
PC3          = data{3};
PC4         = data{4};
PC5          = data{5};
PC6      = data{6};
PC7          = data{7};
GroundTruth = data{8};
Classified  = data{9};

fclose(fidRead);

%% plot

sizeData = length(GroundTruth);

figure(1);
subplot(1,2,1); hold on; grid on;
for i = 1:sizeData
    if      GroundTruth(i) == 0
        plot(PC3(i), PC4(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(PC3(i), PC4(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(PC3(i), PC4(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(PC3(i), PC4(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(PC3(i), PC4(i), '.k');
    end
end
xlabel('PC3');
ylabel('PC4');
title('Ground Truth Labeling');

subplot(1,2,2); hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(PC3(i), PC4(i), 'xr');
    elseif  Classified(i) == 1
        plot(PC3(i), PC4(i), '+b');
    elseif  Classified(i) == 2
        plot(PC3(i), PC4(i), '.g');
    elseif  Classified(i) == 3
        plot(PC3(i), PC4(i), '.c');
    elseif  Classified(i) == 4
        plot(PC3(i), PC4(i), '.k');
    end
end
xlabel('PC3');
ylabel('PC4');
title('Classified Labeling');



figure(2); 
subplot(1,2,1); hold on; grid on;
for i = 1:sizeData
    if      GroundTruth(i) == 0
        plot(PC5(i), PC6(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(PC5(i), PC6(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(PC5(i), PC6(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(PC5(i), PC6(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(PC5(i), PC6(i), '.k');
    end
end
xlabel('PC5');
ylabel('PC6');
title('Ground Truth Labeling');

subplot(1,2,2); hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(PC5(i), PC6(i), 'xr');
    elseif  Classified(i) == 1
        plot(PC5(i), PC6(i), '+b');
    elseif  Classified(i) == 2
        plot(PC5(i), PC6(i), '.g');
    elseif  Classified(i) == 3
        plot(PC5(i), PC6(i), '.c');
    elseif  Classified(i) == 4
        plot(PC5(i), PC6(i), '.k');
    end
end
xlabel('PC5');
ylabel('PC6');
title('Classified Labeling');



figure(3);
subplot(1,2,1); hold on; grid on;
for i = 1:sizeData
    if      GroundTruth(i) == 0
        plot(PC7(i), PC1(i), 'xr');
    elseif  GroundTruth(i) == 1
        plot(PC7(i), PC1(i), '+b');
    elseif  GroundTruth(i) == 2
        plot(PC7(i), PC1(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(PC7(i), PC1(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(PC7(i), PC1(i), '.k');
    end
end
xlabel('PC7');
ylabel('PC1');
title('Ground Truth Labeling');

subplot(1,2,2); hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(PC7(i), PC1(i), 'xr');
    elseif  Classified(i) == 1
        plot(PC7(i), PC1(i), '+b');
    elseif  Classified(i) == 2
        plot(PC7(i), PC1(i), '.g');
    elseif  Classified(i) == 3
        plot(PC7(i), PC1(i), '.c');
    elseif  Classified(i) == 4
        plot(PC7(i), PC1(i), '.k');
    end
end
xlabel('PC7');
ylabel('PC1');
title('Classified Labeling');



figure(4);
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









