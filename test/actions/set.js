import test from 'ava';
const parse = require('../_parser');
const start = require('./_setup');

// single-line (within quotes or string literal)

test('parses an action: set (single-line)', t => {
  const data = `${start}@action(set('var a = 42;'))
`;
  const expected = ["set(\"var a = 42;\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.skip('parses an action: set(single-line, \` inside)', t => {
    const data = `${start}@action(set('var a = \`hello\`;'))
  `;
    const expected = ["set(\"var a = \`hello\`;\")"];
    const result = parse(data);
    t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.skip('parses an action: set(single-line, () inside)', t => {
    const data = `${start}@action(set('var a = function() {};'))
  `;
    const expected = ["set(\"var a = function() {};\")"];
    const result = parse(data);
    t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test.skip('parses an action: set(single-line, ) inside)', t => {
    const data = `${start}@action(set('var a = 'hello :) world\';'))
  `;
    const expected = ["set(\"var a = \'hello :) world\';\")"];
    const result = parse(data);
    t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

// multi-line (within a ``` codeblock)

test('parses an action: set (multi-line, ```)', t => {
  const data = `${start}@action(set(\`\`\`
var a = 42;
var b = 43;
\`\`\`
))
`;
  const expected = ["set(\"var a = 42;\nvar b = 43;\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test('parses an action: set (multi-line, () inside)', t => {
  const data = `${start}@action(set(\`\`\`
function() {
  return;
}
\`\`\`
))
`;
  const expected = ["set(\"function() {\n  return;\n}\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});

test('parses an action: set (multi-line, ) inside)', t => {
  const data = `${start}@action(set(\`\`\`
function() {
  return ':)';
}
\`\`\`
))
`;
  const expected = ["set(\"function() {\n  return \':)\';\n}\")"];
  const result = parse(data);
  t.deepEqual(result.pages[0].tasks[0].actions, expected);
});
