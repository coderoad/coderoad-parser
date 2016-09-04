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

test('parses a multiple onPageCompletes', t => {
  const expectedFirst = 'page one complete';
  const expectedSecond = 'page two complete'
  const data = `# Title
description

## Page One
description

@onPageComplete('${expectedFirst}')

## Page Two
description

@onPageComplete('${expectedSecond}')
`;
  const result = parse(data);
  t.is(result.pages[0].onPageComplete, expectedFirst);
  t.is(result.pages[1].onPageComplete, expectedSecond);
});

test.todo('throws when multiple onPageCompletes');
