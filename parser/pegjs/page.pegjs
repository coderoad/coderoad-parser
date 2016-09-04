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
