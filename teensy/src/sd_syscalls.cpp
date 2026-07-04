// sd_syscalls.cpp -- newlib file syscalls bridged to the Teensy SD card, so
// the shared game loaders (std::ifstream / fopen over relative paths like
// "data/base/conf/..." and "docs/atlas/pik/COLONY.png") read the microSD
// unmodified. Only what the loaders use is implemented: open-for-read,
// read, lseek, close, fstat. Writes go to the card too (save games).
#include <Arduino.h>
#include <SD.h>
#include <cerrno>
#include <cstring>
#include <sys/stat.h>
#include <unistd.h>

// fd 0/1/2 are reserved (stdio -> Serial); files start at 3
static constexpr int FD_BASE = 3;
static constexpr int MAX_OPEN = 8;
static File g_files[MAX_OPEN];
static bool g_used[MAX_OPEN] = {};

extern "C" {

int _open(const char* path, int flags, int /*mode*/) {
    int slot = -1;
    for (int i = 0; i < MAX_OPEN; ++i)
        if (!g_used[i]) { slot = i; break; }
    if (slot < 0) { errno = ENFILE; return -1; }
    // SD paths are rooted; the loaders use repo-relative names
    String p = path[0] == '/' ? String(path) : String("/") + path;
    bool writing = (flags & (O_WRONLY | O_RDWR)) != 0;
    File f = SD.open(p.c_str(), writing ? FILE_WRITE_BEGIN : FILE_READ);
    if (!f) { errno = ENOENT; return -1; }
    g_files[slot] = f;
    g_used[slot] = true;
    return FD_BASE + slot;
}

int _close(int fd) {
    int s = fd - FD_BASE;
    if (s < 0 || s >= MAX_OPEN || !g_used[s]) { errno = EBADF; return -1; }
    g_files[s].close();
    g_used[s] = false;
    return 0;
}

_READ_WRITE_RETURN_TYPE _read(int fd, void* buf, size_t n) {
    if (fd < FD_BASE) return 0;                     // no stdin
    int s = fd - FD_BASE;
    if (s < 0 || s >= MAX_OPEN || !g_used[s]) { errno = EBADF; return -1; }
    return g_files[s].read(buf, n);
}

_READ_WRITE_RETURN_TYPE _write(int fd, const void* buf, size_t n) {
    if (fd < FD_BASE) {                             // stdout/stderr -> Serial
        Serial.write((const uint8_t*)buf, n);
        return (int)n;
    }
    int s = fd - FD_BASE;
    if (s < 0 || s >= MAX_OPEN || !g_used[s]) { errno = EBADF; return -1; }
    return g_files[s].write((const uint8_t*)buf, n);
}

off_t _lseek(int fd, off_t off, int whence) {
    int s = fd - FD_BASE;
    if (s < 0 || s >= MAX_OPEN || !g_used[s]) { errno = EBADF; return -1; }
    File& f = g_files[s];
    uint64_t target = 0;
    if (whence == SEEK_SET) target = (uint64_t)off;
    else if (whence == SEEK_CUR) target = f.position() + off;
    else target = f.size() + off;
    if (!f.seek(target)) { errno = EINVAL; return -1; }
    return (off_t)f.position();
}

int _fstat(int fd, struct stat* st) {
    memset(st, 0, sizeof *st);
    int s = fd - FD_BASE;
    if (fd >= FD_BASE && s < MAX_OPEN && g_used[s]) {
        st->st_size = g_files[s].size();
        st->st_mode = S_IFREG;
    } else {
        st->st_mode = S_IFCHR;
    }
    return 0;
}

int _isatty(int fd) { return fd < FD_BASE; }

// directory listing for the store's data-tree walk (forge/fs_walk.hpp)
void vc_teensy_listdir(const char* dir,
                       void (*cb)(const char* name, int is_dir, void* ud),
                       void* ud) {
    String p = dir[0] == '/' ? String(dir) : String("/") + dir;
    File d = SD.open(p.c_str());
    if (!d || !d.isDirectory()) return;
    for (File e = d.openNextFile(); e; e = d.openNextFile()) {
        cb(e.name(), e.isDirectory() ? 1 : 0, ud);
        e.close();
    }
    d.close();
}

} // extern "C"
