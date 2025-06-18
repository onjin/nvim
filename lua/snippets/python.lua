require("luasnip.session.snippet_collection").clear_snippets "python"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

local struct_decorator = [=[
  from typing import Callable, ParamSpec, TypeVar
  from functools import wraps
  
  Param = ParamSpec("Param")
  RetType = TypeVar("RetType")
  
  def {}({}) -> Callable[[Callable[Param, RetType]], Callable[Param, RetType]]:
      def decorator(func: Callable[Param, RetType]) -> Callable[Param, RetType]:
          @wraps(func)
          def wrapper(*args: Param.args, **kwargs: Param.kwargs) -> RetType:
              {}
              return func(*args, **kwargs)
  
          return wrapper
  
      return decorator

]=]

local helper_benchmark = [=[
    def benchmark(func, data, label=None):
        import copy
        import time
        import tracemalloc

        label = label or str(func)
        data_copy = copy.deepcopy(data)
        tracemalloc.start()
        start = time.time()
        result = func(data_copy)
        end = time.time()
        mem_current, mem_peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()
        return {{
            "label": label,
            "result": result,
            "time": f"{{end - start:.4f}}",
            "memory": f"{{mem_peak / 1024:.2f}}",
        }}
]=]

ls.add_snippets("python", {
  s("#!", fmt("#!/usr/bin/env python", {})),
  s("#!uv", fmt("#!/usr/bin/env -S uv run", {})),
  s("struct#decorator", fmt(struct_decorator, { i(1), i(2), i(3) })),
  s("helper#benchmark", fmt(helper_benchmark, {})),
  s(
    "Generator",
    fmt(
      "Generator[{yield_type}, {send_type}, {return_type}]",
      { yield_type = i(1, "yield_type"), send_type = i(2, "send_type"), return_type = i(3, "return_type") }
    )
  ),
  s(
    "logging#basic",
    fmt(
      [[
      logging.basicConfig(
          level=logging.DEBUG,
          format="%(asctime)s - %(levelname)s - %(message)s",
          datefmt="%Y-%m-%d %H:%M:%S"
      )
  ]],
      {}
    )
  ),
  s("pdb.trace", fmt("import pdb; pdb.set_trace()", {})),
  s("ipdb.trace", fmt("import ipdb; ipdb.set_trace()", {})),
  s("br", fmt("breakpoint()", {})),
  s(
    "dependencies.inline",
    fmt(
      [[
# /// script
# dependencies = [
#     "{package}",
# ]
# ///

  ]],
      { package = i(1, "package") }
    )
  ),
})
