function report = stk_get_report(root, source, providerPath, kind, t0, t1, step, elements)
%STK_GET_REPORT Execute one provider; retain all intervals and text columns.
% source: relative object path or a COM object (including Access).
% providerPath: e.g. 'LLA State/Fixed'; kind: fixed/interval/timevar.
% t0/t1: numeric EpSec, step: seconds. fixed: []/[]/[]; no element filter.
if nargin < 8, elements = {}; end
providerPath = stk_validate_text(providerPath);
kind = validatestring(kind,{'fixed','interval','timevar'});
if ~iscellstr(elements), error('stk:Elements','Elements must be a cell array of char.'); end
if ~strcmp(kind,'fixed')
    validateattributes(t0,{'numeric'},{'scalar','real','finite'});
    validateattributes(t1,{'numeric'},{'scalar','real','finite','>=',t0});
end
if strcmp(kind,'timevar')
    validateattributes(step,{'numeric'},{'scalar','real','finite','positive'});
elseif ~isempty(elements)
    error('stk:Elements','Element filtering is only supported for timevar.');
end
dimensions = {'DateFormat','Distance','Angle','Latitude','Longitude'};
units = {'EpSec','km','deg','deg','deg'};
guard = stk_units(root,dimensions,units); %#ok<NASGU>
if ischar(source) || (isstring(source) && isscalar(source))
    source = root.GetObjectFromPath(stk_validate_text(source));
end
switch kind
    case 'fixed'
        dp = source.DataProviders.GetDataPrvFixedFromPath(providerPath);
        result = dp.Exec();
    case 'interval'
        dp = source.DataProviders.GetDataPrvIntervalFromPath(providerPath);
        result = dp.Exec(t0,t1);
    case 'timevar'
        dp = source.DataProviders.GetDataPrvTimeVarFromPath(providerPath);
        if isempty(elements)
            result = dp.Exec(t0,t1,step);
        else
            result = dp.ExecElements(t0,t1,step,elements(:));
        end
end
report = struct('ProviderPath',providerPath,'Kind',kind, ...
    'StartEpSec',t0,'StopEpSec',t1,'StepSec',step,'Units',struct(), ...
    'Tables',{{}},'ColumnNames',{{}});
for k = 1:numel(dimensions)
    report.Units.(dimensions{k}) = units{k};
end
n = result.Intervals.Count;
if n == 0
    [report.Tables{1},report.ColumnNames{1}] = readDataSets(result.DataSets);
else
    for k = 0:n-1
        interval = result.Intervals.Item(int32(k));
        [report.Tables{k+1},report.ColumnNames{k+1}] = readDataSets(interval.DataSets);
    end
end
end

function [data, names] = readDataSets(sets)
data = table();
names = cell(1,sets.Count);
for k = 0:sets.Count-1
    ds = sets.Item(int32(k));
    names{k+1} = char(ds.ElementName);
end
vars = matlab.lang.makeUniqueStrings(matlab.lang.makeValidName(names));
for k = 0:sets.Count-1
    ds = sets.Item(int32(k));
    values = ds.GetValues;
    if iscell(values)
        values = values(:);
        if all(cellfun(@(x) (isnumeric(x) || islogical(x)) && isscalar(x),values))
            values = cellfun(@double,values);
        end
    elseif isnumeric(values) || islogical(values)
        values = values(:);
    else
        values = cellstr(values);
    end
    data.(vars{k+1}) = values;
end
end
