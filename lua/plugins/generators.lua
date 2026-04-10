local uv = vim.uv or vim.loop
math.randomseed(os.time() + ((uv and uv.hrtime) and math.floor(uv.hrtime() % 1000000) or 0))

local function trim(value)
  return (value:gsub("%s+$", ""))
end

local function rand_hex(length)
  local out = {}
  for _ = 1, length do
    out[#out + 1] = string.format("%x", math.random(0, 15))
  end
  return table.concat(out)
end

local function now_ms()
  local extra = 0
  if uv and uv.hrtime then
    extra = math.floor((uv.hrtime() / 1e6) % 1000)
  end
  return (os.time() * 1000) + extra
end

local function datetime_iso()
  local tz = os.date "%z"
  if #tz == 5 then
    tz = tz:sub(1, 3) .. ":" .. tz:sub(4, 5)
  end
  return os.date "%Y-%m-%dT%H:%M:%S" .. tz
end

local function run_system(argv)
  if vim.fn.executable(argv[1]) == 0 then
    return nil
  end

  local result = vim.fn.system(argv)
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return trim(result):lower()
end

local function uuid_v4_fallback()
  return table.concat {
    rand_hex(8),
    "-",
    rand_hex(4),
    "-4",
    rand_hex(3),
    "-",
    ({ "8", "9", "a", "b" })[math.random(1, 4)],
    rand_hex(3),
    "-",
    rand_hex(12),
  }
end

local function uuid_name()
  local pos = vim.api.nvim_win_get_cursor(0)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    file = "nvim"
  end
  return string.format("%s:%d:%d:%d", file, pos[1], pos[2], now_ms())
end

local function uuid_v2()
  local v1 = run_system { "uuidgen", "--time" }
  if not v1 then
    return nil
  end

  local _, g2, g3, g4, g5 = v1:match("^(%x+)%-(%x+)%-(%x+)%-(%x+)%-(%x+)$")
  if not g2 then
    return nil
  end

  return string.format("%s-%s-%s-%s-%s", rand_hex(8), g2, "2" .. g3:sub(2), g4:sub(1, 2) .. "00", g5)
end

local CROCKFORD32 = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

local function ulid()
  local ms = now_ms()
  local bytes = {}

  for idx = 6, 1, -1 do
    bytes[idx] = ms % 256
    ms = math.floor(ms / 256)
  end

  for idx = 7, 16 do
    bytes[idx] = math.random(0, 255)
  end

  local chars = {}
  local buffer = 0
  local bits = 0

  for _, byte in ipairs(bytes) do
    buffer = (buffer * 256) + byte
    bits = bits + 8

    while bits >= 5 do
      bits = bits - 5
      local value = math.floor(buffer / (2 ^ bits)) % 32
      chars[#chars + 1] = CROCKFORD32:sub(value + 1, value + 1)
    end

    buffer = buffer % (2 ^ bits)
  end

  if bits > 0 then
    local value = (buffer * (2 ^ (5 - bits))) % 32
    chars[#chars + 1] = CROCKFORD32:sub(value + 1, value + 1)
  end

  return table.concat(chars, "", 1, 26)
end

local generators = {
  { id = "uuid1", build = function() return run_system { "uuidgen", "--time" } end },
  { id = "uuid2", build = uuid_v2 },
  {
    id = "uuid3",
    build = function()
      return run_system { "uuidgen", "--md5", "--namespace", "@dns", "--name", uuid_name() }
    end,
  },
  {
    id = "uuid4",
    build = function()
      return run_system { "uuidgen", "--random" } or uuid_v4_fallback()
    end,
  },
  {
    id = "uuid5",
    build = function()
      return run_system { "uuidgen", "--sha1", "--namespace", "@dns", "--name", uuid_name() }
    end,
  },
  { id = "uuid6", build = function() return run_system { "uuidgen", "--time-v6" } end },
  { id = "uuid7", build = function() return run_system { "uuidgen", "--time-v7" } end },
  { id = "ulid", build = ulid },
  { id = "date", build = function() return os.date "%Y-%m-%d" end },
  { id = "datetime", build = function() return os.date "%Y-%m-%d %H:%M:%S" end },
  { id = "datetime_iso", build = datetime_iso },
}

local generator_by_id = {}
for _, generator in ipairs(generators) do
  generator_by_id[generator.id] = generator
end

local function insert_text(value)
  if not value or value == "" then
    return
  end

  if not vim.api.nvim_get_mode().mode:match "^i" then
    vim.cmd.startinsert()
  end

  local keys = vim.api.nvim_replace_termcodes(value, true, false, true)
  vim.api.nvim_feedkeys(keys, "i", false)
end

local function insert_generated(id)
  local generator = generator_by_id[id]
  if not generator then
    vim.notify(("Unknown generator: %s"):format(id), vim.log.levels.ERROR)
    return
  end

  local ok, value = pcall(generator.build)
  if not ok or not value or value == "" then
    vim.notify(("Failed to generate: %s"):format(id), vim.log.levels.ERROR)
    return
  end

  insert_text(value)
end

local function generated_completion_items(base)
  local items = {}
  local match_prefix = base and base ~= ""

  for _, generator in ipairs(generators) do
    local ok, value = pcall(generator.build)
    if ok and value and value ~= "" then
      if (not match_prefix) or vim.startswith(value, base) then
        items[#items + 1] = {
          word = value,
          abbr = generator.id,
          menu = "[generated]",
          kind = "g",
        }
      end
    end
  end

  return items
end

function _G.onjin_generated_complete(findstart, base)
  if findstart == 1 then
    return vim.fn.col "." - 1
  end

  return generated_completion_items(base)
end

vim.opt.completefunc = "v:lua.onjin_generated_complete"

local function pick_and_insert_generated()
  local items = vim.tbl_map(function(item)
    return item.id
  end, generators)

  vim.ui.select(items, { prompt = "Insert generated value" }, function(choice)
    if choice then
      insert_generated(choice)
    end
  end)
end

vim.api.nvim_create_user_command("InsertGenerated", function(opts)
  insert_generated(opts.args)
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_map(function(item)
      return item.id
    end, generators)
  end,
  desc = "Insert generated id/date value",
})

vim.keymap.set("i", "<C-g>k", pick_and_insert_generated, { desc = "Insert generated value menu" })
vim.keymap.set("i", "<C-x>1", function() insert_generated "uuid1" end, { desc = "Insert uuid1" })
vim.keymap.set("i", "<C-x>2", function() insert_generated "uuid2" end, { desc = "Insert uuid2" })
vim.keymap.set("i", "<C-x>3", function() insert_generated "uuid3" end, { desc = "Insert uuid3" })
vim.keymap.set("i", "<C-x>4", function() insert_generated "uuid4" end, { desc = "Insert uuid4" })
vim.keymap.set("i", "<C-x>5", function() insert_generated "uuid5" end, { desc = "Insert uuid5" })
vim.keymap.set("i", "<C-x>6", function() insert_generated "uuid6" end, { desc = "Insert uuid6" })
vim.keymap.set("i", "<C-x>7", function() insert_generated "uuid7" end, { desc = "Insert uuid7" })
vim.keymap.set("i", "<C-x>u", function() insert_generated "ulid" end, { desc = "Insert ulid" })
vim.keymap.set("i", "<C-x>d", function() insert_generated "date" end, { desc = "Insert date" })
vim.keymap.set("i", "<C-x>t", function() insert_generated "datetime" end, { desc = "Insert datetime" })
vim.keymap.set("i", "<C-x>i", function() insert_generated "datetime_iso" end, { desc = "Insert iso datetime" })
