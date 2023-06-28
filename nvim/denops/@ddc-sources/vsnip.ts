import { BaseSource, Item } from "https://deno.land/x/ddc_vim@v3.7.2/types.ts";
import { Denops, fn } from "https://deno.land/x/ddc_vim@v3.7.2/deps.ts";
import { OnCompleteDoneArguments } from "https://deno.land/x/ddc_vim@v3.7.2/base/source.ts";

type MetaData = {
  vsnip: {
    snippet: string[];
  };
};

type Params = Record<string, never>;

export class Source extends BaseSource<Params> {
  async gather(args: {
    denops: Denops;
  }): Promise<Item<MetaData>[]> {
    const items = await args.denops.call(
      "vsnip#get_complete_items",
      await fn.bufnr(args.denops),
    ) as Item<string>[];
    return items.map((item) => ({
      ...item,
      menu: undefined,
      user_data: JSON.parse(item.user_data ?? "{}"),
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
