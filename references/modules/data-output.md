# 数据输出模块

触发：读取 DataProviders、生成报告、CSV/Excel、星历/姿态/加速度/区间文件、EOIR 后处理。输入：对象路径、Provider/Group、类型、时间段/步长、元素列名、单位及输出目录；输出：带元数据的结果和文件。通用契约见 [dataproviders-reports](../dataproviders-reports.md)，模板 stk_get_report / stk_export_report。

## Provider / Report

1. 选择 fixed/interval/timevar 类型与对应 Exec 签名；按 Group 选择参考系。PreData 是额外参考对象或时刻，按 Provider 文档设置；禁止无意弹 UI 让用户选择。
2. 一次 ExecElements 后按 DataSets.GetDataSetByName.GetValues 读取列，数值 cell 才 cell2mat，文本保持 cell。处理全部 Intervals 和空 DataSets，不只 Item(0)。字段合法化要避免同名碰撞。
3. 时间列与数据逐行对应；跨 Provider 合并按时间/窗口，不能裁短数组或假设同样长度即对齐。保存列名、单位、参考系、Epoch、版本和取数参数。
4. GUI Report Style 与 Provider 是不同名字空间。Report_RM/ReportCreate 的样式名必须存在，输出检查目标不存在、目录有效和返回成功状态。
5. stk_export_report 默认防覆盖，CSV 文本公式起始符做保护，数值保留数值语义；输出失败可能留下部分新文件，先核对再处理。

## 专业文件

| 文件 | 优先路径 / 验证点 |
|---|---|
| .e 星历 | 可用时 ExportTools 的原生星历工具；自行写入需验证 BEGIN/END Ephemeris、点数、ScenarioEpoch、CentralBody、CoordinateSystem、DistanceUnit、记录列与格式 |
| .a 姿态 | GetAttitudeExportTool / Attitude 导出；自行写明确 CoordinateAxes、Quaternion 或 Euler321/YPR、时间偏移和角速度单位 |
| .sp 传感器指向 | 与 SetPointingExternalFile 格式匹配；参考 body axes、四元数约定、分段区间、有效时间和 BEGIN/END 成对 |
| .int 区间 | 排序、start<=stop、明确 DateUnitAbrv 与 Epoch；按需求合并重叠，保留对象字段；空结果也有明确表达 |
| .accelhist | 推力/质量→加速度，质量>0，不默认牛顿/kg 数据单位；起点偏移、J2000/自定义系与 ScenarioEpoch 一致 |
| .awb | 按组件类型与依赖输出，文件名含类型避免跨类型同名碰撞 |
| EOIR 图片/纹理 | 原始数值与可视化分开，记录缺测值、缩放、辐亮度/温度单位和像素方向 |

文件写入使用 fopen 成功检查和 onCleanup fclose；固定格式字符串 `fprintf(fid,'%s',text)`，不把用户文本作为格式字符串。行数用 size(data,1)，时间严格递增，文件头 Epoch 与记录零点一致。先写新文件并回读/导入验证，再用于目标对象。

## 源例陷阱

createEphemerisFile 以 StartTime 写 ScenarioEpoch 但数据可能是相对场景 Epoch 的 EpSec，且未保证 km；generateSensorPointingFile 尾为 END Ephemeris，与 BEGIN Attitude 不匹配。satStepWiseTracking 固定第 26 行/第 23 字符定位不稳定；应按文件头与格式解析。

AST_output_Acceleration_Data 混用 StartTime 与 EpSec、datetime 默认字符串格式和质量为零分支；改用 ConversionUtility 与显式时间基准。Coverage 每日输出处理末尾不足一天；无覆盖不能用上一天残留变量。

H5TexMap/HDF4TexMap 为纯 MATLAB 转纹理 CSV，非 COM：H5 示例转置、65535 fill、0.1比例、nW→W及/0.4带宽都针对特定 VIIRS 产品；HDF 示例 0.02 为特定 MODIS LST 温度比例。不可泛用。读取按数据集名/属性名，避免 SDS(5)/Attributes(5) 的固定顺序。Normalize_EOIR_Images 的目录筛选与 scale_up 索引、常量值范围须修正后使用。

格式导入闭环见 [data-import](data-import.md)。
