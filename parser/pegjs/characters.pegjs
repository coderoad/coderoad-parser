content = [^#^@^+] until_end
space = [ \s]
break = [\n\r]?
quote = [\"\'\`]
between_code_block = '```\n' [^\`]+ '```'

until_end
  = content: [^\n^\r]+
    [\n\r]
  { return adjust(content); }

file_path
  = quote
    filePath:[a-zA-Z0-9_\-\s\.]+
    quote
  { return `\"${adjust(filePath)}\"`; }

between_brackets
  = '('
    content: [^\)]+
    ')'
  { return adjust(content); }
