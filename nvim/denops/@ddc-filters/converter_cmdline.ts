import { BaseFilter, Item, PumHighlight } from "../rc/deps/ddc.ts";

const highlight: PumHighlight = {
  type: "kind",
  name: "",
  hl_group: "NightflyEmerald",
  col: 1,
  width: 3,
};

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  override filter(args: {
    items: Item[];
  }) {
    return Promise.resolve(args.items.map((item) => ({
      ...item,
      kind: "",
      highlights: [
        ...item.highlights ?? [],
        highlight,
      ],
    })));
  }

  override params(): Params {
    return {};
  }
}
