function [means] = questionFour
%setN = [2,10,100,500,1000,2000,4000,8000,10000];
setN = [1000,10000];
N = 10000;
A = 0.3039635;
means=zeros(length(setN),N);
F = {};
% F is CDF
for  i = 1 : length(setN)
    k = 1 : setN(i)/2;
    distribution = A * (1./(k.*k));
    distribution = [distribution(end:-1:1) distribution];
    F{i} = cumsum(distribution);
end
% Sampling of Means
for i = 1 : length(setN)
    parfor l = 1 : N
        obtainedSamples = zeros(setN(i),1);
        for j = 1 : setN(i)
            [~,index] = max(F{i} > rand(1,1));
            index =  -(setN(i)/2 + 1) + index;
            if index >= 0
                index = index + 1;
            end
            obtainedSamples(j) = index;
        end
        means(i,l) = mean(obtainedSamples);
    end
    ['i = ' num2str(i)]
end


% Calculating Confidence Interval
standMeans=std(means,0,2);
%No. of means outside the 95% (-2sigma, +2sigma] interval
M=mean(means,2);
for k=1:length(setN)
    conf_interval(k,1)=-2*standMeans(k)+M(k);
    conf_interval(k,2)=2*standMeans(k)+M(k);
    outliers(k)=sum(~(means(k,:)>(conf_interval(k,1)) & means(k,:)<(conf_interval(k,2))));
end
end