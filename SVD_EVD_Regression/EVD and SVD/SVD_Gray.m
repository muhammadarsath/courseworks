clc;
clear variables;
dim=[5 20 100 250];
%dim=[260]
%dim=round(linspace(1,256,10));
n=imread('rect_17.jpg');
[row,col,channel]=size(n);
I=rgb2gray(n);
I=double(I);
isRandom=0;
% Initializing variables %
eigval_u=zeros(row,row);
eigvec_u=zeros(row,row);
eigval_v=zeros(col,col);
eigvec_v=zeros(col,col);
eigval=zeros(row,col);
eigvec=zeros(row,col);
errPlot=zeros(size(dim,2),2);
errPlot(:,1)=dim;
img_index=0;
% Intializing U and V %
U=I*I';
V=I'*I;
% Finding Eigen values and Eigen vectors %
[v_u,d_u]=eig(U);
[v_v,d_v]=eig(V);
% Sorting Eigen values and Eigen vectors in descending %
[e_u,I_U]=sort(diag(d_u),'descend');
[e_v,I_V]=sort(diag(d_v),'descend');
% Sorting Eigen vectors of U %
for k=1:row
    eigvec_u(:,k)=v_u(:,I_U(k));
end
% Sorting Eigen vectors of V %
for k=1:col
    eigvec_v(:,k)=v_v(:,I_V(k));
end
for itr=1:size(dim,2)
    % Sorting Eigen values %
    for k=1:dim(itr)
        eigval_u(k,k)=d_u(I_U(k),I_U(k));
    end
    % Adding zeros to make Singular Value Matrix into rectangular %
    for k=dim(itr)+1:col
        eigval_u(:,k)=zeros(row,1);
    end
    % Finding Square root of D matrix
    eigval_u=sqrt(eigval_u);
    % Calc of AV and UD %
    AV=I*eigvec_v;
    UD=eigvec_u*eigval_u;
    % Normalizing Eigen Vector Matrix of V by checking if AV==UD %
    for k=1:col
        if(floor(AV(1,k)) ~= floor(UD(1,k)))
            eigvec_v(:,k)=(-1)*eigvec_v(:,k);
        end
    end
    % Selecting Random Eigen Values %
    if(isRandom ==1)
        randVal=randi([1 260],[1 1]);
        for k=1:260
            if(any(randVal(:) == k))
            else
                eigval_u(k,k)=0;
            end
        end
    end
    % Reconstructing Matrix A from U, V and Sigma %
    A=abs(eigvec_u*(eigval_u)*(eigvec_v)');
    
    % Plotting recontructed image %
    figure(2);
    img_index=img_index+1;
    subplot(2,4,img_index)
    imshow(uint8(A));
    titlestr=sprintf('Error = %2.2f  Dimensions = %d',norm(I-A,'fro')/norm(I,'fro'),dim(itr));
    title(titlestr);
    img_index=img_index+1;
    
    subplot(2,4,img_index)
    imshow(uint8(I-A));
    titlestr=sprintf('Error Image:Dimensions = %d',dim(itr));
    title(titlestr);
    
    % Relative Error %
    err= norm(I-A,'fro')/norm(I,'fro');
    fprintf('Error = %2.2f, N = %d\n',err,dim(itr));
    errPlot(itr,2)=err;
    
    % Plotting Error %
    %         plot(errPlot(:,1),errPlot(:,2),...
    %             'color',[1 .5 0],...
    %             'LineWidth',2,...
    %             'MarkerFaceColor','black', ...
    %             'MarkerEdgeColor','white',...
    %             'MarkerSize',6,...
    %             'Marker','o');
    %         xlabel('Top N Singular Values')
    %         ylabel('Relative Error')
    %         title('SVD on Grayscale Image');
end