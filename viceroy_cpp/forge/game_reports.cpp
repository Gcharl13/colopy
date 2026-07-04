// game_reports.cpp -- the F1..F10 advisor reports, composed natively from the
// session's report_state_json() (the same assembled rows the web reports
// consumed). Backgrounds + titles are the byte-cited pairs (advisor_reports.md
// + USER RULING #2: F6 Colony -> REPORT6, F7 Naval -> REPORT7); the row grid
// is a faithful-tier text table (per-column x positions RECONSTRUCTED -- the
// data, titles, art and colors are the cited ones).
#include "game_assets.hpp"
#include "popup_render.hpp"    // nearest_pal_index
#include "session.hpp"         // report_state_json / labels_section
#include "json.hpp"
#include <cstdio>

namespace forge {
namespace {

using forge::JsonValue;

struct Col {
    const char* key;
    const char* label;
    int x;
};

std::string jstr_of(const JsonValue& v) {
    switch (v.type) {
        case JsonValue::Number: {
            double n = v.num;
            if (n == (long long)n) return std::to_string((long long)n);
            char b[32];
            std::snprintf(b, sizeof b, "%g", n);
            return b;
        }
        case JsonValue::String: return v.str;
        case JsonValue::Bool:   return v.b ? "yes" : "";
        case JsonValue::Array:  return std::to_string(v.arr.size());
        default: return "";
    }
}

struct Chrome {
    uint8_t title, label, value, rule;
};
Chrome chrome(const uint8_t pal[768]) {
    // the advisor palette anchors (report_framework 0x90/0x92/0x61/0x77)
    return {vc::nearest_pal_index(pal, 255, 255, 190),
            vc::nearest_pal_index(pal, 255, 243, 93),
            vc::nearest_pal_index(pal, 247, 243, 199),
            vc::nearest_pal_index(pal, 134, 0, 0)};
}

void title_bar(vc::Surface& scr, const vc::Sheet& font, const Chrome& C,
               const std::string& text) {
    scr.fill_rect(0, 0, 320, 7, 0);
    int tw = scr.text_width(font, text);
    scr.draw_text(font, (320 - tw) / 2, 0, text, C.title);
}

// one array-of-objects table: header row + data rows, 8px pitch
void table(vc::Surface& scr, const vc::Sheet& font, const Chrome& C,
           const JsonValue* rows, const std::vector<Col>& cols, int y0,
           int max_rows) {
    for (const Col& c : cols)
        scr.draw_text(font, c.x, y0, c.label, C.label);
    scr.hline(4, y0 + 8, 312, C.rule);
    if (!rows || rows->type != JsonValue::Array) return;
    int y = y0 + 11;
    int shown = 0;
    for (const JsonValue& r : rows->arr) {
        if (shown++ >= max_rows) break;
        for (const Col& c : cols) {
            const JsonValue* v = r.find(c.key);
            if (v) scr.draw_text(font, c.x, y, jstr_of(*v).substr(0, 24), C.value);
        }
        y += 8;
    }
}

void kv(vc::Surface& scr, const vc::Sheet& font, const Chrome& C, int x, int& y,
        const std::string& label, const std::string& value) {
    scr.draw_text(font, x, y, label, C.label);
    scr.draw_text(font, x + 170, y, value, C.value);
    y += 9;
}

std::string misc(int i) {
    const std::vector<std::string>& m = labels_section("MISC");
    return i >= 0 && i < (int)m.size() ? m[i] : "REPORT";
}

}  // namespace

bool compose_report(vc::Surface& scr, int f) {
    if (!game_assets_ensure()) return false;
    const vc::Sheet& font = game_assets().nat.font;
    const Chrome C = chrome(game_assets().nat.pal);
    // background + @MISC title per F-key (advisor_reports.md; RULING #2)
    static const char* PIK[10] = {"REPORT1", "REPORT2", "REPORT3", "REPORT4",
                                  "REPORT5", "REPORT6", "REPORT7", "REPORT8",
                                  "REPORT9", "WOODPAN2"};
    static const int TITLE[10] = {79, 30, 37, 49, 50, 51, 52, 93, 29, 114};
    if (f < 1 || f > 10) return false;
    scr.clear(0);
    if (const vc::IndexedPng* bg = atlas_file(std::string("pik/") + PIK[f - 1] + ".png"))
        scr.blit_region(*bg, 0, 0, bg->w, bg->h, 0, 0);
    title_bar(scr, font, C, misc(TITLE[f - 1]));

    forge::JsonValue st = report_state_json();
    switch (f) {
        case 1:   // Terrain: base grounds + your unit/colony counts per ground
            table(scr, font, C, st.find("terrain"),
                  {{"name", "Terrain", 8},
                   {"move", "Move", 110},
                   {"defense", "Def%", 145},
                   {"food", "Food", 180},
                   {"value", "Value", 215},
                   {"units", "Units", 250},
                   {"colonies", "Cols", 285}},
                  14, 20);
            break;
        case 2: { // Religious: the crosses gauge + per-colony output
            const JsonValue* rel = st.find("religious");
            int y = 14;
            if (rel) {
                std::string acc = rel->find("accum") ? jstr_of(*rel->find("accum")) : "0";
                std::string th = rel->find("threshold") ? jstr_of(*rel->find("threshold")) : "?";
                kv(scr, font, C, 8, y, "Crosses toward next immigrant",
                   acc + " of " + th);
                if (const JsonValue* dock = rel->find("dock")) {
                    std::string s;
                    for (const JsonValue& d : dock->arr)
                        s += (s.empty() ? "" : ", ") + jstr_of(d);
                    kv(scr, font, C, 8, y, "Waiting on the dock", s);
                }
                table(scr, font, C, rel->find("colonies"),
                      {{"name", "Colony", 8}, {"crosses", "Crosses/turn", 160}},
                      y + 4, 16);
            }
            break;
        }
        case 3: { // Congress: bells, next father, REF
            const JsonValue* cg = st.find("congress");
            int y = 14;
            if (cg) {
                kv(scr, font, C, 8, y, "Liberty bells (pool)",
                   cg->find("bells_pool") ? jstr_of(*cg->find("bells_pool")) : "0");
                kv(scr, font, C, 8, y, "Bells per turn",
                   cg->find("bells_per_turn") ? jstr_of(*cg->find("bells_per_turn")) : "0");
                kv(scr, font, C, 8, y, "Next father at",
                   cg->find("threshold") ? jstr_of(*cg->find("threshold")) : "?");
                kv(scr, font, C, 8, y, "Fathers in Congress",
                   cg->find("ff_count") ? jstr_of(*cg->find("ff_count")) : "0");
                if (const JsonValue* off = cg->find("offered"))
                    if (off->type == JsonValue::String && !off->str.empty())
                        kv(scr, font, C, 8, y, "Now offering", off->str);
                kv(scr, font, C, 8, y, "Sons of Liberty (national)",
                   (cg->find("national_sol") ? jstr_of(*cg->find("national_sol")) : "0") + "%");
                if (const JsonValue* ref = cg->find("ref")) {
                    auto rg = [&](const char* k) {
                        const JsonValue* v = ref->find(k);
                        return v ? jstr_of(*v) : std::string("?");
                    };
                    kv(scr, font, C, 8, y, "Royal Expeditionary Force",
                       rg("regulars") + " reg  " + rg("cavalry") + " cav");
                    kv(scr, font, C, 8, y, "",
                       rg("artillery") + " art  " + rg("manowar") + " men-o-war");
                }
                if (const JsonValue* fa = cg->find("fathers")) {
                    scr.draw_text(font, 8, y + 2, "In Congress:", C.label);
                    int fy = y + 11, fx = 8, n = 0;
                    for (const JsonValue& fv : fa->arr) {
                        scr.draw_text(font, fx, fy, jstr_of(fv).substr(0, 24), C.value);
                        fx += 104;
                        if (++n % 3 == 0) { fx = 8; fy += 8; }
                    }
                }
            }
            break;
        }
        case 4:   // Labor: the occupation matrix
            table(scr, font, C, st.find("labor"),
                  {{"job", "Occupation", 8}, {"count", "Colonists", 190}},
                  14, 20);
            break;
        case 5:   // Economic: the commodity rows off the published model
            table(scr, font, C, st.find("economic"),
                  {{"good", "Commodity", 8},
                   {"stock", "Stock", 130},
                   {"bid", "Bid", 180},
                   {"ask", "Ask", 215},
                   {"boycott", "Boycott", 255}},
                  14, 18);
            break;
        case 6:   // Colony report (RULING #2: fort art)
            table(scr, font, C, st.find("colonies"),
                  {{"name", "Colony", 8},
                   {"population", "Pop", 120},
                   {"sol", "SoL%", 155},
                   {"food", "Food", 195},
                   {"buildings", "Bldgs", 235},
                   {"x", "X", 280},
                   {"y", "Y", 300}},
                  14, 18);
            break;
        case 7:   // Naval report (RULING #2: ship art)
            table(scr, font, C, st.find("naval"),
                  {{"name", "Ship", 8},
                   {"cargo", "Cargo", 150},
                   {"x", "X", 220},
                   {"y", "Y", 245},
                   {"order", "Orders", 270}},
                  14, 18);
            break;
        case 8:   // Foreign affairs: power strengths
            table(scr, font, C, st.find("foreign"),
                  {{"name", "Power", 8},
                   {"colonies", "Cols", 100},
                   {"military", "Mil", 140},
                   {"naval", "Naval", 175},
                   {"merchant", "Mrch", 215},
                   {"gold", "Gold", 250},
                   {"at_war", "War", 292}},
                  14, 8);
            break;
        case 9:   // Indian advisor: the settlements
            table(scr, font, C, st.find("indian"),
                  {{"tribe", "Tribe", 8},
                   {"count", "Villages", 100},
                   {"alarm", "Alarm", 160},
                   {"mission", "Missions", 210},
                   {"capital", "Capital", 270}},
                  14, 12);
            break;
        case 10: { // Score
            const JsonValue* sc = st.find("score");
            int y = 20;
            if (sc) {
                auto g = [&](const char* k) {
                    const JsonValue* v = sc->find(k);
                    return v ? jstr_of(*v) : std::string("0");
                };
                kv(scr, font, C, 40, y, "Citizens", g("population"));
                kv(scr, font, C, 40, y, "Founding fathers", g("fathers"));
                kv(scr, font, C, 40, y, "Gold", g("gold"));
                kv(scr, font, C, 40, y, "Rebel sentiment", g("sentiment"));
                kv(scr, font, C, 40, y, "Colonies razed", g("razed"));
                kv(scr, font, C, 40, y, "War bells", g("war_bells"));
                kv(scr, font, C, 40, y, "Revolution bonus", g("revolution"));
                kv(scr, font, C, 40, y, "Difficulty multiplier", g("mult"));
                scr.hline(40, y + 1, 240, C.rule);
                y += 5;
                kv(scr, font, C, 40, y, "TOTAL", g("total"));
                if (sc->find("rank")) kv(scr, font, C, 40, y, "Rank", g("rank"));
            }
            break;
        }
    }
    return true;
}

} // namespace forge
