function[result] = Kmean2(img)
data = uint8(img);
[M,N] = size(img);

Rnk = zeros(M,N);
u1 = 0;
u2 = 125;
last_u1 = 1;
last_u2 = 126;

eps = 0.01;
maxLoop = 10;
loop = 0;

while loop <= maxLoop && (abs(u1 - last_u1) > eps || abs(u2 - last_u2) > eps)
    last_u1 = u1;
    last_u2 = u2;
    sum1 = 0;
    sum2 = 0;
    Rnk = zeros(M,N);
    
    for i = 1:M
        for j = 1:N
            if abs(u1 - data(i,j)) < abs(u2 - data(i,j)) 
                sum1 = sum1+data(i,j);
                Rnk(i,j)=1;
            else
                sum2 = sum2+data(i,j);
                Rnk(i,j)=0;
            end
        end
    end
    count = sum(sum(Rnk));
    u1 = sum1/count;
    u2 = sum2/(M*N-count);

    loop = loop +1;
end

result = 255*Rnk;
