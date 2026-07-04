// game_shell.cpp -- the platform-free playable game (see game_shell.hpp).
// The logic is a faithful port of the editor's Game view (studio_main.cpp):
// same session commands, same composers, same key map -- minus ImGui.
#include "game_shell.hpp"
#include "game_assets.hpp"
#include "session.hpp"
#include "engine.hpp"          // EngineCtx, resolve_binding, job_name,
                               // colony_compute_production
#include "drydock_api.hpp"     // drydock_store
#include "savegame.hpp"        // parse_game / LoadedGame (Load Game)
#include "../drydock/core/store.hpp"
#include "colony_screen.hpp"
#include "mapview.hpp"
#include "popup_render.hpp"
#include "sim/unit.hpp"
#include "sim/unit_turn.hpp"
#include "sim/market.hpp"
#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstring>

using drydock::Record;
using drydock::Store;
using drydock::Value;

namespace forge {

// ------------------------------------------------------------- session glue
static vc::Map session_map() {
    vc::Map m;
    m.w = g_world.map_w;
    m.h = g_world.map_h;
    m.tiles = g_world.terrain;
    return m;
}

bool GameShell::boot(std::string& err) {
    std::string msg;
    if (!forge::drydock_store_init("data", msg)) {
        err = "record store: " + msg;
        return false;
    }
    if (!game_assets_ensure()) {
        err = "assets: " + game_assets().err;
        return false;
    }
    return true;
}

void GameShell::new_game(int nation, int difficulty) {
    game_new(nation, difficulty);
    vc::sim::refresh_moves(g_world, g_active_rules);
    g_game_active = true;
    sel_ = next_own_unit(-1);
    if (sel_ >= 0) center_on(g_world.units[sel_].x, g_world.units[sel_].y);
    game_log("A new world awaits.");
}

bool GameShell::active() const { return g_game_active; }

std::string GameShell::save(const std::string& path) {
    return save_game_to(path) ? "saved: " + path : "save failed: " + path;
}

std::string GameShell::load(const std::string& path) {
    try {   // the /api/game/load path (same as the editor's File > Load Game)
        forge::JsonValue root = forge::json_parse_file(path);
        forge::LoadedGame lg = forge::parse_game(forge::json_dump(root));
        g_game = lg.g;
        g_world = lg.w;
        g_colony_xy.clear();
        if (const forge::JsonValue* cxy = root.find("colony_xy"))
            for (const auto& e : cxy->arr)
                if (e.arr.size() >= 2)
                    g_colony_xy.push_back({(int)e.arr[0].num, (int)e.arr[1].num});
        g_engine_extra = forge::EngineExtra{};
        read_extra(root.find("engine_extra"), g_engine_extra);
        g_game_active = true;
        vc::sim::refresh_moves(g_world, g_active_rules);
        sel_ = next_own_unit(-1);
        if (sel_ >= 0) center_on(g_world.units[sel_].x, g_world.units[sel_].y);
        return "game loaded";
    } catch (const std::exception& e) {
        return std::string("load failed: ") + e.what();
    }
}

void GameShell::game_log(const std::string& s) {
    log_.push_back(s);
    if (log_.size() > 8) log_.erase(log_.begin());
    status = s;
}

// ------------------------------------------------------------- host hooks
void GameShell::open_colony(int ci) {
    if (ci < 0 || ci >= (int)g_world.colonies.size()) return;
    colony_view_ = ci;
    europe_view_ = false;
    report_view_ = 0;
    build_open_ = false;
}
void GameShell::open_europe() {
    europe_view_ = true;
    colony_view_ = -1;
    report_view_ = 0;
}
void GameShell::open_report(int f) {
    if (f < 1 || f > 10) return;
    report_view_ = f;
    colony_view_ = -1;
    europe_view_ = false;
}
void GameShell::resync() {
    colony_view_ = -1;
    europe_view_ = false;
    report_view_ = 0;
    confirm_open_ = picker_open_ = goto_mode_ = build_open_ = false;
    menu_open_ = -1;
    sel_ = next_own_unit(-1);
    if (sel_ >= 0) center_on(g_world.units[sel_].x, g_world.units[sel_].y);
}

int GameShell::next_own_unit(int from) const {
    int n = (int)g_world.units.size();
    if (n == 0) return -1;
    for (int k = 1; k <= n; ++k) {
        int i = (from + k) % n;
        const vc::sim::Unit& u = g_world.units[i];
        if (u.alive && u.owner == 0 && u.sail == 0 && !u.in_europe) return i;
    }
    return -1;
}

void GameShell::clamp_view() {
    if (ox_ < 0) ox_ = 0;
    if (oy_ < 0) oy_ = 0;
    if (ox_ > g_world.map_w - 15) ox_ = g_world.map_w - 15;
    if (oy_ > g_world.map_h - 12) oy_ = g_world.map_h - 12;
}
void GameShell::center_on(int x, int y) { ox_ = x - 7; oy_ = y - 6; clamp_view(); }

bool GameShell::try_step(int ui, int dx, int dy) {
    if (ui < 0 || ui >= (int)g_world.units.size()) return false;
    vc::sim::Unit& u = g_world.units[ui];
    if (!u.alive || u.moves_left <= 0) return false;
    int nx = u.x + dx, ny = u.y + dy;
    // stepping east off the Sea Lane column sails for Europe (the sea lane is
    // the right-edge column, map hard rule 2; crossing per session sail_*)
    if (dx > 0 && nx >= g_world.map_w &&
        g_world.terrain_id(u.x, u.y) == 26) {
        std::string why = sail_to_europe(ui);
        game_log(why.empty() ? "sailing for Europe" : why);
        if (why.empty() && ui == sel_) sel_ = next_own_unit(sel_);
        return why.empty();
    }
    if (nx < 0 || ny < 0 || nx >= g_world.map_w || ny >= g_world.map_h) return false;
    int id = g_world.terrain_id(nx, ny);
    bool water = (id == 25 || id == 26);
    bool naval = vc::sim::unit_stats(g_active_rules, u.type).move_class == 99;
    if (water != naval) return false;
    if (vc::sim::unit_at(g_world, nx, ny, ui) >= 0) return false;
    int base = id >= 0 && id < vc::sim::NTERRAIN
                   ? g_active_rules.terrain_move[id % vc::sim::NTERRAIN] : 1;
    u.x = nx; u.y = ny;
    u.moves_left -= naval ? 3 : base * 3;
    if (u.moves_left < 0) u.moves_left = 0;
    return true;
}

void GameShell::end_turn() {
    game_step();
    vc::sim::refresh_moves(g_world, g_active_rules);
    for (const std::string& n : g_turn_notices) game_log(n);
    g_turn_notices.clear();
    sel_ = next_own_unit(sel_);
    if (sel_ >= 0) center_on(g_world.units[sel_].x, g_world.units[sel_].y);
}

// ------------------------------------------------ found-colony confirm flow
void GameShell::found_attempt(const std::string& land_choice) {
    FoundResult fr = found_colony(sel_, found_acks_, land_choice);
    if (!fr.confirm.empty()) {
        confirm_key_ = fr.confirm;
        confirm_lines_.clear();
        confirm_choices_.clear();
        std::vector<std::string> lines;
        std::string cur;
        for (char c : fr.text) {
            if (c == '\r') continue;
            if (c == '\n') { lines.push_back(cur); cur.clear(); }
            else cur += c;
        }
        lines.push_back(cur);
        while (!lines.empty() && lines.back().empty()) lines.pop_back();
        int nch = fr.choices > 0 ? fr.choices : 2;
        for (size_t i = 0; i < lines.size(); ++i) {
            if ((int)(lines.size() - i) <= nch) confirm_choices_.push_back(lines[i]);
            else confirm_lines_.push_back(lines[i]);
        }
        while (!confirm_lines_.empty() && confirm_lines_.back().empty())
            confirm_lines_.pop_back();
        confirm_open_ = true;
        confirm_hover_ = -1;
        return;
    }
    found_acks_.clear();
    if (fr.ok) {
        game_log("colony founded");
        sel_ = next_own_unit(sel_);
    } else {
        game_log(fr.err);
    }
}

void GameShell::found_choice(const std::string& c) {
    confirm_open_ = false;
    auto has = [&](const char* w) {
        std::string lc = c;
        for (auto& ch : lc) ch = (char)tolower(ch);
        return lc.find(w) != std::string::npos;
    };
    if (confirm_key_ == "@INDIANLAND") {
        if (has("offer")) {
            found_acks_.push_back(confirm_key_);
            found_attempt("pay");
        } else if (has("mistaken")) {
            found_acks_.push_back(confirm_key_);
            found_attempt("claim");
        } else {
            found_acks_.clear();
        }
        return;
    }
    if (has("anyway")) {
        found_acks_.push_back(confirm_key_);
        found_attempt("");
    } else {
        found_acks_.clear();
    }
}

// -------------------------------------------------------------- colony view
static const int RDX[8] = {-1, 0, 1, -1, 1, -1, 0, 1};
static const int RDY[8] = {-1, -1, -1, 0, 0, 1, 1, 1};

void GameShell::assign_worker(int colony, int tile, int profession, int good) {
    vc::sim::Colony& c = g_world.colonies[colony];
    for (int w = 0; w < (int)c.workers.size(); ++w)
        if (c.workers[w].tile == tile) {
            c.workers.erase(c.workers.begin() + w);
            break;
        }
    vc::sim::Colony::Worker wk;
    wk.profession = profession;
    wk.tile = tile;
    wk.good = good;
    wk.expert = false;
    int tid = g_world.terrain_id(c.x + RDX[tile], c.y + RDY[tile]);
    wk.terrain = tid < 0 ? 2 : (tid & 0x1F);
    c.workers.push_back(wk);
    if ((int)c.workers.size() > c.population)
        c.population = (int)c.workers.size();
    forge::colony_compute_production(c, g_game.difficulty, g_active_rules,
                                     g_engine_extra.ff_owned, 0, &g_world,
                                     g_game.rumor_seed);
}

// the 28 @JOB rows sorted by index, with the good each produces
struct ProfRow { int index; std::string name; int good; };
static std::vector<ProfRow> prof_rows() {
    std::vector<ProfRow> out;
    Store* st = forge::drydock_store();
    if (!st) return out;
    auto pi = st->type_index.find("prof");
    auto gi = st->type_index.find("good");
    if (pi == st->type_index.end()) return out;
    for (const Record& p : st->records[pi->second]) {
        const Value* ix = p.find("index");
        const Value* nm = p.find("name");
        const Value* pr = p.find("produces");
        if (!ix || !nm) continue;
        ProfRow row{(int)ix->i, nm->s, 0};
        if (pr && gi != st->type_index.end())
            for (const Record& gr : st->records[gi->second])
                if (gr.id == pr->s)
                    if (const Value* gx = gr.find("index")) row.good = (int)gx->i;
        out.push_back(row);
    }
    std::sort(out.begin(), out.end(),
              [](const ProfRow& a, const ProfRow& b) { return a.index < b.index; });
    return out;
}

void GameShell::click_colony(int mx, int my, int button) {
    if (colony_view_ < 0 || colony_view_ >= (int)g_world.colonies.size()) return;
    if (build_open_) { click_build(mx, my, button); return; }
    if (button == 0 && mx < 200 && my >= 8 && my < 128) {
        // the town view opens the construction menu (context_dialogs.md §12;
        // the exact colony-screen hotspot is not byte-cited -- RECONSTRUCTED
        // as the whole SCENE band)
        build_open_ = true;
        build_sel_ = 0;
        build_page_ = 0;
        return;
    }
    vc::sim::Colony& c = g_world.colonies[colony_view_];
    int col = (mx - 224) / 24, row = (my - 32) / 24;
    if (mx >= 224 && my >= 32 && col >= 0 && col < 3 && row >= 0 && row < 3 &&
        !(col == 1 && row == 1)) {
        int tile = -1;
        for (int t = 0; t < 8; ++t)
            if (RDX[t] == col - 1 && RDY[t] == row - 1) tile = t;
        if (button == 1) {                     // right-click: profession picker
            picker_open_ = true;
            picker_tile_ = tile;
            picker_cursor_ = 0;
        } else {
            int existing = -1;
            for (int w = 0; w < (int)c.workers.size(); ++w)
                if (c.workers[w].tile == tile) existing = w;
            if (existing >= 0) {
                c.workers.erase(c.workers.begin() + existing);
                game_log("colonist taken off the fields");
                forge::colony_compute_production(
                    c, g_game.difficulty, g_active_rules,
                    g_engine_extra.ff_owned, 0, &g_world, g_game.rumor_seed);
            } else {
                assign_worker(colony_view_, tile, 19, 0);   // Farmer default
                game_log("farmer assigned to the fields");
            }
        }
    }
}

// ------------------------- colony construction (context_dialogs.md §12) ----
// The build menu runs the verbatim @CTITLE labels ("Select An Item To Build",
// "(No Production)", "(More)", "Turns)", "BUY") over the func_0B900 buildable
// list (session colony_build_options). Row highlight = the 1-px hollow
// outline (§2.1); the dialog is the shared wood-plaque chrome.
struct BuildRow {
    std::string text;
    int action;          // >=0 building id; -1 no production; -2 BUY; -3 more
};
static const int BUILD_PAGE_ROWS = 12;

static std::string ctitle_at(int i, const char* fallback) {
    const std::vector<std::string>& m = labels_section("CTITLE");
    return i >= 0 && i < (int)m.size() && !m[i].empty() ? m[i] : fallback;
}

static std::vector<BuildRow> build_rows(int ci, int page, int& pages) {
    const vc::sim::Colony& c = g_world.colonies[ci];
    std::vector<BuildRow> all;
    all.push_back({ctitle_at(5, "(No Production)"), -1});
    if (c.build_target >= 0) {
        long remaining = (long)c.build_cost - (long)c.build_bank;
        if (remaining < 0) remaining = 0;
        long gold = remaining * g_active_rules.cfg.rush_gold_per_hammer;
        all.push_back({ctitle_at(2, "BUY") + "  (" + std::to_string(gold) +
                       " gold to complete)", -2});
    }
    int rate = c.hammers_per_turn;
    for (const BuildOption& o : colony_build_options(ci)) {
        std::string turns =
            rate > 0 ? "(" + std::to_string((o.cost + rate - 1) / rate) + " " +
                           ctitle_at(7, "Turns)")
                     : "(-- " + ctitle_at(7, "Turns)");
        all.push_back({o.name + "  " + turns, o.id});
    }
    pages = ((int)all.size() + BUILD_PAGE_ROWS - 1) / BUILD_PAGE_ROWS;
    if (pages < 1) pages = 1;
    page %= pages;
    std::vector<BuildRow> rows(
        all.begin() + page * BUILD_PAGE_ROWS,
        all.begin() + std::min((page + 1) * BUILD_PAGE_ROWS, (int)all.size()));
    if (pages > 1) rows.push_back({ctitle_at(6, "(More)"), -3});
    return rows;
}

// the centered dialog box (shared geometry engine: centered when @x/@y = -1)
static void build_box(int ci, const std::vector<BuildRow>& rows,
                      int& bx, int& by, int& bw, int& bh, std::string& title,
                      std::string& info) {
    static vc::Surface meas;
    vc::NativeAssets& A = game_assets().nat;
    const vc::sim::Colony& c = g_world.colonies[ci];
    title = ctitle_at(4, "Select An Item To Build");
    info.clear();
    if (c.build_target >= 0) {
        forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra,
                            g_active_rules, game_rng};
        std::string bn = forge::resolve_binding(
            "@BUILDING[" + std::to_string(c.build_target) + "].name", cx).str;
        info = "Building " + bn + "  (" + std::to_string(c.build_bank) + " of " +
               std::to_string(c.build_cost) + " hammers)";
    }
    bw = 160;
    int tw = meas.text_width(A.font, title) + 14;
    if (tw > bw) bw = tw;
    if (!info.empty() && (tw = meas.text_width(A.font, info) + 14) > bw) bw = tw;
    for (const BuildRow& r : rows)
        if ((tw = meas.text_width(A.font, r.text) + 14) > bw) bw = tw;
    int header = 9 + (info.empty() ? 0 : 9);
    bh = header + (int)rows.size() * 9 + 6;
    bx = (vc::Surface::W - bw) / 2;
    by = (vc::Surface::H - bh) / 2;
    if (by < 8) by = 8;
}

