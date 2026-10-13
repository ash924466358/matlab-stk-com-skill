function name = stk_validate_name(name)
% Conservative template names avoid Connect quoting/path traversal issues.
name = stk_validate_text(name);
if isempty(regexp(name,'^[A-Za-z][A-Za-z0-9_-]{0,63}$','once'))
    error('stk:Name','Use a letter followed by at most 63 ASCII letters/digits/_/-.');
end
end
