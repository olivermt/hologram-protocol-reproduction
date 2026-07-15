# Hologram protocol bundle reproduction

This project reproduces shared client-runtime bundle growth in Hologram 0.10.1 when a server-only page initializer calls an Ash type backed by Tempo.

The Tempo value is created and normalized on the server. The page receives only a plain string. No client action accepts, returns, or references a Tempo value.

## Expected

Dependencies reachable only from `Hologram.Page.init/3` should not be included in the shared browser runtime when the initialized component state contains only client-supported primitive values.

## Actual

Changing the server helper from a plain custom `Ash.Type` to the Tempo-backed custom `Ash.Type` grows the unminified shared runtime from 356,796 bytes to 4,471,166 bytes, approximately 12.5 times larger.

| Stage | Tag | Runtime bundle | Page bundle |
| --- | --- | ---: | ---: |
| Plain Hologram 0.10.1 | `baseline` | 356,796 bytes | 13,021 bytes |
| Server-only plain Ash type | `ash-control` | 356,796 bytes | 13,021 bytes |
| Tempo installed but unused | `tempo-dependency-control` | 356,796 bytes | 13,021 bytes |
| Server-only Tempo-backed Ash type | `trigger` | 4,471,166 bytes | 21,377 bytes |

The first three stages produce byte-for-byte identical JavaScript bundles. In the trigger build, the shared runtime contains Tempo, Calendrical, Localize, and protocol implementation modules such as every `Localize.Chars.*` implementation.

## Reproduce

The project uses Hologram `== 0.10.1`, Ash `3.27.7`, and ex_tempo `0.21.0` from Hex. It does not require a database.

Build and measure the dependency-only control:

```bash
git switch tempo-dependency-control
mix deps.get
mix clean
HOLOGRAM_START=1 mix compile --force
wc -c priv/static/hologram/runtime-*.js priv/static/hologram/page-*.js
```

Build and measure the trigger:

```bash
git switch trigger
mix deps.get
mix clean
HOLOGRAM_START=1 mix compile --force
wc -c priv/static/hologram/runtime-*.js priv/static/hologram/page-*.js
```

The first Hologram build also installs Hologram's compiler-side JavaScript dependencies.

To run the trigger in a browser:

```bash
PORT=4107 mix holo
```

Open [http://localhost:4107](http://localhost:4107). The page displays the server-produced string and includes an unrelated client-side counter to demonstrate the intended boundary.

## Relevant code

`app/home_page.ex` calls `HologramSkeleton.ServerValue.load/0` only from `init/3` and stores the returned string. Its `action/3` callback only increments an integer.

`lib/hologram_skeleton/server_value.ex` parses and formats the duration on the server. Switching this helper from `PlainText` to `TempoDuration` is the effective trigger.

`lib/hologram_skeleton/types/tempo_duration.ex` is the representative application type. It implements `Ash.Type` callbacks for parsing, normalizing, dumping, atomic casting, and generation.

## Environment used

- macOS arm64
- Erlang/OTP 28
- Elixir 1.19.0
- Hologram 0.10.1
