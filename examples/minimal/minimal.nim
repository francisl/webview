import webview

var w = create(0,nil)
w.set_title("Webview Remote site")
w.set_size(640, 480, WEBVIEW_HINT_NONE)
w.navigate("https://nim-lang.org/")
w.run()
w.terminate()
