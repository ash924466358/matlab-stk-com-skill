# 场景管理模块

触发：创建/载入/保存场景、修改时间、ScenarioEpoch、默认目录。输入：场景名或 .sc 完整路径、是否允许修改现有场景、UTCG 开始/结束/历元；输出：场景句柄及记录的时间设置。基础模板：stk_create_scenario。

## 新建、获取、载入、保存

- 空应用：root.NewScenario(name) → root.CurrentScenario；已有场景：直接获取。New/Load 报错不意味着应该 CloseScenario。目标是全新场景且当前实例有内容时，优先 new 独立实例。
- 载入：核实 .sc 和配套资源存在，再 `root.LoadScenario(char(fullPath))`。已有场景需按任务保存或明确关闭；加载后重新获取所有对象、Provider、Access 和 VGT 句柄。
- 时间：在 UTCG 单位下 `sc.SetTimePeriod(startUTCG,stopUTCG)`；若任务要求同零点，用 `sc.AnalysisEpoch.SetExplicitTime(epochUTCG)`。分析 Epoch、轨道初始 Epoch、传播区间、动画起点是独立属性。
- 保存：参考本机 `root.SaveScenarioAs(fullPath)` / `root.SaveScenario` 接口；给定新目录/文件名，先检查目标是否存在及外部文件依赖。CreateSce/LoadSce/SaveSce 原例的路径与异常处理不是可靠的覆盖策略。
- GetDirectory / STKHome 获取安装目录；GetDirectory / Scenario 获取场景目录。未保存新场景可能没有可用场景目录，此时使用调用者指定位置。SetDefaultDir 影响后续输出，复用会话中不能随意改变它。

## 时间规则与验收

`ConversionUtility.ConvertDate('UTCG','EpSec',utc)` 与反向转换用于校验。EpSec 零点为场景 Epoch，StartTime 若为 600，分析必须用 [600,StopTime]，不能以 StopTime-StartTime 代替绝对终点。普通 UTC 任务不用 LCLG/now；实时案例若选当地时钟，明确 LCLG 与时区，保持 OM/Connect 一致。

验收：开始<结束，历元转换结果符合预期，所有对象星历与分析区间有交集；保存后路径及依赖存在。场景时间改变后重新传播并计算相关分析，Rewind 只复位动画。

来源：Example/CreateSce.m、LoadSce.m、SaveSce.m；官方 ObjectModelTutorial、PNT_and_Object_Coverage_Automation、TETK 与实时初始化案例。TETK_SatisfactionIntervalsExample 会递归删除输出目录，不能复用该行为。动画设置见 [animation-control](animation-control.md)。