void GameShell::compose_build(vc::Surface& scr) {
    vc::NativeAssets& A = game_assets().nat;
    int pages = 1;
    std::vector<BuildRow> rows = build_rows(colony_view_, build_page_, pages);
    int bx, by, bw, bh;
    std::string title, info;
    build_box(colony_view_, rows, bx, by, bw, bh, title, info);
    uint8_t outline = vc::nearest_pal_index(A.pal, 20, 12, 6);
    uint8_t selbar  = vc::nearest_pal_index(A.pal, 56, 32, 16);
    uint8_t green   = vc::nearest_pal_index(A.pal, 82, 138, 49);
    uint8_t gold    = vc::nearest_pal_index(A.pal, 227, 170, 40);
    if (A.woodtile.nframes > 0) {
        const vc::Frame& f = A.woodtile.frames[0];
        for (int yy = 0; yy < bh; ++yy)
            for (int xx = 0; xx < bw; ++xx)
                scr.put(bx + xx, by + yy,
                        f.px[(size_t)(yy % f.h) * f.w + (xx % f.w)]);
    }
    scr.rect_outline(bx, by, bw, bh, outline);
    scr.fill_rect(bx + 1, by + 1, bw - 2, 9, selbar);
    scr.draw_text(A.font, bx + 5, by + 2, title, green);
    int y = by + 9;
    if (!info.empty()) {
        scr.draw_text(A.font, bx + 5, y + 2, info, green);
        y += 9;
    }
    for (int i = 0; i < (int)rows.size(); ++i) {
        int ry = y + 3 + i * 9;
        scr.draw_text(A.font, bx + 7, ry + 1, rows[i].text,
                      i == build_sel_ ? gold : green);
        if (i == build_sel_)   // 1-px hollow row outline (context_dialogs §2.1)
            scr.rect_outline(bx + 3, ry, bw - 6, 9, gold);
    }
}

