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
