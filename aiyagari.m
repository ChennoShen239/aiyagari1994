% ----------------------------------------------------------------------- %
%
%   宏观经济学不平等建模入门：
%   AIYAGARI 模型
%   v2: - 异质性主体（个体生产率冲击）。
%       - 方法：使用欧拉方程的内生网格法，结合插值。
%
% ----------------------------------------------------------------------- %

%% 准备工作

% 清理工作区
clear all;  % 清除所有变量
close all;  % 关闭所有图形窗口
clc;        % 清空命令窗口
tic;        % 开始计时

% 添加函数文件夹路径
addpath Funciones;                % 包含辅助函数的文件夹
addpath Estado_Estacionario;      % 包含稳态计算函数的文件夹

% 创建全局变量
global eco n malla_a malla_z pi_z matSt pos ind c_pol vv indL indU wgt;

% 模型参数
% 经济参数
eco.crra    = 2.0;      % 风险厌恶系数 / 跨期替代弹性
eco.beta    = 0.93;     % 折现因子
eco.delta   = 0.12;     % 资本折旧率
eco.alpha   = 0.36;     % 资本在生产中的份额
eco.a_min   = 0.00;     % 资产下限（借贷约束）
rho_z       = 0.90;     % 个体生产率冲击的持续性
sigma_z     = 0.20;     % 个体生产率冲击的波动性

% 数值解参数
n.z         = 10;       % 生产率网格的节点数
n.a         = 500;      % 资产网格的节点数
eco.a_max   = 50;       % 资产上限

% 总状态数
n.N = n.z * n.a;

% 资产网格
malla_a = linspace(eco.a_min, eco.a_max, n.a)';  % 生成线性分布的资产网格

%% 生产率
% 个体生产率冲击的近似
% log(z_t) = rho * log(z_t-1) + sigma * epsilon_t

% 生产率网格：malla_z
% 状态转移概率矩阵：pi_z
%   pi_z(i, j) 表示从 malla_z(i) 转移到 malla_z(j) 的概率
% 生产率的稳态分布：mu_z

% 使用 Tauchen 方法离散化 AR(1) 过程
[log_z, pi_z] = tauchen(n.z, 0, rho_z, sigma_z, 3);
malla_z = exp(log_z);  % 将对数生产率转换回原始值

% 生产率的稳态分布
mu_z = ones(n.z, 1) / n.z;  % 初始分布为均匀分布
tst_z = 1;  % 收敛判断变量
tol_z = 1e-8;  % 收敛容差
while (tst_z > tol_z)
    mu_z2 = pi_z' * mu_z;  % 更新分布
    tst_z = max(abs(mu_z2 - mu_z));  % 计算最大变化
    mu_z = mu_z2;  % 更新分布
end

% 总就业量
% （由于劳动供给无弹性，可以提前计算）
L_agg = malla_z' * mu_z;

% 清理辅助变量
clear a_max log_z mu_z2 rho_z sigma_z tol_z tst_z;

%% 状态矩阵
% 该矩阵表示每个家庭的生产率和资产水平

% 状态变量的位置
pos.z = 1;  % 生产率在第一列
pos.a = 2;  % 资产在第二列

% 状态矩阵
matSt(:, pos.z) = kron((1:n.z)', ones(n.a, 1));  % 生产率状态
matSt(:, pos.a) = kron(ones(n.z, 1), (1:n.a)');  % 资产状态

% 索引（用于将家庭分类到相关组）
ind.z_min = (matSt(:, pos.z) == 1);  % 最低生产率组
ind.z_med = (matSt(:, pos.z) == round(n.z / 2));  % 中等生产率组
ind.z_max = (matSt(:, pos.z) == n.z);  % 最高生产率组

%% 稳态计算
% 对利率 (r) 进行迭代

% 初始化
r_0     = 0.03;     % 初始猜测值
tst_r   = 1;        % 收敛判断变量
tol_r   = 1e-6;     % 收敛容差
peso_r  = 0.8;      % 初始猜测值的权重
iter    = 0;        % 迭代计数器

% 迭代循环
while (tst_r > tol_r)
    % 迭代计数
    iter = iter + 1;
    % 根据企业的一阶条件计算工资
    w_0 = (1 - eco.alpha) * ((eco.alpha / (r_0 + eco.delta))^eco.alpha)^(1 / (1 - eco.alpha));
    % 家庭问题
    %   EE_hogares 更新全局变量：
    %   - 最优消费和储蓄决策。
    %   - 状态转移矩阵 Q。
    %   - 稳态分布 mu。
    %   此外，EE_hogares 返回总资本供给 K1
    K_agg = EE_hogares(r_0, w_0);
    % 根据企业问题计算新的利率
    r_1 = eco.alpha * max(0.001, K_agg)^(eco.alpha - 1) * L_agg^(1 - eco.alpha) - eco.delta;
    % 收敛判断
    tst_r = abs(r_1 - r_0);  % 计算误差
    % 显示当前状态
    fprintf('#%d | r_0: %.4f, r_1: %.4f | 误差: %.5f\n\n', iter, r_0, r_1, tst_r);
    % 更新猜测值
    r_0 = peso_r * r_0 + (1 - peso_r) * r_1;
end

%% 值函数计算

% 效用函数
util = @(c) (c.^(1 - eco.crra) - 1) / (1 - eco.crra);

% 初始化
vv = util(c_pol);  % 初始猜测值
tst_v = 1;  % 收敛判断变量
tol_v = 1e-8;  % 收敛容差

% 迭代循环
while tst_v > tol_v
    % 计算未来值
    v_aux = eco.beta * pi_z(matSt(:, pos.z), :) * reshape(vv, n.a, n.z)';
    v_con = wgt .* v_aux((1:n.N)' + (indL - 1) * n.N) + ...
            (1 - wgt) .* v_aux((1:n.N)' + (indU - 1) * n.N);
    % 更新值函数
    v_1 = util(c_pol) + v_con;
    % 收敛判断
    tst_v = max(abs(v_1 - vv));
    vv = v_1;
end

%% 统计结果
EE_sumario(r_0, w_0, K_agg, L_agg);

%% 绘图
EE_figs;

% 结束计时
toc;