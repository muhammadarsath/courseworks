function distance =  computeDTWDist(referenceSeq, testSeq, startInd, windowLength)

lastFrame = startInd + windowLength - 1;

DTWMatrix = zeros(length(referenceSeq)+1, lastFrame+1);
DTWMatrix(1, :) = repmat(1000, 1, lastFrame + 1);
DTWMatrix(:, 1) = repmat(1000, length(referenceSeq) + 1, 1);

if lastFrame > length(testSeq)
    distance = 10000;
else
    
    for i = 1 : length(referenceSeq)
        for j = startInd : lastFrame
            
            temp = sum(sqrt((referenceSeq(i,:) - testSeq(j,:)) .^ 2));
            DTWMatrix(i+1 ,j+1) = temp + min(min(DTWMatrix(i, j),DTWMatrix(i, j+1)),DTWMatrix(i+1, j));
        end
    end
    
    DTWMatrix(length(referenceSeq)+1, lastFrame+1) = DTWMatrix(length(referenceSeq)+1, lastFrame+1)/(length(referenceSeq));
    distance = DTWMatrix(length(referenceSeq)+1, lastFrame+1);
end
end