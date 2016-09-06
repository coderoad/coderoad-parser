content = [^#^@^+] until_end
until_end = [^\n^\r]+ [\n\r]
space = [ \s]
break = [\n\r]?
quote = [\"\'\`]
between_brackets = '(' [^\)]+ ')'
between_code_block = '```\n' [^\`]+ '```'

file_path
  = quote
    filePath:[a-zA-Z0-9_\-\s\.]+
    quote
  { return `\"${adjust(filePath)}\"`; }
