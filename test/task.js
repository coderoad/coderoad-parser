import test from 'ava';
import parse from './_parser';

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

test('parses a task hint before a test', t => {
  const data = `# Title
description

## Page One
description

+ Task One
@test('01, 02')
@hint('do something')
`;
  const expected = [{
    description: 'Task One',
    tests: [
      '01, 02'
    ],
    hints: [
      'do something'
    ]
  }];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks, expected);
});

test('parses a task test before a hint', t => {
  const data = `# Title
description

## Page One
description

+ Task One
@hint('do something')
@test('01, 02')
`;
  const expected = [{
    description: 'Task One',
    tests: [
      '01, 02'
    ],
    hints: [
      'do something'
    ]
  }];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks, expected);
});
