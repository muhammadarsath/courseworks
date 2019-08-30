function result=postProcessingNLS(result_5c)
% Assigning clusters into the corresponding classes %
index=cellfun(@isempty,result_5c);
for k=1:size(index,1)
    for m=1:size(index,2)
        if index(k,m) == 1 break; end
        for n=1:size(result_5c{k,m},1)
            if (result_5c{k,m}(n,4)==1||result_5c{k,m}(n,4)==2)
                result{k,m}(n,:)=[result_5c{k,m}(n,1:3) 1];
            elseif (result_5c{k,m}(n,4)==4||result_5c{k,m}(n,4)==5)
                result{k,m}(n,:)=[result_5c{k,m}(n,1:3) 3];
            else
                result{k,m}(n,:)=[result_5c{k,m}(n,1:3) 2];
            end
        end
    end
end

end