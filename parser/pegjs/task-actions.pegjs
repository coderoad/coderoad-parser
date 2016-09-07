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
	// test for multi-line actions first
  / action_set_multi
	/ action_insert_multi
	/ action_write_multi
	// single-line actions
	/ action_set_single
	/ action_insert_single
	/ action_write_single
  / action_write_from_file

action_open
  = 'open'
    '('
    file: file_path
    closing_bracket
		closing_bracket
	{ return `open(${file})`; }

action_insert_single
	= 'insert'
		'('
		content: in_single_line
	{ return `insert(\"${content.slice(0, -2)}\")`; }

action_insert_multi
  = 'insert'
		'('
  	content: in_code_block
		closing_bracket
		closing_bracket
	{ return `insert(\"${content}\")`; }

action_set_single
	= 'set'
		'('
		content: in_single_line
	{ return `set(\"${content.slice(0, -2)}\")`; }

action_set_multi
  = 'set'
		'('
		content: in_code_block
		closing_bracket
		closing_bracket
	{ return `set(\"${content}\")`; }

action_write_single
	= 'write'
		'('
		to: file_path
		',' space?
		content: in_single_line
	{ return `write(${to}, \"${content.slice(0, -2)}\")`}

action_write_multi
  = 'write'
    '('
    to: file_path
    ',' space?
    content: in_code_block
		closing_bracket
		closing_bracket
	{ return `write(${to}, \"${content}\")`}

action_write_from_file
  = 'writeFromFile'
    '('
    to: file_path
    ',' space?
    from: file_path
    closing_bracket
		closing_bracket
	{ return `writeFromFile(${to}, ${from})`; }
