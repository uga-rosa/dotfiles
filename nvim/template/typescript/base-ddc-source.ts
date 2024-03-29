import { BaseSource, DdcGatherItems } from "https://deno.land/x/ddc_vim@v4.3.1/types.ts";
import { GatherArguments } from "https://deno.land/x/ddc_vim@v4.3.1/base/source.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  async gather({
    denops,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    {{_cursor_}}
  }

  params(): Params {
    return {};
  }
}
