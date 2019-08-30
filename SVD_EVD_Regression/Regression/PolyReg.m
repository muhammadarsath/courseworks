function [trainLSE, validLSE, testLSE] = PolyReg(fileToLoad, M, d, regularFactor, sampCount, validCount, testCount, showPlots)
% Usage :
% --------
% function [trainLSE, validLSE, testLSE] = PolyReg(fileToLoad, M, d, regularFactor, sampCount, validCount, testCount, showPlots)
% -----------------
% fileToLoad = '17_3.txt';
% M = 3; % Degree of polynomial; q17_1.txt needs upto 6;
% d = 8; % Dimension
% regularFactor = 0.1;
% outputCol = d + 1;
% sampCount = 40; %Train data
% validCount = 40; %Validation data
% testCount = 20; %Test data
% datapoints = load(fileToLoad);
% showPlots = 0;

%close all;
% clear;
% fileToLoad = 'q17_1.txt';
% M = 6; % Degree of polynomial; q17_1.txt needs upto 6;
% d = 1; % Dimension
% regularFactor = 0;
outputCol = d + 1;
datapoints = load(fileToLoad);
sampCount = sampCount / 100; %Train data
validCount = validCount / 100; %Validation data
testCount = testCount / 100; %Test data
showStem = 0;
sampCount = int32(length(datapoints) * sampCount); %Train data
validCount = int32(length(datapoints) * validCount); %Validation data
testCount = int32(length(datapoints) * testCount); %Test data

if d < 3
    noOfCol = factorial(d + M)/(factorial(d)*factorial(M));
else
    noOfCol = (d * M) + 1;
end
phiMatrix = ones(sampCount,noOfCol);
phiMatrixValid = ones(validCount,noOfCol);
phiMatrixTest = ones(testCount,noOfCol);

if d == 1
    target = datapoints(1:sampCount, outputCol);
    targetValid = datapoints(sampCount + 1:sampCount + validCount, outputCol);
    targetTest = datapoints(sampCount + validCount + 1:sampCount + validCount + testCount, outputCol);
    for itr = 0 : noOfCol - 1
        phiMatrix(:,itr + 1) = datapoints(1:sampCount,1).^itr;
        phiMatrixValid(:,itr + 1) = datapoints(sampCount + 1:sampCount + validCount,1).^itr;
        phiMatrixTest(:,itr + 1) = datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,1).^itr;
    end
    if showPlots == 1
        figure;
        scatter(datapoints(1:sampCount,1),datapoints(1:sampCount,2), 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Target');
        title('Train Data');
        legend('Data points','Location','best');
    end
elseif d == 2
    target = datapoints(1:sampCount, outputCol);
    targetValid = datapoints(sampCount + 1:sampCount + validCount, outputCol);
    targetTest = datapoints(sampCount + validCount + 1:sampCount + validCount + testCount, outputCol);
    phiMatrix = calPhi(phiMatrix,M,datapoints(1:sampCount,1:2));
    phiMatrixValid = calPhi(phiMatrixValid,M,datapoints(sampCount + 1:sampCount + validCount,1:2));
    phiMatrixTest = calPhi(phiMatrixTest,M,datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,1:2));
    if showPlots == 1
        figure;
        scatter3(datapoints(1:sampCount,1),datapoints(1:sampCount,2),datapoints(1:sampCount,3), 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Y');
        zlabel('Target');
        title('Train Data');
        legend('Data points','Location','best');
    end
else
    target = datapoints(1:sampCount, outputCol);
    targetValid = datapoints(sampCount + 1:sampCount + validCount, outputCol);
    targetTest = datapoints(sampCount + validCount + 1:sampCount + validCount + testCount, outputCol);
    phiMatrix = calPhiMultidim(phiMatrix,M,datapoints(1:sampCount,1:outputCol-1));
    phiMatrixValid = calPhiMultidim(phiMatrixValid,M,datapoints(sampCount + 1:sampCount + validCount,1:outputCol-1));
    phiMatrixTest = calPhiMultidim(phiMatrixTest,M,datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,1:outputCol-1));
