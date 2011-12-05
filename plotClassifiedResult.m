%% clean up
close all; clear all; clc;

%% parameter
readClassifiedResultFile = 'boostClassifiedResult';

%% read raw data from file

fidRead = fopen(readClassifiedResultFile, 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d %d', 'delimiter', ',');
var         = data{1};
peakFreq    = data{2};
CL          = data{3};
ANE         = data{4};
RD          = data{5};
Energy      = data{6};
SV          = data{7};
GroundTruth = data{8};
Classified  = data{9};

fclose(fidRead);

%% plot

sizeData = length(GroundTruth);
%{
figure(1);
subplot(1,2,1); hold on; grid on;
for i = 1:sizeData
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
title('Ground Truth Labeling');

subplot(1,2,2); hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(CL(i), RD(i), 'xr');
    elseif  Classified(i) == 1
        plot(CL(i), RD(i), '+b');
    elseif  Classified(i) == 2
        plot(CL(i), RD(i), '.g');
    elseif  Classified(i) == 3
        plot(CL(i), RD(i), '.c');
    elseif  Classified(i) == 4
        plot(CL(i), RD(i), '.k');
    end
end
xlabel('Curve Length');
ylabel('Rhythmic Discharge');
title('Classified Labeling');



figure(2); 
subplot(1,2,1); hold on; grid on;
for i = 1:sizeData
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
title('Ground Truth Labeling');

subplot(1,2,2); hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(ANE(i), Energy(i), 'xr');
    elseif  Classified(i) == 1
        plot(ANE(i), Energy(i), '+b');
    elseif  Classified(i) == 2
        plot(ANE(i), Energy(i), '.g');
    elseif  Classified(i) == 3
        plot(ANE(i), Energy(i), '.c');
    elseif  Classified(i) == 4
        plot(ANE(i), Energy(i), '.k');
    end
end
xlabel('Non-linear Energy');
ylabel('Total Energy');
title('Classified Labeling');



figure(3);
subplot(1,2,1); hold on; grid on;
for i = 1:sizeData
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
title('Ground Truth Labeling');

subplot(1,2,2); hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(SV(i), RD(i), 'xr');
    elseif  Classified(i) == 1
        plot(SV(i), RD(i), '+b');
    elseif  Classified(i) == 2
        plot(SV(i), RD(i), '.g');
    elseif  Classified(i) == 3
        plot(SV(i), RD(i), '.c');
    elseif  Classified(i) == 4
        plot(SV(i), RD(i), '.k');
    end
end
xlabel('Strength Variation');
ylabel('Rhythmic Discharge');
title('Classified Labeling');


%}

%{
figure(4);
%subplot(1,2,1); 
hold on; grid on;
for i = 1:sizeData
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
title('Ground Truth Labeling','FontWeight','bold','FontSize',16);

figure(5);
%subplot(1,2,2); 
hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(var(i), peakFreq(i), '.r');
    elseif  Classified(i) == 1
        plot(var(i), peakFreq(i), '.b');
    elseif  Classified(i) == 2
        plot(var(i), peakFreq(i), '.g');
    elseif  Classified(i) == 3
        plot(var(i), peakFreq(i), '.c');
    elseif  Classified(i) == 4
        plot(var(i), peakFreq(i), '.k');
    end
end
xlabel('Variance','FontWeight','bold','FontSize',16);
ylabel('Peak Frequency','FontWeight','bold','FontSize',16);
title('Classified Labeling','FontWeight','bold','FontSize',16);
%}

figure(6);
%subplot(1,2,1); 
hold on; grid on;
for i = 1:sizeData
    if      GroundTruth(i) == 0
        plot(CL(i), peakFreq(i), '.r');
    elseif  GroundTruth(i) == 1
        plot(CL(i), peakFreq(i), '.b');
    elseif  GroundTruth(i) == 2
        plot(CL(i), peakFreq(i), '.g');
    elseif  GroundTruth(i) == 3
        plot(CL(i), peakFreq(i), '.c');
    elseif  GroundTruth(i) == 4
        plot(CL(i), peakFreq(i), '.k');
    end
end
xlabel('Curve Length','FontWeight','bold','FontSize',16);
ylabel('Peak Frequency','FontWeight','bold','FontSize',16);
title('Ground Truth Labeling','FontWeight','bold','FontSize',16);

figure(7);
%subplot(1,2,2); 
hold on; grid on;
for i = 1:sizeData
    if      Classified(i) == 0
        plot(CL(i), peakFreq(i), '.r');
    elseif  Classified(i) == 1
        plot(CL(i), peakFreq(i), '.b');
    elseif  Classified(i) == 2
        plot(CL(i), peakFreq(i), '.g');
    elseif  Classified(i) == 3
        plot(CL(i), peakFreq(i), '.c');
    elseif  Classified(i) == 4
        plot(CL(i), peakFreq(i), '.k');
    end
end
xlabel('Curve Length','FontWeight','bold','FontSize',16);
ylabel('Peak Frequency','FontWeight','bold','FontSize',16);
title('Classified Labeling','FontWeight','bold','FontSize',16);

%% accuracy

labelDiff = GroundTruth - Classified;

accu = length(find(labelDiff == 0))/length(GroundTruth);
disp(accu);









