function stream=color2int(colors)
val=["" "Y" "R" "O" "G" "P" "B" "W" "C"];
for i=1:length(colors)
    stream(i)=double(find(strcmp(val,colors(i))))-1;
end
end