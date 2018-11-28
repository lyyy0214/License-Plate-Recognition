% ����ʶ�����

%���ݲ���
picName = './data/sample3.jpg';             %ͼƬ��
theta1Name = './data/Theta1Reg1_1024.mat';      %theta1������
theta2Name = './data/Theta2Reg1_1024.mat';      %theta2������
arrayLength = 7;                    %Ԫ�����鳤��

%����ԭͼƬ
pic = imread(picName);
figure, title('ԭʼͼƬ'), imshow(pic);  %TODO
fprintf('\nչʾԭʼͼƬ���밴�س�������\n');
pause;

%���ػ���ѧϰ�Ĳ���
load(theta1Name, 'Theta1');
load(theta2Name, 'Theta2');

%��ȡ����
plate = getPlate(pic);
figure,imshow(plate);
pause;
%�и��ַ������ش洢������ͼƬ��Ԫ������
picArray = cutChar(plate);

%test
figure;
for i = 1:arrayLength
    subplot(1, arrayLength, i), imshow(picArray{i});
end
%subplot(2, arrayLength, arrayLength + 1), imshow(plate);
fprintf('\n�и��ַ���Ľ��,�밴�س�������\n')
pause;

%����Ԫ���������Ԥ�����
pred = predictMain(Theta1, Theta2, picArray, arrayLength);

figure, imshow(picName), title('ԭͼƬ');
fprintf('\n�ٴ�չʾԭͼƬ���밴�س�������\n')

pause;
