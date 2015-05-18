#!/bin/bash
app_name=${1:-$(basename $PWD)}
cat <<PACKAGE > package.json
{
  "name": "$app_name",
  "version": "0.0.1",
  "main": "main.js", 
  "scripts": {
    "lint": "npm run lint-json && npm run lint-js && npm run lint-js-style",
    "lint-json": "jsonlint -q package.json .jscsrc .jshintrc",
    "lint-js": "jshint .",
    "lint-js-style": "jscs ."
  }
}
PACKAGE
[ -f main.js ] || touch main.js
CAT <<JSCRC > .jscrc
{
  "preset": "crockford",
  "validateIndentation": 2,
  "excludeFiles": ["node_modules", "bower_components"]
}
JSCRC

CAT <<JSHINTIGNORE > .jshintignore
**/node_modules
**/bower_components
JSHINTIGNORE

CAT <<'JSHINT' > .jshintrc
{
  "camelcase": true,    // Require variable names to be camelCased
  "curly": true,        // Require {} following if, for, while and do statements
  "eqeqeq": true,       // Require `===` and `!==`
  "forin": true,        // Require all `for in` statements to filter `hasOwnProperty`
  "immed": true,        // Require IIFEs to be wrapped in parens e.g. `(function () { } ());`
  "indent": 2,          // Require indentation of 2 spaces
  "newcap": true,       // Require capitalization of constructor functions e.g. `new F()`
  "noarg": true,        // Prohibit use of deprecated `arguments.caller` and `arguments.callee`
  "nonbsp": true,       // Prohibit UTF-8 breaking nbsp characters
  "nonew": true,        // Prohibit use of constructor functions for side-effects
  "quotmark": "single", // Require single quotes for consistency
  "undef": true,        // Require all variables be declared
  "unused": true,       // Require all variables to be used
  "strict": true,       // Require ES5 Strict mode
  "maxlen": 120,        // Require all lines to be less than 120 characters long
  "node": true          // Defines node specific global variables (REMOVE IF PROJECT SPECIFIC)
}
JSHINT
