import { BaseSource, Item } from "https://deno.land/x/ddu_vim@v2.8.4/types.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.4.0/file.ts";
import { LocationLink } from "./types.ts";

type Params = {
  locations: LocationLink[];
};

export class Source extends BaseSource<Params> {
  kind = "file";

  gather(args: {
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      start(controller) {
        const locations = args.sourceParams.locations;
        const items = locations.map((location) => {
          const url = new URL(location.targetUri)
          console.log(url)
          const path = url.pathname
          const { line: lineNr, character: col } =
            location.targetSelectionRange.start;
          return {
            word: path,
            display: `${path}:${lineNr}:${col}`,
            action: { path, lineNr, col },
          };
        });
        controller.enqueue(items);
        controller.close();
      },
    });
  }

  params(): Params {
    return {
      locations: [],
    };
  }
}
