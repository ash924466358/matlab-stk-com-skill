# Connect 常用命令

依据：Example/PropSat.m、ObjectsName.m、Example_2.m；Automation/Matlab/LifetimeTool.m、Comm_ConnectCommands.m、STK_Automation_Tutorial.m。Access/Report_RM/ReportCreate 为补充语法，需查安装版 Connect Command Library，模板优先用 OM。

## 传输、返回与单位

    r = root.ExecuteCommand('GetSTKVersion /');
    for k = 0:r.Count-1
        disp(r.Item(int32(k)));
    end

ExecuteCommand 不需要 stkOpen/TCP 端口。返回字符串集合，Item(0) 只取首项。命令内 UTCG、路径、报告名用英文双引号，外层 MATLAB char；未经校验自由文本不拼入命令，不用 eval。

**OM 单位与 Connect 单位独立**。SetState 属于 Connect，距离常见默认 m；源例 9720000 不能直接成为 OM 的 9720000 km。

    root.ExecuteCommand('SetUnits / km sec UTCG'); % 来自 LifetimeTool.m

隔离实例可设定；附加应用先按本地帮助查询、记录并恢复 Connect 原单位，不能以 OM oldUnit 冒充。收发机 SetValue 等还有内部单位约定。

| 操作 | 命令示例 | 注意 |
|---|---|---|
| 场景 | New / Scenario Demo | 仅空应用 |
| 卫星 | New / */Satellite Sat1 | 不重复 New |
| 存在性 | DoesObjExist */Satellite/Sat1 | 文本 0/1 |
| 对象列表 | ShowNames * Class Satellite | 空列表/空格名不能盲目 strsplit |
| 安装路径 | GetDirectory / STKHome | fullfile 拼路径 |
| 动画 | Animate * Reset | 不改轨道 |
| 地面站 | SetPosition */Facility/Ground1 Geodetic 40 -75 0 | 明确角度/距离单位 |
| Access | Access */Satellite/Sat1 */Facility/Ground1 | 结构化输出优先 OM |
| 清 Access | ClearAllAccess / | 影响全场景，不是断开 |
| 卸载 | Unload / */Satellite/Sat1 | 删除对象 |
| 内存报告 | Report_RM */Satellite/Sat1 Style "LLA Position" | 样式须存在 |
| 文件报告 | ReportCreate */Satellite/Sat1 Type Export Style "LLA Position" File "C:\stk-output\sat1.txt" | 检查目录/覆盖；样式依赖版本 |

## SetState 六根数

本例 Connect 单位 km/sec/UTCG，顺序 [a,e,i,aop,raan,ta]，a 是半长轴而非高度。

    root.ExecuteCommand('SetUnits / km sec UTCG');
    cmd = ['SetState */Satellite/Sat1 Classical J2Perturbation ', ...
        '"24 Feb 2020 16:00:00.000" "25 Feb 2020 16:00:00.000" ', ...
        '60 J2000 "24 Feb 2020 16:00:00.000" 6971 0.001 97.8 0 0 0'];
    root.ExecuteCommand(cmd);

结构：SetState path Classical propagator "start" "stop" step frame "epoch" a e i aop raan ta。历元独立。Cartesian 末六项 x y z vx vy vz（本例 km、km/sec），不能保留六根数数据。传播器关键字 TwoBody/J2Perturbation/HPOP 不同于 ePropagator 枚举。

## Access 与报告

    a = sat.GetAccessToObject(fac);
    a.ComputeAccess;
    r = a.DataProviders.Item('Access Data').Exec(t0,t1); % EpSec 标量

Report Style（LLA Position）和 DataProvider（LLA State/Fixed）是不同名字空间。结构化输出用 stk_get_report + stk_export_report；需要 GUI 样式时用 ReportCreate，核实本机时间选项。
