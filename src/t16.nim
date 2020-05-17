#[
-----------------------------------------------------------------------------

 Gmsh C++ tutorial 16

 Constructive Solid Geometry, OpenCASCADE geometry kernel

-----------------------------------------------------------------------------

Instead of constructing a model in a bottom-up fashion with Gmsh's built-in
geometry kernel, starting with version 3 Gmsh allows you to directly use
alternative geometry kernels. Here we will use the OpenCASCADE kernel.
]#
import gmsh

const
  lc = 1e-2

proc main =
  # Before using any functions, Gmsh must be initialized.
  initialize()

  # By default Gmsh will not print out any messages: in order to output
  # messages on the terminal, just set the "General.Terminal" option to 1
  set("General.Terminal", 1)

  # We now add a new model, named "t1". Otherwise, a new default (unnamed) model 
  # will be created on the fly, if necessary. 
  addModel("t16")


  let bigBox   = box( (x:0.0, y:0.0, z:0.0), 1, 1, 1, 1)
  let smallBox = box( (x:0.0, y:0.0, z:0.0), 0.5, 0.5, 0.5, 2)

#[
  // We apply a boolean difference to create the "cube minus one eigth" shape:
  std::vector<std::pair<int, int> > ov;
  std::vector<std::vector<std::pair<int, int> > > ovv;
  gmsh::model::occ::cut({{3, 1}}, {{3, 2}}, ov, ovv, 3);    
]#
  echo "CUT"
  echo "==="
  let (ov,ovv) = cut(@[bigBox], @[smallBox], 3)
  #let ov = cut(@[(dim:3,id:1)], @[(dim:3,id:2)], 3)
  echo "OV: ", ov
  echo "OVV: ", ovv

  var
    x = 0.0
    y = 0.75
    z = 0.0
    r = 0.09

  # 5 agujeros
  var holes = newSeq[DimTag](5)
  for i in 0..<5:
    x += 0.166
    z += 0.166 
    let outDim = sphere((x:x, y:y, z:z), r, 3 + i + 1)
    holes[i] = outDim
  echo "Holes: ", holes
  echo "FRAGMENT"
  echo "========"
  let (t1,t2) = fragment(@[DimTag(dim:3,id:3)], holes)
  echo "  Volumes produced:"
  for i in t1:
    echo "     ", i
  let inputs = @[DimTag(dim:3,id:3)] & holes
  echo "  Relationships:"
  for idx, children in t2:
    echo "     Parent: ", inputs[idx], "   children: ", children
  #echo repr t1
  #echo "Map:"
  #echo repr t2


  # ovv contains the parent-child relationships for all the input entities:
#[
  addPoint( 0.0, 0.0, 0.0, lc, 1 )
  addPoint( 0.1, 0.0, 0.0, lc, 2 )
  addPoint( 0.1, 0.3, 0.0, lc, 3 )
  addPoint( 0.0, 0.3, 0.0, lc, 4 )
  addLine(1, 2, 1)
  addLine(3, 2, 2)
  addLine(3, 4, 3)
  addLine(4, 1, 4)
  addCurveLoop(@[4, 1, -2, 3], 1)
  addPlaneSurface(@[1], 1)
  addPhysicalGroup(1, @[1, 2, 4], 5)
  let ps = addPhysicalGroup(2, @[1])
  setPhysicalName(2, ps, "My surface")

  # We can then add new points and curves in the same way as we did in `t1.nim`
  addPoint(0.0, 0.4, 0.0, lc, 5);
  addLine(4, 5, 5)

  translate(@[@[0, 5]], -0.02, 0, 0)



  echo "Points: ", points

  var lines:seq[int]
  lines &= addLine(1, 2, 1)
  lines &= addLine(2, 3, 2)
  lines &= addLine(3, points[3], 3)
  lines &= addLine(points[3], 1) # try automatic assignement of tag

  let loop = addCurveLoop(lines, 1)
  let closeLoops = @[ loop ]

  let surface = addPlaneSurface(closeLoops, 1)

  let g5 = @[1,2,4]
  let g6 = @[1]
  addPhysicalGroup(1, g5, 5 )
  let ps = addPhysicalGroup(2, g6, -1)
  setPhysicalName(2, ps, "My surface")

  geoSync()
  ]#
  sync()

  meshGenerate(3)
  write("t16.msh")

main()