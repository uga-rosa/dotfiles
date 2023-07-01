import { BaseFilter, Item, PumHighlight } from "../rc/deps.ts";

const HIGHLIGHT_NAME = "ddc-lsp-kind";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  override filter(args: {
    items: Item[];
  }) {
    return Promise.resolve(args.items.map((item) => {
      item.kind = item.kind ?? "Text";
      if (item.kind in IconMap) {
        const kindName = item.kind as Kind;
        const icon = IconMap[kindName];
        const iconLength = IconLengthMap[kindName];
        const highlights = [
          ...item.highlights?.map((hl) => ({
            ...hl,
            col: hl.col + iconLength + 1,
          })) ?? [],
          {
            name: HIGHLIGHT_NAME,
            type: "abbr",
            hl_group: `CmpItemKind${item.kind}`,
            col: 1,
            width: iconLength,
          },
        ] satisfies PumHighlight[];
        item = {
          ...item,
          abbr: `${icon} ${item.abbr ?? item.word}`,
          kind: "",
          highlights,
        };
      }
      return item;
    }));
  }

  override params(): Params {
    return {};
  }
}

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
