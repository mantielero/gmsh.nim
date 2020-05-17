# Resetting /home/jose/src/gmsh.nim/build
# Importing /home/jose/src/gmsh.nim/build/api/gmshc.h
# Generated at 2020-05-14T13:26:38+02:00
# Command line:
#   /home/jose/.nimble/pkgs/nimterop-#head/nimterop/toast --preprocess -m:c --recurse -G__=_ -E_ -f:ast2 --pnim --dynlib=dynlibFile --nim:/home/jose/.choosenim/toolchains/nim-1.2.0/bin/nim /home/jose/src/gmsh.nim/build/api/gmshc.h

{.hint[ConvFromXtoItselfNotNeeded]: off.}

#import nimterop/types

# const 'GMSH_API' has invalid value 'void gmshFree(void *p);'

const
  dynlibFile = "wrapper/lib64/libgmsh.so"
  headergmshc* = "wrapper/include/gmshc.h"
  GMSH_API_VERSION* = "4.6"
  GMSH_API_VERSION_MAJOR* = 4
  GMSH_API_VERSION_MINOR* = 6
{.pragma: impgmshcHdr, header: headergmshc.}
{.pragma: impgmshcDyn, dynlib: dynlibFile.}
proc gmshMalloc*(n: uint): pointer {.importc, cdecl, impgmshcDyn.}
proc gmshInitialize*(argc: cint; argv: ptr cstring; readConfigFiles: cint;
                    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Initialize Gmsh. This must be called before any call to the other functions
  ##    in the API. If argc' and argv' (or just argv' in Python or Julia) are
  ##    provided, they will be handled in the same way as the command line
  ##    arguments in the Gmsh app. If readConfigFiles' is set, read system Gmsh
  ##    configuration files (gmshrc and gmsh-options).
proc gmshFinalize*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Finalize Gmsh. This must be called when you are done using the Gmsh API.
proc gmshOpen*(fileName: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Open a file. Equivalent to the File->Open' menu in the Gmsh app. Handling
  ##    of the file depends on its extension and/or its contents: opening a file
  ##    with model data will create a new model.
proc gmshMerge*(fileName: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Merge a file. Equivalent to the File->Merge' menu in the Gmsh app.
  ##    Handling of the file depends on its extension and/or its contents. Merging
  ##    a file with model data will add the data to the current model.
proc gmshWrite*(fileName: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Write a file. The export format is determined by the file extension.
proc gmshClear*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Clear all loaded models and post-processing data, and add a new empty
  ##    model.
proc gmshOptionSetNumber*(name: cstring; value: cdouble; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Set a numerical option to value'. name' is of the form "category.option"
  ##    or "category[num].option". Available categories and options are listed in
  ##    the Gmsh reference manual.
proc gmshOptionGetNumber*(name: cstring; value: ptr cdouble; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Get the value' of a numerical option. name' is of the form
  ##    "category.option" or "category[num].option". Available categories and
  ##    options are listed in the Gmsh reference manual.
proc gmshOptionSetString*(name: cstring; value: cstring; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Set a string option to value'. name' is of the form "category.option" or
  ##    "category[num].option". Available categories and options are listed in the
  ##    Gmsh reference manual.
proc gmshOptionGetString*(name: cstring; value: ptr cstring; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Get the value' of a string option. name' is of the form "category.option"
  ##    or "category[num].option". Available categories and options are listed in
  ##    the Gmsh reference manual.
proc gmshOptionSetColor*(name: cstring; r: cint; g: cint; b: cint; a: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a color option to the RGBA value (r', g', b', a'), where where r',
  ##    g', b' and a' should be integers between 0 and 255. name' is of the
  ##    form "category.option" or "category[num].option". Available categories and
  ##    options are listed in the Gmsh reference manual, with the "Color." middle
  ##    string removed.
proc gmshOptionGetColor*(name: cstring; r: ptr cint; g: ptr cint; b: ptr cint; a: ptr cint;
                        ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the r', g', b', a' value of a color option. name' is of the form
  ##    "category.option" or "category[num].option". Available categories and
  ##    options are listed in the Gmsh reference manual, with the "Color." middle
  ##    string removed.
proc gmshModelAdd*(name: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a new model, with name name', and set it as the current model.
proc gmshModelRemove*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the current model.
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
proc gmshModelAddPhysicalGroup*(dim: cint; tags: ptr cint; tags_n: uint; tag: cint;
                               ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a physical group of dimension dim', grouping the model entities with
  ##    tags tags'. Return the tag of the physical group, equal to tag' if tag'
  ##    is positive, or a new tag if tag' < 0.
proc gmshModelSetPhysicalName*(dim: cint; tag: cint; name: cstring; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the name of the physical group of dimension dim' and tag tag'.
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
  ## 

#-------

proc gmshModelMeshGenerate*(dim: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Generate a mesh of the current model, up to dimension dim' (0, 1, 2 or 3).
proc gmshModelMeshPartition*(numPart: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Partition the mesh of the current model into numPart' partitions.
proc gmshModelMeshUnpartition*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Unpartition the mesh of the current model.
proc gmshModelMeshOptimize*(`method`: cstring; force: cint; niter: cint;
                           dimTags: ptr cint; dimTags_n: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Optimize the mesh of the current model using method' (empty for default
  ##    tetrahedral mesh optimizer, "Netgen" for Netgen optimizer, "HighOrder" for
  ##    direct high-order mesh optimizer, "HighOrderElastic" for high-order elastic
  ##    smoother, "HighOrderFastCurving" for fast curving algorithm, "Laplace2D"
  ##    for Laplace smoothing, "Relocate2D" and "Relocate3D" for node relocation).
  ##    If force' is set apply the optimization also to discrete entities. If
  ##    dimTags' is given, only apply the optimizer to the given entities.
proc gmshModelMeshRecombine*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Recombine the mesh of the current model.
proc gmshModelMeshRefine*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Refine the mesh of the current model by uniformly splitting the elements.
proc gmshModelMeshSetOrder*(order: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the order of the elements in the mesh of the current model to order'.
proc gmshModelMeshGetLastEntityError*(dimTags: ptr ptr cint; dimTags_n: ptr uint;
                                     ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the last entities (if any) where a meshing error occurred. Currently
  ##    only populated by the new 3D meshing algorithms.
proc gmshModelMeshGetLastNodeError*(nodeTags: ptr ptr uint; nodeTags_n: ptr uint;
                                   ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the last nodes (if any) where a meshing error occurred. Currently only
  ##    populated by the new 3D meshing algorithms.
proc gmshModelMeshClear*(dimTags: ptr cint; dimTags_n: uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Clear the mesh, i.e. delete all the nodes and elements, for the entities
  ##    dimTags'. if dimTags' is empty, clear the whole mesh. Note that the mesh
  ##    of an entity can only be cleared if this entity is not on the boundary of
  ##    another entity with a non-empty mesh.
proc gmshModelMeshGetNodes*(nodeTags: ptr ptr uint; nodeTags_n: ptr uint;
                           coord: ptr ptr cdouble; coord_n: ptr uint;
                           parametricCoord: ptr ptr cdouble;
                           parametricCoord_n: ptr uint; dim: cint; tag: cint;
                           includeBoundary: cint; returnParametricCoord: cint;
                           ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the nodes classified on the entity of dimension dim' and tag tag'. If
  ##    tag' < 0, get the nodes for all entities of dimension dim'. If dim' and
  ##    tag' are negative, get all the nodes in the mesh. nodeTags' contains the
  ##    node tags (their unique, strictly positive identification numbers). coord'
  ##    is a vector of length 3 times the length of nodeTags' that contains the x,
  ##    y, z coordinates of the nodes, concatenated: [n1x, n1y, n1z, n2x, ...]. If
  ##    dim' >= 0 and returnParamtricCoord' is set, parametricCoord' contains
  ##    the parametric coordinates ([u1, u2, ...] or [u1, v1, u2, ...]) of the
  ##    nodes, if available. The length of parametricCoord' can be 0 or dim'
  ##    times the length of nodeTags'. If includeBoundary' is set, also return
  ##    the nodes classified on the boundary of the entity (which will be
  ##    reparametrized on the entity if dim' >= 0 in order to compute their
  ##    parametric coordinates).
proc gmshModelMeshGetNodesByElementType*(elementType: cint; nodeTags: ptr ptr uint;
                                        nodeTags_n: ptr uint;
                                        coord: ptr ptr cdouble; coord_n: ptr uint;
                                        parametricCoord: ptr ptr cdouble;
                                        parametricCoord_n: ptr uint; tag: cint;
                                        returnParametricCoord: cint;
                                        ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the nodes classified on the entity of tag tag', for all the elements
  ##    of type elementType'. The other arguments are treated as in getNodes'.
proc gmshModelMeshGetNode*(nodeTag: uint; coord: ptr ptr cdouble; coord_n: ptr uint;
                          parametricCoord: ptr ptr cdouble;
                          parametricCoord_n: ptr uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Get the coordinates and the parametric coordinates (if any) of the node
  ##    with tag tag'. This function relies on an internal cache (a vector in case
  ##    of dense node numbering, a map otherwise); for large meshes accessing nodes
  ##    in bulk is often preferable.
proc gmshModelMeshSetNode*(nodeTag: uint; coord: ptr cdouble; coord_n: uint;
                          parametricCoord: ptr cdouble; parametricCoord_n: uint;
                          ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the coordinates and the parametric coordinates (if any) of the node
  ##    with tag tag'. This function relies on an internal cache (a vector in case
  ##    of dense node numbering, a map otherwise); for large meshes accessing nodes
  ##    in bulk is often preferable.
proc gmshModelMeshRebuildNodeCache*(onlyIfNecessary: cint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Rebuild the node cache.
proc gmshModelMeshGetNodesForPhysicalGroup*(dim: cint; tag: cint;
    nodeTags: ptr ptr uint; nodeTags_n: ptr uint; coord: ptr ptr cdouble;
    coord_n: ptr uint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the nodes from all the elements belonging to the physical group of
  ##    dimension dim' and tag tag'. nodeTags' contains the node tags; coord'
  ##    is a vector of length 3 times the length of nodeTags' that contains the x,
  ##    y, z coordinates of the nodes, concatenated: [n1x, n1y, n1z, n2x, ...].
proc gmshModelMeshAddNodes*(dim: cint; tag: cint; nodeTags: ptr uint; nodeTags_n: uint;
                           coord: ptr cdouble; coord_n: uint;
                           parametricCoord: ptr cdouble; parametricCoord_n: uint;
                           ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add nodes classified on the model entity of dimension dim' and tag tag'.
  ##    nodeTags' contains the node tags (their unique, strictly positive
  ##    identification numbers). coord' is a vector of length 3 times the length
  ##    of nodeTags' that contains the x, y, z coordinates of the nodes,
  ##    concatenated: [n1x, n1y, n1z, n2x, ...]. The optional parametricCoord'
  ##    vector contains the parametric coordinates of the nodes, if any. The length
  ##    of parametricCoord' can be 0 or dim' times the length of nodeTags'. If
  ##    the nodeTags' vector is empty, new tags are automatically assigned to the
  ##    nodes.
proc gmshModelMeshReclassifyNodes*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Reclassify all nodes on their associated model entity, based on the
  ##    elements. Can be used when importing nodes in bulk (e.g. by associating
  ##    them all to a single volume), to reclassify them correctly on model
  ##    surfaces, curves, etc. after the elements have been set.
proc gmshModelMeshRelocateNodes*(dim: cint; tag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Relocate the nodes classified on the entity of dimension dim' and tag
  ##    tag' using their parametric coordinates. If tag' < 0, relocate the nodes
  ##    for all entities of dimension dim'. If dim' and tag' are negative,
  ##    relocate all the nodes in the mesh.
proc gmshModelMeshGetElements*(elementTypes: ptr ptr cint; elementTypes_n: ptr uint;
                              elementTags: ptr ptr ptr uint;
                              elementTags_n: ptr ptr uint; elementTags_nn: ptr uint;
                              nodeTags: ptr ptr ptr uint; nodeTags_n: ptr ptr uint;
                              nodeTags_nn: ptr uint; dim: cint; tag: cint;
                              ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the elements classified on the entity of dimension dim' and tag tag'.
  ##    If tag' < 0, get the elements for all entities of dimension dim'. If
  ##    dim' and tag' are negative, get all the elements in the mesh.
  ##    elementTypes' contains the MSH types of the elements (e.g. 2' for 3-node
  ##    triangles: see getElementProperties' to obtain the properties for a given
  ##    element type). elementTags' is a vector of the same length as
  ##    elementTypes'; each entry is a vector containing the tags (unique,
  ##    strictly positive identifiers) of the elements of the corresponding type.
  ##    nodeTags' is also a vector of the same length as elementTypes'; each
  ##    entry is a vector of length equal to the number of elements of the given
  ##    type times the number N of nodes for this type of element, that contains
  ##    the node tags of all the elements of the given type, concatenated: [e1n1,
  ##    e1n2, ..., e1nN, e2n1, ...].
proc gmshModelMeshGetElement*(elementTag: uint; elementType: ptr cint;
                             nodeTags: ptr ptr uint; nodeTags_n: ptr uint;
                             ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the type and node tags of the element with tag tag'. This function
  ##    relies on an internal cache (a vector in case of dense element numbering, a
  ##    map otherwise); for large meshes accessing elements in bulk is often
  ##    preferable.
proc gmshModelMeshGetElementByCoordinates*(x: cdouble; y: cdouble; z: cdouble;
    elementTag: ptr uint; elementType: ptr cint; nodeTags: ptr ptr uint;
    nodeTags_n: ptr uint; u: ptr cdouble; v: ptr cdouble; w: ptr cdouble; dim: cint;
    strict: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Search the mesh for an element located at coordinates (x', y', z'). This
  ##    function performs a search in a spatial octree. If an element is found,
  ##    return its tag, type and node tags, as well as the local coordinates (u',
  ##    v', w') within the reference element corresponding to search location. If
  ##    dim' is >= 0, only search for elements of the given dimension. If strict'
  ##    is not set, use a tolerance to find elements near the search location.
proc gmshModelMeshGetElementsByCoordinates*(x: cdouble; y: cdouble; z: cdouble;
    elementTags: ptr ptr uint; elementTags_n: ptr uint; dim: cint; strict: cint;
    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Search the mesh for element(s) located at coordinates (x', y', z'). This
  ##    function performs a search in a spatial octree. Return the tags of all
  ##    found elements in elementTags'. Additional information about the elements
  ##    can be accessed through getElement' and getLocalCoordinatesInElement'. If
  ##    dim' is >= 0, only search for elements of the given dimension. If strict'
  ##    is not set, use a tolerance to find elements near the search location.
proc gmshModelMeshGetLocalCoordinatesInElement*(elementTag: uint; x: cdouble;
    y: cdouble; z: cdouble; u: ptr cdouble; v: ptr cdouble; w: ptr cdouble; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Return the local coordinates (u', v', w') within the element
  ##    elementTag' corresponding to the model coordinates (x', y', z'). This
  ##    function relies on an internal cache (a vector in case of dense element
  ##    numbering, a map otherwise); for large meshes accessing elements in bulk is
  ##    often preferable.
proc gmshModelMeshGetElementTypes*(elementTypes: ptr ptr cint;
                                  elementTypes_n: ptr uint; dim: cint; tag: cint;
                                  ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the types of elements in the entity of dimension dim' and tag tag'.
  ##    If tag' < 0, get the types for all entities of dimension dim'. If dim'
  ##    and tag' are negative, get all the types in the mesh.
proc gmshModelMeshGetElementType*(familyName: cstring; order: cint; serendip: cint;
                                 ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Return an element type given its family name familyName' ("point", "line",
  ##    "triangle", "quadrangle", "tetrahedron", "pyramid", "prism", "hexahedron")
  ##    and polynomial order order'. If serendip' is true, return the
  ##    corresponding serendip element type (element without interior nodes).
proc gmshModelMeshGetElementProperties*(elementType: cint;
                                       elementName: ptr cstring; dim: ptr cint;
                                       order: ptr cint; numNodes: ptr cint;
                                       localNodeCoord: ptr ptr cdouble;
                                       localNodeCoord_n: ptr uint;
                                       numPrimaryNodes: ptr cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the properties of an element of type elementType': its name
  ##    (elementName'), dimension (dim'), order (order'), number of nodes
  ##    (numNodes'), local coordinates of the nodes in the reference element
  ##    (localNodeCoord' vector, of length dim' times numNodes') and number of
  ##    primary (first order) nodes (numPrimaryNodes').
proc gmshModelMeshGetElementsByType*(elementType: cint; elementTags: ptr ptr uint;
                                    elementTags_n: ptr uint;
                                    nodeTags: ptr ptr uint; nodeTags_n: ptr uint;
                                    tag: cint; task: uint; numTasks: uint;
                                    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the elements of type elementType' classified on the entity of tag
  ##    tag'. If tag' < 0, get the elements for all entities. elementTags' is a
  ##    vector containing the tags (unique, strictly positive identifiers) of the
  ##    elements of the corresponding type. nodeTags' is a vector of length equal
  ##    to the number of elements of the given type times the number N of nodes for
  ##    this type of element, that contains the node tags of all the elements of
  ##    the given type, concatenated: [e1n1, e1n2, ..., e1nN, e2n1, ...]. If
  ##    numTasks' > 1, only compute and return the part of the data indexed by
  ##    task'.
proc gmshModelMeshPreallocateElementsByType*(elementType: cint; elementTag: cint;
    nodeTag: cint; elementTags: ptr ptr uint; elementTags_n: ptr uint;
    nodeTags: ptr ptr uint; nodeTags_n: ptr uint; tag: cint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Preallocate data before calling getElementsByType' with numTasks' > 1.
  ##    For C and C++ only.
proc gmshModelMeshAddElements*(dim: cint; tag: cint; elementTypes: ptr cint;
                              elementTypes_n: uint; elementTags: ptr ptr uint;
                              elementTags_n: ptr uint; elementTags_nn: uint;
                              nodeTags: ptr ptr uint; nodeTags_n: ptr uint;
                              nodeTags_nn: uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add elements classified on the entity of dimension dim' and tag tag'.
  ##    types' contains the MSH types of the elements (e.g. 2' for 3-node
  ##    triangles: see the Gmsh reference manual). elementTags' is a vector of the
  ##    same length as types'; each entry is a vector containing the tags (unique,
  ##    strictly positive identifiers) of the elements of the corresponding type.
  ##    nodeTags' is also a vector of the same length as types'; each entry is a
  ##    vector of length equal to the number of elements of the given type times
  ##    the number N of nodes per element, that contains the node tags of all the
  ##    elements of the given type, concatenated: [e1n1, e1n2, ..., e1nN, e2n1,
  ##    ...].
proc gmshModelMeshAddElementsByType*(tag: cint; elementType: cint;
                                    elementTags: ptr uint; elementTags_n: uint;
                                    nodeTags: ptr uint; nodeTags_n: uint;
                                    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add elements of type elementType' classified on the entity of tag tag'.
  ##    elementTags' contains the tags (unique, strictly positive identifiers) of
  ##    the elements of the corresponding type. nodeTags' is a vector of length
  ##    equal to the number of elements times the number N of nodes per element,
  ##    that contains the node tags of all the elements, concatenated: [e1n1, e1n2,
  ##    ..., e1nN, e2n1, ...]. If the elementTag' vector is empty, new tags are
  ##    automatically assigned to the elements.
proc gmshModelMeshGetIntegrationPoints*(elementType: cint;
                                       integrationType: cstring;
                                       localCoord: ptr ptr cdouble;
                                       localCoord_n: ptr uint;
                                       weights: ptr ptr cdouble;
                                       weights_n: ptr uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Get the numerical quadrature information for the given element type
  ##    elementType' and integration rule integrationType' (e.g. "Gauss4" for a
  ##    Gauss quadrature suited for integrating 4th order polynomials).
  ##    localCoord' contains the u, v, w coordinates of the G integration points
  ##    in the reference element: [g1u, g1v, g1w, ..., gGu, gGv, gGw]. weights'
  ##    contains the associated weights: [g1q, ..., gGq].
proc gmshModelMeshGetJacobians*(elementType: cint; localCoord: ptr cdouble;
                               localCoord_n: uint; jacobians: ptr ptr cdouble;
                               jacobians_n: ptr uint;
                               determinants: ptr ptr cdouble;
                               determinants_n: ptr uint; coord: ptr ptr cdouble;
                               coord_n: ptr uint; tag: cint; task: uint;
                               numTasks: uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the Jacobians of all the elements of type elementType' classified on
  ##    the entity of tag tag', at the G evaluation points localCoord' given as
  ##    concatenated triplets of coordinates in the reference element [g1u, g1v,
  ##    g1w, ..., gGu, gGv, gGw]. Data is returned by element, with elements in the
  ##    same order as in getElements' and getElementsByType'. jacobians'
  ##    contains for each element the 9 entries of the 3x3 Jacobian matrix at each
  ##    evaluation point. The matrix is returned by column: [e1g1Jxu, e1g1Jyu,
  ##    e1g1Jzu, e1g1Jxv, ..., e1g1Jzw, e1g2Jxu, ..., e1gGJzw, e2g1Jxu, ...], with
  ##    Jxu=dx/du, Jyu=dy/du, etc. determinants' contains for each element the
  ##    determinant of the Jacobian matrix at each evaluation point: [e1g1, e1g2,
  ##    ... e1gG, e2g1, ...]. coord' contains for each element the x, y, z
  ##    coordinates of the evaluation points. If tag' < 0, get the Jacobian data
  ##    for all entities. If numTasks' > 1, only compute and return the part of
  ##    the data indexed by task'.
proc gmshModelMeshPreallocateJacobians*(elementType: cint;
                                       numEvaluationPoints: cint;
                                       allocateJacobians: cint;
                                       allocateDeterminants: cint;
                                       allocateCoord: cint;
                                       jacobians: ptr ptr cdouble;
                                       jacobians_n: ptr uint;
                                       determinants: ptr ptr cdouble;
                                       determinants_n: ptr uint;
                                       coord: ptr ptr cdouble; coord_n: ptr uint;
                                       tag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Preallocate data before calling getJacobians' with numTasks' > 1. For C
  ##    and C++ only.
proc gmshModelMeshGetBasisFunctions*(elementType: cint; localCoord: ptr cdouble;
                                    localCoord_n: uint;
                                    functionSpaceType: cstring;
                                    numComponents: ptr cint;
                                    basisFunctions: ptr ptr cdouble;
                                    basisFunctions_n: ptr uint;
                                    numOrientations: ptr cint;
                                    wantedOrientations: ptr cint;
                                    wantedOrientations_n: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the basis functions of the element of type elementType' at the
  ##    evaluation points localCoord' (given as concatenated triplets of
  ##    coordinates in the reference element [g1u, g1v, g1w, ..., gGu, gGv, gGw]),
  ##    for the function space functionSpaceType' (e.g. "Lagrange" or
  ##    "GradLagrange" for Lagrange basis functions or their gradient, in the u, v,
  ##    w coordinates of the reference element; or "H1Legendre3" or
  ##    "GradH1Legendre3" for 3rd order hierarchical H1 Legendre functions).
  ##    numComponents' returns the number C of components of a basis function.
  ##    basisFunctions' returns the value of the N basis functions at the
  ##    evaluation points, i.e. [g1f1, g1f2, ..., g1fN, g2f1, ...] when C == 1 or
  ##    [g1f1u, g1f1v, g1f1w, g1f2u, ..., g1fNw, g2f1u, ...] when C == 3. For basis
  ##    functions that depend on the orientation of the elements, all values for
  ##    the first orientation are returned first, followed by values for the
  ##    secondd, etc. numOrientations' returns the overall number of orientations.
proc gmshModelMeshGetBasisFunctionsOrientationForElements*(elementType: cint;
    functionSpaceType: cstring; basisFunctionsOrientation: ptr ptr cint;
    basisFunctionsOrientation_n: ptr uint; tag: cint; task: uint; numTasks: uint;
    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the orientation index of the elements of type elementType' in the
  ##    entity of tag tag'. The arguments have the same meaning as in
  ##    getBasisFunctions'. basisFunctionsOrientation' is a vector giving for
  ##    each element the orientation index in the values returned by
  ##    getBasisFunctions'. For Lagrange basis functions the call is superfluous
  ##    as it will return a vector of zeros.
proc gmshModelMeshGetNumberOfOrientations*(elementType: cint;
    functionSpaceType: cstring; ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the number of possible orientations for elements of type elementType'
  ##    and function space named functionSpaceType'.
proc gmshModelMeshPreallocateBasisFunctionsOrientationForElements*(
    elementType: cint; basisFunctionsOrientation: ptr ptr cint;
    basisFunctionsOrientation_n: ptr uint; tag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Preallocate data before calling getBasisFunctionsOrientationForElements'
  ##    with numTasks' > 1. For C and C++ only.
proc gmshModelMeshGetEdgeNumber*(edgeNodes: ptr cint; edgeNodes_n: uint;
                                edgeNum: ptr ptr cint; edgeNum_n: ptr uint;
                                ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the global edge identifier edgeNum' for an input list of node pairs,
  ##    concatenated in the vector edgeNodes'.  Warning: this is an experimental
  ##    feature and will probably change in a future release.
proc gmshModelMeshGetLocalMultipliersForHcurl0*(elementType: cint;
    localMultipliers: ptr ptr cint; localMultipliers_n: ptr uint; tag: cint;
    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the local multipliers (to guarantee H(curl)-conformity) of the order 0
  ##    H(curl) basis functions. Warning: this is an experimental feature and will
  ##    probably change in a future release.
proc gmshModelMeshGetKeysForElements*(elementType: cint;
                                     functionSpaceType: cstring;
                                     keys: ptr ptr cint; keys_n: ptr uint;
                                     coord: ptr ptr cdouble; coord_n: ptr uint;
                                     tag: cint; returnCoord: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Generate the keys' for the elements of type elementType' in the entity of
  ##    tag tag', for the functionSpaceType' function space. Each key uniquely
  ##    identifies a basis function in the function space. If returnCoord' is set,
  ##    the coord' vector contains the x, y, z coordinates locating basis
  ##    functions for sorting purposes. Warning: this is an experimental feature
  ##    and will probably change in a future release.
proc gmshModelMeshGetNumberOfKeysForElements*(elementType: cint;
    functionSpaceType: cstring; ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the number of keys by elements of type elementType' for function space
  ##    named functionSpaceType'.
proc gmshModelMeshGetInformationForElements*(keys: ptr cint; keys_n: uint;
    elementType: cint; functionSpaceType: cstring; infoKeys: ptr ptr cint;
    infoKeys_n: ptr uint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get information about the keys'. infoKeys' returns information about the
  ##    functions associated with the keys'. infoKeys[0].first' describes the
  ##    type of function (0 for  vertex function, 1 for edge function, 2 for face
  ##    function and 3 for bubble function). infoKeys[0].second' gives the order
  ##    of the function associated with the key. Warning: this is an experimental
  ##    feature and will probably change in a future release.
proc gmshModelMeshGetBarycenters*(elementType: cint; tag: cint; fast: cint;
                                 primary: cint; barycenters: ptr ptr cdouble;
                                 barycenters_n: ptr uint; task: uint; numTasks: uint;
                                 ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the barycenters of all elements of type elementType' classified on the
  ##    entity of tag tag'. If primary' is set, only the primary nodes of the
  ##    elements are taken into account for the barycenter calculation. If fast'
  ##    is set, the function returns the sum of the primary node coordinates
  ##    (without normalizing by the number of nodes). If tag' < 0, get the
  ##    barycenters for all entities. If numTasks' > 1, only compute and return
  ##    the part of the data indexed by task'.
proc gmshModelMeshPreallocateBarycenters*(elementType: cint;
    barycenters: ptr ptr cdouble; barycenters_n: ptr uint; tag: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Preallocate data before calling getBarycenters' with numTasks' > 1. For C
  ##    and C++ only.
proc gmshModelMeshGetElementEdgeNodes*(elementType: cint; nodeTags: ptr ptr uint;
                                      nodeTags_n: ptr uint; tag: cint; primary: cint;
                                      task: uint; numTasks: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the nodes on the edges of all elements of type elementType' classified
  ##    on the entity of tag tag'. nodeTags' contains the node tags of the edges
  ##    for all the elements: [e1a1n1, e1a1n2, e1a2n1, ...]. Data is returned by
  ##    element, with elements in the same order as in getElements' and
  ##    getElementsByType'. If primary' is set, only the primary (begin/end)
  ##    nodes of the edges are returned. If tag' < 0, get the edge nodes for all
  ##    entities. If numTasks' > 1, only compute and return the part of the data
  ##    indexed by task'.
proc gmshModelMeshGetElementFaceNodes*(elementType: cint; faceType: cint;
                                      nodeTags: ptr ptr uint; nodeTags_n: ptr uint;
                                      tag: cint; primary: cint; task: uint;
                                      numTasks: uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Get the nodes on the faces of type faceType' (3 for triangular faces, 4
  ##    for quadrangular faces) of all elements of type elementType' classified on
  ##    the entity of tag tag'. nodeTags' contains the node tags of the faces for
  ##    all elements: [e1f1n1, ..., e1f1nFaceType, e1f2n1, ...]. Data is returned
  ##    by element, with elements in the same order as in getElements' and
  ##    getElementsByType'. If primary' is set, only the primary (corner) nodes
  ##    of the faces are returned. If tag' < 0, get the face nodes for all
  ##    entities. If numTasks' > 1, only compute and return the part of the data
  ##    indexed by task'.
proc gmshModelMeshGetGhostElements*(dim: cint; tag: cint; elementTags: ptr ptr uint;
                                   elementTags_n: ptr uint;
                                   partitions: ptr ptr cint; partitions_n: ptr uint;
                                   ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the ghost elements elementTags' and their associated partitions'
  ##    stored in the ghost entity of dimension dim' and tag tag'.
proc gmshModelMeshSetSize*(dimTags: ptr cint; dimTags_n: uint; size: cdouble;
                          ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a mesh size constraint on the model entities dimTags'. Currently only
  ##    entities of dimension 0 (points) are handled.
proc gmshModelMeshSetSizeAtParametricPoints*(dim: cint; tag: cint;
    parametricCoord: ptr cdouble; parametricCoord_n: uint; sizes: ptr cdouble;
    sizes_n: uint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set mesh size constraints at the given parametric points parametricCoord'
  ##    on the model entity of dimension dim' and tag tag'. Currently only
  ##    entities of dimension 1 (lines) are handled.
proc gmshModelMeshSetTransfiniteCurve*(tag: cint; numNodes: cint; meshType: cstring;
                                      coef: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set a transfinite meshing constraint on the curve tag', with numNodes'
  ##    nodes distributed according to meshType' and coef'. Currently supported
  ##    types are "Progression" (geometrical progression with power coef') and
  ##    "Bump" (refinement toward both extremities of the curve).
proc gmshModelMeshSetTransfiniteSurface*(tag: cint; arrangement: cstring;
                                        cornerTags: ptr cint; cornerTags_n: uint;
                                        ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a transfinite meshing constraint on the surface tag'. arrangement'
  ##    describes the arrangement of the triangles when the surface is not flagged
  ##    as recombined: currently supported values are "Left", "Right",
  ##    "AlternateLeft" and "AlternateRight". cornerTags' can be used to specify
  ##    the (3 or 4) corners of the transfinite interpolation explicitly;
  ##    specifying the corners explicitly is mandatory if the surface has more that
  ##    3 or 4 points on its boundary.
proc gmshModelMeshSetTransfiniteVolume*(tag: cint; cornerTags: ptr cint;
                                       cornerTags_n: uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Set a transfinite meshing constraint on the surface tag'. cornerTags' can
  ##    be used to specify the (6 or 8) corners of the transfinite interpolation
  ##    explicitly.
proc gmshModelMeshSetRecombine*(dim: cint; tag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set a recombination meshing constraint on the model entity of dimension
  ##    dim' and tag tag'. Currently only entities of dimension 2 (to recombine
  ##    triangles into quadrangles) are supported.
proc gmshModelMeshSetSmoothing*(dim: cint; tag: cint; val: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a smoothing meshing constraint on the model entity of dimension dim'
  ##    and tag tag'. val' iterations of a Laplace smoother are applied.
proc gmshModelMeshSetReverse*(dim: cint; tag: cint; val: cint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Set a reverse meshing constraint on the model entity of dimension dim' and
  ##    tag tag'. If val' is true, the mesh orientation will be reversed with
  ##    respect to the natural mesh orientation (i.e. the orientation consistent
  ##    with the orientation of the geometry). If val' is false, the mesh is left
  ##    as-is.
proc gmshModelMeshSetAlgorithm*(dim: cint; tag: cint; val: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the meshing algorithm on the model entity of dimension dim' and tag
  ##    tag'. Currently only supported for dim' == 2.
proc gmshModelMeshSetSizeFromBoundary*(dim: cint; tag: cint; val: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Force the mesh size to be extended from the boundary, or not, for the model
  ##    entity of dimension dim' and tag tag'. Currently only supported for dim'
  ##    == 2.
proc gmshModelMeshSetCompound*(dim: cint; tags: ptr cint; tags_n: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a compound meshing constraint on the model entities of dimension dim'
  ##    and tags tags'. During meshing, compound entities are treated as a single
  ##    discrete entity, which is automatically reparametrized.
proc gmshModelMeshSetOutwardOrientation*(tag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set meshing constraints on the bounding surfaces of the volume of tag tag'
  ##    so that all surfaces are oriented with outward pointing normals. Currently
  ##    only available with the OpenCASCADE kernel, as it relies on the STL
  ##    triangulation.
proc gmshModelMeshEmbed*(dim: cint; tags: ptr cint; tags_n: uint; inDim: cint;
                        inTag: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Embed the model entities of dimension dim' and tags tags' in the
  ##    (inDim', inTag') model entity. The dimension dim' can 0, 1 or 2 and must
  ##    be strictly smaller than inDim', which must be either 2 or 3. The embedded
  ##    entities should not be part of the boundary of the entity inTag', whose
  ##    mesh will conform to the mesh of the embedded entities.
proc gmshModelMeshRemoveEmbedded*(dimTags: ptr cint; dimTags_n: uint; dim: cint;
                                 ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove embedded entities from the model entities dimTags'. if dim' is >=
  ##    0, only remove embedded entities of the given dimension (e.g. embedded
  ##    points if dim' == 0).
proc gmshModelMeshReorderElements*(elementType: cint; tag: cint; ordering: ptr uint;
                                  ordering_n: uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Reorder the elements of type elementType' classified on the entity of tag
  ##    tag' according to ordering'.
proc gmshModelMeshRenumberNodes*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Renumber the node tags in a continuous sequence.
proc gmshModelMeshRenumberElements*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Renumber the element tags in a continuous sequence.
proc gmshModelMeshSetPeriodic*(dim: cint; tags: ptr cint; tags_n: uint;
                              tagsMaster: ptr cint; tagsMaster_n: uint;
                              affineTransform: ptr cdouble;
                              affineTransform_n: uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Set the meshes of the entities of dimension dim' and tag tags' as
  ##    periodic copies of the meshes of entities tagsMaster', using the affine
  ##    transformation specified in affineTransformation' (16 entries of a 4x4
  ##    matrix, by row). If used after meshing, generate the periodic node
  ##    correspondence information assuming the meshes of entities tags'
  ##    effectively match the meshes of entities tagsMaster' (useful for
  ##    structured and extruded meshes). Currently only available for @code{dim} ==
  ##    1 and @code{dim} == 2.
proc gmshModelMeshGetPeriodicNodes*(dim: cint; tag: cint; tagMaster: ptr cint;
                                   nodeTags: ptr ptr uint; nodeTags_n: ptr uint;
                                   nodeTagsMaster: ptr ptr uint;
                                   nodeTagsMaster_n: ptr uint;
                                   affineTransform: ptr ptr cdouble;
                                   affineTransform_n: ptr uint;
                                   includeHighOrderNodes: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the master entity tagMaster', the node tags nodeTags' and their
  ##    corresponding master node tags nodeTagsMaster', and the affine transform
  ##    affineTransform' for the entity of dimension dim' and tag tag'. If
  ##    includeHighOrderNodes' is set, include high-order nodes in the returned
  ##    data.
proc gmshModelMeshRemoveDuplicateNodes*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove duplicate nodes in the mesh of the current model.
proc gmshModelMeshSplitQuadrangles*(quality: cdouble; tag: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Split (into two triangles) all quadrangles in surface tag' whose quality
  ##    is lower than quality'. If tag' < 0, split quadrangles in all surfaces.
proc gmshModelMeshClassifySurfaces*(angle: cdouble; boundary: cint;
                                   forReparametrization: cint;
                                   curveAngle: cdouble; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Classify ("color") the surface mesh based on the angle threshold angle'
  ##    (in radians), and create new discrete surfaces, curves and points
  ##    accordingly. If boundary' is set, also create discrete curves on the
  ##    boundary if the surface is open. If forReparametrization' is set, create
  ##    edges and surfaces that can be reparametrized using a single map. If
  ##    curveAngle' is less than Pi, also force curves to be split according to
  ##    curveAngle'.
proc gmshModelMeshCreateGeometry*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Create a parametrization for discrete curves and surfaces (i.e. curves and
  ##    surfaces represented solely by a mesh, without an underlying CAD
  ##    description), assuming that each can be parametrized with a single map.
proc gmshModelMeshCreateTopology*(makeSimplyConnected: cint; exportDiscrete: cint;
                                 ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Create a boundary representation from the mesh if the model does not have
  ##    one (e.g. when imported from mesh file formats with no BRep representation
  ##    of the underlying model). If makeSimplyConnected' is set, enforce simply
  ##    connected discrete surfaces and volumes. If exportDiscrete' is set, clear
  ##    any built-in CAD kernel entities and export the discrete entities in the
  ##    built-in CAD kernel.
proc gmshModelMeshComputeHomology*(domainTags: ptr cint; domainTags_n: uint;
                                  subdomainTags: ptr cint; subdomainTags_n: uint;
                                  dims: ptr cint; dims_n: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Compute a basis representation for homology spaces after a mesh has been
  ##    generated. The computation domain is given in a list of physical group tags
  ##    domainTags'; if empty, the whole mesh is the domain. The computation
  ##    subdomain for relative homology computation is given in a list of physical
  ##    group tags subdomainTags'; if empty, absolute homology is computed. The
  ##    dimensions homology bases to be computed are given in the list dim'; if
  ##    empty, all bases are computed. Resulting basis representation chains are
  ##    stored as physical groups in the mesh.
proc gmshModelMeshComputeCohomology*(domainTags: ptr cint; domainTags_n: uint;
                                    subdomainTags: ptr cint; subdomainTags_n: uint;
                                    dims: ptr cint; dims_n: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Compute a basis representation for cohomology spaces after a mesh has been
  ##    generated. The computation domain is given in a list of physical group tags
  ##    domainTags'; if empty, the whole mesh is the domain. The computation
  ##    subdomain for relative cohomology computation is given in a list of
  ##    physical group tags subdomainTags'; if empty, absolute cohomology is
  ##    computed. The dimensions homology bases to be computed are given in the
  ##    list dim'; if empty, all bases are computed. Resulting basis
  ##    representation cochains are stored as physical groups in the mesh.
proc gmshModelMeshComputeCrossField*(viewTags: ptr ptr cint; viewTags_n: ptr uint;
                                    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Compute a cross field for the current mesh. The function creates 3 views:
  ##    the H function, the Theta function and cross directions. Return the tags of
  ##    the views
proc gmshModelMeshFieldAdd*(fieldType: cstring; tag: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a new mesh size field of type fieldType'. If tag' is positive, assign
  ##    the tag explicitly; otherwise a new tag is assigned automatically. Return
  ##    the field tag.
proc gmshModelMeshFieldRemove*(tag: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the field with tag tag'.
proc gmshModelMeshFieldSetNumber*(tag: cint; option: cstring; value: cdouble;
                                 ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the numerical option option' to value value' for field tag'.
proc gmshModelMeshFieldSetString*(tag: cint; option: cstring; value: cstring;
                                 ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the string option option' to value value' for field tag'.
proc gmshModelMeshFieldSetNumbers*(tag: cint; option: cstring; value: ptr cdouble;
                                  value_n: uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set the numerical list option option' to value value' for field tag'.
proc gmshModelMeshFieldSetAsBackgroundMesh*(tag: cint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Set the field tag' as the background mesh size field.
proc gmshModelMeshFieldSetAsBoundaryLayer*(tag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set the field tag' as a boundary layer size field.



proc gmshModelGeoAddPoint*(x: cdouble; y: cdouble; z: cdouble; meshSize: cdouble;
                          tag: cint; ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a geometrical point in the built-in CAD representation, at coordinates
  ##    (x', y', z'). If meshSize' is > 0, add a meshing constraint at that
  ##    point. If tag' is positive, set the tag explicitly; otherwise a new tag is
  ##    selected automatically. Return the tag of the point. (Note that the point
  ##    will be added in the current model only after synchronize' is called. This
  ##    behavior holds for all the entities added in the geo module.)
proc gmshModelGeoAddLine*(startTag: cint; endTag: cint; tag: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a straight line segment between the two points with tags startTag' and
  ##    endTag'. If tag' is positive, set the tag explicitly; otherwise a new tag
  ##    is selected automatically. Return the tag of the line.
proc gmshModelGeoAddCircleArc*(startTag: cint; centerTag: cint; endTag: cint;
                              tag: cint; nx: cdouble; ny: cdouble; nz: cdouble;
                              ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a circle arc (strictly smaller than Pi) between the two points with
  ##    tags startTag' and endTag', with center centertag'. If tag' is
  ##    positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. If (nx', ny', nz') != (0, 0, 0), explicitly set the plane
  ##    of the circle arc. Return the tag of the circle arc.
proc gmshModelGeoAddEllipseArc*(startTag: cint; centerTag: cint; majorTag: cint;
                               endTag: cint; tag: cint; nx: cdouble; ny: cdouble;
                               nz: cdouble; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add an ellipse arc (strictly smaller than Pi) between the two points
  ##    startTag' and endTag', with center centerTag' and major axis point
  ##    majorTag'. If tag' is positive, set the tag explicitly; otherwise a new
  ##    tag is selected automatically. If (nx', ny', nz') != (0, 0, 0),
  ##    explicitly set the plane of the circle arc. Return the tag of the ellipse
  ##    arc.
proc gmshModelGeoAddSpline*(pointTags: ptr cint; pointTags_n: uint; tag: cint;
                           ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a spline (Catmull-Rom) curve going through the points pointTags'. If
  ##    tag' is positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. Create a periodic curve if the first and last points are the
  ##    same. Return the tag of the spline curve.
proc gmshModelGeoAddBSpline*(pointTags: ptr cint; pointTags_n: uint; tag: cint;
                            ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a cubic b-spline curve with pointTags' control points. If tag' is
  ##    positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. Creates a periodic curve if the first and last points are
  ##    the same. Return the tag of the b-spline curve.
proc gmshModelGeoAddBezier*(pointTags: ptr cint; pointTags_n: uint; tag: cint;
                           ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a Bezier curve with pointTags' control points. If tag' is positive,
  ##    set the tag explicitly; otherwise a new tag is selected automatically.
  ##    Return the tag of the Bezier curve.
proc gmshModelGeoAddCompoundSpline*(curveTags: ptr cint; curveTags_n: uint;
                                   numIntervals: cint; tag: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a spline (Catmull-Rom) going through points sampling the curves in
  ##    curveTags'. The density of sampling points on each curve is governed by
  ##    numIntervals'. If tag' is positive, set the tag explicitly; otherwise a
  ##    new tag is selected automatically. Return the tag of the spline.
proc gmshModelGeoAddCompoundBSpline*(curveTags: ptr cint; curveTags_n: uint;
                                    numIntervals: cint; tag: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a b-spline with control points sampling the curves in curveTags'. The
  ##    density of sampling points on each curve is governed by numIntervals'. If
  ##    tag' is positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. Return the tag of the b-spline.
proc gmshModelGeoAddCurveLoop*(curveTags: ptr cint; curveTags_n: uint; tag: cint;
                              ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a curve loop (a closed wire) formed by the curves curveTags'.
  ##    curveTags' should contain (signed) tags of model enties of dimension 1
  ##    forming a closed loop: a negative tag signifies that the underlying curve
  ##    is considered with reversed orientation. If tag' is positive, set the tag
  ##    explicitly; otherwise a new tag is selected automatically. Return the tag
  ##    of the curve loop.
proc gmshModelGeoAddPlaneSurface*(wireTags: ptr cint; wireTags_n: uint; tag: cint;
                                 ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a plane surface defined by one or more curve loops wireTags'. The
  ##    first curve loop defines the exterior contour; additional curve loop define
  ##    holes. If tag' is positive, set the tag explicitly; otherwise a new tag is
  ##    selected automatically. Return the tag of the surface.
proc gmshModelGeoAddSurfaceFilling*(wireTags: ptr cint; wireTags_n: uint; tag: cint;
                                   sphereCenterTag: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a surface filling the curve loops in wireTags'. Currently only a
  ##    single curve loop is supported; this curve loop should be composed by 3 or
  ##    4 curves only. If tag' is positive, set the tag explicitly; otherwise a
  ##    new tag is selected automatically. Return the tag of the surface.
proc gmshModelGeoAddSurfaceLoop*(surfaceTags: ptr cint; surfaceTags_n: uint;
                                tag: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a surface loop (a closed shell) formed by surfaceTags'.  If tag' is
  ##    positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. Return the tag of the shell.
proc gmshModelGeoAddVolume*(shellTags: ptr cint; shellTags_n: uint; tag: cint;
                           ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a volume (a region) defined by one or more shells shellTags'. The
  ##    first surface loop defines the exterior boundary; additional surface loop
  ##    define holes. If tag' is positive, set the tag explicitly; otherwise a new
  ##    tag is selected automatically. Return the tag of the volume.
proc gmshModelGeoExtrude*(dimTags: ptr cint; dimTags_n: uint; dx: cdouble; dy: cdouble;
                         dz: cdouble; outDimTags: ptr ptr cint;
                         outDimTags_n: ptr uint; numElements: ptr cint;
                         numElements_n: uint; heights: ptr cdouble; heights_n: uint;
                         recombine: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Extrude the model entities dimTags' by translation along (dx', dy',
  ##    dz'). Return extruded entities in outDimTags'. If numElements' is not
  ##    empty, also extrude the mesh: the entries in numElements' give the number
  ##    of elements in each layer. If height' is not empty, it provides the
  ##    (cumulative) height of the different layers, normalized to 1. If dx' ==
  ##    dy' == dz' == 0, the entities are extruded along their normal.
proc gmshModelGeoRevolve*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                         z: cdouble; ax: cdouble; ay: cdouble; az: cdouble;
                         angle: cdouble; outDimTags: ptr ptr cint;
                         outDimTags_n: ptr uint; numElements: ptr cint;
                         numElements_n: uint; heights: ptr cdouble; heights_n: uint;
                         recombine: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Extrude the model entities dimTags' by rotation of angle' radians around
  ##    the axis of revolution defined by the point (x', y', z') and the
  ##    direction (ax', ay', az'). The angle should be strictly smaller than Pi.
  ##    Return extruded entities in outDimTags'. If numElements' is not empty,
  ##    also extrude the mesh: the entries in numElements' give the number of
  ##    elements in each layer. If height' is not empty, it provides the
  ##    (cumulative) height of the different layers, normalized to 1.
proc gmshModelGeoTwist*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                       z: cdouble; dx: cdouble; dy: cdouble; dz: cdouble; ax: cdouble;
                       ay: cdouble; az: cdouble; angle: cdouble;
                       outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                       numElements: ptr cint; numElements_n: uint;
                       heights: ptr cdouble; heights_n: uint; recombine: cint;
                       ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Extrude the model entities dimTags' by a combined translation and rotation
  ##    of angle' radians, along (dx', dy', dz') and around the axis of
  ##    revolution defined by the point (x', y', z') and the direction (ax',
  ##    ay', az'). The angle should be strictly smaller than Pi. Return extruded
  ##    entities in outDimTags'. If numElements' is not empty, also extrude the
  ##    mesh: the entries in numElements' give the number of elements in each
  ##    layer. If height' is not empty, it provides the (cumulative) height of the
  ##    different layers, normalized to 1.
proc gmshModelGeoTranslate*(dimTags: ptr cint; dimTags_n: uint; dx: cdouble;
                           dy: cdouble; dz: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Translate the model entities dimTags' along (dx', dy', dz').
proc gmshModelGeoRotate*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                        z: cdouble; ax: cdouble; ay: cdouble; az: cdouble;
                        angle: cdouble; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Rotate the model entities dimTags' of angle' radians around the axis of
  ##    revolution defined by the point (x', y', z') and the direction (ax',
  ##    ay', az').
proc gmshModelGeoDilate*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                        z: cdouble; a: cdouble; b: cdouble; c: cdouble; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Scale the model entities dimTag' by factors a', b' and c' along the
  ##    three coordinate axes; use (x', y', z') as the center of the homothetic
  ##    transformation.
proc gmshModelGeoMirror*(dimTags: ptr cint; dimTags_n: uint; a: cdouble; b: cdouble;
                        c: cdouble; d: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Mirror the model entities dimTag', with respect to the plane of equation
  ##    a' x + b' y + c' z + d' = 0.
proc gmshModelGeoSymmetrize*(dimTags: ptr cint; dimTags_n: uint; a: cdouble; b: cdouble;
                            c: cdouble; d: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Mirror the model entities dimTag', with respect to the plane of equation
  ##    a' x + b' y + c' z + d' = 0. (This is a synonym for mirror',
  ##    which will be deprecated in a future release.)
proc gmshModelGeoCopy*(dimTags: ptr cint; dimTags_n: uint; outDimTags: ptr ptr cint;
                      outDimTags_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Copy the entities dimTags'; the new entities are returned in outDimTags'.
proc gmshModelGeoRemove*(dimTags: ptr cint; dimTags_n: uint; recursive: cint;
                        ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the entities dimTags'. If recursive' is true, remove all the
  ##    entities on their boundaries, down to dimension 0.
proc gmshModelGeoRemoveAllDuplicates*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove all duplicate entities (different entities at the same geometrical
  ##    location).
proc gmshModelGeoSplitCurve*(tag: cint; pointTags: ptr cint; pointTags_n: uint;
                            curveTags: ptr ptr cint; curveTags_n: ptr uint;
                            ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Split the model curve of tag tag' on the control points pointTags'.
  ##    Return the tags curveTags' of the newly created curves.
proc gmshModelGeoGetMaxTag*(dim: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the maximum tag of entities of dimension dim' in the built-in CAD
  ##    representation.
proc gmshModelGeoSetMaxTag*(dim: cint; maxTag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set the maximum tag maxTag' for entities of dimension dim' in the built-
  ##    in CAD representation.
proc gmshModelGeoSynchronize*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Synchronize the built-in CAD representation with the current Gmsh model.
  ##    This can be called at any time, but since it involves a non trivial amount
  ##    of processing, the number of synchronization points should normally be
  ##    minimized.
proc gmshModelGeoMeshSetSize*(dimTags: ptr cint; dimTags_n: uint; size: cdouble;
                             ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a mesh size constraint on the model entities dimTags'. Currently only
  ##    entities of dimension 0 (points) are handled.
proc gmshModelGeoMeshSetTransfiniteCurve*(tag: cint; nPoints: cint;
    meshType: cstring; coef: cdouble; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a transfinite meshing constraint on the curve tag', with numNodes'
  ##    nodes distributed according to meshType' and coef'. Currently supported
  ##    types are "Progression" (geometrical progression with power coef') and
  ##    "Bump" (refinement toward both extremities of the curve).
proc gmshModelGeoMeshSetTransfiniteSurface*(tag: cint; arrangement: cstring;
    cornerTags: ptr cint; cornerTags_n: uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set a transfinite meshing constraint on the surface tag'. arrangement'
  ##    describes the arrangement of the triangles when the surface is not flagged
  ##    as recombined: currently supported values are "Left", "Right",
  ##    "AlternateLeft" and "AlternateRight". cornerTags' can be used to specify
  ##    the (3 or 4) corners of the transfinite interpolation explicitly;
  ##    specifying the corners explicitly is mandatory if the surface has more that
  ##    3 or 4 points on its boundary.
proc gmshModelGeoMeshSetTransfiniteVolume*(tag: cint; cornerTags: ptr cint;
    cornerTags_n: uint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a transfinite meshing constraint on the surface tag'. cornerTags' can
  ##    be used to specify the (6 or 8) corners of the transfinite interpolation
  ##    explicitly.
proc gmshModelGeoMeshSetRecombine*(dim: cint; tag: cint; angle: cdouble; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a recombination meshing constraint on the model entity of dimension
  ##    dim' and tag tag'. Currently only entities of dimension 2 (to recombine
  ##    triangles into quadrangles) are supported.
proc gmshModelGeoMeshSetSmoothing*(dim: cint; tag: cint; val: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a smoothing meshing constraint on the model entity of dimension dim'
  ##    and tag tag'. val' iterations of a Laplace smoother are applied.
proc gmshModelGeoMeshSetReverse*(dim: cint; tag: cint; val: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a reverse meshing constraint on the model entity of dimension dim' and
  ##    tag tag'. If val' is true, the mesh orientation will be reversed with
  ##    respect to the natural mesh orientation (i.e. the orientation consistent
  ##    with the orientation of the geometry). If val' is false, the mesh is left
  ##    as-is.
proc gmshModelGeoMeshSetAlgorithm*(dim: cint; tag: cint; val: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the meshing algorithm on the model entity of dimension dim' and tag
  ##    tag'. Currently only supported for dim' == 2.
proc gmshModelGeoMeshSetSizeFromBoundary*(dim: cint; tag: cint; val: cint;
    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Force the mesh size to be extended from the boundary, or not, for the model
  ##    entity of dimension dim' and tag tag'. Currently only supported for dim'
  ##    == 2.
proc gmshModelOccAddPoint*(x: cdouble; y: cdouble; z: cdouble; meshSize: cdouble;
                          tag: cint; ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a geometrical point in the OpenCASCADE CAD representation, at
  ##    coordinates (x', y', z'). If meshSize' is > 0, add a meshing constraint
  ##    at that point. If tag' is positive, set the tag explicitly; otherwise a
  ##    new tag is selected automatically. Return the tag of the point. (Note that
  ##    the point will be added in the current model only after synchronize' is
  ##    called. This behavior holds for all the entities added in the occ module.)
proc gmshModelOccAddLine*(startTag: cint; endTag: cint; tag: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a straight line segment between the two points with tags startTag' and
  ##    endTag'. If tag' is positive, set the tag explicitly; otherwise a new tag
  ##    is selected automatically. Return the tag of the line.
proc gmshModelOccAddCircleArc*(startTag: cint; centerTag: cint; endTag: cint;
                              tag: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a circle arc between the two points with tags startTag' and endTag',
  ##    with center centerTag'. If tag' is positive, set the tag explicitly;
  ##    otherwise a new tag is selected automatically. Return the tag of the circle
  ##    arc.
proc gmshModelOccAddCircle*(x: cdouble; y: cdouble; z: cdouble; r: cdouble; tag: cint;
                           angle1: cdouble; angle2: cdouble; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a circle of center (x', y', z') and radius r'. If tag' is
  ##    positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. If angle1' and angle2' are specified, create a circle arc
  ##    between the two angles. Return the tag of the circle.
proc gmshModelOccAddEllipseArc*(startTag: cint; centerTag: cint; majorTag: cint;
                               endTag: cint; tag: cint; ierr: ptr cint): cint {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Add an ellipse arc between the two points startTag' and endTag', with
  ##    center centerTag' and major axis point majorTag'. If tag' is positive,
  ##    set the tag explicitly; otherwise a new tag is selected automatically.
  ##    Return the tag of the ellipse arc. Note that OpenCASCADE does not allow
  ##    creating ellipse arcs with the major radius smaller than the minor radius.
proc gmshModelOccAddEllipse*(x: cdouble; y: cdouble; z: cdouble; r1: cdouble;
                            r2: cdouble; tag: cint; angle1: cdouble; angle2: cdouble;
                            ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add an ellipse of center (x', y', z') and radii r1' and r2' along the
  ##    x- and y-axes respectively. If tag' is positive, set the tag explicitly;
  ##    otherwise a new tag is selected automatically. If angle1' and angle2' are
  ##    specified, create an ellipse arc between the two angles. Return the tag of
  ##    the ellipse. Note that OpenCASCADE does not allow creating ellipses with
  ##    the major radius (along the x-axis) smaller than or equal to the minor
  ##    radius (along the y-axis): rotate the shape or use addCircle' in such
  ##    cases.
proc gmshModelOccAddSpline*(pointTags: ptr cint; pointTags_n: uint; tag: cint;
                           ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a spline (C2 b-spline) curve going through the points pointTags'. If
  ##    tag' is positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. Create a periodic curve if the first and last points are the
  ##    same. Return the tag of the spline curve.
proc gmshModelOccAddBSpline*(pointTags: ptr cint; pointTags_n: uint; tag: cint;
                            degree: cint; weights: ptr cdouble; weights_n: uint;
                            knots: ptr cdouble; knots_n: uint;
                            multiplicities: ptr cint; multiplicities_n: uint;
                            ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a b-spline curve of degree degree' with pointTags' control points. If
  ##    weights', knots' or multiplicities' are not provided, default parameters
  ##    are computed automatically. If tag' is positive, set the tag explicitly;
  ##    otherwise a new tag is selected automatically. Create a periodic curve if
  ##    the first and last points are the same. Return the tag of the b-spline
  ##    curve.
proc gmshModelOccAddBezier*(pointTags: ptr cint; pointTags_n: uint; tag: cint;
                           ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a Bezier curve with pointTags' control points. If tag' is positive,
  ##    set the tag explicitly; otherwise a new tag is selected automatically.
  ##    Return the tag of the Bezier curve.
proc gmshModelOccAddWire*(curveTags: ptr cint; curveTags_n: uint; tag: cint;
                         checkClosed: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a wire (open or closed) formed by the curves curveTags'. Note that an
  ##    OpenCASCADE wire can be made of curves that share geometrically identical
  ##    (but topologically different) points. If tag' is positive, set the tag
  ##    explicitly; otherwise a new tag is selected automatically. Return the tag
  ##    of the wire.
proc gmshModelOccAddCurveLoop*(curveTags: ptr cint; curveTags_n: uint; tag: cint;
                              ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a curve loop (a closed wire) formed by the curves curveTags'.
  ##    curveTags' should contain tags of curves forming a closed loop. Note that
  ##    an OpenCASCADE curve loop can be made of curves that share geometrically
  ##    identical (but topologically different) points. If tag' is positive, set
  ##    the tag explicitly; otherwise a new tag is selected automatically. Return
  ##    the tag of the curve loop.
proc gmshModelOccAddRectangle*(x: cdouble; y: cdouble; z: cdouble; dx: cdouble;
                              dy: cdouble; tag: cint; roundedRadius: cdouble;
                              ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a rectangle with lower left corner at (x', y', z') and upper right
  ##    corner at (x' + dx', y' + dy', z'). If tag' is positive, set the tag
  ##    explicitly; otherwise a new tag is selected automatically. Round the
  ##    corners if roundedRadius' is nonzero. Return the tag of the rectangle.
proc gmshModelOccAddDisk*(xc: cdouble; yc: cdouble; zc: cdouble; rx: cdouble;
                         ry: cdouble; tag: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a disk with center (xc', yc', zc') and radius rx' along the x-axis
  ##    and ry' along the y-axis. If tag' is positive, set the tag explicitly;
  ##    otherwise a new tag is selected automatically. Return the tag of the disk.
proc gmshModelOccAddPlaneSurface*(wireTags: ptr cint; wireTags_n: uint; tag: cint;
                                 ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a plane surface defined by one or more curve loops (or closed wires)
  ##    wireTags'. The first curve loop defines the exterior contour; additional
  ##    curve loop define holes. If tag' is positive, set the tag explicitly;
  ##    otherwise a new tag is selected automatically. Return the tag of the
  ##    surface.
proc gmshModelOccAddSurfaceFilling*(wireTag: cint; tag: cint; pointTags: ptr cint;
                                   pointTags_n: uint; ierr: ptr cint): cint {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Add a surface filling the curve loops in wireTags'. If tag' is positive,
  ##    set the tag explicitly; otherwise a new tag is selected automatically.
  ##    Return the tag of the surface. If pointTags' are provided, force the
  ##    surface to pass through the given points.
proc gmshModelOccAddSurfaceLoop*(surfaceTags: ptr cint; surfaceTags_n: uint;
                                tag: cint; sewing: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a surface loop (a closed shell) formed by surfaceTags'.  If tag' is
  ##    positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. Return the tag of the surface loop. Setting sewing' allows
  ##    to build a shell made of surfaces that share geometrically identical (but
  ##    topologically different) curves.
proc gmshModelOccAddVolume*(shellTags: ptr cint; shellTags_n: uint; tag: cint;
                           ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a volume (a region) defined by one or more surface loops shellTags'.
  ##    The first surface loop defines the exterior boundary; additional surface
  ##    loop define holes. If tag' is positive, set the tag explicitly; otherwise
  ##    a new tag is selected automatically. Return the tag of the volume.
proc gmshModelOccAddSphere*(xc: cdouble; yc: cdouble; zc: cdouble; radius: cdouble;
                           tag: cint; angle1: cdouble; angle2: cdouble;
                           angle3: cdouble; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a sphere of center (xc', yc', zc') and radius r'. The optional
  ##    angle1' and angle2' arguments define the polar angle opening (from -Pi/2
  ##    to Pi/2). The optional angle3' argument defines the azimuthal opening
  ##    (from 0 to 2Pi). If tag' is positive, set the tag explicitly; otherwise a
  ##    new tag is selected automatically. Return the tag of the sphere.
proc gmshModelOccAddBox*(x: cdouble; y: cdouble; z: cdouble; dx: cdouble; dy: cdouble;
                        dz: cdouble; tag: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a parallelepipedic box defined by a point (x', y', z') and the
  ##    extents along the x-, y- and z-axes. If tag' is positive, set the tag
  ##    explicitly; otherwise a new tag is selected automatically. Return the tag
  ##    of the box.
proc gmshModelOccAddCylinder*(x: cdouble; y: cdouble; z: cdouble; dx: cdouble;
                             dy: cdouble; dz: cdouble; r: cdouble; tag: cint;
                             angle: cdouble; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a cylinder, defined by the center (x', y', z') of its first circular
  ##    face, the 3 components (dx', dy', dz') of the vector defining its axis
  ##    and its radius r'. The optional angle' argument defines the angular
  ##    opening (from 0 to 2Pi). If tag' is positive, set the tag explicitly;
  ##    otherwise a new tag is selected automatically. Return the tag of the
  ##    cylinder.
proc gmshModelOccAddCone*(x: cdouble; y: cdouble; z: cdouble; dx: cdouble; dy: cdouble;
                         dz: cdouble; r1: cdouble; r2: cdouble; tag: cint;
                         angle: cdouble; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a cone, defined by the center (x', y', z') of its first circular
  ##    face, the 3 components of the vector (dx', dy', dz') defining its axis
  ##    and the two radii r1' and r2' of the faces (these radii can be zero). If
  ##    tag' is positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. angle' defines the optional angular opening (from 0 to
  ##    2Pi). Return the tag of the cone.
proc gmshModelOccAddWedge*(x: cdouble; y: cdouble; z: cdouble; dx: cdouble; dy: cdouble;
                          dz: cdouble; tag: cint; ltx: cdouble; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a right angular wedge, defined by the right-angle point (x', y', z')
  ##    and the 3 extends along the x-, y- and z-axes (dx', dy', dz'). If tag'
  ##    is positive, set the tag explicitly; otherwise a new tag is selected
  ##    automatically. The optional argument ltx' defines the top extent along the
  ##    x-axis. Return the tag of the wedge.
proc gmshModelOccAddTorus*(x: cdouble; y: cdouble; z: cdouble; r1: cdouble; r2: cdouble;
                          tag: cint; angle: cdouble; ierr: ptr cint): cint {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Add a torus, defined by its center (x', y', z') and its 2 radii r' and
  ##    r2'. If tag' is positive, set the tag explicitly; otherwise a new tag is
  ##    selected automatically. The optional argument angle' defines the angular
  ##    opening (from 0 to 2Pi). Return the tag of the wedge.
proc gmshModelOccAddThruSections*(wireTags: ptr cint; wireTags_n: uint;
                                 outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                                 tag: cint; makeSolid: cint; makeRuled: cint;
                                 maxDegree: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a volume (if the optional argument makeSolid' is set) or surfaces
  ##    defined through the open or closed wires wireTags'. If tag' is positive,
  ##    set the tag explicitly; otherwise a new tag is selected automatically. The
  ##    new entities are returned in outDimTags'. If the optional argument
  ##    makeRuled' is set, the surfaces created on the boundary are forced to be
  ##    ruled surfaces. If maxDegree' is positive, set the maximal degree of
  ##    resulting surface.
proc gmshModelOccAddThickSolid*(volumeTag: cint; excludeSurfaceTags: ptr cint;
                               excludeSurfaceTags_n: uint; offset: cdouble;
                               outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                               tag: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a hollowed volume built from an initial volume volumeTag' and a set of
  ##    faces from this volume excludeSurfaceTags', which are to be removed. The
  ##    remaining faces of the volume become the walls of the hollowed solid, with
  ##    thickness offset'. If tag' is positive, set the tag explicitly; otherwise
  ##    a new tag is selected automatically.
proc gmshModelOccExtrude*(dimTags: ptr cint; dimTags_n: uint; dx: cdouble; dy: cdouble;
                         dz: cdouble; outDimTags: ptr ptr cint;
                         outDimTags_n: ptr uint; numElements: ptr cint;
                         numElements_n: uint; heights: ptr cdouble; heights_n: uint;
                         recombine: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Extrude the model entities dimTags' by translation along (dx', dy',
  ##    dz'). Return extruded entities in outDimTags'. If numElements' is not
  ##    empty, also extrude the mesh: the entries in numElements' give the number
  ##    of elements in each layer. If height' is not empty, it provides the
  ##    (cumulative) height of the different layers, normalized to 1.
proc gmshModelOccRevolve*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                         z: cdouble; ax: cdouble; ay: cdouble; az: cdouble;
                         angle: cdouble; outDimTags: ptr ptr cint;
                         outDimTags_n: ptr uint; numElements: ptr cint;
                         numElements_n: uint; heights: ptr cdouble; heights_n: uint;
                         recombine: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Extrude the model entities dimTags' by rotation of angle' radians around
  ##    the axis of revolution defined by the point (x', y', z') and the
  ##    direction (ax', ay', az'). Return extruded entities in outDimTags'. If
  ##    numElements' is not empty, also extrude the mesh: the entries in
  ##    numElements' give the number of elements in each layer. If height' is not
  ##    empty, it provides the (cumulative) height of the different layers,
  ##    normalized to 1. When the mesh is extruded the angle should be strictly
  ##    smaller than 2Pi.
proc gmshModelOccAddPipe*(dimTags: ptr cint; dimTags_n: uint; wireTag: cint;
                         outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                         ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a pipe by extruding the entities dimTags' along the wire wireTag'.
  ##    Return the pipe in outDimTags'.
proc gmshModelOccFillet*(volumeTags: ptr cint; volumeTags_n: uint;
                        curveTags: ptr cint; curveTags_n: uint; radii: ptr cdouble;
                        radii_n: uint; outDimTags: ptr ptr cint;
                        outDimTags_n: ptr uint; removeVolume: cint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Fillet the volumes volumeTags' on the curves curveTags' with radii
  ##    radii'. The radii' vector can either contain a single radius, as many
  ##    radii as curveTags', or twice as many as curveTags' (in which case
  ##    different radii are provided for the begin and end points of the curves).
  ##    Return the filleted entities in outDimTags'. Remove the original volume if
  ##    removeVolume' is set.
proc gmshModelOccChamfer*(volumeTags: ptr cint; volumeTags_n: uint;
                         curveTags: ptr cint; curveTags_n: uint;
                         surfaceTags: ptr cint; surfaceTags_n: uint;
                         distances: ptr cdouble; distances_n: uint;
                         outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                         removeVolume: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Chamfer the volumes volumeTags' on the curves curveTags' with distances
  ##    distances' measured on surfaces surfaceTags'. The distances' vector can
  ##    either contain a single distance, as many distances as curveTags' and
  ##    surfaceTags', or twice as many as curveTags' and surfaceTags' (in which
  ##    case the first in each pair is measured on the corresponding surface in
  ##    surfaceTags', the other on the other adjacent surface). Return the
  ##    chamfered entities in outDimTags'. Remove the original volume if
  ##    removeVolume' is set.
proc gmshModelOccFuse*(objectDimTags: ptr cint; objectDimTags_n: uint;
                      toolDimTags: ptr cint; toolDimTags_n: uint;
                      outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                      outDimTagsMap: ptr ptr ptr cint; outDimTagsMap_n: ptr ptr uint;
                      outDimTagsMap_nn: ptr uint; tag: cint; removeObject: cint;
                      removeTool: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Compute the boolean union (the fusion) of the entities objectDimTags' and
  ##    toolDimTags'. Return the resulting entities in outDimTags'. If tag' is
  ##    positive, try to set the tag explicitly (only valid if the boolean
  ##    operation results in a single entity). Remove the object if removeObject'
  ##    is set. Remove the tool if removeTool' is set.
proc gmshModelOccIntersect*(objectDimTags: ptr cint; objectDimTags_n: uint;
                           toolDimTags: ptr cint; toolDimTags_n: uint;
                           outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                           outDimTagsMap: ptr ptr ptr cint;
                           outDimTagsMap_n: ptr ptr uint;
                           outDimTagsMap_nn: ptr uint; tag: cint; removeObject: cint;
                           removeTool: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Compute the boolean intersection (the common parts) of the entities
  ##    objectDimTags' and toolDimTags'. Return the resulting entities in
  ##    outDimTags'. If tag' is positive, try to set the tag explicitly (only
  ##    valid if the boolean operation results in a single entity). Remove the
  ##    object if removeObject' is set. Remove the tool if removeTool' is set.
proc gmshModelOccCut*(objectDimTags: ptr cint; objectDimTags_n: uint;
                     toolDimTags: ptr cint; toolDimTags_n: uint;
                     outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                     outDimTagsMap: ptr ptr ptr cint; outDimTagsMap_n: ptr ptr uint;
                     outDimTagsMap_nn: ptr uint; tag: cint; removeObject: cint;
                     removeTool: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Compute the boolean difference between the entities objectDimTags' and
  ##    toolDimTags'. Return the resulting entities in outDimTags'. If tag' is
  ##    positive, try to set the tag explicitly (only valid if the boolean
  ##    operation results in a single entity). Remove the object if removeObject'
  ##    is set. Remove the tool if removeTool' is set.
proc gmshModelOccFragment*(objectDimTags: ptr cint; objectDimTags_n: uint;
                          toolDimTags: ptr cint; toolDimTags_n: uint;
                          outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                          outDimTagsMap: ptr ptr ptr cint;
                          outDimTagsMap_n: ptr ptr uint; outDimTagsMap_nn: ptr uint;
                          tag: cint; removeObject: cint; removeTool: cint;
                          ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Compute the boolean fragments (general fuse) of the entities
  ##    objectDimTags' and toolDimTags'. Return the resulting entities in
  ##    outDimTags'. If tag' is positive, try to set the tag explicitly (only
  ##    valid if the boolean operation results in a single entity). Remove the
  ##    object if removeObject' is set. Remove the tool if removeTool' is set.
proc gmshModelOccTranslate*(dimTags: ptr cint; dimTags_n: uint; dx: cdouble;
                           dy: cdouble; dz: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Translate the model entities dimTags' along (dx', dy', dz').
proc gmshModelOccRotate*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                        z: cdouble; ax: cdouble; ay: cdouble; az: cdouble;
                        angle: cdouble; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Rotate the model entities dimTags' of angle' radians around the axis of
  ##    revolution defined by the point (x', y', z') and the direction (ax',
  ##    ay', az').
proc gmshModelOccDilate*(dimTags: ptr cint; dimTags_n: uint; x: cdouble; y: cdouble;
                        z: cdouble; a: cdouble; b: cdouble; c: cdouble; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Scale the model entities dimTag' by factors a', b' and c' along the
  ##    three coordinate axes; use (x', y', z') as the center of the homothetic
  ##    transformation.
proc gmshModelOccMirror*(dimTags: ptr cint; dimTags_n: uint; a: cdouble; b: cdouble;
                        c: cdouble; d: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Apply a symmetry transformation to the model entities dimTag', with
  ##    respect to the plane of equation a' x + b' y + c' z + d' = 0.
proc gmshModelOccSymmetrize*(dimTags: ptr cint; dimTags_n: uint; a: cdouble; b: cdouble;
                            c: cdouble; d: cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Apply a symmetry transformation to the model entities dimTag', with
  ##    respect to the plane of equation a' x + b' y + c' z + d' = 0.
  ##    (This is a synonym for mirror', which will be deprecated in a future
  ##    release.)
proc gmshModelOccAffineTransform*(dimTags: ptr cint; dimTags_n: uint; a: ptr cdouble;
                                 a_n: uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Apply a general affine transformation matrix a' (16 entries of a 4x4
  ##    matrix, by row; only the 12 first can be provided for convenience) to the
  ##    model entities dimTag'.
proc gmshModelOccCopy*(dimTags: ptr cint; dimTags_n: uint; outDimTags: ptr ptr cint;
                      outDimTags_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Copy the entities dimTags'; the new entities are returned in outDimTags'.
proc gmshModelOccRemove*(dimTags: ptr cint; dimTags_n: uint; recursive: cint;
                        ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the entities dimTags'. If recursive' is true, remove all the
  ##    entities on their boundaries, down to dimension 0.
proc gmshModelOccRemoveAllDuplicates*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove all duplicate entities (different entities at the same geometrical
  ##    location) after intersecting (using boolean fragments) all highest
  ##    dimensional entities.
proc gmshModelOccHealShapes*(outDimTags: ptr ptr cint; outDimTags_n: ptr uint;
                            dimTags: ptr cint; dimTags_n: uint; tolerance: cdouble;
                            fixDegenerated: cint; fixSmallEdges: cint;
                            fixSmallFaces: cint; sewFaces: cint; makeSolids: cint;
                            ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Apply various healing procedures to the entities dimTags' (or to all the
  ##    entities in the model if dimTags' is empty). Return the healed entities in
  ##    outDimTags'. Available healing options are listed in the Gmsh reference
  ##    manual.
proc gmshModelOccImportShapes*(fileName: cstring; outDimTags: ptr ptr cint;
                              outDimTags_n: ptr uint; highestDimOnly: cint;
                              format: cstring; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Import BREP, STEP or IGES shapes from the file fileName'. The imported
  ##    entities are returned in outDimTags'. If the optional argument
  ##    highestDimOnly' is set, only import the highest dimensional entities in
  ##    the file. The optional argument format' can be used to force the format of
  ##    the file (currently "brep", "step" or "iges").
proc gmshModelOccImportShapesNativePointer*(shape: pointer;
    outDimTags: ptr ptr cint; outDimTags_n: ptr uint; highestDimOnly: cint;
    ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Imports an OpenCASCADE shape' by providing a pointer to a native
  ##    OpenCASCADE TopoDS_Shape' object (passed as a pointer to void). The
  ##    imported entities are returned in outDimTags'. If the optional argument
  ##    highestDimOnly' is set, only import the highest dimensional entities in
  ##    shape'. For C and C++ only. Warning: this function is unsafe, as providing
  ##    an invalid pointer will lead to undefined behavior.
proc gmshModelOccGetEntities*(dimTags: ptr ptr cint; dimTags_n: ptr uint; dim: cint;
                             ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get all the OpenCASCADE entities. If dim' is >= 0, return only the
  ##    entities of the specified dimension (e.g. points if dim' == 0). The
  ##    entities are returned as a vector of (dim, tag) integer pairs.
proc gmshModelOccGetEntitiesInBoundingBox*(xmin: cdouble; ymin: cdouble;
    zmin: cdouble; xmax: cdouble; ymax: cdouble; zmax: cdouble; tags: ptr ptr cint;
    tags_n: ptr uint; dim: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the OpenCASCADE entities in the bounding box defined by the two points
  ##    (xmin', ymin', zmin') and (xmax', ymax', zmax'). If dim' is >= 0,
  ##    return only the entities of the specified dimension (e.g. points if dim'
  ##    == 0).
proc gmshModelOccGetBoundingBox*(dim: cint; tag: cint; xmin: ptr cdouble;
                                ymin: ptr cdouble; zmin: ptr cdouble;
                                xmax: ptr cdouble; ymax: ptr cdouble;
                                zmax: ptr cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the bounding box (xmin', ymin', zmin'), (xmax', ymax', zmax') of
  ##    the OpenCASCADE entity of dimension dim' and tag tag'.
proc gmshModelOccGetMass*(dim: cint; tag: cint; mass: ptr cdouble; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the mass of the OpenCASCADE entity of dimension dim' and tag tag'.
proc gmshModelOccGetCenterOfMass*(dim: cint; tag: cint; x: ptr cdouble; y: ptr cdouble;
                                 z: ptr cdouble; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the center of mass of the OpenCASCADE entity of dimension dim' and tag
  ##    tag'.
proc gmshModelOccGetMatrixOfInertia*(dim: cint; tag: cint; mat: ptr ptr cdouble;
                                    mat_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the matrix of inertia (by row) of the OpenCASCADE entity of dimension
  ##    dim' and tag tag'.
proc gmshModelOccGetMaxTag*(dim: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get the maximum tag of entities of dimension dim' in the OpenCASCADE CAD
  ##    representation.
proc gmshModelOccSetMaxTag*(dim: cint; maxTag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set the maximum tag maxTag' for entities of dimension dim' in the
  ##    OpenCASCADE CAD representation.
proc gmshModelOccSynchronize*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Synchronize the OpenCASCADE CAD representation with the current Gmsh model.
  ##    This can be called at any time, but since it involves a non trivial amount
  ##    of processing, the number of synchronization points should normally be
  ##    minimized.
proc gmshModelOccMeshSetSize*(dimTags: ptr cint; dimTags_n: uint; size: cdouble;
                             ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set a mesh size constraint on the model entities dimTags'. Currently only
  ##    entities of dimension 0 (points) are handled.
proc gmshViewAdd*(name: cstring; tag: cint; ierr: ptr cint): cint {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a new post-processing view, with name name'. If tag' is positive use
  ##    it (and remove the view with that tag if it already exists), otherwise
  ##    associate a new tag. Return the view tag.
proc gmshViewRemove*(tag: cint; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Remove the view with tag tag'.
proc gmshViewGetIndex*(tag: cint; ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the index of the view with tag tag' in the list of currently loaded
  ##    views. This dynamic index (it can change when views are removed) is used to
  ##    access view options.
proc gmshViewGetTags*(tags: ptr ptr cint; tags_n: ptr uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Get the tags of all views.
proc gmshViewAddModelData*(tag: cint; step: cint; modelName: cstring;
                          dataType: cstring; tags: ptr uint; tags_n: uint;
                          data: ptr ptr cdouble; data_n: ptr uint; data_nn: uint;
                          time: cdouble; numComponents: cint; partition: cint;
                          ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add model-based post-processing data to the view with tag tag'.
  ##    modelName' identifies the model the data is attached to. dataType'
  ##    specifies the type of data, currently either "NodeData", "ElementData" or
  ##    "ElementNodeData". step' specifies the identifier (>= 0) of the data in a
  ##    sequence. tags' gives the tags of the nodes or elements in the mesh to
  ##    which the data is associated. data' is a vector of the same length as
  ##    tags': each entry is the vector of double precision numbers representing
  ##    the data associated with the corresponding tag. The optional time'
  ##    argument associate a time value with the data. numComponents' gives the
  ##    number of data components (1 for scalar data, 3 for vector data, etc.) per
  ##    entity; if negative, it is automatically inferred (when possible) from the
  ##    input data. partition' allows to specify data in several sub-sets.
proc gmshViewAddHomogeneousModelData*(tag: cint; step: cint; modelName: cstring;
                                     dataType: cstring; tags: ptr uint; tags_n: uint;
                                     data: ptr cdouble; data_n: uint; time: cdouble;
                                     numComponents: cint; partition: cint;
                                     ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add homogeneous model-based post-processing data to the view with tag
  ##    tag'. The arguments have the same meaning as in addModelData', except
  ##    that data' is supposed to be homogeneous and is thus flattened in a single
  ##    vector. This is always possible e.g. for "NodeData" and "ElementData", but
  ##    only if data is associated to elements of the same type for
  ##    "ElementNodeData".
proc gmshViewGetModelData*(tag: cint; step: cint; dataType: ptr cstring;
                          tags: ptr ptr uint; tags_n: ptr uint;
                          data: ptr ptr ptr cdouble; data_n: ptr ptr uint;
                          data_nn: ptr uint; time: ptr cdouble;
                          numComponents: ptr cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get model-based post-processing data from the view with tag tag' at step
  ##    step'. Return the data' associated to the nodes or the elements with tags
  ##    tags', as well as the dataType' and the number of components
  ##    numComponents'.
proc gmshViewAddListData*(tag: cint; dataType: cstring; numEle: cint;
                         data: ptr cdouble; data_n: uint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Add list-based post-processing data to the view with tag tag'. dataType'
  ##    identifies the data: "SP" for scalar points, "VP", for vector points, etc.
  ##    numEle' gives the number of elements in the data. data' contains the data
  ##    for the numEle' elements.
proc gmshViewGetListData*(tag: cint; dataType: ptr ptr cstring; dataType_n: ptr uint;
                         numElements: ptr ptr cint; numElements_n: ptr uint;
                         data: ptr ptr ptr cdouble; data_n: ptr ptr uint;
                         data_nn: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get list-based post-processing data from the view with tag tag'. Return
  ##    the types dataTypes', the number of elements numElements' for each data
  ##    type and the data' for each data type.
proc gmshViewAddListDataString*(tag: cint; coord: ptr cdouble; coord_n: uint;
                               data: ptr cstring; data_n: uint; style: ptr cstring;
                               style_n: uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Add a string to a list-based post-processing view with tag tag'. If
  ##    coord' contains 3 coordinates the string is positioned in the 3D model
  ##    space ("3D string"); if it contains 2 coordinates it is positioned in the
  ##    2D graphics viewport ("2D string"). data' contains one or more (for
  ##    multistep views) strings. style' contains pairs of styling parameters,
  ##    concatenated.
proc gmshViewGetListDataStrings*(tag: cint; dim: cint; coord: ptr ptr cdouble;
                                coord_n: ptr uint; data: ptr ptr cstring;
                                data_n: ptr uint; style: ptr ptr cstring;
                                style_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get list-based post-processing data strings (2D strings if dim' = 2, 3D
  ##    strings if dim' = 3) from the view with tag tag'. Return the coordinates
  ##    in coord', the strings in data' and the styles in style'.
proc gmshViewAddAlias*(refTag: cint; copyOptions: cint; tag: cint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Add a post-processing view as an alias' of the reference view with tag
  ##    refTag'. If copyOptions' is set, copy the options of the reference view.
  ##    If tag' is positive use it (and remove the view with that tag if it
  ##    already exists), otherwise associate a new tag. Return the view tag.
proc gmshViewCopyOptions*(refTag: cint; tag: cint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Copy the options from the view with tag refTag' to the view with tag
  ##    tag'.
proc gmshViewCombine*(what: cstring; how: cstring; remove: cint; copyOptions: cint;
                     ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Combine elements (if what' == "elements") or steps (if what' == "steps")
  ##    of all views (how' == "all"), all visible views (how' == "visible") or
  ##    all views having the same name (how' == "name"). Remove original views if
  ##    remove' is set.
proc gmshViewProbe*(tag: cint; x: cdouble; y: cdouble; z: cdouble;
                   value: ptr ptr cdouble; value_n: ptr uint; step: cint; numComp: cint;
                   gradient: cint; tolerance: cdouble; xElemCoord: ptr cdouble;
                   xElemCoord_n: uint; yElemCoord: ptr cdouble; yElemCoord_n: uint;
                   zElemCoord: ptr cdouble; zElemCoord_n: uint; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Probe the view tag' for its value' at point (x', y', z'). Return only
  ##    the value at step step' is step' is positive. Return only values with
  ##    numComp' if numComp' is positive. Return the gradient of the value' if
  ##    gradient' is set. Probes with a geometrical tolerance (in the reference
  ##    unit cube) of tolerance' if tolerance' is not zero. Return the result
  ##    from the element described by its coordinates if xElementCoord',
  ##    yElementCoord' and zElementCoord' are provided.
proc gmshViewWrite*(tag: cint; fileName: cstring; append: cint; ierr: ptr cint) {.importc,
    cdecl, impgmshcDyn.}
  ## ::
  ##    Write the view to a file fileName'. The export format is determined by the
  ##    file extension. Append to the file if append' is set.
proc gmshPluginSetNumber*(name: cstring; option: cstring; value: cdouble;
                         ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the numerical option option' to the value value' for plugin name'.
proc gmshPluginSetString*(name: cstring; option: cstring; value: cstring;
                         ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the string option option' to the value value' for plugin name'.
proc gmshPluginRun*(name: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Run the plugin name'.
proc gmshGraphicsDraw*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Draw all the OpenGL scenes.
proc gmshFltkInitialize*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Create the FLTK graphical user interface. Can only be called in the main
  ##    thread.
proc gmshFltkWait*(time: cdouble; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Wait at most time' seconds for user interface events and return. If time'
  ##    < 0, wait indefinitely. First automatically create the user interface if it
  ##    has not yet been initialized. Can only be called in the main thread.
proc gmshFltkUpdate*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Update the user interface (potentially creating new widgets and windows).
  ##    First automatically create the user interface if it has not yet been
  ##    initialized. Can only be called in the main thread: use awake("update")'
  ##    to trigger an update of the user interface from another thread.
proc gmshFltkAwake*(action: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Awake the main user interface thread and process pending events, and
  ##    optionally perform an action (currently the only action' allowed is
  ##    "update").
proc gmshFltkLock*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Block the current thread until it can safely modify the user interface.
proc gmshFltkUnlock*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Release the lock that was set using lock.
proc gmshFltkRun*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Run the event loop of the graphical user interface, i.e. repeatedly call
  ##    wait()'. First automatically create the user interface if it has not yet
  ##    been initialized. Can only be called in the main thread.
proc gmshFltkIsAvailable*(ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Check if the user interface is available (e.g. to detect if it has been
  ##    closed).
proc gmshFltkSelectEntities*(dimTags: ptr ptr cint; dimTags_n: ptr uint; dim: cint;
                            ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Select entities in the user interface. If dim' is >= 0, return only the
  ##    entities of the specified dimension (e.g. points if dim' == 0).
proc gmshFltkSelectElements*(elementTags: ptr ptr uint; elementTags_n: ptr uint;
                            ierr: ptr cint): cint {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Select elements in the user interface.
proc gmshFltkSelectViews*(viewTags: ptr ptr cint; viewTags_n: ptr uint; ierr: ptr cint): cint {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Select views in the user interface.
proc gmshOnelabSet*(data: cstring; format: cstring; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Set one or more parameters in the ONELAB database, encoded in format'.
proc gmshOnelabGet*(data: ptr cstring; name: cstring; format: cstring; ierr: ptr cint) {.
    importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get all the parameters (or a single one if name' is specified) from the
  ##    ONELAB database, encoded in format'.
proc gmshOnelabSetNumber*(name: cstring; value: ptr cdouble; value_n: uint;
                         ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the value of the number parameter name' in the ONELAB database. Create
  ##    the parameter if it does not exist; update the value if the parameter
  ##    exists.
proc gmshOnelabSetString*(name: cstring; value: ptr cstring; value_n: uint;
                         ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Set the value of the string parameter name' in the ONELAB database. Create
  ##    the parameter if it does not exist; update the value if the parameter
  ##    exists.
proc gmshOnelabGetNumber*(name: cstring; value: ptr ptr cdouble; value_n: ptr uint;
                         ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the value of the number parameter name' from the ONELAB database.
  ##    Return an empty vector if the parameter does not exist.
proc gmshOnelabGetString*(name: cstring; value: ptr ptr cstring; value_n: ptr uint;
                         ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Get the value of the string parameter name' from the ONELAB database.
  ##    Return an empty vector if the parameter does not exist.
proc gmshOnelabClear*(name: cstring; ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Clear the ONELAB database, or remove a single parameter if name' is given.
proc gmshOnelabRun*(name: cstring; command: cstring; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Run a ONELAB client. If name' is provided, create a new ONELAB client with
  ##    name name' and executes command'. If not, try to run a client that might
  ##    be linked to the processed input files.
proc gmshLoggerWrite*(message: cstring; level: cstring; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Write a message'. level' can be "info", "warning" or "error".
proc gmshLoggerStart*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Start logging messages.
proc gmshLoggerGet*(log: ptr ptr cstring; log_n: ptr uint; ierr: ptr cint) {.importc, cdecl,
    impgmshcDyn.}
  ## ::
  ##    Get logged messages.
proc gmshLoggerStop*(ierr: ptr cint) {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Stop logging messages.
proc gmshLoggerGetWallTime*(ierr: ptr cint): cdouble {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Return wall clock time.
proc gmshLoggerGetCpuTime*(ierr: ptr cint): cdouble {.importc, cdecl, impgmshcDyn.}
  ## ::
  ##    Return CPU time.

