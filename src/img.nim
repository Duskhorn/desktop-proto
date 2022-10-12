{. passL: gorge("pkg-config --libs imlib2") .}

from x11/xlib import Display, Visual
from x11/x import Window

type
    Image* {. importc: "Imlib_Image", header: "<Imlib2.h>".} = distinct pointer
    LoadError* {. importc: "Imlib_Load_Error", header: "<Imlib2.h>" .} = distinct cint
        

proc loadImage*(path: cstring): Image {. importc: "imlib_load_image", header: "<Imlib2.h>".}
proc loadImageError*(path: cstring, err: var LoadError): Image {. importc: "imlib_load_image_with_error_return", header: "<Imlib2.h>".}
proc freeImage*(im: Image) {. importc: "imlib_load_image", header: "<Imlib2.h>", discardable.}
proc imageGetWidth*(): cuint {. importc: "imlib_image_get_width", header: "<Imlib2.h>".}
proc imageGetHeight*(): cuint {. importc: "imlib_image_get_height", header: "<Imlib2.h>".}

proc contextSetImage*(im: Image) {. importc: "imlib_context_set_image", header: "<Imlib2.h>", discardable .}
proc contextSetDisplay*(ds: ptr Display) {. importc: "imlib_context_set_display", header: "<Imlib2.h>", discardable .}
proc contextSetVisual*(vs: ptr Visual) {. importc: "imlib_context_set_visual", header: "<Imlib2.h>", discardable .}
proc contextSetDrawable*(vs: Window) {. importc: "imlib_context_set_drawable", header: "<Imlib2.h>", discardable .}
proc contextSetColormap*(vs: Window) {. importc: "imlib_context_set_colormap", header: "<Imlib2.h>", discardable .}

proc renderOnDrawable(x, y: cint) {. importc: "imlib_render_image_on_drawable", header: "<Imlib2.h>".}
