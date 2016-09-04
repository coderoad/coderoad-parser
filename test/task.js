import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test('parses a task description', t => {
  const data = `# Title
description

## Page One
description

+ Task One
`;
  const expected = [{
    description: 'Task One',
    tests: [],
    hints: []
  }];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks, expected);
});

test('parses a second page with a task', t => {
  const data = `# Title
description

## Page One
description

+ Task One

+ Task Two
`;
  const expected = [{
    description: 'Task One',
    tests: [],
    hints: []
  }, {
    description: 'Task Two',
    tests: [],
    hints: []
  }];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks, expected);
});
