function writeSequence(splitIndex,sequence,n,fname,pathstr)
N=size(splitIndex,2)/n;
offset=0;
for k=1:N
    fpath=strcat(pathstr, fname{k});
    fileID = fopen(fpath,'w');
    for j=(k-1)*n+1:k*n
        temp=sequence(offset+1:offset+splitIndex(j));
        fprintf(fileID,'%d ',temp);
        fprintf(fileID,'\n');
        offset=offset+splitIndex(j);
    end
    fclose(fileID);
end
