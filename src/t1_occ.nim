#[
// -----------------------------------------------------------------------------
//
//  Gmsh C++ tutorial 1
//
//  Geometry basics, elementary entities, physical groups
//
// ----------------------------------------------------------------------------- 
]#
import gmsh

const
  lc = 1e-2

proc main =
  # Before using any functions, Gmsh must be initialized.
  initialize()

  # By default Gmsh will not print out any messages: in order to output
  # messages on the terminal, just set the "General.Terminal" option to 1
  set("General.Terminal", 1)  # TODO: probably `General` should be an object

  # We now add a new model, named "t1". Otherwise, a new default (unnamed) model 
  # will be created on the fly, if necessary. 
  addModel("t1")

  #[
  var points &= newPoint( pt(0,0,0), lc )
  points &= newPoint( pt(0.1, 0, 0), lc )
  points &= newPoint( pt(0.1, 0.3, 0), lc )
  points &= newPoint( pt(0, 0.3, 0), lc )
  ]#
  let points = newPoint( @[ pt(0,0,0),
                            pt(0.1, 0, 0),
                            pt(0.1, 0.3, 0),
                            pt(0, 0.3, 0) ], 
                         lc )  
  echo "Points: ", repr points

  let lines = newLine(points, close = true) # Closed
  echo "Lines: ", repr lines

  let loop = newCurveLoop(lines)
  let surface = addPlaneSurface(loop)

  #let g5 = @[1,2,4]
  #let g6 = @[1]
  #addPhysicalGroup(1, g5, 5 )
  let group = surface.newGroup("My Surface")
  sync()

  meshGenerate(2)
  write("t1_occ.msh")

main()