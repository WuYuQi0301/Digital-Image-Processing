%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% median filter
% 2018/11/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

info = imfinfo('../src/sport car.pgm');
w = info.Width;
h = info.Height;
%display(pgm_info);
img = imread('../src/sport car.pgm');
%imshow(pgm);
imwrite(img, '../result/origin.jpg', 'jpg');
t1 = 255*rand(h, w);
t2 = 255*rand(h, w);
input = zeros(h, w); 
for i = 1:h              %noise
    for j = 1:w
        if img(i, j) > t1(i, j)
            input(i, j) = 255;
        elseif img(i, j) < t2(i, j)
                input(i, j) = 0;
        else
            input(i, j) = img(i, j);
        end
    end
end
%imshow(input);
imwrite(input, '../result/input.jpg', 'jpg');

output = medianFilt(input, h, w);
%imshow(output);
imwrite(output, '../result/output.jpg','jpg');

demo = medfilt2(input,[3,3]);
%imshow(demo);
imwrite(demo, '../result/demo.jpg', 'jpg');

input2 = imnoise(img,'salt & pepper',0.02);
imwrite(input2, '../result/noise.jpg', 'jpg');

output2 = medianFilt(input2, h, w);
imwrite(output2, '../result/output2.jpg', 'jpg');

demo2 = medfilt2(input2,[3,3]);
%imshow(demo2);
imwrite(demo2, '../result/demo2.jpg', 'jpg');

