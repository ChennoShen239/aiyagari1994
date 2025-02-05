function EE_sumario(r, w, K_agg, L_agg)
% ----------------------------------------------------------------------- %
%
% 该函数提供稳态的总结信息：
%   - 宏观变量。
%   - 分布的统计量。
%
% ----------------------------------------------------------------------- %

% 加载相关全局变量
global eco vv mu matSt pos malla_z malla_a c_pol

fprintf('\n稳态总结\n\n')

%% 宏观变量

% 计算宏观变量
    % 总产出
    Y_agg = K_agg^eco.alpha * L_agg^(1 - eco.alpha);
    % 总消费
    C_agg = sum(c_pol .* mu);
    % 总福利
    W_agg = sum(vv .* mu);

% 显示结果
fprintf("宏观变量:\n" + ...
        "- 年利率: %2.2f%%.\n" + ...
        "- 人均 GDP: %2.2f.\n" + ...
        "- 资本-GDP 比率: %2.2f.\n" + ...
        "- 总福利: %4.4f.\n" + ...
        "- 商品市场误差: %1.4f.\n\n", ...
        100 * r, Y_agg, K_agg / Y_agg, W_agg, C_agg + eco.delta * K_agg - Y_agg);


%% 不平等度量

% 设置
n_cuan = 5; % 分位数数量
top = 10;   % 分布中关注的顶部群体

% 分布的统计量
    % 收入
    cuan_renta = round(100 * cuantiles(n_cuan, w * malla_z(matSt(:, pos.z)), mu, top));
    % 财富
    cuan_riq = round(100 * cuantiles(n_cuan, malla_a(matSt(:, pos.a)), mu, top));

% 显示数据
fprintf("收入分布:\n" + ...
        "- 按分位数划分的劳动收入（模拟）:    \t %s.\n" + ...
        "- 按五分位数划分的劳动收入（法国，2014）: \t 3%% 11%% 17%% 19%% 42%%.\n" + ...
        "- 收入最高的 %d%% 群体占总收入的百分比（模拟）:   \t %d%%.\n" + ...
        "- 收入最高的 10%% 群体占总收入的百分比（法国，2014）:\t 32%%.\n\n", ...
        join(string(cuan_renta(1:end-1)) + "%"), top, cuan_renta(end));
fprintf("财富分布:\n" + ...
        "- 按分位数划分的财富（模拟）:    \t %s.\n" + ...
        "- 按五分位数划分的财富（法国，2014）: \t 1%% 6%% 13%% 21%% 59%%.\n" + ...
        "- 财富最高的 %d%% 群体占总财富的百分比（模拟）:   \t %d%%.\n" + ...
        "- 财富最高的 10%% 群体占总财富的百分比（法国，2014）:\t 41%%.\n\n", ...
        join(string(cuan_riq(1:end-1)) + "%"), top, cuan_riq(end));


end