task_action
	= '@action'
    '('
    value: action_type
		// must complete with ')' & \n
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
		break?
		')'
	{ return `open(${file})`; }

action_insert
  = 'insert'
    content:
	(
		between_code_block_and_brackets
	/ between_brackets
	)
		break?
		')'
	{ return `insert(\"${content}\")`; }

action_set
  = 'set'
    content: (
		between_code_block_and_brackets
	/ between_brackets
		)
		break?
		')'
	{ return `set(\"${content}\")`; }

action_write
  = 'write'
    '('
    to: file_path
    ',' space?
    content: ( between_code_block_with_closing_bracket
			/ until_end_quote_bracket ) // TODO: make this more flexible
		break?

	{ return `write(${to}, \"${content}\")`}

action_write_from_file
  = 'writeFromFile'
    '('
    to: file_path
    ',' space?
    from: file_path
    ')'
		break?
		')'
	{ return `writeFromFile(${to}, ${from})`; }
