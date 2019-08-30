clc;
clear variables;
%Initilaize A%
A=[3 6 6;4 8 8];
%Find Column and Row space of A%
row=size(A,1);
col=size(A,2);
piv_cols=0;
piv_rows=0;
if(row>col)
    A=A';
    rr=rref(A);
    [r,c]=find(rr==1);
    ind1=0;ind2=0;
    for k=1:length(r)
        if k~=1 && r(k)==piv_cols(ind1)
            continue;
        end
        if k~=1 && r(k)==piv_rows(ind2)
            continue;
        end
        ind1=ind1+1;ind2=ind2+1;
        piv_cols(ind1)=c(r(k));
        piv_rows(ind2)=r(k);
    end
    A=A';
    Ac=A(:,piv_rows);
    Ar=A(piv_cols,:);
else
    rr=rref(A);
    [r,c]=find(rr==1);
    ind1=0;ind2=0;
    for k=1:length(r)
        if k~=1 && r(k)==piv_cols(ind1)
            continue;
        end
        if k~=1 && r(k)==piv_rows(ind2)
            continue;
        end
        ind1=ind1+1;ind2=ind2+1;
        piv_cols(ind1)=c(r(k));
        piv_rows(ind2)=r(k);
    end
    Ac=A(:,piv_cols); % Column space
    Ar=A(piv_rows,:); % Row spcae
end

%Find Projection matrix(Pc) onto the column space of A of size 2x2%
Pc=Ac*inv(Ac'*Ac)*Ac';%Pc of size 2x2%

%Find Projection matrix(Pr) onto the row space of A of size 3x3%
Pr=Ar'*inv(Ar*Ar')*Ar;%Pr of size 3x3%

%Reconstruction of A by using Pc and Pr%
B=Pc*A*Pr;
fprintf('\t----------------\n');
fprintf('\tMatrix B=Pc*A*Pr\n');
fprintf('\t----------------\n');
disp(B)