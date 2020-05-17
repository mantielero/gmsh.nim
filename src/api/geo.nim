##[
Geo
===

Built-in CAD kernel functions
http://gmsh.info/doc/texinfo/gmsh.html#Namespace-gmsh_002fmodel_002fgeo
]##
import ../wrapper/gmsh_wrapper
import strformat

proc addPoint*[N:SomeNumber,M:SomeNumber](x,y,z:N; meshSize:M = 0, tag:int = -1):int  {.discardable.} =
  ##[
  Add a geometrical point in the built-in CAD representation, at coordinates
  `x`, `y`, `z`. 

  If `meshSize` is > 0, add a meshing constraint at that
  point. 
  
  If `tag` is positive, set the tag explicitly; otherwise a new tag is
  selected automatically. Return the tag of the point. 
  
  (Note that the point
  will be added in the current model only after synchronize' is called. This
  behavior holds for all the entities added in the geo module.)
  ]##
  var ierr:cint  
  let t = gmshModelGeoAddPoint(x.cdouble, y.cdouble, z.cdouble, meshSize.cdouble, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new point")  
  return t.int


proc addLine*(startTag, endTag:Natural; tag:int = -1 ):int =
  ##    Add a straight line segment between the two points with tags startTag' and
  ##    endTag'. If tag' is positive, set the tag explicitly; otherwise a new tag
  ##    is selected automatically. Return the tag of the line.
  var ierr:cint 
  let t = gmshModelGeoAddLine(startTag.cint, endTag.cint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new line")  
  return t.int


proc addCircleArc*(startTag, centerTag, endTag:int;tag:int = -1;n:tuple[x:float,y:float,z:float]= (x:0.0,y:0.0,z:0.0) ):int =
  ##[
  Add a circle arc (strictly smaller than Pi) between the two points with
  tags startTag' and endTag', with center centertag'. 
     
  If tag' is positive, set the tag explicitly; otherwise a new tag is selected
  automatically. 
  
  If (nx', ny', nz') != (0, 0, 0), explicitly set the plane
  of the circle arc. Return the tag of the circle arc.
  ]##
  var ierr:cint   
  let t = gmshModelGeoAddCircleArc(startTag.cint, centerTag.cint, endTag.cint, tag.cint, n.x.cdouble, n.y.cdouble, n.z.cdouble,  ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new circle arc")  
  return t.int



proc addEllipseArc*( startTag, centerTag, majorTag, endTag:int;
                     tag:int = -1; n:tuple[x:float,y:float,z:float]= (x:0.0,y:0.0,z:0.0) ):int =
  ##[
  Add an ellipse arc (strictly smaller than Pi) between the two points
  startTag' and endTag', with center centerTag' and major axis point
  majorTag'. If tag' is positive, set the tag explicitly; otherwise a new
  tag is selected automatically. If (nx', ny', nz') != (0, 0, 0),
  explicitly set the plane of the circle arc. Return the tag of the ellipse
  arc.
  ]##
  var ierr:cint   
  let t = gmshModelGeoAddEllipseArc(startTag.cint, centerTag.cint, majorTag.cint, endTag.cint, 
                   tag.cint, n.x.cdouble, n.y.cdouble, n.z.cdouble,  ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new ellipse arc")  
  return t.int  


proc addSpline*(pointTags:seq[int];tag:int = -1):int =
  ##[
  Add a spline (Catmull-Rom) curve going through the points pointTags'. If
  tag' is positive, set the tag explicitly; otherwise a new tag is selected
  automatically. Create a periodic curve if the first and last points are the
  same. Return the tag of the spline curve.
  ]##
  var ierr:cint   
  let t = gmshModelGeoAddSpline(cast[ptr cint](pointTags[0].unsafeAddr), pointTags.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")  
  return t.int  


proc addBSpline*(pointTags:seq[int];tag:int = -1):int =
  ##[
  Add a cubic b-spline curve with pointTags' control points. If tag' is
  positive, set the tag explicitly; otherwise a new tag is selected
  automatically. Creates a periodic curve if the first and last points are
  the same. Return the tag of the b-spline curve.
  ]##
  var ierr:cint   
  let t = gmshModelGeoAddBSpline(cast[ptr cint](pointTags[0].unsafeAddr), pointTags.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new b-spline")  
  return t.int  


proc addBezier*(pointTags:seq[int];tag:int = -1):int =
  ##[
  Add a Bezier curve with pointTags' control points. If tag' is positive,
  set the tag explicitly; otherwise a new tag is selected automatically.
  Return the tag of the Bezier curve.
  ]##
  var ierr:cint   
  let t = gmshModelGeoAddBezier(cast[ptr cint](pointTags[0].unsafeAddr), pointTags.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new b-spline")  
  return t.int  


proc addCompoundSpline*(curveTags:seq[int], numIntervals:int; tag:int = -1):int =
  ##[
  Add a spline (Catmull-Rom) going through points sampling the curves in
  curveTags'. The density of sampling points on each curve is governed by
  numIntervals'. If tag' is positive, set the tag explicitly; otherwise a
  new tag is selected automatically. Return the tag of the spline.
  ]##
  var ierr:cint   
  let t = gmshModelGeoAddCompoundSpline(cast[ptr cint](curveTags[0].unsafeAddr), curveTags.len.uint, numIntervals.cint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new compound spline")  
  return t.int 


proc addCompoundBSpline*(curveTags:seq[int], numIntervals:int; tag:int = -1):int =
  ##[
  Add a b-spline with control points sampling the curves in curveTags'. The
  density of sampling points on each curve is governed by numIntervals'. If
  tag' is positive, set the tag explicitly; otherwise a new tag is selected
  automatically. Return the tag of the b-spline.
  ]##
  var ierr:cint   
  let t = gmshModelGeoAddCompoundBSpline(cast[ptr cint](curveTags[0].unsafeAddr), curveTags.len.uint, numIntervals.cint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new compound b-spline")  
  return t.int 


proc addCurveLoop*(curve:seq[int]; tag:int = -1):int =
  ##[
  ##    Add a curve loop (a closed wire) formed by the curves curveTags'.
  ##    curveTags' should contain (signed) tags of model enties of dimension 1
  ##    forming a closed loop: a negative tag signifies that the underlying curve
  ##    is considered with reversed orientation. If tag' is positive, set the tag
  ##    explicitly; otherwise a new tag is selected automatically. Return the tag
  ##    of the curve loop.
  ]##
  var ierr:cint
  let curvePtr =  curve[0].unsafeAddr #curve[0].unsafeAddr
  var curveCint = newSeq[cint](curve.len)
  for i in 0..<curve.len:
    curveCint[i] = curve[i].cint
  #echo "tag: ", tag
  #echo "Curve: ", curve
  #echo "Curve: ", repr curvePtr 
  let t = gmshModelGeoAddCurveLoop( cast[ptr cint](curveCint[0].unsafeAddr), curveCint.len.uint, tag.cint,  ierr.unsafeAddr)
  echo "tag: ", t
  assert( ierr == 0, "error while adding a new curve loop")  
  return t.int


proc addPlaneSurface*(wireTags1:seq[int]; tag:int = -1):int =
  ##[
  Add a plane surface defined by one or more curve loops wireTags'. The
  first curve loop defines the exterior contour; additional curve loop define
  holes. If tag' is positive, set the tag explicitly; otherwise a new tag is
  selected automatically. Return the tag of the surface.
  ]##
  var ierr:cint
  let wireTags = @[1.cint]
  echo wireTags 
  echo sizeof(cint), " ", sizeof(int )
  let t = gmshModelGeoAddPlaneSurface( cast[ptr cint](wireTags[0].unsafeAddr), 
                                       wireTags.len.uint,  
                                       tag.cint, 
                                       ierr.unsafeAddr)                                                            
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.int    


proc addSurfaceFilling*(wireTags:seq[int], sphereCenterTag:int; tag:int = -1):int =
  ##[
  Add a surface filling the curve loops in wireTags'. Currently only a
  single curve loop is supported; this curve loop should be composed by 3 or
  4 curves only. If tag' is positive, set the tag explicitly; otherwise a
  new tag is selected automatically. Return the tag of the surface.
  ]## 
  var ierr:cint
  let t = gmshModelGeoAddSurfaceFilling(cast[ptr cint](wireTags[0].unsafeAddr), wireTags.len.uint,  tag.cint, sphereCenterTag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new surface filling")  
  return t.int    


proc addSurfaceLoop*(surfaceTags:seq[int]; tag:int = -1):int =
  ##[
  Add a surface loop (a closed shell) formed by surfaceTags'.  If tag' is
  positive, set the tag explicitly; otherwise a new tag is selected
  automatically. Return the tag of the shell.
  ]## 
  var ierr:cint
  let t = gmshModelGeoAddSurfaceLoop(cast[ptr cint](surfaceTags[0].unsafeAddr), surfaceTags.len.uint,  tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new surface loop")  
  return t.int 


proc addVolume*(shellTags:seq[int]; tag:int = -1):int =
  ##[
  Add a volume (a region) defined by one or more shells shellTags'. The
  first surface loop defines the exterior boundary; additional surface loop
  define holes. If tag' is positive, set the tag explicitly; otherwise a new
  tag is selected automatically. Return the tag of the volume.
  ]## 
  var ierr:cint
  let t = gmshModelGeoAddSurfaceLoop(cast[ptr cint](shellTags[0].unsafeAddr), shellTags.len.uint,  tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new surface loop" )  
  return t.int 


proc extrude*( dimTags:seq[int], d:tuple[x:float, y:float,z:float]; 
               numElements:seq[int] = @[]; heights:seq[float] = @[]; recombine:bool=false):int =
  ##[
  Extrude the model entities dimTags' by translation along (dx', dy',
  dz'). 
  
  Return extruded entities in outDimTags'. If numElements' is not
  empty, also extrude the mesh: the entries in numElements' give the number
  of elements in each layer. If height' is not empty, it provides the
  (cumulative) height of the different layers, normalized to 1. If dx' ==
  dy' == dz' == 0, the entities are extruded along their normal.
  ]## 
  var ierr:cint
  var outDimTagsPtr:ptr ptr cint
  var outDimTagsPtr_n:ptr uint
  var recomb:cint = if recombine: 1 else: 0
  gmshModelGeoExtrude( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,  
                       d.x.cdouble, d.y.cdouble, d.z.cdouble,
                       outDimTagsPtr, outDimTagsPtr_n, 
                       cast[ptr cint](numElements.unsafeAddr), numElements.len.uint, 
                       cast[ptr cdouble](heights.unsafeAddr), heights.len.uint,
                       recomb, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new surface loop")  
  #tmp_api_outDimTags_ = unsafe_wrap(Array, api_outDimTags_[], api_outDimTags_n_[], own=true)
  #outDimTags = [ (tmp_api_outDimTags_[i], tmp_api_outDimTags_[i+1]) for i in 1:2:length(tmp_api_outDimTags_) ]
  return recombine.int 

                     

#[
proc gmshModelGeoRevolve*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                         z: cdouble; ax: cdouble; ay: cdouble; az: cdouble;
                         angle: cdouble; outDimTags: ptr ptr cint;
                         outDimTags_n: ptr uint; numElements: ptr cint;
                         numElements_n: uint; heights: ptr cdouble; heights_n: uint;
                         recombine: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Extrude the model entities dimTags' by rotation of angle' radians around
  ##    the axis of revolution defined by the point (x', y', z') and the
  ##    direction (ax', ay', az'). The angle should be strictly smaller than Pi.
  ##    Return extruded entities in outDimTags'. If numElements' is not empty,
  ##    also extrude the mesh: the entries in numElements' give the number of
  ##    elements in each layer. If height' is not empty, it provides the
  ##    (cumulative) height of the different layers, normalized to 1.

proc gmshModelGeoTwist*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                       z: cdouble; dx: cdouble; dy: cdouble; dz: cdouble; ax: cdouble;
                       ay: cdouble; az: cdouble; angle: cdouble;
                       outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                       numElements: ptr cint; numElements_n: uint;
                       heights: ptr cdouble; heights_n: uint; recombine: cint;
                       ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Extrude the model entities dimTags' by a combined translation and rotation
  ##    of angle' radians, along (dx', dy', dz') and around the axis of
  ##    revolution defined by the point (x', y', z') and the direction (ax',
  ##    ay', az'). The angle should be strictly smaller than Pi. Return extruded
  ##    entities in outDimTags'. If numElements' is not empty, also extrude the
  ##    mesh: the entries in numElements' give the number of elements in each
  ##    layer. If height' is not empty, it provides the (cumulative) height of the
  ##    different layers, normalized to 1.
]#


proc translate*() =
  ##[

  ]##
  
