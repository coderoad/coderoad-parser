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
  const expected = ["open(\"file.js\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.skip('parses an action: set', t => {
  const data = `${start}
@action(set('var a = 42;'))
`;
  const expected = ["set('var a = 42;')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.skip('parses an action: insert', t => {
  const data = `${start}
@action(insert('var a = 42;'))
`;
  const expected = ["insert('var a = 42;')"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.todo('parses an action: write');
test.todo('parses an action: writeFileFromFile');

test.todo('parses multiple actions: open & set');
