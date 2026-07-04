// game_shell.cpp -- the platform-free playable game (see game_shell.hpp).
// The logic is a faithful port of the editor's Game view (studio_main.cpp):
// same session commands, same composers, same key map -- minus ImGui.
#include "game_shell.hpp"
#include "game_assets.hpp"
#include "session.hpp"
#include "engine.hpp"          // EngineCtx, resolve_binding, job_name,
                               // colony_compute_production
#include "drydock_api.hpp"     // drydock_store
#include "../drydock/core/store.hpp"
#include "colony_screen.hpp"
#include "mapview.hpp"
#include "popup_render.hpp"
#include "sim/unit.hpp"
#include "sim/unit_turn.hpp"
#include "sim/market.hpp"
#include <algorithm>
#include <cstdio>

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

void GameShell::game_log(const std::string& s) {
    log_.push_back(s);
    if (log_.size() > 8) log_.erase(log_.begin());
    status = s;
}

int GameShell::next_own_unit(int from) const {
    int n = (int)g_world.units.size();
    if (n == 0) return -1;
    for (int k = 1; k <= n; ++k) {
        int i = (from + k) % n;
        if (g_world.units[i].alive && g_world.units[i].owner == 0) return i;
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
}

void GameShell::click_europe(int mx, int my, int button) {
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
        if (!u.alive || !on_screen(u.x, u.y, px, py)) continue;
        if (u.type >= 0 && u.type < A.units.nframes)
            scr.blit_frame(A.units.frames[u.type], px, py);
        if (i == sel_ && flash) scr.rect_outline(px, py, 16, 16, 15);
    }
    if (!status.empty())
        scr.draw_text(A.font, 2, 193, status.substr(0, 52), 15);
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

// -------------------------------------------------------------------- input
void GameShell::key(int k, bool shift) {
    if (!g_game_active) {
        if (k == GK_ENTER || k == ' ') new_game();
        else if (k == GK_ESC) quit_requested = true;
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
    // F1..F10 advisor reports from anywhere
    if (k >= GK_F1 && k <= GK_F1 + 9) {
        report_view_ = k - GK_F1 + 1;
        colony_view_ = -1;
        europe_view_ = false;
        return;
    }
    if (colony_view_ >= 0 || europe_view_ || report_view_ > 0) {
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
        case 'e': europe_view_ = true; return;
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
    if (!g_game_active) return;
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
    if (!g_game_active) {                     // minimal title: OPENING art
        scr.clear(0);
        if (const vc::IndexedPng* bg = atlas_file("pik/OPENING.png"))
            scr.blit_region(*bg, 0, 0, bg->w, bg->h, 0, 0);
        uint8_t c = vc::nearest_pal_index(A.pal, 255, 243, 93);
        const char* line = "VICEROY  --  press Enter to found the New World";
        int tw = scr.text_width(A.font, line);
        scr.draw_text(A.font, (320 - tw) / 2, 184, line, c);
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
