import type { Denops } from "https://deno.land/x/denops_std@v6.3.0/mod.ts";
import * as lambda from "https://deno.land/x/denops_std@v6.3.0/lambda/mod.ts";
import * as api from "https://deno.land/x/denops_std@v6.3.0/function/nvim/mod.ts";
import { is } from "https://deno.land/x/unknownutil@v3.16.3/mod.ts";

export type Options = {
  noremap?: boolean;
  nowait?: boolean;
  silent?: boolean;
  script?: boolean;
  unique?: boolean;
  expr?: boolean;
  desc?: string;
  replace_keycodes?: boolean;
  buffer?: number | true;
  remap?: boolean;
  notify?: boolean;
};

export async function set(
  denops: Denops,
  mode: string | string[],
  lhs: string,
  rhs: string | ((denops: Denops) => void | string | Promise<void | string>),
  opts?: Options,
): Promise<void> {
  mode = is.String(mode) ? [mode] : mode;
  opts = { ...opts ?? {} };

  if (opts.expr && opts.replace_keycodes !== false) {
    opts.replace_keycodes = true;
  }

  if (opts.remap == null) {
    opts.noremap = true;
  } else {
    opts.noremap = !opts.remap;
    delete opts.remap;
  }

  if (!is.String(rhs)) {
    const rhsF = rhs;
    const id = lambda.register(denops, async () => await rhsF(denops));
    if (opts.expr) {
      rhs = `denops#request("${denops.name}", "${id}")`;
    } else {
      const func = `denops#${opts.notify ? "notify" : "request"}`;
      rhs = `<Cmd>call ${func}("${denops.name}", "${id}", [])<CR>`;
    }
    delete opts.notify;
  }

  if (opts.buffer != null) {
    const bufnr = opts.buffer === true ? 0 : opts.buffer;
    delete opts.buffer;
    for (const m of mode) {
      await api.nvim_buf_set_keymap(denops, bufnr, m, lhs, rhs, opts);
    }
  } else {
    for (const m of mode) {
      await api.nvim_set_keymap(denops, m, lhs, rhs, opts);
    }
  }
}
