clear all;
load('Speech\DigitRecog\SpeechData.mat');

result = zeros(length(1:4),length(0.001 : 0.001 : 0.6  ));
when = [];
max = [];
for k=1:4
    when(k) = 0;
    max(k) = 0;
    iter = 1;
    for j = 0.001 : 0.001 : 0.6
        model = svmtrain(trainLabel, trainData, ['-s 1 -n ' num2str(j) ' -t ' num2str(k - 1) ' -q']);
        %svm-train -s 3 -p 0.1 -t 0 data_file
        [predict_label, accuracy, dec_values] = svmpredict(testLabel, testData, model);
        if max(k) < accuracy(1)
            max(k) = accuracy(1);
            when(k) = j;
        end
        result(k,iter)=accuracy(1);
        iter = iter + 1;
    end
end