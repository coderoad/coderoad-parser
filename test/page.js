import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test.todo('parses a page title');
test.todo('parses a page with empty description');
test.todo('parses two pages');

test.todo('parses an onPageComplete');
test.todo('throws when multiple onPageCompletes');
