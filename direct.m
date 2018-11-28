function [im_direct] = direct( rgb )
thresh=3;

im=double(rgb2gray(rgb)); %%%灰度化函数，再转成浮点型
im=imresize(im,[1024,2048]);%重新设置图片大小  [1024,2048]
% % 灰度拉伸
% % im=imadjust(Image,[0.15 0.9],[]);
  s=strel('disk',10);%strei函数 %%%s=圆盘，半径10 为什么用圆？半径大小调整？
 Bgray=imopen(im,s);%打开sgray s图像 %%%开运算，先腐蚀再膨胀，连起黑色
% figure,imshow(Bgray);title('背景图像');%输出背景图像
% %用原始图像与背景图像作减法，增强图像
 im=imsubtract(im,Bgray);%两幅图相减  %%%顶帽运算（Top Hat），突出了比原图轮廓周围的区域更明亮的区域
 %%%分离比邻近点亮一些的斑块，比如车牌上的数字
%figure,imshow(mat2gray(im));title('增强黑白图像');%输出黑白图像

[Lo_D,Hi_D]=wfilters('db2','d'); % d Decomposition filters
[C,S]= wavedec2(im,1,Lo_D,Hi_D); %Lo_D  is the decomposition low-pass filter
% decomposition vector C    corresponding bookkeeping matrix S
isize=prod(S(1,:));%元素连乘
%
cA   = C(1:isize);%cA  49152
cH  = C(isize+(1:isize));
cV  = C(2*isize+(1:isize));
cD  = C(3*isize+(1:isize));
%
cA   = reshape(cA,S(1,1),S(1,2));
cH  = reshape(cH,S(2,1),S(2,2));
cV  = reshape(cV,S(2,1),S(2,2));
cD  = reshape(cD,S(2,1),S(2,2));

%imshow(im);


I2=edge(cV,'sobel',thresh,'vertical');%根据所指定的敏感度阈值thresh，在所指定的方向direction上
%对不同图片，敏感度阈值不同!!!!!!
a1=imclearborder(I2,8); %8连通 抑制和图像边界相连的亮对象
se=strel('rectangle',[10,20]);%[10,20]
I4=imclose(a1,se);
st=ones(1,8); %选取的结构元素
bg1=imclose(I4,st); %闭运算
bg3=imopen(bg1,st); %开运算
bg2=imopen(bg3,[1 1 1 1]'); 
I5=bwareaopen(bg2,500);%移除面积小于2000的图案
I5=imclearborder(I5,4); %8连通 抑制和图像边界相连的亮对象
 
im_direct = I5; 
im_direct = im_direct-im_direct;
 
 %利用长宽比进行区域筛选
[L,num] = bwlabel(I5,8);%标注二进制图像中已连接的部分,c3是形态学处理后的图像
Feastats =regionprops(L,'basic');%计算图像区域的特征尺寸
Area=[Feastats.Area];%区域面积
BoundingBox=[Feastats.BoundingBox];%[x y width height]车牌的框架大小
RGB = label2rgb(L,'spring','k','shuffle'); %标志图像向RGB图像转换
     
lx=1;%统计宽和高满足要求的可能的车牌区域个数
Getok=zeros(1,10);%统计满足要求个数

for l=1:num  %num是彩色标记区域个数
width=BoundingBox((l-1)*4+3);
hight=BoundingBox((l-1)*4+4);
rato=width/hight;%计算车牌长宽比
%利用已知的宽高和车牌大致位置进行确定。
if(width>70 & width<250 & hight>15 & hight<70 &(rato>3&rato<8)&((width*hight)>Area(l)/2))%width>50 & width<1500 & hight>15 & hight<600
        Getok(lx)=l;
        lx=lx+1;  
end
end
startrow=1;startcol=1;
[original_hihgt original_width]=size(cA);


for order_num=1:lx-1 %利用垂直投影计算峰值个数来确定区域
  area_num=Getok(order_num);
  startcol=round(BoundingBox((area_num-1)*4+1)-2);%开始列
  startrow=round(BoundingBox((area_num-1)*4+2)-2);%开始行  
  width=BoundingBox((area_num-1)*4+3)+2;%车牌宽
  hight=BoundingBox((area_num-1)*4+4)+2;%车牌高 
  uncertaincy_area=cA(startrow:startrow+hight,startcol:startcol+width-1); %获取可能车牌区域
  %image_binary=binaryzation(uncertaincy_area);%图像二值化
  zmax=max(max(uncertaincy_area));zmin=min(min(uncertaincy_area));
  image_binary=(zmax+zmin)/2;
  histcol_unsure=sum(uncertaincy_area);%计算垂直投影
   histcol_unsure=smooth(histcol_unsure)';%平滑滤波
      histcol_unsure=smooth(histcol_unsure)';%平滑滤波
      average_vertical=mean(histcol_unsure);
  [data_1 data_2]=size(histcol_unsure);
  peak_number=0; %判断峰值个数
  for j=2:data_2-1%判断峰值个数
      if (histcol_unsure(j)>histcol_unsure(j-1))&(histcol_unsure(j)>histcol_unsure(j+1))
          peak_number=peak_number+1;
      end
  end
  valley_number=0; %判断波谷个数
  %再开一个数组，车牌号的波谷谷底大小应当近似
  
  for j=2:data_2-1
      if (histcol_unsure(j)<histcol_unsure(j-1))&(histcol_unsure(j)<histcol_unsure(j+1)) &(histcol_unsure(j)<average_vertical)
           %波谷值比平均值小
          valley_number=valley_number+1;
      end
  end
  %peak_number<=15
  %波峰波谷筛选
 if peak_number>=7 && peak_number<=18 &&valley_number>=4 && (startcol+width/2)>=original_width/6 &&(startcol+width/2)<=5*original_width/6....
     &&(startrow+hight/2)>=original_hihgt/6 && (startrow+hight/2)<=original_hihgt*5/6
     %进一步确认可能区域

      for i=startrow:1:startrow+hight,
          for j = startcol:1:startcol+width,
              im_direct(i,j) = 1;
          end
      end
 end  
im_direct = 1 - im_direct;
end

