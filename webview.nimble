# Package
version       = "0.2.1"
author        = "Francis Lavoie"
description   = "Nim bindings for webview https://github.com/webview/webview"
license       = "MIT"
skipDirs      = @["tests"]
backend       = "cpp"

# Dependencies
requires "nim >= 1.4.0"

task docs, "generate doc":
    exec "nim doc2 -o:docs/webview.html src/webview.nim"

task update_webview, "update webview.h":
    exec "curl -o webview/webview.h https://raw.githubusercontent.com/webview/webview/master/webview.h"
    exec "curl -o webview/README.md https://raw.githubusercontent.com/webview/webview/master/README.md"

task run_example, "running minimal example":
    exec "nim cpp --run examples/minimal/minimal.nim"

task clean, "clean tmp files":
    exec "rm -rf nimcache"
    exec "rm -rf tests/nimcache"
