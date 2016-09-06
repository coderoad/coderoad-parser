import test from 'ava';
import parse from '../_parser';

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

test('throws when onPageComplete does not close bracket', t => {
  const data = `# Title
description

## Page One
description

@onPageComplete('when page ends'
`;

  try {
    parse(data);
  } catch (e) {
    t.is(e.message, "Invalid @onPageComplete(). Expected closing quote and bracket but found: \"when page ends'\"")
  }
});

test('throws when onPageComplete does not close quote', t => {
  const data = `# Title
description

## Page One
description

@onPageComplete('when page ends)
`;

  try {
    parse(data);
  } catch (e) {
    t.is(e.message, "Invalid @onPageComplete(). Expected closing quote and bracket but found: \"when page ends)\"")
  }
});

test('throws when multiple onPageCompletes', t => {
  const data = `# Title
description

## Page One
description

@onPageComplete('first')
@onPageComplete('second')
`;

  try {
    parse(data);
  } catch (e) {
    t.is(e.message, "\"onPageComplete\" already exists on page \"Page One\"");
  }
});
