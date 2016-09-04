task_action
	= '@action'
    '('
    value: action_type
		')'
		break

	{
		return {
			type: 'actions',
			value
		};
	}

action_type
  = action_open
  // action_set
  // action_insert
  // action_write
  / action_write_from_file


action_open
  = 'open'
    '('
    quote
    file: file_path
    quote
    ')'
	{ return `open("${file.join('')}")`; }

action_insert
  = 'insert'
    '('
    content: .+
    ')'

action_set
  = 'set'
    '('
    content: .+
    ')'

action_write
  = 'write'
    '('
    quote
    to: file_path
    quote
    ',' space?
    quote
    content: .+
    quote
    ')'

action_write_from_file
  = 'writeFromFile'
    '('
    quote
    to: file_path
    quote
    ',' space?
    quote
    from: file_path
    quote
    ')'
	{ return `writeFromFile("${to.join('')}", "${from.join('')}")`; }
