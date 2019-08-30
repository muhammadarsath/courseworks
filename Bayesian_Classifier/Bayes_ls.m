clc;
clear variables;
data=load('17_ls.txt');
% data1=load('17_ns\class1.txt');
% data2=load('17_ns\class2.txt');
% data3=load('17_ns\class3.txt');
% data=cat(1,data1,data2,data3);

%Plotting Flag%
isPlot = 0;
%ROC Flag%
isROC=0;
%Outlier removal Flag%
outlier=0;
isDET = 0;
%Number of classes %
c=3;
%Number of samples in a class %
n=500; % 1000 for NLS
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
result{1}=zeros(0,3);
error{1}=zeros(0,1);
% Initializing Data %
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

% Calculating Mean and Covariance for different classes%
for k=1:c
    M(k,:)=mean(train{1,k},1);
    C_actual{1,k}=cov(train{1,k}(:,1),train{1,k}(:,2));
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
                [result{1,k},error{1,k}]=classify(test,M,C,p,0,0);
            end
            % Choosing best C based on Min. total error %
            [~,C_best_index(itr)]=min(sum([error{itr,1} error{itr,2} error{itr,3}],1));
            C_best{itr}=C_actual{1,C_best_index(itr)};
            
        case 2 % Bayes with Covariance different for all classes %
            C=C_actual;
            C_plot{itr,1}=C;
            [result{2,1},error{2,1}]=classify(test,M,C,p,0,0);
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
                    [result{3,ind},error{3,ind}]=classify(test,M,C,p,0,0);ind=ind+1;
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
                [result{4,k},error{4,k}]=classify(test,M,C,p,0,0);
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
            [result{5,1},error{5,1}]=classify(test,M,C,p,0,0);
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
            [result_ROC{k,ind},~]=classify(test,M,C_plot{k,C_best_index(k)},p,1,n);
            ind=ind+1;
        end
    end
end
% Data for DET %

if isDET == 1
    data_DET = zeros(300,10);
    data_DET(:,1)=lkhood(data(1:300,1:2),M(1,:),C_plot{1,1}{1,1});
    data_DET(:,2)=lkhood(data(501:800,1:2),M(1,:),C_plot{1,1}{1,1});
    data_DET(:,3)=lkhood(data(201:500,1:2),M(1,:),C_plot{2,1}{1,1});
    data_DET(:,4)=lkhood(data(701:1000,1:2),M(1,:),C_plot{2,1}{1,1});
    data_DET(:,5)=lkhood(data(201:500,1:2),M(1,:),C_plot{3,1}{1,1});
    data_DET(:,6)=lkhood(data(501:800,1:2),M(1,:),C_plot{3,1}{1,1});
    data_DET(:,7)=lkhood(data(101:400,1:2),M(1,:),C_plot{4,1}{1,1});
    data_DET(:,8)=lkhood(data(601:900,1:2),M(1,:),C_plot{4,1}{1,1});
    data_DET(:,9)=lkhood(data(151:450,1:2),M(1,:),C_plot{5,1}{1,1});
    data_DET(:,10)=lkhood(data(551:850,1:2),M(1,:),C_plot{5,1}{1,1});
    
    figure;
    hold on;
    N_plots = 5;
    plot_code = ['r' 'g','k','b','c'];
    
    % Plot the detection error trade-off
    for n=1:N_plots
        [P_miss,P_fa] = Compute_DET(data_DET(:,((n-1)*2)+1),data_DET(:,n*2));
        Plot_DET (P_miss,P_fa,plot_code(n));
    end
    title('DET Curve for Real World Data');
    hold off;
end

%Outlier Detection%
if outlier==1
    index=cellfun(@isempty,result);
    for k=1:size(index,1)
        for m=1:size(index,2)
            if index(k,m) == 1 break; end
            temp=lkhood(test,M(3,:),C_plot{k,m}{1,3});
            for q=1:size(result{k,m},1)
                if (result{k,m}(q,3)==3)
                    if temp(q)< 1e-08
                        result{k,m}(q,5)=1;
                    end
                end
            end
        end
    end
end

% Plotting Results %
if isPlot == 1
    index=cellfun(@isempty,result);
    for cs = 1 : 3
        for k=1:size(index,1)
            for m=1:size(index,2)
                if index(k,m) == 1 break; end
                switch cs
                    case 1
                        tit=sprintf('decisionSurface(%d, %d)',k,m);
                        figure('Name',tit);
                        decisionSurface(result{k,m},M,C_plot{k,m},3);
                        %savefig(['Fig\DS\' tit '.fig']);
                    case 2
                        tit=sprintf('decisionSurfaceWithGaussians(%d, %d)',k,m);
                        figure('Name',tit);
                        decisionSurfaceWithGaussians(result{k,m},M,C_plot{k,m},3);
                        %savefig(['Fig\G\' tit '.fig']);
                    otherwise
                        tit=sprintf('decisionSurfaceWithDensityCurves(%d, %d)',k,m);
                        figure('Name',tit);
                        decisionSurfaceWithDensityCurves(result{k,m},M,C_plot{k,m},3);
                        %savefig(['Fig\DC\' tit '.fig']);
                end
            end
        end
    end
end
