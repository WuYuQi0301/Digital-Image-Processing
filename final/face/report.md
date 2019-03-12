

<center><font size = 6>数字图像处理 Final Project</font></center>

### 算法描述

#### 1. 训练

0. 读入ORL人脸数据集，对于每一人脸的10幅图像，选取前7副作为训练图像，将每一幅图像排成列向量的形式，并求平均脸，得到database；后三幅图像作为测试集，存入test_imgs：

    ```matlab
    for i = 1:40
        faces = zeros(7,w*h);
        
        for j = 1:7   % 训练集
            img = imread(strcat('./orl_faces/s',int2str(i),'/',int2str(j),'.pgm'));
            faces(j,:) = img(:)'; %列向量
        end
        for j = 1:w*h
            data(j, 1) = mean(faces(:,j));  % mean 7 traning faces
        end
        database(:, i) = data;
        
        for j = 1:3    % 测试集
           img = imread(strcat('./orl_faces/s',int2str(i),'/',int2str(j+7),'.pgm'));
           test_imgs(:, 3*(i-1)+j) = img(:)';
        end
    end
    ```

1. 计算所有训练图像的平均脸

   ```matlab
   all_face_mean = zeros(w*h, 1);
   for i = 1:w*h
       all_face_mean(i, 1) = mean(database(i, :));  % mean of all traning faces
   end
   ```

2. 中心化训练图像

   ```matlab
   % 中心化 
   shift_database = zeros(w*h, 40);
   for i = 1:40
       shift_database(:, i) = database(:, i) - all_face_mean;
   end
   ```

3. 使用PCA函数计算协方差矩阵的特征值和特征向量

   ```matlab
   
   % 计算协方差矩阵
   %主成分(coeff)、协方差矩阵X的特征值 (latent)和每个特征向量表征在观测量总方差中所占的百分数
   [coeff,score,latent] = pca(database');
   [~, num] = size(coeff);
   ```
#### 2. 测试

外层循环：使k从1到num变化，探究识别正确率与k大小的关系；

内层循环：40张人脸共120张测试图像在当前k下的测试结果；

1. 预处理测试图像

   ```matlab
   current_test = double(test_imgs(:, 3*(i-1)+j));
   feature_vec = evectors' * (current_test - all_face_mean);
   ```

2. 二范数最小匹配得到匹配图像

   ```matlab
    similarity = arrayfun(@(n) 1 / (1 + norm(features(:,n) - feature_vec)), 1:num);
    [~, match_ix] = max(similarity);
   ```

3. 若匹配图像正确，则正确数加一（）

   ```matlab
   if match_ix == i
       success = success + 1;
   end
   ```

### 测试结果

result数组第一行为

| k      | 1      | 2    | 3      | 4      | 5      | 6      | 7      | 8      | 9      | 10     |
| ------ | ------ | ---- | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 正确数 | 19     | 42   | 56     | 70     | 77     | 82     | 90     | 91     | 93     | 97     |
| 正确率 | 0.1583 | 0.35 | 0.4667 | 0.5833 | 0.6417 | 0.6833 | 0.7500 | 0.7583 | 0.7750 | 0.8083 |

| k      | 11     | 12     | 13     | 14     | 15     | 16     | 17     | 18     | 19     | 20     |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 正确数 | 102    | 100    | 101    | 102    | 103    | 104    | 105    | 106    | 106    | 107    |
| 正确率 | 0.8500 | 0.8333 | 0.8417 | 0.8500 | 0.8583 | 0.8667 | 0.8750 | 0.8750 | 0.8833 | 0.8917 |

| k      | 21     | 22     | 23     | 24     | 25     | 26     | 27     | 28     | 29     | 30     |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 正确数 | 107    | 107    | 107    | 107    | 107    | 107    | 107    | 107    | 107    | 107    |
| 正确率 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 |

| k      | 31     | 32     | 33     | 34     | 35     | 36     | 37     | 38     | 39     |      |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ---- |
| 正确数 | 107    | 107    | 107    | 107    | 107    | 107    | 107    | 107    | 107    |      |
| 正确率 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 | 0.8917 |      |

![test result](C:\Users\Yuki\Desktop\face\test result.jpg)