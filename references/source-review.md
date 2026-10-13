# 源代码阅读范围与共性归纳

阅读日期：2026-10-13（Asia/Hong_Kong）。来源为创建者本地 MATLAB–STK 示例工程。两处目录所有 **65 个 MATLAB .m 源文件**已逐文件审阅：Example 20 个；CodeSamples 45 个。本页保留首批65个文件的审阅记录；本次追加的105个.m和2个.mlx见 [官方教程审阅](tutorial-review.md)。汇总完整路径、行数、字节数、功能模块和 SHA-256 见 [source-inventory.csv](source-inventory.csv)。插件重复的纯注释/空行在部分阅读输出中省略，所有可执行代码均检查；单位和协议相关注释另核实。未把 3000 多个非 MATLAB 项目文件冒称为通读；.fig/.mat 为二进制，场景/星历文件仅用于确认示例资源，不作为 MATLAB 代码执行。

## 按文件组归类

| 文件组 | 数量 | 提炼 |
|---|---:|---|
| Example/*.m | 20 | StartSTK；场景建/载/存；CreateSat/Fac/Area/Missile；AddSensor；PropSat；姿态/约束；RV/覆盖取数；4 个调用示例 |
| CodeSamples/Automation/Matlab/*.m | 8 | STK_Automation_Tutorial、AnalysisWorkbench_ObjectModel、Astrogator_ObjectModel、Coverage_ObjectModel、Comm_ConnectCommands、LifetimeTool、两份 Aviator |
| CodeSamples/CustomApplications/Matlab/**/*.m | 4 | 两份 ObjectModel、Tutorial/example、事件回调；STK Engine/控件及可选 5001 服务 |
| CodeSamples/Extend/PluginScripts/*.m | 25 | 收发机、雨损/吸收、约束、VGT、力模型、调制/滤波、波束与雷达回调 |
| Extend/Constraints、Gator.EngineModels、Gator.AttitudeControllers、Hpop.ForceModels 的 WSC/*.m | 4 | STK→MATLAB 回调计算：距离、推力、角度、姿态 |
| Extend/Gator.Search/MATLAB fmincon Optimizer/*.m | 4 | Optimize、MatlabSearch、MatlabSearchNONLCON、UpdateIter |

另外核对 MATLAB 桥接 Readme 和 JS/VBS/WSC 相关接口段；CSharp 样例用于交叉核实 UnitPreferences 和 OrbitEpoch，不扩充为“全部 CSharp 已审阅”。

## 共性模式

1. 连接：actxGetRunningServer → 附加失败时 actxserver（相同 ProgID）→ Personality2。Engine 与反向 Matlab.Application 桥接不同。
2. 获取：CurrentScenario.Children.New / Contains / Item；GetObjectFromPath；子对象通过 Children，COM Item 通常 0 基。
3. 配置：先选传播器/Pattern/Pointing 类型，重新取该类型接口，再配置、Assign 并计算。
4. 单位：UnitPreferences 设置 OM；SetUnits 设置 Connect；插件/SetValue/Aviator 有专用单位。EpSec 用于数值处理、UTCG 用于日期命令。
5. 计算：Propagate / ComputeAccess / ComputeAccesses / RunMCS，不因对象创建就认为已算完。
6. 取数：Provider/Group → 合适 Exec → DataSets/GetValues；数值 cell2mat，文本不强转；Intervals 保留多窗口。
7. 生命周期：桌面可交给用户；释放 COM 引用、关闭场景、退出应用是不同操作，回调和 global 也需要清理。

## 实证缺陷与修正决策

| 来源 | 问题 | Skill 的处理 |
|---|---|---|
| Example/StartSTK.m；Example_1.m | StartSTK(12) 将数字拼成字符；catch 硬编码 STK12 | 支持 numeric/char 主版本；同一 ProgID，严格白名单 |
| Example/CreateSce.m、LoadSce.m | 任意异常都会 CloseScenario，可能丢未保存工作 | 创建/加载前检查状态，不把关闭当作错误恢复 |
| Example/Example_2.m、Example_3.m + PropSat.m | 裸 OrbitData 位置参数被忽略；Example_3 后续正确名值对才生效 | 原函数要用 'OrbitData',OrbitData；新模板显式 kep struct |
| Example/Example_2.m + AddSensor.m | AddSensor 实际仅 3 参数，调用多给 'type',2 | 分离创建和 AdjustSensor 配置 |
| Example/GetObjRV.m、ReadCoverageData.m | 切 EpSec 未恢复；ReadCoverageData 每列重复 Exec、全部 cell2mat | onCleanup；一次 Exec；文本/数值分流、多区间 |
| Example/CreateSat.m | step/DyModel 等参数被解析但不用于传播 | 新模板明确 J2 与 step，其他传播器另适配 |
| Example/CreateArea.m、CreateMissile.m | Area 的 H 未用，Missile varargin 未用 | 不宣传这些参数有效 |
| Example/AddSensor.m | 以 ClassType(2:end) 拼路径依赖 enum 文本且丢嵌套层级 | 使用完整父路径或子集合句柄 |
| Example/AdjustSensor.m | 已有约束分支未重新开启 EnableMin/EnableMax；注释把全部约束单位写 km | 按约束维度并显式检查开关 |
| Example/Example_4.m | 外部文件路径指向根目录，实际样例在 Example | fullfile + exist |
| Example/SaveSce.m | 调用端注记“有bug”，仅静态阅读不能断言根因 | 不声称已修复；先核实路径/许可/SaveScenarioAs，保留异常 |
| Coverage_ObjectModel.m | 31 Jun 非法日期；contours max=min 会零步长 | 合法日历检查、专门处理退化区间 |
| Comm_ConnectCommands.m | 场景 2013 与卫星传播 2007 不重叠 | 所有分析时间与星历一致 |
| Astrogator_ObjectModel.m | DV2 设置误用 impulsive=dv1.Maneuver | 指向 dv2，避免复制句柄串段 |
| STK_Automation_Tutorial.m | 多窗口数组传 Exec、无条件首窗口、num(1,1) 混用 | 标量区间遍历与空 Access 处理 |
| Aviator FuelConsumptionStudy | 删除同名共享飞机模型并写跑道目录 | 唯一名称，按任务明确授权共享目录修改 |
| LifetimeTool.m | 固定 token 位置解析，str2num 有求值语义 | 格式核对 + str2double |
| PluginScripts/Matlab_DynamicDemodulator.m | char 用 == 比较不同长度调制名 | strcmp |
| PluginScripts/Matlab_BeamDirectionProvider.m | 同一方位步长连续加两次 | 审核扫描逻辑；不移植为稳定模板 |
| PluginScripts/Gaussian/PhasedArrayAntGain | 同名 AntennaCoordSystem 输入输出变量覆盖/重复 | 按真实插件契约核实 |
| Hpop WSC/example1Hpop.m | acos 缺零向量/浮点越界保护 | 零模长检查及 [-1,1] 夹限 |

## 证据边界

核心 COM/单位/Provider 模式来自源例；所有权、防覆盖、输入校验、CSV 文本保护是本次新增工程约束。GetSTKVersion、报告 Connect 语法、GetCurrentUnitAbbrv、初始 OrbitEpoch 等还通过本地安装文档/接口验证。stk.TransferData 在汇总172个源码/Live Script代码中仍无实例，不编造签名。Simulink、实时、SOLIS/TETK和Monte Carlo 已由新增官方案例补充静态来源，按功能模块收录；没有因此声明这些高级流程运行通过。
