function DTW_Isolated
machine = 'l';
pathStr='DTW_Isolated/17/';
trainPercent = .3;
filename= dir(pathStr);
filename = filename(~cellfun(@invalidFolders,{filename.name}));
digitcell =loadFilesDTW(pathStr,filename,'*',machine);
for i = 1 : size(digitcell,1)
    for j = 1 : ceil(size(digitcell,2)*trainPercent)
        trainData{i,j} = digitcell{i,j};
    end
end
for i = 1 : size(digitcell,1)
    for j = ceil(size(digitcell,2)*trainPercent) + 1 : size(digitcell,2)
        testData{i,j - ceil(size(digitcell,2)*trainPercent)} = digitcell{i,j};
    end
end
% len = fileLength(digitcell);
outputMatrix = zeros(size(testData));
outputDist = zeros(size(testData));
distance = [];
for i = 1 : size(testData, 1)
    for j = 1 : size(testData, 2)
        ['Calculating ' int2str(i) 'th class and ' int2str(j) 'th utterance']
        min = 1000;
        ind = 1000;
        for eachRef = 1 : size(trainData, 1)
            dist = DTW(trainData(eachRef, :), testData{i, j}, 0, 0);
            distance = [distance dist];
            if min > dist
                min = dist;
                ind = eachRef;
            end
        end
        outputMatrix(i, j) = ind;
        outputDist(i, j) = min;
    end
end
save('DTW_Result.mat','outputMatrix','outputDist','distance');
% outputMatrix
% outputDist
% distance
end


