function newData = dataNormalization(data)
dataMean = mean(data);
dataStd = std(data);
newData = (data - repmat(dataMean, length(data), 1))./repmat(dataStd, length(data), 1);
end