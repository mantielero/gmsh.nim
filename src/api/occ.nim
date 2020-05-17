import ../wrapper/gmsh_wrapper
import math

type
  Point*      = tuple[x,y,z:float]
  PointTag*   = Natural
  CurveTag*   = cint
  WireTag*    = cint
  SurfaceTag* = cint
  ShellTag*   = cint
  VolumeTag*  = cint
  #DimTag*     = tuple[dim:range[0..3], id:cint]
  DimTag*     = object
    dim*:range[cint(0)..cint(3)]
    id*:cint


proc flatten(items:seq[DimTag]):seq[cint] =
  var tmp = newSeq[cint]( 2 * items.len )
  for i, item in items:
    tmp[i*2] = item.dim.cint
    tmp[i*2 + 1] = item.id
  return tmp


proc getOutDimTags(outDimTags:ptr cint, outDimTagsN:uint):seq[DimTag] =
  var arr = cast[ptr UncheckedArray[cint]](outDimTags)
  let n = (outDimTagsN.int / 2).int
  var t = newSeq[DimTag](n)
  for i in 0..<n:
    t[i] = DimTag(dim:arr[i*2], id:arr[i*2+1])
  return t


proc getOutDimTagsMap(outDimTagsMap:ptr ptr cint,outDimTagsMapN:ptr uint, outDimTagsMapNN:uint):seq[seq[DimTag]] =
  ##[
  This is a helper function to obtain the children associated to each parent.
  ]##
  
  let arrMapN = cast[ptr UncheckedArray[uint]](outDimTagsMapN)      # Longitudes de las listas
  var arrMapPtr = cast[ptr UncheckedArray[ptr cint]](outDimTagsMap) # Array con los punteros a las parejas 
  var myMap:seq[seq[DimTag]]
  for i in 0..<outDimTagsMapNN:   # Iteramos en la lista principal.
    let m = (arrMapN[i].int / 2).int  
    #echo "Lista #", i
    #echo "   Contiene: ",m, " elementos"
    var mm = cast[ptr UncheckedArray[cint]](arrMapPtr[i])    # Puntero a cada lista
    var lista:seq[DimTag] # Parejas
    for j in 0..<m:
      let tmp = DimTag(dim:mm[j*2], id:mm[j*2+1])
      #echo "i:",i, " j:", j, " --> ", tmp
      lista &= tmp
    myMap &= lista
  return myMap


#----

