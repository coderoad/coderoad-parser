page_actions
  = on_page_complete

on_page_complete
	= '@onPageComplete'
    '('
    quote
    content: [a-zA-Z0-9 ]+
    quote
    ')'
    break
  { return { type: 'onPageComplete', value: content.join('') }; }
