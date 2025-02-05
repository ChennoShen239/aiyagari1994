function K_agg = EE_hogares(r, w)
% ----------------------------------------------------------------------- %
%
% 该函数以给定的价格 (r, w) 作为输入，返回：
% - 全局变量：最优决策、状态转移矩阵和分布。
% - 返回值：总资本供给。
%
% ----------------------------------------------------------------------- %

%% 前言

% 加载全局变量
global eco n malla_a malla_z pi_z matSt pos ...    % 参数和状态
        a_pol c_pol indL indU wgt ...               % 最优决策和值函数
        Q mu                                        % 状态转移矩阵和分布

% 家庭层面的变量
hh_z    = malla_z;              % 生产率
hh_a    = malla_a';             % 资产
hh_dem  = w * hh_z + (1 + r) * hh_a;  % 手头现金

% 函数定义
    % 由预算约束和储蓄决策推导出的消费函数
    c_RP = @(dem, a_sig) dem - a_sig;


%% 内生网格法

% 初始猜测
    % 储蓄策略（网格）
    a_sig_0 = hh_a;
    % 消费策略（预算约束，假设 a' = a）
    c_sig_0 = w * malla_z + r * a_sig_0;

% 收敛标准
tst_MME = 1;  % 收敛判断变量
tol_MME = 1e-8;  % 收敛容差

% 迭代循环
while tst_MME > tol_MME
    % 由欧拉方程推导的消费
    c_imp = (eco.beta * (1 + r) * pi_z * c_sig_0.^(-eco.crra)).^(1 / -eco.crra);
        % 行表示当前生产率
        % 列表示储蓄决策（下一期的资产）
    % 由预算约束推导的财富
    a_imp = (c_imp + a_sig_0 - w * malla_z) / (1 + r);
    % 更新储蓄策略（插值）
        for zz = 1:n.z
            a_MME(zz, :) = linInterp(hh_a, a_imp(zz, :), a_sig_0, 'capS');
        end
        % 借贷约束
        a_MME(a_MME < eco.a_min) = eco.a_min;
        % 最大储蓄限制
        a_MME(a_MME > eco.a_max) = eco.a_max;
    % 更新消费策略（预算约束）
    c_MME = c_RP(hh_dem, a_MME);
    % 收敛判断
    tst_MME = max(abs(c_MME - c_sig_0));  % 计算误差
    c_sig_0 = c_MME;  % 更新猜测值
end

% 最优决策（向量化格式）
a_pol = reshape(a_MME', n.N, 1);  % 最优储蓄策略
c_pol = reshape(c_MME', n.N, 1);  % 最优消费策略

% 显示状态
disp('家庭问题已解决。')


%% 状态转移矩阵 Q

% 准备工作
    % 插值（a_pol 不再在网格上）
    [indL, indU, wgt] = getWeights(a_pol, malla_a);
    % 指示变量：=1 表示最优储蓄位置
    a_mat = sparse(indL, 1:n.N, wgt, n.a, n.N) + ...
            sparse(indU, 1:n.N, 1 - wgt, n.a, n.N);
        % 行表示下一期的储蓄
        % 列表示当前状态
    % 初始化状态转移矩阵
    Q = [];

% 构建状态转移矩阵 Q
    for z_sig = 1:n.z  % 遍历未来的生产率状态
        auxQ = a_mat .* pi_z(matSt(:, pos.z), z_sig)';
        % 将新行添加到 Q 的末尾
        Q = [Q; auxQ];
    end
    % 关于矩阵 Q：
        % - 列表示初始状态 (z, a)。
        % - 行表示下一期的状态 (z', a')。
        % - 每个单元格表示从 (z, a) 转移到 (z', a') 的概率。

disp('状态转移矩阵已获得。')


%% 分布
% 现在有了 Q，可以计算稳态分布

% 准备工作
    tol_mu = 1e-8;  % 收敛容差
    tst_mu = 1;  % 初始化收敛判断变量
    mu = ones(n.N, 1) / n.N;  % 初始分布（均匀分布）

% 计算稳态分布
    while tst_mu >= tol_mu
        mu_imp = Q * mu;  % 更新分布
        tst_mu = max(abs(mu_imp - mu));  % 计算误差
        mu = mu_imp;  % 更新分布
    end

disp('稳态分布已获得。')


%% 返回值

% 总资本供给
K_agg = sum(a_pol .* mu);  % 计算总资本供给