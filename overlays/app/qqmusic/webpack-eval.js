// Turn webpack's eval("...") module wrappers inside out, and back again.
//
// This bundle was built with devtool: eval, so every module's source is a string
// argument to eval() -- one enormous line. prettier cannot reach inside it, so a
// patch could only ever replace the whole line, which would put a megabyte of
// Tencent's code in this repository for the sake of a ten-line change. So unwrap
// the strings into real files, let the patches be ordinary line diffs, and fold
// them back afterwards.
//
// Folding back cannot re-derive the bundler's escaping -- it spells some tabs
// \t and one > as \x3e -- so it does not try. A module the patches left alone
// keeps its original literal untouched, and only a module that changed is
// escaped afresh, which is checked by decoding it again.
//
// It is Node 12 in here -- CommonJS, and no optional chaining.
const fs = require("fs");
const path = require("path");

const [mode, appDir, modDir] = process.argv.slice(2);

// Every eval("...") in the file, as {start, end, quote} over the literal.
function scan(text) {
  const found = [];
  let i = 0;
  for (;;) {
    const at = text.indexOf("eval(", i);
    if (at < 0) return found;
    let j = at + 5;
    while (/\s/.test(text[j])) j++;
    const quote = text[j];
    if (quote !== '"' && quote !== "'") {
      i = at + 5;
      continue;
    }
    let k = j + 1;
    for (; k < text.length; k++) {
      if (text[k] === "\\") {
        k++;
        continue;
      }
      if (text[k] === quote) break;
    }
    if (k >= text.length) {
      i = at + 5;
      continue;
    }
    found.push({ start: j, end: k + 1, quote: quote });
    i = k + 1;
  }
}

function escape(source, quote) {
  return (
    quote +
    source
      .split("\\").join("\\\\")
      .split(quote).join("\\" + quote)
      .split("\n").join("\\n")
      .split("\t").join("\\t")
      .split("\r").join("\\r") +
    quote
  );
}

// The module id webpack registered the wrapper under, for a readable filename.
function nameOf(text, start, taken) {
  const before = text.slice(Math.max(0, start - 400), start);
  const ids = before.match(/(\d+):\s*(?:function\s*)?\(/g);
  const id = ids ? ids[ids.length - 1].match(/\d+/)[0] : "anon";
  let name = id;
  for (let n = 2; taken[name]; n++) {
    name = id + "-" + n;
  }
  taken[name] = true;
  return name;
}

const bundles = fs.readdirSync(appDir).filter((f) => f.endsWith(".js")).sort();
let modules = 0;
let changed = 0;

for (const bundle of bundles) {
  const file = path.join(appDir, bundle);
  const text = fs.readFileSync(file, "utf8");
  const found = scan(text);
  if (!found.length) continue;

  const dir = path.join(modDir, bundle.replace(/\.js$/, ""));
  const taken = {};

  if (mode === "unwrap") {
    fs.mkdirSync(dir, { recursive: true });
    for (const at of found) {
      const name = nameOf(text, at.start, taken);
      fs.writeFileSync(path.join(dir, name + ".js"), eval(text.slice(at.start, at.end)));
      modules++;
    }
  } else if (mode === "rewrap") {
    let out = "";
    let cut = 0;
    for (const at of found) {
      const literal = text.slice(at.start, at.end);
      const name = nameOf(text, at.start, taken);
      const source = fs.readFileSync(path.join(dir, name + ".js"), "utf8");
      let replacement = literal;
      if (source !== eval(literal)) {
        replacement = escape(source, at.quote);
        if (eval(replacement) !== source) {
          console.error(`webpack-eval: cannot escape ${bundle}/${name}`);
          process.exit(1);
        }
        changed++;
      }
      out += text.slice(cut, at.start) + replacement;
      cut = at.end;
      modules++;
    }
    fs.writeFileSync(file, out + text.slice(cut));
  } else {
    console.error(`webpack-eval: unknown mode ${mode}`);
    process.exit(1);
  }
}

if (!modules) {
  console.error("webpack-eval: no bundle had an eval wrapper");
  process.exit(1);
}
console.log(
  mode === "unwrap"
    ? `unwrapped ${modules} modules`
    : `rewrapped ${modules} modules, ${changed} changed`,
);
