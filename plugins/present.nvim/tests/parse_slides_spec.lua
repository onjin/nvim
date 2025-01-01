---@diagnostic disable: undefined-field
local parse = require("present")._parse_slides
local eq = assert.are.same
describe("present.parse_slides", function()
  it("should parse an empty file", function()
    eq({
      slides = {
        {
          title = "",
          body = {},
          blocks = {},
        },
      },
    }, parse {})
  end)
  it("should parse a file with one slide", function()
    eq(
      {
        slides = {
          {
            title = "# This is the first slide",
            body = { "This is the body" },
            blocks = {},
          },
        },
      },
      parse {
        "# This is the first slide",
        "This is the body",
      }
    )
  end)
  it("should parse a file with one slide, and a codeblock", function()
    local result = parse {
      "# This is the first slide",
      "This is the body",
      "```lua",
      "print('hi')",
      "```",
    }
    eq(1, #result.slides)

    local slide = result.slides[1]
    eq("# This is the first slide", slide.title)
    eq({
      "This is the body",
      "```lua",
      "print('hi')",
      "```",
    }, slide.body)
    local block_body = vim.trim [[print('hi')]]
    eq("lua", slide.blocks[1].language)
    eq(block_body, slide.blocks[1].body)
  end)
end)
