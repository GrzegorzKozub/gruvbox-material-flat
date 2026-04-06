# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
./build.sh    # Generate VS Code themes (runs: cd src && go run ./build.go)
./tm.sh       # Generate TextMate themes (runs build.go with tm flag, then node src/tm.js)
npx eslint .  # Lint JS/MJS/CJS files
npx prettier --write .  # Format files (special handling for *.jsonc)
```

The `themes/` directory contains generated files — always run `./build.sh` after modifying anything in `src/`.

## Architecture

Theme generation is a three-layer pipeline:

**1. Color palette** (`src/{dark,light}/palette.jsonc`)
Defines ~40 template variables (e.g., `bg0`, `red`, `dimOrange`) with hex color values.

**2. UI colors** (`src/{dark,light}/colors.jsonc`)
Maps ~1300 VS Code color keys to palette variables using `{{varName}}` template syntax.

**3. Token colors** (syntax highlighting, in `src/{dark,light}/`)
Multiple profiles merged by the build:
- `token-colors-sainnhe.json` — comprehensive base (47KB)
- `token-colors-greg.json` — custom overrides
- `token-colors-modern.json` — alternative style (not used in default build)
- `token-colors-tm.json` — TextMate-specific overrides (only in `tm` mode)

Default build merges: `sainnhe` + `greg`. TextMate build merges: `tm` + `greg` + `sainnhe`.

**Build script** (`src/build.go`, Go):
Reads palette and color files, replaces `{{varName}}` template variables with actual hex values, merges token color profiles, and writes to `themes/gruvbox-material-flat-{dark,light}-color-theme.json`.

**TextMate conversion** (`src/tm.js`, Node.js):
Converts the generated VS Code JSON themes to plist-based `.tmTheme` format (output is gitignored).

## Go Dependencies

- `github.com/tidwall/gjson` — JSON querying
- `github.com/tidwall/sjson` — JSON modification
- `golang.org/x/text` — Unicode/title case

## Node Dependencies

- `plist` — plist serialization for TextMate output
- `uuid` — UUID generation for TextMate semantic classes
