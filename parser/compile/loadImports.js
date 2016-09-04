const { readFileSync } = require('fs');
const { join } = require('path');

const importPath = /^@import\((.+)\)$/gm;

function loadImports(str) {
  const imports = str.match(importPath);
  imports.forEach(i => {
    const fileName = i.slice(9, -2) + '.pegjs';
    const file = readFileSync(join(__dirname, '../pegjs/', fileName), 'utf8');
    str = str.replace(i, file);
  });
  return str;
}

module.exports = loadImports;
