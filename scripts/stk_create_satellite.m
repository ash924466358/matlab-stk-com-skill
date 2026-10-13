function sat = stk_create_satellite(root, name, kep, stepSec)
%STK_CREATE_SATELLITE Create a NEW J2 satellite; never overwrite an object.
% kep: a[km], e, i/aop/raan/ta[deg]; J2000, explicit scenario-start epoch.
if nargin < 4, stepSec = 60; end
name = stk_validate_name(name);
validateattributes(stepSec,{'numeric'},{'scalar','real','finite','positive'});
fields = {'a','e','i','aop','raan','ta'};
if ~isstruct(kep) || ~isscalar(kep) || ~all(isfield(kep,fields))
    error('stk:Kepler','kep needs scalar a/e/i/aop/raan/ta fields.');
end
for k = 1:numel(fields)
    validateattributes(kep.(fields{k}),{'numeric'},{'scalar','real','finite'});
end
if kep.a <= 0 || kep.e < 0 || kep.e >= 1 || kep.i < 0 || kep.i > 180
    error('stk:Kepler','Require a>0, 0<=e<1, 0<=i<=180 for this elliptic template.');
end
if root.Children.Count == 0, error('stk:NoScenario','Create/load a scenario first.'); end
scenario = root.CurrentScenario;
if scenario.Children.Contains('eSatellite',name)
    error('stk:ObjectExists','Satellite exists. Retrieve it explicitly instead of overwriting.');
end
guard = stk_units(root,{'DateFormat','Distance','Angle'},{'UTCG','km','deg'}); %#ok<NASGU>
startUTCG = scenario.StartTime;
stopUTCG = scenario.StopTime;
sat = scenario.Children.New('eSatellite',name);
sat.SetPropagatorType('ePropagatorJ2Perturbation');
prop = sat.Propagator;
prop.EphemerisInterval.SetExplicitInterval(startUTCG,stopUTCG);
prop.Step = stepSec;
prop.InitialState.OrbitEpoch.SetExplicitTime(startUTCG);
prop.InitialState.Representation.AssignClassical('eCoordinateSystemJ2000', ...
    kep.a,kep.e,kep.i,kep.aop,kep.raan,kep.ta);
prop.Propagate;
% If configuration fails, the new partial object remains for inspection.
% This function intentionally does not Unload objects on failure.
end
