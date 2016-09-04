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

page_title
  = '##'
    space?
    title: content
    break
  { return adjust(title); }

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
