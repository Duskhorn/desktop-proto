import sdl2
import sdl2/image
import shape

const name = "src/assets/proto-test.png"
const DEV_MODE = true

template render(r: RendererPtr, t: TexturePtr, dim: Rect) = 
    r.setDrawColor 0, 0, 255, 255
    r.clear
    r.copy t, addr dim, addr dim 
    r.present

proc main() =
    discard sdl2.init(INIT_EVERYTHING)
    defer: sdl2.quit()
    
    var 
        surface = image.load(name)
        mode: WindowShapeMode
    defer: destroy surface
    
    if surface.format.format.SDL_ISPIXELFORMAT_ALPHA():
        mode.mode = ShapeModeBinarizeAlpha
        mode.parameters.binarizationCutoff = 255
    else:
        mode.mode = ShapeModeColorKey
        mode.parameters.colorKey = color(0,0,0,255)

    var window = createShapedWindow(name, 100, 100, 100, 100, 0)
    defer: destroy window

    window.setPosition(100, 100)

    var renderer = createRenderer(window, -1, Renderer_Accelerated or Renderer_TargetTexture)
    defer: destroy renderer

    var 
        texture = renderer.createTextureFromSurface(surface)
        pixfmt: uint32 = 0
        access: cint = 0
        dim = rect(0,0,0,0)
        evt = sdl2.defaultEvent
        running = true

    defer: destroy texture

    echo "setting up image"
    queryTexture(texture, addr pixfmt, addr access, addr dim.w, addr dim.h)
    window.setSize(dim.w, dim.h)
    window.setShape(surface, addr mode)
    echo dim.repr
    
    while running:
        while pollEvent(evt):
            case evt.kind:
            of KeyDown:
                if evt.key.keysym.sym == K_q and evt.key.keysym.mod and KMOD_LSHIFT or KMOD_RSHIFT != 0:
                    running = false
                    echo "Quit"
                elif DEV_MODE and evt.key.keysym.sym == K_r:
                    var t1 = renderer.createTextureFromSurface(surface)
                    queryTexture(t1, addr pixfmt, addr access, addr dim.w, addr dim.h)
                    window.setSize(dim.w, dim.h)
                    window.setShape(surface, addr mode)
                    texture = t1
                    destroy t1
                    echo "Reloaded"
            of QuitEvent: 
                running = false
                echo "Quit"
                break
            else: continue

        window.hide()  # hide the window to make it invisible
        render(renderer, texture, dim)  
        sdl2.delay(10)           
main()
