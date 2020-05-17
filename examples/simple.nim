#[
https://gitlab.onelab.info/gmsh/gmsh/-/blob/master/demos/api/simple.c   
]#
import ../src/gmsh

initialize()
set("General.Terminal", 1)

addModel("square")
let p1 = addPoint( 0, 0, 0, 0.1, 1 )
let p2 = addPoint( 1, 0, 0, 0.1, 2 )
let p3 = addPoint( 1, 1, 0, 0.1, 3 )
let p4 = addPoint( 0, 1, 0, 0.1, 4 )

var lines:seq[int]
lines &= addLine(1, 2, 1)
lines &= addLine(2, 3, 2)
lines &= addLine(3, 4, 3)
lines &= addLine(4, 1) # try automatic assignement of tag
echo "Lines: ", lines
let tmp = addCurveLoop(lines, 1)
echo tmp
var closeLoops = @[ tmp ]

let surface = addPlaneSurface(closeLoops, 1)

geoSync()

meshGenerate(2)
write("square.msh")

