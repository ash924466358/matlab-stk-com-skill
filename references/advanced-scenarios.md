# 场景分类与进阶接口

按任务读取本节对应原例，不把进阶教程整段运行。这是首批65个文件的协议补充。新增官方教程按 [功能模块入口](../SKILL.md) 与 [官方案例索引](tutorial-case-index.md) 路由；仅在处理本页具体协议时加载。以下是从本地代码提炼的路由；许可证、组件名称与属性以 STK 11.6/12.1 本地帮助为准。

## 传感器、约束、姿态、外部文件

来源：Example/AddSensor.m、AdjustSensor.m、AdjustSensorAttitude.m、AdjustSatelliteAttitude.m、Example_4.m、PropSat.m。

- Sensor 是父对象 Children；相对路径保留完整层级，不能只取 ClassType 和 InstanceName 拼嵌套路径。
- SetPatternType 后访问相应 Pattern：eSnSimpleConic/ConeAngle，eSnRectangular/HorizontalHalfAngle、VerticalHalfAngle，eSnSAR，eSnComplexConic。角度是半角，不能混成全角。
- AccessConstraints.IsConstraintActive → GetActiveConstraint 或 AddConstraint；无论是否已存在都检查 EnableMin/EnableMax，Max/Min 单位随约束类型，不全是 km。
- 固定指向用 CommonTasks.SetPointingFixedEuler；目标指向用 SetPointingType('eSnPtTargeted') 后 Pointing.Targets.AddObject。需要替换目标队列时按授权清理，避免重复目标。
- 传感器外部指向文件：SetPointingExternalFile(.sp)。卫星外部姿态：Attitude.External.Load(.a)；转目标姿态需 External.Disable 和 Pointing.UseTargetPointing。
- 外部星历：SetPropagatorType('ePropagatorStkExternal') → 重新获取 Propagator → Filename → Propagate。
- .e/.a/.sp 文件的坐标系、DistanceUnit、ScenarioEpoch、时间范围和格式头必须与用途一致；路径用 fullfile，先 exist(path,'file')，不改写原文件。Example_4 写成工作区根路径，但样例文件实际位于 Example/。

## Coverage、FOM、Chain、通信

来源：Example/Example_2.m；Automation/Matlab/Coverage_ObjectModel.m、Comm_ConnectCommands.m、STK_Automation_Tutorial.m。

CoverageDefinition → Grid.BoundsType='eBoundsCustomRegions' → Bounds.AreaTargets.Add('AreaTarget/name') → Grid.Resolution.LatLon → AssetList.Add(完整相对路径) → ComputeAccesses。FOM 为 Coverage 的子对象；SetDefinitionType('eFmRevisitTime')；固定型 Overall Value/Static Satisfaction 用 Exec()。GridInspector.SelectPoint 后查看 PointFOM。Coverage 许可和实际网格大小先核实；min=max 时原例 contours 步长为 0，需专门处理。

Chain.Objects 按链路顺序 AddObject，ComputeAccess 后逐报告 Intervals 读。传感器 Access 包含视场/指向/约束；Satellite Access 不等价。ComputedAccessIntervalTimes 是计算结果，不要为了读取而 SpecifyAccessIntervals 修改下一次计算区间。

收发机 Connect SetValue 示例的频率是 Hz、功率可能是线性 W、角度可能 rad；不能照搬 OM 的单位。先 GetValue 查询所选 Model 的属性与帮助。许可、频率/带宽跟踪开关、发射接收方向、天线模型和报告可用性分别检查。源通信例场景 2013、卫星传播 2007，重叠时间必须纠正。

## Analysis Workbench / VGT

来源：Automation/Matlab/AnalysisWorkbench_ObjectModel.m。

对象.Vgt 与 CentralBodies.Earth.Vgt 都是组件提供者；Vectors/Points/Axes/Systems/Angles.Factory 创建组件。DisplacementVector 要有 From/To point；FixedInSystem 要有参考系；AlignedAndConstrained 要有非退化对齐与约束矢量。CalcScalars.Factory 创建幅值或 DataElement，Conditions 定义阈值，Events/EventIntervals/EventIntervalLists 定义时刻和窗口。NewQuantity 明确维度和单位。FindOccurrence 等求值结果先检查有效性再取 Epoch，不推断创建组件就一定能在全时段求值。

