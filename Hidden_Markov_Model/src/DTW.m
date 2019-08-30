function distance = DTW(trainData, testSeq, startInd, windowLength)
if startInd == 0
    startInd = 1;
end
if windowLength == 0
    windowLength = length(testSeq);
end
if windowLength > length(testSeq)
    distance = 10000;
else
    distance = 0;
    for i = 1  : length(trainData)
        distance = distance + computeDTWDist(trainData{i}, testSeq, startInd, windowLength);
    end
    distance = distance / length(trainData);
end
end