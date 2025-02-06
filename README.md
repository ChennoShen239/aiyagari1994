# Aiyagari (1994) 模型实现

这个项目实现了Aiyagari (1994)的异质性主体宏观经济模型。该模型研究了不完全市场条件下的储蓄行为和财富分配。

## 模型特点

- 异质性主体(个体生产率冲击)
- 不完全市场(无法完全规避个体风险)
- 一般均衡框架
- 使用欧拉方程的内生网格法求解

## 环境要求

- MATLAB R2019b或更高版本
- MATLAB Statistics and Machine Learning Toolbox（用于部分统计计算）

## 安装

1. 克隆仓库到本地：
```bash
git clone https://github.com/chengao1992/aiyagari1994.git
```

2. 在MATLAB中添加项目路径：
```matlab
addpath(genpath('aiyagari1994'));
```

## 代码结构

```
.
├── aiyagari1994/           # 主要代码目录
│   ├── aiyagari.m         # 主程序文件
│   ├── tauchen.m         # Tauchen方法离散化AR(1)过程
│   ├── linInterp.m       # 线性插值函数
│   ├── getWeights.m      # 计算网格插值权重
│   ├── quantiles.m       # 计算分位数
│   └── Steady_State/     # 稳态计算相关函数
│       ├── solveHH.m     # 求解家庭问题
│       ├── summary.m     # 计算统计结果
│       └── plotFigs.m    # 绘制结果图形
```

## 主要参数说明

经济参数:
- `econ.risk_aversion`: 风险厌恶系数 (默认=2.0)
- `econ.discount_factor`: 折现因子 (默认=0.93)
- `econ.depreciation_rate`: 资本折旧率 (默认=0.12)
- `econ.capital_share`: 资本份额 (默认=0.36)
- `econ.asset_min`: 借贷约束 (默认=0)
- `econ.asset_max`: 资产上限 (默认=50)

生产率冲击参数:
- `rho_prod`: AR(1)过程的持续性 (默认=0.90)
- `sigma_prod`: 创新项的标准差 (默认=0.20)

数值方法参数:
- `n_prod`: 生产率网格点数 (默认=7)
- `n_asset`: 资产网格点数 (默认=500)

## 使用说明

1. 确保所有文件在正确的目录结构下
2. 在MATLAB中运行主程序:

```matlab
run aiyagari.m
```

## 输出结果

程序会输出以下结果:

1. 稳态统计量:
- 利率和工资
- 总产出、资本和消费
- 资本产出比
- 资产分布的基尼系数和分位数

2. 图形结果:
- 消费政策函数
- 储蓄政策函数
- 资产分布直方图
- 洛伦兹曲线

## 贡献

欢迎提交问题和改进建议！如果你想贡献代码：

1. Fork 这个仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的改动 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

## 许可证

该项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 参考文献

Aiyagari, S. R. (1994). "Uninsured Idiosyncratic Risk and Aggregate Saving." *The Quarterly Journal of Economics*, 109(3), 659-684.

