import { BaseFilter, FilterArguments, Item } from "../rc/deps.ts";

type Params = {
  length: number;
};

export class Filter extends BaseFilter<Params> {
  override filter({
    items,
    completeStr,
    filterParams,
  }: FilterArguments<Params>): Promise<Item[]> {
    const prefix = completeStr.slice(0, filterParams.length);
    return Promise.resolve(
      items.filter((item) => /^\W/.test(item.word) || item.word.startsWith(prefix)),
    );
  }

  override params(): Params {
    return {
      length: 1,
    };
  }
}
