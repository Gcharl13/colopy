// game_shell.hpp -- the platform-free playable game. One implementation of
// the whole play surface (map + orders, colony screen, Europe, advisor
// reports, popup flows), composed into the native 320x200 vc::Surface and
// driven by abstract key/click events. Frontends are thin: the SDL2 player
// (viceroy_app.cpp), the Win32/GDI player (viceroy_win.cpp) and the Teensy
// 4.1 port each just pump events in and blit the surface out.
//
// Mechanics stay in the shared session (forge/session.hpp) -- the shell only
// routes input to session commands and composes the screens, exactly like the
// editor's Game view (which remains its own host of the same session).
#pragma once
#include "surface.hpp"
#include <string>
#include <vector>

namespace forge {

// Abstract key codes for non-character keys; printable keys arrive as their
// ASCII char (lowercase letters, '-', ' ').
enum : int {
    GK_UP = 1000, GK_DOWN, GK_LEFT, GK_RIGHT,
    GK_ENTER, GK_ESC, GK_TAB,
    GK_F1 = 1100,   // .. GK_F1+9 = F10
};

class GameShell {
public:
    // Load the record store + assets from the project rooted at the CURRENT
    // working directory. False + err when the data folder is missing.
    bool boot(std::string& err);
    void new_game(int nation = 0, int difficulty = 1);
    bool active() const;

    // Input (native 320x200 coordinates for clicks; button 0=left 1=right).
    void key(int k, bool shift);
    void click(int x, int y, int button);

    // Compose the current screen. `flash` toggles the selected-unit blink.
    void compose(vc::Surface& scr, bool flash);

    // Save / load the running game (the frontends bind these to keys).
    std::string save(const std::string& path);
    std::string load(const std::string& path);

    // Host hooks (the editor's Game view + the headless harness): open a
    // subview directly, inspect state, drop a notice, absorb the map-Esc.
    void open_colony(int ci);
    void open_europe();
    void open_report(int f);
    int  selected_unit() const { return sel_; }
    const std::vector<std::string>& log() const { return log_; }
    void note(const std::string& s) { game_log(s); }
    void clear_quit() { quit_requested = false; }
    void resync();                   // after an external game load

    bool quit_requested = false;     // Esc on the map asks the frontend to exit
    std::string status;              // one-line notice for window titles/logs

private:
    // ---- boot flow (spec/ui/menus.md: title menu -> pickers -> scene) ----
    enum BootStage { BOOT_MENU, BOOT_DIFF, BOOT_NATION, BOOT_SCENE };
    BootStage boot_ = BOOT_MENU;
    int boot_sel_ = 0;               // menu row / picker cell cursor
    int pick_diff_ = 2;              // Conquistador default
    int pick_nation_ = 0;            // England default
    bool world_america_ = false;     // menu item 2: play the AMER2 map
    void key_boot(int k);
    void click_boot(int x, int y, int button);
    void compose_boot(vc::Surface& scr);
    void boot_start_game();

    // ---- view state (mirrors the editor's Game view) ----
    int ox_ = 0, oy_ = 0, sel_ = -1;
    int colony_view_ = -1;           // >=0: colony screen open
    bool europe_view_ = false;
    int report_view_ = 0;            // 1..10
    bool goto_mode_ = false;
    // pulldown menu bar (spec/ui/menus.md §6): open menu index + row cursor
    int menu_open_ = -1;
    int menu_sel_ = 0;
    int find_colony_ = -1;           // @VIEW Find Colony cycle cursor
    std::vector<std::string> log_;
    // found-colony confirm popup (@TUTNO*/@INDIANLAND flow)
    bool confirm_open_ = false;
    std::string confirm_key_;
    std::vector<std::string> confirm_lines_, confirm_choices_;
    std::vector<std::string> found_acks_;
    int confirm_hover_ = -1;
    // colony profession picker (right-click on a ring tile)
    bool picker_open_ = false;
    int picker_tile_ = -1, picker_cursor_ = 0;

    void game_log(const std::string& s);
    int  next_own_unit(int from) const;
    void clamp_view();
    void center_on(int x, int y);
    bool try_step(int ui, int dx, int dy);
    void end_turn();
    void found_attempt(const std::string& land_choice);
    void found_choice(const std::string& c);
    void assign_worker(int colony, int tile, int profession, int good);
    void key_map(int k, bool shift);
    void click_map(int x, int y, int button);
    void key_menu(int k);
    void click_menu(int x, int y, int button);
    void menu_action(int mi, int row);
    void compose_menu(vc::Surface& scr);
    void click_colony(int x, int y, int button);
    void click_europe(int x, int y, int button);
    void compose_map(vc::Surface& scr, bool flash);
    void compose_colony(vc::Surface& scr);
    void compose_europe(vc::Surface& scr);
    void compose_picker(vc::Surface& scr);
};

} // namespace forge
