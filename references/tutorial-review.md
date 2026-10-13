# STK官方教程审阅与功能提炼

日期：2026-10-13（Asia/Hong_Kong）。新增目录 STK官方教程/Matlab 全部 **105个.m（14203行、567662字节）+ 2个.mlx（提取37行代码）**。与 Example 20个、CodeSamples 45个合计 **170个.m（22567行、896640字节）+2个.mlx**；二进制MLX字节数单独记录，不计入.m字节统计。

## 阅读证据与范围

完整可执行.m代码分20个块读取，部分纯注释/空行省略；单位/接口相关注释与缺口另读原文件。MLX为ZIP，代码在matlab/document.xml的WordprocessingML w:pStyle=code / w:t CDATA中：H5TexMap有3段18行，HDF4TexMap有5段19行。初次通用XML标签提取为空后已修正并读取全部段，未以空提取判定完成。

所有源码与模块归类见 [source-inventory.csv](source-inventory.csv)；各官方案例用途见 [tutorial-case-index.md](tutorial-case-index.md)。创建者本地阅读证据记录了来源哈希、阅读块、缺口及MLX提取信息；本仓库分发逐文件来源清单和审阅结论，原阅读缓存不公开。SatelliteAttitudeControl_sFunction 在 SatelliteAttitudeControl 与 SimulinkAttitudeFile 两处字节相同，保留两条路径、只分析一次同内容。新增目录与首批65文件无字节完全相同的.m。

未执行原教程；配套.fig/.mat/.slx/.mdl、场景/图形模型、DLL、GIS及遥测文件是依赖，不声明全量读取或运行。所有功能入口从本地源提炼，晚版API需在STK11.6/12.1本地帮助核实；原生文件格式头不等于安装产品版本。

## 新增共性与模块归属

- 场景与对象：仍遵循连接→CurrentScenario→Children/VGT集合→配置类型→传播/计算，但新增多处宽泛catch关闭场景或Unload同名对象，不能作为稳健初始化。
- 功能：Access/Chain、Coverage/GridInspector、ObjectCoverage GDOP/GACC、通信、AdvCAT、Astrogator、Lifetime、Aviator各有不同计算方法与许可。
- 动画：CurrentTime、Rewind、PlayForward、SetAnimation、Timeline、VO视角/Primitive；动画、分析和文件时间是不同状态。图形/批量更新必须成对恢复。
- 输出/导入：Provider Group/PreData、原生时刻批量取数、ExportTools、.e/.a/.sp/.int/.accelhist/.awb、ExternalData、Excel/GIS与HDF纹理；格式验证与回读是闭环。
- 自定义：AWB各组件Factory、Scheduled vector、条件/区间、姿态模式、约束、OLE颜色、注册事件；固定SI单位不能统一套OM偏好。
- 实时/扩展：PointBuilder/实时姿态、timer与S-function、TETK TE_*、SOLIS .NET/序列。依赖、时钟、所有权和停止条件独立记录。
- 纯MATLAB图像辅助：Clutter Simulator、Normalize_EOIR_Images、HDF纹理转换列入后处理，不把它们包装成普通COM调用。

## 源例问题与改写决策

