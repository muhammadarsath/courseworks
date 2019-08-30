function data_features=extractFeatures(data_2d_new)
data_sz=cellfun('length',data_2d_new);
for k=1:size(data_2d_new,1)
    for j=1:size(data_2d_new,2)
        curr_sz=data_sz(k,j);
        if curr_sz==0
            break;
        end
        for x=1:curr_sz-1
            x1=data_2d_new{k,j}(1,x);y1=data_2d_new{k,j}(2,x);
            x2=data_2d_new{k,j}(1,x+1);y2=data_2d_new{k,j}(2,x+1);
            temp=atan2(y2-y1,x2-x1)*180/pi;
            if temp<0
                temp=360+temp;
            end
            data_features{k,j}(x)=floor(temp/45) + 1;
        end
    end
end
end

