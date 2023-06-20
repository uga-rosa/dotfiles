import { BaseKind } from "https://deno.land/x/ddu_vim@v3.2.1/types.ts";

type Params = Record<never, never>;

export class Kind extends BaseKind<Params> {
  params() {
    return {};
  }
}
