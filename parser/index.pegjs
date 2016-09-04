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
  const taskTypes = ['tests', 'actions', 'hints']

  /*** "pegjs/_functions.js" ***/

  function adjust(item) {
    return item[0].concat(item[1].join(''));
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
        throw `${type} already exists on page "${page.title}"`;
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

  { let task = { description, tests: [], hints: [] };
	  actions.forEach(({type, value}) => {
      if (taskTypes.includes(type)) {
        task[type].push(value);
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
  { return { type: 'tests', value: testPath.join('') }; }

task_hint
	= '@hint'
    hint: [^\n^\r]+
    break
  { let h = trimBracketsAndQuotes(hint.join(''));
  	return { type: 'hints', value: h };
  }

/*** "pegjs/page-actions.pegjs" ***/

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

/*** "pegjs/task-actions.pegjs" ***/

task_action
	= '@action'
    '('
    type: action_type
    ')'

action_type
  = action_open
  / action_set
  / action_insert
  / action_write
  / action_write_from_file
  break

action_open
  = 'open'
    '('
    quote
    file: file_path
    quote
    ')'

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

/*** "pegjs/shared.pegjs" ***/

description
  = description: content
    break
  { return adjust(description); }

/*** "pegjs/characters.pegjs" ***/

content = [^#^@^+] [^\n^\r]+ [\n\r]
space = [ \s]
break = [\n\r]?
file_path = [a-z_\-\s0-9\.]+
quote = [\"\'\`]

