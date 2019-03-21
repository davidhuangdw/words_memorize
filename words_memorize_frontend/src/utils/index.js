export function splitLines(str) {
  return str
    .split("\\n")
    .map(line => `<p>${line}</p>`)
    .join("");
}
