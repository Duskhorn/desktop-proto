import sdl2
import sdl2/image
import shape



proc render(r: RendererPtr, t: TexturePtr, dim: Rect) = 
    r.setDrawColor 0, 0, 255, 255
    r.clear
    r.copy t, addr dim, addr dim 
    r.present

proc main() =
    discard sdl2.init(INIT_EVERYTHING)
    defer: sdl2.quit()
    
    var 
        surface = image.load("src/assets/headtest.png")
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

    var renderer = createRenderer(window, -1, Renderer_Accelerated or Renderer_TargetTexture)
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

    echo window.repr
    
    var 
        evt = sdl2.defaultEvent
        running = true
    
    while running:
        while pollEvent(evt):
            let k = evt.kind
            if k == QuitEvent: 
                running = false
                echo "quit"
                break
            elif k == KeyDown:
                running = false
                echo "key down"
                break
            else: continue

        render(renderer, texture, dim)             
main()