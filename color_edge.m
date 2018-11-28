function [ im_col_edg ] = color_edge( image_ori )

%��ɫ�Ա�Ե��⺯��corlor_edge
%���룺��ɫԭͼ
%�������ɫ�ĻҶ�ͼ��ֵ��Լ��0~1��

%image_ori=imread('E:\MATLAB\t6.jpg');%��ȡͼƬ
%image�ֱ�ȡr/g/bͼ
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
  
%���ݶ�
r_grad=gradient(image_r);
g_grad=gradient(image_g);
b_grad=gradient(image_b);
% ��ҪͳһͼƬ�ֱ���ô��

[w,h]=size(r_grad);%��ȡͼƬ��С

im_edge=zeros(w,h);%�½�һ��ͼ��

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
%���ˣ�im_edgeΪ���ױ�Եͼ��һ�¶�����к�������
SE=strel('rectangle',[9,3]); %����ṹԪ�������С�ɵ���
im_expanded=imdilate(im_edge,SE);
%������ϣ���ʼ����ģ������
im_vague=zeros(w,h);
min_vague=1000;
max_vague=0;
for i=5:w-4
    for j=2:h-2
        sum=0;
        for s=i-4:i+4   %�˴���4���·���1����9*3�������ģ���������ɵ�
           for t=j-1:j+1
               sum=sum+im_expanded(i,j)*exp((-(s-i)^2-(t-j)^2)/3);%�˴�3Ϊģ�����߶�
           end
        end
        im_vague(i,j)=sum;
        if (sum<min_vague)
            min_vague=sum;
        end   %ȡmin(F_r)
        if (sum>max_vague)
            max_vague=sum;
        end     %ȡmax(F_r)
    end   
end
full=max_vague-min_vague;
%һ�½��й�һ������һ����ɫ-��Ե���ͼ
im_col_edg=zeros(w,h);
for i=1:w
    for j=1:h
        %im_col_edg(i,j)=((im_vague(i,j)-min_vague)/full);
        im_col_edg(i,j)=1-((im_vague(i,j)-min_vague)/full);
        %ȥ����ɫ�������1-ȥ��
    end
end

imshow(im_col_edg);

end

