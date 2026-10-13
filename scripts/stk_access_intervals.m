function [intervals, access] = stk_access_intervals(root, objA, objB)
%STK_ACCESS_INTERVALS Compute Access and return Nx2 EpSec start/stop times.
% Source object type/constraints matter; a Sensor is not its parent Satellite.
guard = stk_units(root,{'DateFormat'},{'EpSec'}); %#ok<NASGU>
access = objA.GetAccessToObject(objB);
access.ComputeAccess;
if access.ComputedAccessIntervalTimes.Count == 0
    intervals = zeros(0,2);
    return
end
arr = access.ComputedAccessIntervalTimes.ToArray(int32(0),int32(-1));
if iscell(arr), arr = cell2mat(arr); end
if size(arr,2) ~= 2 || ~isnumeric(arr)
    error('stk:IntervalShape','Expected an Nx2 numeric Access interval array.');
end
intervals = double(arr);
if any(~isfinite(intervals(:))) || any(intervals(:,2) < intervals(:,1))
    error('stk:IntervalValues','Invalid interval endpoints.');
end
end
