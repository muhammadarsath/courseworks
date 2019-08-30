function classCell = preprocessingWithKMeans(data, K, showPlots)
%Here assumption is number of cluster being 2

x = data(:,1);
y = data(:,2);
[idx,c] = kmeans([x y], K ,'display','iter');
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
    labelx = x(idx == i);
    labely = y(idx == i);    
    if showPlots == 1
        hold on;
        scatter(labelx,labely, 40, 'MarkerEdgeColor',[.5 .5 0],...
            'MarkerFaceColor',[.82 0.90 .93],...
            'LineWidth',1.5);
        title('Clusters');
    end
    classCell{i} = [labelx labely];
end
end