import { TSSnippet } from "https://deno.land/x/denippet_vim@v0.0.4/loader.ts";
import { Denops } from "https://deno.land/x/denippet_vim@v0.0.4/deps/denops.ts";
import { lsputil } from "https://deno.land/x/denippet_vim@v0.0.4/deps/lsp.ts";

export const snippets: Record<string, TSSnippet> = {
  ".if": {
    prefix: ".if",
    body: async (denops: Denops) => {
      const ctx = await lsputil.LineContext.create(denops);
      const lineBeforeCursor = ctx.text.slice(0, ctx.character);
      const variable = lineBeforeCursor.match(/\w(\w|\d)*$/)?.[0] ?? "$1";
      if (variable.length > 0) {
        await lsputil.linePatch(denops, variable.length, 0, "");
      }
      return [
        `if (${variable}) {`,
        `\t$0`,
        `}`,
      ];
    },
    description: "postfix comp: if statement",
  },
};
