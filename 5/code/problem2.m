close all;

img = imread('../blobz1.png');
img2 = imread('../blobz2.png');
%% kmean
kmean1 = Kmean2(img);
kmean2 = Kmean2(img2);
subplot(1,2,1), imshow(kmean1);
subplot(1,2,2), imshow(kmean2);



