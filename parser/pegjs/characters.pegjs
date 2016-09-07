non_special_line = [^#^@^+]
space = [ \s]
break = [\n\r]
non_break = [^\n^\r]
quote = [\"\'\`]
code_block = '```'
closing_bracket = break? ')'

content
  = non_special_line
    until_end

until_end
  = content: non_break+
    break
  { return adjust(content); }

file_path
  = quote
    filePath: [a-zA-Z0-9_\-\s\.]+
    quote
  { return `\"${adjust(filePath)}\"`; }

between_brackets
  = '('
    content: [^\)]+
    ')'
  { return trimQuotes(adjust(content)); }

in_code_block
  = break?
    code_block
    break?
    content: ( [^\`]+ / '`' [^\`]+ )+ // anything but ```
    code_block
    break?
  { return adjust(content); }

in_single_line
  = quote
  content: until_end
  { return content.slice(0, -1); }
