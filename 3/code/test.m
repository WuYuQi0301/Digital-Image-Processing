
img = rgb2gray(imread('../src/office.jpg'));
[M, N] = size(img);
g = zeros(M, N);
h = 2;
l = 0.25;
C = 1;
for i = 1:10
    D0 = i*100;
    g = Homo_filter(img, D0, h, l, C);
    path = ['../result/homo', int2str(D0), '.jpg'];
    imwrite(g, path, 'jpg')
end

bwh = Butterworth_high_pass_filter(img, 0.001);

imwrite(bwh, '../result/BwH.jpg', 'jpg');
imshow(bwh);