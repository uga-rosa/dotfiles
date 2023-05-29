import {
  BaseSource,
  Item,
} from "https://deno.land/x/ddu_vim@v2.8.6/types.ts#^";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.4.1/file.ts#^";
import { Location, LocationLink } from "./types.ts";

type Params = {
  locations: Location[] | LocationLink[];
};

function getUri(location: Location | LocationLink) {
  if ("uri" in location) {
    return location.uri;
  } else {
    return location.targetUri;
  }
}

function getRange(location: Location | LocationLink) {
  if ("range" in location) {
    return location.range;
  } else {
    return location.targetSelectionRange;
  }
}

export class Source extends BaseSource<Params> {
  kind = "file";

  gather(args: {
    sourceParams: Params;
  }): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      start(controller) {
        const locations = args.sourceParams.locations;
        const items = locations.flatMap((location) => {
          let path = getUri(location);
          // filter deno virtual buffers with udd fragments
          // #(^|~|<|=)
          if (/^deno:.*%23(%5E|%7E|%3C|%3D)/.test(path)) {
            return [];
          }
          if (path.startsWith("file:")) {
            path = new URL(path).pathname;
          }
          const range = getRange(location);
          const { line, character } = range.start;
          const [lineNr, col] = [line + 1, character + 1];
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
