function [matrix] = oneHotMatrix(vector, noOfClasses)
matrix = zeros(noOfClasses, length(vector));
for iter = 1:noOfClasses
    row = (iter == vector);
    matrix(iter,:) = row;
end
end