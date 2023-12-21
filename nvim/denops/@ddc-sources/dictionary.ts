import { TextLineStream } from "../rc/deps/std.ts";
import {
  BaseSource,
  DdcGatherItems,
  GatherArguments,
  GetPreviewerArguments,
  Item,
  OnEventArguments,
  OnInitArguments,
  Previewer,
} from "../rc/deps/ddc.ts";
import { Lock } from "../rc/deps/async.ts";
import Trie from "../rc/trie.ts";

function capitalize(str: string): string {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function decapitalize(str: string): string {
  return str.charAt(0).toLowerCase() + str.slice(1);
}

type Cache = {
  path: string;
  mtime: number;
  trie: Trie;
  active: boolean;
};

type Params = {
  paths: string[];
  exactLength: number;
  firstCaseInsensitive: boolean;
  showPath: boolean;
  documentCommand: string[];
};

export class Source extends BaseSource<Params> {
  #dictCache: Record<string, Cache> = {};
  #prePaths = "";

  async onInit({ sourceParams }: OnInitArguments<Params>): Promise<void> {
    await this.update(sourceParams.paths);
  }

  events = ["InsertEnter"];
  async onEvent({ sourceParams }: OnEventArguments<Params>): Promise<void> {
    if (JSON.stringify(sourceParams.paths) !== this.#prePaths) {
      await this.update(sourceParams.paths);
    }
  }

  async update(paths: string[]): Promise<void> {
    this.#prePaths = JSON.stringify(paths);

    // Deactivate old caches.
    for (const cache of Object.values(this.#dictCache)) {
      if (!paths.includes(cache.path)) {
        cache.active = false;
      }
    }

    const lock = new Lock(this.#dictCache);

    await Promise.all(paths.map(async (path) => {
      const stat = await Deno.stat(path);
      const mtime = stat.mtime?.getTime();
      // If there is no update, the previous cache is used as is.
      if (mtime != null && this.#dictCache[path]?.mtime === mtime) {
        this.#dictCache[path].active = true;
        return;
      }

      const trie = new Trie();
      const file = await Deno.open(path);
      const lineStream = file.readable
        .pipeThrough(new TextDecoderStream())
        .pipeThrough(new TextLineStream());
      for await (const line of lineStream) {
        line.split(/\s+/).forEach((word) => {
          if (word !== "") {
            trie.insert(word);
          }
        });
      }

      await lock.lock((dictCache) => {
        dictCache[path] = {
          path,
          mtime: mtime ?? -1,
          trie,
          active: true,
        };
      });
    }));
  }

  search(prefix: string, showPath: boolean): Item[] {
    return Object.values(this.#dictCache)
      .filter((cache) => cache.active)
      .flatMap((cache) => {
        const info = showPath ? cache.path : "";
        return cache.trie.search(prefix).map((word) => ({ word, info }));
      });
  }

  gather({
    sourceParams: params,
    completeStr,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    const prefix = completeStr.slice(0, params.exactLength);
    let items: Item[] = [];
    if (params.firstCaseInsensitive) {
      const isCapital = prefix.charAt(0) === prefix.charAt(0).toUpperCase();
      if (isCapital) {
        items = [
          ...this.search(prefix, params.showPath),
          ...this.search(decapitalize(prefix), params.showPath)
            .map((item) => ({ ...item, word: capitalize(item.word) })),
        ];
      } else {
        items = [
          ...this.search(prefix, params.showPath),
          ...this.search(capitalize(prefix), params.showPath)
            .map((item) => ({ ...item, word: decapitalize(item.word) })),
        ];
      }
    } else {
      items = this.search(prefix, params.showPath);
    }
    const isIncomplete = completeStr.length < params.exactLength;
    return Promise.resolve({ items, isIncomplete });
  }

  #Decoder = new TextDecoder();
  decode(u: Uint8Array): string {
    return this.#Decoder.decode(u);
  }

  getPreviewer({
    item,
    sourceParams: params,
  }: GetPreviewerArguments<Params>): Previewer {
    const contents = item.info ? [item.info] : [];
    if (params.documentCommand.length > 0) {
      const command = params.documentCommand.map((c) => c === "%s" ? item.word : c);
      const { stdout, stderr } = new Deno.Command(command[0], {
        args: command.slice(1),
      }).outputSync();
      if (stdout.length > 0) {
        return {
          kind: "text",
          contents: [
            ...contents,
            ...this.decode(stdout).trim().split("\n"),
          ],
        };
      } else if (stderr.length > 0) {
        return {
          kind: "text",
          contents: [
            "Error:",
            ...this.decode(stderr).trim().split("\n"),
          ],
        };
      }
    } else if (contents.length > 0) {
      return { kind: "text", contents };
    }
    return { kind: "empty" };
  }

  params(): Params {
    return {
      paths: [],
      exactLength: 2,
      firstCaseInsensitive: false,
      showPath: false,
      documentCommand: [],
    };
  }
}
