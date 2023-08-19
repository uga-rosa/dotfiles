import { BaseSource, DdcGatherItems } from "https://deno.land/x/ddc_vim@v4.0.4/types.ts";
import { GatherArguments } from "https://deno.land/x/ddc_vim@v4.0.4/base/source.ts";

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
