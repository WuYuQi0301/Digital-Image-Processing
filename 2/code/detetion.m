%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 相关检测 
% 2018/11/20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = imread('../src/car.png');
mask = imread('../src/wheel.png');
[h1, w1] = size(img);
[h2, w2] = size(mask);
half = floor([h2/2, w2/2]);   %half of height and width of mask;

g = zeros(h1, w1);            

for i = 1+half(1):h1-half(1)
    for j = 1+half(2):w1-half(2)
        temp = img(i-half(1):i+half(1), j-11:j+11);
        sum2 = sum(sum(temp.*temp));
        for k = 1:h2
            for t = 1:w2
                temp(k,t) = temp(k,t)*mask(k,t);
            end
        end
        sum1 = sum(sum(temp));
        g(i,j) = sum1/sum2;
    end
end

g = mat2gray(g);
imwrite(g, '../result/g.bmp','bmp');

val = max(g(:));
[y0,x0] = find(g>=val-0.014);  %threshold
pos = [y0, x0];

result = (pos(1,:));
for i = 2:size(pos)
    tmp = pos(i,:);
    flag = 1;
    for j = 1:size(result) 
        p = result(j,:);
        if norm(p-tmp) < half(2)  %欧氏距离判断局部,
            flag = 0;
            if g(p(1,1),p(1,2)) < g(tmp(1,1), tmp(1,2)) %相关值大的替换
                result(j,:) = tmp;
            end
            break;
        end
    end
    if flag == 1               %新局部点加入数组
        result = [result;tmp];
    end
end
disp(result);
size(result)

% draw detection rectangle
for i = 1:size(result)
    tmp = result(i,:);
    img(tmp(1)-half(1):tmp(1)+half(1), tmp(2)-half(2)) = 255;
    img(tmp(1)-half(1):tmp(1)+half(1), tmp(2)+half(2)) = 255;
    img(tmp(1)+half(1), tmp(2)-half(2):tmp(2)+half(2)) = 255;
    img(tmp(1)-half(1), tmp(2)-half(2):tmp(2)+half(2)) = 255;
end

imshow(img);
hold on;

% draw point
alpha = 0:pi/20:2*pi; %角度[0,2*pi]
R = 0.01;                %半径
x = result(:,2)+R*cos(alpha);
y = result(:,1)+R*sin(alpha);
plot(x,y,'o')
axis equal


