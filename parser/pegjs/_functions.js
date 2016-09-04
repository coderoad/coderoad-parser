function flatten(items) {
  const flat = [];
  items.forEach(item => {
    if (Array.isArray(item)) {
      flat.push(...flatten(item));
    } else {
      flat.push(item);
    }
  });
  return flat;
}

function adjust(item) {
  let flat = flatten(item);
  if (flat[flat.length - 1] === '\n') {
    flat = flat.slice(0, -1);
  }
  return flat.join('');
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
