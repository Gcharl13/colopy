// forge/httpd.hpp -- a tiny localhost HTTP server for the Forge browser GUI.
//
// No external deps (POSIX sockets only). Bound to 127.0.0.1 because the request
// handler reads/writes files by path — it must not be exposed to the network.
// Single-threaded (one request at a time), which is plenty for a local dev tool.
#pragma once

#include <functional>
#include <string>

namespace forge {

struct HttpResponse {
    int status = 200;
    std::string content_type = "application/json";
    std::string body;
};

// handler(method, path, query, body) -> response.
using HttpHandler = std::function<HttpResponse(const std::string& method,
                                               const std::string& path,
                                               const std::string& query,
                                               const std::string& body)>;

// Serve on 127.0.0.1:port forever (until the process is killed). Returns non-zero
// on bind/listen failure (or on platforms without POSIX sockets).
int serve_http(int port, const HttpHandler& handler);

} // namespace forge
