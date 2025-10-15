local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

return {
  -- HTML5 Document Structure
  s("html5", {
    t({"<!DOCTYPE html>", "<html lang=\"en\">", "<head>", "    <meta charset=\"UTF-8\">", "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">", "    <title>"}), i(1, "Document"), t({"</title>", "</head>", "<body>", "    "}), i(0), t({"", "</body>", "</html>"})
  }),

  -- Basic HTML structure
  s("html", {
    t({"<html>", "<head>", "    <title>"}), i(1, "Document"), t({"</title>", "</head>", "<body>", "    "}), i(0), t({"", "</body>", "</html>"})
  }),

  -- Head section
  s("head", {
    t({"<head>", "    <meta charset=\"UTF-8\">", "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">", "    <title>"}), i(1, "Document"), t({"</title>", "    "}), i(0), t({"", "</head>"})
  }),

  -- Meta tags
  s("meta", {
    t("<meta "), c(1, {
      t("charset=\"UTF-8\""),
      t("name=\"viewport\" content=\"width=device-width, initial-scale=1.0\""),
      t("name=\"description\" content=\""), i(1, "Description"), t("\""),
      t("name=\"keywords\" content=\""), i(1, "Keywords"), t("\""),
      t("name=\"author\" content=\""), i(1, "Author"), t("\""),
    }), t(">")
  }),

  -- Link tag
  s("link", {
    t("<link rel=\""), c(1, {
      t("stylesheet"),
      t("icon"),
      t("preconnect"),
      t("dns-prefetch"),
    }), t("\" href=\""), i(2, ""), t("\">")
  }),

  -- CSS link
  s("css", {
    t("<link rel=\"stylesheet\" href=\""), i(1, "style.css"), t("\">")
  }),

  -- Script tag
  s("script", {
    t("<script"), c(1, {
      t(" src=\""), i(1, "script.js"), t("\""),
      t(""),
    }), t(">"), i(0), t("</script>")
  }),

  -- Common HTML elements
  s("div", {
    t("<div"), c(1, {
      t(""),
      t(" class=\""), i(1, ""), t("\""),
      t(" id=\""), i(1, ""), t("\""),
    }), t(">"), i(0), t("</div>")
  }),

  s("p", {
    t("<p>"), i(1), t("</p>")
  }),

  s("h1", {
    t("<h1>"), i(1), t("</h1>")
  }),

  s("h2", {
    t("<h2>"), i(1), t("</h2>")
  }),

  s("h3", {
    t("<h3>"), i(1), t("</h3>")
  }),

  s("h4", {
    t("<h4>"), i(1), t("</h4>")
  }),

  s("h5", {
    t("<h5>"), i(1), t("</h5>")
  }),

  s("h6", {
    t("<h6>"), i(1), t("</h6>")
  }),

  -- Links and images
  s("a", {
    t("<a href=\""), i(1, "#"), t("\">"), i(2, "Link text"), t("</a>")
  }),

  s("img", {
    t("<img src=\""), i(1, ""), t("\" alt=\""), i(2, ""), t("\""), c(3, {
      t(""),
      t(" width=\""), i(1, ""), t("\" height=\""), i(2, ""), t("\""),
    }), t(">")
  }),

  -- Lists
  s("ul", {
    t({"<ul>", "    <li>"}), i(1), t({"</li>", "    <li>"}), i(2), t({"</li>", "</ul>"})
  }),

  s("ol", {
    t({"<ol>", "    <li>"}), i(1), t({"</li>", "    <li>"}), i(2), t({"</li>", "</ol>"})
  }),

  s("li", {
    t("<li>"), i(1), t("</li>")
  }),

  -- Tables
  s("table", {
    t({"<table>", "    <thead>", "        <tr>", "            <th>"}), i(1, "Header 1"), t({"</th>", "            <th>"}), i(2, "Header 2"), t({"</th>", "        </tr>", "    </thead>", "    <tbody>", "        <tr>", "            <td>"}), i(3, "Data 1"), t({"</td>", "            <td>"}), i(4, "Data 2"), t({"</td>", "        </tr>", "    </tbody>", "</table>"})
  }),

  s("tr", {
    t({"<tr>", "    <td>"}), i(1), t({"</td>", "    <td>"}), i(2), t({"</td>", "</tr>"})
  }),

  s("td", {
    t("<td>"), i(1), t("</td>")
  }),

  s("th", {
    t("<th>"), i(1), t("</th>")
  }),

  -- Forms
  s("form", {
    t("<form"), c(1, {
      t(" action=\""), i(1, ""), t("\" method=\""), c(2, {t("post"), t("get")}), t("\""),
      t(""),
    }), t(">"), i(0), t("</form>")
  }),

  s("input", {
    t("<input type=\""), c(1, {
      t("text"),
      t("email"),
      t("password"),
      t("number"),
      t("tel"),
      t("url"),
      t("search"),
      t("submit"),
      t("button"),
      t("reset"),
      t("checkbox"),
      t("radio"),
      t("file"),
      t("hidden"),
    }), t("\""), c(2, {
      t(""),
      t(" name=\""), i(1, ""), t("\""),
      t(" id=\""), i(1, ""), t("\""),
      t(" placeholder=\""), i(1, ""), t("\""),
    }), t(">")
  }),

  s("textarea", {
    t("<textarea"), c(1, {
      t(""),
      t(" name=\""), i(1, ""), t("\""),
      t(" id=\""), i(1, ""), t("\""),
      t(" rows=\""), i(1, "4"), t("\" cols=\""), i(2, "50"), t("\""),
    }), t(">"), i(0), t("</textarea>")
  }),

  s("select", {
    t({"<select", ""}), c(1, {
      t(""),
      t(" name=\""), i(1, ""), t("\""),
    }), t({">", "    <option value=\""}), i(2, ""), t("\">"), i(3, "Option 1"), t({"</option>", "    <option value=\""}), i(4, ""), t("\">"), i(5, "Option 2"), t({"</option>", "</select>"})
  }),

  s("option", {
    t("<option value=\""), i(1, ""), t("\">"), i(2, "Option text"), t("</option>")
  }),

  s("label", {
    t("<label"), c(1, {
      t(" for=\""), i(1, ""), t("\""),
      t(""),
    }), t(">"), i(2, "Label text"), t("</label>")
  }),

  s("button", {
    t("<button"), c(1, {
      t(" type=\"button\""),
      t(" type=\"submit\""),
      t(" type=\"reset\""),
      t(""),
    }), t(">"), i(2, "Button text"), t("</button>")
  }),

  -- Semantic HTML5 elements
  s("header", {
    t("<header>"), i(1), t("</header>")
  }),

  s("nav", {
    t("<nav>"), i(1), t("</nav>")
  }),

  s("main", {
    t("<main>"), i(1), t("</main>")
  }),

  s("section", {
    t("<section>"), i(1), t("</section>")
  }),

  s("article", {
    t("<article>"), i(1), t("</article>")
  }),

  s("aside", {
    t("<aside>"), i(1), t("</aside>")
  }),

  s("footer", {
    t("<footer>"), i(1), t("</footer>")
  }),

  -- Bootstrap components
  s("container", {
    t("<div class=\"container\">"), i(1), t("</div>")
  }),

  s("row", {
    t("<div class=\"row\">"), i(1), t("</div>")
  }),

  s("col", {
    t("<div class=\"col"), c(1, {
      t(""),
      t("-"), i(1, "12"),
      t("-sm-"), i(1, "12"),
      t("-md-"), i(1, "12"),
      t("-lg-"), i(1, "12"),
      t("-xl-"), i(1, "12"),
    }), t("\">"), i(2), t("</div>")
  }),

  s("btn", {
    t("<button class=\"btn btn-"), c(1, {
      t("primary"),
      t("secondary"),
      t("success"),
      t("danger"),
      t("warning"),
      t("info"),
      t("light"),
      t("dark"),
    }), t("\">"), i(2, "Button"), t("</button>")
  }),

  -- Comments
  s("comment", {
    t("<!-- "), i(1, "Comment"), t(" -->")
  }),

  s("todo", {
    t("<!-- TODO: "), i(1, "Task description"), t(" -->")
  }),
}