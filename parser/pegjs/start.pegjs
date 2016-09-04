{
  // final parsed output for coderoad.json file
  var output = {
    info: {
      title: 'Tutorial Title',
      description: '',
    },
    pages: []
  };

@import('./functions')

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

@import('./action')
@import('./common')
