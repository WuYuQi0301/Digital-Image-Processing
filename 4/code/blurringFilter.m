function[g] = blurringFilter(img, a, b, T)
[M, N] = size(img);
f = im2double(img);
%零扩展
%f = zeros(2*M, 2*N);
%中心变换
%for i = 1:M
%    for j = 1:N
%       f(i,j) = double(img(i,j))*(-1)^(i+j);
%    end
%end

% fft
F = fftshift(fft2(f));
F(1:8, 1:8)
% filter
G = zeros(M, N);
coff = T / pi;
j = complex(0,1);
for u = 1:M
    for v = 1:N
        tmp = (u-(M+1)) .* a + (v-(N+1)) .* b;
        if tmp ~= 0
            H = (coff/tmp) * sin(pi*tmp) * exp(-j*pi*tmp);
        else
            H = 0;
        end
        if u == 1 && v == 1
            disp(H)
        end
        G(u, v) = F(u, v) * H;
    end
end
G(1:8, 1:8)
%反中心变换
G = real(ifft2(ifftshift(G)));
G(1:8, 1:8)
%6. 用(-1)^{x+y}乘上5的结果。进行反中心化处理
%g = zeros(M ,N);
%for i = 1:M
%    for j = 1:N
%       g(i,j) = G(i,j)*((-1)^(i+j));
%    end
%end
%g = uint8(g);
%g(1:8, 1:8)
g = uint8(255.*mat2gray(G));