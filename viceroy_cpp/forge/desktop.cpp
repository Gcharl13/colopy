// desktop.cpp -- see desktop.hpp.
#include "desktop.hpp"

#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <mutex>
#include <string>
#include <thread>
#include <sys/stat.h>

#ifdef _WIN32
  #include <windows.h>
  #include <shlobj.h>
  #include <shobjidl.h>
#else
  #include <unistd.h>
  #include <sys/wait.h>
#endif

namespace forge {
namespace {

bool is_project_dir(const std::string& dir) {
    struct stat st{};
    return stat((dir + "/data_extracted/engine").c_str(), &st) == 0 &&
           (st.st_mode & S_IFDIR);
}

std::string exe_dir() {
#ifdef _WIN32
    char buf[MAX_PATH] = {0};
    GetModuleFileNameA(nullptr, buf, MAX_PATH);
    std::string p = buf;
    size_t k = p.find_last_of("\\/");
    return k == std::string::npos ? "." : p.substr(0, k);
#else
    char buf[4096] = {0};
    ssize_t n = readlink("/proc/self/exe", buf, sizeof buf - 1);
    if (n <= 0) return ".";
    std::string p(buf, (size_t)n);
    size_t k = p.find_last_of('/');
    return k == std::string::npos ? "." : p.substr(0, k);
#endif
}

#ifdef _WIN32
// Native folder picker (IFileOpenDialog, FOS_PICKFOLDERS). Empty on cancel.
std::string pick_project_folder() {
    std::string out;
    if (FAILED(CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED))) return out;
    IFileOpenDialog* dlg = nullptr;
    if (SUCCEEDED(CoCreateInstance(CLSID_FileOpenDialog, nullptr, CLSCTX_ALL,
                                   IID_IFileOpenDialog, (void**)&dlg))) {
        DWORD opts = 0;
        dlg->GetOptions(&opts);
        dlg->SetOptions(opts | FOS_PICKFOLDERS | FOS_PATHMUSTEXIST);
        dlg->SetTitle(L"Open a Forge project (the folder containing data_extracted)");
        if (SUCCEEDED(dlg->Show(nullptr))) {
            IShellItem* item = nullptr;
            if (SUCCEEDED(dlg->GetResult(&item))) {
                PWSTR w = nullptr;
                if (SUCCEEDED(item->GetDisplayName(SIGDN_FILESYSPATH, &w))) {
                    int len = WideCharToMultiByte(CP_UTF8, 0, w, -1, nullptr, 0, nullptr, nullptr);
                    std::string s(len > 0 ? len - 1 : 0, '\0');
                    WideCharToMultiByte(CP_UTF8, 0, w, -1, s.data(), len, nullptr, nullptr);
                    out = s;
                    CoTaskMemFree(w);
                }
                item->Release();
            }
        }
        dlg->Release();
    }
    CoUninitialize();
    return out;
}

// Locate a Chromium-engine browser for the app-mode window. Edge ships on
// every Windows 10/11 machine.
std::string find_edge() {
    char buf[MAX_PATH] = {0};
    DWORD n = sizeof buf;
    if (RegGetValueA(HKEY_LOCAL_MACHINE,
                     "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\msedge.exe",
                     nullptr, RRF_RT_REG_SZ, nullptr, buf, &n) == ERROR_SUCCESS && buf[0])
        return buf;
    const char* fixed[] = {
        "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
        "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
    };
    for (const char* p : fixed) {
        struct stat st{};
        if (stat(p, &st) == 0) return p;
    }
    return "";
}

// Open the editor window and wait for it to close. Returns false if no
// app-mode browser was found (caller falls back to a plain browser tab).
bool run_app_window(const std::string& url) {
    std::string edge = find_edge();
    if (edge.empty()) return false;
    // A dedicated user-data-dir keeps the app window its own process, so
    // waiting on it == waiting for the editor window to close.
    char lad[MAX_PATH] = {0};
    DWORD n = sizeof lad;
    if (RegGetValueA(HKEY_CURRENT_USER,
                     "Volatile Environment", "LOCALAPPDATA",
                     RRF_RT_REG_SZ, nullptr, lad, &n) != ERROR_SUCCESS || !lad[0]) {
        const char* e = std::getenv("LOCALAPPDATA");
        std::snprintf(lad, sizeof lad, "%s", e ? e : "C:\\Temp");
    }
    std::string cmd = "\"" + edge + "\" --app=" + url +
                      " --user-data-dir=\"" + std::string(lad) + "\\Forge\\webview\"" +
                      " --no-first-run --no-default-browser-check";
    STARTUPINFOA si{};
    si.cb = sizeof si;
    PROCESS_INFORMATION pi{};
    std::string mut = cmd;   // CreateProcess wants a mutable buffer
    if (!CreateProcessA(nullptr, mut.data(), nullptr, nullptr, FALSE,
                        0, nullptr, nullptr, &si, &pi))
        return false;
    WaitForSingleObject(pi.hProcess, INFINITE);
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
    return true;
}
#else
// POSIX (dev parity): try a Chromium-engine browser in app mode; wait on it.
bool run_app_window(const std::string& url) {
    const char* cands[] = {"chromium", "chromium-browser", "google-chrome",
                           "microsoft-edge", "msedge"};
    for (const char* b : cands) {
        std::string probe = std::string("command -v ") + b + " >/dev/null 2>&1";
        if (std::system(probe.c_str()) != 0) continue;
        std::string cmd = std::string(b) + " --app=" + url +
                          " --user-data-dir=/tmp/forge-webview"
                          " --no-first-run >/dev/null 2>&1";
        return std::system(cmd.c_str()) != -1;
    }
    return false;
}
std::string pick_project_folder() { return ""; }   // no native picker headless
#endif

}  // namespace

