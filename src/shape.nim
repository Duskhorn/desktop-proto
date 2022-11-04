import sdl2
{. passL: "-I/usr/include/SDL2" .}
{. push callconv: cdecl, dynlib: "libSDL2(|-2.0).so(|.0)" .}

type 
    ShapeMode* = enum
        ShapeModeDefault
        ShapeModeBinarizeAlpha
        ShapeModeReverseBinarizeAlpha
        ShapeModeColorKey
    
    ShapeParameters* {. union .} = object  
        binarizationCutoff*: uint8
        colorKey*: Color
    
    WindowShapeMode* = object
        mode*: ShapeMode
        parameters*: ShapeParameters

proc createShapedWindow*(title: cstring, x, y, w, h: cint, flags: uint32) : WindowPtr {. importc: "SDL_CreateShapedWindow".}
proc setShape*(window: WindowPtr, shape: SurfacePtr, mode: ptr WindowShapeMode) : cint {. importc: "SDL_SetWindowShape", discardable.}

{. pop .}