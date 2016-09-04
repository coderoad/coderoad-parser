function adjust(item) {
  return item[0].concat(item[1].join(''));
}

function trim({desc, str, first, last}) {
  if ( str[0].match(first) && str[str.length - 1].match(last || first) ) {
    return str.slice(1, -1);
  }
  throw `Error. Could not parse "${desc}" in "${str}".`;
}

function trimBrackets(str) {
  return trim({
    desc: 'bracket',
    str: str,
    first: /\(/,
    last: /\)/,
  });
}

function trimQuotes(str) {
  return trim({
    desc: 'quote',
    str,
    first: /[\"\'\`]/
  });
}

function trimBracketsAndQuotes(str) {
  return trimQuotes(trimBrackets(str));
}
