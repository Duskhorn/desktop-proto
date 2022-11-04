import sdl2
import sdl2/image
import shape



proc render(r: RendererPtr, t: TexturePtr, dim: Rect) = 
    r.setDrawColor 0, 0, 255, 255
    r.clear
    r.copy t, addr dim, addr dim 

proc main() =
    discard sdl2.init(INIT_EVERYTHING)
    defer: sdl2.quit()
    
    var 
        surface = image.load("src/assets/headtest.bmp")
        mode: WindowShapeMode
    defer: destroy surface

    echo surface.repr
    
    if surface.format.format.SDL_ISPIXELFORMAT_ALPHA():
        mode.mode = ShapeModeBinarizeAlpha
        mode.parameters.binarizationCutoff = 255
    else:
        mode.mode = ShapeModeColorKey
        mode.parameters.colorKey = color(0,0,0,255)

    var window = createShapedWindow("TEST", 0, 0, 1000, 1000, 0)
    defer: destroy window
    echo window.repr

    var renderer = createRenderer(window, -1, 0)
    defer: destroy renderer
    echo renderer.repr
    
    var 
        texture = renderer.createTextureFromSurface(surface)
        pixfmt: uint32 = 0
        access: cint = 0
        dim = rect(0,0,0,0)
    defer: destroy texture
    echo texture.repr

    queryTexture(texture, addr pixfmt, addr access, addr dim.w, addr dim.h)
    window.setSize(dim.w, dim.h)
    window.setShape(surface, addr mode)
    
    var 
        ev: Event
        run = true
    echo ev.repr
    while run:
        render(renderer, texture, dim)
        while pollEvent(ev):
            if ev.kind == QuitEvent: 
                run = false
                break
                     
main()