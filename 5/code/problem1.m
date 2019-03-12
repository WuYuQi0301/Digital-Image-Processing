A = [0,0,0,0,0,0,0;
     0,0,1,1,0,0,0;
     0,0,0,1,0,0,0;
     0,0,0,1,1,0,0;
     0,0,1,1,1,1,0;
     0,0,1,1,1,0,0;
     0,1,0,1,0,1,0;
     0,0,0,0,0,0,0];
mask1 = [1, 1, 1];
mask2 = [1, 1; 0, 1];
[M, N] = size(A);
mask1
expendA = zeros(M+1, N+3);  % 零扩展A，下补一行，左补一列，右补一列
expendA(1:M, 2:N+1) = A;
A

%% dilation with mask1
B = zeros(M, N);
 for i = 1:M
     for j = 2:N+1
        tmp = expendA(i, j:j+2);
        if sum(tmp.*mask1)>=1 
            B(i,j-1) = 1;
        end
     end
 end
B

 %% erosion with mask1
 C = zeros(M, N);
 for i = 1:M
     for j = 2:N+1
        tmp = expendA(i, j:j+2);
        if sum(tmp.*mask1) == 3 
            C(i,j-1) = 1;
        end
     end
 end
C

%% dilation with mask2

D = zeros(M, N);
for i = 1:M
    for j = 2:N+1
       tmp = expendA(i:i+1, j-1:j);      
       if sum(sum(tmp.*mask2)) >= 1 
           D(i,j-1) = 1;
       end
    end
end
D

%% erosion with mask2

E = zeros(M, N);
v = sum(sum(mask2));
for i = 1:M
    for j = 2:N+1
       tmp = expendA(i:i+1, j-1:j);
       if sum(sum(tmp.*mask2)) == v && tmp(2, 1) == 0
           E(i,j-1) = 1;
       end
    end
end
E

%% opening with mask1
F0 = zeros(M, N);
% erosion
 for i = 1:M
     for j = 2:N+1
        tmp = expendA(i, j:j+2);
        if sum(tmp.*mask1) == 3 
            F0(i,j-1) = 1;
        end
     end
 end
% dilation
expendF0 = zeros(M+1, N+3);  % 零扩展F0，下补一行，左补一列，右补一列
expendF0(1:M, 2:N+1) = F0;
F = zeros(M, N);
 for i = 1:M
     for j = 2:N+1
        tmp = expendF0(i, j:j+2);
        if sum(tmp.*mask1) >= 1 
            F(i,j-1) = 1;
        end
     end
 end
F

%% opening with mask2
G0 = zeros(M,N);
%erosion
for i = 1:M
    for j = 2:N+1
       tmp = expendA(i:i+1, j-1:j);
       if sum(sum(tmp.*mask2)) == v && tmp(2, 1) == 0
           G0(i,j-1) = 1;
       end
    end
end
%dilation
expendG0 = zeros(M+1, N+3);  % 零扩展F0，下补一行，左补一列，右补一列
expendG0(1:M, 2:N+1) = G0;
G = zeros(M,N);
for i = 1:M
    for j = 2:N+1
       tmp = expendG0(i:i+1, j-1:j);      
       if sum(sum(tmp.*mask2)) >= 1 
           G(i,j-1) = 1;
       end
    end
end
G


%% closing with mask1
%dilation
H0 = zeros(M, N);
 for i = 1:M
     for j = 2:N+1
        tmp = expendA(i, j:j+2);
        if sum(tmp.*mask1) >= 1 
            H0(i,j-1) = 1;
        end
     end
 end
%erosion
expendH0 = zeros(M+1, N+3);  % 零扩展F0，下补一行，左补一列，右补一列
expendH0(1:M, 2:N+1) = H0;
H = zeros(M, N);
 for i = 1:M
     for j = 2:N+1
        tmp = expendH0(i, j:j+2);
        if sum(tmp.*mask1) == 3 
            H(i,j-1) = 1;
        end
     end
 end
 H
 
%% closing with mask2
%dilation
I0 = zeros(M,N);
for i = 1:M
    for j = 2:N+1
       tmp = expendA(i:i+1, j-1:j);      
       if sum(sum(tmp.*mask2)) >= 1 
           I0(i,j-1) = 1;
       end
    end
end
expendI0 = zeros(M+1, N+3);  % 零扩展H0，下补一行，左补一列，右补一列
expendI0(1:M, 2:N+1) = I0;

%erosion
I = zeros(M, N);
for i = 1:M
    for j = 2:N+1
       tmp = expendI0(i:i+1, j-1:j);
       if sum(sum(tmp.*mask2)) == v && tmp(2, 1) == 0
           I(i,j-1) = 1;
       end
    end
end
I


