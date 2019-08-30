clc;
clear variables;
pathstr='HandWritten_data\DATA\testFeatures\';
data=loadFilesHandwritten(pathstr,'txt');
isFeatureExtracted = 0;

for k=1:size(data,1)
    for j=1:size(data,2)
        data_2d{k,j}=reshape(data{k,j},2,size(data{k,j},2)/2);
    end
end
data_sz=cellfun('length',data_2d);
max_dim=max(max(data_sz,[],2));
for k=1:size(data_2d,1)
    for j=1:size(data_2d,2)
        curr_sz=data_sz(k,j);
        data_2d_new{k,j}=data_2d{k,j};
        if curr_sz==0
            break;
        end
        for x=1:1:(max_dim-curr_sz)
            temp_data=data_2d_new{k,j};
            temp_sz=length(temp_data);
            R = randi([2 temp_sz-1],1,'double');%Getting random index and adding entry
            new_entry(1)=(temp_data(1,R-1)+temp_data(1,R))/2;
            new_entry(2)=(temp_data(2,R-1)+temp_data(2,R))/2;
            data_2d_new{k,j}=[temp_data(1:2,1:R-1) new_entry' temp_data(1:2,R:end)];
        end
    end
end

if isFeatureExtracted == 1
    data_2d_new=extractFeatures(data_2d_new);
end

dataToClassify = [];
labelToClassify = [];
iter = 1;
for i = 1 : size(data_2d_new,1)
    for j = 1 : size(data_2d_new,2)
        if isempty(cell2mat(data_2d_new(i,j))) == 0
            foo = cell2mat(data_2d_new(i,j));
            dataToClassify(iter,:) = foo(:)';
            labelToClassify(iter) = i;
            iter = iter + 1;
        end
    end
end

save('HandWritten_data\DATA\ExtrapolatedData.mat', 'dataToClassify', 'labelToClassify');