| 源例 | 具体问题 / 移植前处理 |
|---|---|
| convertTleState | 宽泛catch掩盖传播/许可错误；保存恢复单位，明确SGP4状态采样历元与ICRF |
| createEphemerisFile | length代替行数；StartTime与EpSec零点不一致；DistanceUnit=km未先设置km |
| generateSensorPointingFile | BEGIN Attitude / END Ephemeris不匹配；区间API拼写与四元数约定核实 |
| pullDataProvider | Type分支、AllowUI和PreData行为；空elements组装与DateFormat恢复不完整 |
| getDCM | q1作为标量；核对STK标量最后、变换方向，并用已知旋转验算 |
| getAllObjectHandles / filterObjectsByType | eval注入对象名；固定ObjectNames.xml；改为容器和唯一临时路径 |
| pushSat2STK | 无条件重置调用者exportAttEphFiles、char时间比较、固定HeaderLines、默认改场景时间 |
| vgtImporterExporter | 跨类型同名文件冲突、依赖与导入顺序；按类型/名称组织 |
| intervalListFromTimeArray | 固定Time/TimeInterval名字及删除；仅管理任务组件 |
| createCommSystemPointingIntervals | 首末/空窗口、索引与时间步长混淆、缺fclose；按时间数据建窗口 |
| AccumulatedPower_CreateUserSuppliedData | 能量累计需乘实际dt；空Access/末索引；不得捕获任意异常后Unload原Chain/Constellation |
| AST_output_Acceleration_Data | StartTime与EpSec混用、datetime默认格式、质量<=0未赋值；明确单位和Epoch |
| DynamicSensorBodyMaskAnalysis | maskTimes(i)变量与epoch循环不匹配；移除原约束/关窗口后未恢复，空数组与res变量边界 |
| coverageAccumPercent | 对[time,percent]全矩阵find；未达标用0混同立即达到；仅指标列并区分未达标 |
| Create3DCoverageFromAreaTarget | Levels=1除零、固定12.8版本假设、单位/路径；估算网格规模并核实目标版格式 |
| LinkBudgetLatLonChain | 不按时间对齐直接裁短Provider数组、未设Required Eb/No导致-9999；位置扫描须恢复 |
| multiSegmentAttitude / satStepWiseTracking | 清全部姿态Profile、固定行/字符定位、空窗口和slew越界；解析文件格式并约束修改范围 |
| SatelliteMonteCarlo | 示例默认扰动单位和幅值不适合作物理设定；固定rng、合法轨道与异常恢复 |
| accessAtEveryCoveragePoint | 改Facility后需重算Access，不能只重算Coverage；结果字段/首样本与网格绑定需核实 |
| AccessByMetric | Time未定义、aerDP集合误用、Interval/Intervals混用、末窗口遗漏；行号不是EpSec |
| astgCheckPassiveSafety | 固定7列布局和空机动max索引；输出badManeuverTimes未总是初始化 |
| automateLifetimeTool | SatName参数与硬编码CrashAndBurn不一致、末文件未关闭；扫描恢复模型参数 |
| coverageDurationPerDay | round天数丢短时段、空日变量未初始化、窗口重叠重复累计 |
| valueByGridPointAtTime | 非整数linspace长度、0分位索引0、列名/NaN；时间网格和分位算法明确 |
| ObjectModelTutorial | DataSets.Count-1漏末列、Alt固定第1样本、Access反复读Item(0)；按列名/全部区间读取 |
| AstrogatorAPI_LEOtoGEO / Complete | 培训版缺propSeg1/dV2；Complete仍将dV2Att=dV1.Maneuver.AttitudeControl |
| FigureEight / GenerateScan / SensorSweepSOLIS | RemoveAll已有路线、复用并Unload临时名、for i=1:size(array)；只改任务对象并用size(array,1) |
| FigureEightCircle | .e点数length且无明确ScenarioEpoch；给定记录零点与完整格式 |
| ImportFacilities / ImportAreaTarget | 删同名站、单位未恢复、EndUpdate无异常兜底；先验证数据和冲突 |
| makeEllipticalSensor两版 | mod(...,361)而非360、input表达式求值；用数值验证和明确输出位置 |
| addArrowsAlongPath / persistentAccessLines | 固定米字段/mi换算、Primitive Delete All、批图缺异常恢复；记录创建ID与恢复单位 |
| ObjectLines / 姿态VO显示 | OLE颜色直接dec2hex顺序错误或255255255非白色；BGR与RGB显式转换/补齐 |
| getEOIRSensorLLA | 无地表交点时平面回退不是实际地面定位；区分有效地表/平面结果并标记 |
| RealTimePropagation | 忽略文件时间、两流未同步、未fclose，timer无EOF停止；明确时钟/流验证/清理 |
| SimulinkAccess / AttitudeControl | 上一Dwork时刻、t+2取参考/lastTime写姿态；延迟契约需确认，Terminate只退出自有会话 |
| SimpleSTK_S_block | 声明输出端口但无输出赋值；不能直接当完整S-function模板 |
| TETK_Automation | Track TimePath有原作者注明命名缺陷；TE_*需插件许可及对应版本 |
| TETK_SatisfactionIntervalsExample | 递归删除场景目录、0/1匹配和最后样本遗漏、字符串剥日期；安全输出与正确日期解析 |
| SOL_API_ConnectToRunningSTK | 无限连接重试；提示管理员netsh且宽URL ACL；不自动执行系统/端口设置 |
| SensorSweepSOLIS / solisCreateSequenceFromAccess | LLA_deg_m高度与km混用、硬编码日期/目录、length窗口数、XML转义与列表长度 |
| Clutter / Normalize_EOIR_Images | GUIDE.fig依赖、str2num求值、零向量/常量归一化、目录筛选及非整数索引；只作辅助后处理 |
| H5TexMap / HDF4TexMap | 产品特定fill/比例/单位；固定SDS/Attribute索引；按名称及元数据读，原输入不覆盖 |

以上为静态发现/待核对点，不声明已修复原案例；原文件没有修改。部分Interval/Intervals、类型枚举和固定单位必须按本版COM接口核实，不能仅凭拼写作普遍断言。

## 版本与验证边界

新增参考使用R2020b已有的MATLAB基础语法作配方约定；教程自身有string、GUIDE、.NET、工具箱及更晚STK API依赖，移植前核实。本次新增功能文档和索引，无新增/修改已发布.m模板；已有模板哈希与重组前一致，复用原STK12.1 + R2020b/R2023b验收日志，不伪称这些高级流程也通过运行测试。

stk.TransferData 在172个源文件/提取代码中未出现；SOL_API_ConnectToRunningSTK等是不同封装。先查实际stk变量类型和定义再处理该关键词。完整审计见 [security-audit](security-audit.md)。
