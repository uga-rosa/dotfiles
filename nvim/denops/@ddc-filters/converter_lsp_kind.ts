import { BaseFilter, Item } from "https://deno.land/x/ddc_vim@v3.6.0/types.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  override filter(args: {
    items: Item[];
  }) {
    return Promise.resolve(args.items.map((item) => {
      if (item.kind === undefined) {
        item.kind = "Text";
      }
      if (item.kind in Kind2Icon) {
        item = {
          ...item,
          kind: `${Kind2Icon[item.kind as Kind]} ${item.kind}`,
          highlights: [
            ...item.highlights ?? [],
            {
              name: "ddc-kind-mark",
              type: "kind",
              hl_group: `CmpItemKind${item.kind}`,
              col: 0,
              width: byteLength(item.kind) + 4,
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

const ENCODER = new TextEncoder();
function byteLength(str: string) {
  return ENCODER.encode(str).length;
}

const Kind2Icon = {
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

type Kind = keyof typeof Kind2Icon;
