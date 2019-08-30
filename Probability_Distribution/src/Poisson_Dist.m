clc;
clear variables;
isPlotDiff = 0;
isPlotMeanByInterval = 0;
lambda=10;
setN=[10,100,1000,10000];
%setN=[1,5,10,100,500,1000,2000,4000,8000,10000];
%No. of iterations
N=10000;
startInterval = 9.99;
endInterval = 10.01;
%Mean values
means=zeros(length(setN),N);
for k=1:length(setN)
    parfor j=1:N
        data=poissrnd(lambda,setN(k),1);
        means(k,j)=mean(data);
    end
end

%Standard Deviation
stdMeans=std(means,0,2);
%No. of means outside the 95% (-2sigma, +2sigma] interval
M=mean(means,2);
for k=1:length(setN)
conf_interval(k,1)=-2*stdMeans(k)+M(k);
conf_interval(k,2)=2*stdMeans(k)+M(k);
outliers(k)=sum(~(means(k,:)>(conf_interval(k,1)) & means(k,:)<(conf_interval(k,2))));
end


%No. of means outside the 95% (LAP Sir Advice)
M=mean(means,2);
for k=1:length(setN)
    interval = 10;
    epsilon = 1;
    while interval >= .05
        conf_interval(k,1)=-epsilon+M(k);
        conf_interval(k,2)=epsilon+M(k);
        outliers(k)=sum(~(means(k,:)>(conf_interval(k,1)) & means(k,:)<(conf_interval(k,2))));
        interval = outliers(k)/length(means(k,:));
        epsilon = epsilon + 0.00001;
    end
end


setAccuracy = [0.1 0.01 0.001 0.0001 0.00001 0.000001];
% setAccuracy = [0.1 0.01 0.001 0.0001];
expectedAccuracy = 0.001;

necessaryCount = zeros(length(setAccuracy),1);

for i = 1 : length(setAccuracy)
count = 0;
obtainedAccuracy = 1000;
while obtainedAccuracy > setAccuracy(i) || obtainedAccuracy == 0
    count = count + 1;
    obtainedAccuracy = abs(mean(poissrnd(lambda,count,1)) - lambda);
end
necessaryCount(i) = count
end



if isPlotDiff == 1
    difference = abs(10 - mean(means,2));
    stem(difference);
    
    xlabel('Number of Samples');
    ylabel('Deviation from original Mean');
    get(gca, 'XTick');
    set(gca, 'FontSize', 10);
end

%No. of means within the interval
if isPlotMeanByInterval == 1    
    meanByInterval = sum(((means>startInterval) & (means<endInterval)),2);
    stem(meanByInterval);
    hold on;
    plot(meanByInterval, 'LineWidth',2);
    
    xlabel('Total Number of Samples');
    ylabel('Number of Smaples in the Intervals');
    get(gca, 'XTick');
    set(gca, 'FontSize', 10);
    legend(['Interval [' num2str(startInterval) ', ' num2str(endInterval) ']']);
end