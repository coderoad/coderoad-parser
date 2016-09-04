'use strict';

// https://github.com/sindresorhus/repeating/blob/master/index.js
// https://github.com/sindresorhus/indent-string/blob/master/index.js

const repeating = (n, str) => {
	str = str === undefined ? ' ' : str;
	let ret = '';
	do {
		if (n & 1) {
			ret += str;
		}
		str += str;
	} while ((n >>= 1));
	return ret;
}

module.exports = (str, count) => {
	let indent = ' ';
	count = count === undefined ? 1 : count;

	if (typeof str !== 'string') {
		throw new TypeError(`Expected \`input\` to be a \`string\`, got \`${typeof str}\``);
	}

	if (typeof count !== 'number') {
		throw new TypeError(`Expected \`count\` to be a \`number\`, got \`${typeof count}\``);
	}

	if (count === 0) {
		return str;
	}

	indent = count > 1 ? repeating(count, indent) : indent;

	return str.replace(/^(?!\s*$)/mg, indent);
};
