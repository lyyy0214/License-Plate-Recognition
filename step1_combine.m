function [Ans ] = step1_combine( F1,F2,F3,ori,H,S )

para_varH=5;

%认为输入两张灰度图(需要扩充成255么？)
%两张图叠加，初步得到叠加结果F
[w,h]=size(F1);
F=zeros(w,h);
for i=1:w
   for j=1:h
      F(i,j)=max(F1(i,j)+F3(i,j)-1,0);
   end
end
%%%%%
%F=F1;
%%%%%

%怎么找最黑的区域？→C(,)/cx1,cy1,cx2,cy2?

[cx1,cy1,cx2,cy2]=find_black( F );

%fprintf("%d %d %d %d",cx1,cx2,cy1,cy2);

C=imcrop(ori, [cx1, cy1, cx2-cx1, cy2-cy1]);
%%以下内容：扩大一下C精确定位车牌
%%前提：C中先要有车牌-测试？

%车牌精确检测：通过H与S
H_var=std2(H)^2*para_varH;
S_var=std2(S)^2*3;
H_max=max(max(H));
S_max=max(max(S));
%扩充C区域到L准备检测：扩大多少？
lx1=cx1;
lx2=cx2;
ly1=cy1;
ly2=cy2;
% 不用扩大了，找黑色车牌的灵敏度调低点就好
%建立二值图M
L_hsi = rgb2hsi(C);
L_h=L_hsi(:, :, 1); %{L的色调图};
L_s=L_hsi(:, :, 2); %{L的饱和度图};

[s,t]=size(L_h);
M_ori=zeros(s,t);

for i=1:s
   for j=1:t
       %fprintf("%d %d %d\n",H_max-H_var,L_h(i,j),H_max+H_var);
      % fprintf("%d %d %d\n",S_max-S_var,L_s(i,j),S_max+S_var);
      if ((H_max-H_var<L_h(i,j) && L_h(i,j)<H_max+H_var))%...
              %&& S_max-S_var<L_s(i,j) && L_s(i,j)<S_max+S+var)
          M_ori(i,j)=1;
          
      end
   end
end
%M的填充&闭运算
M_fill=imfill(M_ori,'hole');
se=strel('disk',10');%圆盘型结构元素
M=imclose(M_fill,se);
%M构建完成
%构建B图
H_l=[0,0,0;-1,2,-1;0,0,0];
%对L纵向增强（怎么做？）再二值化出B
L=edge(rgb2gray(C),'sobel','vertical');
B=L;

E=zeros(s,t);
for i=1:s
    for j=1:t
        E(i,j)=M(i,j)*B(i,j);
    end
end
%imshow(E);
%在从E中找最黑的C区域→和最开始找黑色车牌区的方法相同

[ax1,ay1,ax2,ay2]=find_black( E );

%fprintf("\n%d %d %d %d",ax1,ax2,ay1,ay2);

Ans=imcrop(C, [ax1, ay1, ax2-ax1, ay2-ay1]);
imshow(Ans);
end

