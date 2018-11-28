function p = predict(Theta1, Theta2, X)
%根据Theta1和Theta2进行预测，X是一个矩阵，每一行是一个样本
m = size(X, 1);                 %x行数
p = zeros(size(X, 1), 1);       %预测结果

%==

X = X > 100;
X = X * 225;

%X = reshape(X , 50, 50);
%figure, imshow(X);

%X = reshape(X, 1,2500);

X = [ones(m,1) X];



hide_X = Theta1 * X';
hide_a = sigmoid(hide_X);       %隐层输入

output_x_in = [ones(1,size(hide_a,2));hide_a];      %
output_x = Theta2 * output_x_in;
output_result = sigmoid(output_x);

for i = 1:size(output_result, 2)
  [val,ind] = max(output_result(:,i));
  p(i,1) = ind;
end