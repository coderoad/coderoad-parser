non_special_line = [^#^@^+]
space = [ \s]
break = [\n\r]
non_break = [^\n^\r]
quote = [\"\'\`]
code_block = '```'

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

between_code_block
  = break?
    code_block
    break?
    content: ( [^\`]+ / '`' [^\`]+ )+ // not three back ticks
    code_block
    break?
  { return adjust(content); }

between_code_block_and_brackets
  = '('
    content: between_code_block
    ')'
  { return content; }

between_code_block_with_closing_bracket
  = content: between_code_block
  ')'
  break?
  ')'
  { return content; }

until_end_quote_bracket
  = content: until_end
  {
    // trim off final quote & bracket
    if (content.match(/[\"\'\`][\n\r]?\)[\n\r]?\)$/)) {
      return content.slice(1, -3);
    }
  }
