clc;
clear variables;
n=imread('sqr_17.jpg');
[row,col,channel]=size(n);
I=double(n);
dim=[1 3 240 256];
%dim=[200 220 240 250 254 258 259 260];
%dim=[200 210 220 250 255 256];
%dim=round(linspace(1,256,10));
% Initializing variables %
eigval_u=zeros(row,row);
eigvec_u=zeros(row,row);
eigval_v=zeros(col,col);
eigvec_v=zeros(col,col);
eigval=zeros(row,col);
eigvec=zeros(row,col);
A=zeros(row,col);
I_24b=zeros(row,col);
I_8b_RGB=zeros(row,col,channel);
I_8b_GBR=zeros(row,col,channel);
I_8b_BRG=zeros(row,col,channel);
errPlot=zeros(size(dim,2),5);
errPlot(:,1)=dim;
img_index=0;
% Constructing 24bit Matrix %
for r=1:row
    for c=1:col
        I_24b(r,c)=bin2dec({[dec2bin(I(r,c,1),8),dec2bin(I(r,c,2),8),dec2bin(I(r,c,3),8)]});
    end
end

for itr=1:size(dim,2)
    % If Matrix I is rectangular when row < col %
    if row < col
        % Intializing U and V %
        U=I_24b*I_24b';
        V=I_24b'*I_24b;
        % Finding Eigen values and Eigen vectors %
        [v_u,d_u]=eig(U);
        [v_v,d_v]=eig(V);
        % Sorting Eigen values and Eigen vectors in descending %
        [e_u,I_U]=sort(diag(d_u),'descend');
        [e_v,I_V]=sort(diag(d_v),'descend');
        % Sorting Eigen values %
        for k=1:dim(itr)
            eigval_u(k,k)=d_u(I_U(k),I_U(k));
        end
        % Sorting Eigen vectors of U %
        for k=1:row
            eigvec_u(:,k)=v_u(:,I_U(k));
        end
        % Sorting Eigen vectors of V %
        for k=1:col
            eigvec_v(:,k)=v_v(:,I_V(k));
        end
        % Adding zeros to make Singular Value Matrix into rectangular %
        for k=dim(itr)+1:col
            eigval_u(:,k)=zeros(row,1);
        end
        % Finding Square root of D matrix
        eigval_u=sqrt(eigval_u);
        % Calc of AV and UD %
        AV=I_24b*eigvec_v;
        UD=eigvec_u*eigval_u;
        % Normalizing Eigen Vector Matrix of V by checking if AV==UD %
        for k=1:col
            if(floor(AV(1,k)) ~= floor(UD(1,k)))
                eigvec_v(:,k)=(-1)*eigvec_v(:,k);
            end
        end
        % Reconstructing Matrix A from U, V and Sigma %
        A=abs(eigvec_u*(eigval_u)*(eigvec_v)');
        
        % If Matrix I is Square %
    elseif row == col
        % Finding Eigen values and Eigen vectors %
        [v,d]=eig(I_24b);
        % Sorting Eigen values and Eigen vectors in descending %
        [tempeig,ind]=sort(diag(d),'descend');
        % Sorting Eigen values %
        for k=1:dim(itr)
            eigval(k,k)=d(ind(k),ind(k));
        end
        % Sorting Eigen vectors %
        for k=1:col
            eigvec(:,k)=v(:,ind(k));
        end
        % Reconstructing Matrix I_24b from X and D %
        A=abs(eigvec*eigval*inv(eigvec));
    end
    
    % Reconstructing Original matrix I from 24 bit matrix %
    for r=1:row
        for c=1:col
            binval=dec2bin(A(r,c),24);
            I_8b_RGB(r,c,1)=bin2dec(binval(1:8));
            I_8b_RGB(r,c,2)=bin2dec(binval(9:16));
            I_8b_RGB(r,c,3)=bin2dec(binval(17:24));
            
            I_8b_GBR(r,c,3)=bin2dec(binval(1:8));
            I_8b_GBR(r,c,1)=bin2dec(binval(9:16));
            I_8b_GBR(r,c,2)=bin2dec(binval(17:24));
            
            I_8b_BRG(r,c,2)=bin2dec(binval(1:8));
            I_8b_BRG(r,c,3)=bin2dec(binval(9:16));
            I_8b_BRG(r,c,1)=bin2dec(binval(17:24));
        end
    end
    % Error Calculation %
    Err_RGB_R=norm(I(:,:,1)-I_8b_RGB(:,:,1),'fro')/norm(I(:,:,1),'fro');
    Err_RGB_G=norm(I(:,:,2)-I_8b_RGB(:,:,2),'fro')/norm(I(:,:,2),'fro');
    Err_RGB_B=norm(I(:,:,3)-I_8b_RGB(:,:,3),'fro')/norm(I(:,:,3),'fro');
    
    Err_GBR_R=norm(I(:,:,1)-I_8b_GBR(:,:,1),'fro')/norm(I(:,:,1),'fro');
    Err_GBR_G=norm(I(:,:,2)-I_8b_GBR(:,:,2),'fro')/norm(I(:,:,2),'fro');
    Err_GBR_B=norm(I(:,:,3)-I_8b_GBR(:,:,3),'fro')/norm(I(:,:,3),'fro');
    
    Err_BRG_R=norm(I(:,:,1)-I_8b_BRG(:,:,1),'fro')/norm(I(:,:,1),'fro');
    Err_BRG_G=norm(I(:,:,2)-I_8b_BRG(:,:,2),'fro')/norm(I(:,:,2),'fro');
    Err_BRG_B=norm(I(:,:,3)-I_8b_BRG(:,:,3),'fro')/norm(I(:,:,3),'fro');
    Err_A=norm(I_24b-A,'fro')/norm(I_24b,'fro');
    
    % Image Plot %
    tit=sprintf('Dimensions = %d',dim(itr));
    figure('Name',tit,'NumberTitle','off');
    subplot(2,2,1)
    imshow(uint8(I));
    title('Original');
    subplot(2,2,2)
    imshow(uint8(I_8b_RGB));
    titlestr=sprintf('RGB\n Error : Red=%2.2f  Green=%2.2f Blue=%2.2f',Err_RGB_R,Err_RGB_G,Err_RGB_B);
    title(titlestr);
    subplot(2,2,3)
    imshow(uint8(I_8b_GBR));
    titlestr=sprintf('GBR\n Error : Green=%2.2f  Blue=%2.2f Red=%2.2f',Err_GBR_G,Err_GBR_B,Err_GBR_B);
    title(titlestr);
    %title('GBR');
    subplot(2,2,4)
    imshow(uint8(I_8b_BRG));
    titlestr=sprintf('BRG\n Error : Blue=%2.2f  Red=%2.2f Green=%2.2f',Err_BRG_B,Err_BRG_R,Err_BRG_G);
    title(titlestr);
    %title('BRG');
    
    % Plotting Image along with error image %
    img_index=img_index+1;
    figure(2);
    subplot(3,4,img_index)
    imshow(uint8(I_8b_RGB));
    titlestr=sprintf('Error = %2.2f  Dimensions = %d',norm(I_24b-A,2)/norm(I_24b,2),dim(itr));
    title(titlestr);
    img_index=img_index+1;
    
    subplot(3,4,img_index)
    %figure(img_index1);
    imshow(uint8(I_24b-A));
    titlestr=sprintf('Error Image:Dimensions = %d',dim(itr));
    title(titlestr);
    
    
    % Relative Error %
    fprintf('Dimension = %d \n',dim(itr));
    fprintf('\t\tError : Red=%2.2f  Green=%2.2f Blue=%2.2f\n',Err_RGB_R,Err_RGB_G,Err_RGB_B);
    errPlot(itr,2)=Err_A;
    errPlot(itr,3)=Err_RGB_R;
    errPlot(itr,4)=Err_RGB_G;
    errPlot(itr,5)=Err_RGB_B;
end

% Plotting Error %
% figure(5);
% plot(errPlot(:,1),errPlot(:,2),...
%     'color',[1 .5 0],...
%     'LineWidth',2,...
%     'MarkerFaceColor','black', ...
%     'MarkerEdgeColor','white',...
%     'MarkerSize',6,...
%     'Marker','o');
% xlabel('Top N Dimesnions')
% ylabel('Relative Error')
% title('EVD on 24 bit Image');



%hold on;
% plot(errPlot(:,1),errPlot(:,3));
% plot(errPlot(:,1),errPlot(:,4));
% plot(errPlot(:,1),errPlot(:,5));