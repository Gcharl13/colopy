// desktop.hpp -- Forge as a desktop application.
//
// Forge is the ENGINE: a desktop executable that opens a PROJECT (a folder of
// game data -- rules, tables, maps, assets, graphs, screens, scenarios; the
// Colonization content is the first such project) and presents the full
// editor in its own window. The engine runs in-process; the window is a
// chromeless app-mode browser window over the loopback port (v1 -- a proper
// embedded WebView2 is a drop-in upgrade later; both render with the same
// system engine).
#pragma once
#include "httpd.hpp"

namespace forge {

// Run the desktop shell: resolve the project folder (explicit arg, else the
// current/exe directory if it IS a project, else a native folder picker on
// Windows), chdir into it, start the engine server on an ephemeral loopback
// port, open the editor window, and block until that window closes.
// A "project" is any folder containing data_extracted/engine (the game data
// the engine boots from). Returns a process exit code.
int desktop_main(const char* project_dir, const HttpHandler& handler);

} // namespace forge
