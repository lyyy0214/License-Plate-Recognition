function [Ans ] = step1_combine( F1,F2,F3,ori,H,S )

para_varH=5;

%��Ϊ�������ŻҶ�ͼ(��Ҫ�����255ô��)
%����ͼ���ӣ������õ����ӽ��F
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

%��ô����ڵ����򣿡�C(,)/cx1,cy1,cx2,cy2?

[cx1,cy1,cx2,cy2]=find_black( F );

%fprintf("%d %d %d %d",cx1,cx2,cy1,cy2);

C=imcrop(ori, [cx1, cy1, cx2-cx1, cy2-cy1]);
%%�������ݣ�����һ��C��ȷ��λ����
%%ǰ�᣺C����Ҫ�г���-���ԣ�

%���ƾ�ȷ��⣺ͨ��H��S
H_var=std2(H)^2*para_varH;
S_var=std2(S)^2*3;
H_max=max(max(H));
S_max=max(max(S));
%����C����L׼����⣺������٣�
lx1=cx1;
lx2=cx2;
ly1=cy1;
ly2=cy2;
% ���������ˣ��Һ�ɫ���Ƶ������ȵ��͵�ͺ�
%������ֵͼM
L_hsi = rgb2hsi(C);
L_h=L_hsi(:, :, 1); %{L��ɫ��ͼ};
L_s=L_hsi(:, :, 2); %{L�ı��Ͷ�ͼ};

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
%M�����&������
M_fill=imfill(M_ori,'hole');
se=strel('disk',10');%Բ���ͽṹԪ��
M=imclose(M_fill,se);
%M�������
%����Bͼ
H_l=[0,0,0;-1,2,-1;0,0,0];
%��L������ǿ����ô�������ٶ�ֵ����B
L=edge(rgb2gray(C),'sobel','vertical');
B=L;

E=zeros(s,t);
for i=1:s
    for j=1:t
        E(i,j)=M(i,j)*B(i,j);
    end
end
%imshow(E);
%�ڴ�E������ڵ�C��������ʼ�Һ�ɫ�������ķ�����ͬ

[ax1,ay1,ax2,ay2]=find_black( E );

%fprintf("\n%d %d %d %d",ax1,ax2,ay1,ay2);

Ans=imcrop(C, [ax1, ay1, ax2-ax1, ay2-ay1]);
imshow(Ans);
end

