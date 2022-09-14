import x11/xlib, x11/x

proc main() = 
    let display = XOpenDisplay(nil)
    if display == nil:
        echo "cannot open display"
        return

    defer: discard XCloseDisplay(display)

    let 
        screen = DefaultScreen(display)
        window = XCreateSimpleWindow(
            display, 
            RootWindow(display, screen),
            10, 10, 100, 100, 1,
            BlackPixel(display, screen),
            WhitePixel(display, screen))

    defer: discard XDestroyWindow(display, window)

    discard XSelectInput(display, window, ExposureMask or KeyPressMask)
    discard XMapWindow(display, window)

    var event: XEvent
    
    while true:

        discard XNextEvent(display, event.addr)

        case event.theType

        of Expose:
            discard XFillRectangle(display, window, DefaultGC(display, screen), 20, 20, 10, 10)    

        of KeyPress: break

        else: discard

main()