void GameShell::key_build(int k) {
    int pages = 1;
    std::vector<BuildRow> rows = build_rows(colony_view_, build_page_, pages);
    int n = (int)rows.size();
    if (k == GK_ESC) { build_open_ = false; return; }
    if (k == GK_UP && build_sel_ > 0) --build_sel_;
    if (k == GK_DOWN && build_sel_ + 1 < n) ++build_sel_;
    if ((k == GK_LEFT || k == GK_RIGHT) && pages > 1) {
        build_page_ = (build_page_ + (k == GK_RIGHT ? 1 : pages - 1)) % pages;
        build_sel_ = 0;
    }
    if ((k == GK_ENTER || k == ' ') && build_sel_ < n) {
        const BuildRow& r = rows[build_sel_];
        vc::sim::Colony& c = g_world.colonies[colony_view_];
        switch (r.action) {
            case -3:                                             // (More)
                build_page_ = (build_page_ + 1) % pages;
                build_sel_ = 0;
                return;
            case -2: {                                           // BUY
                long cost = 0;
                std::string why = colony_rush_build(colony_view_, &cost);
                game_log(why.empty() ? "construction complete (" +
                                           std::to_string(cost) + " gold)"
                                     : why);
                break;
            }
            case -1:                                             // (No Production)
                c.build_target = -1;
                game_log("construction halted");
                break;
            default: {
                std::string why = colony_start_build(colony_view_, r.action);
                game_log(why.empty() ? "now building: " + r.text : why);
                break;
            }
        }
        build_open_ = false;
    }
}

void GameShell::click_build(int mx, int my, int button) {
    (void)button;
    int pages = 1;
    std::vector<BuildRow> rows = build_rows(colony_view_, build_page_, pages);
    int bx, by, bw, bh;
    std::string title, info;
    build_box(colony_view_, rows, bx, by, bw, bh, title, info);
    if (mx < bx || mx >= bx + bw || my < by || my >= by + bh) {
        build_open_ = false;                     // click-away closes
        return;
    }
    int y0 = by + 9 + (info.empty() ? 0 : 9) + 3;
    int row = (my - y0) / 9;
    if (row >= 0 && row < (int)rows.size()) {
        build_sel_ = row;
        key_build(GK_ENTER);
    }
}

void GameShell::compose_colony(vc::Surface& scr) {
    vc::NativeAssets& A = game_assets().nat;
    vc::sim::Colony& c = g_world.colonies[colony_view_];
    const vc::IndexedPng* backdrop = atlas_file("pik/COLONY.png");
    static vc::Sheet parch;
    if (parch.nframes == 0)
        if (const vc::Frame* pf = sheet_window("PARCH")) {
            parch.nframes = 1;
            parch.frames.push_back(*pf);
        }
    if (!backdrop || parch.nframes == 0) {
        scr.clear(0);
        scr.draw_text(A.font, 8, 8, "COLONY.PIK / PARCH sheet unavailable", 15);
        return;
    }
    vc::Map m = session_map();
    int stock[16];
    for (int i = 0; i < 16; ++i)
        stock[i] = i < (int)c.stockpile.size() ? c.stockpile[i] : 0;
    render_colony_screen(scr, *backdrop, parch, A.woodtile, A.icons, A.buildings,
                         A.font, A.terrain, A.phys, &m, c.x, c.y, c,
                         (int)g_game.powers[0].gold, g_game.powers[0].tax,
                         (int)g_game.year, stock);
    if (build_open_) compose_build(scr);
    if (picker_open_) compose_picker(scr);
}

// the profession picker, drawn in the game's popup chrome (2-column list)
void GameShell::compose_picker(vc::Surface& scr) {
    vc::NativeAssets& A = game_assets().nat;
    std::vector<ProfRow> rows = prof_rows();
    vc::PopupSpec ps;
    ps.lines.push_back("Choose a profession (arrows + Enter, Esc cancels):");
    int n = (int)rows.size();
    int half = (n + 1) / 2;
    for (int i = 0; i < half; ++i) {
        std::string l = (picker_cursor_ == i ? "> " : "  ") + rows[i].name;
        while (l.size() < 22) l += ' ';
        int j = half + i;
        if (j < n) l += (picker_cursor_ == j ? "> " : "  ") + rows[j].name;
        ps.lines.push_back(l);
    }
    vc::PopupLayout L = vc::popup_layout(A.font, ps);
    static const vc::IndexedPng no_panl;
    const vc::IndexedPng* panl = atlas_file("pik/WOODPANL.png");
    vc::render_popup(scr, panl ? *panl : no_panl, A.font, ps, L);
}