int desktop_main(const char* project_dir, const HttpHandler& handler) {
    // ---- resolve the project ----
    std::string proj;
    if (project_dir && *project_dir) {
        proj = project_dir;
        if (!is_project_dir(proj)) {
            std::fprintf(stderr,
                "Forge: %s is not a project folder (no data_extracted/engine).\n",
                proj.c_str());
            return 1;
        }
    } else if (is_project_dir(".")) {
        proj = ".";
    } else if (is_project_dir(exe_dir())) {
        proj = exe_dir();
    } else {
        proj = pick_project_folder();
        if (proj.empty() || !is_project_dir(proj)) {
#ifdef _WIN32
            MessageBoxA(nullptr,
                "Pick the project folder that contains data_extracted\\engine\n"
                "(for Colonization: the repository checkout).",
                "Forge - no project selected", MB_ICONINFORMATION);
#else
            std::fprintf(stderr,
                "Forge: no project found. Run from a project folder or pass one:\n"
                "  forge desktop /path/to/project\n");
#endif
            return 1;
        }
    }
#ifdef _WIN32
    SetCurrentDirectoryA(proj.c_str());
#else
    if (chdir(proj.c_str()) != 0) {
        std::fprintf(stderr, "Forge: cannot enter %s\n", proj.c_str());
        return 1;
    }
#endif
    std::printf("Forge: project %s\n", proj.c_str());

    // ---- start the engine server on an ephemeral loopback port ----
    std::mutex m;
    std::condition_variable cv;
    int port = 0;
    std::thread server([&handler, &m, &cv, &port]() {
        serve_http(0, handler, [&m, &cv, &port](int p) {
            std::lock_guard<std::mutex> lk(m);
            port = p;
            cv.notify_all();
        });
    });
    server.detach();   // dies with the process (single-session dev tool)
    {
        std::unique_lock<std::mutex> lk(m);
        if (!cv.wait_for(lk, std::chrono::seconds(5), [&port] { return port != 0; })) {
            std::fprintf(stderr, "Forge: engine server failed to start\n");
            return 1;
        }
    }
    const std::string url = "http://127.0.0.1:" + std::to_string(port) + "/";

    // ---- open the editor window; block until it closes ----
    if (run_app_window(url)) return 0;

    // Fallback: no app-mode browser -- open a normal tab and keep serving.
#ifdef _WIN32
    ShellExecuteA(nullptr, "open", url.c_str(), nullptr, nullptr, SW_SHOWNORMAL);
#else
    std::system(("xdg-open " + url + " >/dev/null 2>&1 &").c_str());
#endif
    std::printf("Forge: editor at %s (close with Ctrl-C)\n", url.c_str());
    for (;;) std::this_thread::sleep_for(std::chrono::hours(1));
}

} // namespace forge
