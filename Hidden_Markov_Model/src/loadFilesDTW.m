function [digitcell]=loadFilesDTW(path, filename1, type, machine)
if machine == 'l'
    splitter = '/';
else
    splitter = '\';
end
for j=1:size(filename1,1)
    pathstr1=strcat(path, filename1(j).name, splitter,'*.', type);
    filename2= dir(pathstr1);
    filename2 = filename2(~cellfun(@invalidFolders,{filename2.name}));
    for k=1:size(filename2,1)
        fileLoc=strcat(path, filename1(j).name, splitter,filename2(k).name);
        temp=importdata(fileLoc,' ',1);
        digitcell{j,k}=temp.data;
    end
end
end