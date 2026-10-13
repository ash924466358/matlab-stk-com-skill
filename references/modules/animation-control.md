# 动画控制模块

触发：STK 播放、暂停、复位、显示时间、动画步长、相机/视角、Timeline、批量图形。输入：当前场景、UTCG/EpSec 时刻、动画模式、目标窗口与操作；输出：画面/当前时间状态。以下为源例提炼配方，未新增专用运行验收模板。

## 时间与播放

```matlab
root.Rewind;          % 回到场景动画起点
root.PlayForward;     % 向前播放
root.Pause;           % 暂停（以本机 OM 接口为准）
guard = stk_units(root,{'DateFormat'},{'EpSec'});
root.CurrentTime = 120; % 相对于场景 Epoch 的秒数
```

Connect 源例：`Animate * Reset`；`SetAnimation * TimeStep 0.01 EndTime "<UTCG>"`；`Animate * Start End`。占位符需用核实并校验过的实际时刻，Connect Date 单位独立设置。用 ConversionUtility 转 UTCG，不对返回字符串再 num2str。

Scenario.Animation.StartTime 与分析 StartTime 不同。AnimStepType 例子有 eScTimeStep/eScRealTime/eScXRealTime；选择与输入时钟一致的模式，属性/TimeStep 按本机文档核实。离线回放以数据时间驱动；实时墙钟不可与重放 EpSec 混用。播放不会替代 Propagate、ComputeAccess 或重新计算。

## 视角、图形、Timeline

- `VO * ViewFromTo Normal From Ship/CVN-72` / `VO * ViewerPosition ...` 是视角命令；Window3D * Maximize、Application / Raise 影响 UI。仅在任务需要演示界面时应用。
- 对象 Graphics 管理 2D/属性，VO 管理 3D 模型、轨迹、向量、ObjectLine/Annotation/Primitive。对象模型颜色为 OLE BGR，Connect #RRGGBB 不能直接用同一整数/hex。
- Timeline * CreateWindow、TimeComponent Add/Remove、Refresh 的窗口 ID 不总是 1；先枚举/确认目标窗口，不关闭用户 Timeline 以加速计算。
- 批量图形 `BatchGraphics * On` 后用 onCleanup 尝试 `BatchGraphics * Off`。BeginUpdate 后配对 EndUpdate；异常路径也恢复，否则场景可能停止刷新。复用会话时记录并恢复原状态。
- Primitive CBF/LLA 等接口有固定米的字段；不根据 OM Distance 自动推断。记录本次创建的 ID，后续只移除这些 ID；避免 `Primitive Delete ID All`。

验收：暂停后 CurrentTime 不再增长，指定时刻在有效区间内，复位回到预期起点；视角和图形变化仅作用于目标对象/窗口。原 DynamicSensorBodyMaskAnalysis 用 maskTimes(i) 的循环变量不匹配 epoch，且未恢复约束/窗口；改写时用当前 epoch 并恢复原设置。

实时驱动与 timer 清理见 [realtime-simulink](realtime-simulink.md)，颜色与矢量见 [customization](customization.md)。来源：ObjectLines、persistentAccessLines、LinkBudgetLatLonChain、Aviator CarrierLanding、RealTimePropagation、DynamicSensorMask。
