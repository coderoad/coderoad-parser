import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test('parses a title', t => {
  const data = `# Title\n`;
  const expected = {
    info: {
      title: 'Title',
      description: ''
    }
  };
  const result = parse(data);
  t.deepEqual(result.info, expected.info);
});

test('parses a description', t => {
  const data = `# Title
some description
`;
  console.log(data);
  const expected = {
    info: {
      title: 'Title',
      description: 'some description'
    }
  };
  const result = parse(data);
  t.deepEqual(result.info, expected.info);
});

test('parses a multiline description', t => {
  const data = `# Title
some description
and more on
the next line
`;
  console.log(data);
  const expected = {
    info: {
      title: 'Title',
      description: `some description
and more on
the next line`
    }
  };
  const result = parse(data);
  t.deepEqual(result.info, expected.info);
});

test.skip('parses a title after empty spaces', t => {
  const data = `


# Title
some description
`;
  console.log(data);
  const expected = {
    info: {
      title: 'Title',
      description: 'some description'
    }
  };
  const result = parse(data);
  t.deepEqual(result.info, expected.info);
});
