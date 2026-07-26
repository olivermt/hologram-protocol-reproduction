# Hologram serialized `</script>` reproduction

This branch is a minimal Hologram Skeleton reproduction for
[Hologram issue #959](https://github.com/bartblast/hologram/issues/959).

The home page puts a source-code string containing a literal `</script>` into
its initial component state. Hologram 0.10.1 serializes that state directly into
the inline `pageMountData` script. The HTML parser treats the serialized closing
tag as the end of the bootstrap script.

## Reproduce

The versions from the original report are pinned in `.tool-versions` and
`mix.exs`: Elixir 1.18.3, Erlang/OTP 27, Node.js 22.19.0, and Hologram 0.10.1.

```bash
mix setup
mix phx.server
```

Open [http://localhost:4000](http://localhost:4000) and inspect the browser
console.

## Expected

The source string should round-trip through the initial page state, and the
Hologram page should mount normally.

## Actual

Chrome reports `SyntaxError: Invalid or unexpected token`, and
`globalThis.Hologram.pageMountData` is never created. In the returned HTML, the
inline bootstrap script ends at the `</script>` from the serialized
`source_code` state, and the remainder of the serialized mount data appears as
page text.

The reproduction value is defined in `app/home_page.ex`.
