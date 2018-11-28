function p = predictMain(Theta1, Theta2, X, arrayLength)
%����һ��Ԫ������X����������Ԥ��ֵ

p = '';

for i = 1:arrayLength
    pic = X{i};
    %���ݱ�Ϊһ��
    pic = reshape(pic, 1, 1024);

    %����һ������
    res = predict(Theta1, Theta2, pic);

    %����labelֵ����ԭֵ
    if res == 10
        p = [p, '0'];
    elseif res >= 1 && res <= 9
        p = [p, num2str(res)];
    elseif res >= 11 && res <= 18
        p = [p, char(int8(res) + 54)];
    elseif res >= 19 && res <= 23
        p = [p, char(int8(res) + 54 + 1)];
    elseif res >=24 && res <=34
         p = [p, char(int8(res) + 54 + 2)];
    elseif res == 35
        p = [p, '��'];
    else
        fpritnf('\nԤ������ֵ�Ƿ�\n');
        pause;
    end
    
    for j = 1:arrayLength
        subplot(1,7,j),imshow(X{j});
    end    
end
fprintf('\n���ƺ�Ϊ��%s,�밴�س�������\n', p);
pause;
