const { readFileSync } = require('fs');
const pegjs = require('pegjs');

const files = [
  'index', 'action'
];

let parser = '';
files.forEach(f => parser += readFileSync(`../parser/${f}.pegjs`, 'utf8'));

const parse = pegjs.buildParser(parser).parse;

module.exports = parse;
