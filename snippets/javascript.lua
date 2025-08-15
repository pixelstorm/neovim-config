--[[
╭─────────────────────────────────────────────────────────────╮
│                    JavaScript Snippets                      │
│                                                             │
│  Custom JavaScript snippets for web development            │
╰─────────────────────────────────────────────────────────────╯
--]]

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Console log
  s("cl", fmt([[
    console.log({1});
  ]], {
    i(1, "value"),
  })),

  -- Console log with label
  s("cll", fmt([[
    console.log('{1}:', {2});
  ]], {
    i(1, "label"),
    i(2, "value"),
  })),

  -- Function declaration
  s("function", fmt([[
    function {1}({2}) {{
        {3}
    }}
  ]], {
    i(1, "functionName"),
    i(2),
    i(0),
  })),

  -- Arrow function
  s("arrow", fmt([[
    const {1} = ({2}) => {{
        {3}
    }};
  ]], {
    i(1, "functionName"),
    i(2),
    i(0),
  })),

  -- Arrow function (short)
  s("arrowf", fmt([[
    ({1}) => {2}
  ]], {
    i(1),
    i(0),
  })),

  -- Async function
  s("async", fmt([[
    async function {1}({2}) {{
        {3}
    }}
  ]], {
    i(1, "functionName"),
    i(2),
    i(0),
  })),

  -- Async arrow function
  s("asyncarrow", fmt([[
    const {1} = async ({2}) => {{
        {3}
    }};
  ]], {
    i(1, "functionName"),
    i(2),
    i(0),
  })),

  -- Try-catch
  s("try", fmt([[
    try {{
        {1}
    }} catch (error) {{
        {2}
    }}
  ]], {
    i(1),
    i(0),
  })),

  -- For loop
  s("for", fmt([[
    for (let {1} = 0; {1} < {2}; {1}++) {{
        {3}
    }}
  ]], {
    i(1, "i"),
    i(2, "length"),
    i(0),
  })),

  -- For...of loop
  s("forof", fmt([[
    for (const {1} of {2}) {{
        {3}
    }}
  ]], {
    i(1, "item"),
    i(2, "array"),
    i(0),
  })),

  -- For...in loop
  s("forin", fmt([[
    for (const {1} in {2}) {{
        {3}
    }}
  ]], {
    i(1, "key"),
    i(2, "object"),
    i(0),
  })),

  -- If statement
  s("if", fmt([[
    if ({1}) {{
        {2}
    }}
  ]], {
    i(1, "condition"),
    i(0),
  })),

  -- If-else statement
  s("ifelse", fmt([[
    if ({1}) {{
        {2}
    }} else {{
        {3}
    }}
  ]], {
    i(1, "condition"),
    i(2),
    i(0),
  })),

  -- Switch statement
  s("switch", fmt([[
    switch ({1}) {{
        case {2}:
            {3}
            break;
        default:
            {4}
    }}
  ]], {
    i(1, "expression"),
    i(2, "value"),
    i(3),
    i(0),
  })),

  -- Object destructuring
  s("dest", fmt([[
    const {{ {1} }} = {2};
  ]], {
    i(1, "property"),
    i(2, "object"),
  })),

  -- Array destructuring
  s("desta", fmt([[
    const [{1}] = {2};
  ]], {
    i(1, "item"),
    i(2, "array"),
  })),

  -- Import statement
  s("import", fmt([[
    import {1} from '{2}';
  ]], {
    i(1, "module"),
    i(2, "path"),
  })),

  -- Import destructured
  s("importd", fmt([[
    import {{ {1} }} from '{2}';
  ]], {
    i(1, "exports"),
    i(2, "path"),
  })),

  -- Export default
  s("export", fmt([[
    export default {1};
  ]], {
    i(1, "value"),
  })),

  -- Export named
  s("exportn", fmt([[
    export {{ {1} }};
  ]], {
    i(1, "exports"),
  })),

  -- Promise
  s("promise", fmt([[
    new Promise((resolve, reject) => {{
        {1}
    }})
  ]], {
    i(0),
  })),

  -- Fetch API
  s("fetch", fmt([[
    fetch('{1}')
        .then(response => response.json())
        .then(data => {{
            {2}
        }})
        .catch(error => {{
            console.error('Error:', error);
        }});
  ]], {
    i(1, "url"),
    i(0),
  })),

  -- Async/await fetch
  s("fetchasync", fmt([[
    try {{
        const response = await fetch('{1}');
        const data = await response.json();
        {2}
    }} catch (error) {{
        console.error('Error:', error);
    }}
  ]], {
    i(1, "url"),
    i(0),
  })),

  -- setTimeout
  s("timeout", fmt([[
    setTimeout(() => {{
        {2}
    }}, {1});
  ]], {
    i(1, "1000"),
    i(0),
  })),

  -- setInterval
  s("interval", fmt([[
    setInterval(() => {{
        {2}
    }}, {1});
  ]], {
    i(1, "1000"),
    i(0),
  })),

  -- Event listener
  s("addEventListener", fmt([[
    {1}.addEventListener('{2}', ({3}) => {{
        {4}
    }});
  ]], {
    i(1, "element"),
    i(2, "event"),
    i(3, "e"),
    i(0),
  })),

  -- Class
  s("class", fmt([[
    class {1} {{
        constructor({2}) {{
            {3}
        }}

        {4}
    }}
  ]], {
    i(1, "ClassName"),
    i(2),
    i(3),
    i(0),
  })),
}