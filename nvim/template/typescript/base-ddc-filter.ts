import { BaseFilter, Item } from "https://deno.land/x/ddc_vim@v3.9.0/types.ts";
import { FilterArguments } from "https://deno.land/x/ddc_vim@v3.9.0/base/filter.ts";

type Params = Record<never, never>;

export class Filter extends BaseFilter<Params> {
  async filter({
    items,
  }: FilterArguments<Params>): Promise<Item[]> {
    {{_cursor_}}
  }

  params(): Params {
    return {};
  }
}
