import {
  BaseSource,
  Denops,
  fn,
  GatherArguments,
  Item,
  OnCompleteDoneArguments,
} from "../rc/deps.ts";

type MetaData = {
  vsnip: {
    snippet: string[];
  };
};

type Params = Record<string, never>;

export class Source extends BaseSource<Params> {
  async gather({
    denops,
  }: GatherArguments<Params>): Promise<Item<MetaData>[]> {
    const items = await denops.call(
      "vsnip#get_complete_items",
      await fn.bufnr(denops),
    ) as Item<string>[];
    return items.map((item) => ({
      ...item,
      menu: undefined,
      user_data: JSON.parse(item.user_data!),
    }));
  }

  async onCompleteDone({
    denops,
  }: OnCompleteDoneArguments<Params, MetaData>): Promise<void> {
    // No expansion unless confirmed by pum#map#confirm()
    const itemWord = await denops.eval(`v:completed_item.word`) as string;
    const ctx = await this.lineContext(denops);
    if (!ctx.text.endsWith(itemWord, ctx.character)) {
      return;
    }

    await denops.call("vsnip#expand");
  }

  private async lineContext(
    denops: Denops,
  ) {
    const beforeLine = await denops.eval(
      `getline(".")[:getcurpos()[2]-2]`,
    ) as string;
    const character = beforeLine.length;
    const text = await fn.getline(denops, ".");
    return { character, text };
  }

  params(): Params {
    return {};
  }
}