// -------------------------------------------------------------- Europe view
void GameShell::compose_europe(vc::Surface& scr) {
    vc::NativeAssets& A = game_assets().nat;
    const vc::IndexedPng* backdrop = atlas_file("pik/EUROPE.png");
    scr.clear(0);
    if (backdrop)
        scr.blit_region(*backdrop, 0, 0, backdrop->w, backdrop->h, 0, 0);
    uint8_t title_c = vc::nearest_pal_index(A.pal, 255, 255, 190);
    uint8_t val_c = vc::nearest_pal_index(A.pal, 247, 243, 199);
    char tl[96];
    std::snprintf(tl, sizeof tl, "London, England.  Year %d.  Tax: %d%%  Gold: %lld",
                  (int)g_game.year, g_game.powers[0].tax,
                  (long long)g_game.powers[0].gold);
    scr.draw_text(A.font, 8, 1, tl, title_c);
    for (int gd = 0; gd < 16; ++gd) {
        int cx = gd * 19;
        int fi = 22 + gd;
        if (fi < A.icons.nframes) {
            const vc::Frame& f = A.icons.frames[fi];
            scr.blit_frame(f, cx + (19 - f.w) / 2, 180);
        }
        int bid = vc::sim::market_bid(g_game, 0, gd);
        int ask = vc::sim::market_ask(g_game, 0, gd, g_active_rules);
        char pr[16];
        std::snprintf(pr, sizeof pr, "%d/%d", bid, ask);
        int tw = scr.text_width(A.font, pr);
        scr.draw_text(A.font, cx + (19 - tw) / 2, 194, pr, val_c);
    }
    scr.draw_text(A.font, 146, 108, "On the dock (click to recruit):", title_c);
    for (int s = 0; s < 3; ++s) {
        int cls = g_game.powers[0].dock_pool[s];
        std::string nm = "-";
        if (cls >= 0) {
            if (cls < vc::sim::NUNITTYPES) {
                const char* n = vc::sim::unit_stats(g_active_rules, cls).name;
                nm = n ? n : "colonist";
            } else {
                nm = forge::job_name(cls, false);
            }
        }
        std::string row = std::to_string(s + 1) + ". " + nm;
        scr.draw_text(A.font, 146, 117 + s * 9, row, val_c);
    }
    scr.draw_text(A.font, 4, 170, "click a good: sell 1   right-click: buy 1", val_c);
    // Ships In Port (europe_screen.md docks band: slots x=147+12*slot, y=165;
    // caption slot [0x2dd2] "No Ships In Port" when empty): the units docked
    // via the Atlantic crossing. Click a ship to sail it back west.
    int slot = 0;
    for (int i = 0; i < (int)g_world.units.size() && slot < 6; ++i) {
        const vc::sim::Unit& u = g_world.units[i];
        if (!u.alive || u.owner != 0 || !u.in_europe) continue;
        if (u.type >= 0 && u.type < A.units.nframes)
            scr.blit_frame(A.units.frames[u.type], 147 + 12 * slot, 150);
        ++slot;
    }
    scr.draw_text(A.font, 146, 141,
                  slot ? "In port (click a ship: sail west):" : "No Ships In Port",
                  title_c);
}

void GameShell::click_europe(int mx, int my, int button) {
    if (mx >= 146 && my >= 150 && my < 168 && button == 0) {   // docked ships
        int slot = 0;
        for (int i = 0; i < (int)g_world.units.size(); ++i) {
            const vc::sim::Unit& u = g_world.units[i];
            if (!u.alive || u.owner != 0 || !u.in_europe) continue;
            if (mx >= 147 + 12 * slot && mx < 147 + 12 * (slot + 1)) {
                std::string why = sail_to_new_world(i);
                game_log(why.empty() ? "the ship sails for the New World" : why);
                return;
            }
            ++slot;
        }
        return;
    }
    if (mx >= 146 && my >= 117 && my < 144 && button == 0) {   // recruit rows
        int s = (my - 117) / 9;
        int cls = s >= 0 && s < 3 ? g_game.powers[0].dock_pool[s] : -1;
        if (cls >= 0) {
            long cost = 0;
            if (g_engine_extra.free_recruits > 0) {
                --g_engine_extra.free_recruits;
            } else {
                forge::EngineCtx cx{g_game, g_world, g_colony_xy, g_engine_extra,
                                    g_active_rules, game_rng};
                int row = cls == 0x19 ? 0 : cls == 0x1A ? 1 : 2;
                cost = forge::resolve_binding(
                    "@CLASS[" + std::to_string(row) + "].transport_cost", cx).as_int();
                if (cost < 0) cost = 0;
                if (g_game.powers[0].gold < cost) {
                    game_log("not enough gold to recruit");
                    return;
                }
                g_game.powers[0].gold -= cost;
            }
            vc::sim::Unit u;
            u.owner = 0;
            u.alive = true;
            if (cls < vc::sim::NUNITTYPES) u.type = cls;
            else { u.type = vc::sim::COLONISTS; u.profession = cls; }
            if (!g_colony_xy.empty()) {
                u.x = g_colony_xy[0].first;
                u.y = g_colony_xy[0].second;
            }
            g_world.units.push_back(u);
            g_game.powers[0].dock_pool[s] = -1;
            game_log("recruited for " + std::to_string(cost));
        }
        return;
    }
    if (my >= 179 && mx < 304) {                               // market bar
        int gd = mx / 19;
        if (gd >= 0 && gd < 16) {
            if (button == 0) {
                long net = vc::sim::market_sell(g_game, 0, gd, 1, g_active_rules);
                game_log("sold 1 for " + std::to_string(net));
            } else {
                int ask = vc::sim::market_ask(g_game, 0, gd, g_active_rules);
                if (g_game.powers[0].gold >= ask) {
                    long cost = vc::sim::market_buy(g_game, 0, gd, 1, g_active_rules);
                    game_log("bought 1 for " + std::to_string(cost));
                } else {
                    game_log("not enough gold");
                }
            }
        }
    }
}

// ------------------------------------------------ pulldown menu (menus.md §6)
// The map-screen bar (GAME .. COLONIZOPEDIA, geometry exported by mapview)
// runs the verbatim MENU records (@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP
// @PEDIA). The dropdown opens at the label x, below the bar (y=8), and the
// selection is a 1-px hollow outline (menus.md §6.3 RULING, not a filled
// cell). `~` is the hotkey-underline marker, `#` a value-fill placeholder.
static const char* const MENU_SECTIONS[7] = {"GAME",  "VIEW", "ORDERS",
                                             "REPORTS", "TRADE", "CUP", "PEDIA"};

static std::vector<std::string> menu_rows(int mi) {
    std::vector<std::string> raw;
    if (mi < 0 || mi > 6 || !drydock_text_lines(MENU_SECTIONS[mi], raw) ||
        raw.size() < 2)
        return {};
    std::vector<std::string> rows;
    for (size_t i = 1; i < raw.size(); ++i) {          // row 0 = the ~TITLE
        std::string s;
        for (char c : raw[i]) if (c != '~' && c != '#') s += c;
        size_t b = s.find_first_not_of(' ');
        size_t e = s.find_last_not_of(' ');
        rows.push_back(b == std::string::npos ? std::string()
                                              : s.substr(b, e - b + 1));
    }
    return rows;
}

static bool row_is(const std::string& row, const char* what) {
    std::string lo;
    for (char c : row) lo += (char)std::tolower((unsigned char)c);
    return lo.find(what) != std::string::npos;
}

// The dropdown box (anchored at the label x, opens below the bar; sized by
// the row texts -- the shared dialog geometry engine, menus.md §6.3/§11).
static void menu_box(int mi, const std::vector<std::string>& rows,
                     int& bx, int& by, int& bw, int& bh) {
    static vc::Surface meas;                 // measurement-only scratch
    vc::NativeAssets& A = game_assets().nat;
    bw = 60;
    for (const std::string& r : rows) {
        int tw = meas.text_width(A.font, r) + 12;
        if (tw > bw) bw = tw;
    }
    bh = (int)rows.size() * 9 + 6;
    bx = vc::MAP_MENU_X[mi];
    by = 8;
    if (bx + bw > vc::Surface::W) bx = vc::Surface::W - bw;
}

// Which bar title owns x? Labels partition the strip at their x-origins
// (mechanism B, per-item x R -- menus.md §6.4).
static int menu_bar_hit(int x) {
    for (int i = 6; i >= 0; --i)
        if (x >= vc::MAP_MENU_X[i] - 2) return i;
    return 0;
}

