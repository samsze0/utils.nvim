local terminal_utils = require("utils.terminal")

local opts = terminal_utils.shell_opts_tostring({
  ["--option1"] = "value1",
  ["--option2"] = true,
  ["--option3"] = { "value2", "value3" },
  ["--option4"] = false,
})
T.assert(opts:match("--option1=value1"))
T.assert(opts:match("--option2"))
T.assert(opts:match("--option3=value2"))
T.assert(opts:match("--option3=value3"))
T.assert(not opts:match("--option4"))

T.assert(
  terminal_utils.strip_ansi_codes("[0;31mHello, World![0m") == "Hello, World!"
)
T.assert(
  terminal_utils.strip_ansi_codes("[0;31mHello, World!") == "Hello, World!"
)
T.assert_eq(terminal_utils.strip_ansi_codes("Hello, World![0m"), "Hello, World!")
T.assert(
  terminal_utils.strip_ansi_codes("[0;31mHello, [0;32mWorld![0m")
    == "Hello, World!"
)

T.assert(terminal_utils.ansi.blue("Hello, World!"), "[0;34mHello, World![0m")
T.assert(terminal_utils.ansi.red("Hello, World!"), "[0;31mHello, World![0m")
T.assert(terminal_utils.ansi.green("Hello, World!"), "[0;32mHello, World![0m")
T.assert(terminal_utils.ansi.italic("Hello, World!"), "[3mHello, World![0m")

local output, exit_status, err = terminal_utils.system("echo 'Hello, World!'")
T.assert_eq(output, "Hello, World!\n")
T.assert_eq(exit_status, 0)
T.assert_eq(err, nil)

local output, exit_status, err =
  terminal_utils.system("echo 'Hello, World!' && exit 1")
T.assert_eq(output, nil)
T.assert_eq(exit_status, 1)
T.assert_eq(err, "Hello, World!\n")

local output = terminal_utils.system_unsafe("echo 'Hello, World!'")
T.assert_eq(output, "Hello, World!\n")

T.assert_error(function()
  return terminal_utils.system_unsafe("echo 'Hello, World!' && exit 1")
end)

local output, exit_status, err =
  terminal_utils.systemlist("echo -n ' 1 \n 2 \n \n 3 '", {
    trim = true,
    keepempty = false,
  })
T.assert_eq(exit_status, 0)
T.assert_eq(err, nil)
T.assert_deep_eq(output, { "1", "2", "3" })

local output, exit_status, err =
  terminal_utils.systemlist("echo -n ' 1 \n 2 \n \n 3 '", {
    trim = true,
    keepempty = true,
  })
T.assert_eq(exit_status, 0)
T.assert_eq(err, nil)
T.assert_deep_eq(output, { "1", "2", "", "3" })

local output, exit_status, err =
  terminal_utils.systemlist("echo -n ' 1 \n 2 \n \n 3 '", {
    trim = false,
    keepempty = false,
  })
T.assert_eq(exit_status, 0)
T.assert_eq(err, nil)
T.assert_deep_eq(output, { " 1 ", " 2 ", " ", " 3 " })

local output = terminal_utils.systemlist_unsafe("echo -n ' 1 \n 2 \n \n 3 '", {
  trim = true,
  keepempty = false,
})
T.assert_deep_eq(output, { "1", "2", "3" })

T.assert_error(function()
  return terminal_utils.systemlist_unsafe(
    "echo -n ' 1 \n 2 \n \n 3 ' && exit 1",
    {
      trim = true,
      keepempty = false,
    }
  )
end)
