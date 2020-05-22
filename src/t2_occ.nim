#[
-----------------------------------------------------------------------------

Gmsh C++ tutorial 2

Transformations, extruded geometries, volumes

----------------------------------------------------------------------------- 
]#
import gmsh,  math

const
  lc = 1e-2

proc main =
  initialize()
  set("General.Terminal", 1)
  addModel("t2")

  let points = newPoint( @[ pt(0,0,0),
                            pt(0.1, 0, 0),
                            pt(0.1, 0.3, 0),
                            pt(0, 0.3, 0) ], 
                         lc )

  # With Nim you could do this  
  #let surface = newLine(points, close = true).newCurveLoop.newPlaneSurface
  let lines = newLine(points, close = true)
  echo repr points
  let loop = newCurveLoop(lines)
  let surface = newPlaneSurface(loop)

  # Groups
  let group1 = newGroup(points[0..1] & points[3],"My Points")
  let group2 = surface.newGroup("My Surface")

  # We can then add new points and curves in the same way as we did in
  # `t1_occ.nim`
  let p5    = newPoint( pt(0, 0.4, 0,), lc)
  let line5 = newLine(points[3], p5[0]) 

  #[
  But Gmsh also provides tools to transform (translate, rotate, etc.)
  elementary entities or copies of elementary entities.  Geometrical
  transformations take a vector of pairs of integers as first argument, which
  contains the list of entities, represented by (dimension, tag) pairs.  For
  example, the point 5 (dimension=0, tag=5) can be moved by 0.02 to the left
  (dx=-0.02, dy=0, dz=0) with    
  ]#
  p5.translate(-0.02, 0, 0 )   #v(-0.02, 0, 0)
  # And it can be further rotated by -Pi/4 around (0, 0.3, 0) (with the
  # rotation along the z axis) with:  
  p5.rotate( pt(0, 0.3, 0), 
             v(0, 0, 1), 
             -PI / 4.0 )
  
  #[
  Note that there are no units in Gmsh: coordinates are just numbers - it's
  up to the user to associate a meaning to them.
  ]#

  #[
  // Point 3 can be duplicated and translated by 0.05 along the y axis by using
  // the `copy()' function, which takes a vector of (dim, tag) pairs as input,
  // and returns another vector of (dim, tag) pairs:
  ]#
  let p3 = points[2]
  #echo repr p3
  let ov =  @[p3].copy
  ov.translate(0,0.05,0)
  
  # Create new lines
  echo repr ov
  let line7 = newLine(p3, ov[0])
  let line8 = newLine(ov[0], p5[0])

  # 4 -- 5, 3 -- 3', 3' -- 5
  # 4 -- 5 , 5 -- 3', 3' -- 3, 
  let lines2 = @[line5[0], -line8[0], -line7[0], 3.CurveTag]
  echo repr lines2
  #echo repr lines[2]
  let loop2  = newCurveLoop(@[line5[0], -line8[0], -line7[0], lines[2]])   # TODO: esto debería ser más automático
  #let surf = loop.newPlaneSurface
  



  sync()

  meshGenerate(2)
  write("t2_occ.msh")

main()