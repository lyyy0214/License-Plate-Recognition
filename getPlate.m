function plate = getPlate( im_ori )

%������ȡ��������ԭͼ���ҳ�����λ��

im_direct = direct(im_ori);
im_col_edg= color_edge( im_ori );
[im_area,H,S]=area(im_ori);
Size = size(im_area);
im_direct = imresize(im_direct,Size);
plate=step1_combine(im_col_edg,im_area,im_direct,im_ori,H,S);

figure('NumberTitle','off','Name','����λ�ü��');
subplot(1,3,1);
imshow(im_col_edg);
title('��ɫ�Ա�Ե���');
subplot(1,3,2);
imshow(im_area);
title('��ɫ������ͼ');
subplot(1,3,3);
imshow(im_direct);
title('�Ҷ�ͼ�ı�Ե���');
fprintf('\n�����ӵĳ���λ�ü��ͼ���밴�س�������\n');
pause;



% subplot(3,1,1);
% imshow(im_ori);
% subplot(3,1,2);
% imshow(im_col_edg);
% subplot(3,1,3);
% imshow(plate);

end

