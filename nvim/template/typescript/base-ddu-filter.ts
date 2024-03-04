import { DduItem } from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { BaseFilter, FilterArguments } from "https://deno.land/x/ddu_vim@v3.10.2/base/filter.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  async filter({
    denops,
    items,
  }: FilterArguments<Params>): Promise<DduItem[]> {
    {{_cursor_}}
  }

  params(): Params {
    return {};
  }
}
