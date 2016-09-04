import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test('parses a page title', t => {
  const data = `# Title
description

## Page One
`;
  const expected = [{
    title: 'Page One',
    description: ''
  }];
  const result = parse(data);
  t.deepEqual(result.pages, expected);
});

test('parses a page with empty description', t => {
  const data = `# Title
description

## Page One
page one description
`;
  const expected = [{
    title: 'Page One',
    description: 'page one description'
  }];
  const result = parse(data);
  t.deepEqual(result.pages, expected);
});

test('parses two pages', t => {
  const data = `# Title
description

## Page One
page one description

## Page Two
page two description
`;
  const expected = [{
    title: 'Page One',
    description: 'page one description'
  }, {
    title: 'Page Two',
    description: 'page two description'
  }];
  const result = parse(data);
  t.deepEqual(result.pages, expected);
});

test.todo('parses an onPageComplete');
test.todo('throws when multiple onPageCompletes');
