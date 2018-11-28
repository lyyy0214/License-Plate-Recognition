function porpotion = slidWindow(grey, m, n)
%滑动窗口来计算每个像素在车牌内的可能性(返回矩阵)



%灰度图的尺寸
row = size(grey, 1);
line = size(grey, 2);
fprintf('\n正在进行滑动窗口计算,共有%d行\n', row);
%包含蓝白比例的图
porpotion = zeros(row, line);

%计算滑动窗口的行开始、行结束、列开始与列结束
rowStart = (m - 1)/2 + 1;
rowEnd = row - rowStart;
lineStart = (n - 1)/2 + 1;
lineEnd = line - lineStart;
k=rowStart;

for i = rowStart:rowEnd
    for j = lineStart:lineEnd
        %计算窗口内的蓝白比例
        porpotion(i ,j) = windowPorpotion(grey, i, j, m, n);
    end
    k = k+1;
    if rem((k-rowStart),100)==0,
        fprintf('\n 滑动窗口检测第%d00行\n',(k-rowStart)/100);
    end
end

