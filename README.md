# MATLAB–STK COM Skill

用于 **Windows 上 MATLAB 与 STK 的 COM/ActiveX 自动化**，将连接、建模、分析、动画、数据交换及自定义配置整理成可复用 Skill。Codex、dsh、WorkBuddy 等工具可读取 Markdown 指引；MATLAB 用户也可以直接调用模板函数。

本 Skill 从本地 **Example、CodeSamples、STK官方教程**的 **170 个 `.m` + 2 个 `.mlx`** 中提炼。仓库提供功能指引、参考文档和稳健模板，原始官方教程、商业软件及其配套资源不随仓库分发。

- [Skill 入口：SKILL.md](SKILL.md)
- [官方案例功能索引](references/tutorial-case-index.md)
- [安全审计与验证范围](references/security-audit.md)

## 功能模块

| 模块 | 包含功能 | 参考 |
|---|---|---|
| 连接与会话 | 连接/附加 STK、版本选择、会话所有权、COM 释放、单位恢复 | [connection](references/modules/connection.md) |
| 场景管理 | 新建/获取/载入/保存场景，分析时间、Epoch、目录处理 | [scenario-management](references/modules/scenario-management.md) |
| 对象创建与配置 | 卫星、地面站、区域、传感器、飞行器/船舶/导弹、编组 | [object-management](references/modules/object-management.md) |
| 分析功能创建 | Access、Chain、Coverage/FOM、PNT、通信预算、Astrogator、寿命、Aviator | [analysis-functions](references/modules/analysis-functions.md) |
| 动画控制 | 播放/暂停/复位、CurrentTime、动画步长、相机、Timeline、图形批处理 | [animation-control](references/modules/animation-control.md) |
| 数据输出 | DataProviders、报告、CSV、星历/姿态/区间文件、EOIR 后处理 | [data-output](references/modules/data-output.md) |
| 数据导入 | `.sc/.e/.a/.sp/.int/.awb`、CSV/Excel、GIS、ExternalData、HDF | [data-import](references/modules/data-import.md) |
| 自定义设置 | AWB/VGT、姿态、约束、颜色、VO、事件、MATLAB 插件 | [customization](references/modules/customization.md) |
| 实时与 Simulink | PointBuilder、实时姿态、timer、S-function、TETK、SOLIS 依赖边界 | [realtime-simulink](references/modules/realtime-simulink.md) |

模块按需组合，先连接与配置，再计算和取数。高级模块是有来源的参考配方；可直接调用的稳定基础模板列在下方。

## 适用场景

- 用 MATLAB 批量建立卫星、地面站、传感器及分析场景。
- 计算卫星—地面站 Access，输出可见窗口和位置/姿态等时序数据。
- 自动生成 STK 报告、CSV，或适配外部星历、姿态、区域及网格数据。
- 调整 STK 动画/视角，配置 AWB、约束、姿态或专用分析模型。
- 排查 COM 连接、对象路径、单位、时间、DataProvider 分组和版本差异。
- 为 Codex、dsh、WorkBuddy 提供项目间可复用的 MATLAB/STK 工作指引。

触发关键词包括 MATLAB/STK 互联、STK 场景自动化、STK COM、`actxserver`、`actxGetRunningServer`、`ExecuteCommand`、`SetState`、`DataProviders`。

`stk.TransferData` 可触发接口来源排查，但未在本次源代码中发现该接口；先检查实际 `stk` 变量、函数或封装定义，不将它当作已确认的标准 STK COM API。COM 是组件对象模型，与 COM1/COM2 串口不同；普通 MATLAB 分析、串口通信不属于本 Skill 的主要用途。

## 环境与版本

| 项目 | 假设 / 实测范围 |
|---|---|
| 操作系统 | Windows，支持 MATLAB ActiveX/COM |
| STK 目标版本 | 11.6 / 12.1，对应 `STK11.Application` / `STK12.Application` |
| MATLAB 目标版本 | R2020b / R2023b |
| 已实测组合 | STK 12.1.0 + MATLAB R2020b；STK 12.1.0 + MATLAB R2023b |
| 未实测 | STK 11.6；高级动画/导入/插件/实时/Simulink/SOLIS/TETK 等完整流程 |

