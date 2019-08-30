clc;
clear variables;
n=imread('sqr_17.jpg');
[row,col,channel]=size(n);
I=double(n);
isRandom=0;
dim=[5 20 100 256];
%dim=[256];
%dim=round(linspace(1,256,10));
% Initializing variables %
eigval=zeros(row,col,channel);
eigvec=zeros(row,col,channel);
A=zeros(row,col,channel);
eigval_u=zeros(row,row,channel);
eigvec_u=zeros(row,row,channel);
eigval_v=zeros(col,col,channel);
eigvec_v=zeros(col,col,channel);
U=zeros(row,row,channel);
V=zeros(col,col,channel);
I_Mean=zeros(row,col);
A_Mean=zeros(row,col);
img_index=0;
errPlot=zeros(size(dim,2),5);
errPlot(:,1)=dim;
for itr=1:size(dim,2)
    % Applying EVD on seperate color bands %
    for c=1:channel
        % If Matrix I is rectangular when row < col %
        if row < col
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
                randVal=randi([1 256],[1 1]);
                for k=1:256
                    if(any(randVal(:) == k))
                    else
                        eigval_u(k,k)=0;
                    end
                end
            end
            % Reconstructing Matrix A from U, V and Sigma %
            A(:,:,c)=abs(eigvec_u(:,:,c)*(eigval_u(:,:,c))*(eigvec_v(:,:,c))');
            
            % If Matrix I is Square %
        elseif row == col
            % Finding Eigen values and Eigen vectors %
            [v,d]=eig(I(:,:,c));
            % Sorting Eigen values and Eigen vectors in descending %
            [tempeig,ind]=sort(diag(d),'descend');
            % Sorting Eigen values %
            for k=1:dim(itr)
                eigval(k,k,c)=d(ind(k),ind(k));
            end
            % Sorting Eigen vectors %
            for k=1:col
                eigvec(:,k,c)=v(:,ind(k));
            end
            % Selecting Random Eigen Values %
            if(isRandom ==1)
                randVal=randi([1 256],[1 200]);
                for k=1:256
                    if(any(randVal(:) == k))
                    else
                        eigval(k,k)=0;
                    end
                end
            end
            % Reconstructing Matrix A from X and D %
            A(:,:,c)=abs(eigvec(:,:,c)*eigval(:,:,c)*inv(eigvec(:,:,c)));
        end
        
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
    % Plotting recontructed image %
    figure(2);
    img_index=img_index+1;
    subplot(2,4,img_index)
    imshow(uint8(A));
    titlestr=sprintf('Error = %2.2f  Dimensions = %d',errPlot(itr,2),dim(itr));
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
% xlabel('Top N Dimesnions');
% ylabel('Relative Error');
% title('EVD on each color bands');
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