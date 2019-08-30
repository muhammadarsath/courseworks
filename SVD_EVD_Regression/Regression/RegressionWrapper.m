function RegressionWrapper
close all;
trainErr = [];
validErr = [];
checkComp = 1;
checkReg = 0;
complexity = 20;
reguFactor = 0;
d = 8;
file = '17_3.txt';
showPlots = 0;

if checkComp == 1
    for i = 1 : complexity
        [tE, vE, ~] = PolyReg(file, i, d, reguFactor, 20, 20, 10, showPlots);
        trainErr = [trainErr; tE];
        validErr = [validErr; vE];
    end
    figure;
    plot(1 : complexity, trainErr,'-g.',...
        'LineWidth',2,...
        'MarkerSize',6,...
        'MarkerFaceColor','black', ...
        'MarkerEdgeColor','white','Marker','o');
    hold on;
    plot(1 : complexity, validErr,'-r.',...
        'LineWidth',2,...
        'MarkerSize',6,...
        'MarkerFaceColor','black', ...
        'MarkerEdgeColor','white','Marker','o');
    legend('Train Error','Validation Error','Location','best');
    ylabel('Error (Sqrt(LSE))');
    xlabel('Complexity of the model');
    title('Error Curve');
end
if checkReg == 1
    for i = 0: 2 : reguFactor
        [tE, vE, ~] = PolyReg(file, complexity, d, i, 0.7, 45, 10, showPlots);
        trainErr = [trainErr; tE];
        validErr = [validErr; vE];
    end
    figure;
    plot(0: 2 : reguFactor, trainErr,'-g.',...
        'LineWidth',2,...
        'MarkerSize',6,...
        'MarkerFaceColor','black', ...
        'MarkerEdgeColor','white','Marker','o');
    hold on;
    plot(0: 2 : reguFactor, validErr,'-r.',...
        'LineWidth',2,...
        'MarkerSize',6,...
        'MarkerFaceColor','black', ...
        'MarkerEdgeColor','white','Marker','o');
    legend('Train Error','Validation Error','Location','best');
    ylabel('Error (Sqrt(LSE))');
    xlabel('Regularization Factor');
    title('Error Curve');
end

end