clc;
clear variables;
path='ImageData\Features\';
filename1= dir('ImageData\Features\1_coast\*.jpg_color_edh_entropy');
filename2= dir('ImageData\Features\2_mountain\*.jpg_color_edh_entropy');
filename3= dir('ImageData\Features\3_forest\*.jpg_color_edh_entropy');
%Setting Seed
rng(1);
%No. of classes
c=3;
class{c+1}={};
%Dimension of projection space
p=c-1;
%Load Data
isLoadData=0;
%Train Test ratio
tr=0.7;
te=0.3;
dim=23;
%Feature vectors per image
fvect=36;
PCA=0;
test=zeros(0,23);
isNormalize = 1;

%Load data from the files
if isLoadData==1
    for k=1:size(filename1,1)
        fname=strcat(path,'1_coast\',filename1(k).name);
        class{1}=[class{1}; importdata(fname)];
    end
    for k=1:size(filename2,1)
        fname=strcat(path,'2_mountain\',filename2(k).name);
        class{2}=[class{2}; importdata(fname)];
    end
    for k=1:size(filename3,1)
        fname=strcat(path,'3_forest\',filename3(k).name);
        class{3}=[class{3}; importdata(fname)];
    end
    save('class_data.mat','class');
else
    load('class_data.mat');
end

%Data normalization
if isNormalize == 1
    tp=vertcat(class{1},class{2},class{3});
    sz=size(tp,1);
    M_train=mean(tp,1);
    S_train=std(tp,0,1);
    for k=1:c
        sz=size(class{k},1);
        class{k}=(class{k}-repmat(M_train,sz,1))./repmat(S_train,sz,1);
    end
end

%Appending class label
class{1}=[class{1} ones(size(class{1},1),1)];
class{2}=[class{2} ones(size(class{2},1),1)*2];
class{3}=[class{3} ones(size(class{3},1),1)*3];

%Shuffling data%
for k=1:c
    n=size(class{k},1)
    data{k}=class{k};
end

%PCA on dataset
if PCA==1
    dim=18;
    d=vertcat(data{:});
    cv=cov(d(:,1:23));
    [U,S,V]=svd(cv);
    W=U(:,1:dim)';
    for k=1:size(d,1)
        data_PCA(k,:)=W*d(k,1:23)';
    end
    data_size=cellfun ('length',data);
    offset=0;
    data={};
    for k=1:c
        data{k}=data_PCA(offset+1:offset+data_size(k),:);
        data{k}=[data{k} ones(size(data{k},1),1)*k];
        offset=data_size(k);
    end
end

%Separating Test and Train data%
for k=1:c
    n=size(class{k},1);
    sz=mod((tr*n),fvect);
    sz=tr*n-sz;
    train{k}=data{k}(1:sz,:);
    train{k}=train{k}([randperm(sz)],:);%shuffling train data
    test=[test ; data{k}(sz+1:n,:)];
end

%Compute S_W and S_B
temp=vertcat(train{:});
totalMean=mean(temp(:,1:dim),1);
S_W=0;
S_B=0;
for k=1:c
    classMean(k,:)=mean(train{k}(:,1:dim),1);
    for j=1:size(train{k},1)
        sample1=(train{k}(j,1:dim)-classMean(k,:));
        S_W=S_W+(sample1'*sample1);
    end
    S_B=S_B+size(train{k},1)*(classMean(k,:)-totalMean)'*(classMean(k,:)-totalMean);
end

%Compute S_W^(-1)*S_B
A=inv(S_W)*S_B;
%Compute Eigen values and Eigen vectors
[eigvec,eigval]=eig(A);
%Formation of projection matrix
v=diag(eigval);
X=eigvec(:,1:p);
%Eigen recontruction of W from A
pMatrix=X';
%Projection of test data into 2 dimensional space
for k=1:size(test,1)
    result_test(k,:)=pMatrix*test(k,1:dim)';
end
for k=1:size(temp,1)
    result_train(k,:)=pMatrix*temp(k,1:dim)';
end

%Classify using KNN
group=temp(:,dim+1);
knn=knnclassify(result_test,result_train,group,5);
classifyKNN=sum(vertcat((knn(1:3888)==1),(knn(3889:7956)==2),(knn(7957:end)==3)));
%Voting method
voteCountKNN=reshape(knn,fvect,[]);
[~,voteCountKNN(fvect+1,:)]=max([sum(voteCountKNN==1,1) ;sum(voteCountKNN==2,1) ;sum(voteCountKNN==3,1)],[],1);
finalCountKNN=sum([voteCountKNN(fvect+1,1:108)==1 voteCountKNN(fvect+1,109:221)==2 voteCountKNN(fvect+1,222:end)==3]);

%Classify using Bayesian
rows=[0 9072 18468 26712];
for k=1:c
    prior(k)=size(train{k},1)/size(temp,1);
    projMean(k,:)=mean(result_train(rows(k)+1:rows(k+1),:),1);
    cMatix{k}=cov(result_train(rows(k)+1:rows(k+1),1),result_train(rows(k)+1:rows(k+1),2));
end
final=classify(result_test,projMean,cMatix,prior,0,0);
classifyBayes=sum(vertcat((final(1:3888,3)==1),(final(3889:7956,3)==2),(final(7957:end,3)==3)));
%Voting method
voteCount=reshape(final(:,3),fvect,[]);
[~,voteCount(fvect+1,:)]=max([sum(voteCount==1,1) ;sum(voteCount==2,1) ;sum(voteCount==3,1)],[],1);
finalCount=sum([voteCount(fvect+1,1:108)==1 voteCount(fvect+1,109:221)==2 voteCount(fvect+1,222:end)==3]);
