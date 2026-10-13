function [text, date] = stk_validate_utcg(text)
text = stk_validate_text(text);
if isempty(regexp(text,'^\d{2} [A-Z][a-z]{2} \d{4} \d{2}:\d{2}:\d{2}\.\d{3}$','once'))
    error('stk:UTCG','Use dd MMM yyyy HH:mm:ss.SSS with an English month.');
end
date = datetime(text,'InputFormat','dd MMM yyyy HH:mm:ss.SSS', ...
    'Locale','en_US','TimeZone','UTC');
if isnat(date), error('stk:UTCG','Invalid UTC date.'); end
end
