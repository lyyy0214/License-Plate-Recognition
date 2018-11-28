function p = predictMain(Theta1, Theta2, X, arrayLength)
%接收一个元胞数组X，返回它的预测值

p = '';

for i = 1:arrayLength
    pic = X{i};
    %数据变为一行
    pic = reshape(pic, 1, 1024);

    %返回一个整数
    res = predict(Theta1, Theta2, pic);

    %根据label值返回原值
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
        p = [p, '京'];
    else
        fpritnf('\n预测数据值非法\n');
        pause;
    end
    
    for j = 1:arrayLength
        subplot(1,7,j),imshow(X{j});
    end    
end
fprintf('\n车牌号为：%s,请按回车键继续\n', p);
pause;
