# yay -S gmsh-bin # No usarlo; proporciona el binario "gmsh"
# nim c wrapper > gmsh_wrapper.nim

import os, strformat

import nimterop/[cimport, git]

when defined(windows):
  # Windows specific symbols, options and files

  # Dynamic library to link against
  const dynlibFile = "libode.dll"

elif defined(linux):
  const dynlibFile = "/usr/bin/gmsh"

else:
  static: doAssert false

const
  base = currentSourcePath.parentDir() / "build"

echo base

static:
  cDebug()

  gitPull("https://github.com/live-clones/gmsh", base, """
api/gmshc.h
""")

#[
cPlugin:
  import
    strutils

  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    if sym.name.startsWith("_"): # sym.kind == nskProc and 
      sym.name = sym.name.replace("_", "priv_")
]#
#[
    #if sym.kind == nskType and sym.name.contains("__"):
    #  sym.name = sym.name.replace("__", "_m_")
]#


#cIncludeDir base/"include/ode"
#cIncludeDir base/"api"
cImport(base/"api/gmshc.h",  dynlib="dynlibFile",  flags="-G__=_ -E_ -f:ast2", recurse=true) #flags="-f:ast2",