## Astrogator 与轨道寿命

来源：Automation/Matlab/Astrogator_ObjectModel.m、LifetimeTool.m。

Astrogator 需要许可：SetPropagatorType('ePropagatorAstrogator') → MainSequence → Insert InitialState/Propagate/TargetSequence/Maneuver → 配置停止条件、ControlParameters/Results → RunMCS。任务仅修改某段时不能直接 RemoveAll。复制 DV2 时必须拿 dv2.Maneuver，原例误用 dv1.Maneuver。瞄准完成需检查收敛/目标残差，不把 RunMCS 返回当作收敛证明。单段 BeginRun/EndRun 配对，异常也结束运行。

Lifetime 示例：SetUnits / km sec UTCG → SetState Cartesian → SetLifetime → Lifetime；返回值是文本。原例按空格固定位置提取数值易随版本失效，str2num 有求值语义，改用核对过的格式和 str2double。寿命物理模型假设与初始质量/面积/阻力系数需要任务提供。

## Aviator 与共享 Catalog

来源：Automation/Matlab/Aviator_ObjectModel_FuelConsumptionStudy.m、Aviator_ObjectModel_CarrierLanding.m。

Aircraft.Route.AvtrPropagator → AvtrMission → Phases → Procedures；Site 和 Procedure 类型配对，性能模型/跑道目录必须存在，Aviator 常用 ft、nm、nm/hr，与普通 Route km/km/s 不同。GetDirectory / STKHome 定位样例数据，不硬编码 Program Files。Fuel 示例会删除同名 AircraftModels、写 UserRunways，属于共享目录副作用；优先唯一名称且仅改任务范围。Catalog 查找失败立即给出具体错误，不仅 disp 后继续用未定义变量。

## Engine、事件与 TCP

来源：CustomApplications/Matlab 下全部 4 个 .m。

STKX12.Application 是 Engine；AgStkObjects12.AgStkObjectRoot 是独立 OM 根；STKX12.VOControl、STKX12.2DControl 是嵌入式控件，不能假定有桌面 app.Personality2/UserControl。GUIDE 示例依赖配套 .fig，迁移版本需核实 GUIDE 运行支持，模板不用 GUIDE。

registerevent 配对 unregisterevent/释放控件，不让 global COM 引用遗留。Tutorial/example.m 显式 EnableConnect=true、ConnectPort=5001，是可选 TCP 服务，不是 COM 必需；不要为普通桌面自动化打开监听端口。本 Skill 不自动注册 WSC/ActiveX，不改注册表。

## MATLAB 插件回调

来源：Extend/PluginScripts 全部 25 个 .m；Extend 的 Constraints、Gator.EngineModels、Gator.AttitudeControllers、Hpop.ForceModels 和 Gator.Search 四个优化器 .m。

- register 分支定义 ArgumentName/Name/ArgumentType，compute 分支读取 input.methodData 并填全部输出；输出顺序/字段是调用协议，必须保持。
- 回调常固定使用 m、rad、Hz、线性损耗或 dB，逐参数查接口，不服从普通 OM UnitPreferences。
- Beamformer 权重按 real/imag 交错布局；数组长度与 NumberOfElements/NumDirections 一致。零方向时也初始化输出。
- 不把测试常数模型视作真实物理模型。Gaussian/PhasedArray 注册项存在同名输入输出变量重复，移植时按真实插件契约核对。
- DynamicDemodulator 的 char 用 == 会导致不等长字符串问题，使用 strcmp；BeamDirectionProvider 中方位步长重复加两次，多波束扫描的边界判断需复核。
- HPOP 示例 acos 前检查零模长，并将浮点内积比值夹到 [-1,1]。
- WSC 桥接通过 Matlab.Application、PutWorkspaceData/Feval 调用 MATLAB；与 MATLAB 主动连接 STK 方向不同。启用 MATLAB AutomationServer 仅在任务需要时进行，注意插件 Free 生命周期。
- fmincon/fminunc 需要 Optimization Toolbox；Controls/Results 是 STK 0 基集合，缩放乘子不可为零，检查求解 exitflag，再验证最终 Evaluate。
- 回调/优化过程避免大量 base/global 写入、GUI 弹窗和每步重连接；按任务明确隔离状态，不承诺硬实时能力。
