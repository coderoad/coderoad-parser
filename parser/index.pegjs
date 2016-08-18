{
  var output = {
    info: {

    },
    pages: []
  }
}

start
  = doc
  { return output; }

doc
  = info

page
  = title: page_title
    description: description
  {
    // set page
    output.pages.push({
      title: title,
      description: description
    });
  }

page_title
  = '##'
    space
    title: content
    { return title.join(''); }

info
  = title: info_title
    end
    description: description
    end
  {
    // set info
    output.info.title = title;
    output.info.description = description;
  }

info_title
  = '#'
    space
    title: content
    end
  { return title.join(''); }

description
  = description: content
  { return description.join(''); }

content = .+
space = [ ]?
end = [\n]

// @import

// page
// page_title
// page_description
// page_test
// page_action
// page_hint
// page_on_complete

// @action_insert
// @action_set
// @action_write
// @action_write_from_file
// @action_open
// @action_cursor_position