proc addPoint*(p:Point; meshSize:float = 0.0; tag:int = -1):PointTag =
  ##[
  Add a geometrical point in the OpenCASCADE CAD representation, at
  coordinates (x', y', z'). If meshSize' is > 0, add a meshing constraint
  at that point. If tag' is positive, set the tag explicitly; otherwise a
  new tag is selected automatically. Return the tag of the point. (Note that
  the point will be added in the current model only after synchronize' is
  called. This behavior holds for all the entities added in the occ module.)
  ]##
  var ierr:cint  
  let t = gmshModelOccAddPoint(p.x.cdouble, p.y.cdouble, p.z.cdouble, meshSize.cdouble, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new point")  
  return t.PointTag

proc line*(startTag, endTag:PointTag; tag:int = -1):CurveTag =
  ##[
  Add a straight line segment between the two points with tags startTag' and
  endTag'. If tag' is positive, set the tag explicitly; otherwise a new tag
  is selected automatically. Return the tag of the line.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddLine(startTag.cint, endTag.cint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new line")  
  return t.CurveTag


proc addCircleArc*(startTag, centerTag, endTag:PointTag; tag:int = -1):CurveTag =
  ##[
  Add a circle arc between the two points with tags startTag' and endTag',
  with center centerTag'. If tag' is positive, set the tag explicitly;
  otherwise a new tag is selected automatically. Return the tag of the circle
  arc.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddCircleArc(startTag.cint, centerTag.cint, endTag.cint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new circle arc")  
  return t.CurveTag

proc addCircle*(p:Point, r:float; tag:int = -1;angle1:float = 0.0; angle2:float = 2.0 * PI ):CurveTag =
  ##[
  Add a circle of center (x', y', z') and radius r'. If tag' is
  positive, set the tag explicitly; otherwise a new tag is selected
  automatically. If angle1' and angle2' are specified, create a circle arc
  between the two angles. Return the tag of the circle.
  ]##
  var ierr:cint
  var t:cint
  t = gmshModelOccAddCircle( p.x.cdouble, p.y.cdouble, p.z.cdouble, r.cdouble, tag.cint,  
                             angle1.cdouble, angle2.cdouble, ierr.unsafeAddr)

  assert( ierr == 0, "error while adding a new circle arc")  
  return t.CurveTag


proc addEllipseArc*(startTag, centerTag, majorTag, endTag:PointTag; tag:int = -1):CurveTag =
  ##[
  Add an ellipse arc between the two points startTag' and endTag', with
  center centerTag' and major axis point majorTag'. If tag' is positive,
  set the tag explicitly; otherwise a new tag is selected automatically.
  Return the tag of the ellipse arc. Note that OpenCASCADE does not allow
  creating ellipse arcs with the major radius smaller than the minor radius.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddEllipseArc(startTag.cint, centerTag.cint, majorTag.cint, endTag.cint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new ellipse arc")  
  return t.CurveTag


proc addEllipse*(p:Point, r1,r2:float; tag:int = -1;angle1:float = 0.0; angle2:float = 2.0 * PI ):CurveTag =
  ##[
  Add an ellipse of center (x', y', z') and radii r1' and r2' along the
  x- and y-axes respectively. If tag' is positive, set the tag explicitly;
  otherwise a new tag is selected automatically. If angle1' and angle2' are
  specified, create an ellipse arc between the two angles. Return the tag of
  the ellipse. Note that OpenCASCADE does not allow creating ellipses with
  the major radius (along the x-axis) smaller than or equal to the minor
  radius (along the y-axis): rotate the shape or use addCircle' in such
  cases.
  ]##
  var ierr:cint
  var t:cint
  t = gmshModelOccAddEllipse( p.x.cdouble, p.y.cdouble, p.z.cdouble, r1.cdouble, r2.cdouble, tag.cint,  
                              angle1.cdouble, angle2.cdouble, ierr.unsafeAddr)

  assert( ierr == 0, "error while adding a new circle arc")  
  return t.CurveTag


proc addSpline( pointTags:seq[PointTag]; tag:int = -1 ):CurveTag =
  ##[
  Add a spline (C2 b-spline) curve going through the points pointTags'. If
  tag' is positive, set the tag explicitly; otherwise a new tag is selected
  automatically. Create a periodic curve if the first and last points are the
  same. Return the tag of the spline curve.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddSpline( cast[ptr cint](pointTags[0].unsafeAddr), 
                                 pointTags.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")  
  return t.CurveTag  


proc addBSpline( pointTags:seq[PointTag], degree:int ; tag:int = -1; 
                 weights:seq[float] = @[]; 
                 knots:seq[float] = @[];
                 multiplicities:seq[int] = @[] ):CurveTag =
  ##[
  Add a b-spline curve of degree degree' with pointTags' control points. 
  
  If `weights`, `knots` or `multiplicities` are not provided, default parameters
  are computed automatically. If tag' is positive, set the tag explicitly;
  otherwise a new tag is selected automatically. Create a periodic curve if
  the first and last points are the same. Return the tag of the b-spline
  curve.
  ]##
  var ierr:cint
  #let weightsPtr = if weights.len > 0:  else: weights.unsafeAddr
  #let knotsPtr = if knots.len > 0:  else: knots.unsafeAddr
  #let multiplicitiesPtr = if multiplicities.len > 0: multiplicities[0].unsafeAddr else: multiplicities.unsafeAddr    
  let t = gmshModelOccAddBSpline( cast[ptr cint](pointTags[0].unsafeAddr), pointTags.len.uint, 
                 tag.cint, degree.cint,
                 cast[ptr cdouble](weights[0].unsafeAddr), weights.len.uint, 
                 cast[ptr cdouble](knots[0].unsafeAddr), knots.len.uint,
                 cast[ptr cint](pointTags[0].unsafeAddr), multiplicities.len.uint,                 
                  ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new b-spline")  
  return t.CurveTag 


proc addBezier( pointTags:seq[PointTag]; tag:int = -1 ):CurveTag =
  ##[
  Add a Bezier curve with pointTags' control points. If tag' is positive,
  set the tag explicitly; otherwise a new tag is selected automatically.
  Return the tag of the Bezier curve.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddBezier( cast[ptr cint](pointTags[0].unsafeAddr), 
                                 pointTags.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")  
  return t.CurveTag 


# TODO: CurveTag or WireTag???
proc addWire( curveTags:seq[CurveTag]; tag:int = -1;checkClosed:bool = true ):CurveTag =
  ##[
  Add a wire (open or closed) formed by the curves curveTags'. Note that an
  OpenCASCADE wire can be made of curves that share geometrically identical
  (but topologically different) points. If tag' is positive, set the tag
  explicitly; otherwise a new tag is selected automatically. Return the tag
  of the wire.
  ]##
  var ierr:cint  
  let check:cint = if checkClosed: 1 else: 0
  let t = gmshModelOccAddWire( cast[ptr cint](curveTags[0].unsafeAddr), 
                                 curveTags.len.uint, tag.cint, check, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new wire")  
  return t.CurveTag 


proc addCurveLoop( curveTags:seq[CurveTag]; tag:int = -1 ):CurveTag =
  ##[
  Add a curve loop (a closed wire) formed by the curves curveTags'.
  curveTags' should contain tags of curves forming a closed loop. Note that
  an OpenCASCADE curve loop can be made of curves that share geometrically
  identical (but topologically different) points. If tag' is positive, set
  the tag explicitly; otherwise a new tag is selected automatically. Return
  the tag of the curve loop.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddCurveLoop( cast[ptr cint](curveTags[0].unsafeAddr), 
                                    curveTags.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new curve loop")  
  return t.CurveTag 


proc addRectangle*( p:Point, dx,dy:float; tag:int = -1; roundedRadius:float = -1.0 ):CurveTag =
  ##[
  Add a rectangle with lower left corner at (x', y', z') and upper right
  corner at (x' + dx', y' + dy', z'). If tag' is positive, set the tag
  explicitly; otherwise a new tag is selected automatically. Round the
  corners if roundedRadius' is nonzero. Return the tag of the rectangle.
  ]##
  var ierr:cint
  let t = gmshModelOccAddRectangle( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                                    dx.cdouble, dy.cdouble, 
                                    tag.cint, roundedRadius.cdouble, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new rectangle")  
  return t.CurveTag


proc addDisk*( p:Point, rx, ry:float; tag:int = -1 ):CurveTag =
  ##[
  Add a disk with center (xc', yc', zc') and radius rx' along the x-axis
  and ry' along the y-axis. If tag' is positive, set the tag explicitly;
  otherwise a new tag is selected automatically. Return the tag of the disk.
  ]##
  var ierr:cint
  let t = gmshModelOccAddDisk( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                               rx.cdouble, ry.cdouble, 
                               tag.cint,  ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new rectangle")  
  return t.CurveTag


proc addPlaneSurface*( wireTags:seq[WireTag]; tag:int = -1 ):SurfaceTag =
  ##[
  Add a plane surface defined by one or more curve loops (or closed wires)
  wireTags'. The first curve loop defines the exterior contour; additional
  curve loop define holes. If tag' is positive, set the tag explicitly;
  otherwise a new tag is selected automatically. Return the tag of the
  surface.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddPlaneSurface( cast[ptr cint](wireTags[0].unsafeAddr), 
                                       wireTags.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.SurfaceTag 


proc addPlaneSurface*( wire:WireTag, points:seq[PointTag]; tag:int = -1 ):SurfaceTag =
  ##[
  Add a surface filling the curve loops in wireTags'. If tag' is positive,
  set the tag explicitly; otherwise a new tag is selected automatically.
  Return the tag of the surface. If pointTags' are provided, force the
  surface to pass through the given points.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddSurfaceFilling( wire.cint, tag.cint, 
                cast[ptr cint](points[0].unsafeAddr), points.len.uint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.SurfaceTag 


proc addPlaneSurfaceLoop*( surfaceTags:seq[SurfaceTag]; tag:int = -1; sewing:bool = false ):ShellTag =
  ##[
  Add a surface loop (a closed shell) formed by surfaceTags'.  If tag' is
  positive, set the tag explicitly; otherwise a new tag is selected
  automatically. Return the tag of the surface loop. Setting sewing' allows
  to build a shell made of surfaces that share geometrically identical (but
  topologically different) curves.
  ]##
  var ierr:cint  
  let sew:cint = if sewing: 1 else: 0
  let t = gmshModelOccAddSurfaceLoop( cast[ptr cint](surfaceTags[0].unsafeAddr), 
                                       surfaceTags.len.uint, tag.cint, sew, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.ShellTag 


proc addVolume*(shells:seq[ShellTag]; tag:int = -1):VolumeTag =
  ##[
  Add a volume (a region) defined by one or more surface loops shellTags'.
  The first surface loop defines the exterior boundary; additional surface
  loop define holes. If tag' is positive, set the tag explicitly; otherwise
  a new tag is selected automatically. Return the tag of the volume.
  ]##
  var ierr:cint
  let t = gmshModelOccAddVolume( cast[ptr cint](shells[0].unsafeAddr), 
                                 shells.len.uint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.VolumeTag     


proc sphere*( p:Point, radius:float; tag:int = -1; 
                 angle1:float = PI / -2.0;
                 angle2:float = PI / 2.0;
                 angle3:float = 2.0 * PI ):DimTag =
  ##[
  Add a sphere of center (xc', yc', zc') and radius r'. The optional
  angle1' and angle2' arguments define the polar angle opening (from -Pi/2
  to Pi/2). The optional angle3' argument defines the azimuthal opening
  (from 0 to 2Pi). If tag' is positive, set the tag explicitly; otherwise a
  new tag is selected automatically. 
  Return the tag of the sphere.
  ]##
  var ierr:cint   
  let t = gmshModelOccAddSphere( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                                 radius.cdouble, tag.cint,
                                 angle1.cdouble, angle2.cdouble, angle3.cdouble,
                                 ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  echo repr t
  return DimTag(dim:3, id:t)   


proc box*( p:Point; dx,dy,dz:float; tag:int = -1 ):DimTag =
  ##[
  Add a parallelepipedic box defined by a point (x', y', z') and the
  extents along the x-, y- and z-axes. If tag' is positive, set the tag
  explicitly; otherwise a new tag is selected automatically. Return the tag
  of the box.
  ]##
  var ierr:cint 
  let t = gmshModelOccAddBox( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                              dx.cdouble, dy.cdouble, dz.cdouble,
                              tag.cint, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return DimTag(dim:3, id: t)


proc addCylinder*( p:Point; dx, dy, dz, radius:float; tag:int = -1; 
                   angle:float = 2.0 * PI ):VolumeTag =
  ##[
  Add a cylinder, defined by the center (x', y', z') of its first circular
  face, the 3 components (dx', dy', dz') of the vector defining its axis
  and its radius r'. The optional angle' argument defines the angular
  opening (from 0 to 2Pi). If tag' is positive, set the tag explicitly;
  otherwise a new tag is selected automatically. Return the tag of the
  cylinder.
  ]##
  var ierr:cint
  let t = gmshModelOccAddCylinder( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                dx.cdouble, dy.cdouble, dz.cdouble, radius.cdouble,
                tag.cint,
                angle.cdouble,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.VolumeTag 


proc addCone*( p:Point; dx, dy, dz, r1, r2:float; tag:int = -1; 
                   angle:float = 2.0 * PI  ):VolumeTag =
  ##[
  Add a cone, defined by the center (x', y', z') of its first circular
  face, the 3 components of the vector (dx', dy', dz') defining its axis
  and the two radii r1' and r2' of the faces (these radii can be zero). If
  tag' is positive, set the tag explicitly; otherwise a new tag is selected
  automatically. angle' defines the optional angular opening (from 0 to
  2Pi). Return the tag of the cone.
  ]##
  var ierr:cint
  let t = gmshModelOccAddCone( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                dx.cdouble, dy.cdouble, dz.cdouble, r1.cdouble, r2.cdouble,
                tag.cint,
                angle.cdouble,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.VolumeTag 


proc addWedge*( p:Point; dx, dy, dz:float; tag:int = -1; 
                   ltx:float = 0.0 ):VolumeTag =
  ##[
  Add a right angular wedge, defined by the right-angle point (x', y', z')
  and the 3 extends along the x-, y- and z-axes (dx', dy', dz'). If tag'
  is positive, set the tag explicitly; otherwise a new tag is selected
  automatically. The optional argument ltx' defines the top extent along the
  x-axis. Return the tag of the wedge.
  ]##
  var ierr:cint

  let t = gmshModelOccAddWedge( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                dx.cdouble, dy.cdouble, dz.cdouble, 
                tag.cint,
                ltx.cdouble,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.VolumeTag 


proc addTorus*( p:Point; r1, r2:float; tag:int = -1; 
                angle:float = 2.0 * PI ):VolumeTag =
  ##[
  Add a torus, defined by its center (x', y', z') and its 2 radii r' and
  r2'. If tag' is positive, set the tag explicitly; otherwise a new tag is
  selected automatically. The optional argument angle' defines the angular
  opening (from 0 to 2Pi). Return the tag of the wedge.
  ]##
  var ierr:cint
  let t = gmshModelOccAddTorus( p.x.cdouble, p.y.cdouble, p.z.cdouble,
                r1.cdouble, r2.cdouble,
                tag.cint,
                angle.cdouble,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return t.VolumeTag 


proc addThruSections*( wires:seq[WireTag]; tag:int = -1; 
            makeSolid:bool = true; 
            makeRuled:bool = false;
            maxDegree:int = -1 ):seq[int] =
  ##[
  Add a volume (if the optional argument makeSolid' is set) or surfaces
  defined through the open or closed wires wireTags'. 
  
  If tag' is positive, set the tag explicitly; otherwise a new tag is selected automatically. 
  
  The new entities are returned in outDimTags'. 
  
  If the optional argument makeRuled' is set, the surfaces created on the boundary are forced to be
  ruled surfaces. 
  If maxDegree' is positive, set the maximal degree of
  resulting surface.
  ]##
  var ierr:cint
  var outDimTagsPtr:ptr cint
  var outDimTagsN:uint
  let solid:cint = if makeSolid: 1  else: 0
  let ruled:cint = if makeRuled: 1 else: 0
  gmshModelOccAddThruSections( cast[ptr cint](wires[0].unsafeAddr),
                wires.len.uint, 
                outDimTagsPtr.unsafeAddr, outDimTagsN.unsafeAddr,
                tag.cint,
                solid, ruled, maxDegree.cint,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTagsPtr)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


#proc gmshModelOccAddThickSolid*(volumeTag: cint; excludeSurfaceTags: ptr cint;
#                               excludeSurfaceTags_n: uint; offset: cdouble;
#                               outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
#                               tag: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
proc addThickSolid*( volume:VolumeTag, offset:float;excludeSurfaceTags:seq[SurfaceTag] = @[];
            tag:int = -1 ):seq[int] =
  ##[
  Add a hollowed volume built from an initial volume volumeTag' and a set of
  faces from this volume excludeSurfaceTags', which are to be removed. The
  remaining faces of the volume become the walls of the hollowed solid, with
  thickness offset'. 
  If tag' is positive, set the tag explicitly; otherwise
  a new tag is selected automatically.
  ]##
  var ierr:cint
  var outDimTagsPtr:ptr cint
  var outDimTagsN:uint

  gmshModelOccAddThickSolid(  volume.cint,
                cast[ptr cint](excludeSurfaceTags[0].unsafeAddr), excludeSurfaceTags.len.uint, 
                offset.cdouble, 
                outDimTagsPtr.unsafeAddr, outDimTagsN.unsafeAddr,
                tag.cint,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTagsN)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc extrude*( dimTags:seq[int], dx, dy,dz:float; 
               numElements:seq[int] = @[];
               heights:seq[float] = @[]; recombine:bool = false ):seq[int] =
  ##[
  Extrude the model entities dimTags' by translation along (dx', dy',
  dz'). 
  
  If numElements' is not  empty, also extrude the mesh: the entries in numElements' give the number
  of elements in each layer. 
  
  If height' is not empty, it provides the
  (cumulative) height of the different layers, normalized to 1.

  Return extruded entities in outDimTags'. 
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var numElementsPtr = if numElements.len == 0: nil else:  numElements[0].unsafeAddr
  var heightsPtr = if heights.len == 0: nil else:  heights[0].unsafeAddr
  var recomb:cint = if recombine: 1 else: 0
  gmshModelOccExtrude( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
            dx.cdouble, dy.cdouble, dz.cdouble,
            outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
            cast[ptr cint](numElementsPtr), numElements.len.uint, 
            cast[ptr cdouble](heightsPtr), heights.len.uint,
            recomb,
            ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc revolve*( dimTags:seq[int], angle, x, y, z, ax, ay, az:float; 
               numElements:seq[int] = @[];
               heights:seq[float] = @[]; recombine:bool = false ):seq[int] =
  ##[
  Extrude the model entities dimTags' by rotation of angle' radians around
  the axis of revolution defined by the point (x', y', z') and the
  direction (ax', ay', az'). 
  
  Return extruded entities in outDimTags'. 
  
  If numElements' is not empty, also extrude the mesh: the entries in
  numElements' give the number of elements in each layer. 
  
  If height' is not
  empty, it provides the (cumulative) height of the different layers,
  normalized to 1. When the mesh is extruded the angle should be strictly
  smaller than 2Pi.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var numElementsPtr = if numElements.len == 0: nil else:  numElements[0].unsafeAddr
  var heightsPtr = if heights.len == 0: nil else:  heights[0].unsafeAddr
  var recomb:cint = if recombine: 1 else: 0
  gmshModelOccRevolve( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
            x.cdouble, y.cdouble, z.cdouble, ax.cdouble, ay.cdouble, az.cdouble, angle.cdouble,
            outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
            cast[ptr cint](numElementsPtr), numElements.len.uint, 
            cast[ptr cdouble](heightsPtr), heights.len.uint, 
            recomb,
            ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc addPipe*( dimTags:seq[int], wireTag:WireTag ):seq[int] =
  ##[
  Add a pipe by extruding the entities dimTags' along the wire wireTag'.
  Return the pipe in outDimTags'.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  gmshModelOccAddPipe( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
            wireTag.cint, 
            outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
            ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc fillet*( volumeTags:seq[int], curveTags:seq[int], radii:seq[float]; removeVolumne:bool = false ):seq[int] =
  ##[
  Fillet the volumes volumeTags' on the curves curveTags' with radii
  radii'. The radii' vector can either contain a single radius, as many
  radii as curveTags', or twice as many as curveTags' (in which case
  different radii are provided for the begin and end points of the curves).
  Return the filleted entities in outDimTags'. Remove the original volume if
  removeVolume' is set.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var remove:cint = if removeVolumne: 1 else: 0
  gmshModelOccFillet( cast[ptr cint](volumeTags[0].unsafeAddr), volumeTags.len.uint,
                      cast[ptr cint](curveTags[0].unsafeAddr), curveTags.len.uint, 
                      cast[ptr cdouble](radii[0].unsafeAddr), radii.len.uint,
                      outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                      remove, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc chamfer*( volumeTags:seq[int], curveTags:seq[int], surfaceTags:seq[int],
               distances:seq[float]; removeVolumne:bool = false ):seq[int] =
  ##[
  Chamfer the volumes volumeTags' on the curves curveTags' with distances
  distances' measured on surfaces surfaceTags'. The distances' vector can
  either contain a single distance, as many distances as curveTags' and
  surfaceTags', or twice as many as curveTags' and surfaceTags' (in which
  case the first in each pair is measured on the corresponding surface in
  surfaceTags', the other on the other adjacent surface). Return the
  chamfered entities in outDimTags'. Remove the original volume if
  removeVolume' is set.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var remove:cint = if removeVolumne: 1 else: 0
  gmshModelOccChamfer( cast[ptr cint](volumeTags[0].unsafeAddr), volumeTags.len.uint,
                       cast[ptr cint](curveTags[0].unsafeAddr), curveTags.len.uint, 
                       cast[ptr cint](surfaceTags[0].unsafeAddr), surfaceTags.len.uint,
                       cast[ptr cdouble](distances[0].unsafeAddr), distances.len.uint,                       
                       outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                       remove, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc fuse*( objectDimTags:seq[int], toolDimTags:seq[int]; tag:int = -1; removeObject:bool = false; removeTool:bool = false ):seq[int] =
  ##[
  Compute the boolean union (the fusion) of the entities objectDimTags' and
  toolDimTags'. 
  
  Return the resulting entities in outDimTags'. 
  
  If tag' is positive, try to set the tag explicitly (only valid if the boolean
  operation results in a single entity). 
  
  Remove the object if removeObject' is set. Remove the tool if removeTool' is set.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var outDimTagsMap:ptr ptr cint
  var outDimTagsMapN:ptr uint
  var outDimTagsMapNN:uint  

  var remObject:cint = if removeObject: 1 else: 0
  var remTool:cint = if removeTool: 1 else: 0  
  gmshModelOccFuse( cast[ptr cint](objectDimTags[0].unsafeAddr), objectDimTags.len.uint,
                    cast[ptr cint](toolDimTags[0].unsafeAddr), toolDimTags.len.uint,                   
                    outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                    outDimTagsMap.unsafeAddr, outDimTagsMapN.unsafeAddr, outDimTagsMapNN.unsafeAddr,
                    tag.cint,
                    remObject, remTool, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc intersect*( objectDimTags:seq[int], toolDimTags:seq[int]; 
                 tag:int = -1; removeObject, removeTool:bool = false ):seq[int] =
  ##[
  Compute the boolean intersection (the common parts) of the entities
  objectDimTags' and toolDimTags'. Return the resulting entities in
  outDimTags'. If tag' is positive, try to set the tag explicitly (only
  valid if the boolean operation results in a single entity). Remove the
  object if removeObject' is set. Remove the tool if removeTool' is set.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var outDimTagsMap:ptr ptr cint
  var outDimTagsMapN:ptr uint
  var outDimTagsMapNN:uint  

  var rObject:cint = if removeObject: 1 else: 0
  var rTool:cint = if removeTool: 1 else: 0  
  gmshModelOccIntersect( cast[ptr cint](objectDimTags[0].unsafeAddr), objectDimTags.len.uint,
                         cast[ptr cint](toolDimTags[0].unsafeAddr), toolDimTags.len.uint,                   
                         outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                         outDimTagsMap.unsafeAddr, outDimTagsMapN.unsafeAddr, outDimTagsMapNN.unsafeAddr,
                         tag.cint, rObject, rTool, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t





proc cut*( objectDimTags:seq[DimTag], toolDimTags:seq[DimTag]; 
           tag:int = -1; removeObject, removeTool:bool = true ):tuple[outDimTags:seq[DimTag],outDimTagsMap:seq[seq[DimTag]]] =
  ##[
  Compute the boolean difference between the entities objectDimTags' and
  toolDimTags'. 
  
  Return the resulting entities in outDimTags'. If tag' is
  positive, try to set the tag explicitly (only valid if the boolean
  operation results in a single entity). Remove the object if removeObject'
  is set. Remove the tool if removeTool' is set. By default they are set
  to true to remove the original entities.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var outDimTagsMap:ptr ptr cint
  var outDimTagsMapN:ptr uint
  var outDimTagsMapNN:uint  

  #echo objectDimTags
  let objects = flatten(objectDimTags)
  let tools = flatten(toolDimTags)
 
  gmshModelOccCut( cast[ptr cint](objects[0].unsafeAddr), objects.len.uint,
                   cast[ptr cint](tools[0].unsafeAddr), tools.len.uint,                   
                   outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                   outDimTagsMap.unsafeAddr, outDimTagsMapN.unsafeAddr, outDimTagsMapNN.unsafeAddr,
                   tag.cint, removeObject.cint, removeTool.cint, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 
  
  let t = getOutDimTags(outDimTags, outDimTagsN) 
  #[
  var arr = cast[ptr UncheckedArray[cint]](outDimTags)
  echo "outDimTagsMapNN: ", outDimTagsMapNN  
  #echo repr outDimTags
  let n = (outDimTagsN.int / 2).int
  var t = newSeq[DimTag](n)
  for i in 0..<n:
    t[i] = DimTag(dim:arr[i*2], id:arr[i*2+1])
  ]#
  #[
  let arrMapN = cast[ptr UncheckedArray[uint]](outDimTagsMapN)      # Longitudes de las listas
  var arrMapPtr = cast[ptr UncheckedArray[ptr cint]](outDimTagsMap) # Array con los punteros a las parejas 
  var myMap:seq[seq[DimTag]]
  for i in 0..<outDimTagsMapNN:   # Iteramos en la lista principal.
    echo "i: ", i
    var mm = cast[ptr UncheckedArray[cint]](arrMapPtr[i])    # Puntero a cada lista
    var lista:seq[DimTag] # Parejas
    for j in 0..<arrMapN[i]:
      let tmp = DimTag(dim:mm[j*2], id:mm[j*2+1])
      echo i, " ", j, ": ", tmp
      lista &= tmp
    myMap &= lista
  ]#
  let myMap = getOutDimTagsMap(outDimTagsMap, outDimTagsMapN, outDimTagsMapNN)
  
  return (t, myMap)

#[
function cut(objectDimTags, toolDimTags, tag = -1, removeObject = true, removeTool = true)

    tmp_api_outDimTags_ = unsafe_wrap(Array, api_outDimTags_[], api_outDimTags_n_[], own=true)
    outDimTags = [ (tmp_api_outDimTags_[i], tmp_api_outDimTags_[i+1]) for i in 1:2:length(tmp_api_outDimTags_) ]

    tmp_api_outDimTagsMap_ = unsafe_wrap(Array, api_outDimTagsMap_[], api_outDimTagsMap_nn_[], own=true)
    tmp_api_outDimTagsMap_n_ = unsafe_wrap(Array, api_outDimTagsMap_n_[], api_outDimTagsMap_nn_[], own=true)
    outDimTagsMap = Vector{Tuple{Cint,Cint}}[]
    resize!(outDimTagsMap, api_outDimTagsMap_nn_[])
    
    for i in 1:api_outDimTagsMap_nn_[]
        tmp = unsafe_wrap(Array, tmp_api_outDimTagsMap_[i], tmp_api_outDimTagsMap_n_[i], own=true)
        outDimTagsMap[i] = [(tmp[i], tmp[i+1]) for i in 1:2:length(tmp)]
    end
    return outDimTags, outDimTagsMap
end

]#
proc fragment*( objectDimTags:seq[DimTag], toolDimTags:seq[DimTag]; 
                tag:int = -1; removeObject, removeTool:bool = true ):tuple[outDimTags:seq[DimTag],outDimTagsMap:seq[seq[DimTag]]] =
  ##[
  Compute the boolean fragments (general fuse) of the entities
  objectDimTags' and toolDimTags'. Return the resulting entities in
  outDimTags'. If tag' is positive, try to set the tag explicitly (only
  valid if the boolean operation results in a single entity). Remove the
  object if removeObject' is set. Remove the tool if removeTool' is set.
  ]##
  let objects = flatten(objectDimTags)
  let tools = flatten(toolDimTags)

  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  var outDimTagsMap:ptr ptr cint
  var outDimTagsMapN:ptr uint
  var outDimTagsMapNN:uint  

  gmshModelOccFragment( cast[ptr cint](objects[0].unsafeAddr), objects.len.uint,
                        cast[ptr cint](tools[0].unsafeAddr), tools.len.uint,                   
                        outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                        outDimTagsMap.unsafeAddr, outDimTagsMapN.unsafeAddr, outDimTagsMapNN.unsafeAddr,
                        tag.cint, removeObject.cint, removeTool.cint, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  let t = getOutDimTags(outDimTags, outDimTagsN) 

  let myMap = getOutDimTagsMap(outDimTagsMap, outDimTagsMapN, outDimTagsMapNN)
  return  (t, myMap)
#[
function cut(objectDimTags, toolDimTags, tag = -1, removeObject = true, removeTool = true)
    api_objectDimTags_ = collect(Cint, Iterators.flatten(objectDimTags))
    api_objectDimTags_n_ = length(api_objectDimTags_)
    api_toolDimTags_ = collect(Cint, Iterators.flatten(toolDimTags))
    api_toolDimTags_n_ = length(api_toolDimTags_)
    api_outDimTags_ = Ref{Ptr{Cint}}()
    api_outDimTags_n_ = Ref{Csize_t}()
    api_outDimTagsMap_ = Ref{Ptr{Ptr{Cint}}}()
    api_outDimTagsMap_n_ = Ref{Ptr{Csize_t}}()
    api_outDimTagsMap_nn_ = Ref{Csize_t}()
    ierr = Ref{Cint}()
    ccall((:gmshModelOccCut, gmsh.lib), Cvoid,
          (Ptr{Cint}, Csize_t, Ptr{Cint}, Csize_t, Ptr{Ptr{Cint}}, Ptr{Csize_t}, Ptr{Ptr{Ptr{Cint}}}, Ptr{Ptr{Csize_t}}, Ptr{Csize_t}, Cint, Cint, Cint, Ptr{Cint}),
          api_objectDimTags_, api_objectDimTags_n_, api_toolDimTags_, api_toolDimTags_n_, api_outDimTags_, api_outDimTags_n_, api_outDimTagsMap_, api_outDimTagsMap_n_, api_outDimTagsMap_nn_, tag, removeObject, removeTool, ierr)
    ierr[] != 0 && error("gmshModelOccCut returned non-zero error code: $(ierr[])")
    tmp_api_outDimTags_ = unsafe_wrap(Array, api_outDimTags_[], api_outDimTags_n_[], own=true)
    outDimTags = [ (tmp_api_outDimTags_[i], tmp_api_outDimTags_[i+1]) for i in 1:2:length(tmp_api_outDimTags_) ]
    tmp_api_outDimTagsMap_ = unsafe_wrap(Array, api_outDimTagsMap_[], api_outDimTagsMap_nn_[], own=true)
    tmp_api_outDimTagsMap_n_ = unsafe_wrap(Array, api_outDimTagsMap_n_[], api_outDimTagsMap_nn_[], own=true)
    outDimTagsMap = Vector{Tuple{Cint,Cint}}[]
    resize!(outDimTagsMap, api_outDimTagsMap_nn_[])
    for i in 1:api_outDimTagsMap_nn_[]
        tmp = unsafe_wrap(Array, tmp_api_outDimTagsMap_[i], tmp_api_outDimTagsMap_n_[i], own=true)
        outDimTagsMap[i] = [(tmp[i], tmp[i+1]) for i in 1:2:length(tmp)]
    end
    return outDimTags, outDimTagsMap
end

]#

proc translate*( dimTags:seq[int], dx,dy,dz:float ) =
  ##[
  Translate the model entities dimTags' along (dx', dy', dz').
  ]##
  var ierr:cint  

  gmshModelOccTranslate( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
                        dx.cdouble, dy.cdouble, dz.cdouble, 
                         ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  


proc rotate*( dimTags:seq[int], p:Point, angle, ax, ay, az:float ) =
  ##[
  Rotate the model entities dimTags' of angle' radians around the axis of
  revolution defined by the point (x', y', z') and the direction (ax',
  ay', az').
  ]##
  var ierr:cint  

  gmshModelOccRotate( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
                      p.x.cdouble, p.y.cdouble, p.z.cdouble, 
                      ax.cdouble, ay.cdouble, az.cdouble, 
                      angle.cdouble, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 


proc dilate*( dimTags:seq[int], p:Point, a, b, c:float ) =
  ##[
  Scale the model entities dimTag' by factors a', b' and c' along the
  three coordinate axes; use (x', y', z') as the center of the homothetic
  transformation.
  ]##
  var ierr:cint  
  gmshModelOccDilate( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
                      p.x.cdouble, p.y.cdouble, p.z.cdouble, 
                      a.cdouble, b.cdouble, c.cdouble, 
                      ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 


proc mirror*( dimTags:seq[int], a, b, c, d:float ) =
  ##[
  Apply a symmetry transformation to the model entities dimTag', with
  respect to the plane of equation a' x + b' y + c' z + d' = 0.
  ]##
  var ierr:cint  
  gmshModelOccMirror( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
                      a.cdouble, b.cdouble, c.cdouble, d.cdouble,
                      ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 


proc symmetrize*( dimTags:seq[int], a, b, c, d:float ) =
  ##[
  Apply a symmetry transformation to the model entities dimTag', with
  respect to the plane of equation a' x + b' y + c' z + d' = 0.
  (This is a synonym for mirror', which will be deprecated in a future
  release.)
  ]##
  var ierr:cint  
  gmshModelOccSymmetrize( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
                          a.cdouble, b.cdouble, c.cdouble, d.cdouble,
                          ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 


proc transform*( dimTags:seq[int], a:seq[float] ) =
  ##[
  Apply a general affine transformation matrix a' (16 entries of a 4x4
  matrix, by row; only the 12 first can be provided for convenience) to the
  model entities dimTag'.
  ]##
  var ierr:cint  
  gmshModelOccAffineTransform( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
                               cast[ptr cdouble](a[0].unsafeAddr), a.len.uint,
                               ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 


proc copy*( dimTags:seq[int] ):seq[int] =
  ##[
  Copy the entities dimTags'; the new entities are returned in outDimTags'.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  gmshModelOccCopy( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,                  
                    outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                    ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc remove*( dimTags:seq[int]; recursive:bool = false ) =
  ##[
  Remove the entities dimTags'. If recursive' is true, remove all the
  entities on their boundaries, down to dimension 0.
  ]##
  var ierr:cint  
  var recur:cint = if recursive: 1 else: 0
  gmshModelOccRemove( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,                  
                      recur, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  


proc removeAllDuplicates*( dimTags:seq[int]; recursive:bool = false ) =
  ##[
  Remove all duplicate entities (different entities at the same geometrical
  location) after intersecting (using boolean fragments) all highest
  dimensional entities.
  ]##
  var ierr:cint  
  gmshModelOccRemoveAllDuplicates( ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  


proc healShapes*( dimTags:seq[int] = @[]; 
                  tolerance:float = 1e-8;
                  fixDegenerated:bool = true;
                  fixSmallEdges:bool = true; 
                  fixSmallFaces:bool = true;  
                  sewFaces:bool = true;                                                      
                  makeSolids:bool = true ):seq[int] =
  ##[
  Apply various healing procedures to the entities dimTags' (or to all the
  entities in the model if dimTags' is empty). 
  
  Return the healed entities in
  outDimTags'. Available healing options are listed in the Gmsh reference
  manual.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  let degenerated:cint = if fixDegenerated: 1 else: 0
  let smallEdges :cint = if fixSmallEdges : 1 else: 0
  let smallFaces :cint = if fixSmallFaces : 1 else: 0
  let sew        :cint = if sewFaces      : 1 else: 0
  let solids     :cint = if makeSolids    : 1 else: 0
  gmshModelOccHealShapes( outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                          cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.uint,
                          tolerance.cdouble, degenerated, smallEdges, smallFaces, sew, solids,
                          ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  var arr = cast[ptr UncheckedArray[int]](outDimTagsN)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t
                           

proc importShapes(filename:string; format:string = ""; highestDimOnly:bool = true ):seq[int] =
  ##[
  Import BREP, STEP or IGES shapes from the file fileName'. The imported
  entities are returned in outDimTags'. 
  
  If the optional argument
  highestDimOnly' is set, only import the highest dimensional entities in
  the file. 
  
  The optional argument format' can be used to force the format of
  the file (currently "brep", "step" or "iges").
  ]##
  var ierr:cint
  var outDimTags:ptr cint
  var outDimTagsN:uint
  var highest:cint = if highestDimOnly: 1 else: 0
  gmshModelOccImportShapes( filename.cstring, 
                   outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                   highest, format.cstring, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc importShapesNativePointer(shape:pointer, highestDimOnly:int):seq[int] =
  ##[
  Imports an OpenCASCADE shape' by providing a pointer to a native
  OpenCASCADE TopoDS_Shape' object (passed as a pointer to void). The
  imported entities are returned in outDimTags'. If the optional argument
  highestDimOnly' is set, only import the highest dimensional entities in
  shape'. For C and C++ only. Warning: this function is unsafe, as providing
  an invalid pointer will lead to undefined behavior.
  ]##
  var ierr:cint
  var outDimTags:ptr cint
  var outDimTagsN:uint
  gmshModelOccImportShapesNativePointer( shape, 
                   outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                   highestDimOnly.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  var arr = cast[ptr UncheckedArray[int]](outDimTags)
  var t = newSeq[int](outDimTagsN)
  for i in 0..<outDimTagsN:
    t[i] = arr[i]
  return t


proc getEntities*( dim:int = -1 ):seq[int] =
  ##[
  Get all the OpenCASCADE entities. If dim' is >= 0, return only the
  entities of the specified dimension (e.g. points if dim' == 0). The
  entities are returned as a vector of (dim, tag) integer pairs.
  ]##
  var ierr:cint
  var tags:ptr cint
  var tagsN:uint
  gmshModelOccGetEntities( tags.unsafeAddr, tagsN.unsafeAddr, dim.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  var arr = cast[ptr UncheckedArray[int]](tags)
  var t = newSeq[int](tagsN)
  for i in 0..<tagsN:
    t[i] = arr[i]
  return t


proc getEntitiesInBoundingBox*( bbMin, bbMax:Point; dim:int = -1):seq[int] =
  ##[
  Get the OpenCASCADE entities in the bounding box defined by the two points
  (xmin', ymin', zmin') and (xmax', ymax', zmax'). If dim' is >= 0,
  return only the entities of the specified dimension (e.g. points if dim'
  == 0).
  ]##
  var ierr:cint
  var tags:ptr cint
  var tagsN:uint
  gmshModelOccGetEntitiesInBoundingBox( bbMin.x.cdouble, bbMin.y.cdouble, bbMin.z.cdouble,
                  bbMax.x.cdouble, bbMax.y.cdouble, bbMax.z.cdouble,  
                  tags.unsafeAddr, tagsN.unsafeAddr, dim.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  var arr = cast[ptr UncheckedArray[int]](tags)
  var t = newSeq[int](tagsN)
  for i in 0..<tagsN:
    t[i] = arr[i]
  return t


proc getBoundingBox*( dim:int, tag:int):tuple[bbMin:Point, bbMax:Point] =
  ##[
  Get the bounding box (xmin', ymin', zmin'), (xmax', ymax', zmax') of
  the OpenCASCADE entity of dimension dim' and tag tag'.
  ]##
  var ierr:cint  
  var xmin,ymin,zmin,xmax,ymax,zmax:cdouble
  gmshModelOccGetBoundingBox(dim.cint, tag.cint, 
                  xmin.unsafeAddr, ymin.unsafeAddr, zmin.unsafeAddr,
                  xmax.unsafeAddr, ymax.unsafeAddr, zmax.unsafeAddr,                  
                  ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")

  return ( bbMin: (x:xmin.float, y:ymin.float, z:zmin.float), 
           bbMax: (x:xmax.float, y:ymax.float, z:zmax.float) )


proc getMass*( dim:int, tag:int):float =
  ##[
  Get the mass of the OpenCASCADE entity of dimension dim' and tag tag'.
  ]##
  var ierr:cint  
  var mass:cdouble
  gmshModelOccGetMass(dim.cint, tag.cint, mass.unsafeAddr, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  return mass.float


proc getCenterOfMass*( dim:int, tag:int):Point =
  ##[
  Get the center of mass of the OpenCASCADE entity of dimension dim' and tag
  tag'.
  ]##
  var ierr:cint  
  var x,y,z:cdouble
  gmshModelOccGetCenterOfMass(dim.cint, tag.cint, x.unsafeAddr, y.unsafeAddr, z.unsafeAddr, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  return (x:x.float,y:y.float,z:z.float)


proc getMatrixOfInertia*(dim:int, tag:int):seq[float] =
  ##[
  Get the matrix of inertia (by row) of the OpenCASCADE entity of dimension
  dim' and tag tag'.
  ]##
  var ierr:cint  
  var matPtr:ptr cdouble
  var matN:uint
  gmshModelOccGetMatrixOfInertia(dim.cint, tag.cint, matPtr.unsafeAddr, matN.unsafeAddr, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  var arr = cast[ptr UncheckedArray[float]](matPtr)
  var mat = newSeq[float](matN)
  for i in 0..<matN:
    mat[i] = arr[i]
  return mat


proc getMaxTag*(dim:int):int =
  ##[
  Get the maximum tag of entities of dimension dim' in the OpenCASCADE CAD
  representation.
  ]##
  var ierr:cint  
  let tmp = gmshModelOccGetMaxTag(dim.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline") 
  return tmp.int


proc SetMaxTag*(dim:int, maxTag:int ) =
  ##[
  Set the maximum tag maxTag' for entities of dimension dim' in the
  OpenCASCADE CAD representation.
  ]##
  var ierr:cint  
  gmshModelOccSetMaxTag(dim.cint, maxTag.cint, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new spline")   


proc sync*() =
  ##[
  Synchronize the OpenCASCADE CAD representation with the current Gmsh model.
  This can be called at any time, but since it involves a non trivial amount
  of processing, the number of synchronization points should normally be
  minimized.
  ]##
  var ierr:cint  
  gmshModelOccSynchronize(ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new spline")  


proc meshSetSize*( dimTags:seq[DimTag], size:float) =
  ##[
  Set a mesh size constraint on the model entities dimTags'. Currently only
  entities of dimension 0 (points) are handled.
  ]##
  var ierr:cint  
  gmshModelOccMeshSetSize( cast[ptr cint](dimTags[0].unsafeAddr), 
                                 dimTags.len.uint, size.cdouble, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")  


