import test from 'ava';
const parse = require('../_parser');
const start = require('./_setup');

test('parses an action: open', t => {
  const data = `${start}@action(open('file.js'))
`;
  const expected = ["open(\"file.js\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});
