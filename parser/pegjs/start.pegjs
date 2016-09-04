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

@import('./info')

@import('./page')

@import('./page-task')

@import('./page-actions')

@import('./task-actions')

@import('./shared')

@import('./characters')
