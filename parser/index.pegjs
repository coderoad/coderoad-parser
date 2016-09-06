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
    break
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
    break
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
	{ return `insert(${content})`; }

action_set
  = 'set'
    content: between_brackets
	// second: (between_code_block space? ')' space? )
	{ return `set(${content})`; }

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

/*** "pegjs/shared.pegjs" ***/

description
  = description: content
    break
  { return adjust(description); }

/*** "pegjs/characters.pegjs" ***/

content = [^#^@^+] until_end
space = [ \s]
break = [\n\r]?
quote = [\"\'\`]
between_code_block = '```\n' [^\`]+ '```'

until_end
  = content: [^\n^\r]+
    [\n\r]
  { return adjust(content); }

file_path
  = quote
    filePath:[a-zA-Z0-9_\-\s\.]+
    quote
  { return `\"${adjust(filePath)}\"`; }

between_brackets
  = '('
    content: [^\)]+
    ')'
  { return adjust(content); }

