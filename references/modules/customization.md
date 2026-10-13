# 自定义设置模块

触发：Analysis Workbench/VGT、姿态调度、约束、颜色、VO 向量与模型、事件回调、MATLAB 插件。输入：完整目标路径、组件名/类型、参考系/依赖、物理参数及许可；输出：可求值组件、有效配置与恢复记录。

## AWB / VGT

对象.Vgt 和 CentralBodies.Earth.Vgt 为组件提供者。Vectors/Points/Axes/Systems/Planes/Angles、CalcScalars、Conditions、Events、EventIntervals、EventIntervalLists、EventArrays 各有集合/Factory。按依赖创建：point/vector → axes/system/angle → scalar → condition → event/interval。

- DisplacementVector 指明起点/终点；FixedInAxes 指明参考轴；FixedInSystem 指明系统；AlignedAndConstrained 的向量与 body 方向不可平行/零长度。
- DataElement scalar 选择实际 Provider/Group/Element，NewQuantity 显式阈值维度与单位；某些 SetThresholdsAndLabels 固定米，不能用 OM mi 代替。
- Fixed interval list 用成对 start/stop；Merged AND/MINUS、TimeOffset、StartStopTimes 描述窗口组合。FindOccurrence/FindIntervals/QuickEvaluate 的结果先检查有效性，不读无效 Value/Epoch。
- 同名时 Contains→核实类型和修改意图；不把任意 Create 异常当成“已存在”。输出/导入 .awb 按组件类型分目录并保留依赖顺序。

## 姿态与约束

Basic.SetProfileType、AlignedVector/ConstrainedVector、TargetPointing、External、RealTime 是不同模式。Scheduled vector 以 Interval List 决定 OnSchedule/OffSchedule，并设置 SlewWindowDuration/Timing/MinOffSchedule；按先参考矢量与窗口，再绑定 Attitude 的顺序。

多段姿态用 SetAttitude/AddAttitude/AttitudeSegment；阶段名、起点、序列和参考系明确且按时间排序。已有姿态数据先记录/导出，再做授权替换；multiSegmentAttitude 原例 ClearData AllProfiles 会影响全对象。不能用静态 Euler 裁剪自动保证连续性或角速度约束。

AccessConstraints.IsConstraintActive → GetActiveConstraint 或 AddConstraint → EnableMin/Max 与范围；动态 mask 临时约束退出后恢复原状态/原 mask，不无条件 RemoveConstraint。不同约束维度不同。

q1,q2,q3,q4 的标量位置、主动/被动旋转、body→reference 方向分别确认。getDCM 原例把 q1 当标量，不能直接复用；用单位姿态与已知90°旋转检验矩阵、逆变换和角速度。

## 颜色、图形与事件

OLE 颜色数值 `R + 256*G + 65536*B`（R/G/B 各 0..255）。Connect #RRGGBB 要转换/补齐6位，不用十进制255255255表示白色（正确OLE白为16777215）。Graphics/VO RefCrdns 显示引用独立于 VGT 数据定义；视觉线段不自动产生 Access。

模型路径从 STKHome 获取再核实；对象 .dae/.mdl 的 articulation 节点和比例由模型决定。Registerevent 配对 unregisterevent；callback 保留会话句柄，避免每次重连接或大量 base/global 写入。STK 场景卸载后旧引用失效。

## MATLAB 插件

register 分支定义参数名、顺序、维度、方向；compute 分支读 input.methodData 并填全部输出。插件常用 SI、Hz/rad/线性损耗或 dB，逐接口检查。Optimization Toolbox、WSC 桥、Matlab.Application 等依赖仅在任务需要时启用；不自动注册组件/监听端口。

共有错误：同名输入输出覆盖、char用==、零向量/acos越界、Beamformer real/imag交错数组尺寸、未初始化零方向输出。源例是演示模型，不把常数响应作为真实设备模型。

图形与窗口清理见 [animation-control](animation-control.md)，更多插件协议见 [advanced-scenarios](../advanced-scenarios.md)，原例缺陷见 [tutorial-review](../tutorial-review.md)。
