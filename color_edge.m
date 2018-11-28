function [ im_col_edg ] = color_edge( image_ori )

%颜色对边缘检测函数corlor_edge
%输入：彩色原图
%输出：反色的灰度图（值规约到0~1）

%image_ori=imread('E:\MATLAB\t6.jpg');%获取图片
%image分别取r/g/b图
image_r=double(image_ori(:,:,1));
image_g=double(image_ori(:,:,2));
image_b=double(image_ori(:,:,3));


% %   subplot(2,2,1);
%  figure;
%    imshow(image_r);
% %   subplot(2,2,2);
%    figure;imshow(image_g);
% %   subplot(2,2,3);
%    figure;imshow(image_b);figure;
% %   subplot(2,2,4);
% %   imshow(image_ori);
  
%求梯度
r_grad=gradient(image_r);
g_grad=gradient(image_g);
b_grad=gradient(image_b);
% 需要统一图片分辨率么？

[w,h]=size(r_grad);%获取图片大小

im_edge=zeros(w,h);%新建一个图像

for i=1:w
    for j=1:h
        if ( abs(b_grad(i,j))<abs(r_grad(i,j)) && ...
             abs(b_grad(i,j))<abs(g_grad(i,j)) && ...
             abs(g_grad(i,j))<abs(r_grad(i,j)) && ...
             sign(r_grad(i,j))==sign(g_grad(i,j)) && ...
             sign(g_grad(i,j))==sign(b_grad(i,j)) )
            im_edge(i,j)=min(abs(r_grad(i,j)),abs(g_grad(i,j)));
        end
    end
end
%im_edge=uint8(im_edge);
%至此，im_edge为蓝白边缘图，一下对其进行横向膨胀
SE=strel('rectangle',[9,3]); %横向结构元：具体大小可调整
im_expanded=imdilate(im_edge,SE);
%膨胀完毕，开始进行模糊处理
im_vague=zeros(w,h);
min_vague=1000;
max_vague=0;
for i=5:w-4
    for j=2:h-2
        sum=0;
        for s=i-4:i+4   %此处的4，下方的1构成9*3区域进行模糊，参数可调
           for t=j-1:j+1
               sum=sum+im_expanded(i,j)*exp((-(s-i)^2-(t-j)^2)/3);%此处3为模糊区高度
           end
        end
        im_vague(i,j)=sum;
        if (sum<min_vague)
            min_vague=sum;
        end   %取min(F_r)
        if (sum>max_vague)
            max_vague=sum;
        end     %取max(F_r)
    end   
end
full=max_vague-min_vague;
%一下进行归一化，归一到颜色-边缘检测图
im_col_edg=zeros(w,h);
for i=1:w
    for j=1:h
        %im_col_edg(i,j)=((im_vague(i,j)-min_vague)/full);
        im_col_edg(i,j)=1-((im_vague(i,j)-min_vague)/full);
        %去除反色把这里的1-去掉
    end
end

imshow(im_col_edg);

end

