import ../wrapper/gmsh_wrapper
import math






#----

proc newPoint*(p:Point; meshSize:float = 0.0; tag:int = -1):seq[PointTag] =
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
  return @[t.PointTag]

proc newPoint*( points:seq[Point]; meshSize:float = 0.0):seq[PointTag] =
  var tmp:seq[PointTag]
  for point in points:
    tmp &= newPoint(point, meshSize)
  return tmp
  

proc newLine*(startTag, endTag:PointTag; tag:int = -1):seq[CurveTag] =
  ##[
  Add a straight line segment between the two points with tags startTag' and
  endTag'. If tag' is positive, set the tag explicitly; otherwise a new tag
  is selected automatically. Return the tag of the line.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddLine(startTag.cint, endTag.cint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new line")  
  return @[t.CurveTag]

proc newLine*( tags:seq[PointTag]; close:bool = false):seq[CurveTag] =
  var tmp = newSeq[CurveTag](tags.len-1)
  for i in 0..<tags.len-1:
    tmp[i] = newLine( tags[i], tags[i+1])[0]
  if close:
    tmp &= newLine( tags[tags.len-1], tags[0])
  return tmp


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

proc addCircle*( p:Point, r:float; tag:int = -1;
                 angle1:float = 0.0; angle2:float = 2.0 * PI ):CurveTag =
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


proc addSpline*( pointTags:seq[PointTag]; tag:int = -1 ):CurveTag =
  ##[
  Add a spline (C2 b-spline) curve going through the points pointTags'. If
  tag' is positive, set the tag explicitly; otherwise a new tag is selected
  automatically. Create a periodic curve if the first and last points are the
  same. Return the tag of the spline curve.
  ]##
  echo repr pointTags
  var ierr:cint  
  let t = gmshModelOccAddSpline( cast[ptr cint](pointTags[0].unsafeAddr), 
                                 pointTags.len.cuint, tag.cint, ierr.unsafeAddr)
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
  let t = gmshModelOccAddBSpline( cast[ptr cint](pointTags[0].unsafeAddr), pointTags.len.cuint, 
                 tag.cint, degree.cint,
                 cast[ptr cdouble](weights[0].unsafeAddr), weights.len.cuint, 
                 cast[ptr cdouble](knots[0].unsafeAddr), knots.len.cuint,
                 cast[ptr cint](pointTags[0].unsafeAddr), multiplicities.len.cuint,                 
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
                                 pointTags.len.cuint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")  
  return t.CurveTag 


# TODO: CurveTag or WireTag???
proc addWire*( curveTags:seq[CurveTag]; tag:int = -1;checkClosed:bool = false ):WireTag =
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
                                 curveTags.len.cuint, tag.cint, check, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new wire")  
  return t.WireTag 


proc newCurveLoop*( curveTags:seq[CurveTag]; tag:int = -1 ):seq[WireTag] =
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
                                    curveTags.len.cuint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new curve loop")  
  return @[t.WireTag]


proc addRectangle*( p:Point, dx,dy:float; tag:int = -1; 
                    roundedRadius:float = -1.0 ):CurveTag =
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


proc addDisk*( p:Point, rx, ry:float; tag:int = -1 ):SurfaceTag =
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
  return t.SurfaceTag


proc newPlaneSurface*( wireTags:seq[WireTag]; tag:int = -1 ):seq[SurfaceTag] =
  ##[
  Add a plane surface defined by one or more curve loops (or closed wires)
  wireTags'. The first curve loop defines the exterior contour; additional
  curve loop define holes. If tag' is positive, set the tag explicitly;
  otherwise a new tag is selected automatically. Return the tag of the
  surface.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddPlaneSurface( cast[ptr cint](wireTags[0].unsafeAddr), 
                                       wireTags.len.cuint, tag.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new plane surface")  
  return @[t.SurfaceTag]


proc addPlaneSurface*( wire:WireTag, points:seq[PointTag]; tag:int = -1 ):SurfaceTag =
  ##[
  Add a surface filling the curve loops in wireTags'. If tag' is positive,
  set the tag explicitly; otherwise a new tag is selected automatically.
  Return the tag of the surface. If pointTags' are provided, force the
  surface to pass through the given points.
  ]##
  var ierr:cint  
  let t = gmshModelOccAddSurfaceFilling( wire.cint, tag.cint, 
                cast[ptr cint](points[0].unsafeAddr), points.len.cuint, ierr.unsafeAddr)
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
                                       surfaceTags.len.cuint, tag.cint, sew, ierr.unsafeAddr)
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
                                 shells.len.cuint, tag.cint, ierr.unsafeAddr)
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
            maxDegree:int = -1 ):seq[DimTag] =
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
                wires.len.cuint, 
                outDimTagsPtr.unsafeAddr, outDimTagsN.unsafeAddr,
                tag.cint,
                solid, ruled, maxDegree.cint,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return getOutDimTags( outDimTagsPtr, outDimTagsN) 



