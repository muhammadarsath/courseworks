function decisionSurfaceWithDensityCurves (data, mean, covariance)
%opengl('save','hardware')
step = 599;
cont={[.01 .009 .008],[.025 .02 .015],[.045 .04 .035],[.03 .025 .015],[.009 0.008 .007],[.035 .03 .025]};
minx = min(data(:,1));
maxx = max(data(:,1));
miny = min(data(:,2));
maxy = max(data(:,2));
stepx = (maxx - minx) / step;
stepy = (maxy - miny) / step;
[mgx, mgy] = meshgrid(minx : stepx : maxx, miny : stepy : maxy);

mgxL = mgx(:);
mgyL = mgy(:);

noOfClasses = size(covariance,2);

likelihood = zeros(length(mgxL),noOfClasses);
for c = 1 : noOfClasses
    for k = 1 : size(covariance{c},2)
        if ~isempty(covariance{1,c}{k})
            likelihood(:,c) = likelihood(:,c) + mvnpdf([mgxL mgyL], mean{1,c}(k,:), covariance{1,c}{k});
        end
    end
end
index = zeros(1, length(mgxL));
for i = 1 : length(mgxL)
    [~, index(i)] = max (likelihood(i,:));
end
if noOfClasses == 2
    %gscatter(mgxL,mgyL,index,[0.99 .46 0.52; .39 0.27 .43; 0.99 .71 .85]);
    %gscatter(mgxL,mgyL,index,[0.99 .46 0.52; .82 0.90 .93; 0.99 .71 .85]);
    gscatter(mgxL,mgyL,index,[.96, .90, .89; .78 .84 .86]);
    
    hold on;
    scatter(data(data(:,3)==1,1), data(data(:,3)==1,2), 40, 'MarkerEdgeColor',[.9 .9 .9],...
        'MarkerFaceColor',[.49 .54 .58],...
        'LineWidth',1.5);
    hold on;
    scatter(data(data(:,3)==2,1), data(data(:,3)==2,2), 40, 'MarkerEdgeColor',[.7 .4 .5],...
        'MarkerFaceColor',[.74 .49 .58],...
        'LineWidth',1.5);
    hold on;
    
    
    % [n,c] = hist3([data(data(:,3)==1,1), data(data(:,3)==1,2)]);
    % contour(c{1},c{2},n)
    
    for c = 1 : noOfClasses
        for k = 1 : size(covariance{c},2)
            if ~isempty(covariance{1,c}{k})
                mu = mean{1,c}(k,:);
                Sigma = covariance{1,c}{k};
                x1 = minx:.2:maxx;
                x2 = miny:.2:maxy;
                [X1,X2] = meshgrid(x1,x2);
                F = mvnpdf([X1(:) X2(:)],mu,Sigma);
                F = reshape(F,length(x2),length(x1));
                
                %mvncdf([0 0],[1 1],mu,Sigma);
                %figure;
                contour(x1, x2, F, 2, 'LineWidth', 1.2, 'Color', 'black');
            end
        end
    end
    
%     title('{\bf Decision Region with Density Curves}');
    xlabel('Dimension 1');
    ylabel('Dimension 2');
    legend({'Observed 1','Observed 2','Class 1','Class 2'}, 'Location','Best');
    axis tight;
    get(gca, 'XTick');
    set(gca, 'FontSize', 12);
    hold off;
    
    
end