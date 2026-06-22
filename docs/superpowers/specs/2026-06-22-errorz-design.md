# errorz - design

**Date:** 2026-06-22
**Status:** Approved, pre-implementation

## Summary

`errorz` is a tiny print-and-exit bash tool that prints a nicely formatted,
color-coded reference of error codes for a given domain, selected by a flag.
v1 ships the HTTP status-code domain (`--api`). It is a sibling to `repoz`,
`noiz`, and `clockz`: single file, Catppuccin Mocha palette, `install.sh` into
`~/.local/bin`.

Example:

```
$ errorz --api

  errorz - HTTP status codes
  ────────────────────────────────────────────────────

  ── 2xx Success ───────────────────────────────────────
    200  OK ················· Request succeeded
    201  Created ············ New resource created

  ── 4xx Client ────────────────────────────────────────
    400  Bad Request ········ Malformed syntax / invalid input
    404  Not Found ·········· Resource doesn't exist
```

## Goals

- One command, one flag → a clean, grouped, colored list of error codes.
- Adding a new domain is a trivial, repeatable edit (one function + one
  registry entry), so the list can grow into the user's domains over time.
- Visually and structurally consistent with `repoz`.

## Non-goals (v1)

- No interactive/TUI mode (ratatui). Print and exit only.
- No config file. No user-tunable behavior yet.
- No network calls. Pure embedded data.

## Architecture

Single bash script `errorz`, targeting **bash 3.2** (macOS default; `repoz`
targets 3.2, so no associative arrays).

### Components

1. **Palette + width setup** - copied from `repoz`: Catppuccin Mocha colors via
   `printf '\033[38;2;R;G;Bm'`, terminal-width detection, `DIV` / `DIV_W`.

2. **Render helpers** - reused from `repoz`:
   - `section_div "label"` → `  ── label ──────...` (group headers)
   - `print_row name status ...` → 4-space indent, name in Sapphire, `·`
     dot-leaders, status colored. Adapted so the "name" is the code and the
     "status" is the explanation.

3. **Domain data functions** - one per domain, `cat_<domain>`, each emitting
   pipe-delimited rows to stdout via a quoted heredoc:

   ```
   group:color|code|name|explanation
   ```

   - `group:color` - section label plus a color name (`green`, `yellow`,
     `red`, `blue`, `peach`). Rows sharing a group are drawn under one
     `section_div`; the status text inherits the group color.
   - `code` - the error code (`200`, `127`, ...).
   - `name` - short label (`OK`, `Not Found`).
   - `explanation` - one-line meaning.

   v1 implements `cat_api` fully. `cat_exit`, `cat_git`, `cat_curl` are present
   as registered stubs ready to fill.

4. **Registry** - a space-separated string `CATEGORIES="api exit git curl"` and
   a `case` mapping each to its title (e.g. `api` → `HTTP status codes`). Flags
   are derived as `--<category>`. Adding a domain = write `cat_<x>`, add `<x>`
   to `CATEGORIES`, add a title case arm.

5. **Generic renderer** `render_category <name>`:
   - Prints header `  errorz - <title>` + divider.
   - Reads `cat_<name>` output, drawing a new `section_div` each time the group
     changes and a `print_row` per code.

6. **Color map** `color_for <name>` → palette variable, so group color names in
   the data resolve to escape codes.

7. **Arg parser** - `while`/`case` over `$@` (same style as `repoz`).

### Data flow

```
argv ──▶ parse ──▶ dispatch
                     ├─ --<cat> ─▶ render_category <cat> ─▶ cat_<cat> ─▶ rows ─▶ section_div/print_row
                     ├─ <code>  ─▶ lookup_code <code> ─▶ greps all cat_* ─▶ prints matches w/ domain label
                     ├─ --help  ─▶ usage
                     └─ (none)  ─▶ usage + category list
```

## CLI behavior

Long flags first (short flags added in a later pass):

| Invocation        | Behavior                                                        | Exit |
|-------------------|----------------------------------------------------------------|------|
| `errorz --api`    | Print HTTP status codes, grouped 2xx/3xx/4xx/5xx                | 0    |
| `errorz 404`      | Cross-domain lookup: print every row whose code matches `404`, each tagged with its domain | 0 if found, 1 if not |
| `errorz`          | Usage + list of available categories                           | 0    |
| `errorz --help`   | Usage                                                          | 0    |
| `errorz --bogus`  | `Unknown: --bogus` + usage                                     | 1    |

## Header / em-dash note

`repoz` writes its header with an em-dash (`repoz — subtitle`). Per the user's
hard no-em-dash rule, `errorz` uses a hyphen: `errorz - HTTP status codes`. This
deviation from the sibling is intentional.

## v1 HTTP dataset (`cat_api`)

Grouped and colored:

- **2xx Success** (green): 200 OK, 201 Created, 202 Accepted, 204 No Content
- **3xx Redirect** (blue): 301 Moved Permanently, 302 Found, 304 Not Modified,
  307 Temporary Redirect, 308 Permanent Redirect
- **4xx Client** (yellow): 400 Bad Request, 401 Unauthorized, 403 Forbidden,
  404 Not Found, 405 Method Not Allowed, 409 Conflict, 422 Unprocessable
  Entity, 429 Too Many Requests
- **5xx Server** (red): 500 Internal Server Error, 502 Bad Gateway, 503 Service
  Unavailable, 504 Gateway Timeout

(402 Payment Required included under 4xx as the user referenced it.)

## Install

`install.sh` mirroring `repoz`: copy `errorz` to `${1:-$HOME/.local/bin}`,
`chmod +x`, PATH note. No external dependencies (no `gh`/`jq`).

## Testing

`bats` (or a plain assertion script if bats is unavailable). Behavior, not
implementation:

- `errorz --api` exits 0 and output contains `200`, `404`, `500` and their names.
- `errorz --api` output contains the group headers (e.g. `4xx`).
- `errorz 404` finds the row and tags it with the `api` domain; exit 0.
- `errorz 999` (no match) → exit 1.
- `errorz --bogus` → exit 1 and prints usage.
- `errorz` (no args) → exit 0 and lists `api` as an available category.

## File layout

```
errorz/
  errorz            # the script
  install.sh
  README.md
  LICENSE           # MIT, matching siblings
  test/errorz.bats  # or test/test.sh
  docs/superpowers/specs/2026-06-22-errorz-design.md
```
