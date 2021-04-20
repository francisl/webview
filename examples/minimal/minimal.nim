import webview

proc test(sequ: cstring, req:cstring) = 
    var stvalue: string = $sequ
    echo(stvalue)


var w = create(1,nil)
w.set_title("Webview Remote site")
w.set_size(640, 480, WEBVIEW_HINT_NONE)
w.navigate("https://nim-lang.org/")
w.connect("trythis", test)
w.init("document.getElementsByTagName('body')[0].innerHTML = ''; var ll = document.createElement('h1'); ll.innerText='test'; document.getElementsByTagName('body')[0].appendChild(ll); throw('test');")
w.run()
w.destroy()
