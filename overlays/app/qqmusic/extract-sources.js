// Write out seven of the official app.asar's files in the form the patches need.
//
// They are not stored as plain text, so the build has the shipped binary produce
// that form itself rather than taking a copy from anywhere else. It is run as
// plain node: the app never starts, so there is no window, no request, no login.
//
// It is Node 12 in there -- CommonJS only.
const fs = require("fs");
const path = require("path");

const [asar, out] = process.argv.slice(2);

const FILES = [
  "main.js",
  "preload.js",
  "index.js",
  "common.js",
  "lyric.js",
  "login.js",
  "common_dialog.js",
];

for (const file of FILES) {
  const text = fs.readFileSync(path.join(asar, file), "utf8");

  // A file that came out wrong would sail through the patches and only surface
  // as a blank window, so check here instead.
  const sample = text.slice(0, 4096);
  const printable =
    sample.replace(/[^\x09\x0a\x0d\x20-\x7e]/g, "").length / sample.length;
  if (printable < 0.9) {
    console.error(
      `extract-sources: ${file} does not look like source ` +
        `(${(printable * 100).toFixed(1)}% printable)`,
    );
    process.exit(1);
  }

  fs.writeFileSync(path.join(out, file), text);
  console.log(`extracted ${file} (${text.length} chars)`);
}
