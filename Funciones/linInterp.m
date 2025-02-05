function zinterp = linInterp(x,y,z,extrap)
%LININTERP 使用线性插值计算z值。
%   zinterp = linInterp(x,y,z,extrap)  根据给定的x, y和z数据，
%   以及指定的插值方法extrap，计算插值后的z值zinterp。
%
%   输入参数：
%       x: 插值点的x坐标。
%       y: 插值点的y坐标。
%       z: 已知数据点的z值。
%       extrap: 插值方法，'cap'表示不进行外插，将超出范围的权重限制在[0,1]内。
%
%   输出参数：
%       zinterp: 插值后的z值。

% 获取权重和上下限索引。
[lower,upper,weight] = getWeights(x,y);

% 处理外插情况。
if strcmp(extrap,'cap')
    % 不进行外插，将权重限制在[0, 1]范围内。
    weight(weight>1) = 1;
    weight(weight<0) = 0;
end

% 线性插值计算z值。
zinterp = z(lower).*weight + z(upper).*(1-weight); 

end