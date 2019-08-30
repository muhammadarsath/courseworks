function DTW_Conti
machine = 'l';
verificationPathStr = 'DigitRecog/connected/test1/17/';
testPathStr = 'DigitRecog/connected/test2/17/';
trainPathStr='DTW_Isolated/17/';
isVerification = 1;
filename= dir(trainPathStr);
filename = filename(~cellfun(@invalidFolders,{filename.name}));
trainData = loadFilesDTW(trainPathStr,filename,'*',machine);
len = fileLength(trainData);
if isVerification == 1
    [testData, groundTruth] = loadFilesDTWConti(verificationPathStr,filename,'*',machine);
    result = cell(length(testData),1);
    parfor j = 1 : length(testData)
        startFrame = 1;
        distMatrix = ones(size(trainData,1), 1) * 10000;
        windowObtained = zeros(size(trainData,1), 1);
        while length(testData{j}) - startFrame + 1 > min(len)/4
            for i = 1 : size(trainData,1)
                ['Calculating test ' int2str(j) 'with ref ' int2str(i)]
                distSoFar = 10000;
                winIndex = 10000;
                for k = ceil(len(i)/4) : ceil(len(i)*1.5)
                    temp = DTW(trainData(i,:), testData{j}, startFrame, k);
                    if distSoFar > temp
                        distSoFar = temp;
                        winIndex = k;
                    end
                    
                end
                distMatrix(i) = distSoFar;
                windowObtained(i) = winIndex;
                
            end
            localMin = 10000;
            choosen = 10000;
            for i = 1 : size(trainData,1)
                if localMin > distMatrix(i)
                    localMin = distMatrix(i);
                    choosen = i;
                    startFrame = startFrame + windowObtained(i);
                end
            end
            if localMin == 10000
                break;
            end
            result{j} = [result{j} int2str(choosen)];
            
        end
    end
    %     result
    
    
end

end