void GameShell::compose_menu(vc::Surface& scr) {
    std::vector<std::string> rows = menu_rows(menu_open_);
    if (rows.empty()) return;
    vc::NativeAssets& A = game_assets().nat;
    uint8_t outline = vc::nearest_pal_index(A.pal, 20, 12, 6);
    uint8_t green   = vc::nearest_pal_index(A.pal, 82, 138, 49);
    uint8_t gold    = vc::nearest_pal_index(A.pal, 227, 170, 40);
    int bx, by, bw, bh;
    menu_box(menu_open_, rows, bx, by, bw, bh);
    if (A.woodtile.nframes > 0) {            // wood plaque fill (dialog chrome)
        const vc::Frame& f = A.woodtile.frames[0];
        for (int yy = 0; yy < bh; ++yy)
            for (int xx = 0; xx < bw; ++xx)
                scr.put(bx + xx, by + yy,
                        f.px[(size_t)(yy % f.h) * f.w + (xx % f.w)]);
    }
    scr.rect_outline(bx, by, bw, bh, outline);
    for (int i = 0; i < (int)rows.size(); ++i) {
        int ry = by + 3 + i * 9;
        scr.draw_text(A.font, bx + 6, ry + 1, rows[i],
                      i == menu_sel_ ? gold : green);
        if (i == menu_sel_)   // 1-px hollow row outline (menus.md §6.3 RULING)
            scr.rect_outline(bx + 2, ry, bw - 4, 9, gold);
    }
}

void GameShell::key_menu(int k) {
    std::vector<std::string> rows = menu_rows(menu_open_);
    int n = (int)rows.size();
    if (k == GK_ESC) { menu_open_ = -1; return; }
    if (k == GK_LEFT)  { menu_open_ = (menu_open_ + 6) % 7; menu_sel_ = 0; return; }
    if (k == GK_RIGHT) { menu_open_ = (menu_open_ + 1) % 7; menu_sel_ = 0; return; }
    if (k == GK_UP && menu_sel_ > 0) --menu_sel_;
    if (k == GK_DOWN && menu_sel_ + 1 < n) ++menu_sel_;
    if (k == GK_ENTER || k == ' ') {
        int mi = menu_open_, row = menu_sel_;
        menu_open_ = -1;
        menu_action(mi, row);
    }
}

void GameShell::click_menu(int mx, int my, int button) {
    (void)button;
    if (my < 8) {                            // the bar: switch / toggle menus
        int i = menu_bar_hit(mx);
        menu_sel_ = 0;
        menu_open_ = (menu_open_ == i) ? -1 : i;
        return;
    }
    std::vector<std::string> rows = menu_rows(menu_open_);
    int bx, by, bw, bh;
    menu_box(menu_open_, rows, bx, by, bw, bh);
    if (mx >= bx && mx < bx + bw && my >= by && my < by + bh) {
        int row = (my - by - 3) / 9;
        if (row >= 0 && row < (int)rows.size()) {
            int mi = menu_open_;
            menu_open_ = -1;
            menu_action(mi, row);
        }
        return;
    }
    menu_open_ = -1;                         // click-away closes
}

void GameShell::menu_action(int mi, int row) {
    std::vector<std::string> rows = menu_rows(mi);
    if (row < 0 || row >= (int)rows.size()) return;
    const std::string& r = rows[row];
    auto is = [&](const char* w) { return row_is(r, w); };
    switch (mi) {
        case 0:                                                  // @GAME
            if (is("save game")) { game_log(save("viceroy_save.json")); return; }
            if (is("load game")) { game_log(load("viceroy_save.json")); return; }
            if (is("declare independence")) {
                int promoted = 0;
                std::string why = declare_independence(&promoted);
                game_log(why.empty()
                             ? "INDEPENDENCE DECLARED -- " +
                                   std::to_string(promoted) + " continentals"
                             : why);
                return;
            }
            if (is("retire")) { open_report(10); return; }   // the score plate
            if (is("exit")) { quit_requested = true; return; }
            break;
        case 1:                                                  // @VIEW
            if (is("european status")) { open_europe(); return; }
            if (is("find colony")) {
                int n = (int)g_world.colonies.size();
                for (int step = 1; step <= n; ++step) {
                    int ci = (find_colony_ + step) % n;
                    const vc::sim::Colony& c = g_world.colonies[ci];
                    if (c.owner_power == 0 && c.x >= 0) {
                        find_colony_ = ci;
                        center_on(c.x, c.y);
                        game_log(colony_display_name(ci));
                        return;
                    }
                }
                game_log("no colonies yet");
                return;
            }
            if (is("center view")) {
                if (sel_ >= 0)
                    center_on(g_world.units[sel_].x, g_world.units[sel_].y);
                return;
            }
            if (is("zoom")) {
                game_log("zoom is fixed at 15 x 12 in this build");
                return;
            }
            break;
        case 2: {                            // @ORDERS -> the order key map
            // "unload" before "load": "unload cargo" contains "load cargo"
            static const struct { const char* what; char key; bool shift; }
                M[] = {{"activate", 'a', false},  {"wait", 'w', false},
                       {"fortify", 'f', false},   {"sentry", 's', false},
                       {"build colony", 'b', false}, {"join colony", 'b', false},
                       {"clear forest", 'p', false}, {"plow", 'p', false},
                       {"road", 'r', false},      {"unload cargo", 'u', false},
                       {"load cargo", 'l', false}, {"go to", 'g', false},
                       {"no orders", ' ', false}, {"overboard", 'o', false},
                       {"return to europe", 'e', false}, {"disband", 'd', true}};
            for (const auto& m : M)
                if (is(m.what)) { key_map(m.key, m.shift); return; }
            if (is("pillage")) return;   // vestigial: no handler in the EXE
                                         // (menus.md §6.5, B-negative)
            break;
        }
        case 3:                                                  // @REPORTS
            open_report(row + 1);
            return;
        case 5:                                                  // @CUP (CHEAT)
            if (is("reveal map")) {
                for (uint8_t& fb : g_world.fog) fb |= 0x10;  // player-0 seen bit
                game_log("cheat: the map is revealed");
                return;
            }
            if (is("kill indians")) {
                g_engine_extra.settlements.clear();
                g_engine_extra.braves.clear();
                game_log("cheat: the tribes are gone");
                return;
            }
            if (is("advance revolution")) {
                // per-invocation step is not spec'd: +10 national SoL clamped
                // to 100 (RECONSTRUCTED, same as /api/cheat/revolution)
                g_engine_extra.national_sol =
                    std::min(100, g_engine_extra.national_sol + 10);
                game_log("cheat: rebel sentiment now " +
                         std::to_string(g_engine_extra.national_sol) + "%");
                return;
            }
            break;
    }
    game_log(r + " -- not in this build");
}

// ----------------------------------------------------------------- map view
void GameShell::compose_map(vc::Surface& scr, bool flash) {
    vc::NativeAssets& A = game_assets().nat;
    vc::Map m = session_map();
    render_mapview(scr, m, A.terrain, A.phys, A.woodtile, A.font, g_game,
                   g_world, ox_, oy_);
    auto on_screen = [&](int x, int y, int& px, int& py) {
        int vx = x - ox_, vy = y - oy_;
        if (vx < 0 || vy < 0 || vx >= 15 || vy >= 12) return false;
        px = vx * 16; py = 8 + vy * 16;
        return true;
    };
    for (const vc::sim::Colony& c : g_world.colonies) {
        int px, py;
        if (c.x < 0 || !on_screen(c.x, c.y, px, py)) continue;
        scr.fill_rect(px + 2, py + 2, 12, 12, 6);
        scr.rect_outline(px + 2, py + 2, 12, 12, 15);
        scr.draw_text(A.font, px + 5, py + 5, std::to_string(c.population), 15);
    }
    for (int i = 0; i < (int)g_world.units.size(); ++i) {
        const vc::sim::Unit& u = g_world.units[i];
        int px, py;
        if (!u.alive || u.sail != 0 || u.in_europe) continue;   // off-map
        if (!on_screen(u.x, u.y, px, py)) continue;
        if (u.type >= 0 && u.type < A.units.nframes)
            scr.blit_frame(A.units.frames[u.type], px, py);
        if (i == sel_ && flash) scr.rect_outline(px, py, 16, 16, 15);
    }
    if (!status.empty())
        scr.draw_text(A.font, 2, 193, status.substr(0, 52), 15);
    if (menu_open_ >= 0) compose_menu(scr);
    if (confirm_open_) {
        vc::PopupSpec cs;
        cs.lines = confirm_lines_;
        cs.choices = confirm_choices_;
        cs.highlight = confirm_hover_;
        vc::PopupLayout L = vc::popup_layout(A.font, cs);
        static const vc::IndexedPng no_panl;
        const vc::IndexedPng* panl = atlas_file("pik/WOODPANL.png");
        vc::render_popup(scr, panl ? *panl : no_panl, A.font, cs, L);
    }
}

