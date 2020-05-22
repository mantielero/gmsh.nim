#[
-----------------------------------------------------------------------------

 Gmsh C++ tutorial 18

 Periodic meshes

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

  # By default Gmsh will not print out any messages: in order to output
  # messages on the terminal, just set the "General.Terminal" option to 1
  set("General.Terminal", 1)

  # We now add a new model, named "t1". Otherwise, a new default (unnamed) model 
  # will be created on the fly, if necessary. 
  addModel("t18")


  let box = box( (x:0.0, y:0.0, z:0.0), 1, 1, 1, 1)
  sync()

  let outTags = getEntities(0)
  echo outTags
  setSize(outTags, 0.1)
  setSize(@[DimTag(dim:0,id:1)], 0.02)

  
  let translation = @[ 1.0, 0.0, 0.0, 1.0, 
                       0.0, 1.0, 0.0, 0.0, 
                       0.0, 0.0, 1.0, 0.0, 
                       0.0, 0.0, 0.0, 1.0]

  setPeriodic(2, @[2], @[1],  translation)

  let trans = @[ 1.0, 0.0, 0.0, 0.0, 
                 0.0, 1.0, 0.0, 0.0, 
                 0.0, 0.0, 1.0, 1.0, 
                 0.0, 0.0, 0.0, 1.0]
  setPeriodic( 2, @[6], @[5], trans )
  
  let trans2 = @[ 1.0, 0.0, 0.0, 0.0, 
                  0.0, 1.0, 0.0, 1.0, 
                  0.0, 0.0, 1.0, 0.0, 
                  0.0, 0.0, 0.0, 1.0]  
  setPeriodic( 2, @[4], @[3], trans2)

  let box2 = box( (x:2.0, y:0.0, z:0.0), 1, 1, 1, 10)

  let
    x = 2.0 - 0.3
    y = 0.0
    z = 0.0

  var spheres:seq[DimTag]
  spheres &= sphere((x:x, y:y, z:z), 0.35, 11)
  spheres &= sphere((x:x + 1, y:y, z:z), 0.35, 12)
  spheres &= sphere((x:x, y:y + 1, z:z), 0.35, 13)
  spheres &= sphere((x:x, y:y, z:z + 1), 0.35, 14)
  spheres &= sphere((x:x + 1, y:y + 1, z:z), 0.35, 15)
  spheres &= sphere((x:x, y:y + 1, z:z + 1), 0.35, 16)
  spheres &= sphere((x:x + 1, y:y, z:z + 1), 0.35, 17)
  spheres &= sphere((x:x + 1, y:y + 1, z:z + 1), 0.35, 18)

  let (ov, ovv) = fragment(@[box2], spheres)
  sync()

  set("Geometry.OCCBoundsUseStl", 1)

  # We then retrieve all the volumes in the bounding box of the original cube,
  # and delete all the parts outside it:
  let eps = 1e-3

  let within = getEntitiesInBoundingBox( (x: 2.0-eps,     y: -eps,   z: -eps), 
                                       (x: 2.0+1.0+eps, y:1.0+eps, z: 1.0+eps), 3 ) 



  let outside = ov.filterIt(it notin within)
  
  removeEntities(outside, true) # Delete outside parts recursively
  echo "Removed everything outside the box"

  # We now set a non-uniform mesh size constraint (again to check results
  # visually):
  var p = getBoundary( within, false, false, true)  # Get all points
  setSize(p, 0.1)
  p = getEntitiesInBoundingBox( (x: 2.0-eps,     y: -eps,   z: -eps), 
                                (x: 2.0+eps, y:eps, z: eps), 0 ) 

  setSize(p, 0.001)

  # We now identify corresponding surfaces on the left and right sides of the
  # geometry automatically.

  # First we get all surfaces on the left:
  let sxmin = getEntitiesInBoundingBox( (x: 2.0-eps, y: -eps,    z: -eps), 
                                        (x: 2.0+eps, y: 1.0+eps, z: 1.0+eps), 2 ) 
      
  for surface in sxmin:
    # Then we get the bounding box of each left surface
    let (bbMin, bbMax) = getBoundingBox( surface )
    
    # We translate the bounding box to the right and look for surfaces inside
    # it:

    let sxmax = getEntitiesInBoundingBox( (x: bbMin.x - eps + 1.0, y: bbMin.y-eps,    z: bbMin.z-eps), 
                                        (x: bbMax.x + eps + 1.0, y: bbMax.y+eps, z: bbMax.z+eps), 2 ) 

    # For all the matches, we compare the corresponding bounding boxes...
    for surface2 in sxmax:
      var (bbMin2, bbMax2) = getBoundingBox( surface2 )
      bbMin2.x -= 1.0
      bbMax2.x -= 1.0

      # ...and if they match, we apply the periodicity constraint

      if abs(bbMin2.x - bbMin.x) < eps and abs(bbMax2.x - bbMax.x) < eps and
         abs(bbMin2.y - bbMin.y) < eps and abs(bbMax2.y - bbMax.y) < eps and
         abs(bbMin2.z - bbMin.z) < eps and abs(bbMax2.z - bbMax.z) < eps:
        let trans2 = @[ 1.0, 0.0, 0.0, 0.0, 
                    0.0, 1.0, 0.0, 1.0, 
                    0.0, 0.0, 1.0, 0.0, 
                    0.0, 0.0, 0.0, 1.0]  
        setPeriodic( 2, @[4], @[3], trans2) 
     
#[

      if(std::abs(xmin2 - xmin) < eps && std::abs(xmax2 - xmax) < eps &&
         std::abs(ymin2 - ymin) < eps && std::abs(ymax2 - ymax) < eps &&
         std::abs(zmin2 - zmin) < eps && std::abs(zmax2 - zmax) < eps) {
        gmsh::model::mesh::setPeriodic(2, {sxmax[j].second}, {sxmin[i].second},
                                       translation);

]#

  meshGenerate(3)
  write("t18.msh")
  finalize()

main()