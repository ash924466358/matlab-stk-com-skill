function text = stk_validate_text(text)
if isstring(text) && isscalar(text), text = char(text); end
if ~ischar(text) || ~isrow(text) || isempty(text) || ...
        any(text == char(0) | text == char(10) | text == char(13) | text == char(34))
    error('stk:Text','Expected nonempty scalar text without NUL, newline or double quotes.');
end
end
