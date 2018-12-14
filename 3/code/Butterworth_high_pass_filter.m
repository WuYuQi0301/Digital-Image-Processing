function[g] = Butterworth_high_pass_filter(img, D0)
[M, N] = size(img);
f = zeros(2*M, 2*N);
%1.���ı任
for i = 1:M
    for j = 1:N
       f(i,j) = double(img(i,j))*(-1)^(i+j);
    end
end
%2. DFT
F = fft2(f);

D0_2 = D0^2;
%3. filt
G = zeros(2*M, 2*N);
for u = 1:2*M
    for v = 1:2*N
       %����u,v���H
       H = 1 / (1 + D0_2/((u-(M+1))^2 + (v-(N+1))^2));
       G(u,v) = F(u,v) * H;
    end
end

%4. inv-DFT  %5. �õ�4�����ʵ��
G = real(ifft2(G));

%6. ��(-1)^{x+y}����5�Ľ�������з����Ļ�����
g = zeros(M, N);
for i = 1:M
    for j = 1:N
       g(i,j) = G(i,j)*((-1)^(i+j));
    end
end
g = uint8(g);