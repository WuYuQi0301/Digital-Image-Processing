img1 = imread('../src/EightAM','png');
img2 = imread('../src/LENA','png');
img3 = imread('../src/EightAM','png');

info1 = imfinfo('../src/EightAM','png');
info2 = imfinfo('../src/LENA','png');

%����ƥ��ǰ��ֱ��ͼ(����)
hist1 = imhist(img1)/(info1.Width*info1.Height);
hist2 = imhist(img2)/(info2.Width*info2.Height);

%����ƥ��ǰ��cdf
cdf1 = getCDF(hist1);
cdf2 = getCDF(hist2);

%�����ֵ
%��i�У�����ÿ��cdf1(s),����ÿ��cdf2��ɢֵ�Ĳ�
diff = zeros(256, 256);
for i = 1:256
    for j = 1:256
        diff(j, i) = abs(cdf1(i) - cdf2(j));
    end
end

%����ӳ���: ����Ҷȼ�1�������С��ֵ�ģ�ӳ�䣩�Ҷȼ�2
map = zeros(1,256);
for i = 1:256
    min = diff(1, i); 
    index = 1;
    for j = 1:256     %�ҳ���i����С�Ĳ�ֵ(�ۼƸ���)
        if min > diff(j, i)
            min = diff(j, i);
            index = j;
        end
    end
    map(i) = index;
end

%�任
for i = 1:info1.Width
    for j = 1:info1.Height
        img3(j, i) = map(img1(j, i) + 1);
    end
end

imwrite(img3,'../figure/2/processed_EightAM.png','png');
hist_result = imhist(img3)/(info1.Width*info1.Height);

figure(1);
fig1 = bar(hist1);
saveas(fig1, '../figure/2/hist_enghtAM.png');

fig2 = bar(hist2);
saveas(fig2, '../figure/2/hist_lena.png');

fig3 = bar(hist_result);
saveas(fig3, '../figure/2/hist_result.png');

figure(2);
subplot(1,2,1),imshow(img1);
subplot(1,2,2),imshow(img3);

figure(3)
subplot(1,3,1), bar(hist1);
subplot(1,3,2), bar(hist2);
subplot(1,3,3), bar(hist_result);