// ----------------------------------------------------- boot flow (menus.md)
// Title menu over OPENING.PIK -> difficulty picker (DIFFICUL.PIK, byte-cited
// 105c+23/96g+7 grid, cell 67x89) -> nation picker (NATIONS.PIK, 99c+112/
// 91r+13 grid, cell 87x81) -> the departure scene (LEVN0001..4 + @BUILD1).
// Item text is the verbatim GAME.TXT @BEGINMENU record; names come from
// NAMES @DIFFICULTY/@COUNTRY; prompts from LABELS @MISC. Plaque colors are
// the byte-cited design RGBs (menus.md §3).

static std::vector<std::string> beginmenu_lines() {
    std::string text = game_message_text("@BEGINMENU");
    std::vector<std::string> lines;
    std::string cur;
    for (char c : text) {
        if (c == '\r') continue;
        if (c == '\n') { lines.push_back(cur); cur.clear(); }
        else cur += c;
    }
    if (!cur.empty()) lines.push_back(cur);
    if (!lines.empty()) {          // title row: fill the %STRING version slots
        std::string& t = lines[0];
        auto sub = [&](const char* ph, const char* v) {
            size_t p = t.find(ph);
            if (p != std::string::npos) t.replace(p, strlen(ph), v);
        };
        sub("%STRING0", "Forge");
        sub("%STRING1", "export");
        // strip the {highlight} braces; the plaque draws the row as a bar
        std::string flat;
        for (char c : t) if (c != '{' && c != '}') flat += c;
        t = flat;
    }
    return lines;
}

static std::string first_field(const std::string& s) {   // "England,  12" -> England
    size_t comma = s.find(',');
    return comma == std::string::npos ? s : s.substr(0, comma);
}

static std::string misc_at(int i) {
    const std::vector<std::string>& m = labels_section("MISC");
    return i >= 0 && i < (int)m.size() ? m[i] : "";
}

// byte-cited picker grids (menus.md §7) --------------------------------------
static void diff_cell(int row, int& x, int& y) {          // 5 cells, (0,0) skipped
    int m = row + 1;
    x = (m % 3) * 105 + 23;
    y = (m / 3) * 96 + 7;
}
static void nation_cell(int row, int& x, int& y) {        // 2x2
    x = (row % 2) * 99 + 112;
    y = (row / 2) * 91 + 13;
}

void GameShell::boot_start_game() {
    // "Start a Game in NEW WORLD" = a generated map; AMERICA = the AMER2 map.
    game_new(pick_nation_, pick_diff_, /*random_map=*/!world_america_);
    vc::sim::refresh_moves(g_world, g_active_rules);
    g_game_active = true;
    sel_ = next_own_unit(-1);
    if (sel_ >= 0) center_on(g_world.units[sel_].x, g_world.units[sel_].y);
    game_log("A new world awaits.");
}

void GameShell::key_boot(int k) {
    switch (boot_) {
        case BOOT_MENU: {
            std::vector<std::string> lines = beginmenu_lines();
            int items = (int)lines.size() - 1;             // row 0 = title
            if (items < 1) { new_game(); return; }
            if (k == GK_UP && boot_sel_ > 0) --boot_sel_;
            if (k == GK_DOWN && boot_sel_ + 1 < items) ++boot_sel_;
            if (k >= '1' && k < '1' + items) boot_sel_ = k - '1';
            if (k == GK_ESC) quit_requested = true;
            if (k == GK_ENTER || k == ' ') {
                switch (boot_sel_) {
                    case 0: world_america_ = false; boot_ = BOOT_DIFF; break;
                    case 1: world_america_ = true;  boot_ = BOOT_DIFF; break;
                    case 3: status = load("viceroy_save.json"); break;
                    default: status = "not in this build"; break;
                }
            }
            break;
        }
        case BOOT_DIFF:
            if (k == GK_LEFT && pick_diff_ > 0) --pick_diff_;
            if (k == GK_RIGHT && pick_diff_ < 4) ++pick_diff_;
            if (k == GK_UP && pick_diff_ >= 2) pick_diff_ -= 2;   // grid feel:
            if (k == GK_DOWN && pick_diff_ <= 2) pick_diff_ += 2; // rough rows
            if (pick_diff_ < 0) pick_diff_ = 0;
            if (pick_diff_ > 4) pick_diff_ = 4;
            if (k == GK_ESC) boot_ = BOOT_MENU;
            if (k == GK_ENTER || k == ' ') boot_ = BOOT_NATION;
            break;
        case BOOT_NATION:
            if (k == GK_LEFT || k == GK_RIGHT) pick_nation_ ^= 1;
            if (k == GK_UP || k == GK_DOWN) pick_nation_ ^= 2;
            if (k == GK_ESC) boot_ = BOOT_DIFF;
            if (k == GK_ENTER || k == ' ') { boot_ = BOOT_SCENE; boot_sel_ = 0; }
            break;
        case BOOT_SCENE:
            if (k == GK_ESC) boot_ = BOOT_NATION;
            else if (k) boot_start_game();
            break;
    }
}

void GameShell::click_boot(int x, int y, int button) {
    (void)button;
    switch (boot_) {
        case BOOT_MENU: {
            // rows of the plaque (same layout math as compose_boot)
            std::vector<std::string> lines = beginmenu_lines();
            int items = (int)lines.size() - 1;
            int by = 91, row_h = 9;
            int row = (y - (by + row_h + 2)) / row_h;
            if (row >= 0 && row < items) {
                boot_sel_ = row;
                key_boot(GK_ENTER);
            }
            break;
        }
        case BOOT_DIFF: {
            for (int r = 0; r < 5; ++r) {
                int cx, cy;
                diff_cell(r, cx, cy);
                if (x >= cx && x < cx + 67 && y >= cy && y < cy + 89) {
                    pick_diff_ = r;
                    return;
                }
            }
            boot_ = BOOT_NATION;                 // "Click Here When Finished"
            break;
        }
        case BOOT_NATION: {
            for (int r = 0; r < 4; ++r) {
                int cx, cy;
                nation_cell(r, cx, cy);
                if (x >= cx && x < cx + 87 && y >= cy && y < cy + 81) {
                    pick_nation_ = r;
                    return;
                }
            }
            boot_ = BOOT_SCENE;
            boot_sel_ = 0;
            break;
        }
        case BOOT_SCENE:
            boot_start_game();
            break;
    }
}

