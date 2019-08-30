function [L,index,final_val]=classifyGMM(test,M,S,P)
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
            
            L{j,k}(:,itr)=P{j,k}(itr)*mvnpdf(test(:,1:end-1),M{j,k}(itr,:),cov_mat);
        end
    end
end

%Likelihood comparison between gaussians%
%No of scenarios in every class
J=sum(row(1,:)==0);J=J+1;
K=sum(row(2,:)==0);K=K+1;
ITR=sum(row(3,:)==0);ITR=ITR+1;
actual=repmat(test(:,end),1,sum(row(3,:)==0));
for j=2:J
    for k=2:K
        for itr=2:ITR
            mx1=sum(cell2mat(L(1,j)),2);
            mx2=sum(cell2mat(L(2,k)),2);
            mx3=sum(cell2mat(L(3,itr)),2);
            [mx,Ind]=max([mx1 mx2 mx3],[],2);
            r{j,k}{itr}=[mx Ind];
        end
        temp=cell2mat(r{j,k});
        result{j,k}=temp(:,2:2:end);
        val=difference(actual,result{j,k},2);
        [MAXIMUM, IND] = max(sum(val == 0));
        final_val(j,k)=MAXIMUM;
        final_index(j,k)=IND+1;
    end
end
[~,ind]=max(final_val(:));
[maxrow,maxcol]=ind2sub(size(final_val),ind);
index=[maxrow maxcol final_index(maxrow,maxcol)];
end
