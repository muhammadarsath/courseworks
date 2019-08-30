function [digitcell]=loadFilesHandwritten(path, type)
str=strcat(path, '*.', type);
filenames=dir(str);
filenames = filenames(~cellfun(@invalidFolders,{filenames.name}));
for k=1:size(filenames,1)
    fileLoc=strcat(path, filenames(k).name);
    temp=importdata(fileLoc,'\n');
    for j=1:size(temp,1)
        temp{j,1} = str2double (strsplit(num2str(temp{j,1}),' '));
    end
    s=size(temp',2);
    digitcell(k,1:s)=temp';
end
end