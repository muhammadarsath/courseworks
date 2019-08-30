function [index,final_val]=classifyGMM_synthetic(test,M,S,P)
%No of classes%
c=size(S,1);
%Flag for Diagonal covariance matrix%
Diag=0;
%Size of each row of S%
row=cellfun(@isempty,S);
for j=1:c
    K=sum(row(j,:)==0);K=K+1;
    for k=2:K
        for itr=1:k
            if Diag==1
                cov_mat=diag(diag(S{j,k}{1,itr}));
            else
                cov_mat=S{j,k}{1,itr};
            end
            L{j,k}(:,itr)=P{j,k}(itr)*lkhood(test(:,1:end-1),M{j,k}(itr,:),cov_mat);
        end
    end
end
%Likelihood comparison between gaussians%
%No of scenarios in every class
J=sum(row(1,:)==0);J=J+1;
K=sum(row(2,:)==0);K=K+1;
for j=2:J
    for k=2:K
        mx1=sum(cell2mat(L(1,j)),2);
        mx2=sum(cell2mat(L(2,k)),2);
        [mx,Ind]=max([mx1 mx2],[],2);
        result{j,k}=[mx Ind];
        val=difference(test(:,end),result{j,k}(:,end),2);
        [MAXIMUM, IND] = max(sum(val == 0));
        final_val(j,k)=MAXIMUM;
    end
end
for j=2:30
    sz=size(test,1);mx=0;ind=0;
    mat=final_val(1:j,1:j);
    [mx,ind]=max(mat(:));
    if(mx == 1200)
        break;
    end
end
[maxrow,maxcol]=ind2sub([j j],ind);
index=[maxrow maxcol];
end
