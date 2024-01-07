import { Denops } from "./deps/denops.ts";
import { TOML } from "./deps/std.ts";
import { is, u } from "./deps/unknownutil.ts";

export function main(denops: Denops) {
  denops.dispatcher = {
    toml_parse(raw: unknown): unknown {
      u.assert(raw, is.String);
      return TOML.parse(raw);
    },
    toml_stringfy(obj: unknown): unknown {
      u.assert(obj, is.Record);
      return TOML.stringify(obj);
    },
  };
}
