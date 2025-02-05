function EE_figs()

%% 前言

% 加载全局变量
global malla_a matSt pos ind ...   % 参数和状态
        a_pol c_pol vv ...          % 最优决策和值函数
        mu                          % 分布

% 图形选项
tam_f = 16; % 字体大小
tam_l = 2;  % 线宽

% 颜色定义
azul = [35 80 217]/255;      % 蓝色
naranja = [0.9290 0.6940 0.1250]; % 橙色
rojo = [218 58 52]/255;      % 红色
gris = [0.5 0.5 0.5];        % 灰色


%% 资产积累

% 最优决策
figure()
hold on
    % 主要绘图
    plot(malla_a, a_pol(ind.z_min), "LineWidth", tam_l, "Color", rojo)  % 最低生产率组
    plot(malla_a, a_pol(ind.z_med), "LineWidth", tam_l, "Color", naranja) % 中等生产率组
    plot(malla_a, a_pol(ind.z_max), "LineWidth", tam_l, "Color", azul)  % 最高生产率组
    % 零积累线
    plot(malla_a, malla_a, ':', 'Color', gris, 'LineWidth', tam_l)
    % 图形选项
    grid on
    set(gca,'FontSize', tam_f)
    % 标签
    title('资产积累')
    subtitle('按生产率分组')
    xlabel('期初资产')
    ylabel('期末资产')
    legend('最低生产率', '中等生产率', '最高生产率', ...
           'Location', 'best');
hold off


%% 消费

% 最优决策
figure()
hold on
    % 主要绘图
    plot(malla_a, c_pol(ind.z_min), "LineWidth", tam_l, "Color", rojo)  % 最低生产率组
    plot(malla_a, c_pol(ind.z_med), "LineWidth", tam_l, "Color", naranja) % 中等生产率组
    plot(malla_a, c_pol(ind.z_max), "LineWidth", tam_l, "Color", azul)  % 最高生产率组
    % 图形选项
    grid on
    set(gca,'FontSize', tam_f)
    % 标签
    title('消费政策')
    subtitle('按生产率分组')
    xlabel('期初资产')
    ylabel('消费')
    legend('最低生产率', '中等生产率', '最高生产率', ...
           'Location', 'best');
hold off


%% 值函数

% 值函数绘图
figure()
hold on
    % 主要绘图
    plot(malla_a, vv(ind.z_min), "LineWidth", tam_l, "Color", rojo)  % 最低生产率组
    plot(malla_a, vv(ind.z_med), "LineWidth", tam_l, "Color", naranja) % 中等生产率组
    plot(malla_a, vv(ind.z_max), "LineWidth", tam_l, "Color", azul)  % 最高生产率组
    % 图形选项
    grid on
    set(gca,'FontSize', tam_f)
    % 标签
    title('值函数')
    subtitle('按生产率分组')
    xlabel('期初资产')
    ylabel('值')
    legend('最低生产率', '中等生产率', '最高生产率', ...
           'Location', 'best');
hold off


%% 资产分布

% 资产分布绘图
figure()
hold on
    % 最低生产率组的资产分布
    plot(malla_a, accumarray(matSt(:,pos.a), mu .* ind.z_min) / sum(mu(ind.z_min)), ...
         'LineWidth',tam_l,'Color',rojo)
    % 中等生产率组的资产分布
    plot(malla_a, accumarray(matSt(:,pos.a), mu .* ind.z_med) / sum(mu(ind.z_med)), ...
         'LineWidth',tam_l,'Color',naranja)
    % 最高生产率组的资产分布
    plot(malla_a, accumarray(matSt(:,pos.a), mu .* ind.z_max) / sum(mu(ind.z_max)), ...
         'LineWidth',tam_l,'Color',azul)
    % 图形选项
    grid on
    set(gca,'FontSize', tam_f)
    % 标签
    title('财富分布')
    subtitle('按生产率分组')
    xlabel('资产')
    ylabel('分布')
    legend('最低生产率', '中等生产率', '最高生产率', ...
           'Location', 'best');
hold off

end