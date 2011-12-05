clear all
fidRead = fopen('train', 'r');
fidTest = fopen('test', 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
train_gt = data{8};
var         = data{1};
peakFreq    = data{2};
CL          = data{3};
ANE         = data{4};
RD          = data{5};
Energy      = data{6};
SV          = data{7};
trainSet = [var peakFreq CL ANE RD Energy SV];


%%%

test_data = textscan(fidTest, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
test_gt = test_data{8};
var         = test_data{1};
peakFreq    = test_data{2};
CL          = test_data{3};
ANE         = test_data{4};
RD          = test_data{5};
Energy      = test_data{6};
SV          = test_data{7};
testSet = [var peakFreq CL ANE RD Energy SV];

%%%

S = [0.00001,0.03385,0.00577,-0.00003,0.00064,0.22602,0.00001;
0.00001,0.32146,0.00614,-0.00001,0.00090,0.22606,0.00001;
0.00354,0.08468,0.05307,0.00223,0.06789,0.29240,0.00390;
0.01547,0.49054,0.17414,0.00948,0.05957,0.38728,0.01851;
0.02535,0.06762,0.28879,0.01830,0.07240,0.45618,0.02598;
0.00058,0.86406,0.04611,0.00050,0.00856,0.25937,0.00053;
0.00013,0.84526,0.02363,0.00011,0.00320,0.24171,0.00011;
0.00009,0.74442,0.01984,0.00011,0.00457,0.24128,0.00008;
0.00022,0.83001,0.02990,0.00014,0.01098,0.24740,0.00024
];
W = [0.04106,0.16946,0.13638,0.00361,0.19163,0.36380,0.05030;
0.22466,0.18562,0.47769,0.05696,0.28843,0.60142,0.13210;
0.24168,0.18599,0.45388,0.04985,0.32203,0.62292,0.21575;
0.02609,0.16946,0.11251,0.00342,0.11181,0.32603,0.03655;
0.06163,0.18640,0.17918,0.00750,0.17677,0.36686,0.06378;
0.04216,0.16936,0.14332,0.00552,0.11132,0.38637,0.05332;
0.05678,0.18618,0.16777,0.00716,0.16728,0.38747,0.06136;
0.05143,0.16953,0.16418,0.00740,0.13436,0.40102,0.05606;
0.05622,0.18640,0.17871,0.00730,0.22870,0.41389,0.05311];
R = [0.40925,0.21990,0.50557,0.06348,0.42644,0.61142,0.46418;
0.50850,0.23729,0.64964,0.09707,0.48715,0.72825,0.61986;
0.76007,0.21990,0.71958,0.12526,0.80135,0.87046,1.00000;
0.65949,0.23691,0.66429,0.11213,0.92818,0.85421,0.83575;
0.64416,0.23734,0.68787,0.11597,0.70841,0.88822,0.76863;
0.69693,0.23686,0.70019,0.12692,0.58436,0.75759,0.83995;
0.64531,0.23677,0.69225,0.13232,0.56721,0.72908,0.74717;
0.63169,0.23667,0.72439,0.12949,0.54698,0.83252,0.65674;
0.48249,0.27086,0.79554,0.48726,0.55801,0.88904,0.47077];
B = [0.06637,0.11836,0.33985,0.03394,0.35645,0.55545,0.10102;
0.00029,0.81194,0.03504,0.00033,0.00532,0.24870,0.00023;
0.02339,0.27108,0.17770,0.00950,0.16927,0.39458,0.02875;
0.03711,0.08466,0.21885,0.01797,0.08440,0.43157,0.04961;
0.03007,0.10169,0.16102,0.00711,0.09346,0.37829,0.03400;
0.06700,0.10147,0.28821,0.02892,0.15852,0.50429,0.08834;
0.06157,0.11853,0.20701,0.01084,0.18424,0.42090,0.08678;
0.05368,0.11848,0.22026,0.01185,0.15976,0.44552,0.06613;
0.00321,0.74561,0.10027,0.00228,0.01317,0.29910,0.00280];
S_m = mean(S); W_m = mean(W);R_m = mean(R);B_m = mean(B);S_cov = cov(S);W_cov = cov(W);R_cov = cov(R);B_cov = cov(B);
%% test


uncertainty = Inf * ones(length(trainSet),1);
 accuracy = zeros(length(trainSet),1);
for iteration = 1 : length(trainSet)+1
    
    
    S_tu = mvnpdf(testSet(1:end,1:end),S_m,S_cov);
    W_tu = mvnpdf(testSet(1:end,1:end),W_m,W_cov);
    R_tu = mvnpdf(testSet(1:end,1:end),R_m,R_cov);
    B_tu = mvnpdf(testSet(1:end,1:end),B_m,B_cov);
    correct = 0;
    for i = 1 : length(testSet) 
        tmp_a = [S_tu(i);W_tu(i);R_tu(i);B_tu(i)];
        [C max_index] = max(tmp_a);
         if (max_index-1) == test_gt(i)
            correct = correct + 1;
         else
             %  disp (testSet(i,1:end))
             %  disp (max_index - 1)
            %  disp (test_gt(i))
        
         end
    end
    accuracy(iteration) = correct/length(testSet);
    
    %find most uncertain example%
    S_train = mvnpdf(trainSet(1:end,1:end),S_m,S_cov);
    W_train = mvnpdf(trainSet(1:end,1:end),W_m,W_cov);
    R_train = mvnpdf(trainSet(1:end,1:end),R_m,R_cov);
    B_train = mvnpdf(trainSet(1:end,1:end),B_m,B_cov);

    
    for j = 1: length(trainSet)
         
        tmp_a = [S_train(j) W_train(j) R_train(j) B_train(j)];
        total = sum(tmp_a);
        tmp_a = tmp_a/total;
         etp = 0;
         
        if uncertainty(j) > -1
          
            for mm = 1:4
                if tmp_a(mm) > 0.0000001  
                     etp = etp + (tmp_a(mm)*log(1/tmp_a(mm)));    
                if iteration == 4 && j == 321
                    disp shit
                    etp
                end    
                else 
                    etp = etp;
                end
            end
                uncertainty(j) = etp;
            
                
        end
        
    end
    uncertainty;
    [dummy_uncertain max_index] = max(uncertainty);
    if max_index == 232,
        disp em232
        uncertainty(max_index) 
        tmp_a = [S_train(232) W_train(232) R_train(232) B_train(232)];
        total = sum(tmp_a);
        tmp_a = tmp_a/total
        max_index
        trainSet(max_index,1:end)
        disp why321
        tmp_a = [S_train(321) W_train(321) R_train(321) B_train(321)];
        total = sum(tmp_a);
        tmp_a = tmp_a/total
        uncertainty
        
    end
  
    uncertainty(max_index) = -1;
    if train_gt(max_index) == 0
        S = [S;trainSet(max_index,1:end)];
        S_m = mean(S);
        S_cov = cov(S);
    elseif train_gt(max_index) == 1
        W = [W;trainSet(max_index,1:end)];
        W_m = mean(W);
        W_cov = cov(W);
    elseif train_gt(max_index) == 2
        R = [R;trainSet(max_index,1:end)];
        R_m = mean(R);
        R_cov = cov(R);
    else
        B = [B;trainSet(max_index,1:end)];
        B_m = mean(B);
        B_cov = cov(B);
    end
    previousdot =  trainSet(max_index,1:end);
end    
figure(2)
accuracy;
plot(accuracy)
hold on;
pause;
%% untrusted outlier
clear all
fidRead = fopen('train', 'r');
fidTest = fopen('test', 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
train_gt = data{8};
var         = data{1};
peakFreq    = data{2};
CL          = data{3};
ANE         = data{4};
RD          = data{5};
Energy      = data{6};
SV          = data{7};
trainSet = [var peakFreq CL ANE RD Energy SV];


%%%

test_data = textscan(fidTest, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
test_gt = test_data{8};
var         = test_data{1};
peakFreq    = test_data{2};
CL          = test_data{3};
ANE         = test_data{4};
RD          = test_data{5};
Energy      = test_data{6};
SV          = test_data{7};
testSet = [var peakFreq CL ANE RD Energy SV];

%%%

S = [0.00001,0.03385,0.00577,-0.00003,0.00064,0.22602,0.00001;
0.00001,0.32146,0.00614,-0.00001,0.00090,0.22606,0.00001;
0.00354,0.08468,0.05307,0.00223,0.06789,0.29240,0.00390;
0.01547,0.49054,0.17414,0.00948,0.05957,0.38728,0.01851;
0.02535,0.06762,0.28879,0.01830,0.07240,0.45618,0.02598;
0.00058,0.86406,0.04611,0.00050,0.00856,0.25937,0.00053;
0.00013,0.84526,0.02363,0.00011,0.00320,0.24171,0.00011;
0.00009,0.74442,0.01984,0.00011,0.00457,0.24128,0.00008;
0.00022,0.83001,0.02990,0.00014,0.01098,0.24740,0.00024
];
W = [0.04106,0.16946,0.13638,0.00361,0.19163,0.36380,0.05030;
0.22466,0.18562,0.47769,0.05696,0.28843,0.60142,0.13210;
0.24168,0.18599,0.45388,0.04985,0.32203,0.62292,0.21575;
0.02609,0.16946,0.11251,0.00342,0.11181,0.32603,0.03655;
0.06163,0.18640,0.17918,0.00750,0.17677,0.36686,0.06378;
0.04216,0.16936,0.14332,0.00552,0.11132,0.38637,0.05332;
0.05678,0.18618,0.16777,0.00716,0.16728,0.38747,0.06136;
0.05143,0.16953,0.16418,0.00740,0.13436,0.40102,0.05606;
0.05622,0.18640,0.17871,0.00730,0.22870,0.41389,0.05311];
R = [0.40925,0.21990,0.50557,0.06348,0.42644,0.61142,0.46418;
0.50850,0.23729,0.64964,0.09707,0.48715,0.72825,0.61986;
0.76007,0.21990,0.71958,0.12526,0.80135,0.87046,1.00000;
0.65949,0.23691,0.66429,0.11213,0.92818,0.85421,0.83575;
0.64416,0.23734,0.68787,0.11597,0.70841,0.88822,0.76863;
0.69693,0.23686,0.70019,0.12692,0.58436,0.75759,0.83995;
0.64531,0.23677,0.69225,0.13232,0.56721,0.72908,0.74717;
0.63169,0.23667,0.72439,0.12949,0.54698,0.83252,0.65674;
0.48249,0.27086,0.79554,0.48726,0.55801,0.88904,0.47077];
B = [0.06637,0.11836,0.33985,0.03394,0.35645,0.55545,0.10102;
0.00029,0.81194,0.03504,0.00033,0.00532,0.24870,0.00023;
0.02339,0.27108,0.17770,0.00950,0.16927,0.39458,0.02875;
0.03711,0.08466,0.21885,0.01797,0.08440,0.43157,0.04961;
0.03007,0.10169,0.16102,0.00711,0.09346,0.37829,0.03400;
0.06700,0.10147,0.28821,0.02892,0.15852,0.50429,0.08834;
0.06157,0.11853,0.20701,0.01084,0.18424,0.42090,0.08678;
0.05368,0.11848,0.22026,0.01185,0.15976,0.44552,0.06613;
0.00321,0.74561,0.10027,0.00228,0.01317,0.29910,0.00280];
S_m = mean(S); W_m = mean(W);R_m = mean(R);B_m = mean(B);S_cov = cov(S);W_cov = cov(W);R_cov = cov(R);B_cov = cov(B);


uncertainty = Inf * ones(length(trainSet),1);
accuracy = zeros(length(trainSet),1);
tried_num = length(trainSet); 
trust_num = 1;
impot_d = zeros(1,7);
while(tried_num <= length(trainSet))
    
    S_tu = mvnpdf(testSet(1:end,1:end),S_m,S_cov);
    W_tu = mvnpdf(testSet(1:end,1:end),W_m,W_cov);
    R_tu = mvnpdf(testSet(1:end,1:end),R_m,R_cov);
    B_tu = mvnpdf(testSet(1:end,1:end),B_m,B_cov);
    correct = 0;
    for i = 1 : length(testSet) 
        tmp_a = [S_tu(i);W_tu(i);R_tu(i);B_tu(i)];
        [C max_index] = max(tmp_a);
         if (max_index-1) == test_gt(i)
            correct = correct + 1;
         else
             %  disp (testSet(i,1:end))
             %  disp (max_index - 1)
            %  disp (test_gt(i))
        
         end
    end
    accuracy(trust_num) = correct/length(testSet);
    
    %find most uncertain example%
    S_train = mvnpdf(trainSet(1:end,1:end),S_m,S_cov);
    W_train = mvnpdf(trainSet(1:end,1:end),W_m,W_cov);
    R_train = mvnpdf(trainSet(1:end,1:end),R_m,R_cov);
    B_train = mvnpdf(trainSet(1:end,1:end),B_m,B_cov);

    
    for j = 1: length(trainSet)
         
        tmp_a = [S_train(j) W_train(j) R_train(j) B_train(j)];
        total = sum(tmp_a);
        tmp_a = tmp_a/total;
        if uncertainty(j) > -8
            etp = 0;
            for m = 1:4
                if  tmp_a(m) > 0.000000000001  
                    etp = etp + (tmp_a(m)*log(1/tmp_a(m)));     
                end
            end
            uncertainty(j) = etp;
        end
    end
    uncertainty;
    [dummy_uncertain max_index] = max(uncertainty);

    
    dist = 0;
    if train_gt(max_index) == 0
        dist = (pdist([trainSet(max_index,1:end);S_m]));
    elseif train_gt(max_index) == 1
       dist = (pdist([trainSet(max_index,1:end);W_m]));
    elseif train_gt(max_index) == 2
       dist = (pdist([trainSet(max_index,1:end);R_m]));
    else
        dist = (pdist([trainSet(max_index,1:end);B_m]));
    end
    uncertainty(max_index) = -10;
        
    if dist < 0.3
        impot_d = trainSet(max_index,1:end);
        if train_gt(max_index) == 0
             S = [S;trainSet(max_index,1:end)];
             S_m = mean(S);
             S_cov = cov(S);
         elseif train_gt(max_index) == 1
             W = [W;trainSet(max_index,1:end)];
            W_m = mean(W);
            W_cov = cov(W);
        elseif train_gt(max_index) == 2
            R = [R;trainSet(max_index,1:end)];
            R_m = mean(R);
             R_cov = cov(R);
        else
              B = [B;trainSet(max_index,1:end)];
              B_m = mean(B);
              B_cov = cov(B);
        end
        trust_num = trust_num + 1; 
  
    end
    tried_num = tried_num + 1;
    
end


while(trust_num <= length(trainSet)+1)
    
    S_tu = mvnpdf(testSet(1:end,1:end),S_m,S_cov);
    W_tu = mvnpdf(testSet(1:end,1:end),W_m,W_cov);
    R_tu = mvnpdf(testSet(1:end,1:end),R_m,R_cov);
    B_tu = mvnpdf(testSet(1:end,1:end),B_m,B_cov);
    correct = 0;
    for i = 1 : length(testSet) 
        tmp_a = [S_tu(i);W_tu(i);R_tu(i);B_tu(i)];
        [C max_index] = max(tmp_a);
         if (max_index-1) == test_gt(i)
            correct = correct + 1;
         else
             %  disp (testSet(i,1:end))
             %  disp (max_index - 1)
            %  disp (test_gt(i))
        
         end
    end
    accuracy(trust_num) = correct/length(testSet);
 
    
    %find mos
    %find most uncertain example%
    S_train = mvnpdf(trainSet(1:end,1:end),S_m,S_cov);
    W_train = mvnpdf(trainSet(1:end,1:end),W_m,W_cov);
    R_train = mvnpdf(trainSet(1:end,1:end),R_m,R_cov);
    B_train = mvnpdf(trainSet(1:end,1:end),B_m,B_cov);

    
    for j = 1: length(trainSet)
         
        tmp_a = [S_train(j) W_train(j) R_train(j) B_train(j)];
        total = sum(tmp_a);
        tmp_a = tmp_a/total;
        if uncertainty(j) > -1
            etp = 0;
            for m = 1:4
                if  tmp_a(m) > 0.000000000001  
                    etp = etp + (tmp_a(m)*log(1/tmp_a(m)));     
                end
            end
            uncertainty(j) = etp;
        end
    end
    uncertainty;
    [dummy_uncertain max_index] = max(uncertainty);
    uncertainty(max_index) = -1;
    
    impot_d = trainSet(max_index,1:end);
    if train_gt(max_index) == 0
        S = [S;trainSet(max_index,1:end)];
        S_m = mean(S);
        S_cov = cov(S);
    elseif train_gt(max_index) == 1
        W = [W;trainSet(max_index,1:end)];
        W_m = mean(W);
        W_cov = cov(W);
    elseif train_gt(max_index) == 2
        R = [R;trainSet(max_index,1:end)];
        R_m = mean(R);
        R_cov = cov(R);
    else
        B = [B;trainSet(max_index,1:end)];
        B_m = mean(B);
        B_cov = cov(B);
    end
    trust_num = trust_num + 1;
    
end
%tmp_accuracy = accuracy(trust_num);
%accuracy(trust_num:end) = tmp_accuracy;
figure(2)
accuracy;
plot(accuracy,'r')
hold on;
%pause;
%% gini
clear all
fidRead = fopen('train', 'r');
fidTest = fopen('test', 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
train_gt = data{8};
var         = data{1};
peakFreq    = data{2};
CL          = data{3};
ANE         = data{4};
RD          = data{5};
Energy      = data{6};
SV          = data{7};
trainSet = [var peakFreq CL ANE RD Energy SV];


%%%

test_data = textscan(fidTest, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
test_gt = test_data{8};
var         = test_data{1};
peakFreq    = test_data{2};
CL          = test_data{3};
ANE         = test_data{4};
RD          = test_data{5};
Energy      = test_data{6};
SV          = test_data{7};
testSet = [var peakFreq CL ANE RD Energy SV];

%%%

S = [0.00001,0.03385,0.00577,-0.00003,0.00064,0.22602,0.00001;
0.00001,0.32146,0.00614,-0.00001,0.00090,0.22606,0.00001;
0.00354,0.08468,0.05307,0.00223,0.06789,0.29240,0.00390;
0.01547,0.49054,0.17414,0.00948,0.05957,0.38728,0.01851;
0.02535,0.06762,0.28879,0.01830,0.07240,0.45618,0.02598;
0.00058,0.86406,0.04611,0.00050,0.00856,0.25937,0.00053;
0.00013,0.84526,0.02363,0.00011,0.00320,0.24171,0.00011;
0.00009,0.74442,0.01984,0.00011,0.00457,0.24128,0.00008;
0.00022,0.83001,0.02990,0.00014,0.01098,0.24740,0.00024
];
W = [0.04106,0.16946,0.13638,0.00361,0.19163,0.36380,0.05030;
0.22466,0.18562,0.47769,0.05696,0.28843,0.60142,0.13210;
0.24168,0.18599,0.45388,0.04985,0.32203,0.62292,0.21575;
0.02609,0.16946,0.11251,0.00342,0.11181,0.32603,0.03655;
0.06163,0.18640,0.17918,0.00750,0.17677,0.36686,0.06378;
0.04216,0.16936,0.14332,0.00552,0.11132,0.38637,0.05332;
0.05678,0.18618,0.16777,0.00716,0.16728,0.38747,0.06136;
0.05143,0.16953,0.16418,0.00740,0.13436,0.40102,0.05606;
0.05622,0.18640,0.17871,0.00730,0.22870,0.41389,0.05311];
R = [0.40925,0.21990,0.50557,0.06348,0.42644,0.61142,0.46418;
0.50850,0.23729,0.64964,0.09707,0.48715,0.72825,0.61986;
0.76007,0.21990,0.71958,0.12526,0.80135,0.87046,1.00000;
0.65949,0.23691,0.66429,0.11213,0.92818,0.85421,0.83575;
0.64416,0.23734,0.68787,0.11597,0.70841,0.88822,0.76863;
0.69693,0.23686,0.70019,0.12692,0.58436,0.75759,0.83995;
0.64531,0.23677,0.69225,0.13232,0.56721,0.72908,0.74717;
0.63169,0.23667,0.72439,0.12949,0.54698,0.83252,0.65674;
0.48249,0.27086,0.79554,0.48726,0.55801,0.88904,0.47077];
B = [0.06637,0.11836,0.33985,0.03394,0.35645,0.55545,0.10102;
0.00029,0.81194,0.03504,0.00033,0.00532,0.24870,0.00023;
0.02339,0.27108,0.17770,0.00950,0.16927,0.39458,0.02875;
0.03711,0.08466,0.21885,0.01797,0.08440,0.43157,0.04961;
0.03007,0.10169,0.16102,0.00711,0.09346,0.37829,0.03400;
0.06700,0.10147,0.28821,0.02892,0.15852,0.50429,0.08834;
0.06157,0.11853,0.20701,0.01084,0.18424,0.42090,0.08678;
0.05368,0.11848,0.22026,0.01185,0.15976,0.44552,0.06613;
0.00321,0.74561,0.10027,0.00228,0.01317,0.29910,0.00280];
S_m = mean(S); W_m = mean(W);R_m = mean(R);B_m = mean(B);S_cov = cov(S);W_cov = cov(W);R_cov = cov(R);B_cov = cov(B);



uncertainty = Inf * ones(length(trainSet),1);
 accuracy = zeros(length(trainSet),1);
for iteration = 1 : length(trainSet)+1
    
    
    S_tu = mvnpdf(testSet(1:end,1:end),S_m,S_cov);
    W_tu = mvnpdf(testSet(1:end,1:end),W_m,W_cov);
    R_tu = mvnpdf(testSet(1:end,1:end),R_m,R_cov);
    B_tu = mvnpdf(testSet(1:end,1:end),B_m,B_cov);
    correct = 0;
    for i = 1 : length(testSet) 
        tmp_a = [S_tu(i);W_tu(i);R_tu(i);B_tu(i)];
        [C max_index] = max(tmp_a);
         if (max_index-1) == test_gt(i)
            correct = correct + 1;
         else
             %  disp (testSet(i,1:end))
             %  disp (max_index - 1)
            %  disp (test_gt(i))
        
         end
    end
    accuracy(iteration) = correct/length(testSet);
    

    
    %find most uncertain example%
    S_train = mvnpdf(trainSet(1:end,1:end),S_m,S_cov);
    W_train = mvnpdf(trainSet(1:end,1:end),W_m,W_cov);
    R_train = mvnpdf(trainSet(1:end,1:end),R_m,R_cov);
    B_train = mvnpdf(trainSet(1:end,1:end),B_m,B_cov);

    
    for j = 1: length(trainSet)
         
        tmp_a = [S_train(j) W_train(j) R_train(j) B_train(j)];
        total = sum(tmp_a);
        tmp_a = tmp_a/total;
        if uncertainty(j) > 0
            etp = 0;
            for m = 1:4        
                    etp = etp + (tmp_a(m)*(1-tmp_a(m)));     
            end
            uncertainty(j) = etp;
        end
    end
    uncertainty;
    [dummy_uncertain max_index] = max(uncertainty);
    
    if max_index == 321,
        disp gini
        uncertainty(max_index) 
    max_index
    trainSet(max_index,1:end)
    disp tsz
        uncertainty(232) 
    end
    uncertainty(max_index) = -1;
   
    if train_gt(max_index) == 0
        S = [S;trainSet(max_index,1:end)];
        S_m = mean(S);
        S_cov = cov(S);
    elseif train_gt(max_index) == 1
        W = [W;trainSet(max_index,1:end)];
        W_m = mean(W);
        W_cov = cov(W);
    elseif train_gt(max_index) == 2
        R = [R;trainSet(max_index,1:end)];
        R_m = mean(R);
        R_cov = cov(R);
    else
        B = [B;trainSet(max_index,1:end)];
        B_m = mean(B);
        B_cov = cov(B);
    end
end    
figure(2)
accuracy
plot(accuracy,'g')
hold on;
%% random walk %%
clear all
fidRead = fopen('train', 'r');
fidTest = fopen('test', 'r');

data = textscan(fidRead, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
train_gt = data{8};
var         = data{1};
peakFreq    = data{2};
CL          = data{3};
ANE         = data{4};
RD          = data{5};
Energy      = data{6};
SV          = data{7};
trainSet = [var peakFreq CL ANE RD Energy SV];


%%%

test_data = textscan(fidTest, '%f %f %f %f %f %f %f %d', 'delimiter', ',');
test_gt = test_data{8};
var         = test_data{1};
peakFreq    = test_data{2};
CL          = test_data{3};
ANE         = test_data{4};
RD          = test_data{5};
Energy      = test_data{6};
SV          = test_data{7};
testSet = [var peakFreq CL ANE RD Energy SV];

%%%

S = [0.00001,0.03385,0.00577,-0.00003,0.00064,0.22602,0.00001;
0.00001,0.32146,0.00614,-0.00001,0.00090,0.22606,0.00001;
0.00354,0.08468,0.05307,0.00223,0.06789,0.29240,0.00390;
0.01547,0.49054,0.17414,0.00948,0.05957,0.38728,0.01851;
0.02535,0.06762,0.28879,0.01830,0.07240,0.45618,0.02598;
0.00058,0.86406,0.04611,0.00050,0.00856,0.25937,0.00053;
0.00013,0.84526,0.02363,0.00011,0.00320,0.24171,0.00011;
0.00009,0.74442,0.01984,0.00011,0.00457,0.24128,0.00008;
0.00022,0.83001,0.02990,0.00014,0.01098,0.24740,0.00024
];
W = [0.04106,0.16946,0.13638,0.00361,0.19163,0.36380,0.05030;
0.22466,0.18562,0.47769,0.05696,0.28843,0.60142,0.13210;
0.24168,0.18599,0.45388,0.04985,0.32203,0.62292,0.21575;
0.02609,0.16946,0.11251,0.00342,0.11181,0.32603,0.03655;
0.06163,0.18640,0.17918,0.00750,0.17677,0.36686,0.06378;
0.04216,0.16936,0.14332,0.00552,0.11132,0.38637,0.05332;
0.05678,0.18618,0.16777,0.00716,0.16728,0.38747,0.06136;
0.05143,0.16953,0.16418,0.00740,0.13436,0.40102,0.05606;
0.05622,0.18640,0.17871,0.00730,0.22870,0.41389,0.05311];
R = [0.40925,0.21990,0.50557,0.06348,0.42644,0.61142,0.46418;
0.50850,0.23729,0.64964,0.09707,0.48715,0.72825,0.61986;
0.76007,0.21990,0.71958,0.12526,0.80135,0.87046,1.00000;
0.65949,0.23691,0.66429,0.11213,0.92818,0.85421,0.83575;
0.64416,0.23734,0.68787,0.11597,0.70841,0.88822,0.76863;
0.69693,0.23686,0.70019,0.12692,0.58436,0.75759,0.83995;
0.64531,0.23677,0.69225,0.13232,0.56721,0.72908,0.74717;
0.63169,0.23667,0.72439,0.12949,0.54698,0.83252,0.65674;
0.48249,0.27086,0.79554,0.48726,0.55801,0.88904,0.47077];
B = [0.06637,0.11836,0.33985,0.03394,0.35645,0.55545,0.10102;
0.00029,0.81194,0.03504,0.00033,0.00532,0.24870,0.00023;
0.02339,0.27108,0.17770,0.00950,0.16927,0.39458,0.02875;
0.03711,0.08466,0.21885,0.01797,0.08440,0.43157,0.04961;
0.03007,0.10169,0.16102,0.00711,0.09346,0.37829,0.03400;
0.06700,0.10147,0.28821,0.02892,0.15852,0.50429,0.08834;
0.06157,0.11853,0.20701,0.01084,0.18424,0.42090,0.08678;
0.05368,0.11848,0.22026,0.01185,0.15976,0.44552,0.06613;
0.00321,0.74561,0.10027,0.00228,0.01317,0.29910,0.00280];
S_m = mean(S); W_m = mean(W);R_m = mean(R);B_m = mean(B);S_cov = cov(S);W_cov = cov(W);R_cov = cov(R);B_cov = cov(B);

chosen = zeros(length(trainSet),1);
r_accuracy = zeros(length(trainSet),1);
tried_num = 1;
while(tried_num <= length(trainSet))

    S_tu = mvnpdf(testSet(1:end,1:end),S_m,S_cov);
    W_tu = mvnpdf(testSet(1:end,1:end),W_m,W_cov);
    R_tu = mvnpdf(testSet(1:end,1:end),R_m,R_cov);
    B_tu = mvnpdf(testSet(1:end,1:end),B_m,B_cov);
    correct = 0;
    for i = 1 : length(testSet) 
        tmp_a = [S_tu(i);W_tu(i);R_tu(i);B_tu(i)];
        [C max_index] = max(tmp_a);
         if (max_index-1) == test_gt(i)
            correct = correct + 1;
         else
             %  disp (testSet(i,1:end))
             %  disp (max_index - 1)
            %  disp (test_gt(i))
        
         end
    end
    r_accuracy(tried_num) = correct/length(testSet);
    
%r_index = tried_num;
r_index = randi(length(trainSet),1);
% if(chosen(r_index) == 0)   
    if train_gt(r_index) == 0
        S = [S;trainSet(r_index,1:end)];
        S_m = mean(S);
        S_cov = cov(S);
    elseif train_gt(r_index) == 1
        W = [W;trainSet(r_index,1:end)];
        W_m = mean(W);
        W_cov = cov(W);
    elseif train_gt(r_index) == 2
        R = [R;trainSet(r_index,1:end)];
        R_m = mean(R);
        R_cov = cov(R);
    else
        B = [B;trainSet(r_index,1:end)];
        B_m = mean(B);
        B_cov = cov(B);
    end
      tried_num = tried_num + 1;
   %       chosen(r_index) = 1;  
%end
end    
figure(2)
r_accuracy
plot(r_accuracy,'k')








