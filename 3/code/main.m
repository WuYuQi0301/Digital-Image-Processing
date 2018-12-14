close all;

img = imread('../src/barb.png');
%subplot(1,2,1)
%imshow(img);
D0 = 10;
D1 = 20;
D2 = 40;
D3 = 80;

g0 = Butterworth_low_pass_filter(img, D0);
g1 = Butterworth_low_pass_filter(img, D1);
g2 = Butterworth_low_pass_filter(img, D2);
g3 =  Butterworth_low_pass_filter(img, D3);

%subplot(1,2,2)
%imshow(g);

imwrite(g0, '../result/10.png', 'png');
imwrite(g1, '../result/20.png', 'png');
imwrite(g2, '../result/40.png', 'png');
imwrite(g3, '../result/80.png', 'png');

