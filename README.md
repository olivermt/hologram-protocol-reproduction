# Hologram Ash relationship reflection reproduction

This branch reproduces page-bundle growth in raw Hologram `0.10.1` when server-only code references the root of an Ash resource relationship tree.

`HologramSkeleton.ServerAshPanel.init/3` calls `HologramSkeleton.Catalog.resource_summary/0`, which reads relationship names from the root `Product` resource and returns a plain string. The browser only receives that string. No template, client action, or client state requires the Ash resource structs, `__schema__`, or `__changeset__` functions.

The resource graph is intentionally small but tree-shaped:

```text
Product
├── Category ── Department
├── Brand ── Supplier
└── Variant ── Price
```

## Expected

Referencing `Product` from server-only `init/3` should not pull the Ash resource reflection tree into the generated browser page bundle when the client receives only primitive state.

## Actual

This branch uses Hex `hologram == 0.10.1`. The generated page bundle contains reflection functions for the root resource and its related resources, including `__changeset__/0`, `__schema__/1`, `__schema__/2`, `__struct__/0`, and `__struct__/1`.

Measured locally:

| Hologram dep | Runtime bundle | Page bundle | Ash relationship tree in page JS |
| --- | ---: | ---: | --- |
| Hex `0.10.1` | 365,107 bytes | 117,101 bytes | yes |

## Reproduce

Build and inspect the generated bundles:

```bash
git switch ash-reflection-reproduction
mix deps.get
mix clean
HOLOGRAM_START=1 mix compile --force
wc -c priv/static/hologram/runtime-*.js priv/static/hologram/page-*.js
rg "HologramSkeleton\\.Catalog\\.Product|__changeset__|__schema__" priv/static/hologram/page-*.js
```

To see the relationship traversal, grep for all resource modules:

```bash
rg "HologramSkeleton\\.Catalog\\.(Product|Category|Department|Brand|Supplier|Variant|Price)" priv/static/hologram/page-*.js
```

## Relevant code

`app/home_page.ex` renders `<ServerAshPanel />` and has an unrelated counter action to keep client behavior present.

`app/server_ash_panel.ex` calls the Ash helper only from component `init/3` and stores only the returned string.

`lib/hologram_skeleton/catalog.ex` defines the minimal Ash domain and the server-only helper.

`lib/hologram_skeleton/catalog/*.ex` defines the Ash resource relationship tree. The server helper starts at `Product`; the generated page bundle still contains reflection code for the related resources.

## Environment used

- macOS 14.4.1 arm64
- Erlang/OTP 29
- Elixir 1.20.0
- Node.js 22.19.0
