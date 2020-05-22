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

  sync() 
  #[
  Here the `Physical Volume' definitions can thus be made for the 5 spheres
  directly, as the five spheres (volumes 4, 5, 6, 7 and 8), which will be
  deleted by the fragment operations, will be recreated identically (albeit
  with new surfaces) with the same tags:   
  ]#
  for i in 1..5:
    addPhysicalGroup(3, @[3+i], i)

 
  #var tmp:seq[int]
  #for item in t1:
  #  tmp &= item.id.int
  addPhysicalGroup(3, @[t1[t1.len-1].id.int], 10)

  let 
    lcar1 = 0.1
    lcar2 = 0.0005
    lcar3 = 0.055

  let allPoints = entities(0)
  allPoints.setSize(lcar1)

  let boundary = getBoundary(holes,false, false, true)
  boundary.setSize(lcar3)

  let
    eps = 1e-3
    tmp1 = 0.5 - eps
    tmp2 = 0.5 + eps
    p1 = (x: tmp1 ,y: tmp1,z: tmp1)
    p2 = (x: tmp2 ,y: tmp2,z: tmp2)
  let points_bb = entitiesInBoundingBox(p1,p2, 0)  # We get the points 
  #echo "Points: ", points_bb
  setSize(points_bb, lcar2)

  meshGenerate(3)
  write("t16.msh")

  finalize()

main()