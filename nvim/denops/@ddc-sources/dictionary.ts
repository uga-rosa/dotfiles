import { TextLineStream } from "../rc/deps/std.ts";
import {
  BaseSource,
  DdcGatherItems,
  GatherArguments,
  Item,
  OnInitArguments,
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
};

export class Source extends BaseSource<Params> {
  #dictCache: Record<string, Cache> = {};
  #prePaths: string[] = [];

  async onInit({ sourceParams }: OnInitArguments<Params>): Promise<void> {
    await this.update(sourceParams.paths);
  }

  async update(paths: string[]): Promise<void> {
    this.#prePaths = paths;

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

  search(prefix: string): string[] {
    return Object.values(this.#dictCache)
      .filter((cache) => cache.active)
      .flatMap((cache) => cache.trie.search(prefix));
  }

  async gather({
    sourceParams,
    completeStr,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    // Update if paths is changed.
    if (JSON.stringify(sourceParams.paths) !== JSON.stringify(this.#prePaths)) {
      await this.update(sourceParams.paths);
    }

    const prefix = completeStr.slice(0, sourceParams.exactLength);
    let items: Item[] = [];
    if (sourceParams.firstCaseInsensitive) {
      const isCapital = prefix.charAt(0) === prefix.charAt(0).toUpperCase();
      if (isCapital) {
        items = this.search(prefix).map((word) => ({ word }));
        const prefixL = decapitalize(prefix);
        items = items.concat(this.search(prefixL).map((word) => ({ word: capitalize(word) })));
      } else {
        items = this.search(prefix).map((word) => ({ word }));
        const prefixU = capitalize(prefix);
        items = items.concat(this.search(prefixU).map((word) => ({ word: decapitalize(word) })));
      }
    } else {
      items = this.search(prefix).map((word) => ({ word }));
    }

    return {
      items,
      isIncomplete: completeStr.length < sourceParams.exactLength,
    };
  }

  params(): Params {
    return {
      paths: [],
      exactLength: 2,
      firstCaseInsensitive: false,
    };
  }
}
