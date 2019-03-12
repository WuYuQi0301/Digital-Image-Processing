close all;

img = imread('../book_cover.jpg');
subplot(2, 3, 1), imshow(img), title('原始图像');
[M,N] = size(img);

I = im2double(img);% [0,1]
j = complex(0, -1);
%% 计算运动模糊矩阵H
T=1;a=0.1;b=0.1;
v=[-M/2:M/2-1];
u=v';
A=repmat(a.*u,1,M)+repmat(b.*v,M,1);
H=T/pi./A.*sin(pi.*A).*exp(j*pi.*A);
H(A==0)=T;% replace NAN

F=fftshift(fft2(I));
FBlurred=F.*H;

IBlurred =real(ifft2(ifftshift(FBlurred)));
subplot(2, 3, 2), imshow(uint8(255.*mat2gray(IBlurred)))
title("运动模糊");
imwrite(IBlurred, '../outputs/blurred.jpg', 'jpg');

%% 加入高斯噪声
INoise  = imnoise(zeros(M,N), 'gaussian', 0, 500);
FNoise = ifftshift(ifft2(INoise));
FGaussian = FBlurred + FNoise;
IGaussian = real(ifft2(ifftshift(FGaussian)));

subplot(2, 3, 3), imshow(IGaussian), title('高斯噪声');
imwrite(IGaussian, '../outputs/blurred_noise.jpg', 'jpg');

%% 直接逆滤波
BlurredInv = FBlurred ./ H;
BlurredInvRestoration1 = real(ifft2(ifftshift(BlurredInv)));
subplot(2, 3, 4), imshow(BlurredInvRestoration1),title('模糊图像逆滤波');
imwrite(BlurredInvRestoration1, '../outputs/inv_blurred.jpg', 'jpg');

FGaussianInvRestoration = FGaussian ./ H;
IGaussianInvRestoration = real(ifft2(ifftshift(FGaussianInvRestoration)));
subplot(2, 3, 5), imshow(IGaussianInvRestoration), title('模糊-噪声图像逆滤波');
imwrite(IGaussianInvRestoration, '../outputs/inv_blurred_noise.jpg', 'jpg');

%% 寻找最佳半径
maxPsnr = 0;
bestR = 0;
for r = 20:1:35
    FGaussianInvR = zeros(M, N);
    for a = 1:M
        for b = 1:N
            if sqrt((a-M/2)^2 + (b-N/2)^2) < r
                FGaussianInvR(a, b) = FGaussian(a, b)./H(a, b);
            end
        end
    end
    %figure, imshow(real(ifft2(ifftshift(FGaussianInvR))));
    % 计算峰值信噪比
    IGaussianInvR = real(ifft2(ifftshift(FGaussianInvR)));
    psnr = calPsnr(IGaussianInvR, I);

    if psnr > maxPsnr
        maxPsnr = psnr;
        bestR = r;
    end
end
maxPsnr
bestR 
FGaussianInvR = zeros(M, N);
for a = 1:M
    for b = 1:N
        if sqrt((a-M/2)^2 + (b-N/2)^2) < bestR
            FGaussianInvR(a, b) = FGaussian(a, b)./H(a, b);
        end
    end
end
%figure, imshow(FGaussianInvR);
IGaussianInvR = real(ifft2(ifftshift(FGaussianInvR)));
subplot(2, 3, 6), imshow(uint8(255.*mat2gray(IGaussianInvR))), title('模糊-噪声图像半径抑制逆滤波');
imwrite(IGaussianInvR, ['../outputs/inv_blurred_noise', int2str(bestR), '.jpg'], 'jpg');

%% 维纳滤波
Hsq = (abs(H)).^2;
for K = 0:0.01:0.4
    FGaussianWiennerRestoration = Hsq ./ (Hsq + K) .* FGaussian ./H;
    IGaussianWiennerRestoration = real(ifft2(ifftshift(FGaussianWiennerRestoration)));
    imwrite(IGaussianWiennerRestoration, ['../outputs/wienner_', num2str(K) ,'.jpg'], 'jpg');
end

figure, imshow(IGaussianWiennerRestoration), title("Wienner");

