import {
  BaseExtension,
  Lspoints,
} from "https://deno.land/x/lspoints@v0.0.1/interface.ts";
import {
  makePositionParams,
  OffsetEncoding,
} from "https://deno.land/x/denops_lsputil@v0.6.2/mod.ts";
import { Denops, fn, LSP, u } from "../rc/deps.ts";

function splitLines(s: string): string[] {
  return s.replaceAll(/\r\n?/g, "\n")
    .replaceAll("<br>", "\n")
    .split("\n")
    .filter(Boolean);
}

export class Extension extends BaseExtension {
  initialize(denops: Denops, lspoints: Lspoints) {
    lspoints.defineCommands("hover", {
      execute: async () => {
        const clients = lspoints.getClients(await fn.bufnr(denops))
          .filter((c) => c.serverCapabilities.hoverProvider !== undefined);
        const offsetEncoding = clients[0]?.serverCapabilities
          .positionEncoding as OffsetEncoding;
        const params = await makePositionParams(denops, 0, 0, offsetEncoding);
        const result = await lspoints.request(
          clients[0].name,
          "textDocument/hover",
          params,
        ) as LSP.Hover | null;
        if (result === null) {
          denops.cmd(`echoerr 'No information'`);
          return;
        }
        const contents = result.contents;

        const lines: string[] = [];
        let format = "markdown";

        const parseMarkedString = (ms: LSP.MarkedString) => {
          if (u.isString(ms)) {
            lines.push(...splitLines(ms));
          } else {
            lines.push("```" + ms.language, ...splitLines(ms.value), "```");
          }
        };

        if (u.isString(contents) || "language" in contents) {
          // MarkedString
          parseMarkedString(contents);
        } else if (u.isArray(contents)) {
          // MarkedString[]
          contents.forEach(parseMarkedString);
        } else if ("kind" in contents) {
          // MarkupContent
          if (contents.kind === "plaintext") {
            format = "plaintext";
          }
          lines.push(...splitLines(contents.value));
        }

        await denops.call(
          "luaeval",
          `vim.lsp.util.open_floating_preview(_A[1], _A[2], { border = "single", title = "Hover" })`,
          [lines, format],
        );
      },
    });
  }
}
