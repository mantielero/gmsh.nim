#[
https://gmsh.info/doc/texinfo/gmsh.html#Gmsh-API 

https://gitlab.onelab.info/gmsh/gmsh/-/blob/master/api/gmsh.py
https://pygmsh.readthedocs.io/en/latest/opencascade.html
   
]#
import wrapper/gmsh_wrapper
include "api/geo"
include "api/option"
include "api/occ"
include "api/model"

proc initialize*(args:seq[string] = @[];readConfigFiles:bool=false) =
  ##  Initialize Gmsh. This must be called before any call to the other functions
  ##  in the API. If argc' and argv' (or just argv' in Python or Julia) are
  ##  provided, they will be handled in the same way as the command line
  ##    arguments in the Gmsh app. If readConfigFiles' is set, read system Gmsh
  ##    configuration files (gmshrc and gmsh-options).
  var ierr:cint
  var argc:cint = args.len.cint

  var argv = newSeq[cstring](argc)
  for i,val in args:
    argv[i] = args[i].cstring
  
  #var argv:cstring = ""
  let flag:cint = if readConfigFiles: 1 else: 0
  gmshInitialize(argc, cast[ptr cstring](argv.unsafeAddr), flag, ierr.unsafeAddr)   
  assert( ierr == 0, "error while initializing gmsh")  


proc finalize*() =
  ## Finalize Gmsh. This must be called when you are done using the Gmsh API.    
  var ierr:cint  
  gmshFinalize(ierr.unsafeAddr) 
  assert( ierr == 0, "error while finalizing gmsh") 


proc open*(filename:string) =
  ##    Open a file. Equivalent to the File->Open' menu in the Gmsh app. Handling
  ##    of the file depends on its extension and/or its contents: opening a file
  ##    with model data will create a new model.
  var ierr:cint 
  gmshOpen(fileName.cstring, ierr.unsafeAddr)
  assert( ierr == 0, "error while merging") 


proc merge*(filename:string) =
  ##    Merge a file. Equivalent to the File->Merge' menu in the Gmsh app.
  ##    Handling of the file depends on its extension and/or its contents. Merging
  ##    a file with model data will add the data to the current model.
  var ierr:cint 
  gmshMerge(fileName.cstring, ierr.unsafeAddr)
  assert( ierr == 0, "error while merging") 


proc write*(filename:string) =
  ## Write a file. The export format is determined by the file extension.
  var ierr:cint 
  gmshWrite(fileName.cstring, ierr.unsafeAddr)
  assert( ierr == 0, "error while writing gmsh") 


proc clear*() =
  ##    Clear all loaded models and post-processing data, and add a new empty
  ##    model.
  var ierr:cint 
  gmshClear(ierr.unsafeAddr)
  assert( ierr == 0, "error while merging") 

  



# ------------- Model










proc meshGenerate*(dim:int) =
  ## Generate a mesh of the current model, up to dimension dim' (0, 1, 2 or 3).
  var ierr:cint   
  gmshModelMeshGenerate(dim.cint, ierr.unsafeAddr)
  assert( ierr == 0, "error while generating the mesh") 


