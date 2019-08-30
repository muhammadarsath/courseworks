clc;
clear variables;
load 'EigenVectors.mat';
%Image file path%
filenames= dir('s01\*.pgm');
%Number of images to process%
n=size(filenames,1);
%Dimension of Eigen space%
d=size(COEFF,1);
A{n}=0;
B{n}=0;
A_proj{n}=0;
A_final{n}=0;
A_final_NoCoeff{n}=0;
error{n}=0;
A_new=0;
topK(1,n)=0;
topIndices(d,n)=0;
topCoeffs(d,n)=0;
hcount(n)=0;
x(1,d)=0;
str='s01\face';
%Flag for plotting histogram and error
isPlot=0;
%Flag for plotting images from given Eigen vector bases
isEigPlot=0;

for itr=1:n
    %Reading data from given image%
    A{itr}=imread(strcat(str,int2str(itr),'.pgm'));
    %Converting given image into a vector%
    B{1,itr}=A{itr}(:);
    %Find projection of image on given eigen bases%
    for k=1:d
        t=COEFF(:,k);
        b=double(B{1,itr}(:,1));
        A_proj{1,itr}(1,k)=((t(1,1)*t')*b)./(t'*t);
    end
    %Find scaling factors for given eigen bases%
    for k=1:d
        x(k)=A_proj{1,itr}(1,k)/COEFF(1,k);
    end
    %Sort scaling factors in descending order%
    [X_new,ind]=sort(abs(x),'descend');
    %Selecting top k eigen vectors such that the relative error of reconstructed image < 0.01 %
    A_new=0;A_new_NoCf=0;
    for k=1:d
        A_new=A_new+(x(ind(k))*COEFF(:,ind(k)));
        %A_new=A_new+(x(k)*COEFF(:,k));
        A_new_NoCf=A_new_NoCf+COEFF(:,ind(k));
        err=norm(double(B{1,itr})-A_new,'fro')/norm(double(B{1,itr}),'fro');
        error{1,itr}(k)=err;
        if err<0.01
            break;
        end
    end
    %Assigning final results into variables%
    A_final{1,itr}=A_new;
    A_final_NoCoeff{1,itr}=A_new_NoCf;
    topK(1,itr)=k;
    topIndices(:,itr)=ind;
    topCoeffs(:,itr)=x(ind);
end
fprintf('Image#\tTop K\n');
fprintf('------\t-----\n');
for k=1:n
    fprintf('  %d  \t%d\n',k,topK(k));
end
if isPlot==1
    close all;
    for k=1:n
        tit=sprintf('Hist_%d',k);
        st=strcat('\color[rgb]{0.31 0.34 0.46}Intensity Histogram',' ',int2str(k));
        figure;
        h=histogram(A{1,k});
        h.NumBins = 26;
        h.FaceColor = [0.495 0.460 0.475];
        h.EdgeColor = [0.31 0.34 0.46];
        hcount(k,1:h.NumBins)= histcounts(A{1,k},h.NumBins);
        xlabel('\color[rgb]{0.31 0.34 0.46}Intensity Value');
        ylabel('\color[rgb]{0.31 0.34 0.46}No. of Pixels');
        title(st);
        get(gca, 'XTick');
        set(gca, 'FontSize', 12);
        % % % % % %                 savefig(['Plots\' tit '.fig']);
        
        
        tit=sprintf('coeff_log_%d',k);
        st=strcat('\color[rgb]{0.31 0.34 0.46}Top K Coefficients',' ',int2str(k));
        figure;
        h=plot(log(abs(topCoeffs(:,k))),...
        'color',[0.31 0.34 0.46],...
        'LineWidth',2);
        xlabel('\color[rgb]{0.31 0.34 0.46}No. of Coefficients(Lambda)');
        ylabel('\color[rgb]{0.31 0.34 0.46}log(Coeffcient Value)');
        title(st);
        get(gca, 'XTick');
        set(gca, 'FontSize', 12);
        % % % % %          savefig(['Plots\' tit '.fig']);
    end
end

if isEigPlot==1
    figure;
    dummy=COEFF(:,1);
    imshow(uint8(10000*reshape(dummy,92,92)));
    figure;
    dummy=sum([COEFF(:,1:2)],2);
    imshow(uint8(6000*reshape(dummy,92,92)));
    figure;
    dummy=sum([COEFF(:,1:5)],2);
    imshow(uint8(4000*reshape(dummy,92,92)));
    figure;
    dummy=sum([COEFF(:,1:100)],2);
    imshow(uint8(800*reshape(dummy,92,92)));
    figure;
    dummy=sum([COEFF(:,1:6000)],2);
    imshow(uint8(180*reshape(dummy,92,92)));
end
