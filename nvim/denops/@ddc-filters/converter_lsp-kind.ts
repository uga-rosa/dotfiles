import { BaseFilter, Item } from "https://deno.land/x/ddc_vim@v3.7.2/types.ts";

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
        const kindWithIcon = `${Kind2Icon[item.kind as Kind]} ${item.kind}`;
        item = {
          ...item,
          kind: kindWithIcon,
          highlights: [
            ...item.highlights ?? [],
            {
              name: "ddc-kind-mark",
              type: "kind",
              hl_group: `CmpItemKind${item.kind}`,
              col: 1,
              width: byteLength(kindWithIcon),
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
