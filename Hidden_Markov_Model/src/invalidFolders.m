function y = validFolders(x)
if (isequal(x,'.') || isequal(x,'..') || isequal(x,'desktop.ini'))
    y=1;
else
    y=0;
end
end