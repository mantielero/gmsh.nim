#[
-----------------------------------------------------------------------------

  Gmsh C++ tutorial 19

  Thrusections, fillets, pipes, mesh size from curvature

-----------------------------------------------------------------------------

Periodic meshing constraints can be imposed on surfaces and curves.
]#
import gmsh
import sequtils
import math

const
  lc = 1e-2

proc main =
  # Before using any functions, Gmsh must be initialized.
  initialize()
  set("General.Terminal", 1)
  addModel("t19")

  # Volumes can be constructed from (closed) curve loops thanks to the
  # `addThruSections()' function
  var curves:seq[CurveTag]
  var curveLoops:seq[WireTag]   
  
  curves &= addCircle( (x:0.0,y:0.0,z:0.0), 0.5, 1)
  curveLoops &= addCurveLoop(@[curves[0]], 1)

  curves &= addCircle( (x:0.1,y:0.05,z:1.0), 0.1, 2)
  curveLoops &= addCurveLoop(@[curves[1]], 2)

  curves &= addCircle( (x: -0.1,y: -0.1, z:2.0), 0.3, 3)
  curveLoops &= addCurveLoop(@[curves[2]], 3)

  let ts1 = addThruSections(curveLoops, 1)
  sync()

  # We can also force the creation of ruled surfaces:
  curves &= addCircle( (x:2.0,y:0.0,z:0.0), 0.5, 11)
  curveLoops &= addCurveLoop(@[curves[curves.len-1]], 11)

  curves &= addCircle( (x:2.0 + 0.1,y: 0.05,z:1.0), 0.1, 12)
  curveLoops &= addCurveLoop(@[curves[curves.len-1]], 12)

  curves &= addCircle( (x: 2.0-0.1,y: -0.1, z:2.0), 0.3, 13)
  curveLoops &= addCurveLoop(@[curves[curves.len-1]], 13)

  let ts2 = addThruSections(curveLoops[3..<6], 11,true,true)
  sync()     

  # We copy the first volume, and fillet all its edges:
  let outtag = copy(@[DimTag(dim:3,id:1)])   # ts1
  outtag.translate(4.0, 0.0, 0.0)
  echo "outtag: ", outtag
  sync()
  let f = getBoundary( outtag )
  let e = getBoundary( f, false ) 
  var c:seq[cint]
  for item in e:
    c &= item.id.abs.cint

  echo outtag[0]
  echo e
  let filleted = fillet(@[outtag[0].id], c, @[0.1])
  sync()


  # OpenCASCADE also allows general extrusions along a smooth path. Let's first
  # define a spline curve:
  let
    nturns = 1.0
    npts = 20
    h = 1.0 * nturns
    r = 1.0

  var p:seq[PointTag]
  for i in 0..<npts:
    let theta = i.float * 2.0 * PI * nturns / npts.float
    p &= addPoint( (x: r * cos(theta), y: r * sin(theta), z: i.float * h / npts.float), 
                   1.0, 1000 + i)
  

  #echo "P:",repr p
  let spl = addSpline(p, 1000)
  echo repr spl
  let splineWire = addWire(@[spl], 1000)  # A wire is like a curve loop, but open:


  # We define the shape we would like to extrude along the spline (a disk):
  let disk = addDisk((x:1.0, y:0.0, z:0.0), 0.2, 0.2, 1000)  # SurfaceTag
  let diskTag = @[DimTag(dim:2,id:disk.cint)]

  diskTag.rotate((x:0.0,y:0.0,z:0.0), 1.0,0.0,0.0, PI/2.0 )

  # We extrude the disk along the spline to create a pipe:
  echo "diskTag: ", repr diskTag
  echo "splineWire: ", repr splineWire
  let mypipe = diskTag.addPipe(splineWire)

  # We delete the source surface, and increase the number of sub-edges for a
  # nicer display of the geometry:  
  remove(diskTag)
  set("Geometry.NumSubEdges", 1000)
  sync()


  # We can activate the calculation of mesh element sizes based on curvature:
  set("Mesh.CharacteristicLengthFromCurvature", 1)

  # And we set the minimum number of elements per 2*Pi radians:
  set("Mesh.MinimumElementsPerTwoPi", 20)

  # We can constraint the min and max element sizes to stay within reasonnable
  # values (see `t10.cpp' for more details):
  set("Mesh.CharacteristicLengthMin", 0.001)
  set("Mesh.CharacteristicLengthMax", 0.3)

  meshGenerate(3)
  write("t19.msh")
  finalize()

main()