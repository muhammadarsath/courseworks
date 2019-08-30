function [digitcell,names]=loadFiles(path,filename1,type,slash)
for j=1:size(filename1,1)
    pathstr1=strcat(path, filename1(j).name, slash);
    filename2= dir(pathstr1);
    filename2 = filename2(~cellfun(@invalidFolders,{filename2.name}));
    for k=1:size(filename2,1)
        pathstr2=strcat(pathstr1, filename2(k).name, slash, '*.', type);
        files=dir(pathstr2);
        data={};
        for m=1:size(files,1)
            fileLoc=strcat(pathstr1, filename2(k).name, slash, files(m).name);
            ind=(k-1)*size(files,1)+m;
            temp=importdata(fileLoc,' ',1);
            digitcell{j,ind}=temp.data;
            names(j,ind)={strcat(filename1(j).name, '_', filename2(k).name, '_', files(m).name)};
        end
    end
end