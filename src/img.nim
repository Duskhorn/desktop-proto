{. passL: gorge("pkg-config --libs imlib2") .}
#{. link: gorge("pkg-config --cflags imlib2") .}

type
    Image* {. importc: "Imlib_Image", header: "<Imlib2.h>".} = distinct pointer
        

proc loadImage*(path: cstring): Image {. importc: "imlib_load_image", header: "<Imlib2.h>".}
proc contextSetImage*(im: Image) {. importc: "imlib_context_set_image", header: "<Imlib2.h>", discardable .}


proc testImgStuff() =
    let im = loadImage("/home/dusk/projects/desktop-proto/src/assets/headtest.png")
    echo "loaded image"
    im.contextSetImage()
    echo "set context"

when isMainModule: testImgStuff()
