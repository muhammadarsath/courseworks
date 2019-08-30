function means = preprocessingWithKMeans(data, K, means, toCluster)
%Here assumption is number of cluster being 2
%Cluster centroid locations, returned as a numeric matrix. C is a k-by-p matrix, where row j is the centroid of cluster j.

if toCluster == 1
    [~,c] = kmeans(data, K ,'display','off');
    means = c;
else
    [~,c] = kmeans(data, K ,'display','off', 'MaxIter',1,'Start',means);
    means = c;
end

end