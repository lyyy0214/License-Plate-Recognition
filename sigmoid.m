function g = sigmoid(z)
%sigmoid����

g = 1.0 ./ (1.0 + exp(-z));
end