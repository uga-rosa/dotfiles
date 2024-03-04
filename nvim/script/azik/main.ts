import { join } from "https://deno.land/std@0.218.2/path/mod.ts";
import { hiraToKata } from "./hira_kata.ts";
import { kataToHanKata } from "./hira_hankata.ts";

const rule: { [key: string]: [string, string] } = {
  // あ行
  ["a"]: ["あ", ""],
  ["i"]: ["い", ""],
  ["u"]: ["う", ""],
  ["e"]: ["え", ""],
  ["o"]: ["お", ""],
  // 記号
  ["!"]: ["！", ""],
  ["@"]: ["＠", ""],
  ["#"]: ["＃", ""],
  ["$"]: ["＄", ""],
  ["%"]: ["％", ""],
  ["^"]: ["＾", ""],
  ["&"]: ["＆", ""],
  ["*"]: ["＊", ""],
  ["("]: ["（", ""],
  [")"]: ["）", ""],
  ["_"]: ["＿", ""],
  ["="]: ["＝", ""],
  ["+"]: ["＋", ""],
  ["["]: ["「", ""],
  ["]"]: ["」", ""],
  ["\\"]: ["＼", ""],
  ["|"]: ["｜", ""],
  ['"']: ["＂", ""],
  [","]: ["、", ""],
  ["<"]: ["＜", ""],
  ["."]: ["。", ""],
  [">"]: ["＞", ""],
  ["?"]: ["？", ""],
  // 促音、撥音、長音符
  // US配列 + コロン、セミコロン入替
  // 'はsticky shiftに
  ["q"]: ["ん", ""],
  [";"]: ["っ", ""],
  [":"]: ["：", ""],
  ["-"]: ["ー", ""],
};

const set_key = (key: string, val: string | string[]) => {
  if (typeof val === "string" && val !== "") {
    rule[key] = [val, ""];
  } else if (typeof val === "object" && val[0] !== "") {
    rule[key] = [val.join(""), ""];
  }
};

const set_rule = (
  s: string,
  row?: string[],
  spc_rule?: { [key: string]: string },
) => {
  if (row && row.length === 5) {
    const [a, i, u, e, o] = row;
    set_key(s + "a", a);
    set_key(s + "i", i);
    set_key(s + "u", u);
    set_key(s + "e", e);
    set_key(s + "o", o);
    // 撥音拡張
    set_key(s + "z", [a, "ん"]);
    set_key(s + "k", [i, "ん"]);
    set_key(s + "j", [u, "ん"]);
    set_key(s + "d", [e, "ん"]);
    set_key(s + "l", [o, "ん"]);
    // 撥音拡張互換
    set_key(s + "n", [a, "ん"]);
    // 二重母音拡張
    set_key(s + "q", [a, "い"]);
    set_key(s + "h", [u, "う"]);
    set_key(s + "w", [e, "い"]);
    set_key(s + "p", [o, "う"]);
  }
  Object.entries(spc_rule || {}).forEach(([key, value]) => set_key(key, value));
};

// 仕様
// http://hp.vector.co.jp/authors/VA002116/azik/azikinfo.htm#itiran

// 清音
// あ行は特殊なルールもないので上
set_rule("k", ["か", "き", "く", "け", "こ"]);
set_rule("s", ["さ", "し", "す", "せ", "そ"]);
set_rule("t", ["た", "ち", "つ", "て", "と"], {
  tsa: "つぁ",
});
set_rule("n", ["な", "に", "ぬ", "ね", "の"], {
  nn: "ん",
});
set_rule("h", ["は", "ひ", "ふ", "へ", "ほ"]);
set_rule("f", ["ふぁ", "ふぃ", "ふ", "ふぇ", "ふぉ"], {
  fp: "ふぉー",
});
set_rule("m", ["ま", "み", "む", "め", "も"], {
  mn: "もの",
});
set_rule("y", ["や", "", "ゆ", "", "よ"]);
set_rule("r", ["ら", "り", "る", "れ", "ろ"]);
set_rule("w", ["わ", "うぃ", "", "うぇ", "を"], {
  wl: "うぉん",
  wp: "うぉー",
});

// 濁音、半濁音
set_rule("g", ["が", "ぎ", "ぐ", "げ", "ご"]);
set_rule("z", ["ざ", "じ", "ず", "ぜ", "ぞ"], {
  zc: "ざ",
  zv: "ざい",
  zx: "ぜい",
});
set_rule("d", ["だ", "ぢ", "づ", "で", "ど"]);
set_rule("b", ["ば", "び", "ぶ", "べ", "ぼ"]);
set_rule("p", ["ぱ", "ぴ", "ぷ", "ぺ", "ぽ"]);

