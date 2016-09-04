const { readFileSync, writeFileSync } = require('fs');
const { join } = require('path');
const pegjs = require('pegjs');
const loadImports = require('./loadImports');

let compiled = '';
const start = readFileSync(join(__dirname, '../pegjs/start.pegjs'), 'utf8');

compiled += loadImports(start);

// output parser file
writeFileSync(join(__dirname, '../index.pegjs'), compiled, 'utf8');
