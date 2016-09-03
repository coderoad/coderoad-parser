{
  // final parsed output for coderoad.json file
  var position = {
  	page: -1,
    task: -1,
  };
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
}

start
  = doc
  { return output; }

doc
  = info_title
    info_description*
  	break?
  	page*

page
  = page_title
    page_description*
    page_task*

page_title
  = '##'
    space?
    title: content
    break
   	{
      // increment page
      position.page += 1;
      position.task = -1;
      // add page outline
      output.pages.push({
      	title: 'Page ' + position.page,
          description: '',
      });
      // add page title
      output.pages[position.page].title = adjust(title);
    }

page_description
  = description: content
  	break
   {
   	const d = output.pages[position.page].description;
	output.pages[position.page].description += d.length > 0 ? '\n' : '';
    output.pages[position.page].description += adjust(description);
	}

page_task
	= '+'
    space?
  	description: content
    break
    test: task_test*
    break?
   {
    position.task += 1;
    if (!output.pages[position.page].tasks) {
    	output.pages[position.page].tasks = [];
    }
   	output.pages[position.page].tasks.push({
		description: adjust(description),
        tests: test
     })
   }

page_actions
	= page_onComplete
    / page_import

task_actions
	= task_test
    / task_hint
    / task_action

task_test
	= '@test'
    '(' quote
    testPath: [^\n^\r^\'\"\`)]+
	  quote ')'
    break
    { return testPath.join(''); }

task_hint
	= '@hint'

task_action
	= '@action'

page_onComplete
	= '@onPageComplete'

page_import
	= '@import'

info_title
  = '#'
    space?
    title: content
  { output.info.title = adjust(title); }

info_description
  = description: content
    break
  {
  	const d = output.info.description;
    output.info.description += d.length > 0 ? '\n' : '';
	output.info.description += adjust(description);
   }

within_brackets
	= '(' .+ ')' break

content = [^#^@^+] [^\n^\r]+ [\n\r]
space = [ \s]
break = [\n\r]?
file_path = [a-z_\-\s0-9\.]+
quote = [\"\'\`]
