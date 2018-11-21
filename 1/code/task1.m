%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Histogram Equalization
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%����ͼ��
img_river = imread('../src/river', 'JPG');
info = imfinfo('../src/river','JPG');

%����Ҷ�ֵ�����ʣ�ֱ��ͼ
hist_river = imhist(img_river);
fig1 = bar(hist_river);
saveas(fig1, '../figure/1/hist_origin.png');
%hold on;
hist_river = hist_river/(info.Width*info.Height);

%��������ۼƺ���
cdf = getCDF(hist_river);
%plot(cdf);
%hold on;

%�任
L = 256;
for i = 1:info.Width
    for j = 1:info.Height
        img_river(j, i) = L * cdf(img_river(j, i)+1);
    end
end

imwrite(img_river, '../figure/1/processed_river.jpg', 'jpg');

hist = imhist(img_river);
fig_result = bar(hist);
saveas(fig_result, '../figure/1/hist_result.png');

%���ÿ⺯������
sys = histeq(img_river);
imwrite(sys, '../figure/1/sys.jpg', 'jpg');
test_hist = imhist(sys);
fig_test = plot(test_hist);
saveas(fig_test, '../figure/1/hist_test.png');
