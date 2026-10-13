# 连接与会话模块

触发：MATLAB/STK 互联、COM/ActiveX、actxserver、actxGetRunningServer、单位恢复或断开。输入：主版本 11/12、attach/auto/new 意图；输出：root、app、session 和实际 STK 版本。基础模板见 scripts/stk_connect.m、stk_disconnect.m、stk_units.m。

## 流程

1. Windows 桌面 COM：`actxGetRunningServer('STK12.Application')` 或 `actxserver` → `app.Personality2`。attach 仅附加；auto 仅在附加失败后创建；new 为独立实例。ProgID 只区分主版本，GetSTKVersion 再确认 11.6/12.1。
2. CurrentScenario 前检查 root.Children.Count。获取/许可失败保留原异常；不能在同一个宽泛 catch 中又建应用、又关场景。
3. 每个操作保存/恢复改变的 OM 维度，`guard=stk_units(root,{'DateFormat','Distance'},{'EpSec','km'})`；保留 guard 至操作结束。Connect Units_Set/SetUnits 是另一套状态，附加实例应查询并恢复，本模块 guard 不管理 Connect。
4. 先释放 Provider/Access/子对象引用，再 release root/app。关闭场景、退出应用与 release 不等价。stk_disconnect 默认只释放；quitOwned=true 还要求 OwnsApplication=true。仅退出自己新建且允许丢弃未保存内容的实例。

自有实例退出模板设置 DisplayAlerts=false、UserControl=false，关闭自有场景后 Quit；不把此设置施加给附加实例。失败时报告，不通过杀进程作为常规断开。

## 入口边界与故障

- Engine：STKX12.Application / AgStkObjects12.AgStkObjectRoot；嵌入式 VOControl/2DControl 依赖宿主控件，无桌面 Personality2/UserControl 假设。
- 反向插件：STK 经 Matlab.Application、PutWorkspaceData/Feval 调 MATLAB，要求插件桥和相应注册；不属于普通桌面 COM 连接模板。
- TCP stkOpen/stkExec/stkClose、SOLIS .NET、TETK 扩展需各自依赖，不因 COM 任务自动启用它们。
- 无效类字符串/未注册：核对实际 STK 主版本、COM 注册与本地产品安装；不自动改注册表。服务器异常：核实旧场景句柄、许可、参数签名与原异常。

共享模型与 0 基集合见 [com-object-model](../com-object-model.md)，错误细分见 [troubleshooting](../troubleshooting.md)。官方案例多只附加 STK12，没有对称 release；原例的 root.Isolate() 不能替代独立 STK 实例或场景隔离。
