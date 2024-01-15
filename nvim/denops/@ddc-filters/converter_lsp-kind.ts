import { BaseFilter, Item } from "../rc/deps/ddc.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  override filter(args: {
    items: Item[];
  }): Promise<Item[]> {
    return Promise.resolve(args.items.map((item) => {
      item.kind = item.kind ?? "Text";

      // nvim-lua
      if (item.kind in NvimLuaKind) {
        const luaType = item.kind as LuaType;
        item.kind = NvimLuaKind[luaType];
      }

      if (item.kind in IconMap) {
        const kindName = item.kind as Kind;
        item = {
          ...item,
          kind: IconMap[kindName],
          highlights: [
            ...item.highlights ?? [],
            {
              name: `ddc-lsp-kind-${kindName}`,
              type: "kind",
              hl_group: `CmpItemKind${item.kind}`,
              col: 1,
              width: IconLengthMap[kindName],
            },
          ],
        };
      }
      return item;
    }));
  }

  override params(): Params {
    return {};
  }
}

// :h luaref-type()
const NvimLuaKind = {
  nil: "Value",
  number: "Value",
  string: "Value",
  boolean: "Value",
  table: "Struct",
  function: "Function",
  thread: "Field",
  userdata: "Field",
} as const satisfies Record<string, Kind>;

type LuaType = keyof typeof NvimLuaKind;

const IconMap = {
  Text: "󰉿",
  Method: "󰆧",
  Function: "󰊕",
  Constructor: "",
  Field: "󰜢",
  Variable: "󰀫",
  Class: "󰠱",
  Interface: "",
  Module: "",
  Property: "󰜢",
  Unit: "󰑭",
  Value: "󰎠",
  Enum: "",
  Keyword: "󰌋",
  Snippet: "",
  Color: "󰏘",
  File: "󰈙",
  Reference: "󰈇",
  Folder: "󰉋",
  EnumMember: "",
  Constant: "󰏿",
  Struct: "󰙅",
  Event: "",
  Operator: "󰆕",
  TypeParameter: "",
} as const satisfies Record<string, string>;

type Kind = keyof typeof IconMap;

const ENCODER = new TextEncoder();
function byteLength(str: string) {
  return ENCODER.encode(str).length;
}

const IconLengthMap: Record<string, number> = {};
for (const [name, icon] of Object.entries(IconMap)) {
  IconLengthMap[name] = byteLength(icon);
}
IconLengthMap satisfies Record<Kind, number>;
