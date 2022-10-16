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
        pt = getCurrentDir() & "/src/assets/headtest.png"
        proto = loadImageError(pt.cstring, err)
    
    contextSetImage(proto)
    echo "loaded image file from '" & pt & "'"
    echo "If this is zero, the image loaded correctly! --> *** " & repr(err) & " ***"
    echo "the file is " & $imageGetWidth() & "x" & $imageGetHeight() & " pixels"

    let
        w = imageGetWidth()
        h = imageGetHeight()
    let
        screen = DefaultScreen(display)  
        visual = DefaultVisual(display, screen)
        colormap = DefaultColormap(display, screen)      

        window = XCreateSimpleWindow(
            display, 
            RootWindow(display, screen),
            0, 0, w, h, 0,
            BlackPixel(display, screen),
            WhitePixel(display, screen))

        pix = XCreatePixmap(
            display, 
            window.Drawable, 
            w, 
            h,
            DefaultDepth(display, screen).cuint)
        
        gc = XCreateGC(display, window, 0, nil)

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

    discard XSetForeground(display, gc, 0x00000000)
    discard XFillRectangle(display, window, gc, 0, 0, w, h)
    
    var event: XEvent
    while XPending(display) == 0:
        discard XNextEvent(display, event.addr)
        if event.theType == KeyPress: break

    freeImage(proto)
    
main()
