%% clean up
close all; clear all; clc;

%% parameter

readRawDataFileName      = 'parsedRawData';
writeFeatureDataFileName = 'features';

TWL             = 5; % sec
NUM_OF_ACTIVITY = 5;

%% read raw data from file

fidRead = fopen(readRawDataFileName, 'r');

data = textscan(fidRead, '%u64 %f %f %f %d', 'delimiter', ',');
timeStamp   = data{1};
AccX        = data{2};
AccY        = data{3};
AccZ        = data{4};
GroundTruth = data{5};

fclose(fidRead);

%% open feature file to write to

fidWrite = fopen(writeFeatureDataFileName, 'w');


%% processing

AccMagnitude = sqrt(AccX.^2 + AccY.^2 + AccZ.^2);


%% extract features
rawDataSize                 = length(timeStamp);

windowTimeStampInterval     = TWL * 1000; % msec
minRawDataIntervalInWindow  = 200       ; % msec

firstRawDataInCurrentWindow = 1;
for i = 2:rawDataSize
    if (  (timeStamp(i) - timeStamp(i-1)) < minRawDataIntervalInWindow  )
        if(  (timeStamp(i) - timeStamp(firstRawDataInCurrentWindow)) > windowTimeStampInterval  )
            
            currentWindowAccMagnitude = AccMagnitude(firstRawDataInCurrentWindow:i);
            currentWindowGroundTruth  = GroundTruth(firstRawDataInCurrentWindow:i);
            
            N = length(currentWindowAccMagnitude);
            
            % ---- FEATURE 1: Variance ----
            currentWindowVar = var(currentWindowAccMagnitude);
            
            
            % ---- FEATURE 2: Peak Power Frequency ----
            currentWindowFs = N/(double(timeStamp(i) - timeStamp(firstRawDataInCurrentWindow))/1000);
              
            currentWindowFFT      = fft(currentWindowAccMagnitude)/N;
            currentWindowPwr      = 2*abs(currentWindowFFT(1:floor(N/2)+1));
            peakPwrLocation       = find( currentWindowPwr == max(currentWindowPwr(2:end)) );
            currentWindowPeakFreq = (peakPwrLocation/N)*currentWindowFs;
              %NFFT                  = 2^nextpow2(N);
              %currentWindowFFT      = fft(currentWindowAccMagnitude, NFFT)/N;
              %currentWindowPwr      = 2*abs(currentWindowFFT(1:NFFT/2+1));
              %currentWindowPeakFreq = (peakPwrLocation/NFFT)*currentWindowFs;
            
            
            % ---- FEATURE 3: Curve Length ----
            currentWindowCL = sum(abs(currentWindowAccMagnitude(2:end) - currentWindowAccMagnitude(1:end-1)));
            
            
            % ---- FEATURE 4: Non-linear Energy
            currentWindowANE = sum(currentWindowAccMagnitude(2:end-1).^2 - currentWindowAccMagnitude(1:end-2).*currentWindowAccMagnitude(3:end))/N;
            
            
            % ---- FEATURE 5: Rhythmic Discharge
            if peakPwrLocation > 2
                peakLeftBoundary = peakPwrLocation - 1;
                while peakLeftBoundary > 2
                    if currentWindowPwr(peakLeftBoundary) >= currentWindowPwr(peakPwrLocation)/2
                        peakLeftBoundary = peakLeftBoundary - 1;
                    else
                        peakLeftBoundary = peakLeftBoundary + 1;
                        break;
                    end
                end
            else
                peakLeftBoundary = 2;
            end
            
            if peakPwrLocation < length(currentWindowPwr)
                peakRightBoundary = peakPwrLocation + 1;
                while peakRightBoundary < length(currentWindowPwr)
                    if currentWindowPwr(peakRightBoundary) >= currentWindowPwr(peakPwrLocation)/2
                        peakRightBoundary = peakRightBoundary + 1;
                    else
                        peakRightBoundary = peakRightBoundary - 1;
                        break;
                    end
                end
            else
                peakRightBoundary = length(currentWindowPwr);
            end
            
            currentWindowRD = sum(currentWindowPwr(peakLeftBoundary:peakRightBoundary));
            
            
            % ---- FEATURE 6: Window Energy
            currentWindowEnergy = sum(currentWindowPwr);
            
            
            % Groundtruth Label
            numberLabel           = zeros(1,5);
            for j = 1:length(currentWindowGroundTruth)
                if      currentWindowGroundTruth(j) == 0
                    numberLabel(1) = numberLabel(1) + 1;
                elseif  currentWindowGroundTruth(j) == 1
                    numberLabel(2) = numberLabel(2) + 1;
                elseif  currentWindowGroundTruth(j) == 2
                    numberLabel(3) = numberLabel(3) + 1;
                elseif  currentWindowGroundTruth(j) == 3
                    numberLabel(4) = numberLabel(4) + 1;
                elseif  currentWindowGroundTruth(j) == 4
                    numberLabel(5) = numberLabel(5) + 1;
                end
            end
            currentWindowlabel    = find(numberLabel == max(numberLabel)) - 1;
            
            
            % write features to feature file
            fprintf(fidWrite, '%3.5f,', currentWindowVar     );
            fprintf(fidWrite, '%3.5f,', currentWindowPeakFreq);
            fprintf(fidWrite, '%3.5f,', currentWindowCL      );
            fprintf(fidWrite, '%3.5f,', currentWindowANE     );
            fprintf(fidWrite, '%3.5f,', currentWindowRD      );
            fprintf(fidWrite, '%3.5f,', currentWindowEnergy  );
            fprintf(fidWrite, '%d'    , currentWindowlabel   );
            fprintf(fidWrite, '\n');
            
            
            
            firstRawDataInCurrentWindow = i;
        end
    else
        firstRawDataInCurrentWindow = i;
    end
end

%% plot

figure(1);

plot(1:length(AccMagnitude),AccMagnitude);
hold on;
plot(1:length(GroundTruth), GroundTruth);


%% close writing feature file

fclose(fidWrite);



