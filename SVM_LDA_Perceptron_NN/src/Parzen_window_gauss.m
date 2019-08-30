clc;
clear variables;
path='ImageData\Features\';
filename1= dir('ImageData\Features\1_coast\*.jpg_color_edh_entropy');
filename2= dir('ImageData\Features\2_mountain\*.jpg_color_edh_entropy');
filename3= dir('ImageData\Features\3_forest\*.jpg_color_edh_entropy');
%Setting Seed
rng(5977);
%No. of classes
c=3;
class{c+1}={};
%Load Data
isLoadData=0;
%Data Normalization
normalize=1;
isGaussianKernel = 1;
%Train Test ratio
tr=0.7;
te=0.3;
dim=23;
%Feature vectors per image
fvect=36;
test=zeros(0,23);

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
if normalize==1
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

%Separating Test and Train data%
for k=1:c
    n=size(class{k},1);
    sz=mod((tr*n),fvect);
    sz=tr*n-sz;
    train{k}=class{k}(1:sz,:);
    train{k}=train{k}([randperm(sz)],:);%shuffling train data
    test=[test ; class{k}(sz+1:n,:)];
end

%Gaussian Kernel density Estimator
tic
test_rows=size(test,1);
ind=1;
for itr=0.02:0.02
    if isGaussianKernel == 1
        h=itr*eye(23);% h chosen empirically
    else
        h=itr*ones(1,dim);% h for cubic kernel
    end
    Px=[];
    for k=1:test_rows
        for j=1:c
            if isGaussianKernel == 1
                Px(k,j)=gaussKernel(test(k,1:23),train{j}(:,1:23),h);%gaussian as window region
            else
                Px(k,j)=cubicKernel(test(k,1:23),train{j}(:,1:23),h);%Cube as window region
            end
        end
    end
    [~,Px(:,4)]=max(Px,[],2);
    
    %Voting method
    voteCount=reshape(Px(:,4),fvect,[]);
    [~,voteCount(fvect+1,:)]=max([sum(voteCount==1,1) ;sum(voteCount==2,1) ;sum(voteCount==3,1)],[],1);
    finalCount(ind)=sum([voteCount(fvect+1,1:108)==1 voteCount(fvect+1,109:221)==2 voteCount(fvect+1,222:end)==3]);ind=ind+1;
end
toc