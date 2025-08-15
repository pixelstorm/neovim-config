--[[
╭─────────────────────────────────────────────────────────────╮
│                    PHP Snippets                             │
│                                                             │
│  Custom PHP snippets for web development                   │
╰─────────────────────────────────────────────────────────────╯
--]]

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- PHP opening tag
  s("php", {
    t("<?php"),
    i(0),
  }),

  -- PHP class
  s("class", fmt([[
    <?php

    class {1}
    {{
        {2}
    }}
  ]], {
    i(1, "ClassName"),
    i(0),
  })),

  -- PHP function
  s("function", fmt([[
    public function {1}({2})
    {{
        {3}
    }}
  ]], {
    i(1, "functionName"),
    i(2),
    i(0),
  })),

  -- PHP constructor
  s("construct", fmt([[
    public function __construct({1})
    {{
        {2}
    }}
  ]], {
    i(1),
    i(0),
  })),

  -- PHP array
  s("array", fmt([[
    ${1} = [
        {2}
    ];
  ]], {
    i(1, "array"),
    i(0),
  })),

  -- PHP foreach loop
  s("foreach", fmt([[
    foreach (${1} as ${2}) {{
        {3}
    }}
  ]], {
    i(1, "array"),
    i(2, "$item"),
    i(0),
  })),

  -- PHP if statement
  s("if", fmt([[
    if ({1}) {{
        {2}
    }}
  ]], {
    i(1, "condition"),
    i(0),
  })),

  -- PHP try-catch
  s("try", fmt([[
    try {{
        {1}
    }} catch ({2} $e) {{
        {3}
    }}
  ]], {
    i(1),
    i(2, "Exception"),
    i(0),
  })),

  -- PHP namespace
  s("namespace", fmt([[
    <?php

    namespace {1};

    {2}
  ]], {
    i(1, "App\\Models"),
    i(0),
  })),

  -- PHP use statement
  s("use", fmt([[
    use {1};
  ]], {
    i(1, "Namespace\\Class"),
  })),

  -- PHP property
  s("property", fmt([[
    {1} ${2};
  ]], {
    c(1, {
      t("public"),
      t("private"),
      t("protected"),
    }),
    i(2, "property"),
  })),

  -- PHP getter
  s("getter", fmt([[
    public function get{1}()
    {{
        return $this->{2};
    }}
  ]], {
    i(1, "Property"),
    f(function(args)
      return string.lower(args[1][1])
    end, {1}),
  })),

  -- PHP setter
  s("setter", fmt([[
    public function set{1}(${2})
    {{
        $this->{3} = ${2};
    }}
  ]], {
    i(1, "Property"),
    f(function(args)
      return string.lower(args[1][1])
    end, {1}),
    f(function(args)
      return string.lower(args[1][1])
    end, {1}),
  })),
}