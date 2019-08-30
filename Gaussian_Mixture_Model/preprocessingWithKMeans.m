function [classCell, means] = preprocessingWithKMeans(data, K, showPlots)
%Here assumption is number of cluster being 2
dimension = size(data,2);

if dimension ~= 2 && showPlots == 1
    ME = MException('showPlot works in 2D');
    throw(ME)
end

[idx,c] = kmeans(data, K ,'display','iter');

if showPlots == 1
    scatter(x,y);
    for i = 1 : K
        hold on;
        scatter(c(K,1),c(K,2), 40, 'MarkerEdgeColor',[.5 .5 0],...
            'MarkerFaceColor',[.82 0.90 .93],...
            'LineWidth',1.5);
    end
    title('Means');
    figure;
end

classCell{K} = 0;

for i = 1 : K
    result = [];
    for j = 1 : dimension
        result(:,j) = data(idx == i, j);
    end
    
    if showPlots == 1
        labelx = result(:,1);
        labely = result(:,2);
        hold on;
        scatter(labelx,labely, 40, 'MarkerEdgeColor',[.5 .5 0],...
            'MarkerFaceColor',[.82 0.90 .93],...
            'LineWidth',1.5);
        title('Clusters');
    end
    classCell{i} = result;
end
means = c;
end