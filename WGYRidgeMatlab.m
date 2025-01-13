TrainingData = readtable('DriedHarvestMT.csv');
unique(TrainingData.Variety)
for i = 1:height(TrainingData)
    thisVariety = categorical(cellstr(TrainingData.Variety{i}));
    switch thisVariety
        case {'Sherpa', 'Reiziq','V071','Viand', 'Viand Organic',...
               'V071 Organic', 'Viand Biodynamic', 'Reiziq Organic',...
               'Illabong', 'Reiziq Seed', 'Viand Seed', 'V071 Seed',...
               'Sherpa Seed', 'Mixed Medium'}
            TrainingData.varType(i) = categorical("Medium");
        case {'Koshihikari', 'Opus' }
            TrainingData.varType(i) = categorical("Short");
        case {'Doongara', 'Langi', 'Topaz', 'Mixed Long',...
                'Topaz Seed', 'Langi Seed', 'Doongara Seed'}
            TrainingData.varType(i) = categorical("Long");
    end
end
VarType = dummyvar(TrainingData.varType);
X = [TrainingData.HTC, TrainingData.HIG, VarType];
Y = [TrainingData.WGY];
k = 5;
BWGY = ridge(Y,X,k,0);

 %%
 TestingData = readtable("12122024PaddyvisionAttributesPredLM.csv");
 for i = 1:height(TestingData)
    thisVariety = categorical(cellstr(TestingData.VarType{i}));
    switch thisVariety
        case {'Medium'}
            TestingData.varType(i) = categorical("Medium");
        case {'Long' }
            TestingData.varType(i) = categorical("Long");
        case {'Short'}
            TestingData.varType(i) = categorical("Short");
    end
end
%unique(TestingData.varType)
unique(TestingData.varType)
c = dummyvar(TestingData.varType);
x = [TestingData.TotalCracked, TestingData.Immature, c];
yhatWGY = BWGY(1) + x*BWGY(2:end);
Predicted = (yhatWGY);
yhatWGY= yhatWGY(:);
TrueValue = TestingData.x_WHOLEGRAINYIELD;
figure
gscatter(yhatWGY, TrueValue, TestingData.VarType)
xlim([20,80]),
ylim([20,80])
title('Trained on PV Appraisals, Predicting Vietnam')
xlabel('Predicted WGY')
ylabel('Actual WGY')