#[
proc gmshModelGeoTranslate*(dimTags: ptr cint; dimTags_n: uint; dx: cdouble;
                           dy: cdouble; dz: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Translate the model entities dimTags' along (dx', dy', dz').

proc gmshModelGeoRotate*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                        z: cdouble; ax: cdouble; ay: cdouble; az: cdouble;
                        angle: cdouble; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Rotate the model entities dimTags' of angle' radians around the axis of
  ##    revolution defined by the point (x', y', z') and the direction (ax',
  ##    ay', az').

proc gmshModelGeoDilate*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                        z: cdouble; a: cdouble; b: cdouble; c: cdouble; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Scale the model entities dimTag' by factors a', b' and c' along the
  ##    three coordinate axes; use (x', y', z') as the center of the homothetic
  ##    transformation.

proc gmshModelGeoMirror*(dimTags: ptr cint; dimTags_n: uint; a: cdouble; b: cdouble;
                        c: cdouble; d: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Mirror the model entities dimTag', with respect to the plane of equation
  ##    a' x + b' y + c' z + d' = 0.

proc gmshModelGeoSymmetrize*(dimTags: ptr cint; dimTags_n: uint; a: cdouble; b: cdouble;
                            c: cdouble; d: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Mirror the model entities dimTag', with respect to the plane of equation
  ##    a' x + b' y + c' z + d' = 0. (This is a synonym for mirror',
  ##    which will be deprecated in a future release.)

proc gmshModelGeoCopy*(dimTags: ptr cint; dimTags_n: uint; outDimTags: ptr ptr cint;
                      outDimTags_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Copy the entities dimTags'; the new entities are returned in outDimTags'.

proc gmshModelGeoRemove*(dimTags: ptr cint; dimTags_n: uint; recursive: cint;
                        ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the entities dimTags'. If recursive' is true, remove all the
  ##    entities on their boundaries, down to dimension 0.

proc gmshModelGeoRemoveAllDuplicates*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove all duplicate entities (different entities at the same geometrical
  ##    location).

proc gmshModelGeoSplitCurve*(tag: cint; pointTags: ptr cint; pointTags_n: uint;
                            curveTags: ptr ptr cint; curveTags_n: ptr uint;
                            ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Split the model curve of tag tag' on the control points pointTags'.
  ##    Return the tags curveTags' of the newly created curves.

proc gmshModelGeoGetMaxTag*(dim: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the maximum tag of entities of dimension dim' in the built-in CAD
  ##    representation.

proc gmshModelGeoSetMaxTag*(dim: cint; maxTag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set the maximum tag maxTag' for entities of dimension dim' in the built-
  ##    in CAD representation.
  ## 

]#

proc geoSync*() =
  ##    Synchronize the built-in CAD representation with the current Gmsh model.
  ##    This can be called at any time, but since it involves a non trivial amount
  ##    of processing, the number of synchronization points should normally be
  ##    minimized.
  var ierr:cint   
  gmshModelGeoSynchronize( ierr.unsafeAddr )  
  assert( ierr == 0, "error while synchronizing the geometry") 