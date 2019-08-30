clear all;
load('HandWritten_data\DATA\ExtrapolatedData.mat');
tr = 0.7;

labelToClassify = labelToClassify';
c = max(labelToClassify);
traindata = [];
testdata = [];
trainlabel = [];
testlabel = [];
for i = 1 : c
    classdata = dataToClassify(labelToClassify == i,:);
    traindata = [traindata; classdata(1 : ceil(size(classdata, 1)*tr), :)];
    testdata = [testdata; classdata(ceil(size(classdata, 1)*tr) + 1 : end, :)];
    trainlabel = [trainlabel; repmat(i,ceil(size(classdata, 1)*tr),1)];
    testlabel = [testlabel; repmat(i,size(classdata, 1) - ceil(size(classdata, 1)*tr),1)];
end
premutationTrain = randperm(size(traindata, 1));
traindata = traindata(premutationTrain);
trainlabel = trainlabel(premutationTrain);
premutationTest = randperm(size(testdata, 1));
testdata = testdata(premutationTest);
testlabel = testlabel(premutationTest);

% Data for Analysis
result = zeros(length(1:4),length(0.001 : 0.001 : 0.6  ));
when = [];
max = [];

for k=1:4
    when(k) = 0;
    max(k) = 0;
    iter = 1;
    for j = 0.001 : 0.001 : 0.6
        model = svmtrain(trainlabel, traindata', ['-s 1 -n ' num2str(j) ' -t ' num2str(k - 1) ' -q']);
        %svm-train -s 3 -p 0.1 -t 0 data_file
        [predict_label, accuracy, dec_values] = svmpredict(testlabel, testdata', model);
        if max(k) < accuracy(1)
            max(k) = accuracy(1);
            when(k) = j;
        end
        result(k,iter)=accuracy(1);
        iter = iter + 1;
    end
end