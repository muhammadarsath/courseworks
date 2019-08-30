function [digitcell, groundTruth]=loadFilesDTWConti(path, filename1, type, machine)
filename2= dir(path);
filename2 = filename2(~cellfun(@invalidFolders,{filename2.name}));
for k=1:size(filename2,1)
    fileLoc=strcat(path,  filename2(k).name);
    temp=importdata(fileLoc,' ',1);
    digitcell{k}=temp.data;
    groundTruth{k} = filename2(k).name;
end

end