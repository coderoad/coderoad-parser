info
  = title: info_title
  	description: description*
  {
    output.info.title = title;
    output.info.description = description.join('\n');
  }

info_title
  = '#'
    space?
    title: content
  { return adjust(title); }
