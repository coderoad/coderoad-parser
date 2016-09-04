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

task_actions
  = test: task_test
  / hint: task_hint
  / action: task_action

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
