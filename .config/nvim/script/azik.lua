local rule = {
  -- 関数
  [" "] = "henkanFirst",
  ["/"] = "abbrev",
  -- 通常
  ["!"] = { "！", "" },
  ["?"] = { "？", "" },
  [","] = { "、", "" },
  ["."] = { "。", "" },
  ["a"] = { "あ", "" },
  ["i"] = { "い", "" },
  ["u"] = { "う", "" },
  ["e"] = { "え", "" },
  ["o"] = { "お", "" },
  ["["] = { "「", "" },
  ["]"] = { "」", "" },
  -- 促音、撥音、長音符
  -- US配列 + コロン、セミコロン入替
  -- 'はsticky shiftに
  q = { "ん", "" },
  [":"] = { "っ", "" },
  [";"] = { "：", "" },
  ["-"] = { "ー", "" },
}

local function set_key(key, val)
  if type(val) == "string" and val ~= "" then
    rule[key] = { val, "" }
  elseif type(val) == "table" and val[1] ~= "" then
    rule[key] = { table.concat(val), "" }
  end
end

---@param s string
---@param row? string[]
---@param spc_rule? table
local function set_rule(s, row, spc_rule)
  if row then
    local a, i, u, e, o = unpack(row)
    set_key(s .. "a", a)
    set_key(s .. "i", i)
    set_key(s .. "u", u)
    set_key(s .. "e", e)
    set_key(s .. "o", o)
    -- 撥音拡張
    set_key(s .. "z", { a, "ん" })
    set_key(s .. "k", { i, "ん" })
    set_key(s .. "j", { u, "ん" })
    set_key(s .. "d", { e, "ん" })
    set_key(s .. "l", { o, "ん" })
    -- 撥音拡張互換
    set_key(s .. "n", { a, "ん" })
    -- 二重母音拡張
    set_key(s .. "q", { a, "い" })
    set_key(s .. "h", { u, "う" })
    set_key(s .. "w", { e, "い" })
    set_key(s .. "p", { o, "う" })
  end
  -- 例外
  for k, v in pairs(spc_rule or {}) do
    set_key(k, v)
  end
end

-- 仕様
-- http://hp.vector.co.jp/authors/VA002116/azik/azikinfo.htm#itiran

-- 清音
-- あ行は特殊なルールもないので上
set_rule("k", { "か", "き", "く", "け", "こ" })
set_rule("s", { "さ", "し", "す", "せ", "そ" })
set_rule("t", { "た", "ち", "つ", "て", "と" }, { tsa = "つぁ" })
set_rule("n", { "な", "に", "ぬ", "ね", "の" }, { nn = "ん" })
set_rule("h", { "は", "ひ", "ふ", "へ", "ほ" })
set_rule("f", { "ふぁ", "ふぃ", "ふ", "ふぇ", "ふぉ" }, { fp = "ふぉー" })
set_rule("m", { "ま", "み", "む", "め", "も" }, { mn = "もの" })
set_rule("y", { "や", "", "ゆ", "", "よ" })
set_rule("r", { "ら", "り", "る", "れ", "ろ" })
set_rule("w", { "わ", "うぃ", "", "うぇ", "を" }, { wl = "うぉん", wp = "うぉー" })

-- 濁音、半濁音
set_rule("g", { "が", "ぎ", "ぐ", "げ", "ご" })
set_rule("z", { "ざ", "じ", "ず", "ぜ", "ぞ" }, { zc = "ざ", zv = "ざい", zx = "ぜい" })
set_rule("d", { "だ", "ぢ", "づ", "で", "ど" })
set_rule("b", { "ば", "び", "ぶ", "べ", "ぼ" })
set_rule("p", { "ぱ", "ぴ", "ぷ", "ぺ", "ぽ" })

-- 拗音、拗音互換
set_rule("ky", { "きゃ", "", "きゅ", "きぇ", "きょ" })
set_rule("kg", { "きゃ", "", "きゅ", "きぇ", "きょ" })
set_rule("sy", { "しゃ", "", "しゅ", "しぇ", "しょ" })
set_rule("x", { "しゃ", "", "しゅ", "しぇ", "しょ" })
set_rule("ty", { "ちゃ", "", "ちゅ", "ちぇ", "ちょ" })
set_rule("c", { "ちゃ", "", "ちゅ", "ちぇ", "ちょ" })
set_rule("ny", { "にゃ", "", "にゅ", "にぇ", "にょ" })
set_rule("ng", { "にゃ", "", "にゅ", "にぇ", "にょ" })
set_rule("hy", { "ひゃ", "", "ひゅ", "ひぇ", "ひょ" })
set_rule("hg", { "ひゃ", "", "ひゅ", "ひぇ", "ひょ" })
set_rule("my", { "みゃ", "", "みゅ", "みぇ", "みょ" })
set_rule("mg", { "みゃ", "", "みゅ", "みぇ", "みょ" })
set_rule("ry", { "りゃ", "", "りゅ", "りぇ", "りょ" })

-- 拗音 (濁音、半濁音)
set_rule("gy", { "ぎゃ", "", "ぎゅ", "ぎぇ", "ぎょ" })
set_rule("zy", { "じゃ", "", "じゅ", "じぇ", "じょ" })
set_rule("j", { "じゃ", "じ", "じゅ", "じぇ", "じょ" })
set_rule("by", { "びゃ", "", "びゅ", "びぇ", "びょ" })
set_rule("py", { "ぴゃ", "", "ぴゅ", "ぴぇ", "ぴょ" })
set_rule("pg", { "ぴゃ", "", "ぴゅ", "ぴぇ", "ぴょ" })

-- 拗音 (外来語、他) (f, wは清音)
set_rule("v", { "ヴぁ", "ヴぃ", "ヴ", "ヴぇ", "ヴぉ" })
set_rule("tg", { "", "てぃ", "とぅ", "", "" })
set_rule("dc", { "", "でぃ", "どぅ", "", "" })
set_rule("ws", { "", "", "", "", "うぉ" })
set_rule("l", { "ぁ", "ぃ", "ぅ", "ぇ", "ぉ" })
set_rule("ly", { "ゃ", "", "ゅ", "", "ょ" })

-- 特殊拡張
set_rule("", nil, {
  kt = "こと",
  st = "した",
  tt = "たち",
  ht = "ひと",
  wt = "わた",
  mn = "もの",
  ms = "ます",
  ds = "です",
  km = "かも",
  tm = "ため",
  dm = "でも",
  kr = "から",
  sr = "する",
  tr = "たら",
  nr = "なる",
  yr = "よる",
  rr = "られ",
  zr = "ざる",
  mt = "また",
  tb = "たび",
  nb = "ねば",
  bt = "びと",
  gr = "がら",
  gt = "ごと",
  nt = "にち",
  dt = "だち",
  wr = "われ",
})

-- 独自
set_rule("", nil, {
  -- 矢印
  ["vh"] = "←",
  ["vj"] = "↓",
  ["vk"] = "↑",
  ["vl"] = "→",
})

local path = debug.getinfo(1, "S").source:sub(2)
vim.fn.writefile({vim.json.encode(rule)}, vim.fn.fnamemodify(path, ':r') .. ".json")
