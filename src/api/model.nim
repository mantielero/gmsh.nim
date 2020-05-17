#[
Model
=====

]#
import ../wrapper/gmsh_wrapper


proc addModel*(name:string) =
  ## Add a new model, with name name, and set it as the current model.
  var ierr:cint
  gmshModelAdd( name.cstring, ierr.unsafeAddr )
  assert( ierr == 0, "error while adding a new model")


proc removeCurrentModel*() =
  ## Remove the current model.
  var ierr:cint
  gmshModelRemove( ierr.unsafeAddr )
  assert( ierr == 0, "error while removing current model")



#[ 
proc gmshModelList*(names: ptr ptr cstring; names_n: ptr uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    List the names of all models.




proc gmshModelGetCurrent*(name: ptr cstring; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the name of the current model.




proc gmshModelSetCurrent*(name: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the current model to the model with name name'. If several models have
  ##    the same name, select the one that was added first.



proc gmshModelGetEntities*(dimTags: ptr ptr cint; dimTags_n: ptr uint; dim: cint;
                          ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get all the entities in the current model. If dim' is >= 0, return only
  ##    the entities of the specified dimension (e.g. points if dim' == 0). The
  ##    entities are returned as a vector of (dim, tag) integer pairs.




proc gmshModelSetEntityName*(dim: cint; tag: cint; name: cstring; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the name of the entity of dimension dim' and tag tag'.




proc gmshModelGetEntityName*(dim: cint; tag: cint; name: ptr cstring; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the name of the entity of dimension dim' and tag tag'.


proc gmshModelGetPhysicalGroups*(dimTags: ptr ptr cint; dimTags_n: ptr uint; dim: cint;
                                ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get all the physical groups in the current model. If dim' is >= 0, return
  ##    only the entities of the specified dimension (e.g. physical points if dim'
  ##    == 0). The entities are returned as a vector of (dim, tag) integer pairs.


proc gmshModelGetEntitiesForPhysicalGroup*(dim: cint; tag: cint; tags: ptr ptr cint;
    tags_n: ptr uint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the tags of the model entities making up the physical group of
  ##    dimension dim' and tag tag'.


proc gmshModelGetPhysicalGroupsForEntity*(dim: cint; tag: cint;
    physicalTags: ptr ptr cint; physicalTags_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the tags of the physical groups (if any) to which the model entity of
  ##    dimension dim' and tag tag' belongs.
]#




proc addPhysicalGroup*(dim:int, tags:seq[int]; tag:int = -1 ):int {.discardable.} =
  ##[
  Add a physical group of dimension dim', grouping the model entities with
  tags tags'. Return the tag of the physical group, equal to tag' if tag'
  is positive, or a new tag if tag' < 0.  
  ]##
  var ierr:cint
  let t = gmshModelAddPhysicalGroup( dim.cint,
          cast[ptr cint](tags[0].unsafeAddr), tags.len.uint,
          tag.cint,
          ierr.unsafeAddr )
  assert( ierr == 0, "error while removing current model")  
  return t.int


proc setPhysicalName*(dim:int, tag:int, name:string) =
  ##[
  Set the name of the physical group of dimension dim' and tag tag'. 
  ]##
  var ierr:cint
  gmshModelSetPhysicalName( dim.cint, tag.cint, name.cstring,
          ierr.unsafeAddr )
  assert( ierr == 0, "error while setting the name of a physical group") 


#[
proc gmshModelGetPhysicalName*(dim: cint; tag: cint; name: ptr cstring; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the name of the physical group of dimension dim' and tag tag'.


proc gmshModelGetBoundary*(dimTags: ptr cint; dimTags_n: uint;
                          outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                          combined: cint; oriented: cint; recursive: cint;
                          ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the boundary of the model entities dimTags'. Return in outDimTags'
  ##    the boundary of the individual entities (if combined' is false) or the
  ##    boundary of the combined geometrical shape formed by all input entities (if
  ##    combined' is true). Return tags multiplied by the sign of the boundary
  ##    entity if oriented' is true. Apply the boundary operator recursively down
  ##    to dimension 0 (i.e. to points) if recursive' is true.


proc gmshModelGetEntitiesInBoundingBox*(xmin: cdouble; ymin: cdouble; zmin: cdouble;
                                       xmax: cdouble; ymax: cdouble; zmax: cdouble;
                                       tags: ptr ptr cint; tags_n: ptr uint; dim: cint;
                                       ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the model entities in the bounding box defined by the two points
  ##    (xmin', ymin', zmin') and (xmax', ymax', zmax'). If dim' is >= 0,
  ##    return only the entities of the specified dimension (e.g. points if dim'
  ##    == 0).


proc gmshModelGetBoundingBox*(dim: cint; tag: cint; xmin: ptr cdouble;
                             ymin: ptr cdouble; zmin: ptr cdouble; xmax: ptr cdouble;
                             ymax: ptr cdouble; zmax: ptr cdouble; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the bounding box (xmin', ymin', zmin'), (xmax', ymax', zmax') of
  ##    the model entity of dimension dim' and tag tag'. If dim' and tag' are
  ##    negative, get the bounding box of the whole model.


proc gmshModelGetDimension*(ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the geometrical dimension of the current model.


proc gmshModelAddDiscreteEntity*(dim: cint; tag: cint; boundary: ptr cint;
                                boundary_n: uint; ierr: ptr cint): cint {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Add a discrete model entity (defined by a mesh) of dimension dim' in the
  ##    current model. Return the tag of the new discrete entity, equal to tag' if
  ##    tag' is positive, or a new tag if tag' < 0. boundary' specifies the tags
  ##    of the entities on the boundary of the discrete entity, if any. Specifying
  ##    boundary' allows Gmsh to construct the topology of the overall model.


proc gmshModelRemoveEntities*(dimTags: ptr cint; dimTags_n: uint; recursive: cint;
                             ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the entities dimTags' of the current model. If recursive' is true,
  ##    remove all the entities on their boundaries, down to dimension 0.


proc gmshModelRemoveEntityName*(name: cstring; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Remove the entity name name' from the current model.


proc gmshModelRemovePhysicalGroups*(dimTags: ptr cint; dimTags_n: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the physical groups dimTags' of the current model. If dimTags' is
  ##    empty, remove all groups.


proc gmshModelRemovePhysicalName*(name: cstring; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Remove the physical name name' from the current model.


proc gmshModelGetType*(dim: cint; tag: cint; entityType: ptr cstring; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the type of the entity of dimension dim' and tag tag'.


proc gmshModelGetParent*(dim: cint; tag: cint; parentDim: ptr cint; parentTag: ptr cint;
                        ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    In a partitioned model, get the parent of the entity of dimension dim' and
  ##    tag tag', i.e. from which the entity is a part of, if any. parentDim' and
  ##    parentTag' are set to -1 if the entity has no parent.


proc gmshModelGetPartitions*(dim: cint; tag: cint; partitions: ptr ptr cint;
                            partitions_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    In a partitioned model, return the tags of the partition(s) to which the
  ##    entity belongs.


proc gmshModelGetValue*(dim: cint; tag: cint; parametricCoord: ptr cdouble;
                       parametricCoord_n: uint; coord: ptr ptr cdouble;
                       coord_n: ptr uint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Evaluate the parametrization of the entity of dimension dim' and tag tag'
  ##    at the parametric coordinates parametricCoord'. Only valid for dim' equal
  ##    to 0 (with empty parametricCoord'), 1 (with parametricCoord' containing
  ##    parametric coordinates on the curve) or 2 (with parametricCoord'
  ##    containing pairs of u, v parametric coordinates on the surface,
  ##    concatenated: [p1u, p1v, p2u, ...]). Return triplets of x, y, z coordinates
  ##    in coord', concatenated: [p1x, p1y, p1z, p2x, ...].


proc gmshModelGetDerivative*(dim: cint; tag: cint; parametricCoord: ptr cdouble;
                            parametricCoord_n: uint; derivatives: ptr ptr cdouble;
                            derivatives_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Evaluate the derivative of the parametrization of the entity of dimension
  ##    dim' and tag tag' at the parametric coordinates parametricCoord'. Only
  ##    valid for dim' equal to 1 (with parametricCoord' containing parametric
  ##    coordinates on the curve) or 2 (with parametricCoord' containing pairs of
  ##    u, v parametric coordinates on the surface, concatenated: [p1u, p1v, p2u,
  ##    ...]). For dim' equal to 1 return the x, y, z components of the derivative
  ##    with respect to u [d1ux, d1uy, d1uz, d2ux, ...]; for dim' equal to 2
  ##    return the x, y, z components of the derivate with respect to u and v:
  ##    [d1ux, d1uy, d1uz, d1vx, d1vy, d1vz, d2ux, ...].


proc gmshModelGetCurvature*(dim: cint; tag: cint; parametricCoord: ptr cdouble;
                           parametricCoord_n: uint; curvatures: ptr ptr cdouble;
                           curvatures_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Evaluate the (maximum) curvature of the entity of dimension dim' and tag
  ##    tag' at the parametric coordinates parametricCoord'. Only valid for dim'
  ##    equal to 1 (with parametricCoord' containing parametric coordinates on the
  ##    curve) or 2 (with parametricCoord' containing pairs of u, v parametric
  ##    coordinates on the surface, concatenated: [p1u, p1v, p2u, ...]).


proc gmshModelGetPrincipalCurvatures*(tag: cint; parametricCoord: ptr cdouble;
                                     parametricCoord_n: uint;
                                     curvatureMax: ptr ptr cdouble;
                                     curvatureMax_n: ptr uint;
                                     curvatureMin: ptr ptr cdouble;
                                     curvatureMin_n: ptr uint;
                                     directionMax: ptr ptr cdouble;
                                     directionMax_n: ptr uint;
                                     directionMin: ptr ptr cdouble;
                                     directionMin_n: ptr uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Evaluate the principal curvatures of the surface with tag tag' at the
  ##    parametric coordinates parametricCoord', as well as their respective
  ##    directions. parametricCoord' are given by pair of u and v coordinates,
  ##    concatenated: [p1u, p1v, p2u, ...].


proc gmshModelGetNormal*(tag: cint; parametricCoord: ptr cdouble;
                        parametricCoord_n: uint; normals: ptr ptr cdouble;
                        normals_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the normal to the surface with tag tag' at the parametric coordinates
  ##    parametricCoord'. parametricCoord' are given by pairs of u and v
  ##    coordinates, concatenated: [p1u, p1v, p2u, ...]. normals' are returned as
  ##    triplets of x, y, z components, concatenated: [n1x, n1y, n1z, n2x, ...].


proc gmshModelGetParametrization*(dim: cint; tag: cint; coord: ptr cdouble;
                                 coord_n: uint; parametricCoord: ptr ptr cdouble;
                                 parametricCoord_n: ptr uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the parametric coordinates parametricCoord' for the points coord' on
  ##    the entity of dimension dim' and tag tag'. coord' are given as triplets
  ##    of x, y, z coordinates, concatenated: [p1x, p1y, p1z, p2x, ...].
  ##    parametricCoord' returns the parametric coordinates t on the curve (if
  ##    dim' = 1) or pairs of u and v coordinates concatenated on the surface (if
  ##    dim' = 2), i.e. [p1t, p2t, ...] or [p1u, p1v, p2u, ...].


proc gmshModelGetParametrizationBounds*(dim: cint; tag: cint; min: ptr ptr cdouble;
                                       min_n: ptr uint; max: ptr ptr cdouble;
                                       max_n: ptr uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Get the min' and max' bounds of the parametric coordinates for the entity
  ##    of dimension dim' and tag tag'.


proc gmshModelIsInside*(dim: cint; tag: cint; parametricCoord: ptr cdouble;
                       parametricCoord_n: uint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Check if the parametric coordinates provided in parametricCoord'
  ##    correspond to points inside the entitiy of dimension dim' and tag tag',
  ##    and return the number of points inside. This feature is only available for
  ##    a subset of curves and surfaces, depending on the underyling geometrical
  ##    representation.


proc gmshModelReparametrizeOnSurface*(dim: cint; tag: cint;
                                     parametricCoord: ptr cdouble;
                                     parametricCoord_n: uint; surfaceTag: cint;
                                     surfaceParametricCoord: ptr ptr cdouble;
                                     surfaceParametricCoord_n: ptr uint;
                                     which: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Reparametrize the boundary entity (point or curve, i.e. with dim' == 0 or
  ##    dim' == 1) of tag tag' on the surface surfaceTag'. If dim' == 1,
  ##    reparametrize all the points corresponding to the parametric coordinates
  ##    parametricCoord'. Multiple matches in case of periodic surfaces can be
  ##    selected with which'. This feature is only available for a subset of
  ##    entities, depending on the underyling geometrical representation.


proc gmshModelSetVisibility*(dimTags: ptr cint; dimTags_n: uint; value: cint;
                            recursive: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set the visibility of the model entities dimTags' to value'. Apply the
  ##    visibility setting recursively if recursive' is true.


proc gmshModelGetVisibility*(dim: cint; tag: cint; value: ptr cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the visibility of the model entity of dimension dim' and tag tag'.


proc gmshModelSetColor*(dimTags: ptr cint; dimTags_n: uint; r: cint; g: cint; b: cint;
                       a: cint; recursive: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set the color of the model entities dimTags' to the RGBA value (r', g',
  ##    b', a'), where r', g', b' and a' should be integers between 0 and
  ##    255. Apply the color setting recursively if recursive' is true.


proc gmshModelGetColor*(dim: cint; tag: cint; r: ptr cint; g: ptr cint; b: ptr cint;
                       a: ptr cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the color of the model entity of dimension dim' and tag tag'.


proc gmshModelSetCoordinates*(tag: cint; x: cdouble; y: cdouble; z: cdouble;
                             ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the x', y', z' coordinates of a geometrical point.    
]#