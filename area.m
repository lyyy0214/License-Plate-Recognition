function [ possibility,BH,SI ] = area( rgb )

%统计数据
meanH = 0.63;
thetaH = 0.07;
meanSb = 0.8;
meanSw = 0.06;
meanI = 0.8;
thetaSb = 0.1;
thetaSw = 0.1;
thetaI = 0.15;

%钟型函数参数
a = 0.4656;
b = 1;
c = 0.1;

%滑动窗口大小
m = 35;
n = 115;

%读rgb图
%rgb = imread('./data/test3.jpg');

%转化为hsi图
hsi = rgb2hsi(rgb);
%figure, imshow(hsi);
BH=hsi(:, :, 1);
SI=hsi(:, :, 2);
WI=hsi(:, :, 3);

%根据统计数据转化为灰度图
grey = hsi2grey(meanH, meanSb, meanSw, meanI, ...
                        thetaH, thetaSb, thetaSw, thetaI, hsi);

%imshow(grey);


%根据灰度图转化为窗口比例图
porpotion = slidWindow(grey, m, n);

%figure, imshow(porpotion), title('PORPOTION');

%porpotion;

%根据窗口比例图计算在车牌上的可能性
possibility = posibility(porpotion ,a, b, c);

%imshow(possibility);;

end

