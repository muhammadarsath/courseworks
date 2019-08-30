clc;
clear variables;
pathstr_tt='Speech\DigitRecog\isolated_train_test\';
trainfilesPerDigit = 40;
testfilesPerDigit = 17;
c = 3;
% '\' =>windows && '/' =>linux
slash='\';
%Group Number Flag
grpNo=17;
filename_tt= dir(pathstr_tt);
filename_tt = filename_tt(~cellfun(@invalidFolders,{filename_tt.name}));

% Load train and test data into a cell
[digitdata_tt,names_tt]=loadFiles(pathstr_tt,filename_tt,'mfcc',slash);

%Loading train and test data
train={vertcat(digitdata_tt{4,:}), vertcat(digitdata_tt{5,:}),vertcat(digitdata_tt{6,:})};
developmentData = [vertcat(digitdata_tt{4,:}); vertcat(digitdata_tt{5,:}); vertcat(digitdata_tt{6,:})];
test={digitdata_tt{1,:};digitdata_tt{2,:};digitdata_tt{3,:}};

%Building UBM
k = 5;
means = [];
M = preprocessingWithKMeans(developmentData, k, means, 1);
adaptedMeans = {};
for i = 1 : c
    temp = [];
    for j = 1 : 100
        permute = randperm(length(train{i}));
        permute = permute(1 : 1777)';
        foo = train{i}(permute,:);
        km_m = preprocessingWithKMeans([developmentData; foo], k, M, 1);
        temp = [temp; km_m(:)'];
    end
    adaptedMeans{i} = temp;
end
testMeans = {};
for i = 1 : c
    for j = 1 : size(test,2)
        if isempty(test{i,j}) == 0
            foo = test{i,j};
            km_m = preprocessingWithKMeans([developmentData; foo], k, M, 1);
            testMeans{i,j} = km_m(:)';
        end
    end
end

trainData = [];
trainLabel = [];

for i = 1 : c
    trainData = [trainData; adaptedMeans{i}];
    trainLabel = [trainLabel; repmat(i,size(adaptedMeans{i},1),1)];
end

testData = [];
testLabel = [];

iter = 1;
for i = 1 : c
    for j = 1 : size(testMeans, 2)
        testData = [testData; testMeans{i, j}];
        testLabel(iter) = i;
        iter = iter + 1;
    end
end

testLabel = testLabel';
save('Speech\DigitRecog\SpeechData.mat', 'trainData', 'trainLabel', 'testData', 'testLabel');