模板主版本参数用 `11` 或 `12`，不是 `11.6` 或 `12.1`。连接后可通过 `GetSTKVersion` 核对实际次版本。STK 与 MATLAB 需自行安装并具备相应许可；Coverage、Astrogator、Aviator、EOIR、TETK、SOLIS、Simulink 等能力按任务另行核实。官方目录含晚于 STK 12.1 的 API/案例，移植时以目标版本本地帮助为准。

## 安装

### 获取仓库

```powershell
git clone https://github.com/nuaazxx/matlab-stk-com-skill.git matlab-stk-com
cd matlab-stk-com
```

也可使用 GitHub 的 **Code → Download ZIP** 并解压。仓库根目录即 Skill 目录，保留 `SKILL.md`、`references/`、`scripts/` 及 `scripts/private/` 的相对层级。

### Codex 用户级安装

将完整发布内容复制到 `$CODEX_HOME/skills/matlab-stk-com`；未配置 `CODEX_HOME` 时使用用户目录的 `.codex/skills/matlab-stk-com`。

下面 PowerShell 命令在克隆后的仓库根目录运行，仅在目标尚不存在时复制，不修改全局环境变量：

```powershell
$skillSource = (Get-Location).Path
$codexSkillHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else {
    Join-Path $env:USERPROFILE '.codex'
}
$skillTarget = Join-Path $codexSkillHome 'skills\matlab-stk-com'
if (Test-Path -LiteralPath $skillTarget) {
    throw '目标 Skill 已存在，请先比较内容或备份旧版。'
}
New-Item -ItemType Directory -Path $skillTarget -Force | Out-Null
Get-ChildItem -LiteralPath $skillSource -Force |
    Where-Object { $_.Name -ne '.git' } |
    Copy-Item -Destination $skillTarget -Recurse
```

打开新聊天后，可显式调用 `$matlab-stk-com`，或描述满足触发条件的 MATLAB/STK 自动化任务。

### dsh / WorkBuddy

使用对应版本的技能导入功能导入完整文件夹。不同版本的自动发现目录可能不同，本仓库不假设统一安装路径。若没有技能导入入口，可在提示中给出本地 `SKILL.md` 的绝对路径，让工具先读取入口，再按任务读取相关模块。

工具必须能够访问本地文件；执行 MATLAB/COM 还需要该工具拥有相应的本地执行能力。

## 在 AI 工具中调用

Codex 示例：

```text
使用 $matlab-stk-com。环境为 Windows、STK 12.1、MATLAB R2023b。
新建独立 STK 实例，建立一天的 J2 卫星场景和一个地面站，
计算 Access 窗口并导出 CSV 到我指定的本地输出目录。
使用现有模板，注明单位和时间格式，完成后只释放本次会话引用。
```

跨工具示例（将路径替换为实际安装位置）：

```text
先读取 C:\skills\matlab-stk-com\SKILL.md。
根据本次任务按需读取 references/modules 中的功能模块。
用 MATLAB 附加现有 STK 12.1 场景，读取 Satellite/Sat1 的
LLA State/Fixed 数据，每60秒采样一次并导出报告。
保留原场景，恢复本次改变的单位设置。
```

## 在 MATLAB 中直接调用

### 可调用模板

| 函数 | 用途 |
|---|---|
| `stk_connect` | `attach` 附加、`new` 新建、`auto` 附加失败后新建；返回 root/app/session |
| `stk_disconnect` | 默认释放 COM 引用；显式 `quitOwned=true` 才退出自有实例 |
| `stk_units` | 保存/设置 OM 单位，借助 `onCleanup` 恢复 |
| `stk_create_scenario` | 在空应用中创建场景并设置 UTCG 时间 |
| `stk_create_satellite` | 创建新 J2 卫星，显式 J2000 六根数、初始历元和采样步长 |
| `stk_access_intervals` | 计算 Access，返回全部窗口的 Nx2 EpSec 开始/结束时间 |
| `stk_get_report` | 按 fixed/interval/timevar 类型读取 Provider，保留多区间和文本列 |
| `stk_export_report` | 导出报告，检查覆盖并保护 CSV 文本公式起始符 |
| `stk_smoke_test` | 显式基础验收：独立实例、卫星、Access、报告、恢复与清理 |

### 建场景、卫星、地面站并输出报告

将 `skillDir` 改为实际仓库/安装目录；输出文件名和对象名应使用未占用名称。

