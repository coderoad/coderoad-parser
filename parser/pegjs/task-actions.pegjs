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
  / action_set
  / action_insert
  / action_write
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
    content: between_brackets // TODO: make this more flexible
		')'
	{ return `insert(${flatten(content).join('')})`; }

action_set
  = 'set'
		'('
    content: between_brackets // TODO: make this more flexible
		')'
	{ return `set(${flatten(content).join('')})`; }

action_write
  = 'write'
    '('
    quote
    to: file_path
    quote
    ',' space?
    quote
    content: [^\'\"]+ // TODO: make this more flexible
    quote
    ')'
	{ return `write(\"${to.join('')}\", \"${content.join('')}\")`}

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
