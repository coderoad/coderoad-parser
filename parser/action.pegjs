action
  = action_insert
  / action_set
  / action_write
  / action_write_from_file
  / action_open

action_insert
  = 'insert(' + content + ')'
action_set
  = 'set(' + content + ')'
action_write
  = 'write(' + content + ')'
action_write_from_file
  = 'writeFromFile(' + content + ')'
action_open
  = 'open(' + quote? + file_path + quote? ')'
