function decisionSurfaceWithDensityCurves (data, mean, covariance, noOfClasses)
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
    %gscatter(mgxL,mgyL,index,[0.99 .46 0.52; .39 0.27 .43; 0.99 .71 .85]);
    %gscatter(mgxL,mgyL,index,[0.99 .46 0.52; .82 0.90 .93; 0.99 .71 .85]);
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
    hold on
    
    
    % [n,c] = hist3([data(data(:,3)==1,1), data(data(:,3)==1,2)]);
    % contour(c{1},c{2},n)
    
    mu = mean(1,:);
    Sigma = covariance{1,1};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    %contour(x1, x2, F, [.0001 .001 .01 .05:.1:.95 .99 .999 .9999], 'ShowText', 'on', 'LineWidth', 2);
    contour(x1, x2, F,[1e-06 1.5e-06 4e-06 2.5e-06], 'ShowText', 'on', 'LineWidth', 2);
    
    mu = mean(2,:);
    Sigma = covariance{1,2};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    %contour(x1, x2, F, [.0001 .001 .01 .05:.1:.95 .99 .999 .9999], 'ShowText', 'on', 'LineWidth', 2);
    contour(x1, x2, F,[1.5e-06 4e-06 3.5e-06 5e-06], 'ShowText', 'on', 'LineWidth', 2);
    
    
    
    mu = mean(3,:);
    Sigma = covariance{1,3};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    %contour(x1, x2, F, [.0001 .001 .01 .05:.1:.95 .99 .999 .9999], 'ShowText', 'on', 'LineWidth', 2);
    contour(x1, x2, F,[1.5e-06 4e-06 3.5e-06 2.5e-06], 'ShowText', 'on', 'LineWidth', 2);
    
    
    title('{\bf Decision Region with Density Curves}');
    xlabel('Dimension 1');
    ylabel('Dimension 2');
    legend({'Observed 1','Observed 2','Observed 3','Class 1','Class 2','Class 3'}, 'Location','Best');
    axis tight;
    get(gca, 'XTick');
    set(gca, 'FontSize', 12);
    hold off;
    
elseif noOfClasses == 5
    %gscatter(mgxL,mgyL,index,[0.99 .46 0.52; .39 0.27 .43; 0.99 .71 .85]);
    %gscatter(mgxL,mgyL,index,[0.99 .46 0.52; .82 0.90 .93; 0.99 .71 .85]);
    gscatter(mgxL,mgyL,index,[231/255 226/255 216/255; 202/255 182/255 168/255; 74/255 98/255 94/255; 133/255 170/255 162/255; 186/255 209/255 204/255]);
    
    hold on;
    scatter(data(data(:,4)==1,1), data(data(:,4)==1,2), 40, 'MarkerEdgeColor',[.5 .5 0],...
        'MarkerFaceColor',[174/255 101/255 138/255],...
        'LineWidth',1.5);
    hold on;
    scatter(data(data(:,4)==2,1), data(data(:,4)==2,2), 40, 'MarkerEdgeColor',[.8 .5 .5],...
        'MarkerFaceColor',[240/255 225/255 234/255],...
        'LineWidth',1.5);
    hold on;
    scatter(data(data(:,4)==3,1), data(data(:,4)==3,2), 40, 'MarkerEdgeColor',[.5 .5 .5],...
        'MarkerFaceColor',[87/255 80/255 102/255],...
        'LineWidth',1.5);
    hold on
    scatter(data(data(:,4)==4,1), data(data(:,4)==4,2), 40, 'MarkerEdgeColor',[.5 .5 0],...
        'MarkerFaceColor',[147/255 165/255 214/255],...
        'LineWidth',1.5);
    hold on;
    scatter(data(data(:,4)==5,1), data(data(:,4)==5,2), 40, 'MarkerEdgeColor',[.5 .5 .5],...
        'MarkerFaceColor',[234/255 230/255 247/255],...
        'LineWidth',1.5);
    hold on;
    
    
    % [n,c] = hist3([data(data(:,3)==1,1), data(data(:,3)==1,2)]);
    % contour(c{1},c{2},n)
    
    mu = mean(1,:);
    Sigma = covariance{1,1};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    contour(x1, x2, F, [0.004 0.006 0.01 0.014 0.016], 'ShowText', 'on', 'LineWidth', 2);
    %contour(x1, x2, F,[5e-07 1e-06 2e-06 4.5e-06], 'ShowText', 'on', 'LineWidth', 2);
    
    mu = mean(2,:);
    Sigma = covariance{1,2};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    contour(x1, x2, F,[0.004 0.006 0.01 0.014 0.016], 'ShowText', 'on', 'LineWidth', 2);
    %contour(x1, x2, F, 'ShowText', 'on', 'LineWidth', 2);
    
    
    
    mu = mean(3,:);
    Sigma = covariance{1,3};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    contour(x1, x2, F, [0.01 0.015 0.03 0.045], 'ShowText', 'on', 'LineWidth', 2);
    %contour(x1, x2, F,[5e-07 1e-06 2e-06 4.5e-06], 'ShowText', 'on', 'LineWidth', 2);
    
    mu = mean(4,:);
    Sigma = covariance{1,4};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    contour(x1, x2, F, [0.004 0.008 0.012 0.016], 'ShowText', 'on', 'LineWidth', 2);
    %contour(x1, x2, F, 'ShowText', 'on', 'LineWidth', 2);
    
    
    
    mu = mean(5,:);
    Sigma = covariance{1,5};
    x1 = minx:.2:maxx;
    x2 = miny:.2:maxy;
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)],mu,Sigma);
    F = reshape(F,length(x2),length(x1));
    
    %mvncdf([0 0],[1 1],mu,Sigma);
    contour(x1, x2, F, [0.004 0.008 0.012 0.016], 'ShowText', 'on', 'LineWidth', 2);
    %contour(x1, x2, F, 'ShowText', 'on', 'LineWidth', 2);
    
    
    title('{\bf Decision Region with Density Curves}');
    xlabel('Dimension 1');
    ylabel('Dimension 2');
    legend({'Observed 1','Observed 2','Observed 3','Observed 4','Observed 5','Class 1','Class 2','Class 3','Class 4','Class 5'}, 'Location','Best');
    axis tight;
    get(gca, 'XTick');
    set(gca, 'FontSize', 12);
    hold off;
    
    
end

end