end
identitySize = size(phiMatrix,2);
weight = pinv(phiMatrix' * phiMatrix + (regularFactor * eye(identitySize))) * phiMatrix' * target ;
%weight = pinv(phiMatrix' * phiMatrix) * phiMatrix' * target ;
calcY = phiMatrix * weight;
trainLSE = norm(calcY - target)/length(target)
if showPlots == 1
    if showStem == 1
        figure;stem(target,'b')
        hold on;stem(calcY,'r')
        title('Train');
    end
    if d == 1
        figure;
        scatter(datapoints(1:sampCount,1),target, 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Target');
        title('Train Data');
        hold on;
        [x, y] = sortUserDef (datapoints(1:sampCount,1), calcY);
        plot(x, y, '-s', 'LineWidth', 2,'MarkerEdgeColor','g','MarkerFaceColor',[0.5,0.5,0.5]);
        legend('Data points','Prediction','Location','best');
    elseif d == 2
        figure;
        scatter3(datapoints(1:sampCount,1),datapoints(1:sampCount,2),datapoints(1:sampCount,3), 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Y');
        zlabel('Target');
        title('Train Data');
        hold on;
        X = min(datapoints(:,1)):0.1:max(datapoints(:,1));
        Y = min(datapoints(:,2)):0.1:max(datapoints(:,2));
        [xMeshGrid, yMeshGrid] = meshgrid(X,Y);
        phiMatrixGrid = ones(length(xMeshGrid(:)),noOfCol);
        phiMatrixGrid = calPhi(phiMatrixGrid,M,[xMeshGrid(:),yMeshGrid(:)]);
        calcYGrid = phiMatrixGrid * weight;
        zMeshGrid = reshape(calcYGrid,length(Y),length(X));
        s = mesh(xMeshGrid,yMeshGrid,zMeshGrid,'FaceLighting','gouraud','LineWidth',1.3,'FaceAlpha',0.4, 'FaceColor', 'interp');
        s.EdgeColor = 'none';
        hold on;
        scatter3(datapoints(1:sampCount,1),datapoints(1:sampCount,2),calcY, 's', 'LineWidth', 2,'MarkerEdgeColor','g','MarkerFaceColor',[0.5,0.5,0.5]);
        legend('Data points','Prediction Surf','Prediction','Location','best');
    else
        figure;
        idealLine = [min(datapoints(1:sampCount,outputCol)), min(datapoints(1:sampCount,outputCol)) ; max(datapoints(1:sampCount,outputCol)), max(datapoints(1:sampCount,outputCol))];
        plot(idealLine(:,1),idealLine(:,2),'k', 'LineWidth', 2);
        hold on;
        scatter(calcY,target, 'MarkerEdgeColor',[.7 .1 .2], 'MarkerFaceColor',[0 .1 .1], 'LineWidth',0.2);
        xlabel('Prediction');
        ylabel('Target');
        title('Train Data');
        legend('Ideal Regression','Prediction','Location','best');
    end
end
calcY = phiMatrixValid * weight;
validLSE = norm(calcY - targetValid)/length(targetValid)
if showPlots == 1
    if showStem == 1
        figure;stem(targetValid,'b')
        hold on;stem(calcY,'r')
        title('Validation');
    end
    if d == 1
        figure;
        scatter(datapoints(sampCount + 1:sampCount + validCount, 1),targetValid, 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Target');
        title('Validation Data');
        hold on;
        [x, y] = sortUserDef (datapoints(sampCount + 1:sampCount + validCount, 1), calcY);
        plot(x, y, '-s', 'LineWidth', 2,'MarkerEdgeColor','g','MarkerFaceColor',[0.5,0.5,0.5]);
        legend('Data points','Prediction','Location','best');
    elseif d == 2
        figure;
        scatter3(datapoints(sampCount + 1:sampCount + validCount,1),datapoints(sampCount + 1:sampCount + validCount,2),datapoints(sampCount + 1:sampCount + validCount,3), 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Y');
        zlabel('Target');
        title('Validation Data');
        hold on;
        X = min(datapoints(:,1)):0.1:max(datapoints(:,1));
        Y = min(datapoints(:,2)):0.1:max(datapoints(:,2));
        [xMeshGrid, yMeshGrid] = meshgrid(X,Y);
        phiMatrixGrid = ones(length(xMeshGrid(:)),noOfCol);
        phiMatrixGrid = calPhi(phiMatrixGrid,M,[xMeshGrid(:),yMeshGrid(:)]);
        calcYGrid = phiMatrixGrid * weight;
        zMeshGrid = reshape(calcYGrid,length(Y),length(X));
        s = mesh(xMeshGrid,yMeshGrid,zMeshGrid,'FaceLighting','gouraud','LineWidth',1.3,'FaceAlpha',0.4, 'FaceColor', 'interp');
        s.EdgeColor = 'none';
        hold on;
        scatter3(datapoints(sampCount + 1:sampCount + validCount,1),datapoints(sampCount + 1:sampCount + validCount,2),calcY, 's', 'LineWidth', 2,'MarkerEdgeColor','g','MarkerFaceColor',[0.5,0.5,0.5]);
        legend('Data points','Prediction Surf','Prediction','Location','best');
    else
        figure;
        idealLine = [min(datapoints(sampCount + 1:sampCount + validCount,outputCol)), min(datapoints(sampCount + 1:sampCount + validCount,outputCol)) ; max(datapoints(sampCount + 1:sampCount + validCount,outputCol)), max(datapoints(sampCount + 1:sampCount + validCount,outputCol))];
        plot(idealLine(:,1),idealLine(:,2),'k', 'LineWidth', 2);
        hold on;
        scatter(calcY,targetValid, 'MarkerEdgeColor',[.7 .1 .2], 'MarkerFaceColor',[0 .1 .1], 'LineWidth',0.2);
        xlabel('Prediction');
        ylabel('Target');
        title('Validation Data');
        legend('Ideal Regression','Prediction','Location','best');
    end
end
calcY = phiMatrixTest * weight;
testLSE = norm(calcY - targetTest)/length(targetTest)
if showPlots == 1
    if showStem == 1
        figure;stem(targetTest,'b')
        hold on;stem(calcY,'r')
        title('Test');
    end
    if d == 1
        figure;
        scatter(datapoints(sampCount + validCount + 1:sampCount + validCount + testCount, 1),targetTest, 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Target');
        title('Test Data');
        hold on;
        [x, y] = sortUserDef (datapoints(sampCount + validCount + 1:sampCount + validCount + testCount, 1), calcY);
        plot(x, y, '-s', 'LineWidth', 2,'MarkerEdgeColor','g','MarkerFaceColor',[0.5,0.5,0.5]);
        legend('Data points','Prediction','Location','best');
    elseif d == 2
        figure;
        scatter3(datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,1),datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,2),datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,3), 's', 'LineWidth', 1.5);
        xlabel('X');
        ylabel('Y');
        zlabel('Target');
        title('Test Data');
        hold on;
        X = min(datapoints(:,1)):0.1:max(datapoints(:,1));
        Y = min(datapoints(:,2)):0.1:max(datapoints(:,2));
        [xMeshGrid, yMeshGrid] = meshgrid(X,Y);
        phiMatrixGrid = ones(length(xMeshGrid(:)),noOfCol);
        phiMatrixGrid = calPhi(phiMatrixGrid,M,[xMeshGrid(:),yMeshGrid(:)]);
        calcYGrid = phiMatrixGrid * weight;
        zMeshGrid = reshape(calcYGrid,length(Y),length(X));
        s = mesh(xMeshGrid,yMeshGrid,zMeshGrid,'FaceLighting','gouraud','LineWidth',1.3,'FaceAlpha',0.4, 'FaceColor', 'interp');
        s.EdgeColor = 'none';
        hold on;
        scatter3(datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,1),datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,2),calcY, 's', 'LineWidth', 2,'MarkerEdgeColor','g','MarkerFaceColor',[0.5,0.5,0.5]);
        legend('Data points','Prediction Surf','Prediction','Location','best');
    else
        figure;
        idealLine = [min(datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,outputCol)), min(datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,outputCol)) ; max(datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,outputCol)), max(datapoints(sampCount + validCount + 1:sampCount + validCount + testCount,outputCol))];
        plot(idealLine(:,1),idealLine(:,2),'k', 'LineWidth', 2);
        hold on;
        scatter(calcY,targetTest, 'MarkerEdgeColor',[.7 .1 .2], 'MarkerFaceColor',[0 .1 .1], 'LineWidth',0.2);
        xlabel('Prediction');
        ylabel('Target');
        title('Test Data');
        legend('Ideal Regression','Prediction','Location','best');
    end
