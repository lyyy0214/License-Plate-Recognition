% 车牌识别程序

%数据参数
picName = './data/sample3.jpg';             %图片名
theta1Name = './data/Theta1Reg1_1024.mat';      %theta1矩阵名
theta2Name = './data/Theta2Reg1_1024.mat';      %theta2矩阵名
arrayLength = 7;                    %元胞数组长度

%读画原图片
pic = imread(picName);
figure, title('原始图片'), imshow(pic);  %TODO
fprintf('\n展示原始图片，请按回车键继续\n');
pause;

%加载机器学习的参数
load(theta1Name, 'Theta1');
load(theta2Name, 'Theta2');

%提取车牌
plate = getPlate(pic);
figure,imshow(plate);
pause;
%切割字符并返回存储了七张图片的元胞数组
picArray = cutChar(plate);

%test
figure;
for i = 1:arrayLength
    subplot(1, arrayLength, i), imshow(picArray{i});
end
%subplot(2, arrayLength, arrayLength + 1), imshow(plate);
fprintf('\n切割字符后的结果,请按回车键继续\n')
pause;

%根据元胞数组进行预测输出
pred = predictMain(Theta1, Theta2, picArray, arrayLength);

figure, imshow(picName), title('原图片');
fprintf('\n再次展示原图片，请按回车键继续\n')

pause;
