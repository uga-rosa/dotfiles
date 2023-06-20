import { BaseSource } from "https://deno.land/x/ddu_vim@v3.2.1/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v3.2.1/deps.ts";

type Params = {
  word: string;
  hl_group: string;
};

export class Source extends BaseSource<Params> {
  kind = "dummy";

  gather(args: {
    sourceParams: Params;
    denops: Denops;
  }) {
    return new ReadableStream({
      start(controller) {
        const params = args.sourceParams;

        controller.enqueue([{
          word: `>>${params.word}<<`,
          highlights: [{
            name: "ddu-dummy",
            hl_group: params.hl_group,
            col: 1,
            width: byteLength(params.word) + 4,
          }],
        }]);
        controller.close();
      },
    });
  }

  params() {
    return {
      word: "dummy",
      hl_group: "Error"
    };
  }
}

const ENCODER = new TextEncoder();
function byteLength(
  str: string,
) {
  return ENCODER.encode(str).length;
}
