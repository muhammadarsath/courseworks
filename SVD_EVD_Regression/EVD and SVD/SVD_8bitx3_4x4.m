clc;
clear variables;
n=imread('sqr_17.jpg');
[row,col,channel]=size(n);
I=double(n);
I_16{16}=zeros(64,64,3);
dim(1:12)=1;
dim(13:16)=[64 64 64 64];

% Initializing variables %
eigval=zeros(64,64,3);
eigvec=zeros(64,64,3);
A{16}=zeros(64,64,3);
A_new=zeros(row,col,channel);
eigval_u=zeros(64,64,3);
eigvec_u=zeros(64,64,3);
eigval_v=zeros(64,64,3);
eigvec_v=zeros(64,64,3);
U=zeros(64,64,3);
V=zeros(64,64,3);
temp1=zeros(64,64,3);
temp2=zeros(64,64);
I_Mean=zeros(row,col);
A_Mean=zeros(row,col);
errPlot=zeros(size(dim,2),5);
errPlot(:,1)=dim;
img_index=0;

% Splitting Original Matrix %
m=1;
for p=1:4
    for q=1:4
        I_16{1,m}=I(((p-1)*64+1:p*64),((q-1)*64+1:q*64),:);
        m=m+1;
    end
end
% Original Matrix I %
for d=1:16
    %for itr=1:size(dim,2)
    itr=d;
    % Applying EVD on seperate color bands %
    for c=1:channel
        %         temp=I_16(d,1:64,1:64,c);
        temp2=I_16{1,d};
        % Intializing U and V %
        U(:,:,c)=temp2(:,:,c)*temp2(:,:,c)';
        V(:,:,c)=temp2(:,:,c)'*temp2(:,:,c);
        % Finding Eigen values and Eigen vectors %
        [v_u,d_u]=eig(U(:,:,c));
        [v_v,d_v]=eig(V(:,:,c));
        % Sorting Eigen values and Eigen vectors in descending %
        [e_u,I_U]=sort(diag(d_u),'descend');
        [e_v,I_V]=sort(diag(d_v),'descend');
        % Sorting Eigen values %
        for k=1:dim(itr)
            %eigval_u(k,k)=d_u(row+1-k,row+1-k);
            eigval_u(k,k,c)=d_u(I_U(k),I_U(k));
        end
        % Sorting Eigen vectors of U %
        for k=1:64
            eigvec_u(:,k,c)=v_u(:,I_U(k));
        end
        % Sorting Eigen vectors of V %
        for k=1:64
            eigvec_v(:,k,c)=v_v(:,I_V(k));
        end
        % Adding zeros to make Singular Value Matrix into rectangular %
        for k=dim(itr)+1:64
            eigval_u(:,k,c)=zeros(64,1);
        end
        % Finding Square root of D matrix
        eigval_u(:,:,c)=sqrt(eigval_u(:,:,c));
        % Calc of AV and UD %
        AV=temp2(:,:,c)*eigvec_v(:,:,c);
        UD=eigvec_u(:,:,c)*eigval_u(:,:,c);
        % Normalizing Eigen Vector Matrix of V by checking if AV==UD %
        for k=1:64
            if(floor(AV(1,k)) ~= floor(UD(1,k)))
                eigvec_v(:,k,c)=(-1)*eigvec_v(:,k,c);
            end
        end
        % Reconstructing Matrix A from U, V and Sigma %
        A{1,d}(:,:,c)=abs(eigvec_u(:,:,c)*(eigval_u(:,:,c))*(eigvec_v(:,:,c))');
        
    end
end
% Joining Matrix A into Original Matrix %
m=1;
for p=1:4
    for q=1:4
        for z=1:3
            A_new(((p-1)*64+1:p*64),((q-1)*64+1:q*64),z)=A{1,m}(:,:,z);
        end
        m=m+1;
    end
end
figure(1);
imshow(uint8(A_new));
