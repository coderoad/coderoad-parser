const { readFileSync, writeFileSync } = require('fs');
const pegjs = require('pegjs');

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.generate(parser).parse;

module.exports = parse;
