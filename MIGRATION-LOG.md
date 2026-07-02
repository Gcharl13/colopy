# MIGRATION-LOG — Drydock refactor (engine-dev-environment-spec.md)

One entry per landed increment: what changed, what was retired, test status.

| # | Increment | Retired | Tests |
|---|---|---|---|
| 0 | Phase 0: GAP-ANALYSIS.md + rulings (C++17; web shell for P1–P2; migration order approved) | — | gate G green (10/10 ctest + selftests + validators) |
| 1 | spec-P0a: canonical text module (`drydock/text/rec_text.{hpp,cpp}` parser + deterministic serializer, canonical int/float, escapes, nesting lint) + `drydock_tests` (21 assertions incl. the byte-identical round-trip) wired as ctest #11 | — | 11/11 ctest green; forge selftests + parity oracle unaffected |
