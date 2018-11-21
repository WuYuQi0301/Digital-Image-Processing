<center><font size = 6>数字图像处理Project2</font></center>

<center>姓名：吴宇祺  学号：16340242</center>

## 实验环境及文件结构

实验环境：Matlab R2018a

文件结构

>  root
>
>  - code
>    - detection.m        相关检测主函数
>    - main.m                中值滤波主函数
>    - medianFilt.m      中值滤波函数
>  - src                                源图片文件
>  - result                           结果图片文件
>  - *.pdf



## 算法描述

### 相关检测

相关检测的原理是利用模板与图像做相关运算得到相关值矩阵，相关值最大的位置即检测出的目标位置。

1. 相关矩阵g坐标$(i,j)$的相关值计算公式如下，其中$h',w'$分别为模板的半高和半宽。

$$
g(i,j) = \frac{\sum^k_{h'=-k}\sum^l_{w'=-l}f(i+h',j+w')m(h',w')}{\sum^k_{h'=-k}\sum^l_{w'=-l}f^2(i+h',j+w')}
$$
```matlab
for i = 1+half(1):h1-half(1)
    for j = 1+half(2):w1-half(2)
        temp = img(i-half(1):i+half(1), j-11:j+11);  %截取img的mask所在范围temp
        sum2 = sum(sum(temp.*temp));                 %求分母：temp矩阵点积的累计和
        for k = 1:h2
            for t = 1:w2
                temp(k,t) = temp(k,t)*mask(k,t);     %求分子：temp和mask矩阵对应位置积的累积和
            end
        end
        sum1 = sum(sum(temp));
        g(i,j) = sum1/sum2;
    end
end
```



1. 找相关值矩阵的最大值val，设定阈值筛选可能结果值的坐标集合。

   ```matlab
   val = max(g(:));
   [y0,x0] = find(g>=val-0.014);
   pos = [y0,x0];
   ```

2. 进行局部最大值查找

   ```matlab
   result = (pos(1,:));             % 将步骤2的pos中第一个点加入result集
   for i = 2:size(pos)              % 遍历pos中余下的点
       tmp = pos(i,:);
       flag = 1;
       for j = 1:size(result)       % 在result中查找是否有当前pos点的临近点（在同一个局部区域）
           p = result(j,:);
           if norm(p-tmp) < half(2) % 欧氏距离,
               flag = 0;
               if g(p(1,1),p(1,2)) < g(tmp(1,1), tmp(1,2)) % 若相关值较大，替换
                   result(j,:) = tmp;
               end
               break;
           end
       end
       if flag == 1               % 没有已经发现的局部点，将新局部点加入result
           result = [result;tmp];
       end
   end
   ```


### 中值滤波

中值滤波的原理是取待定像素周围窗口大小内的邻像素值，取其中值作为待定像素的值。中值滤波器对于椒盐噪声（极大极小值）有很好的过滤效果。

1. 对当前图像进行上下、左右分别为1的0扩展

   ```matlab
   ext = zeros(h+2, w+2);   % 0 extern
   ext(2:1+h, 2:1+w) = input;
   ```

2. 遍历图像像素，取当前像素的八邻域像素值，取9个数的中值作为当前像素的处理值。（即窗口大小为3*3）

   ```matlab
    for i = 2:1+h
        for j = 2:1+w
           mask = ext(i-1:i+1, j-1:j+1);
           result(i, j) = median(mask(:));
        end
    end
   ```

3. 截取原图像区域，并将矩阵转换回图像

   ```matlab
   result = mat2gray(result(2:1+h, 2:1+w));
   ```


## 测试文档

### 相关检测

| 相关值结果                 | ![g](C:\Users\Yuki\Desktop\DIP\result\g.bmp)                 |
| -------------------------- | ------------------------------------------------------------ |
| 设置阈值后                 | ![detection](C:\Users\Yuki\Desktop\DIP\result\detection.jpg) |
| 目标x，y坐标（局部最大值） | ![pos](C:\Users\Yuki\Desktop\DIP\result\pos.JPG)             |
| 局部最大值查找后           | ![detect result](C:\Users\Yuki\Desktop\DIP\result\detect result.jpg) |

 

### 中值滤波

**使用题目中的函数生成噪声图像：**
| **原始图像**                                               | **椒盐噪声图像：input.jpg**                               |
| ---------------------------------------------------------- | --------------------------------------------------------- |
| **![origin](C:\Users\Yuki\Desktop\DIP\result\origin.jpg)** | **![origin](C:\Users\Yuki\Desktop\DIP\result\input.jpg)** |
| medFilt：output.jpg****                                    | **medfilt2：demo.jpg**                                    |
| ![output](C:\Users\Yuki\Desktop\DIP\result\output.jpg)     | ![origin](C:\Users\Yuki\Desktop\DIP\result\demo.jpg)      |



**使用imnoise生成0.2椒盐噪声图像：**

![origin](C:\Users\Yuki\Desktop\DIP\result\noise.jpg)

| medFilt：output2.jpg                                     | madfilt2：demo2.jpg                                    |
| -------------------------------------------------------- | ------------------------------------------------------ |
| ![output2](C:\Users\Yuki\Desktop\DIP\result\output2.jpg) | ![origin](C:\Users\Yuki\Desktop\DIP\result\origin.jpg) |

