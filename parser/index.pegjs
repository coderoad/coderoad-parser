{
  var output = {
    info: {

    },
    pages: []
  }
}

start
  = info
  { return output; }

doc
  = info
    page*

page
  = page_title
    description

page_title
  = '##'
    space
    title: content
    EOL
    { return title.join(''); }

info
  = title: info_title
  	description: description
  {
    // set info
    output.info.title = title;
    output.info.description = description
  }

info_title
  = '#'
    space
    title: content
    EOL
  { return title.join(''); }

description
  = description: content
    EOL
  { return description.join(''); }

content = [0-9A-Za-z ]*
space = [ ]
EOL = [\n\r]?
file_path = [a-z_\-\s0-9\.]+
quote = [\"\'\`]

break = space EOL
