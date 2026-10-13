# STK COM 对象模型速查

依据：Example/StartSTK.m、Create*.m、AddSensor.m、Example_2.m；Automation/Matlab/STK_Automation_Tutorial.m；Engine 区别来自 CustomApplications/Matlab GUI 示例。

## 连接与断开

```matlab
app = actxGetRunningServer('STK12.Application'); % 附加 ROT 中实例
% 或 app = actxserver('STK12.Application');      % 新应用，记录拥有关系
root = app.Personality2;
sc = root.CurrentScenario;
```

多实例时附加不能可靠地按窗口选择，连接后检查 sc.InstanceName。UserControl=1 将 UI 交给用户，它不是断开，也不证明所有权。release 释放 MATLAB 接口引用；app.Quit 退出应用，root.CloseScenario 关闭场景，obj.Unload 删除对象；不可等价替代。先清除子对象/Provider/Access/回调引用，释放后 clear 已失效 root/app。不要用 delete(app) 暗示仅释放。

## 层级与常用枚举

```text
STKxx.Application → Personality2 (IAgStkObjectRoot)
  ├─ UnitPreferences / ConversionUtility / ExecuteCommand
  ├─ CentralBodies.Earth.Vgt
  └─ CurrentScenario (IAgScenario)
       ├─ Children → Satellite / Facility / AreaTarget / Aircraft / Chain / ...
       │    └─ Children → Sensor / Receiver / Transmitter / ...（允许关系查本地帮助）
       └─ CoverageDefinition → Children → FigureOfMerit
对象 → Propagator 或 Route、DataProviders、AccessConstraints、Graphics/VO、Vgt
Access → ComputeAccess、ComputedAccessIntervalTimes、DataProviders
```

| 用途 | char 枚举 / 接口 |
|---|---|
| 卫星、地面站、区域、导弹 | eSatellite、eFacility、eAreaTarget、eMissile |
| 传感器、飞机、船、目标 | eSensor、eAircraft、eShip、eTarget |
| 组网与覆盖 | eConstellation、eChain、eCoverageDefinition、eFigureOfMerit |
| 收发机 | eReceiver、eTransmitter |
| TwoBody/J2/J4/HPOP | ePropagatorTwoBody、ePropagatorJ2Perturbation、ePropagatorJ4Perturbation、ePropagatorHPOP |
| 外部星历/SGP4/Astrogator | ePropagatorStkExternal、ePropagatorSGP4、ePropagatorAstrogator |
| 路线 | SetRouteType('ePropagatorGreatArc')；Aviator 用 ePropagatorAviator |
| 轨道表示与系 | eOrbitStateClassical / eOrbitStateCartesian；eCoordinateSystemJ2000 / eCoordinateSystemICRF |

名称优于 18/9 等数字；通过本机 get(obj)、invoke(obj) 或 Programming Interface Help 核实支持值。不是所有父对象都能挂所有 Children。

## 创建 / 获取

```matlab
if sc.Children.Contains('eSatellite','Sat1')
    sat = root.GetObjectFromPath('Satellite/Sat1'); % 不代表授权改轨道
else
    sat = sc.Children.New('eSatellite','Sat1');
end
sensor = sat.Children.New('eSensor','Sensor1');
sensor = root.GetObjectFromPath('Satellite/Sat1/Sensor/Sensor1');
fac = sc.Children.New('eFacility','Ground1');
fac.Position.AssignGeodetic(40,-75,0); % 先设 deg / km
```

Item 通常 0 基，也可按名字；不是所有集合都支持 Contains。GetObjectFromPath 也支持完整路径，源例 ShowNames 返回路径可直接获取。

## 单位与时间

```matlab
old = root.UnitPreferences.GetCurrentUnitAbbrv('DateFormat');
restore = onCleanup(@() root.UnitPreferences.SetCurrentUnit('DateFormat',old));
root.UnitPreferences.SetCurrentUnit('DateFormat','EpSec');
t0 = root.CurrentScenario.StartTime; % 切单位后重读，可能是数值文本
```

用 stk_units 同时保存多个维度，保持 cleanup 对象存活。常用 DateFormat=UTCG/EpSec、Distance=km、Angle/Latitude/Longitude=deg；维度别名按本机帮助核实。

UTCG 示例 24 Feb 2020 16:00:00.000，英语月份、UTC。root.ConversionUtility.ConvertDate('UTCG','EpSec',utcg) 基于当前场景 Epoch；返回文本用 str2double。StartTime、Epoch、卫星初始历元独立；新场景模板令 Epoch=StartTime，附加场景不改 Epoch。OM 单位不会自动改变 Connect/插件参数。

显式退出自有实例时先 app.DisplayAlerts=false，防止保存/退出提示阻塞 COM。此项只用于确定要退出的自有应用；附加用户应用保留其提示设置。测试不应因 onCleanup 报警仍宣称退出成功。

quitOwned=true 会在所有权检查后关闭自有场景并退出，未保存场景不会自动落盘；要保留它先按用户给出的路径 SaveScenarioAs。普通断开和附加应用不关闭场景。
