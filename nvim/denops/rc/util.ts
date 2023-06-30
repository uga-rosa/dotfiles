import { Denops, fn, LSP, nvim } from "./deps.ts";

export class LineContext {
  // utf-16 offset
  character: number;
  text: string;

  constructor(
    character: number,
    text: string,
  ) {
    this.character = character;
    this.text = text;
  }

  static async create(
    denops: Denops,
  ) {
    const beforeLine = await denops.eval(
      `getline('.')[:col('.')-2]`,
    ) as string;
    const character = beforeLine.length;
    const text = await fn.getline(denops, ".");
    return new LineContext(character, text);
  }
}

function createRange(
  startLine: number,
  startCharacter: number,
  endLine: number,
  endCharacter: number,
): LSP.Range {
  return {
    start: { line: startLine, character: startCharacter },
    end: { line: endLine, character: endCharacter },
  };
}

export async function linePatch(
  denops: Denops,
  before: number,
  after: number,
  text: string,
): Promise<void> {
  const ctx = await LineContext.create(denops);
  const line = await fn.line(denops, ".") - 1;
  const range = createRange(line, ctx.character - before, line, ctx.character + after);
  await denops.call(
    "luaeval",
    `vim.lsp.util.apply_text_edits(_A, 0, "utf-16")`,
    [{ range, newText: text }],
  );
  await setCursor(denops, {
    line,
    character: ctx.character - before + text.length,
  });
}

// (0,0)-index, utf-16
export async function setCursor(
  denops: Denops,
  position: LSP.Position,
): Promise<void> {
  const lnum = position.line + 1;
  const line = await fn.getline(denops, lnum);
  const col = byteLength(line.slice(0, position.character));
  await nvim.nvim_win_set_cursor(denops, 0, [lnum, col]);
}

const ENCODER = new TextEncoder();
function byteLength(str: string): number {
  return ENCODER.encode(str).length;
}
