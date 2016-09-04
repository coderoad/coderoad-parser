{
  // final parsed output for coderoad.json file
  var output = {
    info: {
      title: 'Tutorial Title',
      description: '',
    },
    pages: []
  };

  function adjust(item) {
    return item[0].concat(item[1].join(''));
  }
  function trim({desc, str, first, last}) {
  	if ( str[0].match(first) && str[str.length - 1].match(last || first) ) {
    	return str.slice(1, -1);
    }
    console.log('Error. Could not parse ' + desc + ' in ' + str);
   	return str;
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

info
  = title: info_title
  	description: description*
  {
    output.info.title = title;
    output.info.description = description.join('\n');
  }

page
  = title: page_title
    description: description*
    tasks: page_task*
  {
    output.pages.push({
    	title,
      description: description.join('\n'),
      tasks,
    });
  }

page_task
	= '+'
    space?
  	description: description
    actions: task_actions*
    break?

  { let task = { description, tests: [], hints: [] };
	  actions.forEach(({type, value}) => task[type].push(value));
	  return task;
  }

page_actions
  = on_page_complete
  / page_import

task_actions
  = test: task_test
  / hint: task_hint
  / action: task_action
  / onPageComplete: on_page_complete

info_title
  = '#'
    space?
    title: content
  { return adjust(title); }

page_title
  = '##'
    space?
    title: content
    break
  { return adjust(title); }

description
  = description: content
    break
  { return adjust(description); }

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

on_page_complete
	= '@onPageComplete'
    '('
    quote
    content: .+
    quote
    ')'
  { return { type: 'onPageComplete', value: content.join('') }; }

page_import
	= '@import'
    '('
    quote
    filePath: file_path
    quote
    ')'
    break
  { return filePath.join(''); }


// characters

content = [^#^@^+] [^\n^\r]+ [\n\r]
space = [ \s]
break = [\n\r]?
file_path = [a-z_\-\s0-9\.]+
quote = [\"\'\`]
