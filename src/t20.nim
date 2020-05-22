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

#const
#  lc = 1e-2

proc main =
  # Before using any functions, Gmsh must be initialized.
  initialize()
  set("General.Terminal", 1)
  addModel("t20")

  # Load a STEP file (using `importShapes' instead of `merge' allows to
  # directly retrieve the tags of the highest dimensional imported entities):
  let shapes = importShapes("t20_data.step")
  sync()
  #echo shapes

  #[
  If we had specified
  
    set("OCCTargetUnit", "M")
  
  before merging the STEP file, OpenCASCADE would have converted the units to
  meters (instead of the default, which is millimeters).
  ]#

  # Get the bounding box of the volume:
  #echo repr shapes
  let (bbMin, bbMax) = getBoundingBox(shapes[0].dim, shapes[0].id)

  # Note that the synchronization step can be avoided in Gmsh >= 4.6 by using
  # `gmsh::model::occ::getBoundingBox()' instead of
  # `gmsh::model::getBoundingBox()'.  

  # We want to slice the model into N slices, and either keep the volume slices
  # or just the surfaces obtained by the cutting:
  let 
    N    = 5      # Number of slices
    dir  = "X"    # Direction: "X", "Y" or "Z"
    surf = false  # Keep only surfaces?    
    dx = (bbMax.x - bbMin.x )
    dy = (bbMax.y - bbMin.y )
    dz = (bbMax.z - bbMin.z )
    L = if dir == "X": dz else: dx
    H = if dir == "Y": dz else: dy    


  # Create the first cutting plane
  #std::vector<std::pair<int, int> > s;
  let rect = addRectangle(bbMin, L, H)
  #s.push_back({2, gmsh::model::occ::addRectangle(xmin, ymin, zmin, L, H)});
  let rectTag = @[DimTag(dim:2, id:rect.cint)]
  if dir == "X":
    rectTag.rotate( bbMin, 0.0, 1.0, 0.0, -PI/2.0 )
  elif dir == "Y":
    rectTag.rotate( bbMin, 1.0, 0.0, 0.0, PI/2.0 )    

  let
    tx = if dir == "X": dx / N.float else: 0.0
    ty = if dir == "Y": dy / N.float else: 0.0
    tz = if dir == "Z": dz / N.float else: 0.0

  rectTag.translate( tx, ty, tz)

  # Create the other cutting planes:
  var s:seq[DimTag]
  for i in 1..<N-1:
    let tmp = copy(rectTag)
    s &= tmp
    let n = i.float
    @[ s[s.len-1] ].translate( n * tx, n * ty, n * tz)
  
  # Fragment (i.e. intersect) the volume with all the cutting planes:
  let (ov, ovv) = fragment(shapes, s)
  sync()

  # Now remove all the surfaces (and their bounding entities) that are not on
  # the boundary of a volume, i.e. the parts of the cutting planes that "stick
  # out" of the volume:
  let tmp = entities(2)
  remove(tmp, true)

  # The previous synchronization step can be avoided in Gmsh >= 4.6 by using
  # `gmsh::model::occ::getEntities()' instead of `gmsh::model::getEntities()'.

  sync()

  #[
  if surf:
    # If we want to only keep the surfaces, retrieve the surfaces in bounding
    # boxes around the cutting planes...
    let eps = 1e-4

    for i 1..<N:
      let
        xx = if dir == "X": bbMin.x else: bbMax.x
        yy = if dir == "Y": bbMin.y else: bbMax.y
        zz = if dir == "Z": bbMin.z else: bbMax.z

      let e = getEntitiesInBoundingBox(
        (x: xmin - eps + i * tx, y: ymin - eps + i * ty, z: zmin - eps + i * tz),
        (x: xx + eps + i * tx, y: yy + eps + i * ty, z: zz + eps + i * tz), 
        2)
      s &= e  #s.insert(s.end(), e.begin(), e.end());

    
    # ...and remove all the other entities (here directly in the model, as we
    # won't modify any OpenCASCADE entities later on):
    dels = entities(2) 

    #for it in s:
    #  auto it2 = std::find(dels.begin(), dels.end(), *it);
    #  if(it2 != dels.end()) dels.erase(it2);
    #}
    entities(3).remove
    removeEntities(tmp)
    dels.remove
    entities(1).remove
    removeEntities(tmp)
    getEntities(0).remove()
  ]#

  # Finally, let's specify a global mesh size and mesh the partitioned model:
  set("Mesh.CharacteristicLengthMin", 3)
  set("Mesh.CharacteristicLengthMax", 3)
  meshGenerate(3)
  write("t20.msh")
  finalize()

main()