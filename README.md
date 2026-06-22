# httpz

Tiny terminal HTTP status code reference. A sibling to [repoz](https://github.com/Gaurgle/repoz), [noiz](https://github.com/Gaurgle/noiz), and [clockz](https://github.com/Gaurgle/clockz).

Run `httpz` and get a clean, color-coded list of the HTTP status codes you actually run into, grouped 2xx/3xx/4xx/5xx with one-line explanations.

## Install

```bash
git clone https://github.com/Gaurgle/httpz.git
cd httpz
./install.sh
```

Installs to `~/.local/bin` (pass a directory to `install.sh` to change it). No dependencies beyond bash.

## Usage

```bash
httpz        # print all HTTP status codes, grouped and colored
httpz -h     # help
```

That's the whole tool: no flags, no modes. Pipe it if you like - `httpz | grep 4` to filter to 4xx.

## Codes

Covers the ~38 status codes worth keeping at hand (2xx success, 3xx redirects, 4xx client errors, 5xx server errors), including the common-but-easily-forgotten ones like 410 Gone, 422 Unprocessable Entity, 429 Too Many Requests, and 451 Unavailable For Legal Reasons.

To add or edit a code, edit the `http_codes` function in the `httpz` script - one
`group|color|code|name|explanation` line per code.

## Tests

```bash
bats test/httpz.bats
```

## Related

Looking for a searchable, multi-domain code dictionary (HTTP, exit codes, git, curl, and more) in an interactive TUI? That's a separate sibling, **codez** (Rust/ratatui) - in the works.

## License

MIT
