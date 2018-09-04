function [text] = prepjson(text)
% Takes the single line unformatted result of MATLAB's native jsonencode()
% command and adds whitespace to the string so that the resultant .json
% file is easier to read in text editors.

text = strrep(text, '{', ['{' newline]);
text = strrep(text, '[', ['[' newline]);
text = strrep(text, ':{', ': {');
text = strrep(text, '}', [newline '}']);
text = strrep(text, ']', [newline ']']);
text = strrep(text, ',', [',' newline]);
end

