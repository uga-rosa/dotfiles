import { autocmd, fn, op } from "../rc/deps/denops.ts";
import { TextLineStream } from "../rc/deps/std.ts";
import {
  BaseSource,
  DdcEvent,
  DdcGatherItems,
  GatherArguments,
  OnEventArguments,
  OnInitArguments,
} from "../rc/deps/ddc.ts";
import { Lock } from "../rc/deps/async.ts";
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
  exactLength: number;
  filetype: Dict;
  filepath: Dict;
  spelllang: Dict;
  firstCaseInsensitive: boolean;
};

export class Source extends BaseSource<Params> {
  #dictCache: Record<string, Cache> = {};

  events: DdcEvent[] = [
    "Initialize",
    "FileType",
    "BufEnter",
    "OptionSet",
  ];

  async onInit({
    denops,
  }: OnInitArguments<Params>): Promise<void> {
    await autocmd.define(
      denops,
      "OptionSet",
      "spelllang",
      "call ddc#on_event('OptionSet')",
    );
  }

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

    const dictionaries = (await op.dictionary.get(denops))
      .split(",").filter(Boolean);

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

    const lock = new Lock(this.#dictCache);

    await Promise.all(paths.map(async (path) => {
      const stat = await Deno.stat(path);
      const mtime = stat.mtime?.getTime();
      if (mtime && this.#dictCache[path]?.mtime === mtime) {
        return;
      }

      const trie = new Trie();
      const file = await Deno.open(path);
      const lineStream = file.readable
        .pipeThrough(new TextDecoderStream())
        .pipeThrough(new TextLineStream());
      for await (const line of lineStream) {
        line.trim().split(/\s+/).forEach((word) => {
          if (word !== "") trie.insert(word);
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

  gather({
    sourceParams,
    sourceOptions,
    completeStr,
  }: GatherArguments<Params>): Promise<DdcGatherItems> {
    const prefix = completeStr.slice(0, sourceParams.exactLength);
    const prefixes = sourceParams.firstCaseInsensitive
      ? [capitalize(prefix), decapitalize(prefix)]
      : [prefix];
    const items = Object.values(this.#dictCache).filter((cache) => cache.active)
      .map((cache) => prefixes.map((p) => cache.trie.search(p)))
      .flat(2)
      .map((word) => ({ word }));
    const isIncomplete = completeStr.length === sourceParams.exactLength ||
      items.length > sourceOptions.maxItems;
    return Promise.resolve({ items, isIncomplete });
  }

  params(): Params {
    return {
      exactLength: 2,
      filetype: {},
      filepath: {},
      spelllang: {},
      firstCaseInsensitive: false,
    };
  }
}
