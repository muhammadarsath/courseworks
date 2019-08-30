function writeCharSequence(splitIndex,sequence,fname,pathstr)
offset=0;
for k=1:size(splitIndex,1)
    fpath=strcat(pathstr, fname{k});
    fileID = fopen(fpath,'w');
    tempr=splitIndex(k,find(~ismember(splitIndex(k,:),0)));
    for j=1:size(tempr,2)
        temp=sequence(offset+1:offset+splitIndex(k,j));
        fprintf(fileID,'%d ',temp);
        fprintf(fileID,'\n');
        offset=offset+splitIndex(k,j);
    end
    fclose(fileID);
end
