import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test('parses a task hint', t => {
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

test('parses multiple task hints', t => {
    const data = `# Title
description

## Page One
description

+ Task One
@test('01, 02')
@hint('do something')
@hint('do something else')
`;
    const expected = [{
      description: 'Task One',
      tests: [
        '01, 02'
      ],
      hints: [
        'do something',
        'do something else'
      ]
    }];
    const result = parse(data);
    t.deepEqual(result.pages[0].tasks, expected);
});

test('parses a task hint with quotes inside', t => {
    const data = `# Title
description

## Page One
description

+ Task One
@test('01, 02')
@hint('do \' " \` something')
`;
    const expected = [{
      description: 'Task One',
      tests: [
        '01, 02'
      ],
      hints: [
        'do \' " \` something'
      ]
    }];
    const result = parse(data);
    t.deepEqual(result.pages[0].tasks, expected);
});
