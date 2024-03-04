import { ActionFlags, ActionResult, Actions } from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { BaseKind } from "https://deno.land/x/ddu_vim@v3.10.2/base/kind.ts";

type Params = Record<never, never>;

export class Kind extends BaseKind<Params> {
  actions: Actions<Params> = {
    {{_input_:action name}}: async ({
      denops,
      items,
    }): Promise<ActionFlags | ActionResult> => {
      {{_cursor_}}
    },
  };

  params(): Params {
    return {};
  }
}
