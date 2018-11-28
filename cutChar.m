function char = cutChar( raw )
clear all();
% k = 145;
% for k = 1:1:72
%     raw = imread(['BJ73/北京 (',num2str(k), ').jpg']);
%     raw = imread(['plate/',num2str(k), '.jpg']);
%     raw = imread(['plate_sample/',num2str(k), '.jpg']);
%     raw = imread(['all/',num2str(k), '.jpg']);
% raw = imread(['alphabet/',num2str(k), '.jpg']);
% raw = imread(['sample/ans (',num2str(72), ').jpg']);
%plate = ori_get_plate(im)
raw = rgb2gray(raw);
limit = graythresh(raw);
%bw = imbinarize(raw, 'adaptive');
bw = im2bw(raw, limit);


bw1=edge(bw);  
[m,n]=size(bw);  
theta=1:179;  
% bw 表示需要变换的图像，theta 表示变换的角度  
% 返回值 r 表示的列中包含了对应于 theta中每一个角度的 Radon 变换结果  
% 向量 xp 包含相应的沿 x轴的坐标  
[r,xp]=radon(bw1,theta);  
i=find(r>0);  
[foo,ind]=sort(-r(i));  
k=i(ind(1:size(i)));  
[y,x]=ind2sub(size(r),k);  
[mm,nn]=size(x);  
if mm~=0 && nn~=0  
    j=1;  
    while mm~=1 && j<180 && nn~=0  
        i=find(r>j);  
        [foo,ind]=sort(-r(i));  
        k=i(ind(1:size(i)));  
        [y,x]=ind2sub(size(r),k);  
        [mm,nn]=size(x);  
        j=j+1;  
    end  
    if nn~=0  
        if x   % Enpty matrix: 0-by-1 when x is an enpty array.  
            x=x;  
        else  % 可能 x 为空值  
            x=90; % 其实就是不旋转  
        end  
        bw=imrotate(bw,abs(90-x)); % 旋转图像  
        rotate=1;  
    end  
end  


figure, imshow(bw);
pause;


%se = strel('rectangle', [3, 5]);
seo = strel('square', 1);
% sec = strel('square', 1);
% se = strel('square', 1);
im_open = imopen(bw, seo);
% im_close = imclose(bw_o, sec);
s = regionprops(im_open, 'BoundingBox');
bb = round(reshape([s.BoundingBox], 4, []).');
% figure;
% imshow(bw);
% for idx = 1 : numel(s)
%     rectangle('Position', bb(idx,:), 'edgecolor', 'red');
% end
% imwrite(bw, 'bb.jpg');
cn = cell(1, numel(s));
for idx = 1 : numel(s)
    cn{idx} = bw(bb(idx,2):bb(idx,2)+bb(idx,4)-1, bb(idx,1):bb(idx,1)+bb(idx,3)-1);
end
% index = zeros(7, 4);
% j = 1;
sr = sortrows(bb, 4);
threshold = median(sr(size(sr, 1) - 9:size(sr, 1), 4));
seg = zeros(size(bb,1), 2);
for i = 1:1:size(bb,1)
    seg(i, 1) = abs(bb(i, 4) - threshold);
    seg(i, 2) = i;
end
seg = sortrows(seg, 1);
candidates = sortrows(seg(1:7, :), 2);
char = cell(1, numel(s));
for i = 1 : 1 : size(candidates ,1)
    idx = candidates(i, 2);
    char{i} = raw(bb(idx,2):bb(idx,2)+bb(idx,4)-1, bb(idx,1):bb(idx,1)+bb(idx,3)-1);
end
for i = 1:1:7
    im = char{i};
    im = imresize(im, [32, 32]);
%     imwrite(im, ['label_BJ\',num2str(k+73+76+55+23), '_', num2str(i),'.jpg']);
    char{i} = im;
end
end