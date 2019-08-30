function [result,error]=classify(test,M,C,p,f,n)
% Likelihood Estimation %
c=size(C,2);
for k=1:c
    L{k}=lkhood(test,M(k,:),C{1,k});
    w{k}=L{k}*p(k);
end
% Total Estimate %
wc=cell2mat(w);
W=sum(wc,2);
for j=1:c
    g{j}(:,1)=w{j}./W;
end
% Classification of test data using discriminant function g(x)%
A=cell2mat(g);
% for ROC Curve %
if f>0
    result=test;
    error=0;
    for k=1:size(A,1)
        %[mx,Ind]=max(A(k,:));
        if f==1
            for m=4:5
                if A(k,1)>=n
                    result(k,4)=1;break;
                else
                    result(k,4)=0;
                end
            end
            for m=1:size(A,2)
                if m>3 break;end
                if A(k,m)>=n
                    result(k,5)=2; break;
                else
                    result(k,5)=0;
                end
            end
        else
            if A(k,1)>=n
                result(k,4)=1;
            else
                result(k,4)=0;
            end
            for m=2:size(A,2)
                if A(k,m)>=n
                    result(k,5)=2; break;
                else
                    result(k,5)=0;
                end
            end
        end
    end
    
    % Labeling Classes %
else
    for k=1:size(test,1)
        [mx,Ind]=max(A(k,:));
        result(k,:)=[test(k,:) Ind];
        % Calculating Error %
        error(k,:)=1-mx;
    end
end
