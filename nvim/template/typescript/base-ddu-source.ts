import { BaseSource, Item } from "https://deno.land/x/ddu_vim@v3.4.1/types.ts";
import { GatherArguments } from "https://deno.land/x/ddu_vim@v3.4.1/base/source.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  gather({
    denops,
  }: GatherArguments<Params>): ReadableStream<Item[]> {
    return new ReadableStream({
      async start(controller) {
        {{_cursor_}}
      }
    })
  }

  params(): Params {
    return {};
  }
}
