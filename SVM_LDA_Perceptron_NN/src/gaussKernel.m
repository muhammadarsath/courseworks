function result=gaussKernel(X,X_n,h)
rows=size(X_n,1);
d=size(X_n,2);
a=(2*pi)^(d/2);
b=det(h)^0.5;
Z=mvnpdf(X_n,X,h);
result=sum(Z)/rows;
end