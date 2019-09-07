clear all;
close all;
% Init setup %
cam=webcam('UVC Camera (046d:0825)');
preview(cam);
run=true;
capture=false;
start='';
stop='';
initialskip=8; % 8 - 500ms, 4 - 200ms, 2-100ms
stopCounter=0;
othercolor=0;
counter=1;
sampleIndex=0;
freq=1;
prev='';
stream='';
prevcolor='A';
mr=0;mg=0;mb=0;
samecolor=0;Key={'null','null','null','null','null','null','null','null','null','00101101111000010','01110','null','null','null','null','null','null','null','null','null','null','null','null','null','null','null','null','null','null','null','null','null','111','11000000','101100000','10110000100','10110001100011001','00101101111000011','1011000110001101','001011010','001000101101','001000101100','001000101111','1011000110001111','101111','0010111','0010000','0010110110000','001011011001','11000011100','110000111011','101100011001','1011000110000','0010110111111','0010110111101','0010110110001','1100001110101','0010110111010','0010001010','00100101','001011011101100','001011011110001','001011011110010','00101101101','10110001100011000','11000110','110001111','1100001111','101001010','00100100','101100010','101001011','00100011','11000010','001000101110','1011000111','101001001','00101100','110000110','110001110','110000010','0010110111110','101001110','10100110','1000001','1010011111','1010011110','110000011','001011011100','1011000011','001011011101110','10110000101','001011011101101','10110001101','001011011110011','1011000110001110','0010110111100000','0101','1011001','101010','01111','1101','101101','101011','0000','0011','101001000','0010011','10001','101000','0100','0110','1100010','0010001001','11001','0001','1001','101110','1000000','100001','0010001000','001010','1100001110100','101100011000100','101100011000101','001011011101111','null','null'};
value=[1:128];
M = containers.Map(Key,value);
while(run)
    img=snapshot(cam);
    % Crop only interested region %
    dim=[500 500 200 200];
    cropped=imcrop(img,dim);
    r=cropped(:,:,1);g=cropped(:,:,2);b=cropped(:,:,3);
    mean_r=mean(r(:));mean_g=mean(g(:));mean_b=mean(b(:));
    color=getColor_ratio(mean_r,mean_g,mean_b);
    %%% check for start packet %%%
    if(~capture)
        if(strcmp(color,'G'))
            if(strcmp(start,''))
                start=strcat(start, color);
            elseif(~strcmp(start,'G'))
                start='';
            end
        elseif(strcmp(color,'R'))
            if(strcmp(start,'G')||strcmp(start,''))
                start=strcat(start,color);
            elseif(~strcmp(start,'GR')&&~strcmp(start,'R'))
                start='';
            end
        elseif(strcmp(color,'B'))
            if(strcmp(start,'GR')||strcmp(start,'R'))
                start=strcat(start,color);
                capture=true;
                sampleIndex=counter+initialskip;
                tic;
                disp('_____________START RECORDING______________');
            elseif(~strcmp(start,'GRB')&&~strcmp(start,'RB'))
                start='';
            end
        elseif(othercolor>5)
            start='';othercolor=0;
        else
            othercolor=othercolor+1;
        end
    end
    %%% decode color %%%
    if(capture && counter==sampleIndex)
        stream=[stream,color];
        sampleIndex=sampleIndex+freq;
    end
    if(capture)
        if(strcmp(color,'G'))
            if(strcmp(stop,''))
                stop=strcat(stop, color);
            elseif(~strcmp(stop,'G'))
                stop='';
            end
        elseif(strcmp(color,'R'))
            if(strcmp(stop,'G')||strcmp(stop,''))
                stop=strcat(stop,color);
            elseif(~strcmp(stop,'GR')&&~strcmp(stop,'R'))
                stop='';
            end
        elseif(strcmp(color,'B'))
            if(strcmp(stop,'GR')||strcmp(stop,'R'))
                stop=strcat(stop,color);
                run=false;
                disp('____________END RECORDING___________');
                toc
            elseif(~strcmp(stop,'GRB')&&~strcmp(stop,'RB'))
                stop='';
            end
        elseif(othercolor>5)
            stop='';othercolor=0;
        else
            othercolor=othercolor+1;
            
        end
    end
    counter=counter+1;
    
    %%%Same color check %%%
    if(strcmp(color,prev) && capture)
        samecolor=samecolor+1;
    else
        samecolor=0;
    end
    if(samecolor >80)
        run=false;
    end
    prev=color;
end
% 25 - 500,400 ms
% 10 -300 ms , 5- 200ms
stream=stream(1:end-25); %removing endpackets

% Plotting Stream %
order = {
    'No value'      [0]
    'Yellow'           [1]
    'Red'          [2]
    'Orange'         [3]
    'Green'        [4]
    'Pink'          [5]
    'Blue'          [6]
    'White'        [7]
    'Cyan'         [8]};
Rawstream=color2int(stream);
plot(Rawstream);
set(gca,'YtickLabel',order(:,1));
% Decoding Message %
Finalstream=processData(Rawstream);
% Yellow-Orange correction %
for i=1:length(Finalstream)
    temp=Finalstream{i};
    if(~isKey(M,temp))
        for j=1:floor(length(temp)/2)
            if(strcmp(temp((2*j)-1:2*j),'00') && ((2*j)<length(temp)-1 || mod(length(temp),2)==1))
                temp((2*j)-1:2*j)='01';
            elseif(strcmp(temp((2*j)-1:2*j),'01') && ((2*j)<length(temp)-1 || mod(length(temp),2)==1))
                temp((2*j)-1:2*j)='00';
            end
        end
        %disp('Orange <--> Yellow correction..');%temp
    end
    Finalstream{i}=temp;
end
%msg='The quick brown fox jumps over the lazy dog.';
%msg2binary(msg,Finalstream); % To find bit errors
message=decodeMessage(Finalstream)
%printBinary(Finalstream); % received binary stream

% Save message into a file %
fid=fopen('message.txt','w');
fprintf(fid, '%s', message');
fclose(fid);