// drydock/pack -- the compiled pack (spec §4.1 representation #3). P0 keeps it
// minimal-but-real: validated records, canonical bytes, deterministic layout.
// Ref pre-resolution and mmap-friendly fixed layout arrive with the typed
// store (P1) -- noted, not scaffolded.
//
// Layout (little-endian):
//   char[6]  "DDPK1\n"
//   u32      record count
//   per record: u32 id_len, id bytes, u32 body_len, canonical text bytes
// Records are sorted by id, so identical stores produce identical packs.
#pragma once
#include "../text/rec_text.hpp"
#include <string>
#include <vector>

namespace drydock {

bool pack_write(const std::string& path, std::vector<Record> records, std::string& err);
bool pack_read(const std::string& path, std::vector<Record>& out, std::string& err);

} // namespace drydock
