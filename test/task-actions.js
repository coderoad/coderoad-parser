import test from 'ava';
import parse from './_parser';

const start = `# Title
description

## Page One
description

+ Task One
@test('01, 02')
`;

test('parses an action: open', t => {
  const data = `${start}@action(open('file.js'))
`;
  const expected = ["open(\'file.js\')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test('parses an action: set (single-line)', t => {
  const data = `${start}@action(set('var a = 42;'))
`;
  const expected = ["set(\'var a = 42;\')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test('parses an action: insert (single-line)', t => {
  const data = `${start}@action(insert('var a = 42;'))
`;
  const expected = ["insert(\'var a = 42;\')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test('parses an action: write (single-line)', t => {
  const data = `${start}@action(write('to.js', 'hello'))
`;
  const expected = ["write(\'to.js\', \"hello\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test('parses an action: set (multi-line, ```)', t => {
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

test('parses an action: writeFromFile', t => {
  const data = `${start}@action(writeFromFile('to.js', 'from.js'))
`;
  const expected = ["writeFromFile(\'to.js\', \'from.js\')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.todo('parses multiple actions: open & set');
