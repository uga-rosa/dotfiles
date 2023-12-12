import { BaseFilter, FilterArguments, Item } from "../rc/deps/ddc.ts";

type Params = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Params> {
  override filter({
    items,
    completeStr,
  }: FilterArguments<Params>): Promise<Item[]> {
    return Promise.resolve(items.sort((a, b) => {
      if (b.word === completeStr) {
        return 1
      } else if (a.word === completeStr) {
        return -1;
      } else {
        return 0;
      }
    }));
  }

  override params(): Params {
    return {};
  }
}
