// forge/httpd.cpp -- see httpd.hpp. One shared HTTP body over a thin socket
// abstraction, so it compiles natively on both POSIX and Windows (Winsock).
#include "httpd.hpp"

#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <string>

#ifdef _WIN32
  #include <winsock2.h>
  #include <ws2tcpip.h>
  namespace {
    using sock_t = SOCKET;
    const sock_t kInvalidSock = INVALID_SOCKET;
    bool net_init()  { WSADATA w; return WSAStartup(MAKEWORD(2, 2), &w) == 0; }
    void net_close(sock_t s) { closesocket(s); }
  }
#else
  #include <arpa/inet.h>
  #include <netinet/in.h>
  #include <sys/socket.h>
  #include <unistd.h>
  namespace {
    using sock_t = int;
    const sock_t kInvalidSock = -1;
    bool net_init()  { return true; }
    void net_close(sock_t s) { close(s); }
  }
#endif

namespace forge {
namespace {

// Read a full request (headers + body honoring Content-Length). false on EOF/error.
bool recv_request(sock_t fd, std::string& head, std::string& body) {
    std::string buf;
    char tmp[4096];
    size_t hend;
    while ((hend = buf.find("\r\n\r\n")) == std::string::npos) {
        auto n = recv(fd, tmp, (int)sizeof tmp, 0);
        if (n <= 0) return false;
        buf.append(tmp, (size_t)n);
        if (buf.size() > (8u << 20)) return false;   // 8 MB header cap
    }
    head = buf.substr(0, hend);
    body = buf.substr(hend + 4);

    std::string lower = head;
    for (char& c : lower) c = (char)std::tolower((unsigned char)c);
    size_t p = lower.find("content-length:");
    size_t content_len = 0;
    if (p != std::string::npos)
        content_len = (size_t)std::strtoul(head.c_str() + p + 15, nullptr, 10);

    while (body.size() < content_len) {
        auto n = recv(fd, tmp, (int)sizeof tmp, 0);
        if (n <= 0) break;
        body.append(tmp, (size_t)n);
    }
    return true;
}

void send_all(sock_t fd, const std::string& s) {
    size_t off = 0;
    while (off < s.size()) {
        auto n = send(fd, s.data() + off, (int)(s.size() - off), 0);
        if (n <= 0) break;
        off += (size_t)n;
    }
}

}  // namespace

int serve_http(int port, const HttpHandler& handler,
               const std::function<void(int)>& on_ready) {
    if (!net_init()) { std::fprintf(stderr, "forge serve: network init failed\n"); return 1; }

    sock_t srv = socket(AF_INET, SOCK_STREAM, 0);
    if (srv == kInvalidSock) { std::fprintf(stderr, "forge serve: socket() failed\n"); return 1; }
    int yes = 1;
    setsockopt(srv, SOL_SOCKET, SO_REUSEADDR, (const char*)&yes, sizeof yes);

    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);   // 127.0.0.1 only
    addr.sin_port = htons((unsigned short)port);
    if (bind(srv, (sockaddr*)&addr, sizeof addr) != 0) {
        std::fprintf(stderr, "forge serve: bind(127.0.0.1:%d) failed\n", port); net_close(srv); return 1;
    }
    if (listen(srv, 16) != 0) {
        std::fprintf(stderr, "forge serve: listen failed\n"); net_close(srv); return 1;
    }
    if (port == 0) {                                 // ephemeral: report the real port
        sockaddr_in got{};
#ifdef _WIN32
        int glen = sizeof got;
#else
        socklen_t glen = sizeof got;
#endif
        if (getsockname(srv, (sockaddr*)&got, &glen) == 0)
            port = (int)ntohs(got.sin_port);
    }
    if (on_ready) on_ready(port);

    std::printf("Forge: http://127.0.0.1:%d  (Ctrl-C to stop)\n", port);
    std::fflush(stdout);

    for (;;) {
        sock_t c = accept(srv, nullptr, nullptr);
        if (c == kInvalidSock) continue;
        std::string head, body;
        if (recv_request(c, head, body)) {
            // request line: METHOD SP TARGET SP HTTP/x
            std::string method, target;
            size_t e = head.find("\r\n");
            std::string line = head.substr(0, e == std::string::npos ? head.size() : e);
            size_t s1 = line.find(' ');
            size_t s2 = (s1 == std::string::npos) ? std::string::npos : line.find(' ', s1 + 1);
            if (s1 != std::string::npos) {
                method = line.substr(0, s1);
                target = line.substr(s1 + 1, (s2 == std::string::npos ? line.size() : s2) - s1 - 1);
            }
            std::string path = target, query;
            size_t q = target.find('?');
            if (q != std::string::npos) { path = target.substr(0, q); query = target.substr(q + 1); }

            HttpResponse r = handler(method, path, query, body);
            std::string out = "HTTP/1.1 " + std::to_string(r.status) + " OK\r\n";
            out += "Content-Type: " + r.content_type + "\r\n";
            out += "Content-Length: " + std::to_string(r.body.size()) + "\r\n";
            out += "Access-Control-Allow-Origin: *\r\n";
            out += "Connection: close\r\n\r\n";
            out += r.body;
            send_all(c, out);
        }
        net_close(c);
    }
}

} // namespace forge
