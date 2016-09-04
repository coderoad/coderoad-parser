import test from 'ava';
import parse from './_parser';

test('parses an info title', t => {
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

test('parses an info title with a # in the middle', t => {
  const data = `# T#i#t#l#e#\n`;
  const expected = {
    info: {
      title: 'T#i#t#l#e#',
      description: ''
    }
  };
  const result = parse(data);
  t.deepEqual(result.info, expected.info);
});

test('parses an info description', t => {
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

test('parses an info multiline description', t => {
  const data = `# Title
some description
and more on
the next line
`;
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

test.skip('parses an info description seperated by breaks', t => {
  const data = `# Title
some description

and more on

the next line
`;
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

test.skip('parses an info title after empty spaces', t => {
  const data = `


# Title
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
