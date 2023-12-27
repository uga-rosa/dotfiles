import { BaseFilter, DduItem, FilterArguments } from "../rc/deps/ddu.ts";

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
