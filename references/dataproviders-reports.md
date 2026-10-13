# DataProvider、Access 与报告

依据：Example/GetObjRV.m、ReadCoverageData.m、Example_2.m；Automation Tutorial；CustomApplications/Matlab/Matlab Data Providers Example/ObjectModel.m。

| 类型 | 获取 | 执行 |
|---|---|---|
| 固定 | GetDataPrvFixedFromPath(path) | Exec() |
| 区间 | GetDataPrvIntervalFromPath(path) | Exec(start,stop) |
| 时间变化 | GetDataPrvTimeVarFromPath(path) | Exec(start,stop,step) / ExecElements(start,stop,step,elements) |

也可 obj.DataProviders.Item('LLA State').Group.Item('Fixed')。Facility 的 Cartesian Position 和卫星分组不同；get/invoke、本地 Data Providers 帮助核实类型，不凭名字猜。

| 对象 | Provider / Group | 常见列 |
|---|---|---|
| 卫星/飞机等 | LLA State/Fixed | Time、Lat、Lon、Alt |
| 卫星等 | Cartesian Position/J2000、Cartesian Velocity/J2000 | Time、x、y、z |
| Example RV | Vectors(J2000)/Position、Vectors(J2000)/Velocity | Time、x、y、z |
| Access 区间型 | Access Data | Start Time、Stop Time、Duration |
| Access 时间变化 | AER Data/Default | Time、Azimuth、Elevation、Range |
| CoverageDefinition | Percent Coverage（时间变化） | 核实 ElementNames |
| FigureOfMerit | Overall Value、Static Satisfaction（固定） | Minimum/Maximum、Percent Satisfied |
| Chain | Access AER Data（时间变化） | 逐 Intervals 取 Range/Time |
| Aviator Aircraft | Flight Profile By Time | Fuel Consumed、Time（专用单位） |

实际对象/许可/版本可能没有上述 Provider，读取 ElementNames 核实。未支持 Provider 不自动替换后宣称等价。

## 模板签名

    r = stk_get_report(root,source,providerPath,kind,t0,t1,step,elements);
    % source: 相对路径或 Access/FOM COM 句柄
    % kind: fixed | interval | timevar；t0/t1=EpSec，step=秒
    % fixed 时 t0/t1/step 传 []；fixed/interval 的 elements 传 {}
    [ivl,a] = stk_access_intervals(root,sat,fac);
    r = stk_get_report(root,a,'Access Data','interval',0,86400,[],{});
    files = stk_export_report(r,fullfile(pwd,'stk-output'),'access');

返回 struct：Tables 是逐区间 cell of table；ColumnNames 保存 STK 原列名与 table 变量名的对应位置；Units 保存 OM DateFormat/Distance/Angle/Latitude/Longitude，专用维度另查。

- 换 EpSec 后重新读取场景时刻；Epoch 不等于分析开始时刻。
- 每个 Provider 仅 Exec 一次，原 ReadCoverageData 每列重复执行。
- 仅数值标量 cell 转 double；文本保留 cell；makeValidName 后 makeUniqueStrings 避免碰撞。
- Intervals.Count>0 时全部遍历；无 Access 返回 0x2，不无条件 {1}；Nx2 数组不再 reshape。
- 位置/速度合并前检查 Time、行数、坐标系一致，J2000/ICRF/Fixed/Body 不可混用。
- 多窗口逐对 start/stop 标量 Exec，不把数组直接传入。
- 先短时间/适度步长验证；全局细网格和长时间小步长会产生大量数据，不承诺固定 COM 时延。

导出每区间 UTF-8 CSV + JSON 元数据，拒绝覆盖。文本以 =、+、-、@ 开头时加单引号，减少 Excel 公式执行风险；数值负数不修改，内存原 table 不变。包内不含源 .mat/.fig/.sc 数据。
