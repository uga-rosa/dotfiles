import { DduItem } from "https://deno.land/x/ddu_vim@v3.5.1/types.ts";
import { BaseFilter, FilterArguments } from "https://deno.land/x/ddu_vim@v3.5.1/base/filter.ts";

type Params = {
  funcname?: string;
  eval?: string;
};

export class Filter extends BaseFilter<Params> {
  async filter({
    denops,
    items,
    filterParams,
  }: FilterArguments<Params>): Promise<DduItem[]> {
    if (filterParams.funcname) {
      return await denops.call(filterParams.funcname, items) as DduItem[];
    } else if (filterParams.eval) {
      return await denops.eval(filterParams.eval, { items }) as DduItem[];
    }
    return items;
  }

  params(): Params {
    return {};
  }
}
