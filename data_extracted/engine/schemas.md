# Forge engine — data schemas

The game is **data the engine runs and the IDE authors**. Logic is authored visually as
**node graphs** (Blueprint-inspired); these JSON files are only the serialization behind the
editor — you don't hand-edit them.

## Node graph (`graphs/<id>.json`)

```json
{
  "id": "kings_tax",
  "name": "King's Tax Demand",
  "nodes": [ { "id": "n1", "type": "OnTurnStart", "x": 40, "y": 60, "params": {} }, ... ],
  "edges": [ { "from": { "node": "n1", "pin": "out" }, "to": { "node": "n2", "pin": "in" } }, ... ]
}
```

- **nodes** — placed instances. `type` indexes the Node Catalog (`GET /api/nodes`). `params`
  are the node's inline values (numbers, text, selects, binding paths). `x,y` are canvas coords.
- **edges** — wires. A wire connects an output pin `from` to an input pin `to`. Pins are either
  **exec** (control flow, fired in order) or **data** (a value pulled on demand).

### Pin kinds
- **exec** — white control-flow wires. A node runs, does its effect, then fires its exec output.
- **data** — typed value wires (number/bool). Pulled lazily when a node needs an input; if an
  input data pin is unwired, the node's same-named **param** is used instead.

### Node types (first set; see `GET /api/nodes` for the live catalog)
- *Triggers*: `OnTurnStart`, `OnTestFire` (editor Run button).
- *Flow*: `Branch` (cond→true/false), `Sequence`, `Roll` (random min..max).
- *Data*: `Constant`, `GetState` (binding path), `Math`, `Compare`.
- *Actions*: `GrantGold`, `SetTax`, `SetPrice`, `AddColonyPop`, `Log`.
- *Dialog*: `ShowPopup` (title/body/choices; each choice is an exec output pin → the runtime
  pauses, returns the popup, and resumes down the chosen pin).

## Variables — one namespace for the logic and the tables (`GET /api/bind?path=`)

There is a single variable namespace shared by the logic graphs and the data tables. The full,
machine-readable catalog is **`variables.json`** (live-state names + every table section/column);
the sim's functions and their inputs/outputs are in **`functions.json`** (also `GET /api/formulas`).

**Live game state** — resolved by `forge/engine.cpp resolve_binding`; each maps to a real DGROUP
field. Groups: `game.*` (year/season/turn/difficulty/score), `power<N>.*`
(gold/tax/royal_money/crosses/mil_strength/econ_strength/colonies/units/strength), `colony<N>.*`
(population/sol/bells/hammers/food/crosses/owner/build_target/build_cost/build_bank/
build_remaining/building_name/warehouse/built.<id>), `unit<N>.*`
(type/owner/profession/x/y/alive/attack/defense/movement/terrain/terraindef), `natives.tension`,
`congress.*` (bells/cost/era_band/count), `ff.count`/`ff.<id>`, `revolution.*`, `succession.seceded`,
`colonies.count`/`colonies.population`, `units.count`, `ref.*`, `price.<good>`, `boycott.<good>`,
`war.<a>.<b>`, `terrain.defense.<id>`. Writable ones (via `POST /api/bind/set`): year/season/turn/
difficulty, power gold/tax/crosses/mil_strength/econ_strength, colony population, natives.tension,
revolution.sol, congress.bells, price.<good>.

**Data-table cells** — `@SECTION[<row>].<column>` where `<row>` is an index or `name:VALUE`, e.g.
`@BUILDING[name:Fort].cost`, `@CLASS[3].transport_cost`, `@UNIT[name:Soldiers].attack`. Resolved
against the live tables (preferring your Tables-tab edits), so **any row you add is immediately
usable in any logic function** — no code change. Numeric cells return numbers, text cells strings.

These names work anywhere a value is read: `GetState` paths, `Formula` expressions, `ShowPopup`/
`Notify` `{binding}` interpolation, and screen-widget text.

### Newer node types (see `GET /api/nodes` for the live catalog)
- **`Formula`** — one node for a whole expression over the variables above plus `+ - * / %`,
  comparisons (→1/0), `? :`, `min/max/clamp/abs/floor/ceil`, `roll(lo,hi)`, and the `a..d` pins.
  Collapses long Constant/Math/Compare chains (e.g. the king's-tax severity score → one node).
- **`Notify`** — emits a real GAME.TXT message (`textKey`/`textKeys`, with `%NUMBER`/`%STRING`
  fill) as the run output, replacing hand-typed `Log` strings.
- **`StartBuilding` / `BuildStep` / `RushBuild`** — the colony construction + manual-purchase loop
  (cost/min from `@BUILDING`; rush cost is a Formula, RECONSTRUCTED — see `notes/rulings`).

## Running a graph (`POST /api/graph/run`)

Body `{ "id": "..." }` or `{ "graph": {...} }`. Returns `{ log, effects, popup }`. When a
`ShowPopup` is hit, `popup` is `{ title, body, node, choices }` and the run pauses; resume with
`{ "graph"|"id", "from_node": "<that node id>", "choice": "<chosen pin>" }`.

## Screens (`screens/<id>.json`, phase E4)

```json
{ "id": "colony", "background": "COLONY", "size": [320,200],
  "widgets": [ { "id":"w1", "type":"label", "rect":[90,1,140,8], "font":"tiny",
                 "color":"82,138,49", "text":"%S0", "binds": {"S0":"colony0.name"},
                 "onClick": "<graph id>" }, ... ] }
```
Widget `type` maps 1:1 to the spec draw-verbs (label, value, rect, sprite, gauge, list, button,
panel). A button's `onClick` references a node graph.
