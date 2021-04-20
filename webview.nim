import tables

{.passC: "-DWEBVIEW_STATIC -DWEBVIEW_IMPLEMENTATION".}
{.passC: "-I" & currentSourcePath().substr(0, high(currentSourcePath()) - 4) .}

when defined(linux):
  {.passC: "`pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`".}
  {.passL: "`pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0`".}
elif defined(macosx):
  {.passL: "-framework WebKit".}
type
  cstring2{.importcpp:"const char*".} = cstring
  Webview* {.importc: "webview_t",header: "webview.h".} = pointer
  WebviewHint* = enum
    WEBVIEW_HINT_NONE,WEBVIEW_HINT_MIN,WEBVIEW_HINT_MAX,WEBVIEW_HINT_FIXED
  BindFn* = proc(sequ: cstring, req: cstring)
type WebviewCb = proc(seq: cstring2, req: cstring2, arg: pointer){.cdecl.}

proc create*(debug:cint,window:pointer): Webview{.importc: "webview_create",header: "webview.h".}
proc set_title*(w: Webview,title: cstring){.importc: "webview_set_title",header: "webview.h".}
proc set_size*(w: Webview,width:cint,height:cint,hints: WebviewHint){.importc: "webview_set_size",header: "webview.h".}
proc navigate*(w: Webview,url: cstring){.importc: "webview_navigate",header: "webview.h".}
proc run*(w: Webview){.importc: "webview_run",header: "webview.h".}
proc destroy*(w: Webview){.importc: "webview_destroy",header: "webview.h".}
proc eval*(w: Webview, js: cstring){.importc: "webview_eval", header: "webview.h".}
proc connect*(w: Webview, name: cstring, fn: WebviewCb, arg: pointer){.importc: "webview_bind", header: "webview.h".}
proc init*(w: Webview, js: cstring){.importc: "webview_init", header: "webview.h".}


var bindCallTable = newTable[int, BindFn]()

proc bindCProc(sequ: cstring2, req: cstring2, arg: pointer) {.cdecl.} =
  let idx = cast[int](arg)
  let fn = bindCallTable[idx]
  fn(cast[cstring](sequ),cast[cstring](req))

proc connect*(w: Webview, name: cstring, fn: BindFn) =
  let idx = bindCallTable.len()+1
  bindCallTable[idx] = fn
  connect(w, name, bindCProc, cast[pointer](idx))
