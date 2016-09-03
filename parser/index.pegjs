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
   {
    position.task += 1;
    if (!output.pages[position.page].tasks) {
    	output.pages[position.page].tasks = [{
        	description: adjust(description)
        }]
    }
   }

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

content = [^#^@^+] [^\n^\r]+ [\n\r]
space = [ \s]
break = [\n\r]?
file_path = [a-z_\-\s0-9\.]+
quote = [\"\'\`]

{
// notes
// - break if line starts with #
// - break if line starts with @
}
