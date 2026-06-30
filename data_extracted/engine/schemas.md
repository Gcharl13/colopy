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

## Binding paths (`GET /api/bind?path=`)

Read-only views into the live game, used by `GetState` nodes and (later) screen widgets:
`game.year`, `game.season`, `game.turn`, `game.difficulty`, `power<N>.gold|tax|royal_money|crosses`,
`ref.regulars|cavalry|manowar|artillery`, `colonies.count`, `units.count`,
`colony<N>.population|sol`, `price.<good 0..15>`.

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