void GameShell::compose_boot(vc::Surface& scr) {
    vc::NativeAssets& A = game_assets().nat;
    scr.clear(0);
    // the byte-cited plaque design RGBs (menus.md §3)
    uint8_t outline = vc::nearest_pal_index(A.pal, 20, 12, 6);
    uint8_t selbar  = vc::nearest_pal_index(A.pal, 56, 32, 16);
    uint8_t green   = vc::nearest_pal_index(A.pal, 82, 138, 49);
    uint8_t gold    = vc::nearest_pal_index(A.pal, 227, 170, 40);

    if (boot_ == BOOT_MENU) {
        // OPENMENU.PIK is the full-screen menu backdrop (menus.md §2/§4;
        // OPENING.PIK is the 960-wide scrolling title panorama behind it).
        if (const vc::IndexedPng* bg = atlas_file("pik/OPENMENU.png"))
            scr.blit_region(*bg, 0, 0, bg->w, bg->h, 0, 0);
        else if (const vc::IndexedPng* op = atlas_file("pik/OPENING.png"))
            scr.blit_region(*op, 0, 0, 320, op->h, 0, 0);
        // @BEGINMENU plaque: centered x, y=91, width >= 160 (menus.md §2/§4)
        std::vector<std::string> lines = beginmenu_lines();
        int items = (int)lines.size() - 1;
        int row_h = 9, pad = 4;
        int w = 160;
        for (const std::string& l : lines) {
            int tw = scr.text_width(A.font, l) + 10;
            if (tw > w) w = tw;
        }
        int h = row_h * (items + 1) + pad * 2;
        int bx = (vc::Surface::W - w) / 2, by = 91;
        // wood fill from the WOODPANL grain + the outline color
        if (A.woodtile.nframes > 0) {
            const vc::Frame& f = A.woodtile.frames[0];
            for (int yy = 0; yy < h; ++yy)
                for (int xx = 0; xx < w; ++xx)
                    scr.put(bx + xx, by + yy,
                            f.px[(size_t)(yy % f.h) * f.w + (xx % f.w)]);
        }
        scr.rect_outline(bx, by, w, h, outline);
        // title row: a darker bar, green text
        scr.fill_rect(bx + 1, by + 1, w - 2, row_h, selbar);
        scr.draw_text(A.font, bx + 4, by + 2, lines.empty() ? "" : lines[0], green);
        for (int i = 0; i < items; ++i) {
            int ry = by + row_h * (i + 1) + 2;
            if (i == boot_sel_) {
                scr.fill_rect(bx + 1, ry - 1, w - 2, row_h, selbar);
                scr.draw_text(A.font, bx + 4, ry, lines[i + 1], gold);
            } else {
                scr.draw_text(A.font, bx + 4, ry, lines[i + 1], green);
            }
        }
        return;
    }
    if (boot_ == BOOT_DIFF) {
        if (const vc::IndexedPng* bg = atlas_file("pik/DIFFICUL.png"))
            scr.blit_region(*bg, 0, 0, bg->w, bg->h, 0, 0);
        // prompt (frame-measured position; strings = LABELS @MISC 162/163/161)
        scr.draw_text(A.font, 24, 10, misc_at(162), green);
        scr.draw_text(A.font, 16, 19, misc_at(163), green);
        // the finish caption fits the left margin column in FONTTINY; our
        // wider stand-in font wraps it to two lines there
        scr.draw_text(A.font, 4, 56, "(Click Here", green);
        scr.draw_text(A.font, 4, 65, "When Finished)", green);
        // selection outline (67x89, per-row color bytes {0xA,9,0xE,0xD,0xC})
        static const uint8_t SEL[5] = {0x0A, 0x09, 0x0E, 0x0D, 0x0C};
        const std::vector<std::string>& names = labels_section("DIFFICULTY");
        int cx, cy;
        diff_cell(pick_diff_, cx, cy);
        scr.rect_outline(cx, cy, 67, 89, SEL[pick_diff_]);
        std::string nm = pick_diff_ < (int)names.size() ? names[pick_diff_] : "";
        std::string rank = misc_at(165 + pick_diff_);     // Easiest..Toughest
        int tw = scr.text_width(A.font, nm);
        scr.draw_text(A.font, cx + (67 - tw) / 2, cy + 2, nm, gold);
        tw = scr.text_width(A.font, rank);
        scr.draw_text(A.font, cx + (67 - tw) / 2, cy + 80, rank, gold);
        return;
    }
    if (boot_ == BOOT_NATION) {
        if (const vc::IndexedPng* bg = atlas_file("pik/NATIONS.png"))
            scr.blit_region(*bg, 0, 0, bg->w, bg->h, 0, 0);
        scr.draw_text(A.font, 20, 24, misc_at(170), green);      // Select
        scr.draw_text(A.font, 8, 33, misc_at(171), green);       // European Power
        scr.draw_text(A.font, 4, 186, "(" + misc_at(161) + ")", green);
        // selection outline 87x81; the flag byte color is per-nation
        // ([bx+0x848], value not literalized) -- approximated from each flag's
        // dominant color, R-tier.
        const uint8_t SEL[4] = {vc::nearest_pal_index(A.pal, 200, 40, 40),
                                vc::nearest_pal_index(A.pal, 70, 70, 200),
                                vc::nearest_pal_index(A.pal, 220, 180, 40),
                                vc::nearest_pal_index(A.pal, 230, 120, 40)};
        const std::vector<std::string>& country = labels_section("COUNTRY");
        int cx, cy;
        nation_cell(pick_nation_, cx, cy);
        scr.rect_outline(cx, cy, 87, 81, SEL[pick_nation_ & 3]);
        std::string nm = pick_nation_ < (int)country.size()
                             ? first_field(country[pick_nation_]) : "";
        std::string style = misc_at(173 + pick_nation_);   // Immigration..Trade
        int tw = scr.text_width(A.font, nm);
        scr.draw_text(A.font, cx + (87 - tw) / 2, cy - 8, nm, gold);
        tw = scr.text_width(A.font, style);
        scr.draw_text(A.font, cx + (87 - tw) / 2, cy + 82, style, gold);
        return;
    }
    // BOOT_SCENE: the departure harbor (LEVN0001..4 slideshow) + @BUILD1 in a
    // parchment band, exactly the capture's composition.
    static const char* LEVN[4] = {"LEVN0001", "LEVN0002", "LEVN0003", "LEVN0004"};
    int frame = (boot_sel_ / 24) % 4;          // boot_sel_ reused as a tick
    ++boot_sel_;
    if (const vc::IndexedPng* bg =
            atlas_file(std::string("pik/") + LEVN[frame] + ".png"))
        scr.blit_region(*bg, 0, 0, bg->w, bg->h, 0, 0);
    std::string line = game_message_text("@BUILD1");
    std::string flat;
    for (char c : line) if (c != '^' && c != '\n') flat += c;
    uint8_t parch = vc::nearest_pal_index(A.pal, 235, 219, 162);
    uint8_t ink = vc::nearest_pal_index(A.pal, 40, 24, 8);
    // wrap to the band (the stand-in font is wider than FONTTINY)
    std::vector<std::string> rows;
    std::string cur;
    for (size_t i = 0; i < flat.size(); ++i) {
        cur += flat[i];
        if (scr.text_width(A.font, cur) > 300) {
            size_t sp = cur.rfind(' ');
            if (sp != std::string::npos) {
                rows.push_back(cur.substr(0, sp));
                cur = cur.substr(sp + 1);
            }
        }
    }
    if (!cur.empty()) rows.push_back(cur);
    int band_h = 6 + (int)rows.size() * 9;
    scr.fill_rect(0, 0, vc::Surface::W, band_h, parch);
    for (int x = 0; x < vc::Surface::W; ++x) scr.put(x, band_h, ink);
    for (size_t i = 0; i < rows.size(); ++i) {
        int tw = scr.text_width(A.font, rows[i]);
        scr.draw_text(A.font, (vc::Surface::W - tw) / 2, 3 + (int)i * 9,
                      rows[i], ink);
    }
}

