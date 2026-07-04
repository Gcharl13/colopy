// session.hpp -- the game session's public surface (N0).
//
// One running game = one set of these globals + the lifecycle calls below.
// Extracted from forge/main.cpp so the native application (`viceroy`) and
// the web/editor HTTP routes drive the SAME session code. State stays as
// module globals for now (the strangler step: names and behavior unchanged);
// a struct-owned session is a later refactor if multiple sessions are needed.
#pragma once
#include "engine.hpp"      // forge::EngineExtra, JsonValue
#include "game.hpp"        // GameState, World (sim include dir)
#include "rules.hpp"       // RuleData
#include <cstdint>
#include <functional>
#include <string>
#include <utility>
#include <vector>

// ---- canonical session state (defined in session.cpp) ----
extern vc::sim::GameState g_game;
extern vc::sim::World     g_world;
extern std::vector<std::pair<int,int>> g_colony_xy;  // colony map positions
extern forge::EngineExtra g_engine_extra;            // relational engine state
extern bool g_game_active;
extern int  g_end_year;                              // retirement year
extern vc::sim::RuleData g_active_rules;             // live (possibly modded) ruleset

// Deterministic session RNG (LCG; seeded by game_new / load).
int game_rng(int lo, int hi);

// ---- lifecycle ----
// Boot a new game from the scenario data (nation/difficulty per the setup
// screen; random_map generates instead of loading AMER2; p_* = the map-
// generator parameters from the setup screen).
void game_new(int nation = 0, int difficulty = 1, bool random_map = false,
              int p_land = 1, int p_cont = 1, int p_temp = 1, int p_clim = 1);
// Advance one full turn (the byte-faithful end-turn pipeline: production,
// market, immigration, natives, King/REF, diplomacy, events, autosave).
void game_step();

// ---- persistence ----
bool save_game_to(const std::string& path);

// ---- shared player commands (the HTTP routes + the native editor) ----------
// Named unit order (unit_orders.md status letters): "P" clear/plow, "R" road,
// "F" fortify, "S" sentry, "T" trade route, "D" disband, "L"/"U"/"O" cargo
// load/unload/dump, "-" clear; with `order` empty, GOTO to (tx,ty).
struct OrderResult { bool ok = false; std::string err; };
OrderResult unit_order(int ui, const std::string& order, int tx = -1, int ty = -1,
                       int route = -1, int hold = -1);

// Found/join a colony with unit ui (the ~B command): site warnings
// (@TUTNOSPACES/@TUTNOLUMBER), Join Colony on an own colony, the @INDIANLAND
// native land demand (pay/claim), then the founding itself. `acks` lists the
// confirm keys the player already accepted; `land_choice` = ""|"pay"|"claim".
// When a confirmation is pending nothing changes and confirm/text/choices set.
struct FoundResult {
    bool ok = false;
    std::string err;                 // rejection (when !ok and confirm empty)
    std::string confirm, text;       // pending confirmation @KEY + filled text
    long price = 0;                  // the @INDIANLAND asking price
    int choices = 0;                 // trailing option-row count in `text`
};
FoundResult found_colony(int ui, const std::vector<std::string>& acks,
                         const std::string& land_choice = "");

// Trade-route CRUD (trade_routes.md 4: func_0610B0 create with the 12-route
// cap + name uniqueness, func_0612E6 delete with carrier rebinding).
// Returns "" on success, else the user-facing rejection.
std::string route_create(const std::string& name, int type,
                         const std::vector<vc::sim::TradeStop>& stops);
std::string route_delete(int ri);

// Declare independence (the @GAME menu row): the 50% national-SoL gate plus
// the func_03E2EA Continental-promotion pass. "" on success (promoted count
// via out param), else the user-facing rejection.
std::string declare_independence(int* out_promoted = nullptr);

