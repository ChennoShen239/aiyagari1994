function cuan = cuantiles(n_cuan, datos, distr, top)
    % ----------------------------------------------------------------------- %
    %
    % 该函数计算给定数据的分位数和顶部群体的份额。
    % 输入：
    %   - n_cuan: 分位数数量。
    %   - datos: 数据向量。
    %   - distr: 数据对应的分布（权重）。
    %   - top: 顶部群体的百分比（例如，10 表示顶部 10%）。
    % 输出：
    %   - cuan: 分位数和顶部群体的份额。
    %
    % ----------------------------------------------------------------------- %

    % 准备工作：分位数划分
    divs = linspace(0, 1, n_cuan + 1);  % 将 [0, 1] 区间划分为 n_cuan + 1 个点
    divs = divs(2:end);  % 去掉第一个点（0），保留分位点

    % 将数据按从小到大排序
    [datos_ord, i_ord] = sort(datos);  % datos_ord 是排序后的数据，i_ord 是排序索引

    % 计算累积分布
    distr_ord = distr(i_ord);  % 按排序后的数据重新排列分布
    distr_acum = cumsum(distr_ord) / sum(distr_ord);  % 计算累积分布

    % 计算累积份额
    cuota_acum = cumsum(datos_ord .* distr_ord) / sum(datos_ord .* distr_ord);  % 计算累积份额

    % 丢弃质量接近 0 的元素
    i_aux = (distr_ord > 1e-15);  % 仅保留分布质量大于 1e-15 的元素

    % 插值计算分位数
    aux_cuan = interp1(distr_acum(i_aux), cuota_acum(i_aux), divs, 'linear', 'extrap');  % 线性插值

    % 计算顶部群体的份额
    cuota_top = 1 - interp1(distr_acum(i_aux), cuota_acum(i_aux), 1 - top / 100);  % 计算顶部群体的份额

    % 返回结果
    cuan = [diff([0, aux_cuan]), cuota_top];  % 返回分位数和顶部群体的份额
end