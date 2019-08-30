function conf(target, classified, noOfClasses)
targetMatrix = oneHotMatrix(target, noOfClasses);
classifiedMatrix = oneHotMatrix(classified, noOfClasses);
plotconfusion(targetMatrix, classifiedMatrix);
end