// -------------------------------------------------------------------- input
void GameShell::key(int k, bool shift) {
    if (!g_game_active) {
        key_boot(k);
        return;
    }
    // popup flows take the keyboard first
    if (confirm_open_) {
        if (k == GK_ESC) { confirm_open_ = false; found_acks_.clear(); }
        if (k >= '1' && k < '1' + (int)confirm_choices_.size())
            found_choice(confirm_choices_[k - '1']);
        if (k == GK_UP && confirm_hover_ > 0) --confirm_hover_;
        if (k == GK_DOWN && confirm_hover_ + 1 < (int)confirm_choices_.size())
            ++confirm_hover_;
        if (k == GK_ENTER && confirm_hover_ >= 0 &&
            confirm_hover_ < (int)confirm_choices_.size())
            found_choice(confirm_choices_[confirm_hover_]);
        return;
    }
    if (picker_open_) {
        std::vector<ProfRow> rows = prof_rows();
        int n = (int)rows.size(), half = (n + 1) / 2;
        if (k == GK_ESC) picker_open_ = false;
        if (k == GK_UP && picker_cursor_ > 0) --picker_cursor_;
        if (k == GK_DOWN && picker_cursor_ + 1 < n) ++picker_cursor_;
        if (k == GK_LEFT && picker_cursor_ - half >= 0) picker_cursor_ -= half;
        if (k == GK_RIGHT && picker_cursor_ + half < n) picker_cursor_ += half;
        if (k == GK_ENTER && picker_cursor_ < n) {
            assign_worker(colony_view_, picker_tile_, rows[picker_cursor_].index,
                          rows[picker_cursor_].good);
            game_log(rows[picker_cursor_].name + " assigned");
            picker_open_ = false;
        }
        return;
    }
    // an open pulldown menu takes the keyboard (map view only)
    if (menu_open_ >= 0 && colony_view_ < 0 && !europe_view_ &&
        report_view_ == 0) {
        key_menu(k);
        return;
    }
    // F1..F10 advisor reports from anywhere
    if (k >= GK_F1 && k <= GK_F1 + 9) {
        report_view_ = k - GK_F1 + 1;
        colony_view_ = -1;
        europe_view_ = false;
        return;
    }
    if (colony_view_ >= 0 || europe_view_ || report_view_ > 0) {
        if (build_open_ && colony_view_ >= 0) { key_build(k); return; }
        if (colony_view_ >= 0 && k == 'b') {   // open the construction menu
            build_open_ = true;
            build_sel_ = 0;
            build_page_ = 0;
            return;
        }
        if (k == GK_ESC) {
            colony_view_ = -1;
            europe_view_ = false;
            report_view_ = 0;
        }
        if (report_view_ > 0 && k == GK_ENTER) report_view_ = 0;
        return;
    }
    key_map(k, shift);
}

void GameShell::key_map(int k, bool shift) {
    int dx = 0, dy = 0;
    if (k == GK_UP) dy = -1;
    if (k == GK_DOWN) dy = 1;
    if (k == GK_LEFT) dx = -1;
    if (k == GK_RIGHT) dx = 1;
    if ((dx || dy) && sel_ >= 0) {
        try_step(sel_, dx, dy);
        const vc::sim::Unit& u = g_world.units[sel_];
        if (u.x < ox_ + 1 || u.x > ox_ + 13 || u.y < oy_ + 1 || u.y > oy_ + 10)
            center_on(u.x, u.y);
        return;
    }
    auto next_unit = [&] {
        sel_ = next_own_unit(sel_);
        if (sel_ >= 0) center_on(g_world.units[sel_].x, g_world.units[sel_].y);
    };
    switch (k) {
        case GK_TAB: case 'w': case ' ': next_unit(); return;
        case GK_ENTER: end_turn(); return;
        case GK_ESC: quit_requested = true; return;
        case 'e':
            // the E accelerator (@ORDERS "Return to Europe"): a selected ship
            // at sea sails home; otherwise open the Europe screen
            if (sel_ >= 0) {
                std::string why = sail_to_europe(sel_);
                if (why.empty()) {
                    game_log("sailing for Europe");
                    sel_ = next_own_unit(sel_);
                    return;
                }
            }
            europe_view_ = true;
            return;
    }
    if (sel_ < 0) return;
    auto named = [&](const char* o, const char* what) {
        OrderResult r = unit_order(sel_, o);
        game_log(r.ok ? what : r.err);
    };
    switch (k) {
        case 'f': named("F", "fortifying"); break;
        case 's': named("S", "sentry"); break;
        case 'p': named("P", "clearing / plowing"); break;
        case 'r': named("R", "building a road"); break;
        case '-': named("-", "orders cleared"); break;
        case 'l': named("L", "loaded the most valuable good"); break;
        case 'u': named("U", "unloaded the most valuable hold"); break;
        case 'o': named("O", "cargo dumped overboard"); break;
        case 'a': named("-", "unit activated (orders cleared)"); break;
        case 'd':
            if (shift) {
                named("D", "unit disbanded");
                sel_ = next_own_unit(-1);
            }
            break;
        case 'b':
            found_acks_.clear();
            found_attempt("");
            break;
        case 'g':
            goto_mode_ = true;
            game_log("go-to: click the target tile");
            break;
        case 'c':
            center_on(g_world.units[sel_].x, g_world.units[sel_].y);
            break;
    }
}

void GameShell::click(int mx, int my, int button) {
    if (!g_game_active) {
        click_boot(mx, my, button);
        return;
    }
    if (picker_open_) return;                       // keyboard-driven
    if (colony_view_ >= 0) { click_colony(mx, my, button); return; }
    if (europe_view_) { click_europe(mx, my, button); return; }
    if (report_view_ > 0) { report_view_ = 0; return; }
    // map view
    if (confirm_open_) {
        vc::NativeAssets& A = game_assets().nat;
        vc::PopupSpec cs;
        cs.lines = confirm_lines_;
        cs.choices = confirm_choices_;
        vc::PopupLayout L = vc::popup_layout(A.font, cs);
        for (int i = 0; i < (int)cs.choices.size(); ++i) {
            int cx, cy, cw, ch;
            vc::popup_choice_rect(L, i, cx, cy, cw, ch);
            if (mx >= cx && mx < cx + cw && my >= cy && my < cy + ch) {
                found_choice(cs.choices[i]);
                return;
            }
        }
        return;
    }
    if (menu_open_ >= 0) { click_menu(mx, my, button); return; }
    if (my < 8) {                            // the pulldown bar (menus.md §6)
        menu_open_ = menu_bar_hit(mx);
        menu_sel_ = 0;
        return;
    }
    if (button == 0 && mx < 240 && my >= 8) {
        int tx = ox_ + mx / 16, ty = oy_ + (my - 8) / 16;
        if (goto_mode_ && sel_ >= 0) {
            goto_mode_ = false;
            OrderResult r = unit_order(sel_, "", tx, ty);
            game_log(r.ok ? "going to (" + std::to_string(tx) + "," +
                                std::to_string(ty) + ") -- moves on End Turn"
                          : r.err);
        } else {
            for (int ci = 0; ci < (int)g_world.colonies.size(); ++ci) {
                const vc::sim::Colony& c = g_world.colonies[ci];
                if (c.x == tx && c.y == ty && c.owner_power == 0) {
                    colony_view_ = ci;
                    return;
                }
            }
            int ui = vc::sim::unit_at(g_world, tx, ty);
            if (ui >= 0 && g_world.units[ui].owner == 0) sel_ = ui;
        }
    }
}

// ------------------------------------------------------------------ compose
void GameShell::compose(vc::Surface& scr, bool flash) {
    vc::NativeAssets& A = game_assets().nat;
    scr.set_palette(A.pal);
    if (!g_game_active) {                     // the boot flow (menus.md)
        compose_boot(scr);
        return;
    }
    if (report_view_ > 0) {
        if (!compose_report(scr, report_view_)) scr.clear(0);
        return;
    }
    if (colony_view_ >= 0 && colony_view_ < (int)g_world.colonies.size()) {
        compose_colony(scr);
        return;
    }
    if (europe_view_) {
        compose_europe(scr);
        return;
    }
    compose_map(scr, flash);
}

} // namespace forge
