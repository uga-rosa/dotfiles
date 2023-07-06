import { BaseSource, DdcGatherItems, GatherArguments } from "../rc/deps.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params> {
  override gather(args: GatherArguments<Params>): Promise<DdcGatherItems> {
    console.log(args);
    return Promise.resolve([]);
  }

  override params(): Params {
    return {};
  }
}
