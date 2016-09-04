const { readFileSync } = require('fs');
const { join } = require('path');
const indent = require('./indent');

const importPath = /^@import\((.+)\)$/gm;
const pegjs = /\.pegjs$/;

function loadImports(str) {
  // collect all imports
  const imports = str.match(importPath);

  imports.forEach(i => {

    // capture file name
    const fileName = i.slice(9, -2);

    // load import
    let file = readFileSync(join(__dirname, '../pegjs/', fileName), 'utf8');


    // indent js files
    if (!fileName.match(pegjs)) {
      file = indent(file, 2);
    }

    // add imported file to text
    str = str.replace(i, file);
  });
  return str;
}

module.exports = loadImports;
