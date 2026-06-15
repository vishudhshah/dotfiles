-- tex.lua — LuaSnip snippet definitions for LaTeX

--[=[
─── API reference ─────────────────────────────────────────────────────────────

Builder functions:

  autosnip(trig, body [, opts])                auto-triggered, any context
  autosnip_math(trig, body [, opts])           auto-triggered, math mode only
  autosnip_not_math(trig, body [, opts])       auto-triggered, outside math only
  autosnip_line(trig, body [, opts])           auto-triggered, cursor at line start
  autosnip_line_not_math(trig, body [, opts])  auto-triggered, line start + outside math
  snip(trig, body [, opts])                    manual (<Tab>-triggered), any context

trig — the trigger string typed to expand the snippet:
  "abc"    plain literal; fires after typing "abc"
  "%;foo"  Lua pattern; % escapes special chars (here matches "%foo")
  for regex captures, use raw s() API with regTrig=true

body — expansion text (plain string or [[long string]] to avoid \\ escaping):
  $1 $2 ... $0   tabstops in jump order; $0 is the final cursor position
  ${1:default}   tabstop with placeholder text
  repeated $N    automatically becomes a read-only mirror of node N

opts — optional table:
  { word = true }   word-boundary trigger (won't fire mid-word)
  { dscr = "..." }  description shown in completion menus

For complex snippets (regex captures, dynamic nodes, non-sequential tabstops),
use the raw LuaSnip  s({ trig=..., regTrig=true, ... }, { ... })  API directly.

───────────────────────────────────────────────────────────────────────────────
]=]



local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep

-- ─── Conditions ─────────────────────────────────────────────────────────────

local function in_math()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local function not_math()
  return vim.fn["vimtex#syntax#in_mathzone"]() ~= 1
end

local function at_line_start(line_to_cursor, matched_trigger)
  return line_to_cursor:sub(1, -(#matched_trigger + 1)):match("^%s*$") ~= nil
end

local function at_line_start_not_math(line_to_cursor, matched_trigger)
  return at_line_start(line_to_cursor, matched_trigger) and not_math()
end

-- ─── Utilities ──────────────────────────────────────────────────────────────

local function iso_date()
  return os.date("%Y-%m-%d")
end

local function current_filename()
  local full = vim.fn.expand("%:t")
  return full:match("(.+)%..+$") or full
end

-- ─── Snippet builder ────────────────────────────────────────────────────────
-- Body syntax: $1 $2 $0 for tabstops, ${1:default} for defaults.
-- Repeated $N (N≠0) automatically become rep(N) mirrors.
-- Use [[...]] long strings for bodies to avoid double-backslash escaping.

local function parse_body(body)
  local nodes = {}
  local seen = {}
  local pos = 1

  while pos <= #body do
    local dollar = body:find("%$", pos)

    if not dollar then
      local text = body:sub(pos)
      if #text > 0 then
        table.insert(nodes, t(vim.split(text, "\n", { plain = true })))
      end
      break
    end

    if dollar > pos then
      table.insert(nodes, t(vim.split(body:sub(pos, dollar - 1), "\n", { plain = true })))
    end

    local s1, e1, num, def = body:find("%${(%d+):([^}]*)}", dollar)
    if s1 == dollar then
      local n = tonumber(num)
      if n ~= 0 and seen[n] then
        table.insert(nodes, rep(n))
      else
        table.insert(nodes, i(n, def))
        seen[n] = true
      end
      pos = e1 + 1
    else
      local s2, e2, num2 = body:find("%${(%d+)}", dollar)
      if s2 == dollar then
        local n = tonumber(num2)
        if n ~= 0 and seen[n] then
          table.insert(nodes, rep(n))
        else
          table.insert(nodes, i(n))
          seen[n] = true
        end
        pos = e2 + 1
      else
        local s3, e3, num3 = body:find("%$(%d+)", dollar)
        if s3 == dollar then
          local n = tonumber(num3)
          if n ~= 0 and seen[n] then
            table.insert(nodes, rep(n))
          else
            table.insert(nodes, i(n))
            seen[n] = true
          end
          pos = e3 + 1
        else
          table.insert(nodes, t("$"))
          pos = dollar + 1
        end
      end
    end
  end

  return nodes
end

local function make_snip(trig, body, auto, cond, opts)
  opts = opts or {}
  local snip_opts = { trig = trig }
  if auto then snip_opts.snippetType = "autosnippet" end
  snip_opts.wordTrig = opts.word == true
  if opts.dscr then snip_opts.dscr = opts.dscr end
  return s(snip_opts, parse_body(body), cond and { condition = cond } or {})
end

local function autosnip(trig, body, opts)
  return make_snip(trig, body, true, nil, opts)
end

local function autosnip_math(trig, body, opts)
  return make_snip(trig, body, true, in_math, opts)
end

local function autosnip_not_math(trig, body, opts)
  return make_snip(trig, body, true, not_math, opts)
end

local function autosnip_line(trig, body, opts)
  return make_snip(trig, body, true, at_line_start, opts)
end

local function autosnip_line_not_math(trig, body, opts)
  return make_snip(trig, body, true, at_line_start_not_math, opts)
end

local function snip(trig, body, opts)
  return make_snip(trig, body, false, nil, opts)
end



-- ─── Snippets ───────────────────────────────────────────────────────────────

return {

  -- ── Lua / meta ───────────────────────────────────────────────────────────
  autosnip_line("blua",  [[\begin{luacode*}
    $0
\end{luacode*}]]),
  autosnip("lua",   [[\luaexec{$1}]]),
  autosnip_line("evan",  [[\usepackage[sexy]{evan}]]),
  autosnip("today", [[\today]]),

  s({ trig = "date",  snippetType = "autosnippet" }, { f(function() return iso_date() end) }),
  s({ trig = "fname", snippetType = "autosnippet" }, { f(function() return current_filename() end) }),

  -- ── Document templates (bA) ──────────────────────────────────────────────
  autosnip_line("template", [[
\documentclass[12pt]{scrartcl}


\usepackage[margin=1in, head=24pt]{geometry}
\usepackage{setspace}
\singlespacing  % \onehalfspacing, \doublespacing, \setstretch{1.25}

\usepackage[singlespacing=true]{scrlayer-scrpage}
\clearpairofpagestyles
\pagestyle{scrheadings}
\ihead{Vishudh Shah}
\chead{$1}
\ohead{${2:\today}}
\cfoot{\pagemark}
\KOMAoptions{headsepline=true}
\setkomafont{pageheadfoot}{\normalfont}

\usepackage{parskip}

\usepackage{microtype}


\begin{document}

${0:Content goes here.}

\end{document}]]),

  autosnip_line("sbf", [[
% !TeX root = ../main.tex
\documentclass[../main.tex]{subfiles}
\begin{document}

\section[$1]{$2}

$0

\end{document}]]),

  s({ trig = "lec", snippetType = "autosnippet" }, {
    t("\\section[Lecture "), i(1, "X"),
    t("]{Lecture "), rep(1),
    t(" ("), f(function() return iso_date() end), t({ ")}", "", "" }),
    i(0),
  }, { condition = at_line_start }),

  s({ trig = "disc", snippetType = "autosnippet" }, {
    t("\\section[Discussion "), i(1, "X"),
    t("]{Discussion "), rep(1),
    t(" ("), f(function() return iso_date() end), t({ ")}", "", "" }),
    i(0),
  }, { condition = at_line_start }),

  -- ── Section headings (bA) ────────────────────────────────────────────────
  autosnip_line("*subsubsec", [[\subsubsection*{$1}

$0]]),
  autosnip_line("subsubsec", [[\subsubsection{$1}

$0]]),
  autosnip_line("*subsec", [[\subsection*{$1}

$0]]),
  autosnip_line("subsec", [[\subsection{$1}

$0]]),
  autosnip_line("*sec", [[\section*{$1}

$0]]),
  autosnip_line("sec", [[\section{$1}

$0]]),

  -- ── Figures / TikZ (bA) ──────────────────────────────────────────────────
  -- img: non-sequential tabstop order (width=i2 before filename=i1), kept raw
  s({ trig = "img", snippetType = "autosnippet" }, {
    t({ "\\begin{figure}[H]", "\t\\centering", "\t\\includegraphics[width=" }),
    i(2), t("\\textwidth]{"), i(1, "filename"), t({ ".png}", "\t\\caption{" }),
    i(3, "caption"), t({ "}", "\t\\label{fig:" }), i(4, "label"), t({ "}", "\\end{figure}" }),
  }, { condition = at_line_start }),

  s({ trig = "tg", snippetType = "autosnippet" }, {
    t({
      "\\begin{tikzpicture}[",
      "\tnode/.style={circle, draw, thick, minimum size=0.8cm},",
      "\tedge/.style={->, thick}",
      "]",
      "",
      "\t% Top layer",
      "\t\\node[node, fill=black] (1) at (-1,0) {};",
      "\t\\node[node] (2) at (2,0) {};",
      "",
      "\t% Middle layer",
      "\t\\node[node] (3) at (-1,-2) {};",
      "\t\\node[node] (4) at (2,-2) {};",
      "",
      "\t% Bottom layer",
      "\t\\node[node] (5) at (0,-4) {};",
      "",
      "\t% Edges",
      "\t\\draw[edge] (1) -- (2);",
      "\t\\draw[edge] (2) -- (3);",
      "\t\\draw[edge] (2) -- (4);",
      "\t\\draw[edge] (3) -- (5);",
      "\t\\draw[edge] (4) -- (5);",
      "",
      "\\end{tikzpicture}",
    }),
  }, { condition = at_line_start }),

  -- ── Boxes ────────────────────────────────────────────────────────────────
  autosnip_math("box",           [[\boxed{$1}]]),
  autosnip_line_not_math("box",  [[
\begin{tcolorbox}[colback=white, colframe=black, boxrule=0.5pt, boxsep=0pt, sharp corners]
    $0
\end{tcolorbox}]]),

  -- ── Misc formatting ──────────────────────────────────────────────────────
  autosnip_line("---", [[\hrulebar]]),
  autosnip_math("bb",  [[\mathbb{$1}]]),
  autosnip_math("cal", [[\mathcal{$1}]]),
  autosnip(         "bbb", [[\textbf{$1}]]),
  autosnip_not_math("iii", [[\textit{$1}]]),
  autosnip_math("jj", [[_j]]),
  autosnip_math("kk", [[_k]]),

  -- ── Math mode ────────────────────────────────────────────────────────────
  autosnip("mk", [[\($1\)$0]], { word = true }),
  autosnip("dm", "\\[ $0 \\]", { word = true }),

  -- ── Environments (bA) ────────────────────────────────────────────────────
  -- beg: second $1 auto-mirrors via rep(1)
  autosnip_line("beg",   [[\begin{$1}
    $0
\end{$1}]]),
  autosnip_line("align", [[\begin{align*}
    $0
\end{align*}]]),
  autosnip_line("eqn",   [[\begin{equation}
    $0
\end{equation}]]),
  autosnip_line("pf",    [[\begin{proof}
    $0
\end{proof}]]),
  autosnip_line("defn",  [[\begin{definition}
    $0
\end{definition}]]),
  autosnip_line("thm",   [[\begin{theorem}
    $0
\end{theorem}]]),
  autosnip_line("lem",   [[\begin{lemma}
    $0
\end{lemma}]]),
  autosnip_line("prop",  [[\begin{proposition}
    $0
\end{proposition}]]),
  autosnip_line("cor",   [[\begin{corollary}
    $0
\end{corollary}]]),
  autosnip_line("egs",   [[\begin{example}
    $0
\end{example}]]),
  autosnip_line("rem",   [[\begin{remark}
    $0
\end{remark}]]),
  autosnip_line("ques",  [[\begin{ques*}
    $0
\end{ques*}]]),
  autosnip_line("ans",   [[\begin{answer*}
    $0
\end{answer*}]]),
  autosnip_line("sol",   [[\begin{soln}
    $0
\end{soln}]]),
  autosnip_line("code",  [[\begin{lstlisting}[language=$1, caption={$2}]
$0
\end{lstlisting}]]),
  autosnip_line("pkg",   [[\usepackage{${1:package}}$0]]),
  autosnip_line("uls",   [[\begin{itemize}
    \item $0
\end{itemize}]]),
  autosnip_line("ols",   [[\begin{enumerate}
    \item $0
\end{enumerate}]]),

  -- ── Table / array / matrix (regex, dynamic nodes) ────────────────────────
  s({
    trig = "table (%d+) (%d+)",
    regTrig = true,
    dscr = "Table (N rows × M cols)",
    snippetType = "autosnippet",
  }, {
    d(1, function(_, snip)
      local nrow = tonumber(snip.captures[1])
      local ncol = tonumber(snip.captures[2])
      if not nrow or not ncol then return sn(nil, { i(0) }) end
      local nodes = {}
      local col_spec = string.rep("c|", ncol - 1) .. "c"
      table.insert(nodes, t({
        "\\begin{table}[h]",
        "\t\\centering",
        "\t\\begin{tabular}{" .. col_spec .. "}",
        "\t\t\\hline",
        "\t\t",
      }))
      local idx = 1
      for row = 1, nrow do
        for col = 1, ncol do
          table.insert(nodes, i(idx)); idx = idx + 1
          if col < ncol then table.insert(nodes, t(" & ")) end
        end
        table.insert(nodes, t(" \\\\"))
        if row == 1 then
          table.insert(nodes, t({ "", "\t\t\\hline", "\t\t" }))
        elseif row < nrow then
          table.insert(nodes, t({ "", "\t\t" }))
        end
      end
      table.insert(nodes, t({ "", "\t\t\\hline", "\t\\end{tabular}" }))
      table.insert(nodes, t("\n\t\\caption{"))
      table.insert(nodes, i(idx)); idx = idx + 1
      table.insert(nodes, t("}\n\t\\label{tab:"))
      table.insert(nodes, i(idx))
      table.insert(nodes, t({ "}", "\\end{table}" }))
      return sn(nil, nodes)
    end),
  }, { condition = at_line_start_not_math }),

  s({
    trig = "ary (%d+) (%d+)",
    regTrig = true,
    dscr = "Array (N rows × M cols)",
    snippetType = "autosnippet",
  }, {
    d(1, function(_, snip)
      local nrow = tonumber(snip.captures[1])
      local ncol = tonumber(snip.captures[2])
      if not nrow or not ncol then return sn(nil, { i(0) }) end
      local col_spec = string.rep("c", ncol)
      local nodes = {}
      table.insert(nodes, t({ "\\begin{array}{" .. col_spec .. "}", "\t" }))
      local idx = 1
      for row = 1, nrow do
        if row > 1 then table.insert(nodes, t({ "", "\t" })) end
        for col = 1, ncol do
          table.insert(nodes, i(idx)); idx = idx + 1
          if col < ncol then table.insert(nodes, t(" & ")) end
        end
        table.insert(nodes, t(" \\\\"))
      end
      table.insert(nodes, t({ "", "\\end{array}" }))
      return sn(nil, nodes)
    end),
  }, { condition = in_math }),

  s({
    trig = "mat (%d+) (%d+)",
    regTrig = true,
    dscr = "Matrix (N rows × M cols)",
    snippetType = "autosnippet",
    priority = 2000,
  }, {
    d(1, function(_, snip)
      local nrow = tonumber(snip.captures[1])
      local ncol = tonumber(snip.captures[2])
      if not nrow or not ncol then return sn(nil, { i(0) }) end
      local nodes = {}
      table.insert(nodes, t("\\begin{"))
      table.insert(nodes, i(1, "b"))
      table.insert(nodes, t({ "matrix}", "" }))
      local idx = 2
      for row = 1, nrow do
        table.insert(nodes, t("\t"))
        for col = 1, ncol do
          table.insert(nodes, i(idx)); idx = idx + 1
          if col < ncol then table.insert(nodes, t(" & ")) end
        end
        table.insert(nodes, t(" \\\\"))
        if row < nrow then table.insert(nodes, t({ "", "" })) end
      end
      table.insert(nodes, t({ "", "\\end{" }))
      table.insert(nodes, rep(1))
      table.insert(nodes, t("matrix}"))
      table.insert(nodes, i(0))
      return sn(nil, nodes)
    end),
  }, { condition = in_math }),

  -- ── Vectors / column vector ───────────────────────────────────────────────
  autosnip_math("col", [[\begin{bmatrix} $1 \end{bmatrix}$0]]),

  -- ── Auto subscripts (regex, math) ────────────────────────────────────────
  s({ trig = "([A-Za-z])(%d)", regTrig = true, wordTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return snip.captures[1] end),
    t("_"),
    f(function(_, snip) return snip.captures[2] end),
  }, { condition = in_math }),

  s({ trig = "([A-Za-z])_(%-?%d%d)", regTrig = true, wordTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return snip.captures[1] end),
    t("_{"),
    f(function(_, snip) return snip.captures[2] end),
    t("}"),
  }, { condition = in_math }),

  -- ── Exponents / scripts (iA, math) ───────────────────────────────────────
  autosnip_math("sq",   [[^2]]),
  autosnip_math("cb",   [[^3]]),
  autosnip_math("comp", [[^{\mathsf{c}}]]),
  autosnip_math("^^",   [[^{$1}$0]]),
  autosnip_math("__",   [[_{$1}$0]]),
  autosnip_math("inv",  [[^{-1}]]),
  autosnip_math("TT",   [[^\top]]),

  -- ── Fractions ────────────────────────────────────────────────────────────
  autosnip_math("//", [[\frac{$1}{$2}$0]]),

  s({ trig = "(%d+)/", regTrig = true, wordTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\frac{" .. snip.captures[1] .. "}" end),
    t("{"), i(1), t("}"), i(0),
  }, { condition = in_math }),

  s({ trig = "(%d*\\?[%a][%w%^%_%{%}\\]*)/" , regTrig = true, wordTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\frac{" .. snip.captures[1] .. "}" end),
    t("{"), i(1), t("}"), i(0),
  }, { condition = in_math }),

  s({ trig = "(.-)%)/", regTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip)
      local str = snip.captures[1] .. ")"  -- re-attach ) consumed by trigger
      local depth = 0
      local start_idx = #str
      for idx = #str, 1, -1 do
        local ch = str:sub(idx, idx)
        if ch == ")" then depth = depth + 1
        elseif ch == "(" then
          depth = depth - 1
          if depth == 0 then start_idx = idx; break end
        end
      end
      return str:sub(1, start_idx - 1) .. "\\frac{" .. str:sub(start_idx + 1, -2) .. "}"
    end),
    t("{"), i(1), t("}"), i(0),
  }, { condition = in_math }),

  -- ── Decorators: postfix then plain (regex must come first) ───────────────
  s({ trig = "([%\\]?%w+)(,%.%s*|%.,%s*)", regTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\vec{" .. snip.captures[1] .. "}" end),
  }, { condition = in_math }),
  s({ trig = "([a-zA-Z])vec",  regTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\vec{" .. snip.captures[1] .. "}" end)
  }, { condition = in_math }),
  s({ trig = "([a-zA-Z])bar",  regTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\bar{" .. snip.captures[1] .. "}" end)
  }, { condition = in_math }),
  s({ trig = "([a-zA-Z])hat",  regTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\hat{" .. snip.captures[1] .. "}" end)
  }, { condition = in_math }),
  s({ trig = "([a-zA-Z])tild", regTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\tilde{" .. snip.captures[1] .. "}" end)
  }, { condition = in_math }),
  s({ trig = "([a-zA-Z])line", regTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\overline{" .. snip.captures[1] .. "}" end)
  }, { condition = in_math }),

  autosnip_math("vec",  [[\vec{$1}$0]]),
  autosnip_math("bar",  [[\bar{$1}$0]]),
  autosnip_math("hat",  [[\hat{$1}$0]]),
  autosnip_math("tild", [[\tilde{$1}$0]]),
  autosnip_math("line", [[\overline{$1}$0]]),

  -- ── Dots ─────────────────────────────────────────────────────────────────
  autosnip(      "c%.",     [[\cdots]]),
  autosnip(      "d%.",     [[\ddots]]),
  autosnip(      "l%.",     [[\ldots]]),
  autosnip_math( "%.%.%.",  [[\dots]]),

  -- ── Logic / relations (iA, math) ─────────────────────────────────────────
  autosnip_math("=>",  [[\implies ]]),
  autosnip_math("=<",  [[\impliedby]]),
  autosnip_math("iff", [[\iff ]]),
  autosnip_math("==",  [[&= $1 \\]]),
  autosnip_math("!=",  [[\neq ]]),
  autosnip_math("≠",   [[\neq ]]),
  autosnip_math("neq", [[\neq ]]),
  autosnip_math("<=",  [[\leq ]]),
  autosnip_math("≤",   [[\leq ]]),
  autosnip_math(">=",  [[\geq ]]),
  autosnip_math("≥",   [[\geq ]]),
  autosnip_math("~~",  [[\sim ]]),
  autosnip_math("~=",  [[\approx ]]),
  autosnip_math("≈",   [[\approx ]]),
  autosnip_math("perp",[[\perp ]]),
  autosnip_math("<<",  [[\ll ]]),
  autosnip_math(">>",  [[\gg ]]),

  -- ── Arrows (iA, math) ────────────────────────────────────────────────────
  autosnip_math("<->", [[\leftrightarrow]]),
  autosnip_math("|->", [[\mapsto ]]),
  autosnip_math("->",  [[\to ]]),
  autosnip_math("to",  [[\to ]], { word = true }),

  -- ── Sets (iA, math) ──────────────────────────────────────────────────────
  autosnip_math("\\\\\\", [[\setminus]]),
  autosnip_math("cc",  [[\subset ]]),
  autosnip_math("inn", [[\in ]]),
  autosnip_math("uu",  [[\cup ]]),
  autosnip_math("nn",  [[\cap ]]),
  autosnip_math("OO",  [[\varnothing]]),
  autosnip_math("||",  [[\mid ]]),
  autosnip_math("UU",  [[\bigcup_{${1:i \in }${2: I}} $0]]),
  autosnip_math("NN",  [[\bigcap_{${1:i \in }${2: I}} $0]]),

  -- ── Quantifiers / operators (iA, math) ───────────────────────────────────
  autosnip_math("EE",  [[\exists ]]),
  autosnip_math("AA",  [[\forall ]]),
  autosnip_math("xx",  [[\times ]]),
  autosnip_math("•",   [[\cdot ]]),
  autosnip_math("x.",  [[\cdot ]]),
  autosnip_math("+-",  [[\pm ]]),
  autosnip_math("pm",  [[\pm ]]),
  autosnip_math("-+",  [[\mp]]),
  autosnip_math("oo",  [[\infty]]),
  autosnip_math("PP",  [[\prob]]),
  autosnip_math("st",  [[\text{ s.t. } ]]),

  -- ── Calculus (wA, math) ──────────────────────────────────────────────────
  autosnip_math("sssum",  [[\sum_{${1:n}=${2:1}}^{${3:\infty}} $0]], { word = true }),
  autosnip_math("ssum",   [[\sum_{$1} $0]],                          { word = true }),
  autosnip_math("sum",    [[\sum ]],                                  { word = true }),
  autosnip_math("llim",   [[\lim_{${1:n} \to ${2:\infty}} ]],        { word = true }),
  autosnip_math("lim",    [[\lim]],                                   { word = true }),
  autosnip_math("iiint",  [[\int_{${1:-\infty}}^{${2:\infty}} $3 \,\mathrm{d}${4:x}]], { word = true }),
  autosnip_math("iint",   [[\int_{${1:-\infty}}^{${2:\infty}} $0]],  { word = true }),
  autosnip_math("int",    [[\int $1 \,\mathrm{d}${2:x}]],            { word = true }),
  autosnip_math("ppprod", [[\prod_{${1:n}=${2:1}}^{${3:\infty}} $0]], { word = true }),
  autosnip_math("pprod",  [[\prod_{$1} $0]],                          { word = true }),
  autosnip_math("prod",   [[\prod ]],                                  { word = true }),
  -- taylor: 2nd and 3rd $1 auto-become rep(1)
  autosnip_math("taylor", [[\sum_{${1:k}=${2:0}}^{${3:\infty}} ${4:c_}$1 (x-a)^$1 $0]], { word = true }),
  autosnip_math("lsup",   [[\limsup]], { word = true }),
  autosnip_math("linf",   [[\liminf]], { word = true }),
  autosnip_math("par",    [[\partial]], { word = true }),
  autosnip_math("sr",     [[\sqrt{$1}]]),
  autosnip_math("cr",     [[\sqrt[3]{$1}]]),
  autosnip_math("nr",     [[\sqrt[$1]{$2}]]),

  -- ── Trig / operators (wA, math, regex) ───────────────────────────────────
  s({ trig = "a(rc)?(sin|cos|tan|csc|sec|cot)", regTrig = true, trigEngine = "ecma", wordTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\arc" .. snip.captures[2] end),
  }, { condition = in_math }),

  s({ trig = "(sin|cos|tan|csc|sec|cot|min|max|inf|sup|log|ln|exp)", regTrig = true, trigEngine = "ecma", wordTrig = true, snippetType = "autosnippet" }, {
    f(function(_, snip) return "\\" .. snip.captures[1] end),
  }, { condition = in_math }),

  -- ── Misc math ────────────────────────────────────────────────────────────
  autosnip_math("floor",  [[\left\lfloor $1 \right\rfloor$0]]),
  autosnip_math("ceil",   [[\left\lceil $1 \right\rceil $0]]),
  autosnip_math("abs",    [[\abs{$1}$0]]),
  autosnip_math("norm",   [[\norm{$1}$0]]),
  autosnip_math("bin",    [[\binom{$1}{$2}]]),
  autosnip_math("lll",    [[\ell]]),
  autosnip_math("set",    [[\set{$1}$0]]),
  autosnip_math("txt",    [[\text{$1}$0]]),
  autosnip_math("rm",     [[\mathrm{$1}$0]]),
  autosnip_math("dag",    [[\dag]]),
  autosnip_math("ubrace", [[\underbrace{$1}_{${2:label}}$0]]),
  autosnip_math("fn",     [[$1 \colon $2 \to $0]]),

  autosnip_math("case", [[\begin{cases}
    $0
\end{cases}]], { word = true }),

  -- ── Left/right delimiters (iA, math) ─────────────────────────────────────
  autosnip_math("lr%(",  [[\left( $1 \right)$0]]),
  autosnip_math("lr|",   [[\left| $1 \right|$0]]),
  autosnip_math("lr\\|", [[\left\| $1 \right\|$0]]),
  autosnip_math("lr{",   [[\left\{ $1 \right\}$0]]),
  autosnip_math("lr%[",  [[\left[ $1 \right]$0]]),
  autosnip_math("lr%.",  [[\left. $1 \right|$0]]),
  autosnip_math("lr<",   [[\innerprod{$1}{$2}$0]]),
  autosnip_math("<>",    [[\innerprod{$1}{$2}$0]]),

  -- ── Greek letters (iA, math) ─────────────────────────────────────────────
  autosnip_math(";a",  [[\alpha]]),
  autosnip_math(";b",  [[\beta]]),
  autosnip_math(";G",  [[\Gamma]]),
  autosnip_math(";g",  [[\gamma]]),
  autosnip_math(";D",  [[\Delta]]),
  autosnip_math(";d",  [[\delta]]),
  autosnip_math(";e",  [[\varepsilon]]),
  autosnip_math(";z",  [[\zeta]]),
  autosnip_math(";h",  [[\eta]]),
  autosnip_math(";;t", [[\tau]]),
  autosnip_math(";T",  [[\Theta]]),
  autosnip_math(";t",  [[\theta]]),
  autosnip_math(";i",  [[\iota]]),
  autosnip_math(";k",  [[\kappa]]),
  autosnip_math(";L",  [[\Lambda]]),
  autosnip_math(";l",  [[\lambda]]),
  autosnip_math(";m",  [[\mu]]),
  autosnip_math(";n",  [[\nu]]),
  autosnip_math(";X",  [[\Xi]]),
  autosnip_math(";x",  [[\xi]]),
  autosnip_math(";P",  [[\Pi]]),
  autosnip_math(";p",  [[\pi]]),
  autosnip_math("π",   [[\pi]]),
  autosnip_math(";r",  [[\rho]]),
  autosnip_math(";S",  [[\Sigma]]),
  autosnip_math(";s",  [[\sigma]]),
  autosnip_math(";U",  [[\Upsilon]]),
  autosnip_math(";u",  [[\upsilon]]),
  autosnip_math(";F",  [[\Phi]]),
  autosnip_math(";f",  [[\phi]]),
  autosnip_math(";c",  [[\chi]]),
  autosnip_math(";Y",  [[\Psi]]),
  autosnip_math(";y",  [[\psi]]),
  autosnip_math(";O",  [[\Omega]]),
  autosnip_math(";o",  [[\omega]]),
}
