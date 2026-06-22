# errorz

Tiny terminal error-code reference. A sibling to [repoz](https://github.com/Gaurgle/repoz), [noiz](https://github.com/Gaurgle/noiz), and [clockz](https://github.com/Gaurgle/clockz).

Type `errorz --api` and get a clean, color-coded list of HTTP status codes with one-line explanations.

## Install

```bash
git clone https://github.com/Gaurgle/errorz.git
cd errorz
./install.sh
```

Installs to `~/.local/bin` (pass a directory to `install.sh` to change it). No dependencies beyond bash.

## Usage

```bash
errorz --api      # HTTP status codes, grouped 2xx/3xx/4xx/5xx
errorz 404        # look up a single code across all categories
errorz --help     # full help
errorz            # list available categories
```

### Categories

| Flag     | Domain                         |
|----------|--------------------------------|
| `--api`  | HTTP status codes              |
| `--exit` | Shell exit codes (coming soon) |
| `--git`  | Git errors (coming soon)       |
| `--curl` | curl exit codes (coming soon)  |

## Adding a category

Each domain is one function in the `errorz` script that prints
`group:color|code|name|explanation` lines. To add one:

1. Write a `cat_<name>` function with your rows.
2. Add `<name>` to the `CATEGORIES` string.
3. Add a `title_for` case arm.

No other code changes are needed; the renderer is generic.

## Tests

```bash
bats test/errorz.bats
```

## License

MIT
