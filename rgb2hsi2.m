function hsi = rgb2hsi2(rgb)

rgb = im2double(rgb);

r = rgb(:, :, 1);   
g = rgb(:, :, 2);   
b = rgb(:, :, 3);  
hsv = rgb2hsv(rgb);
H=hsv(:, :, 1); 
S=hsv(:, :, 2); 
I=(r+g+b)/3;

hsi = cat(3, H, S, I);