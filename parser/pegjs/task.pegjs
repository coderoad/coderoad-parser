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
