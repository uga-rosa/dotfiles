import { BaseExtension, Lspoints } from "https://deno.land/x/lspoints@v0.0.3/interface.ts";
import { Denops, fn, lambda } from "../rc/deps/denops.ts";
import { applyWorkspaceEdit, LSP, makePositionParams, OffsetEncoding } from "../rc/deps/lsp.ts";
import { is, u } from "../rc/deps/unknownutil.ts";

export class Extension extends BaseExtension {
  initialize(denops: Denops, lspoints: Lspoints) {
    lspoints.defineCommands("rename", {
      execute: async () => {
        const clients = lspoints.getClients(await fn.bufnr(denops))
          .filter((c) => c.serverCapabilities.hoverProvider !== undefined);
        if (clients.length !== 1) {
          return;
        }
        const offsetEncoding = clients[0]?.serverCapabilities
          .positionEncoding as OffsetEncoding;
        const positionParams = await makePositionParams(denops, 0, 0, offsetEncoding);

        const inputParams = {
          prompt: "Rename",
          default: "",
        };

        try {
          const result = await lspoints.request(
            clients[0].name,
            "textDocument/prepareRename",
            positionParams,
          ) as
            | LSP.Range
            | { range: LSP.Range; placeholder: string }
            | { defaultBehavior: boolean }
            | null;

          if (result === null) {
            await denops.call("luaeval", `vim.notify("No symbol under cursor")`);
            return;
          } else if ("placeholder" in result) {
            inputParams.default = result.placeholder;
          }
        } catch {
          // throw
        }

        const id = lambda.register(denops, async (input: unknown) => {
          u.assert(input, is.String);
          const result = await lspoints.request(
            clients[0].name,
            "textDocument/rename",
            {
              ...positionParams,
              newName: input,
            },
          ) as LSP.WorkspaceEdit | null;
          if (result !== null) {
            await applyWorkspaceEdit(denops, result, offsetEncoding);
          }
        });

        await denops.call(
          "luaeval",
          `vim.ui.input(_A, function(input) vim.fn["denops#notify"]("${denops.name}", "${id}", { input }) end)`,
          inputParams,
        );
      },
    });
  }
}
