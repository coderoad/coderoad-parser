import test from 'ava';
const parse = require('../_parser');
const start = require('./_setup');

// write

test('parses an action: write (single-line)', t => {
  const data = `${start}@action(write('to.js', 'hello'))
`;
  const expected = ["write(\"to.js\", \"hello\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

// writeFromFile

test('parses an action: writeFromFile', t => {
  const data = `${start}@action(writeFromFile('to.js', 'from.js'))
`;
  const expected = ["writeFromFile(\"to.js\", \"from.js\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.todo('parses multiple actions: open & set');
