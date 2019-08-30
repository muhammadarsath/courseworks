clc;
clear variables;
n=imread('2345.jpg');
[row,col,channel]=size(n);
I=double(n);
dim=[1 2 3 4 5 100 150 200];
%dim=round(linspace(1,256,20));
% Initializing variables %
eigval=zeros(row,col,channel);
eigvec=zeros(row,col,channel);
A1=zeros(row,col,channel);
A2=zeros(row,col,channel);
eigval_u=zeros(row,row,channel);
eigvec_u=zeros(row,row,channel);
eigval_v=zeros(col,col,channel);
eigvec_v=zeros(col,col,channel);
U=zeros(row,row,channel);
V=zeros(col,col,channel);
I_Mean=zeros(row,col);
A_Mean=zeros(row,col);
errPlot=zeros(size(dim,2),5);
errPlot(:,1)=dim;

for itr=size(dim,2):-1:1
    img_index=0;
    % Applying EVD on seperate color bands %
    for c=1:channel
        % Intializing U and V %
        U(:,:,c)=I(:,:,c)*I(:,:,c)';
        V(:,:,c)=I(:,:,c)'*I(:,:,c);
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
        for k=1:row
            eigvec_u(:,k,c)=v_u(:,I_U(k));
        end
        % Sorting Eigen vectors of V %
        for k=1:col
            eigvec_v(:,k,c)=v_v(:,I_V(k));
        end
        % Adding zeros to make Singular Value Matrix into rectangular %
        for k=dim(itr)+1:col
            eigval_u(:,k,c)=zeros(row,1);
        end
        % Finding Square root of D matrix
        eigval_u(:,:,c)=sqrt(eigval_u(:,:,c));
        % Calc of AV and UD %
        AV=I(:,:,c)*eigvec_v(:,:,c);
        UD=eigvec_u(:,:,c)*eigval_u(:,:,c);
        % Normalizing Eigen Vector Matrix of V by checking if AV==UD %
        for k=1:col
            if(floor(AV(1,k)) ~= floor(UD(1,k)))
                eigvec_v(:,k,c)=(-1)*eigvec_v(:,k,c);
            end
        end
        % Reconstructing Matrix A from U, V and Sigma %
        A1(:,:,c)=abs(eigvec_u(:,:,c)*(eigval_u(:,:,c))*(eigvec_v(:,:,c))');
        A2=A1;
        A2(:,:,1)=I(:,:,1);
        err= norm(I(:,:,c)-A1(:,:,c),'fro')/norm(I(:,:,c),'fro');
        fprintf('Error = %2.2f, Dim = %d, Channel#: %d\n',err,dim(itr),c);
        errPlot(itr,c+2)=err;
    end
    
    for p=1:row
        for q=1:col
            I_Mean(p,q)=mean([I(p,q,1),I(p,q,2),I(p,q,3)],2);
            A_Mean(p,q)=mean([A1(p,q,1),A1(p,q,2),A1(p,q,3)],2);
        end
    end
    errPlot(itr,2)=norm(I_Mean-A_Mean,'fro')/norm(I_Mean,'fro');
    
    % Plotting recontructed image %
    figure(itr);
    img_index=img_index+1;
    subplot(1,3,img_index)
    imshow(uint8(I));
    titlestr=sprintf('Original Image');
    title(titlestr);
    img_index=img_index+1;
    
    subplot(1,3,img_index)
    imshow(uint8(A1));
    titlestr=sprintf('SVD on RBG bands  \nDimensions = %d',dim(itr));
    title(titlestr);
    img_index=img_index+1;
    
    subplot(1,3,img_index)
    imshow(uint8(A2));
    titlestr=sprintf('SVD only on BG bands\nError = %2.2f ', errPlot(itr,2));
    title(titlestr);
end
