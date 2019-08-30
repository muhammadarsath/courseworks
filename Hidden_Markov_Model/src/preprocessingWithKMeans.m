function [sequence, means] = preprocessingWithKMeans(data, K, means, toCluster)
%Here assumption is number of cluster being 2
%Cluster centroid locations, returned as a numeric matrix. C is a k-by-p matrix, where row j is the centroid of cluster j.

sequence = [];
if toCluster == 1
    [~,c] = kmeans(data, K ,'display','iter');
    means = c;
else
    [idx,~] = kmeans(data, K ,'display','iter', 'MaxIter',1,'Start',means);
    sequence = idx;
end
end