function result = calPsnr(I,I2)
    [h, w] = size(I);
    B = 8;% 编码一个像素用8个二进制位
    MAX = 2^B-1;% 图像有多少灰度级
    MES = sum(sum((I-I2).^2))/(h*w);% 均方差
    result = abs(20*log10(MAX/sqrt(MES)));% 峰值信噪比
end