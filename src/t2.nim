#[
https://gitlab.onelab.info/gmsh/gmsh/-/blob/master/demos/api/simple.c   
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
  addModel("t2")

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

  meshGenerate(2)
  write("t1.msh")

main()