function [root, app, session] = stk_connect(majorVersion, mode)
%STK_CONNECT Attach/create desktop STK; track application ownership.
% [root,app,s] = stk_connect(12,'auto'); modes: attach, auto, new.
% Windows; target STK 11.6/12.1 and MATLAB R2020b/R2023b.
if nargin < 1, majorVersion = 12; end
if nargin < 2, mode = 'auto'; end
if ~ispc, error('stk:WindowsRequired','ActiveX requires Windows.'); end
if isnumeric(majorVersion)
    validateattributes(majorVersion,{'numeric'},{'scalar','integer','finite'});
    majorVersion = num2str(majorVersion);
elseif isstring(majorVersion) && isscalar(majorVersion)
    majorVersion = char(majorVersion);
end
if ~ischar(majorVersion) || ~any(strcmp(majorVersion,{'11','12'}))
    error('stk:Version','Use main version 11 or 12, not 11.6/12.1.');
end
mode = validatestring(mode,{'attach','auto','new'});
progID = ['STK',majorVersion,'.Application'];
session = struct('ProgID',progID,'OwnsApplication',false,'Mode',mode, ...
    'AttachErrorIdentifier','','AttachErrorMessage','');
if strcmp(mode,'new')
    app = actxserver(progID);
    session.OwnsApplication = true;
else
    try
        app = actxGetRunningServer(progID);
    catch attachError
        if strcmp(mode,'attach'), rethrow(attachError); end
        session.AttachErrorIdentifier = attachError.identifier;
        session.AttachErrorMessage = attachError.message;
        try
            app = actxserver(progID);
        catch launchError
            launchError = addCause(launchError,attachError);
            rethrow(launchError);
        end
        session.OwnsApplication = true;
    end
end
% Do not wrap root/configuration errors in the attachment fallback.
try
    root = app.Personality2;
    if session.OwnsApplication
        app.UserControl = 1;
        app.Visible = 1;
    end
catch setupError
    if session.OwnsApplication
        try
            app.Quit;
        catch cleanupError
            setupError = addCause(setupError,cleanupError);
        end
    end
    release(app);
    rethrow(setupError);
end
end

