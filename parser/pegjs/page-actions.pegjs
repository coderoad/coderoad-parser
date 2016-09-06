page_actions
  = on_page_complete

on_page_complete
	= '@onPageComplete'
    '('
    quote
    value: until_end
    break?
  {
    if (value.match(/[\'\"]\)/)) {
      // remove '\')' from end
      value = value.slice(0, -2);
    } else {
      throw new Error(`Invalid @onPageComplete(). Expected closing quote and bracket but found: "${value}"`);
    }
    return {
      type: 'onPageComplete',
      value,
    };
  }
