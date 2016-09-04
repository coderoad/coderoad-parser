page_actions
  = on_page_complete

on_page_complete
	= '@onPageComplete'
    '('
    quote
    content: .+
    quote
    ')'
  { return { type: 'onPageComplete', value: content.join('') }; }

page_import
	= '@import'
    '('
    quote
    filePath: file_path
    quote
    ')'
    break
  { return filePath.join(''); }
