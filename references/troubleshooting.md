# 易错点与诊断

优先保留原始异常 identifier/message、实际版本、ProgID、对象路径、命令（去掉敏感路径）、单位与时间。一次失败不自动关闭场景、删除对象、换版本或换坐标系。

| 症状 | 核查和处理 |
|---|---|
| Invalid ProgID / server creation failed | 必须 Windows；检查 STK 主版本注册及安装；11/12 显式选择；数字先转 char；不盲目 regsvr32 |
| 附加失败 | 可能未运行、ROT 注册、不同 Windows 用户/权限或多实例；仅按模式决定是否新建 |
| 连接成功但 Personality2/方法失败 | 单独检查桌面/Engine 入口、实际类型库、许可；不把所有错误当作“未启动” |
| Type mismatch / Invalid enum | string 转 char；枚举核实拼写；索引需要时转 int32；方法通过 invoke 查询 |
| 已存在对象 / 已打开场景 | 检查 Children.Count/Contains；复用与改配置分别确认；不借 catch 无条件 CloseScenario |
| 轨道数量级错 / 传播失败 | OM 与 Connect 单位分别检查；m/km；a 是半长轴；e 范围；历元、初始状态与坐标系 |
| 时间格式错 / 空数据 | DateFormat、UTC、Epoch；英语月份和合法日历日期；分析与星历时间是否重叠 |
| Provider not found / Exec 参数错误 | 先核实对象上的 Provider、Group、类型和列名；固定/区间/时间变化签名不同 |
| cell2mat 错 / 文本挤在一行 | 文本保留 cell；列向量化；字段名去空格不保证合法/唯一 |
| 无 Access | 正常业务结果；检查几何、遮挡、指向/视场、约束及时间覆盖；不能自动去掉约束 |
| 断开后 STK 退出 / 残留 | 会话拥有关系、UserControl、子句柄、回调；release 与 Quit 分开；不杀进程 |
| 许可错误 | Astrogator/Aviator/Coverage/通信模块先核实安装版许可；不自动用简化模型替代 |
| 文件错误 | fullfile + exist；使用给定目录；.e/.a/.sp 格式头/单位/参考系；不吞异常再覆盖原文件 |

## stk.TransferData 与 Connector

65 个本地 .m 中没有 stk.TransferData、stkOpen/stkExec/stkClose 调用。stk.TransferData 在本 Skill 中只是检索/触发入口，**不声称它属于 STK 桌面 COM API，也不提供猜测签名**。

若任务明确要使用：先确认 stk 变量/包来源，查看 whos('stk')、which('stk.TransferData','-all')（若是对象方法再 methods/class/help），按实际类型和文档确定是自定义包装、MATLAB Connector 或其他接口；需要时读取本地函数定义。COM 句柄、TCP connectionID 和自定义对象不能互换。未找到定义时向用户请求最小接口信息，同时可以完成独立的 COM 方案。

## 原例中的高优先级缺陷

实证位置见 source-review.md。不能照搬数字 StartSTK(12)、连接 fallback 硬编码、CreateSce/LoadSce 宽泛 catch 关闭场景、未恢复 DateFormat、PropSat 漏传 OrbitData、AddSensor 多传参数、覆盖例 31 Jun、DV2 误用 dv1。模板明确处理连接所有权、创建防覆盖、单位恢复、报告全部区间与字段类型。

若独立测试卡在 Quit，核实 DisplayAlerts 与交互提示。仅在会话拥有且明确退出时关闭提示；不自动终止用户进程。MATLAB onCleanup 不能访问函数退出后无效的嵌套共享变量，使用捕获 root/app/session 的匿名回调与普通子函数。
