function porpotion = slidWindow(grey, m, n)
%��������������ÿ�������ڳ����ڵĿ�����(���ؾ���)



%�Ҷ�ͼ�ĳߴ�
row = size(grey, 1);
line = size(grey, 2);
fprintf('\n���ڽ��л������ڼ���,����%d��\n', row);
%�������ױ�����ͼ
porpotion = zeros(row, line);

%���㻬�����ڵ��п�ʼ���н������п�ʼ���н���
rowStart = (m - 1)/2 + 1;
rowEnd = row - rowStart;
lineStart = (n - 1)/2 + 1;
lineEnd = line - lineStart;
k=rowStart;

for i = rowStart:rowEnd
    for j = lineStart:lineEnd
        %���㴰���ڵ����ױ���
        porpotion(i ,j) = windowPorpotion(grey, i, j, m, n);
    end
    k = k+1;
    if rem((k-rowStart),100)==0,
        fprintf('\n �������ڼ���%d00��\n',(k-rowStart)/100);
    end
end

