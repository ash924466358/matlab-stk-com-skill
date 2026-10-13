# 分析功能创建模块

触发：Access、链路、Coverage/FOM、PNT/GDOP、通信预算、Astrogator 任务、轨道寿命、碰撞或 Aviator。输入：已传播对象、时间交集、约束/模型和对应许可；输出：计算结果、指标及实际模型假设。高级模块先核实本机许可和 11.6/12.1 接口存在性。

## Access / Chain

`a=from.GetAccessToObject(to); a.ComputeAccess;` → Access Data interval Provider。模板 stk_access_intervals 返回全部窗口；无窗口是空结果。取 AER Data 要选择 Default/BodyFixed 等组，按窗口遍历。修改位置、轨道、指向或约束后重算；Satellite 对象可见不代表其 Sensor/收发机可通信。

Chain.Objects 按链路顺序添加，`chain.ComputeAccess`；Complete Chain Access/Access AER Data 与两对象 Access 区别明确。每个返回区间都保留；不要按固定 8 列或 DataSets.Count/8 推断资产结构。

按指标选最优资产：把 AER 的原始时间映射到统一时间网格，处理窗口边界、并列和无可用资产。AccessByMetric 原例混用 index、timeStep、Epoch，不能将 MATLAB 行号直接转 UTCG；输出必须来自 timeArray(index)。

## Coverage / FOM / ObjectCoverage

CoverageDefinition：Grid Bounds → Grid Resolution → AssetList → 分析 Interval → ComputeAccesses；FOM 在 Coverage 下创建，SetDefinitionType/计算方式→相关 Provider。静态/动态 FOM 用不同 Provider。GridInspector.SelectPoint/SelectRegion 后读取 PointCoverage/PointFOM/Selected Region Coverage。

移动对象覆盖：`obj.ObjectCoverage.Assets.Add` → Compute → FOM 定义 GDOP/GACC；Range uncertainty 单位逐项核实。对象覆盖不是普通地理网格 CoverageDefinition。PNT 需足够几何资产、正确高度和地形；联网地形服务不是离线默认。

每日统计裁剪至分析区间，保留末尾不足一天；区间合并再求总时长，避免重叠重复计数。coverageAccumPercent 应只对 Percent Accum Coverage 列找首次达阈值，不在 [time,percent] 整个矩阵上 find；缺失阈值结果不要写 0 混同“立即达到”。3D 网格先估算点数，Levels>=2、单位和 .pnt 格式需核实。

## 通信预算

Tx/Rx 选择 Model/天线后设置功率、频率、数据率、损耗、跟踪开关，再 ComputeAccess/Chain。OM 可采用 dBW/GHz，Connect SetValue 常为 W/Hz，查 GetValue 和模型文档，不按原注释推断。Link Information 字段带编号，与链路序列一致。

LinkBudgetLatLonChain 以截短数组对齐不同 Provider 会失去时间对应关系；按时间与窗口连接数据。所需 Eb/No 未设时 Link Margin 的 -9999 是无效/哨兵值，不能当物理裕度。地面站扫描后恢复原位置并重算。

## Astrogator / 寿命 / 碰撞

Satellite.SetPropagatorType('ePropagatorAstrogator') → MainSequence → InitialState/Propagate/Maneuver/TargetSequence → 停止条件/控制量/结果 → RunMCS → 检查收敛与残差 → ApplyAllProfileChanges（仅目标解需提交时）。不全清 MCS。DV2 必须取 dv2.Maneuver，官方 Complete 文件仍误取 dV1。

Lifetime：SetLifetime→Lifetime 返回文本，用已核实格式解析；质量/面积/Cd/空间天气及模型来源写入输出。TLE_Deorbit 的在线源是可选依赖，离轨日期是模型估计，受阻力与外推不确定性影响。Monte Carlo 记录 rng 和扰动单位，约束 a/e/i 合法，不用默认“e 的 sigma=10”作为真实设定。PassiveSafety 的固定 7 字段假设及缺省输出要改为按名称提取/初始化。

AdvCAT 确认对象和事件 Provider，提取真实事件数，不将返回文本行数当事件数。扫描模型前备份可变状态，任务完成后恢复。

## Aviator

Aircraft.Route.AvtrPropagator → Catalog/AvtrMission/Phases/Procedures → Vehicle、Site、Navigation/Profile → Propagate。跑道/性能模型缺失即停止该步骤；类型配对以本机帮助为准。AviatorDistance、高度 ft、距离 nm、速度 nm/hr、部分接口固定 SI 需分别检查。禁止把 FuelConsumption 原例的共享模型删除当成初始化。

高级源码定位见 [案例索引](../tutorial-case-index.md)，取数与保存见 [data-output](data-output.md)。
