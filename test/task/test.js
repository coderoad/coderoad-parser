import test from 'ava';
import parse from '../_parser';

test('parses a task test', t => {
  const data = `# Title
description

## Page One
description

+ Task One
@test('01, 02')
`;
  const expected = [{
    description: 'Task One',
    tests: [
      '01, 02'
    ],
  }];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks, expected);
});

test('parses multiple task tests', t => {
  const data = `# Title
description

## Page One
description

+ Task One
@test('01, 02')
@test('03, 04')
`;
  const expected = [{
    description: 'Task One',
    tests: [
      '01, 02',
      '03, 04'
    ],
  }];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks, expected);
});

test('parses task tests across pages', t => {
  const data = `# Title
description

## Page One
description

+ Task One
@test('01, 02')

+ Task Two
@test('02, 01')
`;
  const expected = [{
    description: 'Task One',
    tests: [
      '01, 02'
    ],
  }, {
    description: 'Task Two',
    tests: [
      '02, 01'
    ],
  }];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks, expected);
});

test.todo('warns when missing a task test');

test.todo('parses an array of task tests');
