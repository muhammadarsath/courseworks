function [result_comp, filenames, generatedModels] = hmmTestWrapperConnected
%path = 'sequence/digit/';
%path = 'sequence/character/curvature/';
% path = 'sequence/character/slope/';
path = 'sequence/digit/connected_txt/';
% path = 'sequence/digit/global/';
str=strcat(path, '*.txt');
filenames=dir(str);
strHMM=strcat(path, '*.hmm');
filenamesHMM=dir(strHMM);
for i = 1 : length(filenames)
    logLikelihood = [];
    for j = 1 : length(filenamesHMM)
        trainModel = [path filenamesHMM(j).name];
        testFile = [path filenames(i).name];
        logLikelihood = [logLikelihood hmmTest(testFile, trainModel)];
    end
    result{i} = logLikelihood;
end

for k=1:length(filenames)
    [~,result{2,k}]=max(result{1,k},[],2);
end

end