clc;
clear variables;
filename1= dir('features_image\1_coast\*.jpg_color_edh_entropy');
filename2= dir('features_image\2_mountain\*.jpg_color_edh_entropy');
filename3= dir('features_image\3_forest\*.jpg_color_edh_entropy');
rng(1);
%No. of classes
c=3;
class{c+1}={};
%Load Data
isLoadData=1;
%Tnorm Flag
Tn=0;
%Znorm Flag
Zn=0;
%DET and ROC Flag
Dnr=0;
tr=0.7;
te=0.3;
test=zeros(0,23);
%Load data from the files
if isLoadData==1
    for k=1:size(filename1,1)
        fname=strcat('features_image\1_coast\',filename1(k).name);
        class{1}=[class{1}; importdata(fname)];
    end
    for k=1:size(filename2,1)
        fname=strcat('features_image\2_mountain\',filename2(k).name);
        class{2}=[class{2}; importdata(fname)];
    end
    for k=1:size(filename3,1)
        fname=strcat('features_image\3_forest\',filename3(k).name);
        class{3}=[class{3}; importdata(fname)];
    end
    save('class_data.mat','class');
else
    load('class_data.mat');
end
class{1}=[class{1} ones(size(class{1},1),1)];
class{2}=[class{2} ones(size(class{2},1),1)*2];
class{3}=[class{3} ones(size(class{3},1),1)*3];
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
        [km_c,km_m]=preprocessingWithKMeans(train{j}(:,1:23),k,0);
        M{j,k}=km_m;
        for q=1:k
            S{j,k}{1,q}=eye(23);
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
                G(:,q)=P{j,k}(q)*lkhood(train{j}(:,1:23),M{j,k}(q,:),S{j,k}{1,q});
            end
            temp=(sum(G,2));
            G=G ./ repmat(temp,1,k);
            %Calculate Nk %
            N_K=sum(G,1);
            P{j,k}=N_K/n;
            %Calc Mean,Sigma%
            for q=1:k
                co{q}=zeros(23,23);
                M{j,k}(q,:)=sum([repmat(G(1:n,q),1,23).*train{j}(:,1:23)],1)/N_K(q);
                %Find Covariance matrix
                for r=1:n
                    temp= train{j}(r,1:23)-M{j,k}(q,:);
                    co{q}=co{q}+(G(r,q)*(temp'*temp));
                end
                co{q}=co{q}./N_K(q);
            end
            S{j,k}=co;
            try
                jumper = 0;
                %Calculating log likelihood%
                for q=1:k
                    tmp(:,q)=(P{j,k}(q))*lkhood(train{j}(:,1:23),M{j,k}(q,:),S{j,k}{1,q});
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
%Data classification%
[L_Test,index,final_val]=classifyGMM(test,M,S,P);


%T-Norm%
if Tn==1
    for q=1:3
        Tn(:,q)=sum(L_Test{q,index(q)},2);
    end
    TMean=mean(Tn(:));
    Tstd=std(Tn(:));
    Tnorm=(Tn-TMean)/Tstd;
    [mx,Ind]=max(Tnorm,[],2);
    NoOfClassification=sum(test(:,24)-Ind==0);
end

%Z-Norm%
if Zn==1
    for q=1:3
        Mu(1,q) =mean(sum(L_Test{1,q},2),1);
        Sig(1,q)=std(sum(L_Test{1,q  },2));
    end
    for q=1:3
        final_lk(:,q)=(sum(L_Test{q,index(q)},2)-Mu(1,q))/Sig(1,q) ;
    end
    [mx,ind]=max(final_lk,[],2);
end

if DnR==1
    %Loading Data as chunks and classifying%
    numberOfImagestoLoad = 54;
    for k=1:numberOfImagestoLoad
        fname=strcat('features_image\1_coast\',filename1(k).name);
        class_chunks{1,k}=importdata(fname);
    end
    for k=1:numberOfImagestoLoad
        fname=strcat('features_image\2_mountain\',filename2(k).name);
        class_chunks{2,k}=importdata(fname);
    end
    for k=1:numberOfImagestoLoad
        fname=strcat('features_image\3_forest\',filename3(k).name);
        class_chunks{3,k}=importdata(fname);
    end
    index=[2 2 2];
    for j=1:3
        for k=1:54
            for q=1:index(j)
                result_chunks1{j,k}(:,q)=P{j,index(j)}(q)*lkhood(class_chunks{1,k},M{j,index(j)}(q,:),diag(diag(S{j,index(j)}{1,q})));
            end
            result_chunks1{4,k}(:,j)=sum(result_chunks1{j,k},2);
            if j==3
                [~,ind]=max(result_chunks1{4,k},[],2);
                result_chunks1{4,k}(:,4)=ind;
                [~,mx]=max(histc(ind,1:3));
                result_chunks1{5,k}=mx;
            end
        end
    end
    sum(cell2mat(result_chunks1(5,:))==1)
    
    
    %DET Plot%
    ROC_index=[2 3 5 8 10];
    for m=1:3
        for j=1:numberOfImagestoLoad
            for k=1:size(ROC_index,2)
                for q=1:ROC_index(k)
                    ROC_lk{1,m}{k,j}(:,q)= P{1,ROC_index(k)}(q)*lkhood(class_chunks{m,j},M{1,ROC_index(k)}(q,:),diag(diag(S{1,ROC_index(k)}{1,q})));
                end
                ROC_lk{1,m}{6,k}(:,j)=sum(ROC_lk{1,m}{k,j},2);
                if j==54
                    ROC_lk{1,m}{7,k}=mean(ROC_lk{1,m}{6,k},1);
                end
            end
        end
    end
    for j=1:3
        for k=1:5
            sm=sum(ROC_lk{1,1}{7,k},2)+sum(ROC_lk{1,2}{7,k},2)+sum(ROC_lk{1,3}{7,k},2);
            for q=1:size(ROC_lk{1,j}{7,1},2)
                ROC_lk{1,j}{7,k}(1,q)=ROC_lk{1,j}{7,k}(1,q)/sm;
            end
        end
    end
    for k=1:5
        ind=1;
        for n=1:-0.0001:0
            result = zeros(size(ROC_lk{1,1}{7,1},2),2);
            for q=1:size(ROC_lk{1,1}{7,1},2)
                if ROC_lk{1,1}{7,k}(1,q)>=n
                    result(q,1)=1;
                else
                    result(q,1)=0;
                end
                
                if ROC_lk{1,3}{7,k}(1,q)>=n || ROC_lk{1,2}{7,k}(1,q)>=n
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
            predictedFalseIter = (result_ROC{i, iter}(:,2) == 2);
            targetTrue = 54;
            targetFalse = 54;
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
