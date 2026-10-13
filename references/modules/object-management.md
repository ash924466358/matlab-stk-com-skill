# 对象创建与配置模块

触发：创建卫星、地面站、区域、传感器、Aircraft/Ship/Missile、Constellation 或 Chain 成员。输入：类型、完整父对象路径、唯一名称、状态/位置/路线及单位；输出：对象句柄与配置后状态。稳定卫星模板：stk_create_satellite。

## 通用创建模式

`parent.Children.Contains('eSensor','Sensor1')` → 按任务获取 Item 或 New。顶层 parent=root.CurrentScenario；Sensor/Transmitter/Receiver 常为嵌套子对象。GetObjectFromPath 使用完整层级；集合遍历 Item(int32(k)) 从 0 到 Count-1。不得用 getAllObjectHandles 原例的 eval 将对象名注入变量。

对象存在时“获取”不授权覆盖。配置失败保留新建的部分对象供检查，错误信息记录路径与失败步骤，避免任意 catch→Unload。同名组件、对象和输出文件分别检测。

## 分类配置

| 对象 | 操作顺序 | 必须明确 |
|---|---|---|
| Satellite | SetPropagatorType → 重取 Propagator → InitialState/区间/Step → Propagate | J2000/ICRF、Epoch、a/e/i/aop/raan/ta，a 为半长轴 |
| SGP4 | 选 SGP4 → 从指定本地 TLE 文件 AddSegsFromFile → Propagate | SSC、TLE 历元/范围；在线源与 AutoUpdate 是显式联网功能 |
| Facility/Place/Target | Children.New → UseTerrain → Position.AssignGeodetic | 纬度/经度 deg、高程单位及椭球/MSL/地形语义 |
| AreaTarget | AreaType='ePattern' → AreaTypeData.Add(lat,lon) 或 CommonTasks.SetAreaTypePattern | >=3点、经纬列顺序、跨日期变更线和多边形闭合 |
| Sensor | SetPatternType → 对应 Pattern → SetPointingType → 指向/约束 | SimpleConic/Rectangular 半角；父体姿态与传感器指向不同 |
| Aircraft/Ship/GroundVehicle | SetRouteType('ePropagatorGreatArc') → 重取 Route → Waypoints → Propagate | 纬/经、高度参考、km/km/s；若替换路线先获得该修改范围 |
| Missile | 选择轨迹类型 → Launch 与 Impact 类型接口 → Propagate | 发射/落点、初始时间、类型对应的字段 |
| Constellation/Chain | 新建集合 → Objects.AddObject/Add(path) | Constellation 是编组；Chain 顺序决定链路，不按名称随意排序 |

Facility 的简单配方（仅新对象，操作期间设置 Distance=km、Latitude/Longitude=deg）：

```matlab
fac = root.CurrentScenario.Children.New('eFacility','Ground1');
fac.UseTerrain = false;
fac.Position.AssignGeodetic(30.4794,-86.5234,0);
```

## 错点与验收

- ConvertTo('eOrbitStateClassical') 后设置 SizeShapeType/LocationType 等，再 Assign；不假定读取来的表示恰好是半长轴与真近点角。
- TLE→Cartesian→其他传播器是采样转换，不能把原 SGP4 数据当成同精度动力学模型；核对时间与坐标系。
- Sensor 指向目标与卫星 Attitude.TargetPointing 是两个配置层；太阳/地球约束按具体对象加。
- ImportFacilities 原例删除同名地面站；FigureEight 清空已有 Waypoints；GenerateScan 可能复用并卸载 ScanGuess。改为唯一任务对象或明确允许的目标。
- 验收传播范围、样本物理量级、位置/路线终点、Sensor 半角和目标成员；原例简单经纬度几何在高纬/大区域需球面或椭球算法。

分析见 [analysis-functions](analysis-functions.md)，外部文件见 [data-import](data-import.md)，姿态/AWB 见 [customization](customization.md)。
