import {
  BaseSource,
  DdcEvent,
  DdcGatherItems,
  fn,
  GatherArguments,
  OnEventArguments,
  op,
  readLines,
} from "../rc/deps.ts";
import Trie from "../rc/trie.ts";

function ensureArray<T>(x: T | T[]): T[] {
  return Array.isArray(x) ? x : [x];
}

type Dict = Record<string, string | string[]>;
type EnsuredDict = Record<string, string[]>;

function ensureDict(dict: Dict): EnsuredDict {
  return Object.fromEntries(
    Object.entries(dict).map(([key, value]) => [key, ensureArray(value)]),
  );
}

type Cache = {
  path: string;
  mtime: number;
  trie: Trie;
  active: boolean;
};

type Params = {
  exactLength: number;
  filetype: Dict;
  filepath: Dict;
  spelllang: Dict;
};

export class Source extends BaseSource<Params> {
  #dictCache: Record<string, Cache> = {};

  events: DdcEvent[] = [
    "Initialize",
    "FileType",
    "BufEnter",
    "OptionSet",
  ];

  async onEvent({
    denops,
    sourceParams,
  }: OnEventArguments<Params>): Promise<void> {
    const params = {
      filetype: ensureDict(sourceParams.filetype),
      filepath: ensureDict(sourceParams.filepath),
      spelllang: ensureDict(sourceParams.spelllang),
    };
    const filetype = await op.filetype.get(denops);
    const fullpath = await fn.expand(denops, "%:p") as string;
    const spelllang = await op.spelllang.get(denops);

    const dictionaries = (await op.dictionary.get(denops)).split(",").filter(Boolean);

    if (params.filetype[filetype]) {
      dictionaries.push(...params.filetype[filetype]);
    }
    for (const [path, dict] of Object.entries(params.filepath)) {
      if (new RegExp(path).test(fullpath)) {
        dictionaries.push(...dict);
      }
    }
    for (const sl of spelllang.split(",")) {
      if (params.spelllang[sl]) {
        dictionaries.push(...params.spelllang[sl]);
      }
    }

    await this.update(dictionaries);
  }

  async update(paths: string[]): Promise<void> {
    for (const cache of Object.values(this.#dictCache)) {
      if (!paths.includes(cache.path)) {
        cache.active = false;
      }
    }

    await Promise.all(paths.map(async (path) => {
      const stat = await Deno.stat(path);
      const mtime = stat.mtime?.getTime();
      if (mtime && this.#dictCache[path]?.mtime === mtime) {
        return;
      }

      const trie = new Trie();
      const reader = await Deno.open(path);
      for await (const line of readLines(reader)) {
        line.trim().split(/\s+/)
          .filter((word) => word !== "")
          .map((word) => trie.insert(word));
      }

      this.#dictCache[path] = {
        path,
        mtime: mtime ?? -1,
        trie,
        active: true,
      };
    }));
  }

  gather({
    sourceParams,
    completeStr,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    const prefix = completeStr.slice(0, sourceParams.exactLength);
    const isIncomplete = completeStr.length !== sourceParams.exactLength;
    const items = Object.values(this.#dictCache).filter((cache) => cache.active)
      .flatMap((cache) => cache.trie.search(prefix))
      .map((word) => ({ word }));
    return Promise.resolve({ items, isIncomplete });
  }

  params(): Params {
    return {
      exactLength: 2,
      filetype: {},
      filepath: {},
      spelllang: {},
    };
  }
}
