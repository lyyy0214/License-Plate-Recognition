function plate = getPlate( im_ori )

%车牌提取函数：从原图上找出车牌位置

im_direct = direct(im_ori);
im_col_edg= color_edge( im_ori );
[im_area,H,S]=area(im_ori);
Size = size(im_area);
im_direct = imresize(im_direct,Size);
plate=step1_combine(im_col_edg,im_area,im_direct,im_ori,H,S);

figure('NumberTitle','off','Name','车牌位置检测');
subplot(1,3,1);
imshow(im_col_edg);
title('颜色对边缘检测');
subplot(1,3,2);
imshow(im_area);
title('颜色区域检测图');
subplot(1,3,3);
imshow(im_direct);
title('灰度图的边缘检测');
fprintf('\n待叠加的车牌位置检测图，请按回车键继续\n');
pause;



% subplot(3,1,1);
% imshow(im_ori);
% subplot(3,1,2);
% imshow(im_col_edg);
% subplot(3,1,3);
% imshow(plate);

end

