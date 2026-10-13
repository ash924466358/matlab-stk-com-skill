function scenario = stk_create_scenario(root, name, startUTCG, stopUTCG)
%STK_CREATE_SCENARIO Create ONLY in an empty application. No replacement.
% Fixed UTCG format: dd MMM yyyy HH:mm:ss.SSS, English month, UTC.
name = stk_validate_name(name);
[startUTCG,startDate] = stk_validate_utcg(startUTCG);
[stopUTCG,stopDate] = stk_validate_utcg(stopUTCG);
if stopDate <= startDate
    error('stk:TimeOrder','Stop time must follow start time.');
end
if root.Children.Count ~= 0
    error('stk:ScenarioExists','A scenario is open; reuse it or use a new application.');
end
guard = stk_units(root,{'DateFormat'},{'UTCG'}); %#ok<NASGU>
root.NewScenario(name);
scenario = root.CurrentScenario;
scenario.SetTimePeriod(startUTCG,stopUTCG);
scenario.Epoch = startUTCG; % Template invariant: EpSec zero = scenario start.
root.Rewind;
end
