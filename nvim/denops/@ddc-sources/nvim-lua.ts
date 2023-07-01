import {
  BaseSource,
  DdcGatherItems,
  GatherArguments,
  Item,
  OnCompleteDoneArguments,
} from "../rc/deps.ts";
import { LineContext, linePatch } from "../rc/util.ts";

type UserData = {
  name: string;
  help_tag: string;
};

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  async gather({
    denops,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    const ctx = await LineContext.create(denops);
    const [path] = ctx.text.slice(0, ctx.character).match(/\w[\w.]*$/) ?? [];
    if (path === undefined) {
      return [];
    }
    const parent = path.split(".");
    parent.pop();

    const items = await denops.call(
      "luaeval",
      `require("rc.ddc_sources.nvim_lua").items(_A)`,
      parent,
    ) as Item[];

    return items.map((item) => {
      const help_tag = parent[0] === "vim"
        ? parent[1] === "api" || parent[1] === "fn" ? item.word : [...parent, item.word].join(".")
        : "";
      return {
        ...item,
        user_data: {
          name: item.word,
          help_tag,
        },
      };
    });
  }

  async onCompleteDone({
    denops,
    userData,
  }: OnCompleteDoneArguments<Params, UserData>): Promise<void> {
    const name = userData.name;
    if (!/\W/.test(name)) {
      return;
    }

    const ctx = await LineContext.create(denops);
    if (!ctx.text.slice(0, ctx.character).endsWith(name)) {
      return;
    }

    await linePatch(denops, name.length + 1, 0, `["${name}"]`);
  }

  params(): Params {
    return {};
  }
}
