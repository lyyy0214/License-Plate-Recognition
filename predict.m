function p = predict(Theta1, Theta2, X)
%����Theta1��Theta2����Ԥ�⣬X��һ������ÿһ����һ������
m = size(X, 1);                 %x����
p = zeros(size(X, 1), 1);       %Ԥ����

%==

X = X > 100;
X = X * 225;

%X = reshape(X , 50, 50);
%figure, imshow(X);

%X = reshape(X, 1,2500);

X = [ones(m,1) X];



hide_X = Theta1 * X';
hide_a = sigmoid(hide_X);       %��������

output_x_in = [ones(1,size(hide_a,2));hide_a];      %
output_x = Theta2 * output_x_in;
output_result = sigmoid(output_x);

for i = 1:size(output_result, 2)
  [val,ind] = max(output_result(:,i));
  p(i,1) = ind;
end