```matlab
skillDir = fullfile(getenv('USERPROFILE'),'.codex','skills','matlab-stk-com');
addpath(fullfile(skillDir,'scripts')); % 仅当前会话，不需要 savepath

[root,app,session] = stk_connect(12,'new'); % STK 11.6 使用 11
sc = stk_create_scenario(root,'MatlabDemo', ...
    '24 Feb 2020 16:00:00.000','25 Feb 2020 16:00:00.000');

% a[km]；i/aop/raan/ta[deg]；J2000，轨道初始历元为场景开始时刻
kep = struct('a',6971,'e',0.001,'i',97.8,'aop',0,'raan',0,'ta',0);
sat = stk_create_satellite(root,'Sat1',kep,60);

guard = stk_units(root,{'Distance','Latitude','Longitude'},{'km','deg','deg'});
fac = sc.Children.New('eFacility','Ground1');
fac.UseTerrain = false;
fac.Position.AssignGeodetic(30.4794,-86.5234,0);
clear guard % 恢复原单位

[windows,access] = stk_access_intervals(root,sat,fac);
lla = stk_get_report(root,'Satellite/Sat1','LLA State/Fixed', ...
    'timevar',0,3600,60,{'Time';'Lat';'Lon';'Alt'});
accessReport = stk_get_report(root,access,'Access Data', ...
    'interval',0,86400,[],{});

outDir = fullfile(pwd,'stk-output');
llaFiles = stk_export_report(lla,outDir,'sat1_lla');
accessFiles = stk_export_report(accessReport,outDir,'sat1_access');
disp(windows);

% 默认只释放 MATLAB 引用，STK 界面保留供检查
clear access fac sat sc
stk_disconnect(root,app,session);
clear root app session
```

示例分析时刻 `0..86400` 使用该模板设置的场景 Epoch。附加其他场景时，先核实 Epoch/StartTime/StopTime，不能直接套用这些秒数。运行中断时，先清除子句柄并按会话所有权释放引用；函数模板不会自动关闭用户场景。

如需退出新建的实例，在释放前调用 `stk_disconnect(root,app,session,true)`。这会丢弃该自有实例的未保存场景，需保留时先保存；不能对附加实例这样调用。

### 附加现有 STK

```matlab
[root,app,session] = stk_connect(12,'attach');
sat = root.GetObjectFromPath('Satellite/Sat1');
% 按场景实际时间、Provider 与单位执行操作
clear sat
stk_disconnect(root,app,session);
clear root app session
```

### 基础验收

```matlab
runDir = fullfile(tempdir,['stk-smoke-' datestr(now,'yyyymmddTHHMMSSFFF')]);
summary = stk_smoke_test(12,runDir);
```

验收会创建独立 STK 实例并退出自己的实例，写入新的输出位置。Skill 加载不会自动启动验收或 MATLAB/STK。

## 目录结构

```text
.
├── README.md
├── SKILL.md
├── agents/openai.yaml
├── scripts/                  # 9个公开模板
│   └── private/              # 3个输入校验辅助函数
├── references/
│   ├── modules/              # 9个功能模块
│   ├── com-object-model.md
│   ├── connect-commands.md
│   ├── dataproviders-reports.md
│   ├── troubleshooting.md
│   ├── source-inventory.csv
│   ├── source-review.md
│   ├── tutorial-review.md
│   ├── tutorial-case-index.md
│   ├── installation.md
│   └── security-audit.md
├── manifest-sha256.json
└── public-audit.json
```

## 验证与使用边界

基础模板曾在 STK 12.1.0 + MATLAB R2020b/R2023b 上通过验收：各61条 LLA 样本、6个 Access 窗口，单位异常恢复、场景/同名对象保护、报告防覆盖、CSV文本保护和自有实例退出。公开版保留相同实现，仅将示例注释和文档中的本机路径通用化。

STK 11.6 未实测；高级配方只完成静态审阅。COM 集合一般为0基；UTCG 是 UTC，EpSec 零点是场景 Epoch；OM 与 Connect 单位独立。参考 [故障排查](references/troubleshooting.md) 和 [安全审计](references/security-audit.md)。

本仓库不提供 MATLAB、STK、许可证或第三方教程资源。来源清单用于追溯，原案例及商业产品权利归对应权利人；本项目与 MathWorks、Ansys/AGI 无官方隶属关系。仓库未额外声明开源许可授权。
