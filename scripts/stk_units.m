function guard = stk_units(root, dimensions, units)
%STK_UNITS Save/restore OM units, including exception paths.
% guard = stk_units(root,{'DateFormat','Distance'},{'EpSec','km'});
% Keep guard alive during the operation. Connect units are independent.
if ~iscellstr(dimensions) || ~iscellstr(units) || ...
        numel(dimensions) ~= numel(units) || isempty(dimensions)
    error('stk:Units','Pass equally sized nonempty cell arrays of char.');
end
if numel(unique(dimensions)) ~= numel(dimensions)
    error('stk:Units','Repeated dimensions are not allowed.');
end
old = cell(size(dimensions));
for k = 1:numel(dimensions)
    old{k} = root.UnitPreferences.GetCurrentUnitAbbrv(dimensions{k});
end
guard = onCleanup(@() restoreUnits(root,dimensions,old));
for k = 1:numel(dimensions)
    root.UnitPreferences.SetCurrentUnit(dimensions{k},units{k});
end
end

function restoreUnits(root, dimensions, old)
for k = numel(dimensions):-1:1
    try
        root.UnitPreferences.SetCurrentUnit(dimensions{k},old{k});
    catch e
        warning('stk:RestoreUnits','Could not restore %s: %s',dimensions{k},e.message);
    end
end
end
