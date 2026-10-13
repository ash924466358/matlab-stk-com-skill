function stk_disconnect(root, app, session, quitOwned)
%STK_DISCONNECT Release MATLAB COM references; do not close user scenarios.
% Clear child handles first. Afterwards clear root/app in the caller.
% Pass true ONLY to quit the application created by this session.
if nargin < 4, quitOwned = false; end
validateattributes(quitOwned,{'logical'},{'scalar'});
if quitOwned
    if ~isstruct(session) || ~isfield(session,'OwnsApplication') || ...
            ~isequal(session.OwnsApplication,true)
        error('stk:NotOwner','Cannot quit an attached application.');
    end
    % Suppress exit/save prompts ONLY for an explicitly owned application.
    app.DisplayAlerts = false;
    app.UserControl = false;
    if root.Children.Count > 0
        root.CloseScenario; % Owned quit discards this session's unsaved scene.
    end
    app.Quit;
end
release(root);
release(app);
end