// Colony construction (context_dialogs.md §12, availability = func_0B900):
// the buildable list for colony ci (gates: already built, in progress,
// min-colony @0xB940, chain prereq/supersede @0xB97D/@0xB956, FF requirement),
// start/stop a build, and the rush-buy (@BUYME1 backend). start/rush return
// "" on success, else the user-facing reason.
struct BuildOption { int id = -1; std::string name; int cost = 0; int min_colony = 0; };
std::vector<BuildOption> colony_build_options(int ci);
std::string colony_start_build(int ci, int bid);
std::string colony_rush_build(int ci, long* out_cost = nullptr);
// FF gates: Custom House (18) needs Peter Stuyvesant (#3); the factory tier
// (5/23/26/29/34/41) needs Adam Smith (#0). Reason string, or nullptr.
const char* building_ff_requirement(int bid, uint32_t ff_owned);

// The colony display name (the NAMES colony-name pool by index, as the
// colony screen titles it).
std::string colony_display_name(int ci);

// Atlantic crossing (europe_screen.md sail-states; time byte-cited @0x41871:
// 2 turns, 1 with Magellan). Start a ship east ("Return to Europe", the E
// accelerator) or west (departing the Europe docks); "" on success, else the
// user-facing reason. sail_step advances crossings each turn (in game_step).
std::string sail_to_europe(int ui);
std::string sail_to_new_world(int ui);
void sail_step();

// ---- per-turn history (the Play sparkline / /api/history) ----
struct HistPoint { long turn; int year; long gold; int sol; long population; };
extern std::vector<HistPoint> g_history;
void history_snapshot();

// ---- state views (JSON used by the routes today; the app reads the
// globals directly until the native screens need structured views) ----
forge::JsonValue game_state_json();
forge::JsonValue colony_detail_json(int ci);
forge::JsonValue colony_screen_json(int ci);
forge::JsonValue fathers_json();
forge::JsonValue report_state_json();

// ---- notices / tutorial queues the UI drains each turn ----
extern std::vector<std::string> g_turn_notices;
extern std::vector<std::pair<std::string, std::string>> g_tutorial_queue;
void tutorial_fire(uint16_t bit, const std::string& key,
                   const std::vector<std::string>& s = {},
                   const std::vector<long>& n = {});
void tutorial_fire2(uint8_t bit, const std::string& key,
                    const std::vector<std::string>& s = {},
                    const std::vector<long>& n = {});
void tutorial_fire_x(uint8_t bit, const std::string& key,
                     const std::vector<std::string>& s = {},
                     const std::vector<long>& n = {});
std::string tutorial_home_port();

// ---- text/label lookups (GAME.TXT / LABELS.TXT sections) ----
std::string game_message_text(const std::string& key);
const std::vector<std::string>& labels_section(const char* s);
std::string good_display(int g);
std::string nation_name(int p);

// ---- turn-loop sub-steps the routes also trigger directly ----
void auto_export_step();
void spanish_succession_step();
void tory_uprising_step();
void war_resolution_step();
void congress_step(forge::EngineExtra& x, int diff, int year, int bells_this_turn,
                   std::function<int(int,int)> rng);
bool building_chain_blocked(const vc::sim::Colony& c, int bid,
                            int* out_blocker, bool* out_super);
bool game_is_water(int id);
vc::sim::RuleData live_market_rules(const forge::EngineCtx& cx);
void read_extra(const forge::JsonValue* o, forge::EngineExtra& x);
extern const char* ACTIVE_RULES_PATH;

// ---- the isolated colony sandbox (a second mini-session) ----
extern vc::sim::GameState g_sb_game;
extern vc::sim::World g_sb_world;
extern std::vector<std::pair<int,int>> g_sb_colony_xy;
extern forge::EngineExtra g_sb_extra;
extern bool g_sb_active;
void sandbox_new(int pop);
forge::JsonValue sandbox_state_json();
int sb_rng(int lo, int hi);

// ---- tiny JSON builders shared by session + routes ----
forge::JsonValue jbool(bool b);
forge::JsonValue jarr();
forge::JsonValue jobj();
forge::JsonValue jstr(const std::string& s);
forge::JsonValue jstrs(const std::vector<std::string>& xs);
