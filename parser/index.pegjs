{
  /*** "pegjs/_data.js" ***/

  var output = {
    info: {
      title: 'Tutorial Title',
      description: '',
    },
    pages: []
  };

  /*** "pegjs/_types.js" ***/

  const pageTypes = ['onPageComplete'];
  const taskTypes = ['tests', 'hints', 'actions'];

  /*** "pegjs/_functions.js" ***/

  function flatten(items) {
    const flat = [];
    items.forEach(item => {
      if (Array.isArray(item)) {
        flat.push(...flatten(item));
      } else {
        flat.push(item);
      }
    });
    return flat;
  }

  function adjust(item) {
    let flat = flatten(item);
    if (flat[flat.length - 1] === '\n') {
      flat = flat.slice(0, -1);
    }
    return flat.join('');
  }

  function trim({desc, str, first, last}) {
    if ( str[0].match(first) && str[str.length - 1].match(last || first) ) {
      return str.slice(1, -1);
    }
    throw `Error. Could not parse "${desc}" in "${str}".`;
  }

  function trimBrackets(str) {
    return trim({
      desc: 'bracket',
      str: str,
      first: /\(/,
      last: /\)/,
    });
  }

  function trimQuotes(str) {
    return trim({
      desc: 'quote',
      str,
      first: /[\"\'\`]/
    });
  }

  function trimBracketsAndQuotes(str) {
    return trimQuotes(trimBrackets(str));
  }

}

start
  = doc
  { return output; }

doc
  = info
  	break?
	  page*

/*** "pegjs/info.pegjs" ***/

info
  = title: info_title
  	description: description*
  {
    output.info.title = title;
    output.info.description = description.join('\n');
  }

info_title
  = '#'
    space?
    title: content
  { return adjust(title); }

/*** "pegjs/page.pegjs" ***/

page
  = title: page_title
    description: description*
    tasks: page_task*
    actions: page_actions*

  {
    let page = {
      title,
      description: description.join('\n'),
      tasks
    }

    // map over any actions and add them
    actions.forEach(({type, value}) => {
      if (page.hasOwnProperty(type)) {
        throw new Error(`\"${type}\" already exists on page \"${page.title}\"`);
      }
      page[type] = value;
    });
    output.pages.push(page);
  }

page_title
  = '##'
    space?
    title: content
  { return adjust(title); }

/*** "pegjs/task.pegjs" ***/

page_task
	= '+'
    space?
  	description: description
    actions: task_actions*
    break?

  { let task = { description };
	  actions.forEach(({type, value}) => {
			// task actions
      if (taskTypes.includes(type)) {
				if (!task.hasOwnProperty(type)) {
					task[type] = [];
				}
        task[type].push(value);
			// page actions
      } else if (pageTypes.includes(type)) {
        output.pages[pages.length - 1][type] = value;
      }
    });
	  return task;
  }

task_actions
  = task_test
  / task_hint
  / task_action
  / page_actions

task_test
	= '@test'
    '('
    quote
    testPath: [^\n^\r^\'\"\`)]+
	  quote
    ')'
    break
  { return { type: 'tests', value: adjust(testPath) }; }

task_hint
	= '@hint'
    hint: [^\n^\r]+
    break
  { let h = trimBracketsAndQuotes(adjust(hint));
  	return { type: 'hints', value: h };
  }

/*** "pegjs/page-actions.pegjs" ***/

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

/*** "pegjs/task-actions.pegjs" ***/

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

/*** "pegjs/shared.pegjs" ***/

description
  = description: content
    break?
  { return adjust(description); }

/*** "pegjs/characters.pegjs" ***/

non_special_line = [^#^@^+]
space = [ \s]
break = [\n\r]
non_break = [^\n^\r]
quote = [\"\'\`]
code_block = '```'
closing_bracket = break? ')'

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

in_code_block
  = break?
    code_block
    break?
    content: ( [^\`]+ / '`' [^\`]+ )+ // anything but ```
    code_block
    break?
  { return adjust(content); }

in_single_line
  = quote
  content: until_end
  { return content.slice(0, -1); }

