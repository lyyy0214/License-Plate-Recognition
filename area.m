function [ possibility,BH,SI ] = area( rgb )

%ͳ������
meanH = 0.63;
thetaH = 0.07;
meanSb = 0.8;
meanSw = 0.06;
meanI = 0.8;
thetaSb = 0.1;
thetaSw = 0.1;
thetaI = 0.15;

%���ͺ�������
a = 0.4656;
b = 1;
c = 0.1;

%�������ڴ�С
m = 35;
n = 115;

%��rgbͼ
%rgb = imread('./data/test3.jpg');

%ת��Ϊhsiͼ
hsi = rgb2hsi(rgb);
%figure, imshow(hsi);
BH=hsi(:, :, 1);
SI=hsi(:, :, 2);
WI=hsi(:, :, 3);

%����ͳ������ת��Ϊ�Ҷ�ͼ
grey = hsi2grey(meanH, meanSb, meanSw, meanI, ...
                        thetaH, thetaSb, thetaSw, thetaI, hsi);

%imshow(grey);


%���ݻҶ�ͼת��Ϊ���ڱ���ͼ
porpotion = slidWindow(grey, m, n);

%figure, imshow(porpotion), title('PORPOTION');

%porpotion;

%���ݴ��ڱ���ͼ�����ڳ����ϵĿ�����
possibility = posibility(porpotion ,a, b, c);

%imshow(possibility);;

end

