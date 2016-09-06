const { readFileSync, writeFileSync } = require('fs');
const { join } = require('path');
const pegjs = require('pegjs');

const parser = readFileSync(join(__dirname, '../parser/index.pegjs'), 'utf8');
const parse = pegjs.generate(parser).parse;

module.exports = parse;
