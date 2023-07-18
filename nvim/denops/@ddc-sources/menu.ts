import {
  autocmd,
  BaseSource,
  batch,
  DdcGatherItems,
  Denops,
  GatherArguments,
  Item,
  lambda,
  linePatch,
  OnCompleteDoneArguments,
  OnInitArguments,
} from "../rc/deps.ts";

type Params = {
  items: UserData[];
};

type UserData = {
  sourceName: string;
  lhs: string;
};

export class Source extends BaseSource<Params> {
  #lhsSet = new Set<string>();
  #augroup = "ddc-source-mode";

  async onInit({
    denops,
  }: OnInitArguments<Params>): Promise<void> {
    const id = lambda.register(denops, () => this.resetMap(denops));
    await autocmd.group(denops, this.#augroup, (helper) => {
      helper.define(
        "InsertLeave",
        "*",
        `call denops#notify('${denops.name}', '${id}', [])`,
      );
    });
  }

  private async resetMap(
    denops: Denops,
  ): Promise<void> {
    for (const lhs of this.#lhsSet) {
      await denops.cmd(`iunmap <buffer> ${lhs}`);
    }
    this.#lhsSet.clear();
  }

  async gather({
    denops,
    sourceParams,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    const items = sourceParams.items.map(({ sourceName, lhs }) => ({
      word: sourceName,
      kind: lhs,
      user_data: { sourceName, lhs },
    } satisfies Item<UserData>));
    await this.setMap(denops, items);
    return items;
  }

  private async setMap(
    denops: Denops,
    items: Item<UserData>[],
  ): Promise<void> {
    await batch(denops, async (denops) => {
      for (let i = 0; i < items.length; i++) {
        const { sourceName, lhs } = items[i].user_data!;
        this.#lhsSet.add(lhs);
        await denops.cmd(this.createMap(lhs, sourceName, i));
      }
    });
  }

  private createMap(
    lhs: string,
    sourceName: string,
    index: number,
  ): string {
    return `inoremap <buffer><expr> ${lhs} ` +
      `ddc#custom#patch_buffer(#{sources: ['${sourceName}']}) ?? ` +
      `ddc#map#insert_item(${index})`;
  }

  async onCompleteDone({
    denops,
    userData,
  }: OnCompleteDoneArguments<Params, UserData>): Promise<void> {
    await linePatch(denops, userData.sourceName.length, 0, "");
    await this.resetMap(denops);
  }

  params(): Params {
    return {
      items: [],
    };
  }
}
