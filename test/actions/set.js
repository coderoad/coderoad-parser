import test from 'ava';
const parse = require('../_parser');
const start = require('./_setup');

test('parses an action: set (single-line)', t => {
  const data = `${start}@action(set('var a = 42;'))
`;
  const expected = ["set(\'var a = 42;\')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.skip('parses an action: set (multi-line, ```)', t => {
  const data = `${start}@action(set(```
var a = 42;
var b = 43;
```
))
`;
  const expected = ["set(\'var a = 42;\nvar b = 43;\')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});
