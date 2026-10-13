# 数据导入模块

触发：加载场景、导入外部星历/姿态/传感器指向/区间/AWB、CSV/Excel、GIS、ExternalData、EOIR HDF。输入：本地存在的文件、格式/列契约、单位、历元/坐标系、目标对象和新建/更新意图；输出：导入配置及回读验证。不直接执行原例的固定路径、覆盖或删除流程。

## 按格式处理

| 输入 | 接口路线 | 前置条件 |
|---|---|---|
| .sc | root.LoadScenario(fullPath) | 当前场景处置明确，配套文件存在；重新获取句柄 |
| Satellite .e | SetPropagatorType('ePropagatorStkExternal') → Propagator.Filename → Propagate | 类型切换后重取接口，头与记录一致 |
| Aircraft/Ship/GroundVehicle .e | SetRouteType('ePropagatorStkExternal') → Route.Filename → Propagate | 不给 Route 用 Satellite.SetPropagatorType |
| Missile .e | 对应外部 Trajectory 类型 → Trajectory 文件接口 → Propagate | 先核实本版签名 |
| Satellite .a | Attitude.External.Load(fullPath) | 目标指向/Basic/External 生效优先级明确 |
| Sensor .sp | SetPointingExternalFile(fullPath) | 时间范围、body参考系、四元数和文件类型核实 |
| .pattern / .bmsk | Custom Pattern 或 SetAzElMaskFile | 文件内容、传感器类型、遮挡约束开关正确 |
| .int | AWB 外部 Interval List 或解析后 SetIntervals | DateUnit/Epoch、成对列、空结果和边界正确 |
| .awb | 相应组件集合 Import | 类型、目标名称、依赖顺序和冲突策略 |
| CSV / Excel | readtable → 校验 → New / AssignGeodetic / AreaTypeData.Add / Waypoints.Add | 指定 ID/LAT/LON/ALT 等列、缺测/重复、角度/高程语义 |
| .shp | GIS * Import "file" AreaTarget | .shx/.dbf/投影等配套、导入可能产生多个对象 |
| ExternalData | ExternalData DataGroup 定义与数据导入 | 时间/列数/维度/单位，名称与现有组冲突 |
| HDF4/HDF5 | hdfinfo/hdfread 或 h5info/h5read → 标定→输出 CSV→EOIR纹理设置 | 产品元数据/地理范围/缺测值，需 EOIR 功能与正确纹理单位 |

## 标准步骤

1. 用 fullfile/char 处理路径，确认文件和配套资源。自由路径不可直接拼 Connect：先拒绝嵌入引号/换行，完整路径加双引号；不把文件内文本当作命令执行。
2. 回读文件头和代表性首/末行，确认点数、列数、有限数值、单调时间、Epoch、单位、坐标系。与已有场景分析区间求交；不为导入默认改场景时间。
3. 指明对象是新建还是允许替换配置。批量 CSV 先验证全部行与 ID 冲突，再逐对象建模；保留已成功/失败记录，不遇异常就删除原对象。
4. 导入后在指定时刻取 LLA/Cartesian/姿态作回读对比。不会 Propagate 的文件/组件接口则检查加载状态和可求值范围。外部依赖保存进交付清单。

## 易错点

- pushSat2STK 无条件覆盖 exportAttEphFiles 参数，char 时间比较/固定 HeaderLines 脆弱；配置由调用者给，解析实际文件头。
- ImportFacilities 原例的 ALT 在 Distance=m 下；常用对象例为 km，必须标出列单位。AreaTarget 导入需 BeginUpdate/EndUpdate 异常配对。
- GIS 可产生分片/岛屿对象，先枚举新增对象，不用 UnloadMulti 通配符删“多余”对象。
- 自定义坐标系 .e/.a 必须存在并在有效时段求值。STK q1..q4 常为标量最后，但以实际文件/Provider说明为准；转 MATLAB 标量首先时显式重排并检验方向。
- AccumulatedPower 外部数据例把功率和能量累计混淆：能量须对真实 dt 积分，并定义正确单位；无 Access 和末段边界处理。
- 官方案例出现 STK 12.8 文件头和晚版 API；别机械降头版本，核实目标11.6/12.1格式与字段再转换。

场景载入见 [scenario-management](scenario-management.md)，专业文件生成见 [data-output](data-output.md)，TETK .tedm/TSPI 专属导入见 [realtime-simulink](realtime-simulink.md)。
