# Quick Start

```@meta
CurrentModule = SpaceIndices
```

```@setup quick_start
using SpaceIndices
SpaceIndices.Scratch.clear_scratchspaces!(SpaceIndices)
```

This quick tutorial will show how to use **SpaceIndicies.jl** to obtain the F10.7 index at
2020-06-19.

First, we need to initialize all the space indices:

```@repl quick_start
SpaceIndices.init()
```

Afterward, we can obtain the desired space index using:

```@repl quick_start
space_index(Val(:F10adj), DateTime(2020, 6, 19))
```
