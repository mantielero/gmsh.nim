import ../wrapper/gmsh_wrapper

# Option
proc set*[N:SomeNumber](name:string, value:N) =
  ##    Set a numerical option to value'. name' is of the form "category.option"
  ##    or "category[num].option". Available categories and options are listed in
  ##    the Gmsh reference manual.
  var ierr:cint 
  gmshOptionSetNumber(name.cstring, value.cdouble, ierr.unsafeAddr)
  assert( ierr == 0, "error while setting a number") 

proc getFloat*(name:string):float =
  ##    Get the value' of a numerical option. name' is of the form
  ##    "category.option" or "category[num].option". Available categories and
  ##    options are listed in the Gmsh reference manual.
  var ierr:cint 
  var value:cdouble
  gmshOptionGetNumber(name.cstring, value.unsafeAddr, ierr.unsafeAddr)
  assert( ierr == 0, "error while setting a number") 
  return value.float


proc set*(name, value:string) =
  ##    Set a string option to value'. name' is of the form "category.option" or
  ##    "category[num].option". Available categories and options are listed in the
  ##    Gmsh reference manual.
  var ierr:cint 
  gmshOptionSetString(name.cstring, value.cstring, ierr.unsafeAddr)
  assert( ierr == 0, "error while setting a string") 


proc getString*(name:string):string =
  ##    Get the value' of a string option. name' is of the form "category.option"
  ##    or "category[num].option". Available categories and options are listed in
  ##    the Gmsh reference manual.
  var ierr:cint 
  var value:cstring
  gmshOptionGetString(name.cstring, value.unsafeAddr, ierr.unsafeAddr)
  assert( ierr == 0, "error while setting a number") 
  return $value

type
  Color* = object
    r*:range[0..255]
    g*:range[0..255]
    b*:range[0..255]
    a*:range[0..255]

proc set*(name:string, color:Color) =
  ##    Set a color option to the RGBA value (r', g', b', a'), where where r',
  ##    g', b' and a' should be integers between 0 and 255. name' is of the
  ##    form "category.option" or "category[num].option". Available categories and
  ##    options are listed in the Gmsh reference manual, with the "Color." middle
  ##    string removed.
  var ierr:cint
  gmshOptionSetColor(name.cstring, color.r.cint, color.g.cint, color.b.cint, color.a.cint,  ierr.unsafeAddr) 
  assert( ierr == 0, "error while setting a color")   

proc getColor*( name:string ):Color =
  ##    Get the r', g', b', a' value of a color option. name' is of the form
  ##    "category.option" or "category[num].option". Available categories and
  ##    options are listed in the Gmsh reference manual, with the "Color." middle
  ##    string removed.
  var ierr:cint
  var r,g,b,a:cint
  gmshOptionGetColor(name.cstring, r.unsafeAddr, g.unsafeAddr, b.unsafeAddr, a.unsafeAddr,  ierr.unsafeAddr) 
  assert( ierr == 0, "error while getting a color")
  return Color(r:r.int,g:g.int,b:b.int,a:a.int)