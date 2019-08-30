function [data,newData] = upSamplerCharacter
pathstr='HandWritten_data/DATA/FeaturesHW/';
data=loadFilesHandwritten(pathstr,'txt');
newData = cell(length(data),1);

for i = 1 : length(data)
    index = 1;
    for j = 1 : length(data{i})
        dummy = reshape(data{i}{j},2,length(data{i}{j})/2);
        dummy(1,:) = dummy(1,:) - mean(dummy(1,:));
        dummy(1,:) = dummy(1,:) * 2;
        for theta = -0.17: 0.02: 0.17
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            newData{i}{index} = R*dummy;
            newData{i}{index} = newData{i}{index}(:)';
            index = index + 1;
        end
        newData{i}{index} = dummy(:)';
    end
end
end