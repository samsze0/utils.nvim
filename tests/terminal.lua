local terminal_utils = require("utils.terminal")
local debug = require("utils").debug

local opts = terminal_utils.shell_opts_tostring({
  ["--option1"] = "value1",
  ["--option2"] = true,
  ["--option3"] = { "value2", "value3" },
  ["--option4"] = false,
})
assert(opts:match("--option1=value1"))
assert(opts:match("--option2"))
assert(opts:match("--option3=value2"))
assert(opts:match("--option3=value3"))
assert(not opts:match("--option4"))

assert(
  terminal_utils.strip_ansi_codes("[0;31mHello, World![0m") == "Hello, World!"
)
assert(
  terminal_utils.strip_ansi_codes("[0;31mHello, World!") == "Hello, World!"
)
assert(terminal_utils.strip_ansi_codes("Hello, World![0m") == "Hello, World!")
assert(
  terminal_utils.strip_ansi_codes("[0;31mHello, [0;32mWorld![0m")
    == "Hello, World!"
)

assert(terminal_utils.ansi.blue("Hello, World!"), "[0;34mHello, World![0m")
assert(terminal_utils.ansi.red("Hello, World!"), "[0;31mHello, World![0m")
assert(terminal_utils.ansi.green("Hello, World!"), "[0;32mHello, World![0m")
assert(terminal_utils.ansi.italic("Hello, World!"), "[3mHello, World![0m")

local output, exit_status, err = terminal_utils.system("echo 'Hello, World!'")
assert(output == "Hello, World!\n")
assert(exit_status == 0)
assert(err == nil)

local output, exit_status, err =
  terminal_utils.system("echo 'Hello, World!' && exit 1")
assert(output == nil)
assert(exit_status == 1)
assert(err == "Hello, World!\n")

local output = terminal_utils.system_unsafe("echo 'Hello, World!'")
assert(output == "Hello, World!\n")

local ok, output = pcall(
  function()
    return terminal_utils.system_unsafe("echo 'Hello, World!' && exit 1")
  end
)
assert(not ok)

local output, exit_status, err =
  terminal_utils.systemlist("echo -n ' 1 \n 2 \n \n 3 '", {
    trim = true,
    keepempty = false,
  })
assert(exit_status == 0)
assert(err == nil)
assert(vim.deep_equal(output, { "1", "2", "3" }))

local output, exit_status, err =
  terminal_utils.systemlist("echo -n ' 1 \n 2 \n \n 3 '", {
    trim = true,
    keepempty = true,
  })
assert(exit_status == 0)
assert(err == nil)
assert(vim.deep_equal(output, { "1", "2", "", "3" }))

local output, exit_status, err =
  terminal_utils.systemlist("echo -n ' 1 \n 2 \n \n 3 '", {
    trim = false,
    keepempty = false,
  })
assert(exit_status == 0)
assert(err == nil)
assert(vim.deep_equal(output, { " 1 ", " 2 ", " ", " 3 " }))

local output = terminal_utils.systemlist_unsafe("echo -n ' 1 \n 2 \n \n 3 '", {
  trim = true,
  keepempty = false,
})
assert(vim.deep_equal(output, { "1", "2", "3" }))

local ok, output = pcall(
  function()
    return terminal_utils.systemlist_unsafe(
      "echo -n ' 1 \n 2 \n \n 3 ' && exit 1",
      {
        trim = true,
        keepempty = false,
      }
    )
  end
)
assert(not ok)
