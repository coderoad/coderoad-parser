import test from 'ava';
const parse = require('../_parser');
const start = require('./_setup');

test('parses an action: insert (single-line)', t => {
  const data = `${start}@action(insert('var a = 42;'))
`;
  const expected = ["insert(\"var a = 42;\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test('parses an action: insert (multi-line, ```)', t => {
  const data = `${start}@action(insert(\`\`\`
var a = 42;
var b = 43;
\`\`\`
))
`;
  const expected = ["insert(\"var a = 42;\nvar b = 43;\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});
