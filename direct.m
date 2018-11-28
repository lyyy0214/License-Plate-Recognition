function [im_direct] = direct( rgb )
thresh=3;

im=double(rgb2gray(rgb)); %%%�ҶȻ���������ת�ɸ�����
im=imresize(im,[1024,2048]);%��������ͼƬ��С  [1024,2048]
% % �Ҷ�����
% % im=imadjust(Image,[0.15 0.9],[]);
  s=strel('disk',10);%strei���� %%%s=Բ�̣��뾶10 Ϊʲô��Բ���뾶��С������
 Bgray=imopen(im,s);%��sgray sͼ�� %%%�����㣬�ȸ�ʴ�����ͣ������ɫ
% figure,imshow(Bgray);title('����ͼ��');%�������ͼ��
% %��ԭʼͼ���뱳��ͼ������������ǿͼ��
 im=imsubtract(im,Bgray);%����ͼ���  %%%��ñ���㣨Top Hat����ͻ���˱�ԭͼ������Χ�����������������
 %%%������ڽ�����һЩ�İ߿飬���糵���ϵ�����
%figure,imshow(mat2gray(im));title('��ǿ�ڰ�ͼ��');%����ڰ�ͼ��

[Lo_D,Hi_D]=wfilters('db2','d'); % d Decomposition filters
[C,S]= wavedec2(im,1,Lo_D,Hi_D); %Lo_D  is the decomposition low-pass filter
% decomposition vector C    corresponding bookkeeping matrix S
isize=prod(S(1,:));%Ԫ������
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


I2=edge(cV,'sobel',thresh,'vertical');%������ָ�������ж���ֵthresh������ָ���ķ���direction��
%�Բ�ͬͼƬ�����ж���ֵ��ͬ!!!!!!
a1=imclearborder(I2,8); %8��ͨ ���ƺ�ͼ��߽�������������
se=strel('rectangle',[10,20]);%[10,20]
I4=imclose(a1,se);
st=ones(1,8); %ѡȡ�ĽṹԪ��
bg1=imclose(I4,st); %������
bg3=imopen(bg1,st); %������
bg2=imopen(bg3,[1 1 1 1]'); 
I5=bwareaopen(bg2,500);%�Ƴ����С��2000��ͼ��
I5=imclearborder(I5,4); %8��ͨ ���ƺ�ͼ��߽�������������
 
im_direct = I5; 
im_direct = im_direct-im_direct;
 
 %���ó���Ƚ�������ɸѡ
[L,num] = bwlabel(I5,8);%��ע������ͼ���������ӵĲ���,c3����̬ѧ������ͼ��
Feastats =regionprops(L,'basic');%����ͼ������������ߴ�
Area=[Feastats.Area];%�������
BoundingBox=[Feastats.BoundingBox];%[x y width height]���ƵĿ�ܴ�С
RGB = label2rgb(L,'spring','k','shuffle'); %��־ͼ����RGBͼ��ת��
     
lx=1;%ͳ�ƿ�͸�����Ҫ��Ŀ��ܵĳ����������
Getok=zeros(1,10);%ͳ������Ҫ�����

for l=1:num  %num�ǲ�ɫ����������
width=BoundingBox((l-1)*4+3);
hight=BoundingBox((l-1)*4+4);
rato=width/hight;%���㳵�Ƴ����
%������֪�Ŀ�ߺͳ��ƴ���λ�ý���ȷ����
if(width>70 & width<250 & hight>15 & hight<70 &(rato>3&rato<8)&((width*hight)>Area(l)/2))%width>50 & width<1500 & hight>15 & hight<600
        Getok(lx)=l;
        lx=lx+1;  
end
end
startrow=1;startcol=1;
[original_hihgt original_width]=size(cA);


for order_num=1:lx-1 %���ô�ֱͶӰ�����ֵ������ȷ������
  area_num=Getok(order_num);
  startcol=round(BoundingBox((area_num-1)*4+1)-2);%��ʼ��
  startrow=round(BoundingBox((area_num-1)*4+2)-2);%��ʼ��  
  width=BoundingBox((area_num-1)*4+3)+2;%���ƿ�
  hight=BoundingBox((area_num-1)*4+4)+2;%���Ƹ� 
  uncertaincy_area=cA(startrow:startrow+hight,startcol:startcol+width-1); %��ȡ���ܳ�������
  %image_binary=binaryzation(uncertaincy_area);%ͼ���ֵ��
  zmax=max(max(uncertaincy_area));zmin=min(min(uncertaincy_area));
  image_binary=(zmax+zmin)/2;
  histcol_unsure=sum(uncertaincy_area);%���㴹ֱͶӰ
   histcol_unsure=smooth(histcol_unsure)';%ƽ���˲�
      histcol_unsure=smooth(histcol_unsure)';%ƽ���˲�
      average_vertical=mean(histcol_unsure);
  [data_1 data_2]=size(histcol_unsure);
  peak_number=0; %�жϷ�ֵ����
  for j=2:data_2-1%�жϷ�ֵ����
      if (histcol_unsure(j)>histcol_unsure(j-1))&(histcol_unsure(j)>histcol_unsure(j+1))
          peak_number=peak_number+1;
      end
  end
  valley_number=0; %�жϲ��ȸ���
  %�ٿ�һ�����飬���ƺŵĲ��ȹȵ״�СӦ������
  
  for j=2:data_2-1
      if (histcol_unsure(j)<histcol_unsure(j-1))&(histcol_unsure(j)<histcol_unsure(j+1)) &(histcol_unsure(j)<average_vertical)
           %����ֵ��ƽ��ֵС
          valley_number=valley_number+1;
      end
  end
  %peak_number<=15
  %���岨��ɸѡ
 if peak_number>=7 && peak_number<=18 &&valley_number>=4 && (startcol+width/2)>=original_width/6 &&(startcol+width/2)<=5*original_width/6....
     &&(startrow+hight/2)>=original_hihgt/6 && (startrow+hight/2)<=original_hihgt*5/6
     %��һ��ȷ�Ͽ�������

      for i=startrow:1:startrow+hight,
          for j = startcol:1:startcol+width,
              im_direct(i,j) = 1;
          end
      end
 end  
im_direct = 1 - im_direct;
end

