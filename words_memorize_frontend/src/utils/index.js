import _ from "lodash";

export function splitLines(str) {
  return str
    .split("\\n")
    .map(line => `<p>${line}</p>`)
    .join("");
}

export const str_bits_count = bits_str =>
  _.reduce(bits_str, (sum, ch) => sum + (ch === "1"), 0);

export const str_bits_ratio = (bits_str, maxLen) =>
  str_bits_count(bits_str) / Math.min(maxLen, bits_str.length);

export const bisect_right = (arr, v) => {
  let l = 0;
  let r = arr.length - 1;
  while (l <= r) {
    let m = (l + r) >> 1;
    if (arr[m] <= v) l = m + 1;
    else r = m - 1;
  }
  return l;
};

export const random_pick_acc_arr = acc_arr => {
  const sum = acc_arr[acc_arr.length - 1];
  const rnd = _.random(true) * sum;
  return bisect_right(acc_arr, rnd) - 1;
};

export const default_error_strategy = input_size =>
  Math.min(2, _.toInteger(input_size / 4));
