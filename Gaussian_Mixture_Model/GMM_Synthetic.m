clc;
clear variables;
rng(1);
%No. of classes
c=2;
tr=0.7;
te=0.3;
test=zeros(0,2);
%DET and ROC Flag
DnR=0;
%Load Data
class{1}=load('features_synthetic\class1.txt');
class{2}=load('features_synthetic\class2.txt');
class{1}=[class{1} ones(size(class{1},1),1)];
class{2}=[class{2} ones(size(class{2},1),1)*2];
%Shuffling data%
for k=1:c
    n=size(class{k},1)
    data{k}=class{k}([randperm(n)],:);
end
%Separating Test and Train data%
for k=1:c
    n=size(class{k},1)
    train{k}=data{k}(1:tr*n,:);
    test=[test ; data{k}(floor(tr*n)+1:n,:)];
end
% Shuffling test data across the class %
test=test(randperm(int16(size(test,1))),:);
%Trainig model with 3 clases%
for j=1:c
    n=size(train{j},1);
    for k=2:30
        [km_c,km_m]=preprocessingWithKMeans(train{j}(:,1:2),k,0);
        M{j,k}=km_m;
        for q=1:k
            S{j,k}{1,q}=eye(2);
        end
        P{j,k}=repmat(1/k,1,k);
        G=zeros(n,k);
        prev_lk=0;count=0;
        curr_lk=1000;
        tmp = [];
        co={};
        while(count<10 && difference(curr_lk,prev_lk,1)>1)
            prev_lk=curr_lk;count=count+1;
            for q=1:k
                G(:,q)=P{j,k}(q)*lkhood(train{j}(:,1:2),M{j,k}(q,:),S{j,k}{1,q});
            end
            temp=(sum(G,2));
            G=G ./ repmat(temp,1,k);
            %Calculate Nk %
            N_K=sum(G,1);
            P{j,k}=N_K/n;
            %Calc Mean,Sigma%
            for q=1:k
                co{q}=zeros(2,2);
                M{j,k}(q,:)=sum([repmat(G(1:n,q),1,2).*train{j}(:,1:2)],1)/N_K(q);
                %Find Covariance matrix
                for r=1:n
                    temp= train{j}(r,1:2)-M{j,k}(q,:);
                    co{q}=co{q}+(G(r,q)*(temp'*temp));
                end
                co{q}=co{q}./N_K(q);
                if(~isempty(find(sign(eig(co{q}))<0, 1)))
                end
            end
            S{j,k}=co;
            try
                jumper = 0;
                %Calculating log likelihood%
                for q=1:k
                    tmp(:,q)=(P{j,k}(q))*lkhood(train{j}(:,1:2),M{j,k}(q,:),S{j,k}{1,q});
                end
            catch Exception
                M{j,k} = [];
                S{j,k} = {};
                P{j,k}= [];
                jumper = 1;
                break;
            end
            temp=(sum(tmp,2));
            curr_lk=sum(log(temp));
            t=1;
        end
        if jumper == 1
            break;
        end
    end
end
[index,final_val]=classifyGMM_synthetic(test,M,S,P);

%DET and Roc Plot
if DnR==1
    ROC_index=[2 3 5 10 15];
    for j=1:1
        for k=1:size(ROC_index,2)
            for q=1:ROC_index(k)
                ROC_lk{k,1}(:,q)= P{1,ROC_index(k)}(q)*lkhood(ROCdata(1:600,1:2),M{1,ROC_index(k)}(q,:),(S{1,ROC_index(k)}{1,q}));
                ROC_lk{k,2}(:,q)= P{1,ROC_index(k)}(q)*lkhood(ROCdata(601:1200,1:2),M{1,ROC_index(k)}(q,:),S{1,ROC_index(k)}{1,q});
            end
            ROC_lk{6,1}(:,k)=sum(ROC_lk{k,1},2);
            ROC_lk{6,2}(:,k)=sum(ROC_lk{k,2},2);
        end
    end
    minimum = min(min([ROC_lk{6,1} ROC_lk{6,2}]));
    maximum = max(max([ROC_lk{6,1} ROC_lk{6,2}]));
    ROC_lk{6,1} = (ROC_lk{6,1}-minimum)/(maximum-minimum);
    ROC_lk{6,2} = (ROC_lk{6,2}-minimum)/(maximum-minimum);
    figure;
    hold on;
    
    %-----------------------
    % Create simulated detection output scores
    N_plots = 5;
    plot_code = ['r' 'g' 'k' 'b' 'm'];
    %-----------------------
    % Plot the detection error trade-off
    for n=1:N_plots
        [P_miss,P_fa] = Compute_DET(ROC_lk{6,1}(:,n),ROC_lk{6,2}(:,n));
        Plot_DET (P_miss,P_fa,plot_code(n));
    end
    legend({'K = 2','K = 3','K = 5','K = 10','K = 15'}, 'Location','Best');
    get(gca, 'XTick');
    set(gca, 'FontSize', 12);
    echo off;
    for k=1:5
        ind=1;
        for n=1:-0.0001:0
            result = zeros(1,2);
            for q=1:size(ROC_lk{6,1}(:,k),1)
                if ROC_lk{6,1}(:,k)>=n
                    result(q,1)=1;
                else
                    result(q,1)=0;
                end
                if ROC_lk{6,2}(:,k)>=n
                    result(q,2)=2;
                else
                    result(q,2)=0;
                end
            end
            result_ROC{k,ind}=result;
            ind=ind+1;
        end
    end
    %ROC Plot
    cases = 5;
    noOfIter = length(1:-0.0001:0);
    line = [0 : 0.1 : 1; 0 : 0.1 : 1]';
    legendCell{1} = 'Bad Case';
    figure;
    plot(line(:,1), line(:,2), 'k--');
    for i = 1 : cases
        TPR = zeros(noOfIter,1);
        FPR = zeros(noOfIter,1);
        for iter = 1 : noOfIter
            %pred = predicted{i, iter}(:,4);
            predictedTrueIter = result_ROC{i, iter}(:,1) == 1;
            predictedFalseIter = (result_ROC{i, iter}(:,2) == 1);
            targetTrue = 600;
            targetFalse = 600;
            TPR(iter) = sum(predictedTrueIter)/sum(targetTrue);
            FPR(iter) = sum(predictedFalseIter)/sum(targetFalse);
        end
        hold on;
        plot(FPR(:), TPR(:), 'LineWidth',2);
        legendCell{cases - i +2} = ['Case ' num2str(i)];
    end
    legend(legendCell, 'Location','Best');
    xlabel('False Positive Rate (FPR)');
    ylabel('True Positive Rate (TPR)');axis tight;
    get(gca, 'XTick');
    set(gca, 'FontSize', 12);
    set(gca, 'ZTick',[]);
    hold off;
end