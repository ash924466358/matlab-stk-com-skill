# 官方 MATLAB 案例功能索引

范围：STK官方教程/Matlab 的 105 个 .m + 2 个 .mlx。路径相对仓库根目录；源码不随 Skill 复制分发。全部为静态审阅，未直接执行原教程。模块交叉列出主路线与相关功能，允许按任务组合。

纯图像/GUI辅助归数据输出后处理，不因普通图像任务触发整个COM工作流。MLX代码从ZIP内matlab/document.xml的WordprocessingML代码段提取，含CDATA；不把空提取结果当已阅读。哈希和行数见 [来源清单](source-inventory.csv)。

## 连接与会话

读取 [功能模块](modules/connection.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| General_Utilities/StkHelp.m | 本地接口帮助；主版本/路径需核实 |

## 场景管理

读取 [功能模块](modules/scenario-management.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| Scenario_Building/ObjectModelTutorial.m | 基础New/SetState/Provider/Access；漏列/重复首区间/Alt索引 |

## 对象创建与配置

读取 [功能模块](modules/object-management.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| General_Utilities/convertTleState.m | SGP4初始状态转ICRF再切传播器；恢复单位、保留原异常 |
| General_Utilities/filterObjectsByType.m | 对象路径枚举；避免固定ObjectNames.xml覆盖 |
| General_Utilities/getAllObjectHandles.m | 对象集合遍历；不复用eval变量注入 |
| Problem_Specific/High_Altitude_Balloon.m | 随机GreatArc气球路线；ft/knots换算、rng |
| Problem_Specific/sensorPointingAndAER.m | Aircraft目标Sensor与分区间AER；空结果/全部区间 |
| Scenario_Building/FigureEight.m | GreatArc八字路线；已有Waypoints替换范围 |
| Scenario_Building/MissilePropagation.m | 弹道Launch/Impact配置与Ground Range Provider |

## 分析功能创建

读取 [功能模块](modules/analysis-functions.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| General_Utilities/FilterSegmentsByType.m | 递归MCS段类型过滤；核实嵌套TargetSequence |
| General_Utilities/FOMDataPrv.m | FOM Provider取数；按实际接口类型/单位 |
| Problem_Specific/advcatTradeStudy.m | 轨道扫描与AdvCAT事件；恢复原状态、事件计数 |
| Problem_Specific/coverageAccumPercent.m | 区域累计覆盖阈值；只筛指标列、空/未达标区分 |
| Problem_Specific/DebrisModel.m | 复制碎片Astrogator与随机机动；禁止默认卸载已有对象 |
| Problem_Specific/DynamicSensorMask/DynamicSensorBodyMaskAnalysis.m | 分时.bmsk/Access/Timeline/ObjectLine；恢复原约束/窗口 |
| Problem_Specific/DynamicSensorMask/GetSensorAzElMask.m | VO AzElMaskTool生成.bmsk；完整路径/时间/固定分辨率 |
| Problem_Specific/DynamicSensorMask/SetSensorAzElMask.m | 加载.bmsk；文件存在与当前约束状态 |
| Problem_Specific/LambertSolver_EarthToMars.m | ComponentBrowser设计工具；版本/许可/结果解析 |
| Problem_Specific/LinkBudgetLLA/LinkBudgetLatLonChain.m | 链路预算Excel与动画；按时间对齐、Eb/No哨兵 |
| Problem_Specific/SatelliteMonteCarlo.m | 轨道扰动相对运动；rng、合法e/i/单位与工具箱 |
| Problem_Specific/sensorPointingAndAER.m | Aircraft目标Sensor与分区间AER；空结果/全部区间 |
| Problem_Specific/TLE_Deorbit_Estimation.m | TLE采样→Astrogator离轨；在线依赖/物理外推假设 |
| Scenario_Analysis/accessAtEveryCoveragePoint.m | 移动Facility与C/N网格扫描；每次重算Access并恢复 |
| Scenario_Analysis/AccessByMetric.m | 最优AER指标转窗口；变量拼写/时间索引/多区间错误 |
| Scenario_Analysis/astgCheckPassiveSafety.m | 机动后被动安全；按字段取数、空机动及输出初始化 |
| Scenario_Analysis/automateLifetimeTool.m | 寿命参数扫描；硬编码卫星名/fclose与原参数恢复 |
| Scenario_Analysis/coverageDurationPerDay.m | 按日Access统计；不足一天/空日/窗口重叠 |
| Scenario_Analysis/CoverageGridInspectorAutomate.m | 逐网格Inspector取Coverage/FOM；选点/空结果状态 |
| Scenario_Building/AstrogatorAPI_Training/AstrogatorAPI_LEOtoGEO.m | 培训待填代码；propSeg1/dV2缺失，不直接执行 |
| Scenario_Building/AstrogatorAPI_Training/AstrogatorAPI_LEOtoGEO_Complete.m | 瞄准序列与差分修正；Complete仍误取dV1姿态句柄 |
| Scenario_Building/Aviator_ObjectModel_CarrierLanding.m | Carrier/两机飞行任务；目录/ft/nm/固定SI核对 |
| Scenario_Building/chainAutomationExample.m | Walker编组与Chain；AER字段不按固定列数推断 |
| Scenario_Building/Coverage_FOM_GridInspector_CodeHelp.m | RevisitTime FOM与Inspector；空结果GetRow保护 |
| Scenario_Building/PNT_and_Object_Coverage_Automation.m | Pseudolite/Chain/GDOP/GACC；许可/地形网络/不确定性 |

## 动画控制

读取 [功能模块](modules/animation-control.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| General_Utilities/persistentAccessLines.m | Access的MTO/VO连线；批图恢复、CBF米单位 |
| Problem_Specific/DynamicSensorMask/DynamicSensorBodyMaskAnalysis.m | 分时.bmsk/Access/Timeline/ObjectLine；恢复原约束/窗口 |
| Problem_Specific/DynamicSensorMask/GetSensorAzElMask.m | VO AzElMaskTool生成.bmsk；完整路径/时间/固定分辨率 |
| Problem_Specific/DynamicSensorMask/SetSensorAzElMask.m | 加载.bmsk；文件存在与当前约束状态 |
| Scenario_Analysis/addArrowsAlongPath.m | AWB距离阈值与VO箭头；米/mi、不Delete All |
| Scenario_Building/ObjectLines.m | 历元偏移卫星连线与动画；颜色顺序/同名/原配置 |

## 数据输出

读取 [功能模块](modules/data-output.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| General_Utilities/Clutter Simulator/create_clutter_map.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/create_satellite_train_layer.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/create_star_info.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/create_star_map.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/draw_antialias_line.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/generate_2d_gaussian_psf.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/mouse_figure.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/SSA_Clutter_Interference_Visualizer.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/Clutter Simulator/trim_or_pad.m | 纯MATLAB图像/GUI辅助；.fig依赖，输入求值/归一化/图像范围边界 |
| General_Utilities/createCommSystemPointingIntervals.m | 通信对象切换转.int；末窗口/空结果/时间步长/fclose |
| General_Utilities/createEphemerisFile.m | 导出自定义系星历；修正Epoch、点数与DistanceUnit |
| General_Utilities/generateSensorPointingFile.m | 指向四元数.sp；头尾标记及区间接口需修正 |
| General_Utilities/Normalize_EOIR_Images/create_normalized_frame_sequence.m | EOIR数值图像后处理；目录筛选、常量范围/非整数上采样索引 |
| General_Utilities/Normalize_EOIR_Images/save_colormapped_image.m | EOIR数值图像后处理；目录筛选、常量范围/非整数上采样索引 |
| General_Utilities/pullDataProvider.m | 按Provider类型Exec；PreData/UI、空元素与单位恢复 |
| General_Utilities/vgtImporterExporter.m | AWB组件导入导出；按类型避名冲突并保依赖 |
| Problem_Specific/AST_output_Acceleration_Data.m | 推力/质量导出.accelhist；时间零点、质量>0与单位 |
| Problem_Specific/ConstrainSatelliteAttitude.m | 指向约束与YPR裁剪写.a；不关现有场景/固定路径 |
| Problem_Specific/EOIRTextureMaps/H5TexMap.mlx | VIIRS HDF5纹理CSV；fill/转置/比例/辐亮度仅限该产品 |
| Problem_Specific/EOIRTextureMaps/HDF4TexMap.mlx | MODIS HDF4 LST纹理CSV；命名元数据/0.02温度比例 |
| Problem_Specific/satStepWiseTracking.m | Constellation姿态采样保持；禁止固定行号/字符解析 |
| Problem_Specific/sensorPointingAndAER.m | Aircraft目标Sensor与分区间AER；空结果/全部区间 |
| Scenario_Analysis/getEOIRSensorLLA.m | EOIR像素射线→地表或平面交点；平面回退需标记非地表 |
| Scenario_Analysis/quiverPlotRelativeGroundVelocity.m | 固定Provider PreData时刻FOM→quiver；坐标和速度单位 |
| Scenario_Analysis/regroupByAsset.m | 读取.cvaa合并资产窗口→.int；文件格式/日期和末区间 |
| Scenario_Analysis/valueByGridPointAtTime.m | 时序FOM与分位数→Excel；步长/0分位索引/列名 |

## 数据导入

读取 [功能模块](modules/data-import.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| General_Utilities/pushSat2STK.m | 星历/姿态导入；覆盖参数、char比较及固定文件头问题 |
| General_Utilities/vgtImporterExporter.m | AWB组件导入导出；按类型避名冲突并保依赖 |
| Problem_Specific/AccumulatedPower_CreateUserSuppliedData.m | ExternalData累计数据；功率/能量/dt、空窗口及误Unload |
| Problem_Specific/ConstrainSatelliteAttitude.m | 指向约束与YPR裁剪写.a；不关现有场景/固定路径 |
| Problem_Specific/ConvertAERtoLLA/ConvertAERtoLLA.m | 站体AER→地理坐标→Aircraft Waypoints；恢复批图/单位 |
| Problem_Specific/Create3DCoverageFromAreaTarget.m | 区域网格分层.pnt；Levels/点数/单位及12.8假设 |
| Problem_Specific/DynamicSensorMask/DynamicSensorBodyMaskAnalysis.m | 分时.bmsk/Access/Timeline/ObjectLine；恢复原约束/窗口 |
| Problem_Specific/DynamicSensorMask/GetSensorAzElMask.m | VO AzElMaskTool生成.bmsk；完整路径/时间/固定分辨率 |
| Problem_Specific/DynamicSensorMask/SetSensorAzElMask.m | 加载.bmsk；文件存在与当前约束状态 |
| Problem_Specific/EOIRTextureMaps/H5TexMap.mlx | VIIRS HDF5纹理CSV；fill/转置/比例/辐亮度仅限该产品 |
| Problem_Specific/EOIRTextureMaps/HDF4TexMap.mlx | MODIS HDF4 LST纹理CSV；命名元数据/0.02温度比例 |
| Problem_Specific/satStepWiseTracking.m | Constellation姿态采样保持；禁止固定行号/字符解析 |
| Scenario_Building/FigureEightCircle.m | 生成LLA.e再External route；Epoch缺失与点数/单位 |
| Scenario_Building/ImportAreaTarget/ImportAreaTarget.m | CSV LAT/LON区域；批量更新异常恢复 |
| Scenario_Building/ImportFacilities/ImportFacilities.m | CSV ID/LAT/LON/ALT(m)；不默认删同名站 |

## 自定义设置

读取 [功能模块](modules/customization.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| General_Utilities/getDCM.m | 四元数转DCM；q1作为标量与STK常用约定不一致 |
| General_Utilities/intervalListFromTimeArray.m | 事件时刻左右offset窗口；避免组件同名与误删 |
| General_Utilities/makeEllipticalSensor.m | 生成.pattern；半角、模360与路径/输入校验 |
| General_Utilities/persistentAccessLines.m | Access的MTO/VO连线；批图恢复、CBF米单位 |
| General_Utilities/printRootEvents.m | root事件订阅/回调；退出配对取消订阅 |
| General_Utilities/rgb2StkColor.m | RGB转OLE颜色 R+256G+65536B |
| General_Utilities/vgtImporterExporter.m | AWB组件导入导出；按类型避名冲突并保依赖 |
| Problem_Specific/AttitudeUsingAScheduledVector.m | 纬度条件→Scheduled vector→姿态；组件冲突/非退化轴 |
| Problem_Specific/ChangeSTMComponents.m | Astrogator STM自定义Mars坐标系；克隆名称及单位 |
| Problem_Specific/ClosestGrazingAngle.m | Grazing点/矢量/二面角及VO显示；父路径/向量退化 |
| Problem_Specific/ConstrainSatelliteAttitude.m | 指向约束与YPR裁剪写.a；不关现有场景/固定路径 |
| Problem_Specific/DynamicSensorMask/DynamicSensorBodyMaskAnalysis.m | 分时.bmsk/Access/Timeline/ObjectLine；恢复原约束/窗口 |
| Problem_Specific/DynamicSensorMask/GetSensorAzElMask.m | VO AzElMaskTool生成.bmsk；完整路径/时间/固定分辨率 |
| Problem_Specific/DynamicSensorMask/SetSensorAzElMask.m | 加载.bmsk；文件存在与当前约束状态 |
| Problem_Specific/multiSegmentAttitude.m | 光照/Access窗口与slew调度；ClearData范围与边界 |
| Problem_Specific/satStepWiseTracking.m | Constellation姿态采样保持；禁止固定行号/字符解析 |
| Scenario_Analysis/addArrowsAlongPath.m | AWB距离阈值与VO箭头；米/mi、不Delete All |
| Scenario_Analysis/astgVisualizeDeltaVVectors.m | 机动DeltaV/位置自定义系与VO；数组布局/单位/恢复 |
| Scenario_Analysis/CreateGrazingAngle.m | NED方向→Grazing点/角/scalar；名称/角度符号 |
| Scenario_Building/Analysis_Workbench_Components.m | AWB矢量/轴/标量/事件族完整创建示例 |
| Scenario_Building/astgSlewToManeuvers.m | 推力阈值Scheduled vectors→姿态；许可/段遍历/轴退化 |
| Scenario_Building/makeEllipticalSensor.m | 生成.pattern；半角、模360与路径/输入校验 |
| Scenario_Building/MultiSegmentAttitude.m | Connect姿态文件/段/目标；时间单位/引用/清理范围 |
| Scenario_Building/MultiSegmentAttitudeLoop.m | 批量姿态类型参数组装；不用base隐式共享作模板 |
| Scenario_Building/ObjectLines.m | 历元偏移卫星连线与动画；颜色顺序/同名/原配置 |

## 实时与Simulink

读取 [功能模块](modules/realtime-simulink.md)。

| 源文件 | 用途 / 审阅要点 |
|---|---|
| Problem_Specific/SatelliteAttitudeControl/SatelliteAttitudeControl_sFunction.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SimulinkAccess/InitFcn_TestCode.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SimulinkAccess/STK_SatelliteAccess_sFunction.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SimulinkAttitudeControlLoop/InitCode.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SimulinkAttitudeControlLoop/SFunctionClosedLoop.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SimulinkAttitudeFile/SatelliteAttitudeControl_FullInitFunction.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SimulinkAttitudeFile/SatelliteAttitudeControl_InitFcn.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SimulinkAttitudeFile/SatelliteAttitudeControl_sFunction.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SolarEnergySimulink/InitFcn_TestCode.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/SolarEnergySimulink/stk_level2_mfile.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Problem_Specific/TETK_Automation_Tutorial.m | TE_*映射/TSPI/Track/Graph；专用许可及已知命名缺陷 |
| Problem_Specific/TETK_SatisfactionIntervalsExample.m | 测量阈值→飞行窗口；0/1/末样本且不递归删目录 |
| Scenario_Building/RealTimePropagation/realtimeAircraft.m | 实时墙钟位置姿态；不忽略源时间，文件同步/fclose |
| Scenario_Building/RealTimePropagation/realtimeMissileWithArticulations.m | 实时弹体与模型关节；节点/时间轴/流同步 |
| Scenario_Building/RealTimePropagation/realtimeSatellite.m | PointBuilder ECI与姿态；LCLG/距离/流同步 |
| Scenario_Building/RealTimePropagation/realtimeSatellite_MatlabClock.m | timer驱动COM；EOF、错误时stop/delete/fclose |
| Scenario_Building/SensorSweepSOLIS/Bearing.m | 球面初始方位角辅助；纬经度/极点边界 |
| Scenario_Building/SensorSweepSOLIS/GenerateScan.m | 区域扫描种子与Access裁剪；size维度/临时对象所有权 |
| Scenario_Building/SensorSweepSOLIS/SensorSweepSOLIS.m | 扫描、可选Aviator、seqs/tpc与SOLIS执行；米单位/XML/列表 |
| Scenario_Building/SensorSweepSOLIS/SOL_API_ConnectToRunningSTK.m | SOLIS .NET入口；无限重试/宽URL ACL提示不可照搬 |
| Scenario_Building/SimpleSimulinkExample/initFcn.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Scenario_Building/SimpleSimulinkExample/SimpleSTK_S_block.m | Simulink初始化/S-function；时间零点、采样/端口输出与COM所有权清理 |
| Scenario_Building/solisCreateSequenceFromAccess.m | Access→SOLIS .seq；size行数、目录/文件/空结果 |

