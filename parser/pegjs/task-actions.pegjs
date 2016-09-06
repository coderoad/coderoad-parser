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
    file: file_path
    ')'
	{ return `open(${file})`; }

action_insert
  = 'insert'
    content: between_brackets
	{ return `insert${adjust(content)}`; }

action_set
  = 'set'
    content: between_brackets
	// second: (between_code_block space? ')' space? )
	{ return `set${adjust(content)}`; }

action_write
  = 'write'
    '('
    to: file_path
    ',' space?
    quote
    content: [^\'\"]+ // TODO: make this more flexible
    quote
    ')'
	{ return `write(${to}, \"${adjust(content)}\")`}

action_write_from_file
  = 'writeFromFile'
    '('
    to: file_path
    ',' space?
    from: file_path
    ')'
	{ return `writeFromFile(${to}, ${from})`; }
