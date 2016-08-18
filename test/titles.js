import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test('parses a title', t => {
  const data = `# Title
some description
`;
  const expected = {
    info: {
      title: 'Title',
      description: 'some description'
    }
  };
  const result = parse(data);
  t.deepEqual(result.info, expected.info);
});
