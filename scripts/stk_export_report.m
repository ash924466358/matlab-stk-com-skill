function files = stk_export_report(report, outDir, baseName)
%STK_EXPORT_REPORT Write UTF-8 CSVs and JSON metadata; refuse overwriting.
% outDir: explicit absolute local drive path. No UNC/network side effects.
% Text fields starting with formula markers get a leading apostrophe.
outDir = stk_validate_text(outDir);
baseName = stk_validate_name(baseName);
if isempty(regexp(outDir,'^[A-Za-z]:[\\/]','once')) || ...
        ~isempty(regexp(outDir,'(^|[\\/])\.\.([\\/]|$)','once'))
    error('stk:OutputPath','Use an absolute local drive path without .. components.');
end
if ~isstruct(report) || ~isfield(report,'Tables') || ...
        ~iscell(report.Tables) || ~all(cellfun(@istable,report.Tables))
    error('stk:Report','Expected the struct returned by stk_get_report.');
end
files = cell(1,numel(report.Tables)+1);
for k = 1:numel(report.Tables)
    files{k} = fullfile(outDir,sprintf('%s_%03d.csv',baseName,k));
end
files{end} = fullfile(outDir,[baseName,'_metadata.json']);
for k = 1:numel(files)
    if exist(files{k},'file') || exist(files{k},'dir')
        error('stk:OutputExists','Refusing to overwrite: %s',files{k});
    end
end
metadata = rmfield(report,'Tables');
metadata.TableVariables = cellfun(@(t) t.Properties.VariableNames,report.Tables, ...
    'UniformOutput',false);
metadata.CSVFiles = files(1:end-1);
encoded = unicode2native(jsonencode(metadata),'UTF-8');
if ~exist(outDir,'dir')
    [ok,msg] = mkdir(outDir);
    if ~ok, error('stk:OutputDirectory','%s',msg); end
end
for k = 1:numel(report.Tables)
    data = report.Tables{k};
    for c = 1:width(data)
        field = data.Properties.VariableNames{c};
        column = data.(field);
        if iscell(column)
            for row = 1:numel(column)
                value = column{row};
                if ischar(value) && ~isempty(regexp(value,'^\s*[=+\-@]','once'))
                    column{row} = [char(39),value];
                end
            end
            data.(field) = column;
        elseif isstring(column)
            for row = 1:numel(column)
                if ~ismissing(column(row)) && ...
                        ~isempty(regexp(char(column(row)),'^\s*[=+\-@]','once'))
                    column(row) = string([char(39),char(column(row))]);
                end
            end
            data.(field) = column;
        end
    end
    writetable(data,files{k},'Encoding','UTF-8');
end
fid = fopen(files{end},'w');
if fid < 0, error('stk:OutputFile','Cannot open metadata output.'); end
closeFile = onCleanup(@() fclose(fid)); %#ok<NASGU>
count = fwrite(fid,encoded,'uint8');
if count ~= numel(encoded), error('stk:OutputFile','Incomplete metadata write.'); end
end
