function ROC (predicted, noOfIter, text)
cases = 5;
line = [0 : 0.1 : 1; 0 : 0.1 : 1]';
legendCell{1} = 'Bad Case';
figure;
plot(line(:,1), line(:,2), 'k--');
for i = 1 : cases
    TPR = zeros(noOfIter,1);
    FPR = zeros(noOfIter,1);
    for iter = 1 : noOfIter
        %pred = predicted{i, iter}(:,4);
        predictedTrueIter = predicted{i, iter}(:,4) .* predicted{i, iter}(:,3) == 1;
        predictedFalseIter = (predicted{i, iter}(:,5) == 2) .* (predicted{i, iter}(:,3) ~= 1);
        targetTrue = predicted{i, iter}(:,3) == 1;
        targetFalse = predicted{i, iter}(:,3) ~= 1;
        TPR(iter) = sum(predictedTrueIter)/sum(targetTrue);
        FPR(iter) = sum(predictedFalseIter)/sum(targetFalse);
    end
    hold on;
    plot(FPR(:), TPR(:), 'LineWidth',2);
    legendCell{i+1} = ['Case ' num2str(i)];
end
legend(legendCell, 'Location','Best');
text = ['{\bf ' text '}'];
title(text);
xlabel('False Positive Rate (FPR)');
ylabel('True Positive Rate (TPR)');axis tight;
get(gca, 'XTick');
set(gca, 'FontSize', 12);
set(gca, 'ZTick',[]);
hold off;
end