# 实时、Simulink 与专用扩展模块

触发：实时遥测/PointBuilder、实时姿态、MATLAB timer、Simulink S-function、TETK TSPI、SOLIS。输入：时钟契约、采样/更新周期、数据字段/单位、目标对象、依赖/许可和停止条件；输出：时间一致的状态与可清理会话。全部为本次静态提炼参考；未做这些专用模块运行验证。

## 实时输入

1. 卫星选 ePropagatorRealtime，配置 LookAheadPropagator、Duration.LookAhead/LookBehind 和 TimeStep；PointBuilder.ECI.Add 输入位置速度，实时 Attitude.AddQuaternion/AddEuler 输入姿态。Aircraft/Missile 原例通过 Realtime/SetPosition/AddAttitude Connect 路线。
2. 区分墙钟UTC/本地LCLG、记录文件时间、场景EpSec和root.CurrentTime。离线文件重放应保留记录时间，不能像原例忽略文件 EpSec 后贴 now。参考系 ECI/ECF 与输入数据定义一致。
3. 两个流按时间同步，检查 EOF、列数、有限数值、单调时间与四元数归一。LookAhead 是外推/保持策略，不能误报为收到真实新样本。
4. timer 记录所有权、停止条件和错误状态；stop/delete 本次 timer、fclose 文件、恢复播放/单位并 release。BusyMode='drop' 可能丢采样，不能宣称硬实时。

## Simulink

InitFcn 创建/附加一次会话、对象和 OnePointAccess，放入 block UserData 或受控会话结构；S-function Start 初始化状态，Outputs 输出、Update 更新离散状态，Terminate 做与所有权匹配的清理。COM 句柄不能当可序列化 SimState，也不适用于代码生成或默认并行 worker。

- `block.CurrentTime` 若为仿真秒，需明确零点与场景 Epoch 对应；使用 EpSec，角度 rad/deg与模型端口契约一致。
- OnePointAccess：StartTime=StopTime=t → Compute → AccessSatisfied，用于瞬时判定；不是全天窗口 ComputeAccess 的替代。
- SimulinkAccess 原例 Dwork 上一时刻输出；SatelliteAttitudeControl 原例在 t+2 取参考姿态，并在 lastTime 写当前角度。这些延迟是模型选择，必须明确是否期望。
- 确认端口维度/采样/DirectFeedthrough；SimpleSTK_S_block 声明输出口却未赋值，不能用作可运行模板。
- SatelliteAttitudeControl 两份 sFunction 字节相同；多块不能各自 Quit 同一应用。Terminate 中附加实例仅release；创建者在全部依赖停止后退出自有实例。
- 运行条件包括 Simulink、配套 .slx/.mdl/.sc；R2020b/R2023b 与 STK版本组合须独立验收。

## TETK

TE_Mapping 导入 .tedm → TE_AnalysisObject/AssociatedObject/AdditionalData 导入 TSPI/测量 → TE_SegmentDefinition 建窗口 → Track/Comparison/QuickLooks/Graph → Export。是插件 Connect 命令，需要对应 TETK 许可/版本，不把 TE_* 当标准 STK 核心命令。

映射列名、单位行、ISO-YD/UTCG 格式、Ownship和TimePath必须匹配实际对象。TETK_Automation 原例已注记 Track TimePath 命名错误；SatisfactionIntervals 需处理0/1条、最后采样及间隔断点，不靠字符串删除日期来转换时间。避免递归删除同名场景目录。

## SOLIS

SOL_API_ConnectToRunningSTK 读取 SolisExePath、加载 STKSolisLib.dll、创建 STKSolis.SolisConnect；这是 .NET/服务入口。版本v11、DLL路径、许可、satellite序列库须与实际安装匹配；连接失败有限重试后停止，不无限循环。

原例输出 netsh URL ACL 为所有人开放服务的管理员提示，**不能为普通COM任务自动执行**。先报告SOLIS专属依赖错误并按用户任务范围处理。生成 .seq/.seqs/.tpc 与实际执行 config.Run 是不同步骤。XML文本需要转义，LLA_deg_m 的高度必须是米；所有列表长度、扫描时长、slew时间和日期配置一致。

来源：官方 RealTimePropagation、SimpleSimulinkExample、SimulinkAccess、SimulinkAttitudeFile/ControlLoop、SolarEnergySimulink、SensorSweepSOLIS、TETK 两例。详见 [案例索引](../tutorial-case-index.md)。
