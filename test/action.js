import test from 'ava';
import pegjs from 'pegjs';
import { readFileSync } from 'fs';

const parser = readFileSync('../parser/index.pegjs', 'utf8');
const parse = pegjs.buildParser(parser).parse;

test.todo('parses an action: open');
test.todo('parses multiple actions: open');

test.todo('parses an action: set');
test.todo('parses an action: insert');
test.todo('parses an action: write');
test.todo('parses an action: writeFileFromFile');
