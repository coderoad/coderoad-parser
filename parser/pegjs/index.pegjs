{
@import('./data.js')
@import('./functions.js')
}

start
  = doc
  { return output; }

doc
  = info
  	break?
	  page*

@import('./info.pegjs')
@import('./page.pegjs')
@import('./task.pegjs')
@import('./page-actions.pegjs')
@import('./task-actions.pegjs')
@import('./shared.pegjs')
@import('./characters.pegjs')
