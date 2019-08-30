function [result_comp, filenames, generatedModels] = hmmTestWrapper
%path = 'sequence/character/final/';
%path = 'sequence/character/curvature/';
% path = 'sequence/character/slope/';
path = 'sequence/digit/';
% path = 'sequence/digit/global/';
str=strcat(path, 'test*.txt');
filenames=dir(str);
strHMM=strcat(path, '*.hmm');
filenamesHMM=dir(strHMM);
generatedModels = {};
for i = 1 : length(filenamesHMM)
    generatedModels{i} = cell2mat(regexp(cell2mat(regexp(filenamesHMM(i).name, '_[1-9a-zA-Z0]*_', 'match')), '[1-9a-zA-Z0]', 'match'));
end
generatedModels = unique(generatedModels);
for i = 1 : length(filenames)
    logLikelihood = [];
    symbols = cell2mat(regexp(cell2mat(regexp(filenames(i).name, '_[1-90]*.txt', 'match')), '[1-90]*', 'match'));
    for j = 1 : length(generatedModels)
        trainModel = [path 'train_' char(generatedModels(j)) '_' symbols '.txt.hmm'];
        testFile = [path filenames(i).name];
        logLikelihood = [logLikelihood hmmTest(testFile, trainModel)];
    end
    result{i} = logLikelihood;
end
s=length(filenames)/3;
mx=max([size(result{1},1),size(result{1*s+1},1),size(result{2*s+1},1)]);
for k=1:s
    [~,result_comp{1,k}(:,1)]=max(result{1,k},[],2);
    [~,ind1]=max(result{1,(1*s+k)},[],2);
    result_comp{1,k}(:,2)=padarray(ind1,mx-size(ind1,1),0,'post');
    [~,ind2]=max(result{1,(2*s+k)},[],2);
    result_comp{1,k}(:,3)=padarray(ind2,mx-size(ind2,1),0,'post');
    result_comp{2,k} = sum(result_comp{1,k}(:,1)==1) + sum(result_comp{1,k}(:,2)==2) + sum(result_comp{1,k}(:,3)==3);
end

end