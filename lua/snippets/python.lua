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

ls.add_snippets("python", {
  s("struct#decorator", fmt(struct_decorator, { i(1), i(2), i(3) })),
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
})