function pMean = windowPorpotion(grey, row, line, m, n)
%row,line代表点的索引；m，n是窗口大小

pAmount = 0;

for i = row - (m-1)/2:row + (m-1)/2
    for j = line - (n-1)/2: line + (n-1)/2
        pAmount = pAmount + grey(i, j);
    end
end

pMean = pAmount/(m*n);