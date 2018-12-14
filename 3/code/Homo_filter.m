function[g] = Homo_filter(img, D0, h, l, C)

[M, N] = size(img);
f = zeros(2*M, 2*N);

%1.中心变换+ log
for i = 1:M
    for j = 1:N
       f(i,j) = log(double(img(i,j)) + 1)*(-1)^(i+j);
    end
end

%2. DFT
F = fft2(f);

%parameters
D0_2 = D0^2;
r = h - l;
%3. homo filt func
G = zeros(2*M, 2*N);
for u = 1:2*M
    for v = 1:2*N
        k = ((u-(M+1))^2 + (v-(N+1))^2) / D0_2;
        H = r * (1 - exp((-C) * k))+ l;
        G(u,v) = F(u,v) * H;
    end
end

%5. 得到4结果的实部
G = real(ifft2(G));
g = zeros(M, N);
%反中心化处理
for i = 1:M
    for j = 1:N
       g(i,j) = exp(G(i,j)*(-1)^(i+j)) - 1;
    end
end

%归一化
max_data = max(g(:));
min_data = min(g(:));
range = max_data - min_data;
for i = 1 : M
    for j = 1 : N
        g(i,j) = uint8(255 * (g(i, j)-min_data) / range);
    end
end

g = uint8(g);

