function result = findSlope(data)
for k=3:size(data,2)-2
    x_t=0;y_t=0;
    for j=1:2
        x_t=x_t+j*(data(1,k+j)-data(1,k-j));
        y_t=y_t+j*(data(2,k+j)-data(2,k-j));
    end
    x_t=x_t/10;
    y_t=y_t/10;
    result(1,k)=x_t;
    result(2,k)=y_t;
end
result = result(:,3:end);

end