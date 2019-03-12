close all;
w = 92;
h = 112;


%% Training : Set up database
database = zeros(w*h, 40);
test_imgs = zeros(w*h, 120);
data = zeros(w*h,1);
% read in traning figure and compute the mean of every 7 figure 
for i = 1:40
    faces = zeros(7,w*h);
    
    for j = 1:7
        img = imread(strcat('./orl_faces/s',int2str(i),'/',int2str(j),'.pgm'));
        faces(j,:) = img(:)'; %112*98
    end
    for j = 1:w*h
        data(j, 1) = mean(faces(:,j));  % mean 7 traning faces
    end
    database(:, i) = data;
    
    for j = 1:3
       img = imread(strcat('./orl_faces/s',int2str(i),'/',int2str(j+7),'.pgm'));
       test_imgs(:, 3*(i-1)+j) = img(:)';
    end
end

all_face_mean = zeros(w*h, 1);
for i = 1:w*h
    all_face_mean(i, 1) = mean(database(i, :));  % mean of all traning faces
end

% 中心化 
shift_database = zeros(w*h, 40);
for i = 1:40
    shift_database(:, i) = database(:, i) - all_face_mean;
end

% 计算协方差矩阵
%主成分(coeff)、协方差矩阵X的特征值 (latent)和每个特征向量表征在观测量总方差中所占的百分数
[coeff,score,latent] = pca(database');
[~, num] = size(coeff);

%% Testing

result = zeros(num, 2);

for k = 1:num
    evectors = coeff(:, 1:k);
    features = evectors' * shift_database;
    success = 0;
    for i = 1:40
        for j = 1:3
            current_test = double(test_imgs(:, 3*(i-1)+j));
            feature_vec = evectors' * (current_test - all_face_mean);
            
            similarity = arrayfun(@(n) 1 / (1 + norm(features(:,n) - feature_vec)), 1:num);
            [~, match_ix] = max(similarity);

            if match_ix == i
                success = success + 1;
            end
        end
    end
    result(k, 1) = success;
    result(k, 2) = success / 120;
end

figure, plot(result(:, 2));
xlabel('k'), ylabel('correct rate');
xlim([1 num]), ylim([0 1]), grid on;

result = result';

