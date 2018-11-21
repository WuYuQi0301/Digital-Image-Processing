function [result] = medianFilt(input, h, w)
%MEDIANFILT 
% input img ,width and height
% return the img after median filtering

result = zeros(h+2, w+2);
ext = zeros(h+2, w+2);   % 0 extern
ext(2:1+h, 2:1+w) = input;
 for i = 2:1+h
     for j = 2:1+w
        mask = ext(i-1:i+1, j-1:j+1);
        result(i, j) = median(mask(:));
     end
 end
result = mat2gray(result(2:1+h, 2:1+w));
end

