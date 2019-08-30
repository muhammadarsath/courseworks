clc;
clear variables;
data1=load('17_ns\class1.txt');
data2=load('17_ns\class2.txt');
data3=load('17_ns\class3.txt');
%ROC Flag%
isROC=0;
%Number of classes %
c=3;
%Number of samples in a class %
n=1000;
%Train & Test ratio %
tr=0.7;
te=0.3;
ns=te*n*c;
train{c}=zeros(tr*n,2);
test=zeros(0,3);  % 3 for NLS
M=zeros(c,2);
C{c}=zeros(2,2);
C_actual{c}=zeros(2,2);
g{c}=zeros(ns,1);
p(c)=0;
w{c}=zeros(ns,1);
L{c}=zeros(ns,1);
result{1}=zeros(0,4);
error{1}=zeros(0,1);
% Initializing Data %
data=cat(1,data1,data2,data3);
for k=1:c
    data((1+(k-1)*n):(k*n),3)=k;
    p(k)=1/c;
end
data(:,4)=1:n*c;
% Shuffling train data within the class %
for k=1:c
    data_new((1+(k-1)*n):(k*n),:)=data((k-1)*n+randperm(n),:);
end
% Choosing 70% of shuffled data as train data and 10% as test data %
for k=1:c
    train{1,k}=data_new((1+(k-1)*n):(tr*n+(k-1)*n),1:2);
    test=cat(1,test,data_new(((1-te)*n+1+(k-1)*n):(k*n),1:3)); % 1:3 for NLS
end
% Shuffling test data across the class %
n1=c*te*n;
test=test(randperm(int16(n1)),:);
% Splitting 3 classes into 5 clusters according to the data given %
train_new=preprocessingWithKMeans(train{1,1}, 2, 0);
train_new{3}=train{2};
temp=preprocessingWithKMeans(train{1,3}, 2, 0);
train_new{4}=temp{1};train_new{5}=temp{2};
% Initializing prior according to new classes %
c=5;
for k=1:c
    p(k)=size(train_new{k},1)/(3*tr*n);
end
% Calculating Mean and Covariance for different classes%
for k=1:c
    M(k,:)=mean(train_new{1,k},1);
    C_actual{1,k}=cov(train_new{1,k}(:,1),train_new{1,k}(:,2));
end
% Computing results for different cases of bayesian%
for itr=1:5
    switch itr
        case 1 % Bayes with Covariance same for all classes %
            for k=1:c
                C{1,1}=C_actual{1,k};
                for j=2:c
                    C{1,j}=C{1,1};
                end
                C_plot{itr,k}=C;
                [result_5c{1,k},error{1,k}]=classify(test,M,C,p,0,0);
            end
            % Choosing best C based on Min. total error %
            [~,C_best_index(itr)]=min(sum([error{itr,1} error{itr,2} error{itr,3}],1));
            C_best{itr}=C_actual{1,C_best_index(itr)};
        case 2 % Bayes with Covariance different for all classes %
            C=C_actual;
            C_plot{itr,1}=C;
            [result_5c{2,1},error{2,1}]=classify(test,M,C,p,0,0);
            % Choosing best C %
            C_best_index(itr)=1;
            C_best{itr}=C_actual;
        case 3 % Naive Bayes with C = sigma^2*I %
            ind=1;
            for x=1:c
                for y=1:2
                    C{1,1}=C_actual{1,x}(y,y)*eye(2);
                    for z=2:c
                        C{1,z}=C{1,1};
                    end
                    C_plot{itr,ind}=C;
                    [result_5c{3,ind},error{3,ind}]=classify(test,M,C,p,0,0);ind=ind+1;
                end
            end
            % Choosing best C based on Min. total error %
            [~,C_best_index(itr)]=min(sum([error{itr,1} error{itr,2} error{itr,3} error{itr,4} error{itr,5} error{itr,6}],1));
            temp=C_best_index(itr);
            if(mod(temp,2)==0)
                C_best{itr}=C_actual{1,(temp/2)}(2,2)*eye(2);
            else
                C_best{itr}=C_actual{1,ceil(temp/2)}(1,1)*eye(2);
            end
            
        case 4 % Naive Bayes with C same for all classes %
            for k=1:c
                C{1,1}=[C_actual{1,k}(1,1) 0;0 C_actual{1,k}(2,2)];
                for j=2:c
                    C{1,j}=C{1,1};
                end
                C_plot{itr,k}=C;
                [result_5c{4,k},error{4,k}]=classify(test,M,C,p,0,0);
            end
            % Choosing best C based on Min. total error %
            [~,C_best_index(itr)]=min(sum([error{itr,1} error{itr,2} error{itr,3}],1));
            temp=C_best_index(itr);
            C_best{itr}=[C_actual{1,temp}(1,1) 0;0 C_actual{1,temp}(2,2)];
            
        otherwise % Naive Bayes with C different for all classes %
            for j=1:c
                C{1,j}=[C_actual{1,j}(1,1) 0;0 C_actual{1,j}(2,2)];
            end
            C_plot{itr,1}=C;
            [result_5c{5,1},error{5,1}]=classify(test,M,C,p,0,0);
            % Choosing best C %
            C_best_index(itr)=1;
            C_best{itr}=C;
    end
end

% Calculating ROC Curve %
if isROC==1
    ind=1;
    %result_ROC{5,21}=zeros(1,4);
    for k=1:5
        ind=1;
        for n=1:-0.1:0
            [result_ROC{k,ind},~]=classify(test,M,C_plot{k,C_best_index(k)},p,2,n);
            ind=ind+1;
        end
    end
end

% Clubbing clusters 1,2-->1 3-->2 and 4,5-->3 as given data %
result=postProcessingNLS(result_5c);