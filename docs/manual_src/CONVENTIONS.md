# Manual authoring conventions (ALL agents follow these exactly)

TARGET: a section fragment of COLONIZATION_TECHNICAL_REFERENCE.md — the source for a
print-manual pipeline. The manual documents THE SHIPPED 1994 BINARY AND ITS DATA FILES.

RULES:
1. FACTS ONLY from the repo's byte-verified/pixel-verified docs (spec/, docs/, formats/,
   notes/rulings/RULINGS.md, data_extracted/). NEVER invent. Where the repo says TBD/runtime,
   the manual says "unmapped"/"runtime" honestly. Where confidence is PARTIAL/measured-only,
   label it "(measured; not byte-cited)".
2. Cite evidence as binary file offsets in prose: "at 0x5D186" or "(0x181F:0x4D4)". Function
   labels func_0XXXXX are allowed (they are binary addresses). NO .c/.h citations, NO
   re-implementation helper names, NO repo file paths in the body text (the manual stands alone).
3. Section headings at `## N. Title` level (N assigned below); subsections `###`/`####`.
   Every section opens with a 2-4 sentence lede paragraph (plain prose, no heading).
4. Structs as fenced C code: `typedef struct { ... } Name;` with per-field `// +0xNN offset:
   note` comments (the pipeline turns these into byte plates). Only include fields actually
   mapped; end with a `// +0xNN..+0xNN unmapped (N bytes)` comment line for gaps.
5. Tables liberally: mono/numeric columns, exact values, hex as 0xNN. Keep tables ≤ ~30 rows;
   split with subheadings if longer.
6. UI screens: for each screen give (a) a python-style region list block:
   ```python
   regions = [
       (x, y, w, h, "Label", "panel|hit|text|art", "note"),
   ]  # 320x200 Mode 13h
   ```
   with EXACT byte/pixel-verified coordinates, (b) a region table (bounds, kind, content
   source, state binding), (c) fonts/inks used with palette indices, (d) navigation/keys.
7. Events: rows following the schema fields event_id / string_key / trigger / condition /
   options[] / outcomes (state writes) / arms (downstream). Include full message TEXT with
   %STRING/%NUMBER slots verbatim from the extracted TXT data where load-bearing.
8. Formulas as inline math in prose or small ```text blocks, always with the evidence offset.
9. Pixel-validation results may be summarized as "(pixel-verified against the running game,
   1994 binary under DOSBox)" — no repo artifact paths.
10. Write self-contained prose a game engineer could rebuild from. British-neutral tone,
    matter-of-fact. No marketing.
OUTPUT: write your fragment to the file named in your prompt. Start directly with your first
`## N.` heading. No front matter.