end
end

function [phiMatrix] = calPhi(phi,M,data)
cols = 2;
for m = 1:M
    array = zeros(1,m);
    rect = 1;
    for t = 1:m+1
        for in = 1:m
            if array(in) == 0
                phi(:,cols) = phi(:,cols).*  data(:,1);
            else
                phi(:,cols) = phi(:,cols).*  data(:,2);
            end
        end
        array(rect) = 1;
        rect = rect + 1;
        cols = cols + 1;
    end
end
phiMatrix = phi;
end

function [phiMatrix] = calPhiMultidim(phi,M,data)
cols = size(data,2);
phi(:,1) = ones(length(data),1);
for m = 1 : M
    for dim = 1 : cols
        phi(:, (m*dim) + 1) = data(:, dim) .^ m;
    end
end
phiMatrix = phi;
end

function [randSampParam, randWNExpParam] = sortUserDef (randSamp,randWNExp)
for i = 1 : length(randSamp)
    for j = i : length(randSamp)
        if randSamp(i) >= randSamp(j)
            temp1 = randSamp(i);
            temp2 = randWNExp(i);
            randSamp(i) = randSamp(j);
            randSamp(j) = temp1;
            randWNExp(i) = randWNExp(j);
            randWNExp(j) = temp2;
        end
    end
end
randSampParam = randSamp;
randWNExpParam =randWNExp;
end