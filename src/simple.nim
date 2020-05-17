#[
https://gitlab.onelab.info/gmsh/gmsh/-/blob/master/demos/api/simple.c   
]#
import gmsh

initialize()
set("General.Terminal", 1)

addModel("square")
var points:seq[int]
points &= addPoint( 0, 0, 0, 0.1, 1 )
points &= addPoint( 1, 0, 0, 0.1, 2 )
points &= addPoint( 1, 1, 0, 0.1, 3 )
points &= addPoint( 0, 1, 0, 0.1, 4 )
echo "Points: ", points

var lines:seq[int]
lines &= addLine(1, 2, 1)
lines &= addLine(2, 3, 2)
lines &= addLine(3, 4, 3)
lines &= addLine(4, 1) # try automatic assignement of tag

let loop = addCurveLoop(lines, 1)
var closeLoops = @[ loop ]

let surface = addPlaneSurface(closeLoops, 1)

geoSync()

meshGenerate(2)
write("square.msh")

