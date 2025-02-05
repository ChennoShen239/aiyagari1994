function [Z,Zprob] = tauchen(N,mu,rho,sigma,m)
%TAUCHEN  使用Tauchen方法近似AR(1)过程的马尔可夫链。
%
%   [Z, Zprob] = tauchen(N,mu,rho,sigma,m)
%
%   该函数找到一个马尔可夫链，其样本路径近似于AR(1)过程的样本路径：
%       z(t+1) = (1-rho)*mu + rho * z(t) + eps(t+1)
%   其中eps是标准差为sigma的正态分布。
%
%   输入参数：
%       N:      标量，Z的节点数。
%       mu:     标量，过程的无条件均值。
%       rho:    标量，自回归系数。
%       sigma:  标量，epsilon的标准差。
%       m:      标量，最大正负标准差倍数，用于确定Z的范围。
%
%   输出参数：
%       Z:      N*1向量，Z的节点。
%       Zprob:  N*N矩阵，转移概率。
%
%   作者：Martin Floden
%   日期：1996年秋季
%
%   此程序实现了George Tauchen在Ec. Letters 20 (1986) 177-181中描述的算法。

Z     = zeros(N,1); % 初始化Z向量
Zprob = zeros(N,N); % 初始化转移概率矩阵
a     = (1-rho)*mu; % 计算常数项

Z(N)  = m * sqrt(sigma^2 / (1 - rho^2)); % 设置Z的最大值
Z(1)  = -Z(N); % 设置Z的最小值
zstep = (Z(N) - Z(1)) / (N - 1); % 计算Z的步长

for i=2:(N-1)
    Z(i) = Z(1) + zstep * (i - 1); % 创建Z的网格
end 

Z = Z + a / (1-rho); % 调整Z的均值

for j = 1:N % 遍历所有起始状态
    for k = 1:N % 遍历所有目标状态

        if k == 1 % 计算转移到第一个状态的概率
            Zprob(j,k) = normcdf((Z(1) - a - rho * Z(j) + zstep / 2) / sigma,0,1);
        elseif k == N % 计算转移到最后一个状态的概率
            Zprob(j,k) = 1 - normcdf((Z(N) - a - rho * Z(j) - zstep / 2) / sigma,0,1);
        else % 计算转移到中间状态的概率
            Zprob(j,k) = normcdf((Z(k) - a - rho * Z(j) + zstep / 2) / sigma,0,1) - ...
                         normcdf((Z(k) - a - rho * Z(j) - zstep / 2) / sigma,0,1);
        end
    end
end

end