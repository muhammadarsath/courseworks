function hmmTrainAutomate
NStates = 2;
threshold = 0.1;
%path = 'sequence/character/final/';
%path = 'sequence/character/curvature/';
%path = 'sequence/character/slope/';
path = 'sequence/digit/';
%path = 'sequence/digit/global/';
str=strcat(path, 'train*.txt');
filenames=dir(str);
for i = 1 : length(filenames)
    symbols = cell2mat(regexp(cell2mat(regexp(filenames(i).name, '_[1-90]*.txt', 'match')), '[1-90]*', 'match'));
    hmmTrain([path filenames(i).name], NStates, str2double(symbols), threshold);
end
[result,files,~] = hmmTestWrapper;
%save('Foo.mat','result');
end