// 拗音、拗音互換
set_rule("ky", ["きゃ", "", "きゅ", "きぇ", "きょ"]);
set_rule("kg", ["きゃ", "", "きゅ", "きぇ", "きょ"]);
set_rule("sy", ["しゃ", "", "しゅ", "しぇ", "しょ"]);
set_rule("x", ["しゃ", "", "しゅ", "しぇ", "しょ"]);
set_rule("ty", ["ちゃ", "", "ちゅ", "ちぇ", "ちょ"]);
set_rule("c", ["ちゃ", "", "ちゅ", "ちぇ", "ちょ"]);
set_rule("ny", ["にゃ", "", "にゅ", "にぇ", "にょ"]);
set_rule("ng", ["にゃ", "", "にゅ", "にぇ", "にょ"]);
set_rule("hy", ["ひゃ", "", "ひゅ", "ひぇ", "ひょ"]);
set_rule("hg", ["ひゃ", "", "ひゅ", "ひぇ", "ひょ"]);
set_rule("my", ["みゃ", "", "みゅ", "みぇ", "みょ"]);
set_rule("mg", ["みゃ", "", "みゅ", "みぇ", "みょ"]);
set_rule("ry", ["りゃ", "", "りゅ", "りぇ", "りょ"]);

// 拗音 (濁音、半濁音)
set_rule("gy", ["ぎゃ", "", "ぎゅ", "ぎぇ", "ぎょ"]);
set_rule("zy", ["じゃ", "", "じゅ", "じぇ", "じょ"]);
set_rule("j", ["じゃ", "じ", "じゅ", "じぇ", "じょ"]);
set_rule("by", ["びゃ", "", "びゅ", "びぇ", "びょ"]);
set_rule("py", ["ぴゃ", "", "ぴゅ", "ぴぇ", "ぴょ"]);
set_rule("pg", ["ぴゃ", "", "ぴゅ", "ぴぇ", "ぴょ"]);

// 拗音 (外来語、他) (f, wは清音)
set_rule("v", ["ヴぁ", "ヴぃ", "ヴ", "ヴぇ", "ヴぉ"]);
set_rule("tg", ["", "てぃ", "とぅ", "", ""]);
set_rule("dc", ["", "でぃ", "どぅ", "", ""]);
set_rule("ws", ["", "", "", "", "うぉ"]);
set_rule("l", ["ぁ", "ぃ", "ぅ", "ぇ", "ぉ"]);
set_rule("ly", ["ゃ", "", "ゅ", "", "ょ"]);

// 特殊拡張
// deno-fmt-ignore
set_rule("", undefined, {
  kt: "こと", st: "した", tt: "たち", ht: "ひと",
  wt: "わた", mn: "もの", ms: "ます", ds: "です",
  km: "かも", tm: "ため", dm: "でも", kr: "から",
  sr: "する", tr: "たら", nr: "なる", yr: "よる",
  rr: "られ", zr: "ざる", mt: "また", tb: "たび",
  nb: "ねば", bt: "びと", gr: "がら", gt: "ごと",
  nt: "にち", dt: "だち", wr: "われ",
});

// 独自
set_rule("", undefined, {
  // 矢印等
  ["vh"]: "←",
  ["vj"]: "↓",
  ["vk"]: "↑",
  ["vl"]: "→",
  ["v/"]: "・",
  ["v,"]: "‥",
  ["v."]: "...",
  ["v-"]: "〜",
  ["v["]: "『",
  ["v]"]: "』",
});

// For skkeleton
const dirname = new URL(".", import.meta.url).pathname;
Deno.writeTextFileSync(
  join(dirname, "skkeleton.json"),
  JSON.stringify(rule, undefined, 2) + "\n",
);

set_rule("", undefined, {
  // 数値
  ["0"]: "0",
  ["1"]: "1",
  ["2"]: "2",
  ["3"]: "3",
  ["4"]: "4",
  ["5"]: "5",
  ["6"]: "6",
  ["7"]: "7",
  ["8"]: "8",
  ["9"]: "9",
});

// For CorvusSKK
Deno.writeTextFileSync(
  join(dirname, "azik_corvus.txt"),
  Object.entries(rule).reduce((acc, cur) => {
    const [rom, [hira, _]] = cur;
    const kata = hiraToKata(hira);
    const hankata = kataToHanKata(kata);
    return acc + [rom, hira, kata, hankata, 0].join("\t") + "\n";
  }, ""),
);
