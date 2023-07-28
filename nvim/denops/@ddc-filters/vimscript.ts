import { BaseFilter, Item } from "https://deno.land/x/ddc_vim@v3.9.0/types.ts";
import { FilterArguments } from "https://deno.land/x/ddc_vim@v3.9.0/base/filter.ts";

type Params = {
  funcname?: string;
  eval?: string;
};

export class Filter extends BaseFilter<Params> {
  async filter({
    denops,
    items,
    filterParams,
  }: FilterArguments<Params>): Promise<Item[]> {
    if (filterParams.funcname) {
      return await denops.call(filterParams.funcname, items) as Item[];
    } else if (filterParams.eval) {
      return await denops.eval(filterParams.eval, { items }) as Item[];
    }
    return items;
  }

  params(): Params {
    return {};
  }
}
