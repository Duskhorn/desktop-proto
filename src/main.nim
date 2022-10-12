import x11/xlib, x11/x
import img

from os import getCurrentDir

proc main() = 
    let display = XOpenDisplay(nil)
    if display == nil:
        echo "desktop-proto: cannot open display"
        return
    defer: 
        discard XCloseDisplay(display)

    var err: LoadError
    let 
        pt = getCurrentDir() & "/testing/proto-test.png"
        proto = loadImageError(pt.cstring, err)
    
    contextSetImage(proto)
    echo "loaded image file from '" & pt & "'"
    echo "If this is zero, the image loaded correctly! --> *** " & repr(err) & " ***"
    echo "the file is " & $imageGetWidth() & "x" & $imageGetHeight() & " pixels"

    let
        screen = DefaultScreen(display)  
        visual = DefaultVisual(display, screen)
        colormap = DefaultColormap(display, screen)      

        window = XCreateSimpleWindow(
            display, 
            RootWindow(display, screen),
            0, 0, imageGetWidth(), imageGetHeight(), 0,
            BlackPixel(display, screen),
            WhitePixel(display, screen))

        pix = XCreatePixmap(
            display, 
            window.Drawable, 
            imageGetWidth(), 
            imageGetHeight(),
            DefaultDepth(display, screen).cuint)

    defer:
        discard XDestroyWindow(display, window)
    
    contextSetDisplay(display)
    contextSetVisual(visual)
    contextSetColormap(colormap)
    contextSetDrawable(pix)

    discard XSelectInput(display, window, ExposureMask or KeyPressMask)
    discard XSetWindowBackgroundPixmap(display, window, pix)
    discard XMapWindow(display, window)
    discard XClearWindow(display, window)
    
    var event: XEvent
    while XPending(display) == 0:
        discard XNextEvent(display, event.addr)
        if event.theType == KeyPress: break

    freeImage(proto)
    
main()
