clc;
clear variables;
%Upsample given raw data
[data,data_up]=upSamplerCharacter;
train_per=0.7;
test_per=0.3;
%Group Number Flag
grpNo=17;
%Group Data Flags%
grpData_start=50;
grpData_end=200;
grpData_step=10;
slpData_start=10;
slpData_end=70;
slpData_step=10;
traindata_means={};
traindata_slope_means={};
traindata_final_means={};
% Feature Extraction - Original data
for k=1:size(data,1)
    for j=1:size(data{k,1},2)
        temp=data{k,1}{1,j};
        dummy{k,j} = reshape(temp,2,size(temp,2)/2);
        deriv_1{k,1}{1,j}=findDerivative(dummy{k,j});
        deriv_2{k,1}{1,j}=findDerivative(deriv_1{k,1}{1,j});
        % find curvature - inverse of readius of the curve in each point
        x1=deriv_1{k,1}{1,j}(1,2:end-1) ;y1=deriv_1{k,1}{1,j}(2,2:end-1);
        x2=deriv_2{k,1}{1,j}(1,:) ;y2=deriv_2{k,1}{1,j}(2,:);
        %Curvature
        foo = (x1.*y2-x2.*y1)./((x1.^2+y1.^2).^1.5);
        foo(isinf(foo)) = 0;
        foo(isnan(foo)) = 0;
        feature{k,j}=foo';
    end
end
% Feature Extraction - Upsampled data
for k=1:size(data,1)
    for j=1:size(data{k,1},2)
        temp=data{k,1}{1,j};
        dummy2 = reshape(temp,2,size(temp,2)/2);
        feature_slope{k,j}=findSlope(dummy2);
    end
end

%concatinating features [x,y,slope,curvature] %
index=cellfun(@isempty,feature);
for k=1:size(feature,1)
    for j=1:size(feature,2)
        if index(k,j) == 1 break; end
        %         feature_final{k,j}=[dummy{k,j}(1,3:end-2)' dummy{k,j}(2,3:end-2)' feature_slope{k,j}(1,:)' feature_slope{k,j}(2,:)' feature{k,j}];
        feature_final{k,j}=[dummy{k,j}(1,3:end-2)' dummy{k,j}(2,3:end-2)' feature{k,j}];
    end
end
%splitting train and test data
for k=1:size(feature,1)
    ind=floor(size(feature(k,:),2)*train_per);
    feature_train(k,:)=feature(k,1:ind);
    feature_test(k,:)=feature(k,ind+1:end);
end
for k=1:size(feature_final,1)
    ind=floor(size(feature_final(k,:),2)*train_per);
    feature_final_train(k,:)=feature_final(k,1:ind);
    feature_final_test(k,:)=feature_final(k,ind+1:end);
end

%Loading train and test data
traindata=vertcat(feature_train{:});
testdata=vertcat(feature_test{:});
traindata_final=vertcat(feature_final_train{:});
testdata_final=vertcat(feature_final_test{:});

%Cluster train and test data by calling K-means
ind=0;
for k=grpData_start:grpData_step:grpData_end
    ind=ind+1;
    [~, traindata_final_means{ind}] = preprocessingWithKMeans(traindata_final, k, traindata_final_means, 1);
end

%Generating sequences of train and test data by calling K-means
ind=0;
for k=(grpData_start/grpData_step):(grpData_end/grpData_step)
    ind=ind+1;
    [traindata_final_seq{ind}, ~] = preprocessingWithKMeans(traindata_final, size(traindata_final_means{ind},1),traindata_final_means{ind}, 0);
end
ind=0;
for k=(grpData_start/grpData_step):(grpData_end/grpData_step)
    ind=ind+1;
    [testdata_final_seq{ind}, ~] = preprocessingWithKMeans(testdata_final,  size(traindata_final_means{ind},1),traindata_final_means{ind}, 0);
end

%No of rows in each file
[r_final_train,~]=cellfun(@size,feature_final_train, 'UniformOutput', false);
r_final_train=cell2mat(r_final_train);
[r_final_test,~]=cellfun(@size,feature_final_test, 'UniformOutput', false);
r_final_test=cell2mat(r_final_test);

% writing sequences into sequences folder
ind=0;
for k=(grpData_start/grpData_step):(grpData_end/grpData_step)
    ind=ind+1;
    fn_train={'train_chA','train_dA','train_lA'};
    fn_test={'test_chA','test_dA','test_lA'};
    path_final='sequence\character\final\';
    n=grpData_start+(ind-1)*grpData_step;
    for j=1:3
        fn_train{j}=strcat(fn_train{j}, '_',num2str(n), '.txt');
        fn_test{j}=strcat(fn_test{j}, '_',num2str(n) , '.txt');
    end
    %train sequences
    writeCharSequence(r_final_train,traindata_final_seq{ind},fn_train,path_final);
    %test sequences
    writeCharSequence(r_final_test,testdata_final_seq{ind},fn_test,path_final);
end
