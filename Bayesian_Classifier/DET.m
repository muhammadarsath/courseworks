function DET (predicted, noOfIter, text)
cases = 5;
figure;
for i = 1 : cases
    FR = zeros(noOfIter,1);
    FA = zeros(noOfIter,1);
    for iter = 1 : noOfIter
        %pred = predicted{i, iter}(:,4);
        falseNegative = predicted{i, iter}(:,4) .* (predicted{i, iter}(:,3) ~= 1);
        falsePositive = (predicted{i, iter}(:,5) == 2) .* (predicted{i, iter}(:,3) == 1);
        targetTrue = predicted{i, iter}(:,3) == 1;
        targetFalse = predicted{i, iter}(:,3) ~= 1;
        FR(iter) = 1 - sum(falseNegative)/sum(targetTrue);
        FA(iter) = sum(falsePositive)/sum(targetFalse);
    end
    hold on;
    plot(FA(:), FR(:), 'LineWidth',2);
    legendCell{i} = ['Case ' num2str(i)];
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