#proc gmshModelOccAddThickSolid*(volumeTag: cint; excludeSurfaceTags: ptr cint;
#                               excludeSurfaceTags_n: cuint; offset: cdouble;
#                               outDimTags: ptr ptr cint; outDimTags_n: ptr cuint;
#                               tag: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
proc addThickSolid*( volume:VolumeTag, offset:float;excludeSurfaceTags:seq[SurfaceTag] = @[];
            tag:int = -1 ):seq[DimTag] =
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
                cast[ptr cint](excludeSurfaceTags[0].unsafeAddr), excludeSurfaceTags.len.cuint, 
                offset.cdouble, 
                outDimTagsPtr.unsafeAddr, outDimTagsN.unsafeAddr,
                tag.cint,
                ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return getOutDimTags( outDimTagsPtr, outDimTagsN) 


proc extrude*( dimTags:seq[int], dx, dy,dz:float; 
               numElements:seq[int] = @[];
               heights:seq[float] = @[]; recombine:bool = false ):seq[DimTag] =
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
  gmshModelOccExtrude( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.cuint,
            dx.cdouble, dy.cdouble, dz.cdouble,
            outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
            cast[ptr cint](numElementsPtr), numElements.len.cuint, 
            cast[ptr cdouble](heightsPtr), heights.len.cuint,
            recomb,
            ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return getOutDimTags( outDimTags, outDimTagsN) 


proc revolve*( dimTags:seq[int], angle, x, y, z, ax, ay, az:float; 
               numElements:seq[int] = @[];
               heights:seq[float] = @[]; recombine:bool = false ):seq[DimTag] =
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
  gmshModelOccRevolve( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.cuint,
            x.cdouble, y.cdouble, z.cdouble, ax.cdouble, ay.cdouble, az.cdouble, angle.cdouble,
            outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
            cast[ptr cint](numElementsPtr), numElements.len.cuint, 
            cast[ptr cdouble](heightsPtr), heights.len.cuint, 
            recomb,
            ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return getOutDimTags( outDimTags, outDimTagsN) 


proc addPipe*( dimTags:seq[DimTag], wireTag:WireTag ):seq[DimTag] =
  ##[
  Add a pipe by extruding the entities dimTags' along the wire wireTag'.
  Return the pipe in outDimTags'.
  ]##
  var ierr:cint  
  var outDimTags:ptr cint
  var outDimTagsN:uint
  var objects = flatten(dimTags)
  gmshModelOccAddPipe( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,
            wireTag.cint, 
            outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
            ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return getOutDimTags( outDimTags, outDimTagsN) 


proc fillet*( volumeTags:seq[cint], curveTags:seq[cint], radii:seq[float]; 
              removeVolumne:bool = false ):seq[DimTag] =
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
  gmshModelOccFillet( cast[ptr cint](volumeTags[0].unsafeAddr), volumeTags.len.cuint,
                      cast[ptr cint](curveTags[0].unsafeAddr), curveTags.len.cuint, 
                      cast[ptr cdouble](radii[0].unsafeAddr), radii.len.cuint,
                      outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                      remove, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return getOutDimTags( outDimTags, outDimTagsN) 


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
  gmshModelOccChamfer( cast[ptr cint](volumeTags[0].unsafeAddr), volumeTags.len.cuint,
                       cast[ptr cint](curveTags[0].unsafeAddr), curveTags.len.cuint, 
                       cast[ptr cint](surfaceTags[0].unsafeAddr), surfaceTags.len.cuint,
                       cast[ptr cdouble](distances[0].unsafeAddr), distances.len.cuint,                       
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
  gmshModelOccFuse( cast[ptr cint](objectDimTags[0].unsafeAddr), objectDimTags.len.cuint,
                    cast[ptr cint](toolDimTags[0].unsafeAddr), toolDimTags.len.cuint,                   
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
  gmshModelOccIntersect( cast[ptr cint](objectDimTags[0].unsafeAddr), objectDimTags.len.cuint,
                         cast[ptr cint](toolDimTags[0].unsafeAddr), toolDimTags.len.cuint,                   
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
 
  gmshModelOccCut( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,
                   cast[ptr cint](tools[0].unsafeAddr), tools.len.cuint,                   
                   outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                   outDimTagsMap.unsafeAddr, outDimTagsMapN.unsafeAddr, outDimTagsMapNN.unsafeAddr,
                   tag.cint, removeObject.cint, removeTool.cint, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 
  
  let t = getOutDimTags( outDimTags, outDimTagsN) 
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

  gmshModelOccFragment( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,
                        cast[ptr cint](tools[0].unsafeAddr), tools.len.cuint,                   
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

proc translate*[N1,N2,N3:SomeNumber]( dimTags:seq[DimTag], dx:N1, dy:N2, dz:N3 ) =
  ##[ DEPRECATED
  Translate the model entities dimTags' along (dx', dy', dz').
  ]##
  var ierr:cint  
  let objects = flatten(dimTags)
  gmshModelOccTranslate( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,
                         dx.cdouble, dy.cdouble, dz.cdouble, 
                         ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  

proc translate*[N1,N2,N3:SomeNumber]( tags:seq[Tag], dx:N1, dy:N2, dz:N3 ) =
  ##[
  Translate the model entities dimTags' along (dx', dy', dz').
  ]##
  var ierr:cint
  let objects = flatten(tags)
  gmshModelOccTranslate( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,
                         dx.cdouble, dy.cdouble, dz.cdouble, 
                         ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  



proc rotate*( dimTags:seq[DimTag], p:Point,  ax, ay, az, angle:float ) =
  ##[ DEPRECATED
  Rotate the model entities dimTags' of angle' radians around the axis of
  revolution defined by the point (x', y', z') and the direction (ax',
  ay', az').
  ]##
  var ierr:cint  
  let objects = flatten(dimTags)
  gmshModelOccRotate( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,
                      p.x.cdouble, p.y.cdouble, p.z.cdouble, 
                      ax.cdouble, ay.cdouble, az.cdouble, 
                      angle.cdouble, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 

proc rotate*[N:SomeNumber]( tags:seq[Tag], p:Point,  axe:Vec, angle:N ) =
  ##[
  Rotate the model entities dimTags' of angle' radians around the axis of
  revolution defined by the point (x', y', z') and the direction (ax',
  ay', az').
  ]##
  var ierr:cint  
  let objects = flatten(tags)
  gmshModelOccRotate( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,
                      p.x.cdouble, p.y.cdouble, p.z.cdouble, 
                      axe.x.cdouble, axe.y.cdouble, axe.z.cdouble, 
                      angle.cdouble, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 


proc dilate*( dimTags:seq[int], p:Point, a, b, c:float ) =
  ##[
  Scale the model entities dimTag' by factors a', b' and c' along the
  three coordinate axes; use (x', y', z') as the center of the homothetic
  transformation.
  ]##
  var ierr:cint  
  gmshModelOccDilate( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.cuint,
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
  gmshModelOccMirror( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.cuint,
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
  gmshModelOccSymmetrize( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.cuint,
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
  gmshModelOccAffineTransform( cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.cuint,
                               cast[ptr cdouble](a[0].unsafeAddr), a.len.cuint,
                               ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface") 


proc copy*( dimTags:seq[DimTag] ):seq[DimTag] =
  ##[
  Copy the entities dimTags'; the new entities are returned in outDimTags'.
  ]##
  var ierr:cint  
  var objects = flatten(dimTags)
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  gmshModelOccCopy( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,                  
                    outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                    ierr.unsafeAddr )
  assert( ierr == 0, "error while copying some entities")  
  return getOutDimTags( outDimTags, outDimTagsN) 


proc asType*[T:Tag|SomeInteger,P:PointTag](newVal:T, original:P):P = newVal.P
proc asType*[T:Tag|SomeInteger,P:CurveTag](newVal:T, original:P):P = newVal.P

proc copy*[T:PointTag | CurveTag | WireTag | LoopTag | SurfaceTag | ShellTag | VolumeTag]( tags:seq[T] ):seq[T] =
  ##[
  Copy the entities dimTags'; the new entities are returned in outDimTags'.
  ]##
  var ierr:cint  
  var objects = flatten(tags)
  var outDimTags:ptr cint
  var outDimTagsN:uint 
  gmshModelOccCopy( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,                  
                    outDimTags.unsafeAddr, outDimTagsN.unsafeAddr,
                    ierr.unsafeAddr )
  assert( ierr == 0, "error while copying some entities")  
  let dimTags = getOutDimTags( outDimTags, outDimTagsN) 
  var newTags = newSeq[T](tags.len)
  for idx, item in dimTags:
    newTags[idx] = item.id.T
  return newTags

  


proc remove*( dimTags:seq[DimTag]; recursive:bool = false ) =
  ##[
  Remove the entities dimTags'. If recursive' is true, remove all the
  entities on their boundaries, down to dimension 0.
  ]##
  var ierr:cint  
  var recur:cint = if recursive: 1 else: 0
  let objects = flatten(dimTags)
  gmshModelOccRemove( cast[ptr cint](objects[0].unsafeAddr), objects.len.cuint,                  
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
                  makeSolids:bool = true ):seq[DimTag] =
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
                          cast[ptr cint](dimTags[0].unsafeAddr), dimTags.len.cuint,
                          tolerance.cdouble, degenerated, smallEdges, smallFaces, sew, solids,
                          ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new plane surface")  
  return getOutDimTags( outDimTags, outDimTagsN) 
                           

proc importShapes*(filename:string; format:string = ""; highestDimOnly:bool = true ):seq[DimTag] =
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
  return getOutDimTags( outDimTags, outDimTagsN)


proc importShapesNativePointer*(shape:pointer, highestDimOnly:int):seq[DimTag] =
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
  return getOutDimTags( outDimTags, outDimTagsN) 


proc entities*( dim:int = -1 ):seq[DimTag] =
  ##[
  Get all the OpenCASCADE entities. If `dim` is >= 0, return only the
  entities of the specified dimension (e.g. points if dim' == 0). The
  entities are returned as a vector of (dim, tag) integer pairs.
  ]##
  var ierr:cint
  var tags:ptr cint
  var tagsN:uint
  gmshModelOccGetEntities( tags.unsafeAddr, tagsN.unsafeAddr, dim.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  return getOutDimTags(tags, tagsN)


proc entitiesInBoundingBox*( bbMin, bbMax:Point; dim:int = -1):seq[DimTag] =
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
  return getOutDimTags(tags, tagsN)

proc getBoundingBox*[I:SomeInteger]( dim:I, tag:I):tuple[bbMin:Point, bbMax:Point] =
  ##[
  Get the bounding box (xmin', ymin', zmin'), (xmax', ymax', zmax') of
  the OpenCASCADE entity of dimension dim' and tag tag'.
  ]##
  var ierr:cint  
  echo dim, " ", tag
  var xmin,ymin,zmin,xmax,ymax,zmax:cdouble
  gmshModelOccGetBoundingBox(dim.cint, tag.cint, 
                  xmin.unsafeAddr, ymin.unsafeAddr, zmin.unsafeAddr,
                  xmax.unsafeAddr, ymax.unsafeAddr, zmax.unsafeAddr,                  
                  ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")

  return ( bbMin: (x:xmin.float, y:ymin.float, z:zmin.float), 
           bbMax: (x:xmax.float, y:ymax.float, z:zmax.float) )


proc getMass*( dim:int, tag:int):float = #NOK
  ##[
  Get the mass of the OpenCASCADE entity of dimension dim' and tag tag'.
  ]##
  var ierr:cint  
  var mass:cdouble
  gmshModelOccGetMass(dim.cint, tag.cint, mass.unsafeAddr, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  return mass.float


proc getCenterOfMass*( dim:int, tag:int):Point = #NOK
  ##[
  Get the center of mass of the OpenCASCADE entity of dimension dim' and tag
  tag'.
  ]##
  var ierr:cint  
  var x,y,z:cdouble
  gmshModelOccGetCenterOfMass(dim.cint, tag.cint, x.unsafeAddr, y.unsafeAddr, z.unsafeAddr, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")
  return pt(x,y,z)


proc getMatrixOfInertia*(dim:int, tag:int):seq[float] = #NOK
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


proc getMaxTag*(dim:int):int = #NOK
  ##[
  Get the maximum tag of entities of dimension dim' in the OpenCASCADE CAD
  representation.
  ]##
  var ierr:cint  
  let tmp = gmshModelOccGetMaxTag(dim.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline") 
  return tmp.int


proc SetMaxTag*(dim:int, maxTag:int ) = #NOK
  ##[
  Set the maximum tag maxTag' for entities of dimension dim' in the
  OpenCASCADE CAD representation.
  ]##
  var ierr:cint  
  gmshModelOccSetMaxTag(dim.cint, maxTag.cint, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new spline")   


proc sync*() =  #OK
  ##[
  Synchronize the OpenCASCADE CAD representation with the current Gmsh model.
  This can be called at any time, but since it involves a non trivial amount
  of processing, the number of synchronization points should normally be
  minimized.
  ]##
  var ierr:cint  
  gmshModelOccSynchronize(ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new spline")  


proc meshSetSize*( dimTags:seq[DimTag], size:float) = #NOK
  ##[
  Set a mesh size constraint on the model entities dimTags'. Currently only
  entities of dimension 0 (points) are handled.
  ]##
  var ierr:cint  
  let objects = flatten(dimTags)  
  gmshModelOccMeshSetSize( cast[ptr cint](objects[0].unsafeAddr), 
                           objects.len.cuint, size.cdouble, ierr.unsafeAddr)
  assert( ierr == 0, "error while adding a new spline")  


#------ Sugar baby
proc newGroup*[T:Tag](dimN:int, tags:seq[T]; name:string = "" ):seq[GroupTag] = 
  #let group = addPhysicalGroup(d, tag.cint)
  #var tmp:seq[seq[Tag], seq[Tag], seq[Tag], seq[Tag]] = @[ @[], @[], @[], @[] ]
  let values = castToCint(tags)
  let group = addPhysicalGroup( dimN, values )

  setPhysicalName(dimN, group[0], name)
  return group

proc newGroup*[T:PointTag](tags:seq[T]; name:string = "" ):seq[GroupTag]  = 
  #let group = addPhysicalGroup(d, tag.cint)
  #var tmp:seq[seq[Tag], seq[Tag], seq[Tag], seq[Tag]] = @[ @[], @[], @[], @[] ]
  return newGroup(0, tags, name)
  

proc newGroup*[T:SurfaceTag | ShellTag](tags:seq[T]; name:string = "" ):seq[GroupTag]  = 
  #let group = addPhysicalGroup(d, tag.cint)
  #var tmp:seq[seq[Tag], seq[Tag], seq[Tag], seq[Tag]] = @[ @[], @[], @[], @[] ]
  return newGroup(2, tags, name)


proc newGroup*[T:CurveTag | LoopTag | WireTag](tags:seq[T]; name:string = "" ):seq[GroupTag]  = 
  #let group = addPhysicalGroup(d, tag.cint)
  #var tmp:seq[seq[Tag], seq[Tag], seq[Tag], seq[Tag]] = @[ @[], @[], @[], @[] ]
  return newGroup(1, tags, name)

proc newGroup*[T:VolumeTag](tags:seq[T]; name:string = "" ):seq[GroupTag]  = 
  #let group = addPhysicalGroup(d, tag.cint)
  #var tmp:seq[seq[Tag], seq[Tag], seq[Tag], seq[Tag]] = @[ @[], @[], @[], @[] ]
  return newGroup(3, tags, name)

