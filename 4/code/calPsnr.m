function result = calPsnr(I,I2)
    [h, w] = size(I);
    B = 8;% ����һ��������8��������λ
    MAX = 2^B-1;% ͼ���ж��ٻҶȼ�
    MES = sum(sum((I-I2).^2))/(h*w);% ������
    result = abs(20*log10(MAX/sqrt(MES)));% ��ֵ�����
end