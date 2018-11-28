function p = posibility(porpotion, a, b, c)
%根据porpotion图计算每个点属于车牌的可能性

%计算钟型函数矩阵
%G = clockk(porpotion, a, b, c);

%minG = min(min(G));
%p = G - minG;
%maxP = max(max(p));

%p = p / maxP;
row = size(porpotion, 1);
line = size(porpotion, 2);
p = zeros(row, line);
for i=1:row,
    for j=1:line,
        if porpotion(i,j)>0.7 && porpotion(i,j)<0.75,
            p(i,j)=0;
        else
            p(i,j)=1;
        end
    end
end


