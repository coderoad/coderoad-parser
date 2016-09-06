content = [^#^@^+] until_end
until_end = [^\n^\r]+ [\n\r]
space = [ \s]
break = [\n\r]?
file_path = quote [a-zA-Z0-9_\-\s\.]+ quote
quote = [\"\'\`]
between_brackets = '(' [^\)]+ ')'
between_code_block = '```\n' [^\`]+ '```'
