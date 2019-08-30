function len = fileLength(digitcell)
len = zeros(size(digitcell,1),1);
for i = 1 : size(digitcell,1)
    for j = 1 : size(digitcell,2)
        len(i) = len(i) + size(digitcell{i,j},1);
    end
    len(i) = len(i) / size(digitcell,2);
end
end