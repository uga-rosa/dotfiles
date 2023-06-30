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
  fullpath: string;
};

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  async gather({
    denops,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    return await Promise.resolve().then(async () => {
      const ctx = await LineContext.create(denops);
      const [path] = ctx.text.slice(0, ctx.character).match(/\w[\w.]*$/) ?? [];
      if (path === undefined) {
        throw new Error("");
      }
      return path;
    }).then(async (path) => {
      const parent = path.split(".");
      parent.pop();
      const items = await denops.call(
        "luaeval",
        `require("rc.ddc_sources.nvim_lua").items(_A)`,
        parent,
      ) as Item[];
      return { items, parent: parent.join(".") };
    }).then(({ items, parent }) => {
      return items.map((item) => ({
        ...item,
        user_data: {
          name: item.word,
          fullpath: `${parent}.${item.word}`,
        },
      })) satisfies Item<UserData>[];
    }).catch(() => []);
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
