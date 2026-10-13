function summary = stk_smoke_test(majorVersion, outputDir)
%STK_SMOKE_TEST Isolated end-to-end validation; never attaches to user STK.
% Writes fresh CSV/JSON reports to outputDir and quits ONLY its own app.
% [s] = stk_smoke_test(12,fullfile(tempdir,'stk-smoke-run12'));
if nargin < 1, majorVersion = 12; end
if nargin < 2, error('stk:OutputPath','Specify a fresh absolute output directory.'); end

[root,app,session] = stk_connect(majorVersion,'new');
app.DisplayAlerts = false; % Isolated test only; do not change attached apps.
finish = onCleanup(@() closeOwnedTest(root,app,session));
v = root.ExecuteCommand('GetSTKVersion /');
summary = struct('MATLAB',version,'STK',char(v.Item(int32(0))), ...
    'ProcessID',double(app.ProcessID),'AccessCount',0,'Samples',0,'Files',{{}});
sc = stk_create_scenario(root,'SkillSmoke', ...
    '24 Feb 2020 16:00:00.000','25 Feb 2020 16:00:00.000');
expectError(@() stk_create_scenario(root,'Other', ...
    '24 Feb 2020 16:00:00.000','25 Feb 2020 16:00:00.000'),'stk:ScenarioExists');
assert(strcmp(sc.InstanceName,'SkillSmoke'),'Unexpected scenario replacement.');
kep = struct('a',6971,'e',0.001,'i',97.8,'aop',0,'raan',0,'ta',0);
sat = stk_create_satellite(root,'Sat1',kep,60);
expectError(@() stk_create_satellite(root,'Sat1',kep,60),'stk:ObjectExists');
originalDateUnit = root.UnitPreferences.GetCurrentUnitAbbrv('DateFormat');
r = stk_get_report(root,'Satellite/Sat1','LLA State/Fixed', ...
    'timevar',0,3600,60,{'Time';'Lat';'Lon';'Alt'});
assert(strcmp(root.UnitPreferences.GetCurrentUnitAbbrv('DateFormat'), ...
    originalDateUnit),'DateFormat was not restored.');
t = r.Tables{1};
assert(height(t)==61 && all(isfinite(t.Alt)) && all(t.Alt>400 & t.Alt<700), ...
    'Unexpected LLA sample count or altitude scale.');
assert(abs(t.Time(1))<1e-6 && abs(t.Time(end)-3600)<1e-6,'Wrong EpSec epoch.');
summary.Samples = height(t);
% A failed provider call must also restore caller units.
try
    stk_get_report(root,sat,'MissingProviderForValidation','timevar',0,60,60,{});
    error('stk:ExpectedFailure','Missing provider unexpectedly succeeded.');
catch e
    if strcmp(e.identifier,'stk:ExpectedFailure'), rethrow(e); end
end
assert(strcmp(root.UnitPreferences.GetCurrentUnitAbbrv('DateFormat'), ...
    originalDateUnit),'Failure path leaked unit changes.');
g = stk_units(root,{'Distance','Latitude','Longitude'},{'km','deg','deg'}); %#ok<NASGU>
fac = sc.Children.New('eFacility','Ground1');
fac.Position.AssignGeodetic(40,-75,0);
clear g
[ivl,access] = stk_access_intervals(root,sat,fac);
assert(size(ivl,2)==2 && all(ivl(:,2)>=ivl(:,1)),'Invalid Access intervals.');
summary.AccessCount = size(ivl,1);
ar = stk_get_report(root,access,'Access Data','interval',0,86400,[],{});
assert(sum(cellfun(@height,ar.Tables))==size(ivl,1),'Access report lost rows.');
summary.Files = stk_export_report(r,outputDir,'lla');
roundTrip = readtable(summary.Files{1});
assert(height(roundTrip)==height(t),'CSV lost rows.');
expectError(@() stk_export_report(r,outputDir,'lla'),'stk:OutputExists');
% Text handling, field mappings and CSV formula protection.
synthetic = r;
synthetic.Tables = {table([1;2],{'=1+1';'plain'},'VariableNames',{'N','Text'})};
synthetic.ColumnNames = {{'N','Text'}};
csv = stk_export_report(synthetic,outputDir,'textcheck');
csvText = fileread(csv{1});
assert(contains(csvText,[char(39),'=1+1']),'Formula text was not protected.');
% Cannot quit through an attached-session ownership marker.
notOwner = session; notOwner.OwnsApplication = false;
expectError(@() stk_disconnect(root,app,notOwner,true),'stk:NotOwner');
disp(summary);

access = []; sat = []; fac = []; sc = []; %#ok<NASGU>
clear finish
end

function closeOwnedTest(root, app, session)
try
    stk_disconnect(root,app,session,true);
catch e
    warning('stk:SmokeCleanup','Owned application cleanup failed: %s',e.message);
end
end
function expectError(action, expectedID)
try
    action();
catch e
    assert(strcmp(e.identifier,expectedID),'Unexpected error: %s',e.message);
    return
end
error('stk:ExpectedFailure','Expected error %s was not raised.',expectedID);
end



