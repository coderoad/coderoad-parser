import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test.todo('parses a task description');
test.todo('parses a second page with a task');

test.todo('parses a task test');
test.todo('warns when missing a task test');
test.todo('parses multiple task tests');
test.todo('parses task tests across pages');

test.todo('parses a task hint');
test.todo('parses multiple task hints');
