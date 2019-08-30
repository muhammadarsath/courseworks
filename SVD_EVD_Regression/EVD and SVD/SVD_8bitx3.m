clc;
clear variables;
n=imread('rect_17.jpg');
%n=imread('BW.png');
[row,col,channel]=size(n);
I=double(n);
dim=[5 50 100 260];
%dim=[260];
isRandom=0;
rearrange=0;
%dim=round(linspace(1,256,10));
%dim=[50 100 260];
% Initializing variables %
eigval=zeros(row,col,channel);
eigvec=zeros(row,col,channel);
A=zeros(row,col,channel);
A_RBG=zeros(row,col,channel);
A_GBR=zeros(row,col,channel);
A_BRG=zeros(row,col,channel);
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
img_index=0;
for itr=1:size(dim,2)
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
        A(:,:,c)=abs(eigvec_u(:,:,c)*(eigval_u(:,:,c))*(eigvec_v(:,:,c))');
        
        err= norm(I(:,:,c)-A(:,:,c),'fro')/norm(I(:,:,c),'fro');
        fprintf('Error = %2.2f, Dim = %d, Channel#: %d\n',err,dim(itr),c);
        errPlot(itr,c+2)=err;
    end
    
    for p=1:row
        for q=1:col
            I_Mean(p,q)=mean([I(p,q,1),I(p,q,2),I(p,q,3)],2);
            A_Mean(p,q)=mean([A(p,q,1),A(p,q,2),A(p,q,3)],2);
        end
    end
    errPlot(itr,2)=norm(I_Mean-A_Mean,'fro')/norm(I_Mean,'fro');
    % Rearrangement of color bands %
    if(rearrange ==1)
        A_RBG(:,:,2)=A(:,:,3);A_RBG(:,:,3)=A(:,:,2);
        A_GBR(:,:,1)=A(:,:,2);A_GBR(:,:,2)=A(:,:,3);A_GBR(:,:,3)=A(:,:,1);
        A_BRG(:,:,1)=A(:,:,3);A_BRG(:,:,2)=A(:,:,1);A_BRG(:,:,3)=A(:,:,2);
        img_index=img_index+1;figure(img_index);imshow(uint8(A_RBG));
        img_index=img_index+1;figure(img_index);imshow(uint8(A_GBR));
        img_index=img_index+1;figure(img_index);imshow(uint8(A_BRG));
    end
    % Plotting recontructed image %
    figure(2);
    img_index=img_index+1;
    subplot(2,4,img_index)
    imshow(uint8(A));
    titlestr=sprintf('Error = %2.2f  Dimensions = %d', errPlot(itr,2),dim(itr));
    title(titlestr);
    img_index=img_index+1;
    
    subplot(2,4,img_index)
    imshow(uint8(I_Mean-A_Mean));
    titlestr=sprintf('Error Image:Dimensions = %d',dim(itr));
    title(titlestr);
end


% Plotting Error %
% figure(3);
% plot(errPlot(:,1),errPlot(:,2),...
%     'color',[1 .5 0],...
%     'LineWidth',2,...
%     'MarkerFaceColor','black', ...
%     'MarkerEdgeColor','white',...
%     'MarkerSize',8,...
%     'Marker','o');
% xlabel('Top N Singular Values');
% ylabel('Relative Error');
% title('SVD on each color bands');
% hold on;
% plot(errPlot(:,1),errPlot(:,3),...
%     'color','red',...
%     'LineWidth',1,...
%     'MarkerFaceColor','black', ...
%     'MarkerEdgeColor','white',...
%     'MarkerSize',5,...
%     'Marker','h');
% plot(errPlot(:,1),errPlot(:,4),...
%     'color','green',...
%     'LineWidth',1,...
%     'MarkerFaceColor','black', ...
%     'MarkerEdgeColor','white',...
%     'MarkerSize',5,...
%     'Marker','s');
% plot(errPlot(:,1),errPlot(:,5),...
%     'color','blue',...
%     'LineWidth',1,...
%     'MarkerFaceColor','black', ...
%     'MarkerEdgeColor','white',...
%     'MarkerSize',5,...
%     'Marker','d');
% legend('Mean RGB','R band','G band','B band');