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
  = page_onComplete
  / page_import

task_actions
  = test: task_test
  / hint: task_hint
  / action: task_action

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

page_onComplete
	= '@onPageComplete'

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
