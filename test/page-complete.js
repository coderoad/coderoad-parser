import test from 'ava';
import parse from './_parser';

test('parses an onPageComplete', t => {
  const expected = 'when page ends';
  const data = `# Title
description

## Page One
description

@onPageComplete('${expected}')
`;
  const result = parse(data);
  t.is(result.pages[0].onPageComplete, expected);
});

test.todo('throws when multiple onPageCompletes');
