%% clean up
close all; clear all; clc;

%% parameter

readTrainClass0   = 'trainClass0';
readTrainClass1   = 'trainClass1';
readTrainClass2   = 'trainClass2';
readTrainClass3   = 'trainClass3';
readTest          = 'test'       ;

writeTestResult   = 'boostClassifiedResult';
writeWeightResult = 'boostFeatureImportance.csv';

boostingClass0Ite = 150;
boostingClass1Ite = 10;
boostingClass2Ite = 10;

NUM_FEATURE       = 7;

%% read training feature from file

fidTrainClass0 = fopen(readTrainClass0, 'r');
fidTrainClass1 = fopen(readTrainClass1, 'r');
fidTrainClass2 = fopen(readTrainClass2, 'r');
fidTrainClass3 = fopen(readTrainClass3, 'r');
fidTest        = fopen(readTest       , 'r');

data = textscan(fidTrainClass0, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
varTrainClass0         = data{1};
peakFreqTrainClass0    = data{2};
CLTrainClass0          = data{3};
ANETrainClass0         = data{4};
RDTrainClass0          = data{5};
EnergyTrainClass0      = data{6};
SVTrainClass0          = data{7};
sizeTrainClass0        = length(varTrainClass0);

data = textscan(fidTrainClass1, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
varTrainClass1         = data{1};
peakFreqTrainClass1    = data{2};
CLTrainClass1          = data{3};
ANETrainClass1         = data{4};
RDTrainClass1          = data{5};
EnergyTrainClass1      = data{6};
SVTrainClass1          = data{7};
sizeTrainClass1        = length(varTrainClass1);

data = textscan(fidTrainClass2, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
varTrainClass2         = data{1};
peakFreqTrainClass2    = data{2};
CLTrainClass2          = data{3};
ANETrainClass2         = data{4};
RDTrainClass2          = data{5};
EnergyTrainClass2      = data{6};
SVTrainClass2          = data{7};
sizeTrainClass2        = length(varTrainClass2);

data = textscan(fidTrainClass3, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
varTrainClass3         = data{1};
peakFreqTrainClass3    = data{2};
CLTrainClass3          = data{3};
ANETrainClass3         = data{4};
RDTrainClass3          = data{5};
EnergyTrainClass3      = data{6};
SVTrainClass3          = data{7};
sizeTrainClass3        = length(varTrainClass3);

data = textscan(fidTest, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
varTest                = data{1};
peakFreqTest           = data{2};
CLTest                 = data{3};
ANETest                = data{4};
RDTest                 = data{5};
EnergyTest             = data{6};
SVTest                 = data{7};
GroundTruthTest        = data{8};
sizeTest               = length(GroundTruthTest);


fclose(fidTrainClass0);
fclose(fidTrainClass1);
fclose(fidTrainClass2);
fclose(fidTrainClass3);
fclose(fidTest       );

%% train the boosting classifier

% classify Class0 <--> Class1,2,3
labelClass0 = -1*ones(sizeTrainClass0+sizeTrainClass1+sizeTrainClass2+sizeTrainClass3,1);
labelClass0(1:sizeTrainClass0) = ones(sizeTrainClass0,1);

trainClass0   = [varTrainClass0 peakFreqTrainClass0 CLTrainClass0 ANETrainClass0 RDTrainClass0 EnergyTrainClass0 SVTrainClass0; ...
                 varTrainClass1 peakFreqTrainClass1 CLTrainClass1 ANETrainClass1 RDTrainClass1 EnergyTrainClass1 SVTrainClass1; ...
                 varTrainClass2 peakFreqTrainClass2 CLTrainClass2 ANETrainClass2 RDTrainClass2 EnergyTrainClass2 SVTrainClass2; ...
                 varTrainClass3 peakFreqTrainClass3 CLTrainClass3 ANETrainClass3 RDTrainClass3 EnergyTrainClass3 SVTrainClass3];
% adaboost
[classEstimateClass0,modelClass0]=adaboost('train',trainClass0,labelClass0,boostingClass0Ite);


% classify Class1 <--> Class2,3
labelClass1 = -1*ones(sizeTrainClass1+sizeTrainClass2+sizeTrainClass3,1);
labelClass1(1:sizeTrainClass1) = ones(sizeTrainClass1,1);

trainClass1   = [varTrainClass1 peakFreqTrainClass1 CLTrainClass1 ANETrainClass1 RDTrainClass1 EnergyTrainClass1 SVTrainClass1; ...
                 varTrainClass2 peakFreqTrainClass2 CLTrainClass2 ANETrainClass2 RDTrainClass2 EnergyTrainClass2 SVTrainClass2; ...
                 varTrainClass3 peakFreqTrainClass3 CLTrainClass3 ANETrainClass3 RDTrainClass3 EnergyTrainClass3 SVTrainClass3];
% adaboost
[classEstimateClass1,modelClass1]=adaboost('train',trainClass1,labelClass1,boostingClass1Ite);


% classify Class2 <--> Class3
labelClass2 = -1*ones(sizeTrainClass2+sizeTrainClass3,1);
labelClass2(1:sizeTrainClass2) = ones(sizeTrainClass2,1);

trainClass2   = [varTrainClass2 peakFreqTrainClass2 CLTrainClass2 ANETrainClass2 RDTrainClass2 EnergyTrainClass2 SVTrainClass2; ...
                 varTrainClass3 peakFreqTrainClass3 CLTrainClass3 ANETrainClass3 RDTrainClass3 EnergyTrainClass3 SVTrainClass3];
% adaboost
[classEstimateClass2,modelClass2]=adaboost('train',trainClass2,labelClass2,boostingClass2Ite);

figure(1);
subplot(2,2,1);
errorClass0=zeros(1,length(modelClass0)); 
for i=1:length(modelClass0) 
    errorClass0(i)=modelClass0(i).error; 
end 
grid on;
plot(errorClass0); 
title('Classification Error of Stationary Class');
xlabel('Iteration');

subplot(2,2,2);
errorClass1=zeros(1,length(modelClass1)); 
for i=1:length(modelClass1) 
    errorClass1(i)=modelClass1(i).error; 
end 
grid on;
plot(errorClass1); 
title('Classification Error of Walking Class');
xlabel('Iteration');

subplot(2,2,3);
errorClass2=zeros(1,length(modelClass2)); 
for i=1:length(modelClass2) 
    errorClass2(i)=modelClass2(i).error; 
end 
grid on;
plot(errorClass2); 
title('Classification Error of Biking Class');
xlabel('Iteration');


%% test the boosting classifier

testFeatures = [varTest peakFreqTest CLTest ANETest RDTest EnergyTest SVTest];

classifiedLabel = zeros(sizeTest, 1);

for i = 1:sizeTest
    testFeature = testFeatures(i,:);
    
    testClass = adaboost('apply',testFeature,modelClass0); % classify Class0
    if testClass == 1 % classify result is Class0
        classifiedLabel(i) = 0;
    else              % classify result is Class1,2,3
       
        testClass = adaboost('apply',testFeature,modelClass1); % classify Class1
        if testClass == 1 % classify result is Class1
            classifiedLabel(i) = 1;
        else              % classify result is Class2,3
            
            testClass = adaboost('apply',testFeature,modelClass2); % classify Class2
            if testClass == 1 % classify result is Class2
                classifiedLabel(i) = 2;
            else              % classify result is Class3
                classifiedLabel(i) = 3;
            end
        end
    end

    
end

%% feature importance analysis

class0FeatureWeight = zeros(NUM_FEATURE,1);
for i = 1:length(modelClass0)
    class0FeatureWeight(modelClass0(i).dimension) = class0FeatureWeight(modelClass0(i).dimension) + modelClass0(i).alpha;
end

class1FeatureWeight = zeros(NUM_FEATURE,1);
for i = 1:length(modelClass1)
    class1FeatureWeight(modelClass1(i).dimension) = class1FeatureWeight(modelClass1(i).dimension) + modelClass1(i).alpha;
end

class2FeatureWeight = zeros(NUM_FEATURE,1);
for i = 1:length(modelClass2)
    class2FeatureWeight(modelClass2(i).dimension) = class2FeatureWeight(modelClass2(i).dimension) + modelClass2(i).alpha;
end

class0FeatureWeight = class0FeatureWeight/sum(class0FeatureWeight);
class1FeatureWeight = class1FeatureWeight/sum(class1FeatureWeight);
class2FeatureWeight = class2FeatureWeight/sum(class2FeatureWeight);





%% write result to file

fidWrite = fopen(writeTestResult, 'w');

for i = 1:sizeTest
    fprintf(fidWrite, '%3.5f,', testFeatures(i,1)   );
    fprintf(fidWrite, '%3.5f,', testFeatures(i,2)   );
    fprintf(fidWrite, '%3.5f,', testFeatures(i,3)   );
    fprintf(fidWrite, '%3.5f,', testFeatures(i,4)   );
    fprintf(fidWrite, '%3.5f,', testFeatures(i,5)   );
    fprintf(fidWrite, '%3.5f,', testFeatures(i,6)   );
    fprintf(fidWrite, '%3.5f,', testFeatures(i,7)   );
    fprintf(fidWrite, '%d,'   , GroundTruthTest(i)  );
    fprintf(fidWrite, '%d'    , classifiedLabel(i)  );
    fprintf(fidWrite, '\n');
end

fclose(fidWrite);


fidWriteFeatWeight = fopen(writeWeightResult, 'w');

fprintf(fidWriteFeatWeight, '%3.5f,%3.5f,%3.5f,%3.5f,%3.5f,%3.5f,%3.5f\n', class0FeatureWeight);
fprintf(fidWriteFeatWeight, '%3.5f,%3.5f,%3.5f,%3.5f,%3.5f,%3.5f,%3.5f\n', class1FeatureWeight);
fprintf(fidWriteFeatWeight, '%3.5f,%3.5f,%3.5f,%3.5f,%3.5f,%3.5f,%3.5f\n', class2FeatureWeight);

fclose(fidWriteFeatWeight);





