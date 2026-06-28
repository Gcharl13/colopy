// forge/datacheck.hpp -- structural validation of the raw data tables.
//
// The data-table editor's validation backend: it checks the JSON the modder edits
// (data_extracted/tables/names_tables.json) for structural + referential
// soundness, WITHOUT asserting balance values (those are the modder's to set).
// Checks: every row carries its section's declared columns; row_count matches;
// @UNIT stays within the sim enum (NUNITTYPES=24) with non-negative stats;
// @FATHERS.type indexes a real @FOUNDING category.
#pragma once

#include "json.hpp"
#include <string>
#include <vector>

namespace forge {

struct DataReport {
    int sections = 0, rows = 0;
    std::vector<std::string> issues;     // hard structural/referential failures
    std::vector<std::string> warnings;   // softer (e.g., row_count mismatch)
    bool ok() const { return issues.empty(); }
};

// Validate a parsed names_tables document.
DataReport check_data(const JsonValue& root);

// Load + validate a names_tables.json file (throws std::runtime_error on parse error).
DataReport check_data_tables(const std::string& path);

} // namespace forge
