function [cdf] = getCDF(hist)
cdf = zeros(1, 256);
cdf(1) = hist(1);
for i = 2:256
      cdf(i) = cdf(i-1) + hist(i);
end