import { BaseSource } from "https://deno.land/x/ddu_vim@v3.2.1/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v3.2.1/deps.ts";

type Params = {
  name: string;
  color: string;
};

export class Source extends BaseSource<Params> {
  kind = "dummy";

  gather(args: {
    sourceParams: Params;
    denops: Denops;
  }) {
    return new ReadableStream({
      async start(controller) {
        const params = args.sourceParams;
        const hl_group = `DduDummy${params.name.replace(/[^a-zA-Z]/g, "")}`;
        await args.denops.cmd(
          `highlight default ${hl_group} guifg=${params.color}`,
        );

        controller.enqueue([{
          word: `>>${params.name}<<`,
          highlights: [{
            name: "ddu-dummy",
            hl_group,
            col: 1,
            width: byteLength(params.name) + 4,
          }],
        }]);
        controller.close();
      },
    });
  }

  params() {
    return {
      name: "dummy",
      color: "#000000",
    };
  }
}

const ENCODER = new TextEncoder();
function byteLength(
  str: string,
) {
  return ENCODER.encode(str).length;
}
