clc;
clear variables;
pathstr_tt='DigitRecog\isolated_train_test\';
pathToWrite='sequence\digit\';
traindata_means={};
testdata_means={};
seqReady=0;
ind=0;
trainfilesPerDigit = 40;
testfilesPerDigit = 17;
% '\' =>windows && '/' =>linux
slash='\';
%Group Number Flag
grpNo=17;
%Group Data Flags%
isGlobalMeans = 0;
globalMeansStart = 100;
globalMeansEnd = 200;
globalMeansStep = 100;
grpData_start=60;
grpData_end=100;
grpData_step=10;
filename_tt= dir(pathstr_tt);
filename_tt = filename_tt(~cellfun(@invalidFolders,{filename_tt.name}));

% Load train and test data into a cell
[digitdata_tt,names_tt]=loadFiles(pathstr_tt,filename_tt,'mfcc',slash);

%Loading train and test data
traindata=vertcat(digitdata_tt{2,:});
testdata=vertcat(digitdata_tt{1,:});

%Cluster train and test data by calling K-means
if isGlobalMeans == 1
    grpData_start=globalMeansStart;
    grpData_end=globalMeansEnd;
    grpData_step=globalMeansStep;
    load allDataMeans.mat;
    traindata_means = allData_means;
else
    ind=0;
    for k=grpData_start:grpData_step:grpData_end
        ind=ind+1;
        [~, traindata_means{ind}] = preprocessingWithKMeans(traindata, k, traindata_means, 1);
    end
end

%Generating sequences of train and test data by calling K-means
ind=0;
for k=(grpData_start/grpData_step):(grpData_end/grpData_step)
    ind=ind+1;
    [traindata_seq{ind}, ~] = preprocessingWithKMeans(traindata, size(traindata_means{ind},1),traindata_means{ind}, 0);
end
ind=0;
for k=(grpData_start/grpData_step):(grpData_end/grpData_step)
    ind=ind+1;
    [testdata_seq{ind}, ~] = preprocessingWithKMeans(testdata, size(traindata_means{ind},1),traindata_means{ind}, 0);
end

%No of rows in each file
[r_tt,~]=cellfun(@size,digitdata_tt, 'UniformOutput', false);
r_tt=cell2mat(r_tt);

% writing sequences into sequences folder
ind=0;
for k=(grpData_start/grpData_step):(grpData_end/grpData_step)
    ind=ind+1;
    fn_train={'train_1','train_9','train_z'};
    fn_test={'test_1','test_9','test_z'};
    n=grpData_start+(ind-1)*grpData_step;
    for j=1:3
        fn_train{j}=strcat(fn_train{j}, '_',num2str(n), '.txt');
        fn_test{j}=strcat(fn_test{j}, '_',num2str(n) , '.txt');
    end
    %train sequences
    tempr_train=r_tt(2,:);
    writeSequence(tempr_train,traindata_seq{ind},trainfilesPerDigit,fn_train,pathToWrite);
    %test sequences
    tempr_test=r_tt(1,find(~ismember(r_tt(1,:),0)));
    writeSequence(tempr_test,testdata_seq{ind},testfilesPerDigit,fn_test,pathToWrite);
end