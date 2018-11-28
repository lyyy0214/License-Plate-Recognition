function grey = hsi2grey(meanH, meanSb, meanSw, meanI, ...
                        thetaH, thetaSb, thetaSw, thetaI, hsi)
%根据hsi中的数值，将原图像转化为灰度图

%定义三种不同的灰度值
tb = 0;
tw = 0.7;
t0 = 1;

H = hsi(:, :, 1);
S = hsi(:, :, 2);
I = hsi(:, :, 3);
row = size(H, 1);
line = size(H, 2);

grey = zeros(row, line);
for i=1:row
    for j=1:line
        if H(i,j)>0.6 && H(i,j)<0.72 && S(i,j)>0.45
            grey(i,j) = tb;
        elseif I(i,j)>0.75 && S(i,j)<0.3
            grey(i,j) = tw;
        %if H(i,j)>(meanH - thetaH) && H(i,j)<(meanH + thetaH) && ...
        %       S(i,j)>(meanSb - thetaSb) && S(i,j)<(meanSb + thetaSb)
        %   grey(i, j) = tb;
        %elseif S(i,j)>(meanSw - thetaSw) && S(i,j)<(meanSw + thetaSw) && ...
        %        I(i,j)>(meanI - thetaI) && I(i,j)>(meanI + thetaI)
        %    grey(i ,j) = tw;
        else
            grey(i,j) = t0;
        end
    end
end




