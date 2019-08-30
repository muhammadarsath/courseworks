function decisionSurface (data, mean, covariance, noOfClasses)
step = 599;
minx = min(data(:,1));
maxx = max(data(:,1));
miny = min(data(:,2));
maxy = max(data(:,2));
stepx = (maxx - minx) / step;
stepy = (maxy - miny) / step;
[mgx, mgy] = meshgrid(minx : stepx : maxx, miny : stepy : maxy);

mgxL = mgx(:);
mgyL = mgy(:);

likelihood = zeros(length(mgxL),noOfClasses);
for k = 1 : noOfClasses
    likelihood(:,k) = mvnpdf([mgxL mgyL], mean(k,:), covariance{1,k});
end
index = zeros(1, length(mgxL));
for i = 1 : length(mgxL)
    [~, index(i)] = max (likelihood(i,:));
end
if noOfClasses == 3
    gscatter(mgxL,mgyL,index,[0.84 .97 0.68; .62 0.76 .56; .62 .75 .8]);
    hold on;
    scatter(data(data(:,3)==1,1), data(data(:,3)==1,2), 40, 'MarkerEdgeColor',[.5 .5 0],...
        'MarkerFaceColor',[.82 0.90 .93],...
        'LineWidth',1.5);
    hold on;
    scatter(data(data(:,3)==2,1), data(data(:,3)==2,2), 40, 'MarkerEdgeColor',[.8 .5 .5],...
        'MarkerFaceColor',[0.99 .71 .85],...
        'LineWidth',1.5);
    hold on;
    scatter(data(data(:,3)==3,1), data(data(:,3)==3,2), 40, 'MarkerEdgeColor',[.5 .5 .5],...
        'MarkerFaceColor',[1 .91 0.92],...
        'LineWidth',1.5);
    
    title('{\bf Decision Region}');
    xlabel('Dimension 1');
    ylabel('Dimension 2');
    legend({'Observed 1','Observed 2','Observed 3','Class 1','Class 2','Class 3'}, 'Location','Best');
    axis tight;
    get(gca, 'XTick');
    set(gca, 'FontSize', 12);
    hold off;
end

end